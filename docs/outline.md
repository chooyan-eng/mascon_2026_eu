# Flutter Security Talk - Slide Handoff (Build Hooks Focus)

## 1. このファイルの目的

このファイルは、`flutter_deck` を使ってカンファレンス登壇用スライドを制作するための引き継ぎ資料です。

元の発表テーマはそのまま維持する。

**Security Risks of Packages in Mobile App Development**

ただし、40分枠で技術的な深さとストーリーの一貫性を優先するため、Dart / Flutter の複数の任意コード実行経路を同じ深さで扱うのではなく、

**Dart / Flutter build hooks を主な深掘り対象にする。**

analyzer plugins、build_runner、DevTools extensions、Android / iOS の build-time execution mechanism は、

- 他にも execution surface が存在することを示す
- build hooks の特徴を比較する
- Flutter dependency が native ecosystem まで広がることを示す

ための一覧・比較材料として扱う。

発表内容はまだ完全には確定していない。

特に以下は今後も official documentation / SDK source / PoC で確認する。

- build hook の正確な発火条件
- build / link hook の役割差
- transitive dependency の hook の扱い
- hook process の filesystem / network / environment 制約
- child process に引き継がれる制約
- native asset download 時の integrity verification の実態
- 実際の supply chain incident の採用事例
- mitigation の具体例と優先順位
- provenance / attestation の説明量
- live demo / prerecorded demo の有無

未検証事項を勝手に補完して断定しないこと。

---

# 2. 発表タイトル

## 正式タイトル

**Security Risks of Packages in Mobile App Development**

masCon / next.app devCon Berlin 2026 での発表タイトル。

変更予定なし。

---

# 3. 登壇者の立場

登壇者は以下の立場。

- 日本から参加する Flutter developer
- Flutter 開発歴が長い
- mobile application を開発・公開している
- Dart / Flutter package も開発・公開している
- package ecosystem の consumer であると同時に package author でもある
- security expert ではない
- 最近 software supply chain / mobile application security を重点的に調査している

冒頭で以下を明示する。

> I’m not a security expert. I’m a Flutter developer.

これは弱みとしてではなく、本発表の視点を示すため。

この発表は、

**security expert が developer に security rule を教える発表**

ではなく、

**application developer 自身が、自分の使っている platform を深掘りし、attack path を理解していく発表**

にする。

---

# 4. 発表の主目的

単純に、

- 危険な package を紹介する
- security checklist を紹介する
- package を使うなと警告する
- build hooks は危険だと煽る

という発表にはしない。

最終的に伝えたいのは、

1. 自分が使っている platform / ecosystem の仕組みを理解する
2. compromise がどの経路で自分まで届くのかを理解する
3. その attack path をもとに mitigation を選ぶ

という考え方。

---

# 5. Core principle

発表全体で最も重要な考え方。

> **Don't start with the mitigation.  
> Start by understanding how the system works.**

そして、

> **Understand the platform.  
> Understand the attack path.  
> Then choose the mitigation.**

この軸から外れない。

---

# 6. 今回 build hooks にフォーカスする理由

Dart ecosystem には third-party Dart code が development / build 中に実行され得る経路が複数ある。

例：

- Dart hooks
  - build hooks
  - link hooks
- analyzer plugins
- build_runner / builders
- DevTools extensions

ただし、全部を同じ深さで扱うと40分では表面的になる。

そのため本編では build hooks を深掘りする。

理由：

- normal development / build workflow に近い場所で発火する
- native asset の compile / download が正規用途に含まれる
- external process execution と組み合わせられる
- external artifact trust の問題まで自然に広げられる
- source review だけでは分からない attack path を説明しやすい
- 「仕組みを理解しないと mitigation を正しく評価できない」という本発表の主張を一つの具体例で示せる

他mechanismは、

> There are other execution surfaces, but today I want to go one level deeper into one of them.

程度の導入で一覧表示する。

---

# 7. 発表の最終メッセージ

## Understand your platform

理解する対象：

- dependency はどこから来るのか
- version はどう決まるのか
- package contents はどこに置かれるのか
- third-party code はいつ実行されるのか
- どの process / environment で動くのか
- 何にアクセスできるのか
- build 中に外部から何を取得するのか
- native dependency はどう組み込まれるのか

## Understand the attack path

Dependency が compromise されたとして、

