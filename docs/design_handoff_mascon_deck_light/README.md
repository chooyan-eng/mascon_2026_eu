# Handoff: masCon 2026 deck — "Security Risks of Packages in Mobile App Development"

## Overview

登壇スライド（24枚、16:9 / 1920×1080）のデザイン・レイアウト・ページ構成のハンドオフです。
実装先は既存の **flutter_deck** ベースの Flutter アプリ（`mascon_eu_2026`）。

**このハンドオフの目的は「見た目・レイアウト・ページ構成・演出の意図」を伝えることです。**
スライドの文言、技術的な正確性、Flutter 側の実装方法は、現状のコードベースと Claude Code の判断を優先してください。
特に `[NEEDS VERIFICATION]` / `TBD` と記した内容は仮置きです。断定せず、現状の資料や official docs に合わせてください。

## About the Design Files

同梱の `Deck Redesign.dc.html` は **HTML で作ったデザインリファレンス**（プロトタイプ）です。そのまま流用するコードではありません。
ブラウザで開くとスライド一覧と各ページの演出（→ キーで段階送り）を確認できます。
タスクは、このデザインを **既存の flutter_deck プロジェクトの構成・慣習に沿って Flutter で再現すること**です。

## Fidelity

**High-fidelity（見た目）** — 色・フォント・サイズ・レイアウトは指定どおりに再現してください。
ただし以下は low-fidelity 扱い：

- コード抜粋（p13）、Q&A の回答（p12）、事例名・年・リンク（p7）、表の中身（p9, p20, p21）の**文言**
- 依存グラフ（p4）のノード配置 — 実データがあれば置き換え可
- アニメーションの正確な easing / duration（目安を記載）

## Global design language

### 方針

- **1 slide = 1 message。文章ではなくキーワード＋図。** 説明は口頭。
- 箇条書きは最小限（p7, p11, p12, p21 など「一覧で見せる」ページのみ）。
- **ライトモード**（紙色の地）。色は**単一アクセント（金）**。「危険」も赤ではなく金で「注目点」として示す。
- 面（塗り）ではなく**線**で描く。枠は 1px（強調は 2px）のボーダー、区切りはヘアライン。塗りつぶしの箱・カードは使わない。
- 大きい文字ほど細く（Light 300）。Bold は使わない。
- 装飾（背景グラデーション、影、アイコン、絵文字）は使わない。

### カラー

| 用途 | 値 |
|---|---|
| 背景 | `#F3F2F2`（Classical の紙色、ライトモード） |
| 主要テキスト | `#201F1D` |
| 副テキスト | `#D7D3D3` |
| 補足・薄い文字 | `#BAB6B6` |
| さらに薄い（フッター、ラベル） | `#7D7979` |
| 非強調の線・枠 | `#BAB6B6` |
| 表の罫線 | `#D7D3D3` |
| 沈めた線・文字（フォーカス時の他要素） | `#D7D3D3` / `#BAB6B6` |
| **アクセント（金）** | `#B68235` |
| アクセント（濃い、下線用） | `#8A6228` |
| コードブロック背景 | `#2D2B2B` |

> ライトモード（案 3a）で確定。ダーク版からの変更は色のみで、レイアウト・演出は同一。

### タイポグラフィ（Google Fonts / SIL OFL — 無料、アプリ同梱可）

- **本文・見出し:** Figtree — 300（Light）を基本、名前など一部 400 / 500
- **等幅:** Martian Mono — 400。キッカー、ハンドル名、ファイル名、コマンド、パッケージ名、コード、番号
- Flutter: `google_fonts` の `GoogleFonts.figtree()` / `GoogleFonts.martianMono()`、またはアセット同梱

サイズの目安（1920×1080 基準）:

| 役割 | サイズ / ウェイト |
|---|---|
| タイトル（p1） | 130px / 300 / line-height 1.02 / letter-spacing −0.03em |
| ページ見出し h2 | 88px / 300 / line-height 1 |
| 巨大数字（606） | 360–440px / 300 / tabular figures |
| セクション見出し（p10） | 160px / 300 |
| 大キーワード（p8 exists/executes） | 220px / 300 |
| 中見出し・要点 | 48–72px / 300 |
| 本文 | 28–40px / 300 |
| 表セル | 28–34px |
| コード | 26px / Martian Mono / line-height 1.6 |
| キッカー（左上の小ラベル） | 24px / Martian Mono / letter-spacing 0.08em / 金 |
| フッター | 24px / `#7D7979` |
| **最小サイズ** | 24px |

