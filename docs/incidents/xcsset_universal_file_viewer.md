# `universal_file_viewer` / XCSSET 事例まとめ

> 登壇資料作成用メモ
> 最終確認: 2026-09-27
> スライド 08 Not hypothetical の 3 例目の一次資料。スライド・台本の記述はこのメモの「17. スライド向け短い説明案」「19. 事実と推測を区別するための注意」に従うこと。

## 1. 事例の概要

2026年9月、Flutter package `universal_file_viewer` の `0.1.5` に、macOS向けマルウェアファミリー **XCSSET** によって注入された不正な build hook が含まれていることを Aikido Security が報告した。

重要なのは、これは

> 「攻撃者が Flutter package を狙って悪意ある Dart コードを書いた」

という事件ではない、という点。

Aikido の解析では、

1. package maintainer の Mac が XCSSET に感染
2. XCSSET が端末上に存在する Android Gradle project / Xcode project / Git repository を探索
3. `universal_file_viewer` の `example/` 以下にある Android / iOS / macOS project が探索対象に該当
4. build script / Xcode project file がローカルで書き換えられる
5. maintainer がその変更に気づかないまま GitHub に commit/push
6. その状態で package version `0.1.5` が pub.dev に publish
7. 不正な build hook を含む package archive が pub.dev から取得可能な状態になった

という流れだった。

Aikido は、この package が意図的に狙われたものではなく、感染した端末上の build files に XCSSET が機械的に自身を注入した結果だと説明している。

## 2. なぜ `lib/` ではなく `example/` が感染したのか

`universal_file_viewer` の Dart library code (`lib/`) は clean だった。

感染していたのは以下。

```text
universal_file_viewer/
├── lib/
│   └── ...                         # clean
└── example/
    ├── android/
    │   └── app/build.gradle.kts    # infected
    ├── ios/
    │   └── Runner.xcodeproj/
    │       └── project.pbxproj     # infected
    └── macos/
        └── Runner.xcodeproj/
            └── project.pbxproj     # infected
```

これは XCSSET が Flutter package や `example/` を特別扱いしていたためではない。

XCSSET は端末上から、

- Android Gradle project
- Xcode project
- Git repository

を探索して汚染する。

Flutter package の `example/` は、実体として通常の Android / iOS / macOS project を含んでいるため、XCSSET の探索対象に偶然該当した。

したがって、

> **`example/` だから感染したのではなく、そこが Android / Xcode project だったから感染した**

と説明するのが正確。

これは「Flutter developer は pub ecosystem だけに依存しているわけではない」という点を示す具体例でもある。

```text
Flutter app / package
├── Dart / pub
├── Android / Gradle / Maven
├── iOS / Xcode / CocoaPods / SPM
├── macOS / Xcode
├── Git / Git hooks
└── CI / signing / distribution
```

## 3. package を dependency に追加するだけでは発火しない

今回の不正コードは `example/` 以下に存在していた。

そのため通常の Flutter app で、

```yaml
dependencies:
  universal_file_viewer: ...
```

として package を dependency に追加し、自分の app を build するだけでは、`universal_file_viewer/example/` は build されない。

Aikido も、

> Simply adding `universal_file_viewer` to your `pubspec.yaml` and building your own app does not trigger anything.

と明記している。

実際に危険なのは、

- repository を clone して example app を build する
- package archive を展開して example project を明示的に build する

など、感染した Android/Xcode project 自体を build するケース。

したがって今回の事例は、

```text
malicious package
↓
dependency に追加
↓
即 malware 実行
```

という典型的な package-install 型の攻撃とは異なる。

## 4. Android / Xcode build で何が起きるか

### Android

`example/android/app/build.gradle.kts` に `preBuild` hook が注入されていた。

そこから難読化された shell command が実行され、C2 server に接続する。

Aikido が確認したものでは、文字列検索を避けるため `xxd` というコマンド名自体も動的に組み立てていた。

### iOS / macOS

`project.pbxproj` に悪意ある build rule が注入されていた。

iOS では Base64、macOS では hex を利用した難読化が確認されている。

build 時に C2 server へ接続し、次段の処理を取得する。

## 5. build hook 自体が secrets を直接盗むわけではない

今回 package に含まれていた build hook は、credential theft の本体ではない。

概念的には以下の流れ。

