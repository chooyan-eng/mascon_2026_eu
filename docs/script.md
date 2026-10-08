# Talk Script — 20-minute slot

`docs/slides.md` の 30 枚（Claude Design 構成）に対応する読み上げ台本。目安は毎分 120 語。現状の合計は約 22:05 で、**20 分枠を約 2 分 5 秒超過**（アニメ待ち・操作込み。下の短縮候補で調整するか、リハーサルで実測して詰める）。

- `[→ step N]` はキーを押して次の step に進めるタイミング。auto 段階（遅延アニメ）は待つだけで進む。
- **太字** は `docs/security_english_vocabulary_handoff.txt` の語彙。本番で自然に出るよう、意識して発音練習する。
- `[TODO]` は内容が未確定の箇所、`[VERIFY]` は発表前に一次情報で確認する箇所。確認できるまでは断定しない言い回しにしてある。
- 各スライドの時間は目安。Part ごとの累計時間を見出しに書いてある。
- 押したときの短縮候補（優先順）: ① 04 のクリック操作を省く（−20 秒） ② 13 の pattern 2 を 1 文に圧縮（−20 秒） ③ 26 を最初と最後の 2 文だけにする（−25 秒） ④ 07 の各 incident の補足文を落とす（−30 秒）。
- スライドの文言を変えたらここも合わせる。スライドの正本は `docs/slides.md`、話す内容の正本はこのファイル。
- 非表示ページの旧台本は末尾の「退避」セクションに残してある。

---

## Part 1 — Opening (0:00–2:50)

### 01. Title — 0:20

Hello everyone. My name is Tsuyoshi, and I came here from Japan.

Today I'd like to talk about the **security** **risks** of **packages** in mobile app development 

### 02. About me — 0:50

Let me introduce myself first. I'm a Flutter developer.

I build and publish mobile apps — so I am a **package** user. And I develop and maintain Flutter **packages**, like crop_your_image and animated_to — so I am also a **package** author. I depend on other people's code, and other people depend on mine.

[→ step 2]

One thing I am not.

[→ step 3: 取り消し線]

I am not a **security** expert. I am someone who lives in the Flutter ecosystem every day, as a **package** user and as a **package** **maintainer**. So today, I will talk from that viewpoint. Not as an expert teaching rules, but as a developer who looked closely at the platform he uses every day.

### 03. 606 — 0:40

Let me start with a number. (カウントアップを待つ) Six hundred and six. What does this number mean? (少し間を取る)

[→ step 2]

This is the number of **packages** and libraries that one of my production Flutter apps depends on. Not a demo app — a real app in production. And since what I build is a Flutter app, this number is not just Dart and Flutter **packages** — it also includes the iOS and Android libraries underneath.

### 04. Dependency graph — 1:00

And this is what it looks like. This is not an illustration. It is the real **dependency** graph of my app.

(グラフを pan / zoom で軽く動かす) In the center, you can see my app. And every line here is a **dependency** — for example, (近くのノードを 1 つクリックして示す) you can see my app depends on this **package**.

Right now you see only my **direct dependencies** — the **packages** I wrote in my pubspec file, the ones I actually chose. Eighty-six of them.

[→ step 2]

And this is everything my **build** actually pulls in. (カウントアップとノード出現を待つ) Most of these are **transitive dependencies**. Honestly, I don't even know most of their names. But every one of them is part of my app.

And let me be clear: depending on **packages** is not a bad thing. These **dependencies** are exactly why we can build apps this efficiently, and ship them to our users this fast.

---

## Part 2 — Supply chain & incidents (2:50–7:30)

### 05. Supply chain — 0:50

But on the other hand, we have to be aware that these **dependencies** also introduce **risks**. Let's take a look at simple version of the **dependency** graph. My app is on the left. Everything flows in from **upstream** — my direct **dependencies**, their dependencies, and so on. The chain continues further than we can see.

[→ step 2]

Now imagine one small **package**, deep in the graph, gets **compromised**. (線が My app まで流れるのを待つ) The **malicious** code travels **downstream**. Through Package C, into my app. I never chose Package F. I have never even heard of Package F. My app ships it anyway.

This is a **software supply chain** **attack**. And as I said, **dependencies** themselves are not the problem. But every **dependency** is a trust relationship, and every one of them increases our **attack surface**. This **risk** keeps growing, and that is my topic today.

