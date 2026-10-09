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

Hello everyone. My name is Tsuyoshi. I'm really glad to have the chance to provide my talk in the last session of this event.

Today my talk is about **security** **risks** of **packages** in mobile app development.

### 02. About me — 0:50

Let me introduce myself first. I'm a Flutter developer.

I build and publish mobile apps — so I am a **package** user. And I develop and maintain Flutter **packages**, like crop_your_image and animated_to — so I am also a **package** author. I depend on other people's code, and other people depend on mine.

[→ step 2]

One thing I am not.

[→ step 3: 取り消し線]

I am not a **security** expert. I am someone who lives in the Flutter ecosystem every day, as a **package** user and as a **package** **maintainer**. So today, I will talk from that viewpoint. Not as an expert teaching rules, but as a developer who looked closely at the platform he uses every day.

### 03. 458 — 0:40

Let me start with a number. (カウントアップを待つ) Four hundred and fifty-eight. What does this number mean? (少し間を取る)

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

Now imagine one small **package**, deep in the graph, gets **compromised**. (線が My app まで流れるのを待つ) The **malicious** code travels **downstream**. Through Package C, into my app. And my app can be also compromized.

This is a **software supply chain** **attack**. And as I said, **dependencies** themselves are not the problem. But every **dependency** is a trust relationship, and every one of them increases our **attack surface**. 

### 06. Impact examples — 0:45

So, what actually happens when one of these attacks succeeds? Briefly saying, there can be two separated environments, Developers and CI, or end users. 

First, developers and CI side. The typical damage is stolen **credentials** — API keys, access **tokens**, cloud access. For example, if your GitHub access **token** is stolen, the **attacker** can access your private **repositories**, and your private **source code** leaks. And if the stolen **credentials** are for the **package registry**, **malicious** versions of your own **packages** can be published. This result in another incident in the supply chain.

[→ step 2]

Second, end users. The damage there is hard to enumerate. Because **Malicious** code ships inside your app and delivered through the store, the damage is anything your app can do on the device.

But in this session, let me focus more on the first one, developers and CI side in the rest of the presentation.

### 07. Real-world incidents — 1:50

This is not hypothetical. I picked up three cases of **incidents**, all from this year, in three different ecosystems.

First, npm. Legitimate Red Hat **packages**, under the namespace of redhat-claude-services, were **compromised** because of the **malicious** VSCode extension, and a **malicious** `preinstall` hook was added, which run right after installing by default at that time.

Second, PyPI. The publish **credentials** of LiteLLM and telnyx were **compromised**, and a version containing a **credential harvesting** malware was published. 

And the third one is from pub. Pub is not the exeption. A Flutter **package** called universal_file_viewer shipped **malicious** code last month. The **maintainer's** Mac was infected with a macOS **malware** called XCSSET, which mechanically injects itself into Xcode and Android projects it finds on the machine — and the package's example folder contained files and folders with exact the same structure as Xcode and Android project. The maintainer committed and published as usual without knowing the malicious code.

So this is not an npm-specific problem. We have to be aware no ecosystem is an exeption.

And what I want to enphasize looking at these case is that you did not need any deep low-level knowledge to follow these stories. From the incidents, you can understand what was **compromised**, how the code got **executed**, and what damage followed, as I did.

### 08. More than packages — 0:30

By the way, a **software supply chain** is more than **packages**. This list is based on the OWASP Software Supply Chain Security Cheat Sheet. Version control. **Build** tools. CI. IDE extensions. The **package registry** itself. Our development depends on all of them, and every one of them can be attacked.

[→ step 2]

But this 40-minute session cannot cover all of that, so today I focus on this one lane: **packages** and libraries.

### 09. Exists ≠ executes — 0:45

Even when **malicious** code gets inside your environment, that does not mean it automatically runs. There is no mysterious force that executes the code on its own. In other words, "The code exists" and "the code **executes**" are different — and that difference is exactly where the defense lives.

Again, thinking back to the **incidents**, **Attackers** did not suddenly run **arbitrary** code in some incomprehensible way. Typically, they abuse an **execution** mechanism the ecosystem itself provides. So knowing those mechanisms is exactly where the defense starts.

[→ step 2]

So the key question of this talk is: when can a **package** actually **execute** code?

---

## Part 3 — Execution surfaces (7:30–8:30)

### 10. Execution surfaces — 1:00

So far, everything I said applies to almost any ecosystem. From here, let me take Flutter and Dart as the example, and make it concrete. 

So, Dart **package** has several **execution** surfaces. (行の出現を待つ) Library code runs inside the app, at **runtime**. **Build** **hooks** run during the **build process**, as part of a normal `flutter build`. Analyzer plugins run during analysis — but only when you configure them explicitly, per **package**. Builders run when you run build_runner, which executes builders from all your **packages** together, so there is no per-package opt-in. 

[→ step 2]

And I want to dig more into this line, build hooks.