```text
infected Android / Xcode project を build
        ↓
malicious build hook 実行
        ↓
C2 に接続
        ↓
Stage 1 / Stage 2 / Stage 3
        ↓
XCSSET core orchestrator 起動
        ↓
propagation / persistence / theft modules を実行
```

Aikido の解析では、Stage 2 で main loader を `/tmp/h` に取得し、一時的な app bundle として起動した後、10秒以内に削除する処理が確認されている。

最終的な core orchestrator が各 module を dispatch する。

### 代表的な theft module

Aikido が今回の variant で確認した対象には以下が含まれる。

- Chrome passwords / cookies / session tokens
- Safari local data
- Firefox credentials
- Telegram session data
- Notes / Reminders / Calendar data
- clipboard
- home directory 内の対象ファイル

つまり、

> **build → secrets を直接読む**

ではなく、

> **build → XCSSET infection chain を起動 → malware core → theft modules**

という構造。

## 6. XCSSET の propagation

今回特に重要な module は以下の3つ。

### `android_finder`

home directory 以下から `build.gradle` / `build.gradle.kts` を探索し、Android project に悪意ある `preBuild` hook を注入する。

### `replicator_finder`

`project.pbxproj` を探索し、Xcode project に悪意ある Run Script Build Phase 等を注入する。

### `git_finder`

端末上の `.git` directory を探索し、`.git/hooks/pre-commit` に悪意ある hook を書き込む。

## 7. Git `pre-commit` で行われること

今回の `pre-commit` hook は、

- commit 内容へ malware を直接追加する
- 自動的に `git commit` する
- 自動的に `git push` する

ための仕組みではない。

`git commit` をトリガーとして、**XCSSET の full infection chain を再実行する**。

```text
git commit
    ↓
.git/hooks/pre-commit
    ↓
XCSSET chain 再実行
    ↓
android_finder
replicator_finder
git_finder
...
    ↓
端末上の他 project も再探索・再汚染
```

その結果として別 repository の、

- `build.gradle(.kts)`
- `project.pbxproj`

などが書き換えられる可能性がある。

その後 developer 自身が通常どおり `git add` / `git commit` / `git push` すると、不正な変更が GitHub に流出する。

したがって、

> **XCSSET が GitHub に push するのではなく、XCSSET がローカルを汚染し、その後の developer の通常操作を通じて公開 repository に感染コードが出る**

という理解が重要。

## 8. GitHub に見えている感染範囲 = ローカルの感染範囲ではない

XCSSET はローカル project を直接書き換える。

そのため、ある project が感染していても、その後 developer がその project を触らず commit/push しなければ、外部からは観測できない可能性がある。

```text
XCSSET
  ↓
developer machine
  ├── Project A → infected → commit/push → GitHub から観測可能
  ├── Project B → infected → 放置        → 外部から観測困難
  └── Project C → infected → commit/push → GitHub から観測可能
```

したがって、公開 repository 上で見つかった感染 project 数が、その端末で実際に感染した project 数の全体とは限らない。

## 9. 同作者の `iweather` でも同種の痕跡

同じ作者の `iweather` repository（native iOS / SwiftUI app）でも、第三者から XCSSET とみられる build script が `project.pbxproj` に存在すると報告されている。

GitHub Issue #1 には、

- `PBXShellScriptBuildPhase`
- 難読化された shell command
- `.ru` C2 server
- `p=xcode_phase`

を含む処理が提示されている。

これは、

> 「Flutter package が狙われた」

というより、

> **「感染した Mac 上に存在する Xcode project が横断的に汚染された」**

という Aikido の説明と整合する。

なお、`iweather` に関する具体的な感染指摘は GitHub 上の第三者 Issue であり、Aikido の `universal_file_viewer` 報告とは証拠の出所を区別して扱うこと。

## 10. `dynamic_icon_changer` について

同じ作者の別 repository が公開上 clean に見える場合でも、

> ローカルでは XCSSET に書き換えられていたが、その後 commit/push されていない

という可能性自体は、XCSSET の動作モデル上は成立する。

ただし、公開された repository に痕跡がない場合、外部から感染を断定することはできない。

資料では「可能性」と「確認済み事実」を混同しないこと。

## 11. `universal_file_viewer` の version 状態

2026-09-27 時点の pub.dev:

| Version | 状態 |
|---|---|
| `0.1.5` | Retracted |
| `0.1.6` | Retracted |
| `0.1.7` | Stable |