- malicious code がどう自分の環境に入るか
- package 自体が変わらなくても挙動が変わる経路はあるか
- いつ code execution が発生するか
- developer machine / CI / end-user device のどこが影響を受けるか
- attacker が何を取得・変更できる可能性があるか

を理解する。

## Choose mitigations based on that understanding

一般論として recommendation を適用するのではなく、

> **Which attack path does this mitigation actually stop?**

を考える。

---

# 8. 現実のアプリ開発との関係

必ず、

**全dependencyを人力で完全監査することは現実的ではない**

という前提を置く。

実際の Flutter application では direct / transitive を合わせて数百 dependency が存在しうる。

Developer には、

- feature development
- bug fixing
- maintenance
- client work
- CI
- release
- store submission
- compatibility
- performance

など他の責務もある。

したがって目標は、

**everything を audit することではない。**

重要な attack surface を理解し、

**限られた時間を効果の高い場所に使うこと。**

---

# 9. Developer と Security specialist の視点差

対立構造にはしない。

Developer は通常、

- functionality
- developer experience
- API design
- compatibility
- performance
- deadline
- maintenance cost

なども同時に最適化する。

Security specialist は、

- attack surface
- trust boundary
- abuse case
- privilege
- failure mode
- residual risk

をより強く見る。

同じ機能を見ても、最初に出る問いが違う。

例：build hooks

Developer:

> What can I build with this?

Security:

> What changed in the trust model?

メッセージ候補：

> **We look at the same technology through different optimization lenses.**

> **Neither question is wrong. We need both.**

---

# 10. AI の位置付け

AI は最後のメッセージの一部にする。

ただし、

> AI に「この package は安全ですか？」と聞けばよい

という話にはしない。

AI は、

**security decision maker**

ではなく、

**investigation assistant / investigation amplifier**

として扱う。

利用例：

- unfamiliar code の説明
- SDK source の調査補助
- call path の追跡
- suspicious area の絞り込み
- minimal reproduction の作成
- experiment 設計
- documentation の理解補助
- hypothesis の列挙
- attack path の整理

重要なのは、

```text
AI answer
  ↓
official documentation
  ↓
source code
  ↓
experiment
  ↓
observation
```

のように検証すること。

候補メッセージ：

> **AI has significantly reduced the cost of going one level deeper.**

> **The valuable part isn’t the AI. It’s the questions.**

---

# 11. 発表全体のストーリー

```text
大量の dependencies
        ↓
software supply chain
        ↓
dependency compromise がなぜ問題なのか
        ↓
malicious code が自分まで届く経路
        ↓
重要な問い：
"When can a package actually execute code?"
        ↓
Dart に複数の execution surfaces がある
        ↓
今日は build hooks を深掘りする
        ↓
How does a build hook actually work?
        ↓
What can legitimate hooks do?
        ↓
external process / external download
        ↓
package が変わらなくても behavior が変わり得る
        ↓
existing trusted execution path の悪用
        ↓
Developer / CI compromise と End-user compromise
        ↓
Flutter は Android / iOS native artifact まで広がる
        ↓
What does my build actually consume?
        ↓
source / binary / integrity / provenance
        ↓
"We locked our dependencies." — Which dependency graph?
        ↓
attack path に対応した mitigation
        ↓
全部は監査できない現実
        ↓
platform を理解して優先順位を付ける
        ↓
AI も使って one level deeper
```

---

# 12. Opening

簡潔に自己紹介。

例：

```text
Hello everyone.

My name is Tsuyoshi, and I came here from Japan.

I’m a Flutter developer.
I develop mobile applications, and I also develop and maintain Dart and Flutter packages.

But I’m not a security expert.

Today I’d like to talk about software supply chain risk
from the perspective of an application and package developer.
```

---

# 13. Hook: "345"

序盤のフックとして数字を出す。

## Slide

**345**

問いかけ：

> Can anyone guess what this number means?

答え：

自分が業務で開発している Flutter application が direct / transitive に依存している Dart package 数。

※発表前に数え方を再確認する。

明示するもの：

- dependencies
- dev_dependencies
- SDK packages を含むか
- transitive dependencies を含むか

---

# 14. Dependency graph

伝えたいこと：

- direct dependency は一部
- package は別packageに依存する
- dependency graph は複雑
- 自分が直接選んでいない code も多い

