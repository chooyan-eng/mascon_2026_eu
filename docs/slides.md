# Slides — Source of Truth

スライドに表示される文言と speaker notes の正本。`lib/slides/` はこのファイルに従って生成・修正する。

運用ルール:
- 文言を変えたいときはこのファイルを編集し、「slides.md に合わせてコードを更新して」と依頼する。
- 見出し `## NN. Title (route)` の route は `FlutterDeckSlideConfiguration.route` と 1 対 1 対応。並び順・追加・削除もここで管理する。
- ページ構成・デザイン・演出は `docs/design_handoff_mascon_deck/README.md`（Claude Design ハンドオフ）を正とする。文言（具体的な記述内容）は本ファイルを正とする。
- `steps` は flutter_deck の step 数 = **click 段階**の数。ハンドオフの `…`（auto 段階）は step 内の遅延付き出現アニメ（`Enter` / `GrowLine` / `PathDraw` の `delayMs`）で実装する。
- 台本: 話す内容の全文は `docs/script.md`（20 分版）。スライドの文言や順序を変えたら台本も合わせる。
- 同期チェック: `python3 tool/check_slides_sync.py` で、このファイルとコードの文言・route・番号・steps・並び順・notes のずれを検出できる。コード側の speaker notes には `verify:` / `todo:` の内容が英語で追記される（それ以外は `notes:` と同文）。
- 引用符 `"…"` 内がスライドに出る文言。`notes:` は speaker notes（presenter view のみ）。`todo:` / `verify:` は制作メモで、`verify:` は発表前に一次情報で確認するまでスライドで断定しない。
- コードとの対応: route `/about-me` は `lib/slides/about_me.dart`。ファイル名に番号は付けない（並べ替えに強くするため）。並び順は `lib/main.dart` の `slides:` と `lib/slides/slides.dart`。
- 非表示ページ: 旧構成のページは削除せず、`lib/main.dart` に登録しないことで非表示にしている。一覧は末尾の「非表示ページ」セクション（`###` 見出しなので同期チェック対象外）。
- デザイン: 大きい文字はハンドオフ比 0.7 倍で実装（例: h2 88px→62px、タイトル 130px→91px）。背景 `#1C1A19`、単一アクセント金 `#E1AD66`、線で描く（塗りのカードは使わない）、Figtree 300 + Martian Mono。16:9 Full HD。footer は各スライドが自前描画（左 `@tsuyoshi_chujo` / 右ページ番号、title / thank-you はなし）。詳細はハンドオフ README。
- speaker info: name "Tsuyoshi Chujo" / description "Flutter developer · package author" / handle `@tsuyoshi_chujo`。写真は `assets/me_photo.jpg`（About me の円形枠と presenter view で使用）。
- フォント: `google_fonts` パッケージ経由（初回はネットワークが必要。発表前に一度起動してキャッシュしておく）。

---

## Part 1 — Opening

## 01. Title (/title)
type: custom, steps: 1, footer: none
- kicker: "masCon / next.app devCon · Berlin 2026"（等幅・金）
- title 2 行: "Security Risks of Packages\nin Mobile App Development"（91px Light）
- 金のヘアラインが左から伸びる（auto）
- 名前行 (auto): "Tsuyoshi Chujo" / "Flutter developer · package author" / `@tsuyoshi_chujo`（等幅・金）
- 右上: ライト/ダークモード切替トグル（月/太陽アイコン 22px + ピル型トグル 56×28、薄色・控えめ。クリックでデッキ全体の配色がダーク ⇔ ライトに切替。ライトの配色は docs/design_handoff_mascon_deck_light/README.md 準拠）
- notes: Hello everyone. My name is Tsuyoshi, and I came here from Japan.

## 02. About me (/about-me)
type: custom, steps: 3
- kicker: "About me"
- 上段 (auto): 丸型の写真（`assets/me_photo.jpg`、金 1px 枠）+ "Tsuyoshi Chujo"（56px）/ "Flutter developer from Japan"（32px 薄）
- 中段 (auto): 2 カラム。左 "Package user"（67px）/ "Cardcraft, and more"。右 "Package author"（67px）/ "crop_your_image", "animated_to", and more（パッケージ名は等幅）
- 下段 (step 2): "Security expert"（84px イタリック 薄）
- step 3: 金の取り消し線が左から引かれる（"I'm not a security expert." は口頭）
- notes: Quick self introduction: package user, package author. Then, with the strikethrough: I am not a security expert. I take part in the Flutter ecosystem every day, as a package user and as a package author. Today I talk from that viewpoint.