`0.1.7` の changelog には、

> Security update: Removed unauthorized Xcode build rules and script phases from example iOS and macOS project configurations.

と記載されている。

## 12. Retracted は「削除」ではない

pub.dev の Retracted は security 専用機能ではない。

Dart 公式ドキュメントでは、

> Retraction isn't deletion.

と明記されている。

目的は、

> **公開済み version を、新しい package consumer の通常の version resolution で選ばせない**

こと。

### 既存 `pubspec.lock`

retract 前から `pubspec.lock` にその version が固定されている場合、その version を引き続き利用できる。

### 新しく retracted version を指定する場合

すでに Retracted された version を意図的に利用する場合、利用側で `dependency_overrides` に pin する必要がある。

### exact constraint

例えば新規 resolution で、

```yaml
dependencies:
  universal_file_viewer: 0.1.5
```

とした場合、`0.1.5` は retracted で新規候補にならず、`0.1.7` は exact constraint を満たさないため、通常は dependency resolution が失敗する。

一方、

```yaml
dependencies:
  universal_file_viewer: ^0.1.5
```

なら、non-retracted かつ constraint を満たす `0.1.7` が候補になり得る。

## 13. `pub unpack` との違い

`dart pub unpack` は package/version の artifact を取得して展開する用途のコマンド。

例えば、

```bash
dart pub unpack universal_file_viewer:0.1.5 --no-resolve
```

のように exact version を指定して archive を取得・調査する用途がある。

Retracted は artifact の削除ではないため、incident 後に問題 version を取得して監査できることには意味がある。

つまり、

```text
pub get / pub upgrade
    → dependency solver の対象として Retracted を避ける

pub unpack <exact-version>
    → 指定 version の archive 自体を取得して調査できる
```

という役割の違いがある。

## 14. Retracted は security incident だけに使われるものではない

Retracted は「この version は新規利用してほしくない」という一般的な release-management 機能。

非 security 理由の例:

### `url_launcher 6.2.0`

新 API の型が誤っていたため Retracted。

### `analyzer 14.2.0`

誤ったファイルを package に含めて publish したため Retracted。

### `portsip 0.2.0`

誤って `0.1.5` のコードをそのまま publish したため Retracted。

したがって、

> **Retracted は「理由を確認すべき signal」ではあるが、それ自体は security indicator ではない**

と整理できる。

## 15. commit 前の `git diff` は検知に役立つか

今回のように tracked file が書き換わるケースでは有効。

例えば Flutter/Dart の修正しかしていないはずなのに、

```text
M android/app/build.gradle.kts
M ios/Runner.xcodeproj/project.pbxproj
```

が発生していれば強い違和感になる。

特に、

- shell command
- `ProcessBuilder`
- `Process.run`
- `curl`
- `base64`
- `xxd`
- 外部 URL
- 不自然な難読化

などの追加はレビュー対象になりやすい。

ただし `.git/hooks/pre-commit` は Git の tracked file ではないため `git diff` には出ない。

さらに、感染済み `pre-commit` は `git commit` 実行時に動くため、

```text
git diff を確認
    ↓
異常なし
    ↓
git commit
    ↓
pre-commit が XCSSET を再実行
    ↓
その後別 project が汚染される
```

という順序も成立する。

したがって `git diff` review は有効な防御レイヤーだが、endpoint compromise 全体を防ぐものではない。

## 16. この事例から得られる主な教訓

### 16.1 Flutter developer は pub だけを信頼しているわけではない

Flutter app は Dart/pub に加え、

- Gradle
- Maven
- Xcode
- CocoaPods / Swift Package Manager
- Git hooks
- CI tools
- signing / distribution tools

など複数の ecosystem に依存する。

### 16.2 package の `lib/` だけ見ても十分とは限らない

今回の `lib/` は clean だった。

問題は native build files に存在した。

特に注意すべき対象:

- `build.gradle`
- `build.gradle.kts`
- `project.pbxproj`
- build hooks
- shell scripts
- Gradle plugins
- Xcode Build Phases / Build Rules
- Git hooks
- CI workflows

### 16.3 developer workstation 自体が supply chain の一部

今回の感染方向は、

```text
よく想像する方向:

malicious package
    ↓
developer machine
```

だけではない。

```text
今回:

compromised developer machine
    ↓
local projects
    ↓
GitHub
    ↓
pub.dev
    ↓
other developers
```