ただし、

**dependencies are bad**

という話にはしない。

> Packages are one of the reasons we can build applications efficiently.

便利さとriskの両方がある。

---

# 15. Software supply chain

Software supply chain はpackageだけではない。

例：

- compiler
- build tool
- CI
- IDE extension
- package registry
- container image
- binary artifact
- external build tool

ただし本発表ではscopeを絞る。

> Today, I mainly focus on packages and libraries.

---

# 16. Typical supply chain attack paths

単一路線にしない。

## Path A: malicious package release

```text
Legitimate dependency
        ↓
Maintainer / account / release process compromised
        ↓
Malicious version published
        ↓
Dependency resolution / update
        ↓
Malicious code reaches environment
```

ここから二方向に分岐する。

### A1. Developer / CI compromise

```text
Malicious package
        ↓
Build-time / development-time execution
        ↓
Developer machine / CI
        ↓
credential theft / source modification / artifact tampering / exfiltration
```

### A2. End-user compromise

```text
Malicious runtime code
        ↓
Compiled / bundled into app
        ↓
APK / IPA
        ↓
End-user device
```

重要：

**developer machine 上で悪さをしなくても、malicious runtime code が app に入る attack path はある。**

---

# 17. Attack path B: package が変わらなくても behavior が変わる

Build hooks を深掘りしたことで見つかる重要な論点。

正規packageがすでに外部artifactを取得する場合：

```text
Legitimate package
        ↓
hook/build.dart
        ↓
https://vendor.example/tool.zip
        ↓
external artifact / hosting compromised
        ↓
malicious content
```

この場合、

- package version は同じ
- package source は同じ
- pub package content hash も同じ

でも、build behavior / build input が変わる可能性がある。

強い問い：

> **Can this dependency change its behavior without changing itself?**

この点は発表の重要な発見として残す。

---

# 18. Malicious code exists ≠ malicious code executes

必ず区別する。

**malicious code が machine に存在すること**

と、

**その code が実際に execution されること**

は別。

ここから、

> **When can a package actually execute code?**

につなげる。

---

# 19. Dart execution surfaces overview

一覧のみ見せる。

```text
Dart / Flutter package ecosystem

- Build hooks        ← MAIN FOCUS
- Link hooks         ← mention briefly
- Analyzer plugins   ← overview only
- build_runner       ← overview only
- DevTools extension ← overview only
```

目的：

**Same language execution capability does not mean the same attack surface.**

比較観点：

- trigger
- explicit opt-in
- normal build integration
- execution timing
- environment restrictions
- process execution
- network access
- artifact form

危険度ランキングにはしない。

---

# 20. Dart hooks: terminology

上位概念は **Dart hooks**。

現時点では、

- build hook
- link hook

が存在する。

本発表では主に **build hook** を扱う。

link hook は、

> Dart hooks include build hooks and link hooks. Today I mainly focus on build hooks.

程度の説明でよい。

※正確なversion / lifecycle説明は最終版前に official docs で再確認する。

---

# 21. Build hooks: legitimate purpose

Build hooks を最初から「危険機能」と表現しない。

正規用途：

- native code compilation
- native asset preparation
- prebuilt native asset download
- linking information preparation
- platform-specific build integration

重要：

**download / process execution が存在すること自体は、build hookでは必ずしもsuspiciousではない。**

ここが後の detection discussion に効く。

---

# 22. Build hooks: execution model

Hook は Dart program。

監査上確認すること：

- いつ発火するか
- direct / transitive package でどう扱われるか
- どのworking directoryか
- どのenvironment variablesが見えるか
- filesystem access
- network access
- `Process` でchild processを起動できるか
- child process に何が継承されるか

無制限な任意実行と雑に表現しない。

Environmentなどには制約がある。

ただし、

- native compiler
- build tool
- external executable

を呼び出す正規用途があるため、developer / CI execution surface として見る。

---

# 23. Build hooks: deep investigation flow

この発表の「狂気」を見せる中心部分。

一つのbuild hookを実際に追う。

```text
Package
  ↓
hook/build.dart
  ↓
imports / API calls
  ↓
Process execution?
  ↓
Network download?
  ↓
Downloaded artifact
  ↓
Checksum / signature verification?
  ↓
Executable / library / generated output
  ↓
Where does it go next?
```

結果だけでなく、**どう調べたか**も見せる。

