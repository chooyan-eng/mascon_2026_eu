# Slides — Source of Truth

スライドに表示される文言と speaker notes の正本。`lib/slides/` はこのファイルに従って生成・修正する。

運用ルール:
- 文言を変えたいときはこのファイルを編集し、「slides.md に合わせてコードを更新して」と依頼する。
- 見出し `## NN. Title (route)` の route は `FlutterDeckSlideConfiguration.route` と 1 対 1 対応。並び順・追加・削除もここで管理する。
- `type` は flutter_deck のテンプレート（title / bigFact / quote / split / blank）。`steps` は段階表示数で、`(step N)` は N 段階目に現れる要素。
- 台本: 話す内容の全文は `docs/script.md`（20 分版）。スライドの文言や順序を変えたら台本も合わせる。
- 同期チェック: `python3 tool/check_slides_sync.py` で、このファイルとコードの文言・route・番号・steps・並び順・notes のずれを検出できる。コード側の speaker notes には `verify:` / `todo:` の内容が英語で追記される（それ以外は `notes:` と同文）。
- 引用符 `"…"` 内がスライドに出る文言。`notes:` は speaker notes（presenter view のみ）。`todo:` / `verify:` は制作メモで、`verify:` は発表前に一次情報で確認するまでスライドで断定しない。
- コードとの対応: route `/about-me` は `lib/slides/about_me.dart`。ファイル名に番号は付けない（並べ替えに強くするため）。並び順は `lib/main.dart` の `slides:` と `lib/slides/slides.dart`。
- 全体の流れ: 概要（Dart / Flutter パッケージのみ）→ build hooks の深掘り（hooks の話はここに集約）→ 他の surface も同じ → iOS / Android もある → 対策と現実 → takeaways。
- backlog: 文字による説明が多いので、内容が固まったら「Flutter アプリであること」を活かした操作可能なページに置き換えて文字量を減らす（スライド 04 が先行例）。
- デザイン: dark theme 固定、16:9 Full HD、強調色 amber。footer に slide number と `@chooyan_i18n`（title / thank-you は footer なし）。
- speaker info: name "Tsuyoshi Chujo" / description "Flutter developer, package author, from Japan" / handle "@chooyan_i18n"。画像は未配置。

---

## Part 1 — Opening (0–4 min)

## 01. Title (/title)
type: title, steps: 1, footer: hidden
- title: "Security Risks of Packages in Mobile App Development"
- subtitle: "masCon / next.app devCon Berlin 2026"
- speaker info widget
- notes: Hello everyone. My name is Tsuyoshi, and I came here from Japan.

## 02. About me (/about-me)
type: blank, steps: 2
- header: "About me"
- bullet: "Flutter developer from Japan"
- bullet: "I build and publish mobile applications"
- bullet: "I develop and maintain Dart / Flutter packages"
- bullet: "Recently digging into software supply chain security"
- message box (step 2): "Not a security expert." / "Someone who lives in the Flutter ecosystem every day, as a package user and as a package author." / "That is the viewpoint of this talk."
- notes: Quick self introduction with the bullets. Then: I listed a few things, but what it means is this. I am not a security expert. I take part in the Flutter ecosystem every day, as a package user and as a package author. Today I talk from that viewpoint.

## 03. 606 (/the-number)
type: bigFact, steps: 2
- title: "606"
- subtitle (step 1): "Can anyone guess what this number means?"
- subtitle (step 2): "Packages my production Flutter app depends on: Dart, iOS and Android, direct and transitive."
- notes: Ask the audience. Measured with my dependency inspector: 283 Dart, 15 iOS, 308 Android. 86 of them are direct. The next slide shows the same data as a graph.
- todo: 数字は `assets/dependency_graph.json` の計測値（スライド 04 step 2 の件数と同じ）。データを更新したらここと 33 も合わせる。