という逆向きから supply chain に乗る経路だった。

### 16.4 build script は「設定」ではなく executable code

Gradle や Xcode の build configuration は、単なる設定ファイルとして扱わず、

> developer machine 上で任意コード実行につながり得るもの

として見る必要がある。

### 16.5 「ツールを入れれば解決」ではない

Aikido のような malware / dependency scanner や endpoint protection は有効な defense layer になり得る。

一方で、

- unknown / zero-day malware
- developer workstation compromise
- Git repository 外の `.git/hooks`
- credential scope
- security tool 自体の supply-chain risk

など、ツール導入だけでは閉じない問題も残る。

したがって、

> **A mitigation reduces risk. It does not make the risk disappear.**

と考える方が適切。

## 17. スライド向け短い説明案

### 1文版

> XCSSET に感染した maintainer の Mac 上で Flutter package の example に含まれる Android/Xcode project が自動的に汚染され、その変更が通常の commit/publish を通じて GitHub と pub.dev に流出した。

### 強調したいポイント

> **The Flutter package itself was not the original target.
> The developer environment was compromised first.**

### `example/` の説明

> **It was not infected because it was an example.
> It was infected because it was an Android/Xcode project.**

### supply chain の方向

```text
Compromised developer machine
        ↓
Local Android / Xcode / Git projects
        ↓
GitHub
        ↓
pub.dev
        ↓
Other developers
```

## 18. 参考URL

### Incident / primary references

- Aikido Security: Compromised Flutter package on pub.dev contains XCSSET malware
  https://www.aikido.dev/blog/compromised-flutter-package-on-pub-dev-contains-xcsset-malware

- GitHub Issue #19: `[URGENT] Malicious code in repository`
  https://github.com/Shonu72/universal_file_viewer/issues/19

- `universal_file_viewer` GitHub repository
  https://github.com/Shonu72/universal_file_viewer

- `universal_file_viewer` pub.dev versions
  https://pub.dev/packages/universal_file_viewer/versions

- `universal_file_viewer` changelog
  https://pub.dev/packages/universal_file_viewer/changelog

### Same-author related repository

- `iweather` repository
  https://github.com/Shonu72/iweather

- `iweather` Issue #1: XCSSET report
  https://github.com/Shonu72/iweather/issues/1

### XCSSET background

- Unit 42: XCSSET v40 / The Xcode Assassin Returns
  https://unit42.paloaltonetworks.com/xcsset-v40-malware-analysis/

- Microsoft Security Blog: New XCSSET malware adds new obfuscation, persistence techniques to infect Xcode projects
  https://www.microsoft.com/en-us/security/blog/2025/03/11/new-xcsset-malware-adds-new-obfuscation-persistence-techniques-to-infect-xcode-projects/

### Dart / pub behavior

- Dart: Publishing packages / Retract a package version
  https://dart.dev/tools/pub/publishing

- Dart: `dart pub unpack`
  https://dart.dev/tools/pub/cmd/pub-unpack

### Other Retracted examples

- `url_launcher` changelog (`6.2.0` Retracted)
  https://pub.dev/packages/url_launcher/changelog

- `analyzer` changelog (`14.2.0` Retracted)
  https://pub.dev/packages/analyzer/changelog

- `portsip` changelog (`0.2.0` Retracted)
  https://pub.dev/packages/portsip/changelog

---

## 19. 事実と推測を区別するための注意

### 公開情報から確認できること

- Aikido は `universal_file_viewer 0.1.5` から XCSSET を検出した
- Aikido は maintainer machine が感染していたと報告している
- `lib/` は clean だった
- 感染ファイルは `example/` 内の Android / iOS / macOS project に存在した
- Android / Xcode / Git project を探索する propagation module が確認されている
- `.git/hooks/pre-commit` は commit ごとに full chain を再起動する
- `0.1.5` と `0.1.6` は Retracted、`0.1.7` は Stable
- `iweather` の公開 repository には第三者から XCSSET とみられる build script が報告されている

### 推測として扱うべきこと

- 同じ作者の公開上 clean な他 project もローカルでは感染していた可能性
- どの操作が maintainer machine の最初の感染入口だったか
- ローカルで実際に何個の project が感染していたか
- 公開されなかった project に感染が残っていたか

これらは XCSSET の動作モデル上はあり得るが、公開情報だけから断定しない。