## 03. 606 (/the-number)
type: custom, steps: 2
- 数字 606（308px 金）が 0 からカウントアップ（Can anyone guess の問いかけは口頭のみ）
- subtitle (step 2): "Packages my production Flutter app depends on."（45px イタリック）
- 比率バー (step 2, auto): "Dart" 283 / "iOS" 15 / "Android" 308。ラベルは 3 つとも線分の真下。iOS 区間はラベル（iOS 15）の文字幅程度に固定（比率は正確でなくて良い）
- notes: The number counts up from 0. Ask the audience: can anyone guess what this number means? Measured with my dependency inspector: 283 Dart, 15 iOS, 308 Android. 86 of them are direct. The next slide shows the same data as a graph. Q&A prep: the Android count includes the Gradle build toolchain (about 90 artifacts) and fine-grained Maven artifacts (Firebase alone is 25); iOS counts SwiftPM packages only (15, mostly Firebase and Maps) — Apple ships the platform frameworks inside the OS, so they never appear as dependencies.
- todo: 数字は `assets/dependency_graph.json` の計測値（スライド 04・27 と同じ）。データを更新したらここも合わせる。

## 04. Dependency graph (/dependency-graph)
type: custom (interactive graph), steps: 2
- graph: 実アプリの依存グラフを操作可能な形で表示（ドラッグ = pan、scroll / pinch = zoom、click = 選択、double-click = reset）。`assets/dependency_graph.json` のデータから描画する
- 左上の大数字（98px 金）はカウントアップ。step 1: "direct dependencies" / step 2: "dependencies, direct and transitive"
- legend: Dart / iOS / Android の件数（ラベルは graph_view.dart 側） + "Filled = direct   ·   Outline = transitive"
- selection panel (選択時): パッケージ名 + "depends on" n / "used by" n
- notes: This is the real dependency graph of my app, not an illustration. Step 1 is what I wrote in pubspec.yaml; step 2 is everything my build pulls in. The number counts up as the transitive dependencies appear. Click a package: gold = what it depends on, white = who depends on it. Drag to pan, scroll / pinch to zoom, double-click to reset. Dependencies are not bad: they are why we can build this efficiently and ship this fast.
- todo: データ更新は `dart run tool/export_dependency_graph.dart <dependency_inspector の snapshot.json> --root-label "My app"`。数値はデータから自動算出される。

## Part 2 — Supply chain & incidents

## 05. Supply chain (/supply-chain-risk)
type: custom (横型ツリー), steps: 2
- kicker: "Software supply chain"。右上に左向き矢印 + `upstream`（イタリック）
- 横型ツリー (auto): 左端 "My app" ← "Package A" / "Package B" / "Package C" ← "Package D" / "Package E" / "Package F" / "Package G"。右端には名前のない小枠が右へフェードして「まだ続く」
- step 2: "Package F" が金に点灯（2px 枠）+ 下に "compromised"（イタリック金）。auto で金の線が F → C → My app と右から左へ伸び、C と My app も順に点灯
- 文字キャプションなし（I never chose Package F は口頭）
- notes: Our apps depend on a lot of packages and libraries. But on a chain this complex, one compromised package somewhere deep is enough to reach my app. I never chose Package F, but my app ships it anyway. This is a supply chain attack. The risk keeps growing, and that is what I want to talk about today.

## 06. Impact examples (/impact-examples)
type: custom (2 カラム), steps: 2
- kicker: "Supply chain", h2: "Impact examples"
- 左 (step 1): "DEVELOPERS / CI"（等幅・金）+ bullets: "Credential theft" / "Private source code leaks" / "Malicious versions published with stolen credentials"
- 右 (step 2): "END USERS"（等幅・金）+ "Malicious code ships inside the app." / "The damage is anything the app can do on the device — too varied to enumerate."（薄）
- notes: Two kinds of victims. Developer / CI side: credential theft, private source code leaks, and malicious versions published with the stolen credentials — the chain continues. End-user side: the damage is too varied to enumerate. Malicious code ships inside the app, so it is anything the app can do on the device. Both belong in our threat model. Now let's look at what a real compromise looks like.