### 06. Impact examples — 0:45

So, what actually happens when one of these attacks succeeds? Two groups of people get hurt.

First, our side — developers and CI. **Credentials** are stolen: **tokens**, API keys, cloud access. Private **source code** leaks. And here is the nasty part: with stolen publish **credentials**, the **attacker** publishes **malicious** versions of your own **packages**. You become the next link. The chain continues.

[→ step 2]

Second, end users. The damage there is hard to enumerate — and that is exactly the problem. **Malicious** code ships inside your app, signed by you, delivered through the store. So the damage is anything your app can do on the device. The two groups get hurt in different ways — and we have to think about both.

Now, let's see what a real **compromise** looks like.

### 07. Real-world incidents — 1:50

This is not hypothetical. Here are three **incidents**, all from this year, in three different ecosystems.

First, npm. Legitimate Red Hat **packages** were **compromised**, and a **malicious** `preinstall` hook was added. A preinstall hook is a lifecycle script — it runs automatically. So running `npm install` as usual was enough to execute it, and it stole **credentials** from developer machines and CI.

Second, PyPI. The publish **credentials** of LiteLLM were **compromised**, and a version containing a **credential stealer** was published. Developers updated as usual, and their **tokens** were stolen. Those **tokens** were then used to attack further **packages**. A chain reaction.

And the third one is from our own ecosystem: pub.dev. A Flutter **package** called universal_file_viewer shipped **malicious** code. But here is the twist: the **package** was not the original target. The **maintainer's** Mac was infected with a macOS **malware** called XCSSET, which mechanically injects itself into Xcode and Android projects it finds on the machine — and the package's example folder contained exactly such projects. The maintainer committed and published as usual, completely unaware, and the infection reached GitHub and pub.dev.

Look at the pattern. A **compromised package**. A normal developer operation — install, update, publish. Code **execution** on the developer machine or CI. **Credential theft**, further **compromise**. Three ecosystems, three different **execution** mechanisms — and the third case shows the reverse direction: a **compromised** developer machine entering the **supply chain**. So this is not an npm-specific problem. It has already reached us.

And notice one more thing: you did not need any deep low-level knowledge to follow these stories. From the incidents alone, you can understand what was **compromised**, how the code got **executed**, and what damage followed.

### 08. More than packages — 0:30

By the way, a **software supply chain** is more than **packages**. This list is based on the OWASP Software Supply Chain Security Cheat Sheet. Version control. **Build** tools. CI. IDE extensions. The **package registry** itself. All of them flow into the final app, and every one of them can be attacked.

[→ step 2]

But this 40-minute session cannot cover all of that, so today I focus on this one lane: **packages** and libraries.

### 09. Exists ≠ executes — 0:45

Before we go deeper, one thing to keep in mind. Even when **malicious** code gets onto your disk, that does not mean it automatically runs. A **compromised package** can sit in my pub cache and do nothing. Code that exists is one thing; code that **executes** is another — and that difference is exactly where the defense lives.

And think back to the **incidents**. **Attackers** did not suddenly run **arbitrary** code in some incomprehensible way. Typically, they abuse an **execution** mechanism the ecosystem itself provides — a lifecycle script, a **build** file, **package** code. So knowing those mechanisms is exactly where the defense starts.

[→ step 2]

So the key question of this talk is: when can a **package** actually **execute** code?

---

## Part 3 — Execution surfaces (7:30–8:30)

### 10. Execution surfaces — 1:00

So far, everything I said applies to almost any ecosystem. From here, let me take Flutter and Dart as the example, and make it concrete.

Even a single Dart **package** has several **execution** surfaces. (行の出現を待つ) Library code runs inside the app, at **runtime** — but only when you call it. **Build** **hooks** run during the **build process**, as part of a normal `flutter build`. Analyzer plugins run during analysis — but you configure them explicitly, per **package**. Builders run when you run build_runner, which executes builders from all your **packages** together, so there is no per-package opt-in. 

For each of these, I ask the same two questions. When does it run? And did I opt in?

[→ step 2]

And look at this row. **Build** **hooks**. Part of the normal **build**, and no explicit opt-in. You add a **dependency**, you build, it runs. That is the surface I want to dig into.

---

## Part 4 — Deep dive: build hooks (8:30–14:00)

### 11. Divider: Build hooks — 0:25

