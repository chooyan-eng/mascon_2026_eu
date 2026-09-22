# Talk Script — 20-minute version

`docs/slides.md` の 38 枚に対応する読み上げ台本。目安は毎分 120 語、合計 20 分。

- `[→ step N]` はキーを押して次の step に進めるタイミング。
- **太字** は `docs/security_english_vocabulary_handoff.txt` の語彙。本番で自然に出るよう、意識して発音練習する。
- `[TODO]` は内容が未確定の箇所、`[VERIFY]` は発表前に一次情報で確認する箇所。確認できるまでは断定しない言い回しにしてある。
- 各スライドの時間は目安。Part ごとの累計時間を見出しに書いてある。
- スライドの文言を変えたらここも合わせる。スライドの正本は `docs/slides.md`、話す内容の正本はこのファイル。

---

## Part 1 — Opening (0:00–3:00)

### 01. Title — 0:20

Hello everyone. My name is Tsuyoshi, and I came here from Japan.

Today I'd like to talk about the **security** **risks** of **packages** in mobile app development.

### 02. About me — 0:45

Let me introduce myself first. I'm a Flutter developer. I build and publish mobile apps. I also develop and maintain Dart and Flutter **packages**. And recently, I have been digging into **software supply chain** **security**.

[→ step 2]

I listed a few things, but what it really means is this. I am not a **security** expert. I am someone who lives in the Flutter ecosystem every day, as a **package** user and as a **package** **maintainer**. So today, I will talk from that viewpoint. Not as an expert teaching rules, but as a developer who looked closely at the platform he uses.

### 03. 606 — 0:30

Let me start with a number. Six hundred and six. Can anyone guess what this number means?

[→ step 2]

This is the number of **packages** and libraries that one of my production Flutter apps depends on. Dart, iOS and Android together. **Direct dependencies** and **transitive dependencies**.

### 04. Dependency graph — 0:50

And this is what it looks like. This is not an illustration. It is the real **dependency** graph of my app.

Right now you see only my **direct dependencies**. These are the **packages** I wrote in my pubspec file. Eighty-six of them.

[→ step 2]

And this is everything my **build** actually pulls in. Most of these are **transitive dependencies**. I never chose them. I never read their **source code**. But every one of them is part of my app.

(クリックして 1 つ選ぶ) If I click one **package**, you can see what it depends on, and who depends on it.

### 05. The risk of supply chain attacks — 0:35

So, what is the **risk** here? Let's make it simple.

[→ step 2]

Imagine one small **package**, deep in the graph, gets **compromised**.

[→ step 3]

Now the **malicious** code travels **downstream**. Through Package C, into my app. I never chose Package F. My app ships it anyway.

This is a **software supply chain** **attack**. **Dependencies** are not bad. They are the reason we can ship apps at all. But every **dependency** is a trust relationship, and every **dependency** increases our **attack surface**. This **risk** keeps growing, and that is my topic today.

---

## Part 2 — Overview: Dart / Flutter packages (3:00–8:30)

### 06. Software supply chain — 0:30

By the way, a **software supply chain** is more than **packages**. Compilers, **build** tools, CI, IDE extensions, the **package registry**. All of them are part of the chain.

[→ step 2]

But today, I focus on **packages** and libraries. Now, let's see what a real **compromise** looks like.

### 07. Real-world incident — 0:40

[TODO: 採用する事例が決まったら差し替える。以下は型。]

This is not **theoretical**. It has happened **in the wild**. And notice: this was not a **vulnerability** in the victims' own code. In this **incident**, an **attacker** took over a **maintainer** account. This is called an **account takeover**. Then the **attacker** published a **malicious** version of a popular **package**. Developers updated as usual, and the **malicious package** reached their machines. The **impact** was **credential theft** **at scale**, and for some companies, a real **breach**.

Other well-known **attack vectors** are **typosquatting** and **dependency confusion**. The entry is different, but the result is the same: **untrusted code** inside your project.