---

# 24. External artifact problem

Build hookが正規用途としてexternal artifactをdownloadする場合を深掘りする。

確認項目：

- URLはversionedか
- immutableか
- redirectされるか
- SHA-256等のdigestを検証するか
- signatureを検証するか
- provenanceがあるか
- downloaded artifactをexecuteするか
- runtime libraryとしてappへbundleするか

重要：

```text
pubspec.lock
     ↓
Dart package version / package content

External artifact fetched by hook
     ↓
別のtrust boundary
```

Lockfileだけでは後者は必ずしも固定されない。

---

# 25. Existing trusted execution path

今回の調査で得た重要な一般則。

新versionで突然、

```text
hook added
curl added
Process.run added
```

なら比較的目立つ。

一方、正規版からすでに、

```text
hook
  ↓
download
  ↓
run tool
```

が存在する場合、その経路の先だけが侵害されても、構造上の差分は小さい／ゼロになり得る。

候補メッセージ：

> **The hardest malicious update may not add a new capability.  
> It may abuse a capability you already trusted.**

または、

> **Don't only look for new execution paths.  
> Look at what changed behind existing trusted paths.**

---

# 26. Normal behavior / baseline

単純なdangerous API searchだけでは足りない。

例：

- analyzer plugin が突然native binaryをdownload → unusual
- native build hook がnative libraryをdownload → legitimate use caseとしてあり得る
- Gradle native plugin がcompiler processを起動 → ordinary
- unrelated formatter が`~/.ssh`へアクセス → unusual

一般化：

> **The more powerful behavior is legitimate for a feature, the weaker that behavior becomes as a detection signal.**

つまり、

**malicious behaviorを探す前に、そのmechanismのnormal baselineを理解する必要がある。**

これは本発表の「platformを理解する」メッセージに直結する。

---

# 27. Other Dart execution mechanisms

1 slide程度で比較。

## Analyzer plugins

- 有効化されたplugin codeがanalysis systemで実行される
- normal dependencyが存在するだけで自動実行ではない
- IDE / analysis server経由で継続実行され得る
- build hooksよりexplicit configurationが大きい

## build_runner

- builderはDart code
- `build_runner`を利用・実行するprojectで動く
- code generationなどが正規用途
- normal Flutter buildとのtrigger差を示す

## DevTools extensions

- packageにDevTools extensionを同梱できる
- userがenableするtrust boundaryがある
- precompiled Flutter Web outputがdistributionに含まれる
- sourceと実際にexecuteされるcompiled outputの対応は別問題になり得る

ここでは深掘りしない。

---

# 28. Flutter は Dart だけでは終わらない

```text
Flutter application
        ↓
Dart package
        ↓
Flutter plugin
        ↓
Android / iOS dependency
        ↓
Native artifact / source
```

ここではnative側のexecution mechanismを大量に説明するのではなく、

**dependency graphとartifact trustが別ecosystemへ続く**

ことを示す。

---

# 29. What does my build actually consume?

重要メッセージ：

> **Don't audit what looks like your dependency.  
> Audit what your build actually consumes.**

GitHub repository を見れば十分、とは考えない。

確認対象は ecosystem ごとに違う。

---

# 30. Source distribution vs Binary distribution

比較表候補：

| Ecosystem / mechanism | Typical form | Consumer build input |
|---|---|---|
| Dart/pub | source package | source |
| CocoaPods `source_files` | source | source |
| SwiftPM `.target` | source | source |
| Maven / Gradle JAR/AAR | precompiled | binary artifact |
| CocoaPods vendored framework | precompiled | framework / XCFramework |
| SwiftPM `.binaryTarget` | precompiled | binary artifact |
| DevTools extension | precompiled web output | compiled extension artifact |

伝えたいこと：

Source distributionでは、

> what I inspect

と

> what gets compiled

が比較的近い。

Binary distributionでは、GitHub sourceを読んでも、

> **Is this the source that produced the binary I actually consume?**

という別の問いが残る。

---

# 31. Android side — 本編では簡潔に

Android詳細は主題にしない。

伝える内容は最低限：

```text
Flutter plugin
    ↓
Gradle dependency
    ↓
JAR / AAR from Maven repository
    ↓
precompiled artifact
```

通常の `implementation(...)` dependencyでは、MavenからJAR/AARを取得し、consumerがそのsourceを再compileするわけではない。