### 共通レイアウト

- 余白: 左右 120px、上 96px
- 左上に**キッカー**（金・等幅 24px、例 `Build hooks · versions`）、その 20px 下に h2
- フッター: 左下 `@tsuyoshi_chujo`、右下ページ番号（2桁）。位置 `left/right: 96px, bottom: 44px`。タイトルにはなし
- 角丸: 4px
- 横方向の流れ図（p5, 6）: **My app を左端**に置き、依存は**右（upstream）から左へ**流れる。右上に左向き矢印＋ `upstream`。右端の枝は右へ向かって透明にフェードし「まだ続く」感を出す

### 演出（ステップ）の共通ルール

- 各スライドは flutter_deck のステップに相当する「段階」を持つ。**→ / Space で次の段階、全段階が出たら次のスライド**
- 出現: `opacity 0→1` ＋ `translateY 28px→0`、700ms ease
- 線が伸びる: `scaleX 0→1`（transform-origin left）または SVG `stroke-dashoffset 1→0`、700–1200ms ease-out
- 「点灯」: 枠線・文字色が `#BAB6B6` → `#B68235` に 700ms で変化
- 「沈む」: 他要素の文字色が `#D7D3D3` / `#BAB6B6` へ
- 段階には 2 種類: **auto**（前段階から 150–350ms 後に自動）と **click**（発表者操作待ち）。以下 `→` は click、`…` は auto を示す

---

## Slides

### 01 — Title
- 左寄せ、縦中央。キッカー `masCon / next.app devCon · Berlin 2026`（等幅・金）
- タイトル 2 行 130px Light: `Security Risks of Packages` / `in Mobile App Development`
- 金のヘアライン（左から伸びる、1200ms）
- 名前行: `Tsuyoshi Chujo`（48px）· `Flutter developer · package author`（28px 薄）· `@tsuyoshi_chujo`（等幅 26px 金）
- 段階: タイトル … 線＋名前行

### 02 — About me
- キッカー `About me`
- 上段: **円形の写真枠**（168px、金の 1px 枠、内側 8px の余白に 150px 写真）＋ 右に `Tsuyoshi Chujo`（56px）/ `Flutter developer from Japan`（32px 薄）
- 中段: 2 カラム（中央にヘアライン縦線）
  - 左 `Package user`（96px、nowrap）/ 下に `Cardcraft, and more`（30px 薄）
  - 右 `Package author`（96px）/ 下に `crop_your_image, animated_to, and more`（パッケージ名は等幅 28px）
- 下段: `Security expert`（120px、イタリック、`#7D7979`）→ **金の取り消し線**が左から引かれる（4px 太、scaleX）
- 段階: 上段 … 中段 → 下段テキスト … 取り消し線

### 03 — 606
- 中央。数字 `606`（440px、金、tabular）を **0 から 1.8 秒でカウントアップ**
- → `packages my app depends on`（64px イタリック）
- … 比率バー（幅 1200px）: Dart 283 / iOS 15 / Android 308 を `flex` 比率で並べ、各区分の上辺に 3px の線（Dart `#2D2B2B`、iOS 金、Android `#7D7979`）。ラベルは線の下 30px。iOS は細すぎるため、細い金の引き出し線で下 76px にラベル

### 04 — Dependency graph
- キャンバス描画のネットワーク図（1720×760、左 100 / 上 200）
- 左上に数字（140px 金）＋ラベル（32px）。`86` / `direct dependencies` → `606` / `dependencies — direct + transitive` へ数字が実時間で増える
- 中央 `My app`（金の点 r=11、下に 22px ラベル）
- 段階: … 直接依存 86 ノード（金 r=5、金の線 α0.32）が中心から弾けるように展開 → 推移的依存（白の中空丸 r=2.6、線 α0.09）が**親ノードから枝分かれ**して増える … 3 秒後にクラスタ横へ `Dart 283` / `Android 308` / `iOS 15` ラベル（38px、数字は金）、右下に `Direct is only the top.`（56px イタリック金）
- Flutter: `CustomPainter` + `AnimationController`。ノード座標は擬似乱数で固定（実データでも可）