### 08. Attack path A — 0:40

Let me generalize this story.

[→ step 2–5 を 1 文ごとに進める]

We start with a legitimate **dependency**. Then the **maintainer**, the account, or the release process is **compromised**. A **malicious** version is published to the **package registry**. Our **dependency** resolution picks it up. And the **malicious** code reaches our environment.

A **package** can be **trustworthy** today and **compromised** tomorrow. The important part is: where does it go from here?

### 09. Two impact paths — 0:45

There are two directions.

The first one is our side. The developer machine and CI. If the code runs at **build time** or during development, the **attacker** can steal **credentials**, **tokens** and **secrets**, modify **source code**, **tamper** with the **artifact**, and **exfiltrate** data. A stolen CI **token** can also lead to **privilege escalation**. So **exfiltration** is often only the first step.

[→ step 2]

The second one is the end user. **Malicious** **runtime** code is compiled into the app, shipped through the store, and runs on the user's device. The **severity** is different, and the victim is different. So we need to think about both in our **threat model**.

### 10. Exists ≠ executes — 0:30

Here is one thing I want to separate clearly. A **compromised package** can sit in my pub cache. But **malicious** code that exists on my machine is one thing. **Malicious** code that **executes** on my machine is another. These are not the same.

[→ step 2]

So the key question is: when can a **package** actually **execute** code?

### 11. Attack surfaces — 0:40

Even a single Dart **package** has many **attack surfaces**.

Library code runs inside the app, at **runtime**. **Build** **hooks** and link **hooks** run during the **build process**. Analyzer plugins run inside the analysis server. Builders run during code generation. DevTools extensions run inside DevTools.

Same language, same **package**. But not the same **attack surface**. This is not a ranking. They are simply different **entry points**.

### 12. Surface triggers — 0:35

[VERIFY: 各 mechanism の発火条件と opt-in]

What matters for each one is two questions. When does it run? And did I opt in?

Some of them need explicit configuration. Some run only when I run a command. And some are part of the normal **build**. So the **likelihood** of **execution** is different for each surface. I will not go deeper here. Not yet.

### 13. Source, integrity, provenance — 0:40

Then, how do we check a **dependency**? There are three different questions.

**Source code** review asks: is this behavior acceptable? **Integrity** asks: are these the exact bytes I expected? That is what a **checksum** or a **signature** gives us. And **provenance** asks: where did these bytes come from?

[→ step 2]

These are not the same thing. A **lockfile** is not **verification**. **Verification** is not **provenance**. And **provenance** does not tell you the source is safe. Visibility is not the same as **integrity**.

### 14. Attack path → mitigation — 0:50

And finally, **mitigation**. I don't want to show a checklist. For each **mitigation**, I ask: which **attack vector** does it actually stop?

[→ step 1–3 を 1 行ごとに]

Unexpected **package** updates: a **lockfile** and **dependency pinning** are **effective**. But they do not stop a pinned version that is already **malicious**.

Code **execution** in CI: follow the principle of **least privilege**. Fewer **secrets**, smaller **token** **permissions**. But code still runs inside that boundary.

Code **execution** on my machine: **isolation**. A **sandbox**, a container, a VM. **Untrusted code** should be isolated whenever possible. But everything inside the **sandbox** is still exposed.

So that's the overview. **Risk**, **attack surface**, **verification**, **mitigation**.

---

## Part 3 — Deep dive: build hooks (8:30–15:00)

### 15. Overview is the easy part — 0:25

But honestly, the overview is the easy part. Anyone can say these words.

So now, let me pick one **attack surface** and go one level deeper. I chose **build** **hooks**. Watch how many new questions appear.

### 16. Dart hooks — 0:20

[VERIFY: version / lifecycle / build と link の役割差]

Dart has a feature called **hooks**. A **package** can include a **build** **hook** and a link **hook**. They are Dart programs inside the **package**. Today I look at the **build** **hook**.