## 07. Real-world incidents (/real-incident)
type: custom (3 カラム), steps: 1
- kicker: "Supply chain", h2: "Real-world incidents"（This is not hypothetical は口頭）
- 3 カラムは同時表示（auto で左から順に出現、click 段階なし）
- column 1: "npm · 2026" / "Red Hat packages" / "A malicious preinstall hook was added to legitimate packages" / "npm install alone executed it on dev machines and CI" / link "access.redhat.com"
- column 2: "PyPI · 2026" / "LiteLLM / Telnyx" / "Publish credentials compromised; a version with a credential stealer published" / "Stolen tokens were used to attack further packages" / link "blog.pypi.org"
- column 3: "pub.dev · 2026" / "universal_file_viewer"（長い名前は FittedBox で 1 行に縮小） / "XCSSET on the maintainer's Mac infected the Android / Xcode projects in example/" / "Normal commit and publish carried it to GitHub and pub.dev — the package was not the target" / link "aikido.dev"
- notes: Three incidents in 2026, three ecosystems, three execution mechanisms: npm preinstall lifecycle script, PyPI package code, and infected Xcode / Gradle build files inside a Flutter package. The pattern is always the same: compromised package, normal developer operation, code execution on dev / CI, credential theft and further compromise. The third one also shows the reverse direction: a compromised developer machine entering the supply chain. The point: this is not an npm-specific problem — it reached our own ecosystem. No deep low-level knowledge was needed to follow these: the incidents alone show what was compromised, how the code got executed, and what damage followed.
- 参考 (npm): https://access.redhat.com/security/vulnerabilities/RHSB-2026-006 / https://www.microsoft.com/en-us/security/blog/2026/06/02/preinstall-persistence-inside-red-hat-npm-miasma-credential-stealing-campaign/
- 参考 (PyPI): https://blog.pypi.org/posts/2026-04-02-incident-report-litellm-telnyx-supply-chain-attack/
- 参考 (pub.dev): 詳細メモ docs/incidents/xcsset_universal_file_viewer.md / https://www.aikido.dev/blog/compromised-flutter-package-on-pub-dev-contains-xcsset-malware / https://github.com/Shonu72/universal_file_viewer/issues/19
- verify: 事実と推測の区別は docs/incidents/xcsset_universal_file_viewer.md の §19 に従う（スライドの記述は Aikido 報告で確認済みの範囲のみ）。

## 08. More than packages (/supply-chain)
type: custom (横型レーン), steps: 2
- kicker: "Software supply chain"。右上に同じ upstream 矢印
- "My app" に右から 8 本のレーンが流れ込む (auto): "Version control", "Build tool", "CI", "IDE extension", "Packages", "Package registry", "Container image", "Binary artifact"。右端はフェード
- 参考: レーンの項目は OWASP Software Supply Chain Security Cheat Sheet の構成要素と整合（https://cheatsheetseries.owasp.org/cheatsheets/Software_Supply_Chain_Security_Cheat_Sheet.html。2026-10-01 確認。Container image のみ同チートシートでは scanner への言及として登場）
- step 2: "Packages" のレーンと枠だけ金に残り、他 7 本は沈む（"Today: packages." は口頭）
- 出典表示 (左下): "Source: cheatsheetseries.owasp.org/cheatsheets/Software_Supply_Chain_Security_Cheat_Sheet.html"（等幅 18px 薄）
- notes: By the way, a supply chain is more than packages: CI, IDE extensions, build tools and so on. The list is based on the OWASP Software Supply Chain Security Cheat Sheet. Today I focus on packages and libraries.

## 09. Exists ≠ executes (/exists-vs-executes)
type: custom, steps: 2
- 小ラベル: "MALICIOUS CODE"（24px 大文字）
- 大キーワード (auto): "exists"（154px）の後、遅れて "≠"（金）+ "executes"（154px イタリック金）が出現
- question (step 2): "When can a package actually execute code?"（48px）
- notes: Even when malicious code gets onto the disk, it does not automatically run. A compromised package can sit in my pub cache and do nothing: code that exists is one thing; code that executes is another — that difference is exactly where the defense lives. Attackers did not run arbitrary code in some incomprehensible way: in the incidents, they abused an execution mechanism the ecosystem itself provides — a lifecycle script, a build file, package code. So knowing those mechanisms is where the defense starts. So the key question is: when can a package actually execute code?