Now, here is how I want to spend the rest of this session. Instead of covering many topics broadly, I will pick one mechanism — **build** **hooks** — dig deep into it, and share what I learned on the way.

And as you listen, please keep one thing in mind: this process of digging deeper is transferable. The same approach works for any mechanism, in any ecosystem. So even though my examples are from Flutter, this is not a talk just for Flutter developers.

### 12. What build hooks do — 1:05

First, what are **build** **hooks**? Just like Gradle or Swift Package Manager, it is a mechanism that lets a **package** inject its own work into the **build**. In Flutter, the typical uses are: compiling native code, preparing native assets, downloading prebuilt **binaries**, and preparing linking information for the platform **build system**.

And why is this design useful? Flutter builds for many platforms — and shipping Android resources inside an iOS **build** would be wasteful. So instead of bundling everything in the **package** up front, a hook prepares just the right resources for the target platform, at **build time**.

[→ step 2]

And they are part of the normal `flutter build`: **packages** drop their hooks right into the pipeline, between compiling and linking. So please remember this one thing: inside a **build** **hook**, downloading a file, or starting a process, is not suspicious by itself. That is the normal job of a hook. This becomes important later, when we talk about **detection**.

### 13. Real hook code — 1:30

So I went and read what real **hooks** do, in published **packages**. The code on the right is excerpted from the real hooks. Three patterns.

Pattern one: download a prebuilt **binary**. The powersync **package** fetches its prebuilt SQLite core from GitHub releases, at **build time** — and notice, it verifies a SHA-256 **digest** against the download. This is a hook doing it right.

[→ step 2]

Pattern two: run a native compiler. The objective_c **package** — published by dart.dev, so as official as it gets — compiles its bundled Objective-C sources with clang. A **child process**, started on my machine, as part of my build.

[→ step 3]

Pattern three, the interesting one: search the developer machine. The android_libcpp_shared **package** bundles the C++ **runtime** library for Android. Its hook downloads nothing and compiles nothing. It searches my local machine for an installed Android NDK — **environment variables**, local.properties, common install locations — and bundles the libc++_shared.so it found there into my app.

Every one of these is completely legitimate. And that is exactly the point. A **build** **hook** supplied by a **dependency** runs as a normal Dart program on my machine: network access, **child processes**, reading the filesystem. The same capabilities become the **attack surface**, the moment something **upstream** goes wrong.

### 14. Audit & versions — 0:45

Now, suppose I want to **audit** this surface. A **hook** is normal **package** code — so I can read it. Say I did, and everything looked fine.

[→ step 2]

But that check was valid for one version only. A new version can ship a brand-new hook, or quietly change an existing one — and it runs on your next **build**. No prompt, no confirmation. And remember the **incidents** from earlier: this is exactly how a typical **supply chain** **attack** arrives — as a **malicious** update you pull in.

(注意行が出るのを待つ) So which version runs? The one in your **lockfile**. The version you resolved is the version you **build** with. Keep that in mind for the next slide.

### 15. Package unchanged — 0:50

Because here is the finding that surprised me the most.

Yesterday: my **package**, version 1.4.2. Its **hook** downloads a tool from an external URL. Good **artifact**. Everything fine.

[→ step 2]

Today: same **package**. Same version. Same **hook** code. Same content **hash** on pub.dev — not a single byte of the package changed. But the **artifact** behind that URL was replaced **upstream**. My **build** input changed; my **dependency** did not.

So I learned to ask a new question: can this **dependency** change its behavior without changing itself?

### 16. Trust boundary — 0:55

[VERIFY: native asset ダウンロード時の標準の integrity 検証]

Let's follow the chain to see why. The pub **package** contains the **hook**. The hook points at an external URL. The URL serves an **artifact**. And the artifact is **executed** on my machine, or bundled into my app.

[→ step 2]

My **lockfile**, together with the pub content **hash**, pins the first half — the Dart **package**. But everything after that external URL is a different trust boundary, and the **lockfile** does not necessarily pin it. So for a downloaded **artifact**, I now have a checklist. Is the URL versioned and immutable — or can the same URL start serving different bytes? Is a **hash** verified? A **signature**? Is there **provenance**? And finally: is the artifact **executed** on my machine, or bundled into the app my users install? Each answer changes the **risk**.

---

## Part 5 — Beyond Dart (14:00–17:35)

### 17. Provenance — 0:25

