# 28.12 — The other two, running

Same method as chapter 10: same emulator, same day. Shorter, because there is less
to find.

## 1. Pregnancy Tracker — could not be run

`com.teamthree.pregnancytracker` 1.0.20 ships a single ABI split,
`config.armeabi_v7a` — 32-bit ARM only. The emulator image (API 36.1, x86_64)
translates `arm64-v8a` but not `armeabi-v7a`, so the install fails:

```
INSTALL_FAILED_NO_MATCHING_ABIS: Failed to extract native libraries, res=-113
```

Dropping the ABI split fails differently — `INSTALL_FAILED_MISSING_SPLIT` — because
the base APK declares it as required.

**Options, none taken yet.** Download an older x86_64 system image with 32-bit ARM
translation (API 30 or below), or run it on a physical Android device. Neither is
worth doing on its own; chapter 03's decompiled analysis is thorough, the app is
small, unobfuscated and single-purpose, and its Kotlin metadata survived intact. The
things running it would add — how the eleven tools *feel*, the actual look of the
stock-template theme — are worth having but not worth a system-image download at this
point. **Recorded as open in chapter 11 §7.**

One thing running it would settle: whether `SuccessInterstitialAd` really fires an
ad after a kick-count session. That is worth confirming before it is quoted anywhere
outside this repository.

## 2. GO Flo — which is not called GO Flo

`com.go.flo` 1.1.9 installs and runs on the emulator, and Android greets it with its
own warning: *"This app was built for an older version of Android. It might not work
properly and doesn't include the latest security and privacy protections."*

Its display name is **Petal**, not Flo — the package name is the only place "flo"
appears. Its tagline is *"Best period tracker for ladies"*.

### The finding that matters: "Safe Period"

The home screen reads:

```
Aug 23
Safe Period
———
1
Days To Fertile
```

**It labels the day "Safe Period".**

That is a contraceptive claim. It is also medically false — there is no day on which
pregnancy is impossible, which is why every serious product in this category avoids
the word. Flo's equivalent copy is *"Low chance of getting pregnant"*, and Flo goes
further, attaching an explicit disclaimer to the number itself: *"Flo does not predict
your fertility status and cannot be used as a method of contraception or to aid
conception"* (chapter 10 §6a).

Femio's product rule 1 forbids this outright — never diagnose, treat, prevent
disease, or act as contraception — and the rule exists precisely to stay outside
FDA SaMD and EU MDR scope. **This screen is what the rule is protecting against, and
it should be quoted in `docs/13`.** It is a far better illustration than an abstract
statement of the rule, because it shows how casually the line gets crossed: not by a
deliberate medical claim, but by a two-word label on a home screen.

The same screen also says **"1 Days To Fertile"** — the plural is wrong, which is a
small thing that tells you how much review the copy received.

### The onboarding is better than the app deserves

Three questions, presented as a **stack of cards** — pink in front, yellow and blue
visibly behind it — each one a single question:

| Card | Question | Helper |
|---|---|---|
| 1 | How long is your period on average? | "Bleeding usually lasts 4–7 days" |
| 2 | How long is your cycle on average? | "The interval between two periods is usually 23–35 days" |
| 3 | When did your last period start? | a month calendar |

Each card has a horizontal number picker with the selected value ringed in a
hand-drawn circle, a ✓ to confirm, and **"I'm not sure"** as an underlined escape.
A persistent footer reads *"Make your best guess. You can always change it later."*

Three things here are genuinely good and worth taking.

**The card stack is the progress indicator.** You can see two more cards behind the
one you are answering. No progress bar, no step counter, no percentage — the physical
metaphor does the work. For a short wizard this is better than a bar, and it is the
opposite of Flo's 57 screens with a computed progress fraction.

**Every question carries its normal range as helper text**, so the user is told what
a typical answer looks like before answering. That is a small kindness and it also
improves data quality.

**"I'm not sure" and "make your best guess, you can always change it later"** remove
the pressure to be precise about something most people are not precise about. Flo has
the same idea (its "I don't remember" recovery screen) and spends four screens on it;
this does it in a sentence.

### What comes immediately after

Two screens after the welcome, before any value is delivered, a **social sign-in wall**:
Continue with Twitter / Instagram / Facebook / **Google+** — a service shut down in
2019, which dates the build. Consent is bundled into the button as *"By continuing,
you agree to our Terms and Privacy Policy"*, rather than separated into checkboxes
the way Flo does it.

And immediately after setup completes, before the home screen:

> **"Allow Petal to access contacts and accounts on this device?"**
> *This app will be able to access your contacts and see the list of your accounts
> that can save contacts.*

A period tracker asking to read your contacts, with no explanation offered. This is
the `GET_ACCOUNTS` permission from chapter 04 §3, live, in context, at the moment of
least suspicion. Nothing in the product needs it.

### The rest of it

The home screen is an arc — a curved path with a "Today" marker travelling along it,
pink for the period segment, orange for the fertile segment, an arrow pointing
forward — over a large slate-blue field. It is a distinctive metaphor and it is
undermined by the label on it.

Bottom nav is four tabs: **Petal · Record · Analysis · Me**. A "reset info" button
sits on the home screen itself, which reads like a debug affordance that shipped.

## 3. What these two add to the study

**For `docs/13` and the compliance pack.** Two concrete artefacts: the "Safe Period"
label, and a contacts permission prompt in a menstrual tracker. Both are more
persuasive than any restatement of product rules 1 and 4.

**For onboarding (OD-6).** Petal's three-card stack is the shape of a short,
comfortable, honest onboarding: one question per card, the normal range as helper
text, an "I'm not sure" escape, and the stack itself as the progress indicator. Flo
shows what a long onboarding buys and costs; this shows what a short one can be.
Femio's should be nearer this end, with Flo's answer-then-respond rhythm layered on
top and none of its selling.

**For the standing rule.** Neither app changes the parity picture from chapter 06.
The pregnancy tracker's contribution remains its eleven tools and its
three-registers-per-week content model; Petal's remains as a cautionary case.