### 05 — Supply chain（横型ツリー）
- キッカー `Supply chain`。右上に左向き矢印（560px）＋ `upstream`
- `My app`（左 160 / 上 492、280×96、金枠 1px、48px）← 中列 Package A / B / C（左 720、上 252 / 492 / 732）← 右列 D / E / F / G（左 1320、上 172 / 332 / 652 / 812）。枝は 1.5px `#BAB6B6` の直角線
- 右列の D・F・G のさらに右に、名前のない小枠（220×48）と枝を置き、`mask: linear-gradient(to right, #000 15%, transparent 85%)` で右へフェード
- 段階: … 全体表示 → **Package F が金に点灯**（2px 枠）＋下に `compromised`（28px イタリック金）… 金の線が F → C に伸びる … C → My app に伸びる（右から左へ）
- 文字キャプションなし（口頭）

### 06 — More than packages（横型レーン）
- キッカー `Software supply chain`。同じ upstream 矢印
- `My app`（左端、同位置）に右から 8 本のレーンが流れ込む（各 y: 250, 340, 430, 520, 610, 700, 790, 880）: `Compiler / SDK`, `Build tool`, `CI`, `IDE extension`, **`Packages`**, `Package registry`, `Container image`, `Binary artifact`
- 各レーンの枠（300×68、左 900）。線は右端で右へフェード
- 段階: … 全体（全て灰）→ **Packages のレーン・枠だけ金**、他 7 本は `#D7D3D3` に沈む

### 07 — Not hypothetical（箇条書き）
- キッカー `Real incidents`、h2 `This is not hypothetical`
- 3 カラム。各: 小見出し（等幅 24px 金 `npm · 2026`）/ 事例名（56px）/ ヘアライン / 箇条書き 2 点（28px `#444141`）/ 最下部に参考リンク（24px 金、下線 `#8A6228`）
- 段階: 1 列目 … → 2 列目 → 3 列目
- 事例・リンクは仮置き `[NEEDS VERIFICATION]`

### 08 — Exists ≠ executes
- 中央。小ラベル `Malicious code`（24px 大文字）
- `exists`（220px `#444141`）`≠`（金）`executes`（220px イタリック金）
- → 下に `When can a package actually run code?`（68px）
- 段階: exists → ≠ executes → 問い

### 09 — Execution surfaces（表）
- キッカー `Execution surfaces`、h2 `When does package code actually run?`
- 3 列: `Mechanism` / `When` / `Explicit opt-in?`（ヘッダー 24px 大文字 `#7D7979`、下線 `#605D5D`）
- 行（罫線 `#D7D3D3`、padding 30px）: Library code / at runtime / — you call it · **Build hooks / link hooks** / during the build / **No** part of the normal build · Analyzer plugins / during analysis / Yes explicit configuration · build_runner / builders（等幅）/ during code generation / Yes you run build_runner · DevTools extensions / while debugging / Yes user enables it
- opt-in 列: Yes/No を 44px、補足を 26px 薄で横並び
- 段階: 行が上から順に … → **Build hooks の行が金**（文字・罫線）、名前が 1.12 倍、**他 4 行は `#BAB6B6`/`#D7D3D3` に沈む**
- 内容は `[NEEDS VERIFICATION]`

### 10 — Divider: Build hooks
- 中央、文字だけ。`Build hooks`（160px）… `deep dive`（64px イタリック `#605D5D`）。装飾なし

### 11 — What build hooks do
- キッカー `Build hooks`、h2 `Build hooks exist for good reasons`
- 上: 箇条書き 5 点（40px、金の丸ドット 10px）: Native code compilation / Native asset preparation / Prebuilt native asset download / Linking information preparation / Platform-specific build integration
- 下（y 640–980）: **ビルドパイプラインの帯**。ヘアライン（y=880）上に `$ flutter build`（等幅、線の上）、段 `compile`（左 420、220 幅）… `link`（左 1400、180）… `app`（左 1620、180）。各段 68px 高、`#BAB6B6` 枠、背景色で線を隠す
- → `package_a` / `package_b`（等幅 24px 薄）から `hook/build.dart`（320×68、**金 2px 枠**、等幅 24px 金）が上から 60px 降りてきて（1200ms ease-out）、compile と link の間の線上に並ぶ（左 690 / 1040）
- 段階: 箇条書き 5 点 … パイプライン … → hooks 降下