One more question. Earlier, I showed you the hook's **source code** on GitHub. But is the **source code** on GitHub what my **build** actually uses?

[→ step 2]

No. Not necessarily. So my rule became: don't **audit** what looks like your **dependency**. **Audit** what your **build** actually consumes. Reading the GitHub **repository** is not **sufficient**.

### 18. Inspect the packages — 0:40

And here is one genuinely good thing about the Dart ecosystem: you can read what your **build** consumes. Every hosted **package** your **build** resolved is already on your disk, in the pub cache — hooks included.

And if a version is not in your cache yet, `dart pub unpack` fetches any package version into a local directory, for inspection, without running anything.

[→ step 2]

So the exact set of **packages** that will run is always available to read. The exception is what we just saw: the **artifact** a **hook** downloads from outside. That one, you have to chase separately.

### 19. Deep dive recap — 0:35

Let me pause here and collect what this deep dive gave us. By digging into this one mechanism, three things became visible.

How its code gets **executed** — as part of a normal **build**, with no opt-in and no prompt. Which **attack surfaces** that opens — network, **child processes**, the filesystem, and the **artifact** behind a URL. And how to **audit** it — read the resolved source, re-check on every version, and chase what the **build** actually consumes.

None of this was visible from the package page. It came from looking one level deeper.

### 20. Divider: Zoom out — 0:10

Now, let's widen the view again. Because the same questions are waiting everywhere else.

### 21. Same questions — 0:30

Now — that was one surface. One. And to say just this much, I needed the documentation, the SDK **source code**, real **packages**, and my own small experiments.

Every other surface deserves the same treatment. Analyzer plugins. Builders. DevTools extensions. The questions are always the same four: When does it run? Did I opt in? What does it fetch or run? And what does my **build** actually consume?

### 22. Beyond Dart — 0:35

And all of that was still Dart-only. Let's zoom out. A Flutter app has Dart **packages**. Some of them are Flutter plugins, with Android and iOS code inside. Plugins bring native **dependencies** through Gradle, CocoaPods and Swift Package Manager — three more package managers, three more resolution mechanisms. And those bring native **artifacts** — often precompiled. The **supply chain** does not stop at pub.dev, and the same thinking applies at every layer.

### 23. Source vs binary — 0:40

Because at those layers, the form changes. Dart **packages** are distributed as **source code** — what I **review** is close to what I compile. CocoaPods source pods and SwiftPM source targets, the same. But a JAR or AAR from Maven, a vendored XCFramework, or a precompiled DevTools extension arrives as a **binary**.

[→ step 2]

And with a **binary**, a new question appears: is this the **source code** that produced the **binary** I actually consume? That is a question about **provenance** and **authenticity** — **code review** alone cannot answer it.

---

## Part 6 — Mitigation & close (17:35–21:10)

### 24. Mitigation: cooldown — 0:55

[VERIFY: Dependabot cooldown / Renovate minimumReleaseAge の設定名・挙動]

So how do we defend? Here is some good news: there are things you can do even without knowing every low-level detail we just went through. I will not give you a checklist of ten tools. Instead, let me take two concrete **mitigations** — both easy to adopt today — and look honestly at what each one covers, and what it does not.

The first one: a cooldown. Don't adopt a new version on day zero. Wait until it has been public for a while. Dependabot and Renovate support this natively.

[→ step 2]

Why does this work? Many **compromised** releases are detected and pulled within days — remember, universal_file_viewer was retracted. A cooldown skips exactly that window. But it does not cover **malware** that stays unnoticed longer than your cooldown. And it does not protect whoever updates first — someone is always first. The trade-off: legitimate fixes, including **security** patches, also arrive late.

### 25. Mitigation: lockfile — 0:50

The second one: respect your **lockfile**. Build from exactly what pubspec.lock records — locally, and in CI too. Pub has a flag for this: `dart pub get --enforce-lockfile`.

[→ step 2]

Now no unintended version can enter the **build**, and every update becomes an explicit, reviewable diff — a pull request you can actually look at. But again, the limits. The **lockfile** does not cover a locked version that is already **malicious** — pinning a bad version just makes it reproducible. And it does not pin what a **hook** downloads at **build time** — that is the trust boundary we crossed earlier. The trade-off: updates become deliberate maintenance, and falling behind accumulates unpatched **vulnerabilities**.

### 26. No single checkbox — 0:45