## 04. Dependency graph (/dependency-graph)
type: blank (interactive graph), steps: 2
- header: "Most of this code, I never chose directly."
- graph: 実アプリの依存グラフを操作可能な形で表示（ドラッグ = pan、scroll / pinch = zoom、click = 選択、double-click = reset）。文言ではなく `assets/dependency_graph.json` のデータから描画する。
- count panel (step 1): "<N>" + "direct dependencies" — root と直接依存のみ表示
- count panel (step 2): "<N>" + "dependencies, direct and transitive" — 全ノード表示
- caption (step 2): "Direct dependencies are only the top of the graph."
- legend: "Dart <n>" / "iOS <n>" / "Android <n>" / "Filled = direct   ·   Outline = transitive"
- selection panel (選択時): "<name>  <version>" / "depends on <n>" / "used by <n>"
- notes: This is the real dependency graph of my app, not an illustration. Step 1 is what I wrote in pubspec.yaml; step 2 is everything my build pulls in. Click a package: amber = what it depends on, blue = who depends on it. Drag to pan, scroll / pinch to zoom, double-click to reset.
- todo: データ更新は `dart run tool/export_dependency_graph.dart <dependency_inspector の snapshot.json> --root-label "My app"`。数値はデータから自動算出される。root の表示名は `--root-label` で変更する。

## 05. Supply chain risk (/supply-chain-risk)
type: blank (tree diagram), steps: 3
- header: "The risk of supply chain attacks"
- tree (step 1): "My app" > "Package A" > ["Package D", "Package E"]; "My app" > "Package B"; "My app" > "Package C" > ["Package F", "Package G"]
- step 2: "Package F" が赤くなり、下にラベル "compromised" が出る
- step 3: "Package F" → "Package C" → "My app" の経路が赤くなる
- caption (step 3): "I never chose Package F. My app ships it anyway."
- notes: Our apps depend on a lot of packages and libraries. That is not bad; it is why we can ship at all. But on a chain this complex, one compromised package somewhere deep is enough to reach my app. This is a supply chain attack. The risk keeps growing, and that is what I want to talk about today.

## Part 2 — Overview, Dart / Flutter packages only (4–14 min)

ねらい: サプライチェーン攻撃とは何か、attack surface の把握、どうチェックし、どう対策を選ぶかを一通り外観する。ここでは Dart / Flutter パッケージの話に限定し、build hooks も surface の 1 つとして並べるだけにする。iOS / Android には触れない。

## 06. Software supply chain (/supply-chain)
type: blank, steps: 2
- header: "Software supply chain is more than packages"
- left list (step 1): "Compiler", "Build tool", "CI", "IDE extension", "Package registry", "Container image", "Binary artifact", "External build tool"
- right big text (step 2): "Today, I mainly focus on packages and libraries."
- notes: By the way, a supply chain is more than packages: CI, IDE extensions, build tools and so on. Today I focus on packages and libraries. Now let's look at what a real compromise looks like.

## 07. Real-world incident (/real-incident)
type: blank, steps: 1
- header: "This is not hypothetical"
- body: "[TODO: 1–2 real package compromise incidents]"
- notes: Show one or two incidents briefly. Goal is to show it really happens, not to tell the story.
- todo: 採用事例は未確定（npm / PyPI から、attack path が明確なもの）。

## 08. Attack path A (/attack-path-a)
type: blank, steps: 5 (chain, one node per step)
- header: "Attack path A: a malicious package release"
- chain: "Legitimate dependency" → "Maintainer / account / release process compromised" → "Malicious version published" → "Dependency resolution / update" → "Malicious code reaches your environment"
- notes: Generalize the incident we just saw. This is the typical story. The important part is where it goes from here.

## 09. Two impact paths (/two-impact-paths)
type: split, steps: 2
- left title (step 1): "Developer / CI compromise"
- left chain: "Malicious package" → "Build-time / development-time execution" → "Developer machine / CI" → "Credential theft, source modification, artifact tampering, exfiltration"
- right title (step 2): "End-user compromise"
- right chain: "Malicious runtime code" → "Compiled / bundled into the app" → "APK / IPA" → "End-user device"
- notes: Even if nothing bad happens on the developer machine, malicious runtime code can still reach the app.

## 10. Exists ≠ executes (/exists-vs-executes)
type: blank, steps: 2
- line (step 1): "Malicious code exists on my machine"
- line (step 1): "≠"
- line (step 1): "Malicious code executes on my machine"
- question (step 2): "When can a package actually execute code?"
- notes: Existing in the pub cache and actually running are different things.