## Part 3 — Execution surfaces

## 10. Execution surfaces (/execution-surfaces)
type: custom (表), steps: 2
- kicker: "Execution surfaces", h2: "When does package code actually run?"
- 表 3 列: "MECHANISM" / "WHEN" / "EXPLICIT OPT-IN?"。行は上から順に出現 (auto)
- row: "Library code" / "at runtime" / "—" "you call it"
- row: "Build hooks / link hooks" / "during the build" / "No" "part of the normal build"
- row: "Analyzer plugins" / "during analysis" / "Yes" "explicit configuration"
- row: "build_runner / builders"（等幅） / "during code generation" / "No" "one run executes all builders in the graph"
- row: "DevTools extensions" / "while debugging" / "Yes" "user enables it"
- step 2: Build hooks の行が金に点灯・少し拡大、他 4 行は沈む
- notes: Even a single Dart package has several places where its code can run. What matters for each one: when does it run, and did I opt in? Runtime code ends up on the end-user device; the others run on my machine or CI. build_runner is also No: you run the command for one package, but builders from all packages run together — unlike analyzer plugins (per-package configuration) or DevTools extensions (explicit enable). Build hooks are part of the normal build, with no explicit opt-in. That is the surface we will dig into.
- verify: 各 mechanism の trigger / opt-in の記述（発火条件・設定の要否）。

## Part 4 — Deep dive: build hooks

## 11. Divider: Build hooks (/deep-dive-intro)
type: custom (divider), steps: 1
- 中央に "Build hooks"（112px）、下に "deep dive"（45px イタリック薄, auto）。装飾なし
- notes: Not broad coverage: pick one mechanism — build hooks — dig deep, and share what I learned on the way. Ask the audience to keep one thing in mind: the process of digging deeper is transferable to any mechanism, in any ecosystem — not a talk just for Flutter developers.

## 12. What build hooks do (/legitimate-purpose)
type: custom, steps: 2
- kicker: "Build hooks", h2: "What build hooks do"（概要と活用例。ビルド時に処理を差し込むこと自体は Gradle / CocoaPods / SwiftPM にもある通常の仕組み、というニュートラルな位置づけ）
- bullets (auto): "Native code compilation" / "Native asset preparation" / "Prebuilt native asset download" / "Linking information preparation" / "Platform-specific build integration"
- 下部にビルドパイプラインの帯 (auto): ヘアラインの上に "$ flutter build"（等幅）、段 "compile" … "link" … "app"
- step 2: "package_a" / "package_b" の "hook/build.dart"（金 2px 枠・等幅）が上から降りてきて compile と link の間に並ぶ
- アニメーション: 帯の出現アニメーション完了後（表示から約 1.9 秒後）に、金のスイープ（グラデーションの尾を引く）が線上を左から右へ繰り返し流れ始める（約 4.2 秒周期、終端で小休止）。compile / link / app は到達時に金に点灯・わずかに拡大し、通過後にゆっくり減衰する。step 2 以降は hook/build.dart の 2 箱も同様に点灯する
- notes: Overview and typical uses. Injecting work into the build is an ordinary mechanism: Gradle, CocoaPods and SwiftPM have the same idea. Benefit: Flutter builds for many platforms; instead of bundling everything up front, a hook prepares just the right resources for the target platform at build time. Hooks are part of the normal flutter build: they run between fetching packages and linking the app. Download and process execution are not, by themselves, suspicious here. This matters later for detection.