---

## Part 4 — Deep dive: build hooks (8:30–14:00)

### 11. Divider: Build hooks — 0:25

Now, here is how I want to spend the rest of this session. Instead of covering many topics broadly, I randomly picked one mechanism — **build** **hooks** — and I'll dig deep into it, and share my findings and insights.

Please keep one thing in mind: this process of digging deeper is transferable. The same approach works for any mechanism, in any ecosystem. So even though my examples are from Flutter, this is not a talk just for Flutter developers.

### 12. What build hooks do — 1:05

First, what are **build** **hooks**? It must be effective to know what it is and how it is used, before thinking about the security.

Just like Gradle or Swift Package Manager, it is a mechanism that lets a **package** inject its own work into the **build**. 

Because Flutter builds for many platforms — and shipping Android resources inside an iOS **build** would be wasteful. So instead of bundling everything in the **package** up front, a hook prepares just the right resources for the target platform, at **build time**.

[→ step 2]

So the typical uses are: compiling native code, preparing native assets, downloading prebuilt **binaries**, and so on based on the target platform.

### 13. Real hook code — 1:30

So I went and read what real **hooks** do, in published **packages**. I just randomly picked up some of them, and the code on the right is excerpted from the real hooks. We have three patterns.

Pattern one: download a prebuilt **binary**. The powersync **package** fetches its prebuilt SQLite core from GitHub releases, at **build time**.

[→ step 2]

Pattern two: run a native compiler. The objective_c **package** — published by dart.dev, compiles its bundled Objective-C sources with clang. A **child process**, started on my machine, as part of my build.

[→ step 3]

Pattern three: search the developer machine. The android_libcpp_shared **package** bundles the C++ **runtime** library for Android. It searches my local machine for an installed Android NDK, and bundles the appropreate resource into my app if found.

Those behavior is not suspicious itself. We can say that every one of these is completely legitimate. A **build** **hook** supplied by a **dependency** runs as a normal Dart program on my machine: doing network access, running **child processes**, reading the filesystem. We have to be aware that those capabilities become the **attack surface**.

### 14. Audit & versions — 0:45

Now, suppose I want to **audit** this surface. A **hook** is normal Dart code that usually consists of tens or some hundled lines, so I can read it, and find everything is fine.

[→ step 2]

But that check was valid for one version only. A new version can ship a brand-new hook, or can change an existing one — and it runs on your next **build**. And remember the **incidents** from earlier: this is exactly how a typical **supply chain** **attack** arrives — as a **malicious** update you pull in.

### 15. Package unchanged — 0:50

Yesterday: my **package**, version 1.4.2. Its **hook** downloads a tool from an external URL. Good **artifact**. Everything fine.

[→ step 2]

Today: same **package**. Same version. Same **hook** code, not a single byte of the package changed. But the **artifact** behind that URL can be replaced **upstream**. So my **build** input changed; even though my **dependency** did not.

That was one of my findings by digging into it.

### 16. Trust boundary — 0:55

[VERIFY: native asset ダウンロード時の標準の integrity 検証]

Let's follow the chain to see why. The pub **package** contains the **hook**. The hook points at an external URL. The URL serves an **artifact**. And the artifact is **executed** on my machine, or bundled into my app.

[→ step 2]

My **lockfile** pins the first half — the Dart **package**. But everything after that external URL is a different trust boundary, and the **lockfile** does not pin it. So for a downloaded **artifact**, it requires extra check: Is the URL versioned and immutable — or can the same URL start serving different bytes? Is a **hash** verified? A **signature**? And finally: is the artifact **executed** on my machine, or bundled into the app my users install? Each answer changes the **risk**.

---

## Part 5 — Beyond Dart (14:00–17:35)

### 17. Provenance — 0:25

One more question. In the previous slide, I showed you the hook's **source code** on GitHub. But is the **source code** on GitHub what my **build** actually uses?

[→ step 2]

No. Not necessarily. We have to know that pacakage authors, as well as attackers, can omit uploading source code when publishing packages. So an important point here is that you have to **audit** exactly what your **build** consumes. Reading the GitHub **repository** is not **sufficient**.

### 18. Inspect the packages — 0:40

And here is one good thing about the Dart ecosystem: you can read what your **build** consumes. Every hosted **package** your **build** resolved is already on your disk, in the pub cache.

And if a version is not in your cache yet, `dart pub unpack` fetches any package version into a local directory, without running anything.

[→ step 2]

So the exact set of **packages** that will run is always available to read. The exception is what we just saw: the **artifact** a **hook** downloads from outside. That one, you have to chase separately.

### 19. Deep dive recap — 0:35

Let me pause here and collect what this deep dive gave us. By digging into this one mechanism, three things became visible.

How its code gets **executed** — as part of a normal **build**. Which **attack surfaces** that opens — network, **child processes**, the filesystem, and the **artifact** behind a URL. And how to **audit** it — read the resolved source, re-check on every version, and chase what the **build** actually consumes.