### 17. Legitimate purpose — 0:35

First, **build** **hooks** exist for good reasons. They compile native code. They prepare native assets. They download prebuilt **binaries**. They integrate with the platform **build system**.

So please remember this: in a **build** **hook**, downloading a file and starting a process are not suspicious by themselves. They are the normal job. This becomes important later, when we talk about **detection**.

### 18. Execution model — 0:45

[VERIFY: 以下の問いへの答えは実測後に差し替える。現状は「問い」として提示する。]

A **hook** is a Dart program. So as a developer, I started asking questions.

When does it **execute**? Does it run for **transitive dependencies** too? Which **environment variables** can it see? Can it access the file system and the network? Can it start a **child process**? And what does that **child process** inherit?

This is not unlimited **arbitrary code execution**. There are restrictions. But calling a compiler or an external tool is a legitimate use. So we should treat **build-time execution** as part of our **threat model**. Asking these questions is basic **threat modeling**. To answer these questions, I read the documentation, I read the SDK **source code**, and I wrote a small **proof of concept**.

### 19. Follow one hook — 1:00

Then I took one real **package** and followed its **hook** all the way down.

[→ step 2–8 を 1 文ごとに]

I open the **package** in my pub cache. I find hook/build.dart. I read its imports and API calls. Does it start a process? Does it download something from the network? If yes, what is the downloaded **artifact**? Is there a **checksum** or a **signature** **verification**? And finally: where does this **artifact** go? Is it **executed** on my machine? Or is it bundled into my app as a **binary**?

Each step is a new question. And each answer decides the **impact** if something here is **compromised**.

### 20. Demo — 0:40

[TODO: 録画済みのターミナルキャプチャを差し込む。live は行わない想定。]

Let me show you what I actually saw. Here is the **hook** in the pub cache. Here it **executes** during a normal **build**. Here it starts a **child process**. And here it downloads an external **artifact**.

### 21. External artifact problem — 0:50

[VERIFY: native asset ダウンロード時の標準の integrity 検証]

So when a **hook** downloads an **artifact**, these are my questions. Is the URL versioned? Is it immutable? Is a **hash** verified? Is a **signature** verified? Is there **provenance** or an **attestation**? Is the **artifact** **executed**, or shipped inside my app?

[→ step 2]

And here is the point. My **lockfile** pins the Dart **package**. But the **artifact** that the **hook** downloads is in a different trust boundary. The **lockfile** does not necessarily pin it. The **source code** we can see is not always the **artifact** we actually use.

### 22. The package didn't change — 0:50

This leads to a second **attack vector**.

Yesterday: same **package**, same **hook**, good **artifact**.

[→ step 2]

Today: same **package**, same **hook**, **malicious** **artifact**. Same version. Same **source code**. Same content **hash** on pub.dev. Only the server **upstream** was **compromised**.

[→ step 3]

So I learned to ask: can this **dependency** change its behavior without changing itself?

### 23. Existing trusted path — 0:30

If a new version suddenly adds a **hook** and a **shell command**, a **code review** may catch it. It stands out.

But the hardest **malicious** update may not add any new capability. It may **exploit** a capability we already **trusted**. The diff can be zero.

### 24. Baseline — 0:40

And this makes **detection** difficult. An analyzer plugin that downloads a **binary**? Unusual. A **build** **hook** that downloads a native library? Probably legitimate. A formatter reading my SSH keys? Very unusual.

[→ step 2]

The more powerful behavior is legitimate for a feature, the weaker it becomes as a **detection** signal. So before looking for **malicious** behavior, we must know the normal behavior. That is why I say: understand the platform first.

### 25. Same for every surface — 0:25

That was one **attack surface** out of five. And I needed the documentation, the SDK source, real **packages**, and my own experiments to say just this much.

Every other surface deserves the same treatment. Understand the mechanism. Understand the **attack vector**. Then choose the **defense**.

---