### 12 — What can a hook do?（Q&A）
- キッカー `Build hooks · execution model`、h2 `A hook is a Dart program.`
- 2 列グリッド（1fr / 1.1fr、gap 64）。左: 問い（34px Light `#2D2B2B`）、右: 答え（等幅 26px 金、手前に 24px の金の短い線）。行 padding 14px、罫線 `#D7D3D3`
- 6 行: When does it fire? / Direct vs transitive? / Working directory? / Visible environment variables? / Filesystem access? / Network access?
- 段階: 問い … → 答えが 1 つずつ（線 scaleX ＋ テキスト translateX −16→0）
- 答えは仮置き（`TBD` 含む）`[NEEDS VERIFICATION]`

### 13 — Real hook code（切り替え式）
- キッカー `Build hooks · in the wild`、h2 `What real hooks do`
- 1 枚の中で 3 パネルを **クロスフェード切り替え**（→ で 01 → 02 → 03、次で次スライド）
- パネル: 2 列（520px / 残り、gap 64）
  - 左: 番号 `01 / 03`（等幅 24px `#7D7979`）/ やっていること（72px Light、例 `Download a prebuilt binary`）/ 補足 1 行（28px 薄）/ **最下部**にメタ 1 行 `some_package 1.4.2 ↗`（等幅 24px `#7D7979`、行全体がリンク）
  - 右: 枠の左上外側にファイル名 `hook/build.dart`（等幅 24px `#7D7979`）、その下にコードブロック（`#EAE7E7` 背景、`#D7D3D3` 1px 枠、padding 44/48、等幅 26px、白）
- 内容とコードで画面の 9 割。メタ情報は目立たせない
- 3 例: ダウンロード / clang 実行 / TBD。コードは全てダミー

### 14 — Versions change
- キッカー `Build hooks · versions`、h2 `A new version can ship a new hook`
- 上段: `some_package 1.4.2`（320×140 枠）— 線 — `some_package 1.5.0`（金枠）、右に `hook/build.dart`（等幅金）/ `changed · runs on your next build`
- → 下段: `pubspec.lock`（金 2px 枠、内に `some_package: 1.4.2`）… 右に `The version you resolved is the version you build with.`（40px）

### 15 — Package unchanged
- キッカー `Nothing in the package changed`
- 2 行の同一チェーン: `Yesterday` / `Today`（48px イタリック）— `package 1.4.2` — `hook/build.dart` — `tool.zip`（各 320×130 枠）
- → Today 行の `tool.zip` だけ金枠に変わり、中身が `tool.zip` / `replaced upstream`（金）へクロスフェード
- … 下に `Can a dependency change without changing itself?`（60px イタリック中央）

### 16 — Trust boundary
- キッカー `Build hooks · trust boundary`、h2 `Same version. Same bytes?`
- 5 ノードの横チェーン（288px 枠 ×5、60px の線）: `pub package` — `hook/build.dart` — `external URL` — `artifact` — `run · bundle`。後半 3 つは金枠・金文字
- → 下に 2 つの括弧: 前半 3 ノード下 `pubspec.lock`（灰）、後半 3 ノード下 **`a different trust boundary`**（金 2px）
- … 最下部にチップ列（等幅 24px、`#BAB6B6` 枠）: `check` versioned URL · immutable · no redirect · SHA-256 digest · signature · provenance · executed? · bundled into the app?
- 段階: ノード 1 … 2 … 3 … 4（線が順に伸びる）→ 括弧 … チップ

### 17 — Provenance
- 中央。`Is the source on GitHub / what my build actually uses?`（72px 2 行）→ **`No.`**（200px 金）… `Audit what your build consumes.`（40px）＋ `provenance`（等幅 32px 金）

