# `android_libcpp_shared` — Build Hookによるローカルファイルシステム探索の実例

> 登壇資料作成用メモ
> 最終確認: 2026-09-27（pub.dev 最新は 0.3.0 / publisher: zeyus.com）
> スライド 13 Real hook code の panel 3 の一次資料。

## 概要

`android_libcpp_shared` は、Android 向け Dart / Flutter アプリに C++ runtime library である `libc++_shared.so` を含めるためのパッケージ。

特徴的なのは、`libc++_shared.so` をネットワークからダウンロードしたり、その場でコンパイルしたりするのではなく、**開発者のローカルマシンにインストールされている Android NDK を Build Hook から探索し、既存の `libc++_shared.so` を発見してアプリに bundle する**点。

```text
flutter build
    ↓
dependency の hook/build.dart が自動実行
    ↓
ローカル環境から Android NDK を探索
    ↓
NDK 内の libc++_shared.so を探索・検証
    ↓
CodeAsset としてアプリに bundle
```

## Build Hook

実際の `hook/build.dart`:

https://github.com/NexusDynamic/android_libcpp_shared/blob/main/hook/build.dart

`build.dart` では Android build の場合に `resolveLibcppShared()` を呼び、対象 architecture に対応する `libc++_shared.so` を探している。

概略:

```dart
await build(args, (input, output) async {
  if (input.config.code.targetOS != OS.android) {
    return;
  }

  final resolution =
      await resolveLibcppShared(input, logger: logger);

  final libcppSharedPath = resolution.libcppShared;

  // ...

  output.assets.code.add(
    CodeAsset(
      package: input.packageName,
      name: 'libc++_shared.so',
      file: libcppSharedPath,
      linkMode: DynamicLoadingBundled(),
    ),
  );
});
```

## ローカルファイルシステムの探索

実際の探索処理:

https://github.com/NexusDynamic/android_libcpp_shared/blob/main/lib/src/resolve_libcpp.dart

パッケージは Build Hook 実行中に、ローカルマシン上にある Android NDK の場所を複数の方法から特定する。

公式 README によると、例えば以下が探索に利用される。

- Build configuration に含まれる compiler path
- `ndk-build` が存在する `PATH`
- `ANDROID_NDK`
- `ANDROID_NDK_HOME`
- `ANDROID_NDK_LATEST_HOME`
- `ANDROID_NDK_ROOT`
- `ANDROID_HOME`
- `ANDROID_SDK_ROOT`
- `ANDROID_SDK_HOME`
- Flutter project の `local.properties`
  - `sdk.dir`
  - `ndk.dir`
- `flutter config --android-sdk`
- OS ごとの一般的な Android SDK / NDK インストール先

さらに Build Hook の output directory から親 directory を辿り、

```dart
Directory.fromUri(
  current.resolve('.dart_tool/'),
).existsSync()
```

によって Flutter/Dart project の root directory を発見する処理も実装されている。

project root を取得する目的の一つは、プロジェクトにある `local.properties` を参照すること。

## ファイルの存在・内容も確認する

候補となるパスを取得するだけではなく、

```dart
Directory(path).existsSync()
```

やファイルの読み取りを利用して、候補の `libc++_shared.so` が実際に存在し、ELF shared object であることまで確認している。

つまり Build Hook は正当な目的で、

```text
directory traversal
file existence check
file read
project file inspection
SDK / NDK discovery
```

といったローカルファイルシステム操作を実際に行っている。

## セキュリティの観点で重要なポイント

このパッケージ自体に問題があるという意味ではない。

むしろこれは、**Build Hook が正当なユースケースとしてローカルファイルシステムへアクセスする必要がある**ことを示す実例として有用。

Build Hook は dependency に含まれる Dart program であり、Dart SDK によって build process の途中で自動的に実行される。

したがって、概念的には、

```text
dependency
    ↓
hook/build.dart
    ↓
automatically executed Dart code
    ↓
developer machine
```

という関係になる。

`android_libcpp_shared` の実装を見ることで、

> Build Hook から developer machine のファイルシステムを参照できる

ことが、仮説ではなく実際の正規パッケージのユースケースとして確認できる。

これは Supply Chain Security の観点では重要。

例えば package が侵害された場合、Build Hook に入ったコードは「native library を build する」ことだけに限定されているわけではなく、通常の Dart / `dart:io` の能力を使った処理を実行できる可能性を考慮する必要がある。

## Environment Variables との違い

Dart の Build Hooks には environment variable に対する制限がある。

公式ドキュメントでは Hooks は **semi-hermetic environment** で実行され、`Platform.environment` から親 process のすべての environment variables が見えるわけではない。

許可されているものには例えば以下がある。

```text
PATH
HOME
USERPROFILE

ANDROID_HOME
ANDROID_NDK
ANDROID_NDK_HOME
ANDROID_NDK_LATEST_HOME
ANDROID_NDK_ROOT

HTTP_PROXY
HTTPS_PROXY
NO_PROXY
...
```

その他の environment variables は原則として除去される。

一方で、この制限は **environment variables に対する制限**。

`android_libcpp_shared` の実装が示しているように、Build Hook から、

```dart
Directory(...)
File(...)
existsSync()
```

などを利用してローカルファイルシステムを探索すること自体とは別の問題。

そのため、

```text
Environment variables are restricted
```

と

```text
The hook cannot access the local filesystem
```

は同義ではない。

ここは Build Hooks の security model を理解するときに重要な区別。

## 登壇での使い方

この例は、Build Hooks の利便性を説明した直後に security risk へ話をつなげる材料として使いやすい。

例えば:

```text
Build Hooks are not only for compiling code.

Here is a real package called android_libcpp_shared.

Its build hook searches the developer's local machine
to find installed Android NDKs and libc++_shared.so.

This is completely legitimate behavior.

But from a security perspective, there is an important point:

A build hook supplied by a dependency can access
the developer's local filesystem.
```

ポイントは、`android_libcpp_shared` を危険なパッケージとして扱うのではなく、

> **正当な機能を実現するために必要な能力が、そのまま攻撃面にもなり得る**

という Build Hooks / Supply Chain Security 全体の構造を示す例として使うこと。

## References

### Package

https://pub.dev/packages/android_libcpp_shared

### Repository

https://github.com/NexusDynamic/android_libcpp_shared

### `hook/build.dart`

https://github.com/NexusDynamic/android_libcpp_shared/blob/main/hook/build.dart

### NDK / `libc++_shared.so` discovery implementation

https://github.com/NexusDynamic/android_libcpp_shared/blob/main/lib/src/resolve_libcpp.dart

### Dart — Hooks

https://dart.dev/tools/hooks