## 11. Attack surfaces (/attack-surfaces)
type: blank, steps: 1
- header: "One Dart package, many attack surfaces"
- item: "Library code" — tag "runs inside the app"
- item: "Build hooks / link hooks" — tag "run during the build"
- item: "Analyzer plugins" — tag "run inside the analysis server"
- item: "build_runner / builders" — tag "run during code generation"
- item: "DevTools extensions" — tag "run inside DevTools"
- footer line: "Same language, same package. Not the same attack surface."
- notes: Even a single Dart package has several places where its code can run. Runtime code ends up on the end-user device; the others run on my machine or CI. No ranking, and no surface is singled out yet.

## 12. Surface triggers (/surface-triggers)
type: blank, steps: 1
- header: "Each surface has its own trigger and its own opt-in"
- column "Hooks": "hook/build.dart, hook/link.dart", "Part of the normal build", "Prepare native assets"
- column "Analyzer plugins": "Runs inside the analysis server / IDE", "Not auto-run just because a dependency exists", "Explicit configuration", "Can run continuously"
- column "build_runner": "Builders are Dart code", "Runs when the project runs build_runner", "Code generation is the normal use"
- column "DevTools extensions": "Shipped inside a package", "User enables it (trust boundary)", "Precompiled Flutter Web output"
- notes: Overview only. What matters: when does it run, and did I opt in?
- verify: 各 mechanism の trigger / opt-in の記述。

## 13. Source, integrity, provenance (/source-integrity-provenance)
type: blank, steps: 2
- header: "Three different questions"
- card (step 1): "Source review" / "Is this source behavior acceptable?"
- card (step 1): "Artifact integrity" / "Are these the exact bytes I expected?"
- card (step 1): "Build provenance" / "Where did these bytes come from?"
- chain (step 2): "Version locking" ≠ "Artifact verification" ≠ "Publisher verification" ≠ "Build provenance" ≠ "Source-code security review"
- notes: Provenance tells you where the bytes came from, not whether the source is safe.
- verify: provenance / attestation の対応状況と説明量。

## 14. Attack path → mitigation (/attack-path-to-mitigation)
type: blank, steps: 3 (table, one row per step)
- header: "Which attack path does this mitigation actually stop?"
- table columns: "Attack path" / "Mitigation" / "Does not stop"
- row 1: "Unexpected package update" / "Lockfile, controlled updates, dependency diff review" / "A locked version that is itself malicious"
- row 2: "CI code execution" / "Least privilege, minimal secrets, reduced token permissions, isolated workflows" / "Code that still runs inside the allowed boundary"
- row 3: "Developer machine execution" / "Disposable environment, container / VM, credential and filesystem separation" / "Everything inside the sandbox boundary"
- notes: Not a checklist. Each control maps to an attack path and has something it does not stop. Overview level only; two more rows appear after the deep dive (slide 31).
- verify: "Does not stop" 列は outline 36–37 章からの叩き台。

## Part 3 — Deep dive: build hooks (14–26 min)

ねらい: 「概要を説明するのは簡単だが、1 つの仕組みを深掘りすると考えるべきことがこれだけ出てくる」を体感させる。Build hooks の説明はすべてこの Part に集約する。調査の裏付け（docs / SDK source / PoC を見たこと）は各スライドで口頭で差し込む。最後に「他の surface も同じ」と一般化する。

## 15. Overview is the easy part (/deep-dive-intro)
type: quote, steps: 1
- quote: "The overview is the easy part. Let me pick one surface and go one level deeper."
- attribution: "Build hooks"
- notes: Everything so far fits in ten minutes. Explaining the overview is easy. Now I pick one surface and actually go deep: build hooks. Watch how many new questions appear once we look at one real mechanism.

## 16. Dart hooks (/dart-hooks)
type: blank, steps: 1
- header: "Dart hooks"
- card: "Build hook" / "hook/build.dart" / "Today's focus"
- card: "Link hook" / "hook/link.dart" / "Mentioned briefly"
- notes: Dart hooks include build hooks and link hooks. Today I mainly focus on build hooks.
- verify: version / lifecycle / build と link の役割差。