また、

**artifactがどのroleで利用されるかが重要。**

例として存在だけ示す：

- normal implementation dependency
- Gradle plugin
- KSP / kapt / annotation processor
- custom lint

詳細なGradle task execution chainは本編では追わない。

---

# 32. iOS side — 本編では簡潔に

## CocoaPods

```text
source Pod
  → source_files
  → consumer側でcompile

binary Pod
  → vendored_frameworks / vendored_libraries
  → precompiled artifact
```

Build/development時のexecution mechanismとして、

- `prepare_command`
- `script_phase`

が存在することだけ示す。

## SwiftPM

```text
.target
  → source build

.binaryTarget
  → precompiled artifact

.plugin
  → build/development tooling
```

詳細は深掘りしない。

---

# 33. "We locked our dependencies." — Which dependency graph?

重要なスライド候補。

Flutter applicationでは複数ecosystemが存在する。

```text
Dart
  → pubspec.lock

Android
  → Gradle / Maven dependency resolution

iOS CocoaPods
  → Podfile.lock

iOS SwiftPM
  → Package.resolved

Build hook external downloads
  → yet another artifact resolution path
```

したがって、

> **We locked our dependencies.**

と言われたときの問い：

> **Which dependency graph?**

例：

Flutter pluginのversionが`pubspec.lock`で固定されていても、plugin内部のAndroid dependencyがdynamic versionを使えば、最終的なJAR/AARが変わる可能性がある。

また、hookが外部URLからartifactをdownloadする場合、pub package lockだけではそのcontentを固定できない。

---

# 34. Source review / Integrity / Provenance

混同しない。

## Source review

> Is this source behavior acceptable?

## Artifact integrity

> Are these the exact bytes I expected?

例：checksum / signature verification。

## Build provenance

> Where did these bytes come from?

- which source
- which build process
- which builder / environment

## Important

以下は同じ意味ではない。

```text
Version locking
≠ Artifact verification
≠ Publisher verification
≠ Build provenance
≠ Source-code security review
```

Provenanceがあっても、source自体がmaliciousなら安全とは限らない。

---

# 35. Investigation method

発表の特徴として、結果だけでなく調査方法を見せる。

候補：

1. official documentationを読む
2. actual package archive / cacheを見る
3. SDK / tooling sourceを見る
4. dependency treeを見る
5. minimal PoCを作る
6. execution timingをlogする
7. process / environment / filesystemを観察する
8. external downloadを追う
9. artifactのhash / formを確認する
10. source / binary boundaryを確認する
11. AIで調査候補を絞る
12. 最後は実測する

重要：

**GitHub sourceを読むことがauditのゴールではない。**

---

# 36. Attack path → Mitigation

Mitigationをchecklistとして並べない。

attack pathに対応させる。

## Unexpected package update

候補：

- lockfile
- exact / controlled updates
- dependency diff review

止める対象：

**unexpected resolution / update**

止められない例：

- locked version自体がmalicious
- hookが取得するexternal artifactだけが変わる

## External artifact substitution

候補：

- immutable / versioned URLs
- digest pinning
- checksum verification
- signature verification
- trusted distribution
- provenance / attestation

止める対象：

**packageとは別に取得されるartifactの差し替え**

## CI code execution

候補：

- least privilege
- minimal secrets
- token permission reduction
- isolated workflows
- trusted / untrusted execution separation

## Developer machine execution

候補：

- disposable environment
- container / VM
- credential separation
- filesystem separation

ただしsandbox / containerの限界は明示する。

## Prebuilt binary risk

候補：

- artifact inspection
- checksum / signature
- provenance
- reproducible builds where available
- trusted repository / publisher

---

# 37. No magic solution

必ず説明する。

- lockfileはunexpected updateを抑えるが、locked content自体の悪意は防がない
- pub package hashはpackage archiveのintegrityには役立つが、hookが後から取得するexternal artifactまでは自動的に保証しない
- source reviewは有効だが全dependencyを毎回完全reviewするのは非現実的
- scannerは便利だがmalicious logicを必ず検知できるわけではない
- sandboxにもboundaryがある
- provenanceは由来を示してもsource自体の安全性までは保証しない
- binary analysisは可能だがsource reviewより高コスト

候補：

> **There is no single “supply chain protection enabled” checkbox.**