## 13. Real hook code (/real-hook-code)
type: custom (切り替えパネル), steps: 3
- kicker: "Build hooks · in the wild", h2: "What real hooks do"
- 3 パネルをクロスフェード切り替え。各パネル: 番号（"01 / 03" 等）/ やっていること（50px）/ 補足 / メタ行（等幅）+ 右に "hook/build.dart" のコードブロック（実 hook からの抜粋）
- panel 1: "Download a prebuilt binary" / "powersync downloads its prebuilt SQLite core from GitHub releases at build time — and verifies a SHA-256 digest" / "powersync 2.4.0 ↗"（コードは packages/powersync/hook/build.dart の Uri.https 部分の抜粋。`await client.get(uri)` の呼び出し部分のみ金で強調（戻り値の受け取り部分は強調しない））
- panel 2 (step 2): "Run a native compiler" / "objective_c compiles its bundled Objective-C sources with clang during the build" / "objective_c 9.6.0 ↗"（コードは pkgs/objective_c/hook/build.dart の _compile の抜粋。`await Process.run(_compiler, args)` の呼び出し部分のみ金で強調）
- panel 3 (step 3): "Search the developer machine" / "android_libcpp_shared discovers a locally installed Android NDK and bundles its libc++_shared.so — no download, no compile" / "android_libcpp_shared 0.3.0 ↗"（コードは hook/build.dart の resolveLibcppShared 部分の抜粋。`await resolveLibcppShared(...)` の呼び出し部分のみ金で強調。詳細は docs/examples/android_libcpp_shared_build_hook.md）
- 操作: コードブロックをクリックすると、その hook の GitHub 上の build.dart ページを WebView モーダルで表示（金 1px 枠。ESC / 外側クリックで閉じる。要ネットワーク）。コード下にヒント "tap to open on github.com"（等幅 20px 薄）。WebView は macOS / iOS / Android のみ（web / Windows ではタップ無効・ヒント非表示）
- notes: Walk through what real hooks do, one pattern at a time. The code is excerpted from the real hooks. powersync downloads its prebuilt SQLite core from GitHub releases and verifies a SHA-256 digest — a hook doing it right. objective_c, published by dart.dev, compiles its bundled Objective-C sources with clang through a child process. android_libcpp_shared searches the local machine for an installed Android NDK (env vars, local.properties, common install locations) and bundles its libc++_shared.so. Completely legitimate — and it shows a hook can read the developer machine.
- 参考 (panel 1): https://github.com/powersync-ja/powersync.dart/blob/main/packages/powersync/hook/build.dart
- 参考 (panel 2): https://github.com/dart-lang/native/blob/main/pkgs/objective_c/hook/build.dart
- 参考 (panel 3): https://github.com/NexusDynamic/android_libcpp_shared/blob/main/hook/build.dart / 詳細メモ docs/examples/android_libcpp_shared_build_hook.md
- todo: バージョン（powersync 2.4.0 / objective_c 9.6.0 / android_libcpp_shared 0.3.0）は 2026-09-27 時点の pub.dev 最新。発表前に再確認する。

## 14. Audit & versions (/versions-change)
type: custom (2 段), steps: 2
- kicker: "Build hooks · auditing", h2: "Audit the hook — and watch the version"
- 上段 (step 1): ラベル "AUDIT"（等幅・金）+ "some_package\n1.4.2" + 右に "hook/build.dart"（等幅） / "read the source · looks fine"（イタリック薄）
- 下段 (step 2): ラベル "NEW VERSION"（等幅・金）+ "some_package\n1.5.0"（金枠・金文字）+ 右に "hook/build.dart"（等幅金） / "changed · runs on your next build"
- 注意行 (step 2, auto): "pubspec.lock"（等幅金）+ " decides which version your next build runs."（30px 薄、1 行）
- notes: Bridge to the audit viewpoint: a hook is normal package code, so I can read it — say I did and it looked fine. But that check is valid for one version only: a new version can ship or change a hook, and it runs on the next build. A typical supply chain attack arrives exactly like this — as a malicious update (callback to 07). The lockfile decides which version that is. The version you resolved is the version you build with.

## 15. Package unchanged (/package-unchanged)
type: custom, steps: 2
- kicker: "Nothing in the package changed"
- 2 行の同一チェーン: "Yesterday" / "Today"（48px イタリック）— "package 1.4.2" — "hook/build.dart" — "tool.zip"
- step 2: Today 行の "tool.zip" だけ金枠になり、"replaced upstream"（金）へクロスフェード
- question (step 2, auto): "Can this dependency change its behavior without changing itself?"（42px イタリック）
- notes: Key finding. Same package, same hook, same version, same pub content hash. But the artifact the hook fetches was replaced upstream: the build input changed; the package did not.

## 16. Trust boundary (/external-artifact)
type: custom, steps: 2
- kicker: "Build hooks · trust boundary", h2: "Same version. Same bytes?"
- 5 ノードの横チェーン (auto, 順に出現): "pub package" — "hook/build.dart" — "external URL" — "artifact" — "run · bundle"。後半 3 つは金
- step 2: 前半 3 ノード下に括弧 "pubspec.lock"（灰・等幅）、後半 3 ノード下に括弧 "a different trust boundary"（金 2px）
- チップ列 (step 2, auto): "check" + "versioned URL" / "immutable" / "no redirect" / "SHA-256 digest" / "signature" / "provenance" / "executed?" / "bundled into the app?"
- notes: The lockfile pins the Dart package, not the artifact the hook fetches. Everything after the external URL is a different trust boundary. For a downloaded artifact I check: versioned URL, immutable, no redirect, SHA-256 digest, signature, provenance, is it executed, is it bundled into the app.
- verify: native asset download 時の integrity verification の標準挙動。