## 17. Legitimate purpose (/legitimate-purpose)
type: blank, steps: 1
- header: "Build hooks exist for good reasons"
- bullet: "Native code compilation"
- bullet: "Native asset preparation"
- bullet: "Prebuilt native asset download"
- bullet: "Linking information preparation"
- bullet: "Platform-specific build integration"
- footer line: "Download and process execution are not, by themselves, suspicious in a build hook."
- notes: Do not start from "build hooks are dangerous." This matters later for detection.

## 18. Execution model (/execution-model)
type: blank, steps: 1
- header: "A hook is a Dart program. What do I need to know?"
- question: "When does it fire?", "Direct vs transitive packages?", "Working directory?", "Visible environment variables?"
- question: "Filesystem access?", "Network access?", "Can it start a child process?", "What does the child process inherit?"
- footer line: "[NEEDS VERIFICATION] To be confirmed against official docs, SDK source and a PoC."
- notes: Not unlimited arbitrary execution; there are constraints. But calling native tools is legitimate, so it is a developer / CI execution surface.
- verify: 発火条件、transitive hook、working dir、environment、filesystem / network、child process 継承。確認後 footer line を実測結果に置き換える。

## 19. Follow one hook (/follow-one-hook)
type: blank, steps: 8 (chain, one node per step)
- header: "Follow one hook all the way down"
- chain: "Package" → "hook/build.dart" → "imports / API calls" → "Process execution?" → "Network download?" → "Downloaded artifact" → "Checksum / signature verification?" → "Executable / library / generated output — where does it go next?"
- notes: Center of the talk. Show how I investigated, not only the result.
- todo: 実際に追う package と観察結果を決める。

## 20. Demo (/demo)
type: blank, steps: 1
- header: "Demo"
- body: "[TODO: prerecorded terminal capture / screenshots]"
- item: "Find hook/build.dart in the pub cache", "Observe hook execution in the console", "Child process start"
- item: "Visible environment", "External artifact download", "URL / checksum validation in the source"
- notes: Prefer prerecorded capture over live demo.
- todo: live か prerecorded か未決定。

## 21. External artifact problem (/external-artifact)
type: split, steps: 2
- left title (step 1): "What I check for a downloaded artifact"
- left list: "Is the URL versioned?", "Is it immutable?", "Is it redirected?", "Is a digest (SHA-256) verified?", "Is a signature verified?", "Is there provenance?", "Is the artifact executed?", "Is it bundled into the app as a runtime library?"
- right (step 2): "pubspec.lock" → "Dart package version / content"
- right (step 2): "Artifact fetched by the hook" → "A different trust boundary"
- right caption (step 2): "The lockfile does not necessarily pin the second one."
- notes: The lockfile pins the Dart package, not the artifact the hook fetches.
- verify: native asset download 時の integrity verification の標準挙動。

## 22. The package didn't change (/package-unchanged)
type: blank, steps: 3
- header: "Attack path B: the package didn't change"
- row "Yesterday" (step 1): "Same package" → "Same hook" → "Good artifact"
- row "Today" (step 2): "Same package" → "Same hook" → "Malicious artifact"
- side note (step 2): "Same version. Same source. Same pub content hash."
- question (step 3): "Can this dependency change its behavior without changing itself?"
- notes: Key finding. The build input changed; the package did not.

## 23. Existing trusted path (/existing-trusted-path)
type: quote, steps: 1
- quote: "The hardest malicious update may not add a new capability. It may abuse a capability you already trusted."
- attribution: "Don't only look for new execution paths. Look at what changed behind existing trusted paths."
- notes: hook + curl + Process.run added in a new version stands out. If hook → download → run already exists, the diff can be zero.

## 24. Baseline (/baseline)
type: blank, steps: 2
- header: "Before looking for malicious behavior, learn the normal baseline"
- table row (step 1): "Analyzer plugin suddenly downloads a native binary" / "Unusual"
- table row (step 1): "Native build hook downloads a native library" / "Plausible legitimate use"
- table row (step 1): "Gradle native plugin starts a compiler process" / "Ordinary"
- table row (step 1): "Unrelated formatter reads ~/.ssh" / "Unusual"
- message (step 2): "The more powerful behavior is legitimate for a feature, the weaker that behavior becomes as a detection signal."
- notes: A dangerous API search is not enough. Understand the platform first.