---

# 38. 「安全か？」ではなく assurance を考える

避けたい問い：

> Is this package safe?

代わりに：

> **How much assurance do I need for this dependency?**

Riskによって監査深度を変える。

例えば、

- pure utility package
- package with build hook
- package downloading external executable
- package handling authentication / payment
- closed-source prebuilt binary

では必要なassuranceは同じでなくてよい。

基本原則：

> **Review effort should be proportional to risk.**

---

# 39. Reality: 全部はできない

build hookを一つ異常に深く追った後に、

> Can we do this for all 345 dependencies?

と問いかける。

答え：現実には難しい。

ここから、

- high-risk mechanismを優先する
- execution surfaceを機械的に列挙する
- source/binary/downloadを分類する
- AIで調査コストを下げる
- humanがrisk decisionをする

へつなぐ。

理想的な流れ：

```text
One dependency
  ↓
Obsessively investigate it
  ↓
Learn what questions matter
  ↓
Realize this doesn't scale
  ↓
Use tooling / AI to apply those questions broadly
  ↓
Human chooses where deeper assurance is needed
```

---

# 40. Demo 候補

build hooks中心に絞る。

優先度高：

- package cacheで`hook/build.dart`を実際に見つける
- hook executionをconsole logで確認
- child process起動
- visible environmentの確認
- external artifact downloadの例
- URL / checksum validationの有無をsourceで確認

補助：

- `.pub-cache` inspection
- `pubspec.lock`
- native dependency lineの確認

analyzer / build_runner demoは入れないか、一覧slideだけにする。

Live demoはfailure riskがあるため、

- prerecorded terminal capture
- screenshot
- animation

を優先検討。

---

# 41. 実例インシデント

1〜2件のみ。

目的：

**supply chain compromiseが現実に起きていることを示す。**

事件紹介自体を中心にしない。

選定条件：

- package compromise中心
- attack pathが明確
- malicious release / credential theft / build compromiseの流れが説明しやすい
- Flutter developerにも理解しやすい

npm / PyPIなどから選ぶ。

※採用事例は未確定。

---

# 42. 発表時間（40分）

build hooks中心なら以下を目安にする。

## 0–4 min — Opening / 345 dependencies

- self introduction
- dependency count
- dependency graph

## 4–8 min — Supply chain / attack path

- what compromise means
- developer/CI vs end-user impact
- malicious code exists vs executes

## 8–11 min — Execution surfaces overview

- hooks / analyzer / build_runner / DevTools extension
- build hooksを選ぶ理由

## 11–23 min — Build hooks deep dive

中心部分。

- mechanism
- legitimate purpose
- execution timing
- environment / process
- external download
- existing trusted execution path
- package unchanged / behavior changed
- baseline vs suspicious behavior

## 23–29 min — Beyond Dart

- Flutter → Android / iOS
- source vs binary distribution
- actual artifact
- Which dependency graph?

## 29–35 min — Mitigation

- attack pathに対応したcontrols
- lockfile limits
- digest / signature / provenance
- least privilege / isolation

## 35–38 min — Reality / AI

- cannot deeply audit everything
- extract questions
- AI as investigation assistant

## 38–40 min — Takeaways

- Understand platform
- Understand attack path
- Choose mitigation
- Go one level deeper

※Q&Aが別枠かどうかはイベント形式に合わせて調整。

---

# 43. 仮アウトライン

## 01. Who I am

Flutter developer, not a security expert.

## 02. 345 dependencies

大量のdependency。

## 03. What is a software supply chain?

package中心にscopeを定義。

## 04. What happens when a dependency is compromised?

Developer/CIとend-userへの2方向。

## 05. When can code actually execute?

Dart execution surfaces一覧。

## 06. Today: Build hooks

本編の深掘り対象を宣言。

## 07. How build hooks work

legitimate purpose / trigger / environment。

## 08. Follow one hook all the way down

source → process → download → artifact。

## 09. The package didn't change

external artifact compromise。

## 10. Existing trusted execution path

新しいcapabilityではなく、既存経路の先が変わる問題。

## 11. What looks suspicious?

normal baselineを理解する必要性。

## 12. Flutter goes beyond Dart

Android / iOS dependency。

## 13. What does my build actually consume?

source / binary distribution。

## 14. Which dependency graph?