And you can run this same exercise for every control. That is the real message: there is no single "supply chain protection" checkbox.

A **lockfile** covers unexpected updates — not **malicious** locked content. The pub content **hash** covers the **package** archive — not what the **hook** fetches later. **Source review** covers source behavior — but not every **dependency**, every time. Scanners catch known bad patterns — not **malicious** logic, reliably. **Sandboxes** control what crosses the boundary — not what happens inside it. **Provenance** tells you where the bytes came from — not whether the source is safe. Every tool has a boundary. Knowing the boundary is the point. That is **defense in depth**.

### 27. 606 again — 0:45

So let's come back to our number. Can we do this deep dive for all six hundred and six **dependencies**?

[→ step 2]

Honestly — no. It is not **feasible**, and I will not pretend it is. But investigating one **dependency** deeply taught me which questions matter. So: understand the mechanisms, then prioritize. Which **packages** have **build** **hooks**? Which ones ship **binaries**? Which ones download things? That enumeration can be mechanical. And AI helps here — not as a **security** decision maker, but as an investigation amplifier. It makes going one level deeper much cheaper. The questions, and the **risk** decision, are still yours.

### 28. Takeaways — 1:00

We went quite deep today — into the **package** mechanisms, and into **build** **hooks**. Of course, no developer can investigate every **dependency** this deeply. And we don't all need to become **security** specialists. So here is what I want you to take home.

One. Pick one thing. One mechanism you are curious about — in any ecosystem.

Two. Go one level deeper. Understand how it works, and where the **attack path** is — like we did today with **build** **hooks**.

Three. Share what you learn. A blog post, a talk, an issue, a tool. None of us can watch the entire **software supply chain** alone — but if we each bring one piece of knowledge, we raise the defense of the whole community.

(金の一行が出るのを待つ) Let's dig deeper together.

### 29. Thank you — 0:10

One last question to take home: if one of your **dependencies** was **compromised** — what would actually happen?

Thank you very much.

---

## 退避（非表示ページの旧台本）

旧 38 枚構成で使っていた台本。ページを復活させる場合はここから戻す。

### 旧 08. Attack path A

Let me generalize this story. We start with a legitimate **dependency**. Then the **maintainer**, the account, or the release process is **compromised**. A **malicious** version is published to the **package registry**. Our **dependency** resolution picks it up. And the **malicious** code reaches our environment. A **package** can be **trustworthy** today and **compromised** tomorrow. The important part is: where does it go from here?

### 旧 09. Two impact paths

There are two directions. The first one is our side. The developer machine and CI. If the code runs at **build time** or during development, the **attacker** can steal **credentials**, **tokens** and **secrets**, modify **source code**, **tamper** with the **artifact**, and **exfiltrate** data. A stolen CI **token** can also lead to **privilege escalation**. So **exfiltration** is often only the first step. The second one is the end user. **Malicious** **runtime** code is compiled into the app, shipped through the store, and runs on the user's device. The **severity** is different, and the victim is different. So we need to think about both in our **threat model**.

### 旧 13. Source, integrity, provenance

Then, how do we check a **dependency**? There are three different questions. **Source code** review asks: is this behavior acceptable? **Integrity** asks: are these the exact bytes I expected? That is what a **checksum** or a **signature** gives us. And **provenance** asks: where did these bytes come from? These are not the same thing. A **lockfile** is not **verification**. **Verification** is not **provenance**. And **provenance** does not tell you the source is safe.

### 旧 14. Attack path → mitigation

For each **mitigation**, I ask: which **attack vector** does it actually stop? Unexpected **package** updates: a **lockfile** and **dependency pinning** are **effective**. But they do not stop a pinned version that is already **malicious**. Code **execution** in CI: **least privilege**, fewer **secrets**, smaller **token** **permissions**. But code still runs inside that boundary. Code **execution** on my machine: **isolation** — a **sandbox**, a container, a VM. But everything inside the **sandbox** is still exposed.

### 退避: What can a hook do?（2026-09-27 に非表示化）

[VERIFY: 右列の答えは実測後に差し替える。現状は「問い」として提示する。]

A **hook** is a Dart program. So as a developer, I started asking questions.

When does it fire? Does it run for **transitive dependencies** too? What is the working directory? Which **environment variables** can it see? Can it access the file system and the network?