## Part 5 — Beyond Dart

## 17. Provenance (/what-build-consumes)
type: custom, steps: 2
- question: "Is the source on GitHub\nwhat my build actually uses?"（50px 2 行）
- step 2: "No."（140px 金）
- step 2 (auto): "Audit what your build actually consumes."（40px）+ "provenance"（等幅 32px 金）
- notes: Reading the GitHub repository is not enough. Don't audit what looks like your dependency. Audit what your build actually consumes. What to check differs per ecosystem.

## 18. Inspect the packages (/inspect-packages)
type: custom, steps: 2
- kicker: "Inspect", h2: "Get the exact packages your build runs"
- 左 (auto): "~/.pub-cache"（等幅） / "Hosted packages your build resolved are already on disk"
- 右 (auto): "dart pub unpack"（等幅） / "Fetches any package version into a local directory for inspection" / 例 "$ dart pub unpack some_package"（等幅・薄）
- message (step 2): "The exact set of packages that will run is always available to read."（金）
- notes: In Flutter's case you can read everything: hosted packages your build resolved are already in the pub cache. If a version is not in your cache, dart pub unpack fetches it into a local directory. So the exact set of packages that will run is always available to read. The artifact a hook fetches is the exception we saw earlier.

## 19. Deep dive recap (/deep-dive-recap)
type: custom (3 項目), steps: 1
- kicker: "Build hooks · recap", h2: "What one deep dive made visible"
- 番号（等幅 50px 金）+ 見出し（48px）+ 補足（30px 薄）が順に出る (auto)（28 Takeaways と同じ構成）
- item 1: "How its code gets executed" / "Part of a normal build — no opt-in, no prompt."
- item 2: "Which attack surfaces it opens" / "Network, child processes, the filesystem — and the artifact behind a URL."
- item 3: "How to audit it" / "Read the resolved source, re-check every version, chase what the build consumes."
- notes: Pause and collect. Digging into one mechanism made three things visible: how its code gets executed, which attack surfaces it opens, and how to audit it. None of this was visible from the package page — it came from looking one level deeper.

## 20. Divider: Zoom out (/zoom-out)
type: custom (divider), steps: 1
- 中央に "Beyond build hooks"（112px）、下に "widen the view"（45px イタリック薄, auto）。装飾なし（11 と同じ divider 構成）
- notes: From here, widen the view again: the same questions apply to the other surfaces, and beyond Dart.

## 21. Same questions (/every-surface)
type: custom (2 列表), steps: 1
- kicker: "Beyond build hooks", h2: "Ask the same questions elsewhere"
- 行 (auto, 順に): "Analyzer plugins" / "build_runner / builders"（等幅） / "DevTools extensions"
- 各行の右に問いのチップ 4 つ: "When does it run?" / "Explicit opt-in?" / "What does it fetch or run?" / "What does the build consume?"
- notes: That was one surface. Every other one deserves the same treatment: understand the mechanism, understand the attack path, then choose the defense. I read the docs, the SDK source and real packages, and built small experiments to say this much. Analyzer plugins, build_runner and DevTools extensions deserve the same.

## 22. Beyond Dart (/beyond-dart)
type: custom (縦 5 層), steps: 1
- kicker: "Beyond Dart", h2: "A Flutter app depends on more than Dart"
- 縦 5 層 (auto, 上から): "Flutter app" / "Dart packages"（右注 "pub"） / "Flutter plugins"（"Android / iOS code inside"） / "Gradle · CocoaPods · SwiftPM"（金、"other package managers"） / "JAR / AAR · frameworks · binaries"（金、"often precompiled"）
- notes: All of that was Dart / Flutter packages only. A Flutter app also pulls in Android and iOS native libraries through Gradle, CocoaPods and SwiftPM — often as precompiled artifacts — and the same thinking applies there.

