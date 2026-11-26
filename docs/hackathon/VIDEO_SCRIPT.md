# Demo video script (under 3 minutes, English, public on YouTube)

Agent doc; the owner reads it through `OWNER_GUIDE.html` section 12. Rewritten 2026-11-27 for R14.5
(JUDGE-8, UX-9, UX-10, UX-12, UX-17): it now shows one real Cloud boost run and the "What the AI did"
ledger. Button names are the app's English strings (`apps/mobile/lib/l10n/app_en.arb`); words in
quotes are what the screen says. Rules §6: at most 3 minutes are judged; the video must be public on
YouTube and show the app working on Android.

## Before recording

- **Phone A (Gemini Nano):** Settings → Assistant shows "AI on your phone (Gemini Nano)" with
  "Ready. It reads your notes on the phone; nothing is sent." Cloud boost "Off". A profile trying
  to conceive for 6 to 12 months, with a few days of cramps and tiredness logged.
- **Phone B (no Nano, or the emulator):** the **debug** build with `assistant.env`, its App Check
  debug token registered in the Firebase console (OWNER_ACTIONS row 25), Cloud boost not yet agreed.
  A release APK installed outside Google Play is expected to fail Play Integrity, so do not use it
  for the cloud shot.
- Record each phone with Android's Screen record (quick settings). Use only real captures: no
  synthetic test render anywhere in the video (UX-10).
- Device-test the two sentences below on Phone A first. Checked on 2026-11-27 against femio's
  rules only (synthetic run, no model): the rules find **Cramps** in sentence 1 and **nothing** for
  "my jeans will not button, I feel like a balloon"; that is the part Gemini Nano should add as
  **Bloating**. If Nano does not add it on the phone, pick another sentence the same way; never
  edit the chips by hand on camera.
- The Today status chip is R14.6 (another session). If it has not shipped when you record, use
  Settings → Assistant for shot 2 instead, and read the chip's words from the phone, not from here.

## Shots

| Time | Screen | Say |
|---|---|---|
| 0:00–0:12 | **Split diagram** (a slide, or the thumbnail's strip): left "On this phone · Gemini Nano · `ONLY_ON_DEVICE` · her record and her words"; right "Cloud boost · opt-in · `PREFER_ON_DEVICE` · an approved general question or four broad facts"; across the top "Safety rules first". | "femio is a women's health app where her record never leaves her phone. Firebase AI Logic lets us split the AI by how sensitive the data is: anything from her record runs on Gemini Nano, on the phone. The cloud is opt-in, and only for things that say nothing about her." |
| 0:12–0:22 | Phone A, **Today**: the status chip ("Gemini Nano · on this phone"). Tap it to open Settings → Assistant: "Ready", Cloud boost "Off. Everything is done on this phone." | "This chip always says where the AI runs. Here: Gemini Nano, on this phone. Cloud boost is off." |
| 0:22–0:52 | Phone A: tap **+** → "Tell femio anything, like “cramps since this morning”". Type *"cramps since this morning and my jeans will not button, I feel like a balloon"*. Tap **Turn into log entries**. Chips: **Cramps** and **Bloating**; the note "This runs on your phone. Your words are not saved or sent anywhere. Gemini Nano, the AI on your phone, helped with this." Tap **Save 2 entries on 1 day**. | "She writes one sentence instead of tapping through forms. femio's word rules found cramps. They don't know 'I feel like a balloon'; Gemini Nano, on the phone, adds bloating. She checks every chip, and nothing is saved until she taps Save. It also reads 'yesterday… today…' into separate days." |
| 0:52–1:20 | Phone A: Today → **Ask femio**. Type *"I'm 34 and my cramps are awful, what can I do?"*. Tap **Ask**. Show the label "Summarised on your phone by Gemini Nano, from the sources below", the numbered citations, then scroll to **Sources** (MedlinePlus, NICHD, each with its date). | "A personal question, so it stays on the phone. femio carries a library of passages from trusted public sources, like MedlinePlus and NIH. Nano may only summarise them and must cite them by number; an answer that cites nothing is thrown away and she reads the sources word for word." |
| 1:20–1:30 | Phone A: Ask *"heavy bleeding and dizzy"*. | "Safety rules run before any model. This shows ACOG's emergency guidance and the help page; no model is called." |
| 1:30–2:12 | Phone B: Settings → Assistant → **Cloud boost**. The consent screen: "What may be sent" with her own four values, "What is never sent", "Who receives it, and where". Tick the "General questions" box, tap **I agree**; show "You agreed on … to: General questions." Then Ask femio *"What helps with period cramps?"* → **Ask**. Show "This is exactly the question that will be sent, with the public sources:" and the editable text. Tap **Summarise with Cloud boost**. Show "Summarised by Google's cloud AI (Cloud boost), from the sources below". | "This phone has no Gemini Nano. She can opt in to Cloud boost: the screen shows her own values, who receives what, and one box per purpose. Her choice is saved as a dated receipt. Now a general question: femio removes numbers, e-mail addresses and links, and she sees and can edit the exact text. Only that text and the public passages go to the cloud model, protected by App Check, and the answer still cites its sources." |
| 2:12–2:32 | Phone B: Settings → Assistant → **What the AI did**: an entry "Sent with Cloud boost", open **Exactly what was sent**. Then back → **What the AI can see** for two seconds. (Phone A's list shows "On this phone (Gemini Nano)" entries.) | "Every model call is listed on her phone. For Cloud boost she keeps a receipt of exactly what was sent. And 'What the AI can see' lists, for each feature, the only things it receives." |
| 2:32–2:52 | Phone A: Settings → Assistant → turn off **Use the assistant** ("Off: femio answers from its rules and guides only. No AI runs, on the phone or in the cloud."). Log → **Say it in your words** (the "+" shortcut hides while the assistant is off), the same sentence → Cramps only. Today → Ask femio → "Word for word from trusted sources". | "And she can switch the AI off. No model runs anywhere, and every feature still works: rules log her words, and Ask femio shows the sources word for word. The AI is a companion, never the engine." |
| 2:52–2:58 | Today. | "femio. Private by design, hybrid by choice." |

## After recording

- Check the length is under 3:00, upload to YouTube as **Public**, English title
  "femio: private women's health app with hybrid AI (Firebase AI Logic, Gemini Nano)".
- Put the link in `DEVPOST_SUBMISSION.md` ("Video") and the Devpost form.
- The same captures replace the synthetic Ask store image (UX-9) and any Devpost gallery image.