They came from looking one level deeper.

### 20. Divider: Zoom out — 0:10

Now, let's widen the view again. Because the same questions are waiting everywhere else.

### 21. Same questions — 0:30

Every other surface deserves the same treatment. Analyzer plugins. Builders. DevTools extensions. Each surface has questions that we have to make it clear.

### 22. Beyond Dart — 0:35

And all of that was still Dart-only. Once we zoom out, a Flutter app has not only Dart **packages**, but also Android and iOS code inside. Plugins bring native **dependencies** through Gradle, CocoaPods and Swift Package Manager, so we have three more ecosistems. The **supply chain** does not stop at pub, and the same thinking applies at every layer.

### 23. Source vs binary — 0:40

Because at those layers, the form changes. Dart **packages** are distributed as **source code** — what I **review** is close to what I compile. CocoaPods source pods and SwiftPM source targets, the same. But a JAR or AAR from Maven, a vendored XCFramework, or a precompiled DevTools extension arrives as a **binary**.

[→ step 2]

And with a **binary**, a new question appears: is this the **source code** that produced the **binary** I actually consume? That is a question about **provenance** and **authenticity** — **code review** alone cannot answer it.

---

## Part 6 — Mitigation & close (17:35–21:10)

### 24. Mitigation: cooldown — 0:55

[VERIFY: Dependabot cooldown / Renovate minimumReleaseAge の設定名・挙動]

So how can we defend? 
Thanks to the investigations by security researchers, there are common and effective **Mitigations** you can do even without knowing every low-level detail. Let me describe some of them.

The first one: a cooldown. Its a practice not to adopt a new version on day zero. It is effective because many **compromised** releases are detected and pulled within days, and a cooldown enables us to update only safe versions by waiting and making sure no compromise detected. If you use Dependabot or Renovate, for example, you can activate this feature by configuring `cooldown` or `minimumReleaseAge` option.

[→ step 2]

But it is not the perfect solution. It does not cover **malware** that stays unnoticed, or left without fixes by the author, longer than your configuration. Also, the trade-off exists: legitimate fixes, including **security** patches, also arrive late.

### 25. Mitigation: lockfile — 0:50

The second one: respect your **lockfile**. Build from exactly what pubspec.lock records — locally, and in CI too. Pub has a flag for this: `dart pub get --enforce-lockfile`.

[→ step 2]

This enables to avoid unintended versions installed automatically. But again, the limits. The **lockfile** does not cover a locked version that is already **malicious**. And, as we have discussed in the build hook slide, it only ensures that the source code of the package has no change, but doesn't assure external artifacts retrieved at **build time** has no change. That is the difference of trust boundary we looked earlier.

### 26. No single checkbox — 0:45

And you can run this same exercise for every control. There is no single "supply chain protection" checkbox, which makes our security perfect.

A **lockfile** covers unexpected updates — not **malicious** locked content. The pub content **hash** covers the **package** archive — not what the **hook** fetches later. **Source review** covers source behavior — but not every **dependency**, every time. Scanners catch known bad patterns — not **malicious** logic, reliably. **Sandboxes** control what crosses the boundary — not what happens inside it. **Provenance** tells you where the bytes came from — not whether the source is safe. Every tool has a boundary. Knowing the boundary is the point. That is **defense in depth**.

### 27. 458 again — 0:45

And we can not forget the number, 458, the number of the **dependencies** that our apps tend to depend on. Can we do this deep dive for all four hundred and fifty-eight?

[→ step 2]

Honestly — no. It is not **feasible**. But investigating one **dependency** deeply taught me insights to understand the mechanisms, possible attack senario, which enable us to prioritize what to do. Which **packages** have **build** **hooks**? Which ones ship **binaries**? Which ones download things? 

Fortunately, AI helps our investigation in this AI era — not as a **security** decision maker, but as an investigation amplifier. It makes going one level deeper much cheaper.

### 28. Takeaways — 1:00

But still, diving into every one of the mechanisms of every one of the ecosystems one by one is not **feasible**, because we developers have to be interested in other businesses, such as introducing new features to our apps, enhanceing UX, earning money, etc. 

So here is what I want you to take home.

One. Pick one thing. One mechanism you are curious about — in any ecosystem.

Two. Go one level deeper. Understand how it works, and where the **attack path** is — like we did today with **build** **hooks**.

Three. This is important: share what you learn. A blog post, a talk, an issue, a tool. None of us can watch the entire **software supply chain** alone — but if we each bring one piece of knowledge, we raise the defense of the whole community.

### 29. GitHub

So, this is my turn. I've just prepared one GitHub Actions here. This is the action to publish this slide deck to GitHub Pages so that everyone can see the discussion later. 

### 30. Thank you — 0:10

That's all. I'll be glad if I see your own investigation and findings.
Thank you for listening.

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