## 25. Same for every surface (/every-surface)
type: quote, steps: 1
- quote: "That was one surface. Every other one deserves the same: understand the mechanism, understand the attack path, then choose the defense."
- attribution: "Analyzer plugins · build_runner · DevTools extensions · library code"
- notes: That was one surface out of five. I read the docs, the SDK source and real packages, and built small experiments to say this much. Analyzer plugins, build_runner and DevTools extensions deserve the same treatment. (「How I investigated」のスライドは廃止。調査の裏付けは深掘りパートの各所で口頭で差し込む。)

## Part 4 — And then there is native (26–31 min)

ねらい: 「Dart / Flutter パッケージだけでもこれだけあるのに、iOS / Android のネイティブライブラリも同じように考える必要がある」とつなげる。

## 26. Beyond Dart (/beyond-dart)
type: blank, steps: 5 (chain, one node per step)
- header: "And that was only Dart"
- chain: "Flutter application" → "Dart package" → "Flutter plugin" → "Android / iOS dependency" → "Native artifact / source"
- notes: All of that was Dart / Flutter packages only. A Flutter app also pulls in iOS and Android native libraries, and the same thinking applies there.

## 27. What does my build consume? (/what-build-consumes)
type: quote, steps: 1
- quote: "Don't audit what looks like your dependency. Audit what your build actually consumes."
- attribution: "Reading the GitHub repository is not enough."
- notes: What to check differs per ecosystem.

## 28. Source vs binary (/source-vs-binary)
type: blank, steps: 2
- header: "Source distribution vs binary distribution"
- table columns: "Ecosystem / mechanism" / "Typical form" / "Build input"
- table rows (step 1): "Dart / pub" / "source package" / "source"; "CocoaPods source_files" / "source" / "source"; "SwiftPM .target" / "source" / "source"
- table rows (step 1): "Maven / Gradle JAR / AAR" / "precompiled" / "binary artifact"; "CocoaPods vendored framework" / "precompiled" / "framework / XCFramework"; "SwiftPM .binaryTarget" / "precompiled" / "binary artifact"; "DevTools extension" / "precompiled web output" / "compiled extension artifact"
- question (step 2): "Is this the source that produced the binary I actually consume?"
- notes: Source distribution: inspect and compile are close. Binary distribution: another question remains.

## 29. Android / iOS (/android-ios)
type: split, steps: 2
- left title (step 1): "Android"
- left chain: "Flutter plugin" → "Gradle dependency" → "JAR / AAR from Maven" → "precompiled artifact"
- left note: "The role matters: implementation dependency, Gradle plugin, KSP / kapt, custom lint"
- right title (step 2): "iOS"
- right line: "CocoaPods: source_files → compiled by you / vendored_frameworks → precompiled"
- right line: "CocoaPods build-time hooks: prepare_command, script_phase"
- right line: "SwiftPM: .target → source / .binaryTarget → precompiled / .plugin → tooling"
- notes: No deep dive. Both ecosystems have source and binary forms and build-time execution mechanisms.

## 30. Which dependency graph? (/which-dependency-graph)
type: blank, steps: 3
- line (step 1): "\"We locked our dependencies.\""
- list (step 2): "Dart" → "pubspec.lock"; "Android" → "Gradle / Maven dependency resolution"; "iOS CocoaPods" → "Podfile.lock"; "iOS SwiftPM" → "Package.resolved"; "Build hook external downloads" → "yet another artifact resolution path"
- question (step 3): "Which dependency graph?"
- notes: Pinned plugin version + dynamic Android dependency inside it can change the final AAR. A hook URL is not pinned by pubspec.lock at all.
- verify: native dependency の locking / verification の細部。

## Part 5 — Mitigation and reality (31–38 min)

ねらい: 深掘りと native で増えた attack path を対策表に足し、万能策はないこと、全部はできない現実、AI の位置付けへつなぐ。