## Part 4 — And then there is native (15:00–17:00)

### 26. Beyond Dart — 0:25

And all of that was only Dart.

[→ step 2–5]

A Flutter app has Dart **packages**. Some are Flutter plugins. Plugins bring Android and iOS **dependencies**. And those bring native **artifacts**. The **supply chain** continues into other ecosystems.

### 27. What does my build consume? — 0:15

So my rule is: don't **audit** what looks like your **dependency**. **Audit** what your **build** actually consumes. Reading the GitHub **repository** is not **sufficient**.

### 28. Source vs binary — 0:30

Because the form is different. Dart **packages** come as **source code**. What I **review** is close to what I compile. But a JAR, an AAR, or an XCFramework comes as a precompiled **binary**.

[→ step 2]

Then a new question appears: is this the **source code** that produced the **binary** I actually use? That is a question about **provenance** and **authenticity**, not about **code review**.

### 29. Android / iOS — 0:20

I won't go deep here. On Android, a plugin pulls precompiled **artifacts** from Maven, and Gradle plugins run at **build time**.

[→ step 2]

On iOS, CocoaPods and Swift Package Manager both have source and **binary** forms, and both have their own **build-time execution** mechanisms. The same thinking applies.

### 30. Which dependency graph? — 0:30

So when someone says, "We locked our **dependencies**"...

[→ step 2]

Dart has pubspec.lock. CocoaPods has Podfile.lock. Swift Package Manager has Package.resolved. Gradle has its own resolution. And a **hook** download is one more path.

[→ step 3]

...my question is: which **dependency** graph?

---

## Part 5 — Mitigation and reality (17:00–19:15)

### 31. Mitigation revisited — 0:35

[VERIFY: "Does not stop" 列の表現]

Let's go back to the **mitigation** table. Going deeper added two more rows.

[→ step 2]

**Artifact** substitution: pin a **hash**, verify a **signature**, check **provenance**.

[→ step 3]

Prebuilt **binary** **risk**: inspect the **artifact**, prefer **reproducible builds** and a **trustworthy** publisher.

We could only write these rows because we understood the mechanism.

### 32. No magic solution — 0:25

And there is no single perfect **mitigation**. A **lockfile**, a **hash**, a scanner, a **sandbox**, **provenance**. Each of them has a boundary. **Security** is about reducing **risk** in multiple layers. **Defense in depth**.

### 33. Assurance — 0:25

So I stopped asking, "Is this **package** safe?" I ask, "How much assurance do I need for this **dependency**?"

[→ step 2]

A small utility, a **package** with a **build** **hook**, a closed-source **binary**. They are not the same.

[→ step 3]

Our **review** effort should follow the **risk**. **Likelihood** times **impact**. That is a simple **risk assessment**.

### 34. All 606? — 0:25

Now, can we do this deep dive for all six hundred and six **dependencies**?

[→ step 2]

Honestly, no. It is not **feasible**. But investigating one **dependency** deeply taught me which questions matter. Tools can apply those questions broadly. And a human decides where deeper assurance is needed.

### 35. AI — 0:25

This is where AI helps. Not as a **security** decision maker. As an investigation amplifier. It explains unfamiliar code, traces call paths, and helps me design experiments.

[→ step 2]

But I always verify: documentation, **source code**, experiment. The valuable part isn't the AI. It's the questions.

---

## Part 6 — Takeaways (19:15–20:00)

### 36. Takeaways — 0:25

Three things to take home.

One. Understand your platform. If you don't know the mechanism, you don't know what you are trusting.

[→ step 2]

Two. Understand the **attack vector**. Where it enters, where it **executes**, who is affected.

[→ step 3]

Three. Choose the **mitigation** based on that understanding.

### 37. Go one level deeper — 0:15

So, pick one part of your own development environment, and go one level deeper. Ask yourself: if this **dependency** was **compromised**, what would actually happen?

### 38. Thank you — 0:05

Thank you very much.

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