## 23. Source vs binary (/source-vs-binary)
type: custom (表), steps: 2
- kicker: "Provenance", h2: "Source distribution vs binary distribution"
- 表 3 列: "ECOSYSTEM / MECHANISM" / "TYPICAL FORM" / "BUILD INPUT"。Build input が binary の行は金文字
- row: "Dart / pub" / "source package" / "source"
- row: "CocoaPods source_files" / "source" / "source"
- row: "SwiftPM .target" / "source" / "source"
- row: "Maven / Gradle JAR / AAR" / "precompiled" / "binary artifact"
- row: "CocoaPods vendored framework" / "precompiled" / "framework / XCFramework"
- row: "SwiftPM .binaryTarget" / "precompiled" / "binary artifact"
- row: "DevTools extension" / "precompiled web output" / "compiled extension artifact"
- question (step 2): "Is this the source that produced the binary I actually consume?"（金）
- notes: Source distribution: inspect and compile are close. Binary distribution: another question remains — is this the source that produced the binary I actually consume?
- verify: 各エコシステムの配布形態・build input の記述。

## Part 6 — Mitigation & close

## 24. Mitigation: cooldown (/mitigation-cooldown)
type: custom, steps: 2
- kicker: "Mitigations · example 01", h2: "Cooldown — wait before you update"
- statement (step 1): "Adopt a new version only after it has been public for a while."（40px）+ "e.g. Dependabot cooldown · Renovate minimumReleaseAge"（等幅・薄）
- row COVERS (step 1, auto): "Many compromised releases are detected and pulled within days — a cooldown skips exactly that window"
- row DOES NOT COVER (step 2, 金): "Malware that stays unnoticed longer than your cooldown — and it does not protect whoever updates first"
- row TRADE-OFF (step 2, auto): "Legitimate fixes, including security patches, also arrive late"
- notes: Good news: there are things you can do without knowing every low-level detail — two concrete mitigations, both easy to adopt. First example: cooldown. Adopt a new version only after it has been public for a while; Dependabot and Renovate support this natively. Many compromised releases are detected and pulled within days — remember, universal_file_viewer was retracted. A cooldown skips exactly that window. It does not cover malware that stays unnoticed longer, and it does not protect whoever updates first. Trade-off: legitimate fixes, including security patches, also arrive late.
- verify: Dependabot の cooldown / Renovate の minimumReleaseAge の設定名・挙動を一次情報で確認する。

## 25. Mitigation: lockfile (/mitigation-lockfile)
type: custom, steps: 2
- kicker: "Mitigations · example 02", h2: "Respect the lockfile"
- statement (step 1): "Build from exactly what pubspec.lock records — in CI too."（40px）+ "$ dart pub get --enforce-lockfile"（等幅・薄）
- row COVERS (step 1, auto): "No unintended version enters the build — every update becomes an explicit, reviewable diff"
- row DOES NOT COVER (step 2, 金): "A locked version that is already malicious — and what the lockfile does not pin, like the artifact a hook downloads"
- row TRADE-OFF (step 2, auto): "Updates need deliberate maintenance — falling behind accumulates unpatched issues"
- notes: Second example: respect the lockfile, in CI too — dart pub get --enforce-lockfile. No unintended version enters the build; every update becomes an explicit, reviewable diff. It does not cover a locked version that is already malicious, or what the lockfile does not pin — like the artifact a hook downloads, the boundary we saw earlier. Trade-off: updates need deliberate maintenance; falling behind accumulates unpatched issues.

## 26. No single checkbox (/no-magic)
type: custom (表), steps: 1
- kicker: "Mitigations", h2: "No single “supply chain protection” checkbox"
- 表 3 列: "CONTROL" / "COVERS" / "DOES NOT COVER"（3 列目は金）。行は順に出現 (auto)
- row: "Lockfile" / "unexpected updates" / "malicious locked content"
- row: "Pub content hash" / "the package archive" / "what the hook fetches later"
- row: "Source review" / "source behavior" / "every dependency, every time"
- row: "Scanners" / "known bad patterns" / "malicious logic, reliably"
- row: "Sandboxes" / "what crosses the boundary" / "everything inside the boundary"
- row: "Provenance" / "where the bytes came from" / "safety of the source"
- row: "Binary analysis" / "the artifact itself" / "costs — far more than source review"
- notes: There is no single "supply chain protection enabled" checkbox. Every tool has a boundary. Knowing the boundary is the point.