### 18 — Same questions
- キッカー `Beyond build hooks`、h2 `Ask the same questions elsewhere`
- 2 列表（1fr / 1.4fr）: 左 mechanism（Analyzer plugins / build_runner / builders（等幅）/ DevTools extensions、48px）、右に問いのチップ 4 つ（26px、`#BAB6B6` 枠）: When does it run? / Explicit opt-in? / What does it fetch or run? / What does the build consume?
- 段階: 行が上から順に …

### 19 — Beyond Dart
- キッカー `Beyond Dart`、h2 `A Flutter app depends on more than Dart`
- 縦に 5 層（720×88 枠、間を 36px の縦線で接続）: `Flutter app` / `Dart packages`（pub）/ `Flutter plugins`（Android / iOS code inside）/ **`Gradle · CocoaPods · SwiftPM`**（other package managers）/ **`JAR / AAR · frameworks · binaries`**（often precompiled）。下 2 層は金。右に補足 26px 薄
- 段階: 上から順に降りる …

### 20 — Source vs binary（表）
- キッカー `Provenance`、h2 `Source distribution vs binary distribution`
- 3 列（`Ecosystem / mechanism` / `Typical form` / `Build input`）、7 行、行 padding 12px。Build input が binary の行は金文字
- 行: Dart / pub · CocoaPods source_files · SwiftPM .target · Maven / Gradle JAR / AAR · CocoaPods vendored framework · SwiftPM .binaryTarget · DevTools extension
- → 最下部に `Is this the source that produced the binary I actually consume?`（36px 金、1 行）
- 内容 `[NEEDS VERIFICATION]`

### 21 — No single checkbox（表）
- キッカー `Mitigations`、h2 `No single “supply chain protection” checkbox`（72px）
- 3 列（420px / 1fr / 1fr）: `Control` / `Covers` / `Does not cover`（3 列目は金文字）。7 行: Lockfile · Pub content hash · Source review · Scanners · Sandboxes · Provenance · Binary analysis
- 段階: 行が順に …

### 22 — 606 again
- 中央。`606`（360px 金）＋ `Can we do this for all of them?`（64px）→ `No. Understand the mechanisms, then prioritize.`（48px）… `AI makes going one level deeper much cheaper — the questions are still yours.`（30px 薄）

### 23 — Takeaways
- 左右 200px 余白、縦中央、行間 72px。番号（等幅 72px 金）＋ 見出し（68px）＋ 補足（30px 薄）
  1. Understand your platform — If you don’t know the mechanism, you don’t know what you trust.
  2. Understand the attack path — Where it enters, where it executes, who is affected.
  3. Choose mitigations from that understanding — Pick the control that stops a concrete attack path.
- 段階: 1 … 2 … 3

### 24 — Thank you
- 左寄せ縦中央。`Thank you.`（160px）/ 金ヘアライン（左から伸びる）/ `Tsuyoshi Chujo`（48px）· `@tsuyoshi_chujo`（等幅金）· 右端に `Go one level deeper.`（36px イタリック薄）

---

## Interactions summary（flutter_deck 向けメモ）

- 段階送り = flutter_deck の steps。auto 段階は前段階完了後に自動で進める（`Future.delayed` など）。click 段階は発表者操作
- 出現アニメ: `AnimatedOpacity` + `AnimatedSlide`（700ms, `Curves.easeOut`）
- 線の伸長: `AnimatedContainer`/`TweenAnimationBuilder` の scaleX、または `CustomPainter` で `PathMetrics` の部分描画
- カウントアップ（p3, p4）: `TweenAnimationBuilder<int>` 1.8s `Curves.easeOutCubic`
- p4 のグラフ: `CustomPainter` + `AnimationController`
- p13 のパネル切替: `AnimatedSwitcher`（fade + 24px slide）
- 写真枠（p2）: 正方形画像を `ClipOval` で。画像は差し替え可能に

## Assets

- 写真: About me の円形枠のみ（ユーザー提供）。その他の画像・アイコンなし
- フォント: Figtree, Martian Mono（Google Fonts, SIL OFL）

## Files

- `Deck Redesign.dc.html` — 全 24 枚のデザインリファレンス（ブラウザで開いて確認。→ / ← でスライドと段階を送る）
- `deck-stage.js`, `support.js`, `image-slot.js`, `_ds/` — リファレンスを表示するための補助ファイル。実装には不要
- `Font Options.dc.html` — フォント選定時の比較（参考）