This is not unlimited **arbitrary code execution**. There are restrictions. But calling a compiler or an external tool is a legitimate use. So we should treat **build-time execution** as part of our **threat model**. To answer these questions, I read the documentation, I read the SDK **source code**, and I wrote a small **proof of concept**.

### 旧 16. Dart hooks

Dart has a feature called **hooks**. A **package** can include a **build** **hook** and a link **hook**. They are Dart programs inside the **package**. Today I look at the **build** **hook**.

### 旧 19. Follow one hook

I open the **package** in my pub cache. I find hook/build.dart. I read its imports and API calls. Does it start a process? Does it download something from the network? If yes, what is the downloaded **artifact**? Is there a **checksum** or a **signature** **verification**? And finally: where does this **artifact** go? Is it **executed** on my machine? Or is it bundled into my app as a **binary**? Each step is a new question.

### 旧 20. Demo

Let me show you what I actually saw. Here is the **hook** in the pub cache. Here it **executes** during a normal **build**. Here it starts a **child process**. And here it downloads an external **artifact**.

### 旧 23. Existing trusted path

If a new version suddenly adds a **hook** and a **shell command**, a **code review** may catch it. It stands out. But the hardest **malicious** update may not add any new capability. It may **exploit** a capability we already **trusted**. The diff can be zero.

### 旧 24. Baseline

An analyzer plugin that downloads a **binary**? Unusual. A **build** **hook** that downloads a native library? Probably legitimate. A formatter reading my SSH keys? Very unusual. The more powerful behavior is legitimate for a feature, the weaker it becomes as a **detection** signal. So before looking for **malicious** behavior, we must know the normal behavior.

### 旧 29. Android / iOS

On Android, a plugin pulls precompiled **artifacts** from Maven, and Gradle plugins run at **build time**. On iOS, CocoaPods and Swift Package Manager both have source and **binary** forms, and both have their own **build-time execution** mechanisms. The same thinking applies.

### 旧 30. Which dependency graph?

When someone says, "We locked our **dependencies**"... Dart has pubspec.lock. CocoaPods has Podfile.lock. Swift Package Manager has Package.resolved. Gradle has its own resolution. And a **hook** download is one more path. My question is: which **dependency** graph?

### 旧 31. Mitigation revisited

Going deeper added two more rows. **Artifact** substitution: pin a **hash**, verify a **signature**, check **provenance**. Prebuilt **binary** **risk**: inspect the **artifact**, prefer **reproducible builds** and a **trustworthy** publisher. We could only write these rows because we understood the mechanism.

### 旧 33. Assurance

I stopped asking, "Is this **package** safe?" I ask, "How much assurance do I need for this **dependency**?" A small utility, a **package** with a **build** **hook**, a closed-source **binary**. They are not the same. Our **review** effort should follow the **risk**. **Likelihood** times **impact**.

### 旧 35. AI

This is where AI helps. Not as a **security** decision maker. As an investigation amplifier. It explains unfamiliar code, traces call paths, and helps me design experiments. But I always verify: documentation, **source code**, experiment. The valuable part isn't the AI. It's the questions.

---

## 発音メモ（語彙リストからつまずきやすいもの）

大文字の音節に強勢を置く。

| 語 | 強勢 | 注意 |
|---|---|---|
| provenance | PROV-uh-nuhns | 「プロビナンス」ではなく第 1 音節に強勢 |
| integrity | in-TEG-ruh-tee | |
| authenticity | aw-then-TIS-uh-tee | |
| attestation | at-es-TAY-shun | |
| malicious | muh-LISH-us | |
| compromise / compromised | KOM-pruh-myz(d) | 最後は「マイズ」 |
| arbitrary | AR-bi-trer-ee | |
| exfiltrate / exfiltration | EKS-fil-trayt / eks-fil-TRAY-shun | |
| credential | kruh-DEN-shul | |
| privilege | PRIV-uh-lij | 3 音節 |
| mitigation | mit-i-GAY-shun | |
| severity | suh-VER-uh-tee | |
| likelihood | LYK-lee-hood | |
| transitive | TRAN-zuh-tiv | |
| typosquatting | TY-poh-skwot-ing | |
| artifact | AR-ti-fakt | |
| feasible | FEE-zuh-bul | |
| trustworthy | TRUST-wur-thee | th は濁る |
| threat | THRET | 「スレット」。treat と区別する |
| upstream / downstream | UP-streem / DOWN-streem | |