## 27. 606 again (/all-of-them)
type: custom, steps: 2
- 背景: スライド 04 と同じ依存グラフ（全ノード表示・操作不可・opacity 0.3）をテキストの後ろに敷く
- 中央に 606（252px 金）+ "Can we do this for all 606 dependencies?"（45px, auto）
- step 2: "No. Understand the mechanisms, then prioritize."（48px）
- step 2 (auto): "AI makes going one level deeper much cheaper — the questions are still yours."（30px 薄イタリック）
- notes: Honest answer: no. Prioritize high-risk mechanisms, enumerate surfaces mechanically, classify source / binary / download, keep the risk decision human. AI is an investigation amplifier, not a security decision maker: it makes going one level deeper much cheaper, but the questions — and the risk decision — are still yours.

## 28. Takeaways (/takeaways)
type: custom, steps: 1
- 番号（等幅 50px 金）+ 見出し（48px）+ 補足（30px 薄）が順に出る (auto)
- item 1: "Pick one thing" / "One mechanism you are curious about — in any ecosystem."
- item 2: "Go one level deeper" / "Understand how it works and where the attack path is."
- item 3: "Share what you learn" / "A post, a talk, an issue, a tool — the whole community gets stronger."
- 締め (auto): "Let's dig deeper together."（40px 金イタリック）
- notes: We went deep today; no developer can investigate every dependency this deeply, and we don't all need to become security specialists. Pick one mechanism you are curious about, go one level deeper — like we did with build hooks — and share what you learn: a post, a talk, an issue, a tool. Together we raise the defense of the whole community. Close with: Let's dig deeper together.

## 29. Thank you (/thank-you)
type: custom, steps: 1, footer: none
- "Thank you."（112px）/ 金のヘアライン（auto）/ "Tsuyoshi Chujo" + `@tsuyoshi_chujo`（等幅金）+ 右端に "Let's dig deeper together."（36px イタリック薄、28 の締めの一言のエコー）
- notes: Q&A if the event format has it.

---

## 非表示ページ

旧構成（38 枚時代）のページ。ファイルは `lib/slides/` に残しているが、`lib/main.dart` に登録していないため投影されない（`###` 見出しのため同期チェック対象外）。復活させる場合は main.dart / slides.dart に追加し、`## NN.` 見出しに戻す。

### 非表示: Attack path A (/attack-path-a) — attack_path_a.dart
### 非表示: Two impact paths (/two-impact-paths) — two_impact_paths.dart
### 非表示: Attack surfaces (/attack-surfaces) — attack_surfaces.dart（10 Execution surfaces に統合）
### 非表示: Surface triggers (/surface-triggers) — surface_triggers.dart（10 Execution surfaces に統合）
### 非表示: Source, integrity, provenance (/source-integrity-provenance) — source_integrity_provenance.dart
### 非表示: Attack path → mitigation (/attack-path-to-mitigation) — attack_path_to_mitigation.dart
### 非表示: Dart hooks (/dart-hooks) — dart_hooks.dart
### 非表示: What can a hook do? (/execution-model) — execution_model.dart（2026-09-27 に非表示化。Q&A 形式・答えは TBD のままだった）
### 非表示: Mitigation examples (/mitigation-examples) — mitigation_examples.dart（プレースホルダー。24 cooldown / 25 lockfile の 2 枚に置き換え）
### 非表示: Follow one hook (/follow-one-hook) — follow_one_hook.dart（13 Real hook code が後継）
### 非表示: Demo (/demo) — demo.dart（13 Real hook code が後継）
### 非表示: Existing trusted path (/existing-trusted-path) — existing_trusted_path.dart
### 非表示: Baseline (/baseline) — baseline.dart
### 非表示: Android / iOS (/android-ios) — android_ios.dart
### 非表示: Which dependency graph? (/which-dependency-graph) — which_dependency_graph.dart
### 非表示: Mitigation revisited (/mitigation-revisited) — mitigation_revisited.dart
### 非表示: Assurance (/assurance) — assurance.dart
### 非表示: AI (/ai) — ai.dart（27 に要点を統合）
### 非表示: Go one level deeper (/go-one-level-deeper) — go_one_level_deeper.dart（28 に要点を統合）
### 非表示: Go deeper together (/go-deeper-together) — go_deeper_together.dart（2026-10-07 に 28 Takeaways へ統合）