## 31. Mitigation revisited (/mitigation-revisited)
type: blank, steps: 3
- header: "Going deeper added two more attack paths"
- table: slide 14 と同じ 3 行を最初から表示し、以下の 2 行を強調色で追加する
- row 4 (step 2): "External artifact substitution" / "Immutable versioned URLs, digest pinning, checksum / signature verification, provenance" / "A malicious source that was signed correctly"
- row 5 (step 3): "Prebuilt binary risk" / "Artifact inspection, checksum / signature, provenance, reproducible builds, trusted publisher" / "A compromised upstream build"
- notes: Same table as before. The deep dive and the native layer added two rows. These rows only exist because we understood the mechanism.
- verify: "Does not stop" 列の表現。

## 32. No magic solution (/no-magic)
type: blank, steps: 1
- header: "There is no single \"supply chain protection enabled\" checkbox."
- bullet: "A lockfile limits unexpected updates, not malicious locked content"
- bullet: "A pub content hash protects the archive, not what the hook fetches later"
- bullet: "Source review works, but not for every dependency every time"
- bullet: "Scanners help, but do not reliably catch malicious logic"
- bullet: "Sandboxes have boundaries"
- bullet: "Provenance shows origin, not safety of the source"
- bullet: "Binary analysis is possible, but costs more than source review"
- notes: Every tool has a boundary. Knowing the boundary is the point.

## 33. Assurance (/assurance)
type: blank, steps: 3
- line (step 1, struck through): "Is this package safe?"
- line (step 1): "How much assurance do I need for this dependency?"
- list label (step 2): "Not the same assurance for"
- list (step 2): "Pure utility package", "Package with a build hook", "Package downloading an external executable", "Package handling authentication / payment", "Closed-source prebuilt binary"
- principle (step 3): "Review effort should be proportional to risk."
- notes: Replace "is it safe" with "how much assurance do I need."

## 34. All 606? (/all-of-them)
type: blank, steps: 2
- question (step 1): "Can we do this for all 606 dependencies?"
- chain (step 2): "One dependency" → "Obsessively investigate it" → "Learn which questions matter" → "Realize this doesn't scale" → "Use tooling / AI to apply those questions broadly" → "A human chooses where deeper assurance is needed"
- notes: Honest answer: no. Prioritize high-risk mechanisms, enumerate surfaces mechanically, classify source / binary / download, keep the risk decision human.

## 35. AI (/ai)
type: split, steps: 2
- left title (step 1): "Not a security decision maker. An investigation amplifier."
- left list: "Explain unfamiliar code", "Help read SDK source", "Trace call paths", "Narrow suspicious areas", "Build a minimal reproduction", "Design experiments", "List hypotheses"
- right title (step 2): "Verify"
- right chain: "AI answer" → "Official documentation" → "Source code" → "Experiment" → "Observation"
- right message: "The valuable part isn't the AI. It's the questions."
- notes: Do not ask AI "is this package safe." AI reduced the cost of going one level deeper; verify every answer.

## Part 6 — Takeaways (38–40 min)

## 36. Takeaways (/takeaways)
type: blank, steps: 3
- item 1 (step 1): "Understand your platform" / "If you don't know the mechanism, you don't know what you trust."
- item 2 (step 2): "Understand the attack path" / "Where it enters, where it executes, who is affected."
- item 3 (step 3): "Choose mitigations based on that understanding" / "Pick the control that stops a concrete attack path."
- notes: Don't start with the mitigation. Start by understanding how the system works.

## 37. Go one level deeper (/go-one-level-deeper)
type: blank, steps: 1
- big text: "Go one level deeper."
- line: "Pick one part of your own development environment."
- line: "Read the documentation. Look at the implementation. Create a small experiment. Use AI to help you explore it."
- line: "And ask yourself: \"If this dependency was compromised, what would actually happen?\""
- notes: Closing call to action.

## 38. Thank you (/thank-you)
type: title, steps: 1, footer: hidden
- title: "Thank you!"
- subtitle: "Tsuyoshi Chujo · @chooyan_i18n"
- notes: Q&A if the event format has it.