pubspec.lockだけでは全build inputを固定しない。

## 15. Source, integrity, provenance

意味を分離。

## 16. From attack path to mitigation

lock / verification / isolation / least privilege。

## 17. Can we do this for all 345?

現実的には無理。

## 18. Scale the questions

tooling / AIで調査を補助。

## 19. Takeaways

Understand platform.

Understand attack path.

Choose mitigation.

## 20. Go one level deeper

自分の環境で一つ調べるよう促す。

---

# 44. 最後の呼びかけ

候補：

```text
Pick one part of your own development environment.

Go one level deeper than you normally do.

Read the documentation.
Look at the implementation.
Create a small experiment.
Use AI to help you explore it.

And ask yourself:

"If this dependency was compromised,
what would actually happen?"
```

---

# 45. 発表のトーン

避ける：

- 恐怖を煽る
- 「OSSは危険」
- 「packageを信用するな」
- build hooks自体を悪者にする
- 「AIが解決する」
- 「この対策をすれば安全」
- security expert的な上からの説教

目指す：

- developer perspective
- technical curiosity
- concrete experiments
- realistic risk
- practical mitigation
- honest uncertainty
- mechanism-first thinking

---

# 46. Slide design 方針

`flutter_deck` で制作。

- 1 slide = 1 message
- 長文を載せない
- technical detailはdiagram / code / tableで見せる
- speaker scriptをslideに全部書かない
- dependency graph / attack pathはvisual優先
- Flutter developerに馴染みのあるcode / commandを使う
- `345`などkey numberは大胆に表示
- build hook deep diveは同じdiagramを段階的に拡張する
- final conclusionは3項目

---

# 47. Visual candidates

## Dependency graph

```text
App
 ├─ Package A
 │   ├─ Package D
 │   └─ Package E
 ├─ Package B
 └─ Package C
     ├─ Package F
     └─ ...
```

## Two impact paths

```text
Compromised Dependency
        │
        ├── Build-time execution ──→ Developer / CI
        │
        └── Runtime code ──────────→ End user
```

## Build hook trust chain

```text
pub package
    ↓
hook/build.dart
    ↓
external URL
    ↓
downloaded artifact
    ↓
execute / bundle / link
```

## Package unchanged

```text
Yesterday:
Same package → same hook → good artifact

Today:
Same package → same hook → malicious artifact
```

## Dependency layers

```text
Flutter App
    ↓
Dart
    ↓
Flutter Plugin
    ↓
Gradle / CocoaPods / SwiftPM
    ↓
Native Artifact
```

## Assurance layers

```text
Version
  ↓
Artifact bytes
  ↓
Publisher
  ↓
Build provenance
  ↓
Source behavior
```

---

# 48. 調査で使える問い

発表中／AI監査用のframework候補。

## What do I depend on?

Dependency graphを把握する。

## What actually ships?

Source / JAR / AAR / XCFramework / generated outputなど。

## What runs during development or build?

Hooks / plugins / builders / scripts。

## What does it download or execute?

External tool / binary / asset。

## Where did those artifacts come from?

Registry / repository / URL / build process。

## What can change without the dependency itself changing?

External artifact / dynamic native dependency / mutable endpoint。

## What is the normal behavior of this mechanism?

異常検知のbaseline。

## Which attack path does my mitigation stop?

Mitigationの効果範囲。

---

# 49. Claude Code への重要指示

この資料からslideを作る際は、

**内容を勝手に技術的に補完しない。**

特に以下は最終確認前に断定しない：

- build hookのexact trigger conditions
- link hookとのlifecycle差
- transitive hook behavior
- environment / filesystem / network制約
- child process behavior
- external artifact validationの標準挙動
- native dependency locking / verificationの細部
- provenance対応状況

不明点は、

```text
[NEEDS VERIFICATION]
```

またはcode内TODOで明示する。

発表内容の正確性をslide designより優先する。

---

# 50. 最終的に残したい3メッセージ

## 1. Understand your platform

仕組みを知らなければ、何をtrustしているのか分からない。

## 2. Understand the attack path

「危険そう」ではなく、どこからどう届き、どこでexecuteされ、誰が影響を受けるかを見る。

## 3. Choose mitigations based on that understanding

万能なchecklistではなく、具体的なattack pathを止めるcontrolを選ぶ。

最後に：

> **Go one level deeper.**

