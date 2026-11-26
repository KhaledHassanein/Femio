# 03 — Legal pack for femio v3 (drafted 2026-10-27)

**Author:** Privacy and legal counsel session (Sonnet 5.5). **Approver:** Dr Khaled Hassanein, as owner and controller (`docs/runbooks/OWNER_ACTIONS.md`: no outside lawyer in the plan).
**This is not a lawyer's opinion.** It is a drafted pack built from primary texts where I could fetch them and from named secondary sources where I could not. Every claim carries a source tag; the tag key is at the end of §1. **[NEEDS SOURCE]** marks a claim I could not trace to a page I read. Nothing here was invented from memory.

**Placeholders the owner must fill before publishing** (all marked in the text): `[ENTITY]` = KM Digital Labs, Cairo, Egypt, plus legal form and registration number; `[EMAIL]` = a privacy mailbox on femioapp.com that really exists; `[DATE]` = effective date, default 2026-11-30; `[URL]` = final policy address, default `https://femioapp.com/privacy`.

---

## 1 · Regulatory note (one page)

**Facts this note rests on** (from `docs/compliance/PRIVATE_LAUNCH_V1.md` and `00_PLAN.md`, Checked by report 10): the Android release build declares no `INTERNET` permission and has no analytics, crash or ad SDK; the record is a file on the phone; there are no accounts. The website is a static export on Vercel with no database. Ordinary personal data still reaches Femio in one place: **web server logs (IP address and request details) held by the host**. Age gate: 18+.

| | Egypt | Saudi Arabia | EU (GDPR) | UK |
|---|---|---|---|---|
| **Law** | Law 151/2020 [E1]; Executive Regulations, Ministerial Decision 816/2025, issued 1 Nov 2025 [E2] | PDPL, Royal Decree M/19, amended M/148 [S1]; enforced from 14 Sep 2024 [S2] | Regulation (EU) 2016/679 [G1] | UK GDPR and Data Protection Act 2018 [U1] |
| **Does it reach us?** | The law covers electronic processing of personal data by a holder, controller or processor (Art. 1) [E1]. Sensitive data includes data on physical or mental health, and all children's data (Art. 1) [E1]. | Applies to processing in the Kingdom and to processing of residents' data by parties outside it (Art. 2(1)); health data is sensitive (Art. 1(11),(13)) [S1]. | Art. 3(2): only if we offer services to people in the EU or monitor them. Our stated markets are Saudi Arabia and Egypt, so targeting is weak. EU visitors are incidental. [G1] | Same test. UK visitors incidental. [U1] |
| **The app (health data never leaves the phone)** | Femio never obtains or holds the records, so it is not a "holder" (holds and retains) or "controller" (right to obtain data) on the law's definitions (Art. 1) [E1]. The Art. 12 licence for sensitive data is aimed at whoever collects, stores or processes it [E1]. **Argument is sound on the text but untested: I found no regulator guidance on on-device apps** [E3]. | Femio does not "collect" or process; the PDPL's duties (Art. 12 policy, 13 notice, 23 health-data controls, 29 transfer) attach to a controller that processes [S1]. The Art. 2(2) personal-use exclusion protects **her** own use, not the developer [S1]. | The household exemption (Art. 2(2)(c)) protects the individual. Recital 18 says the Regulation still applies to those who "provide the means" for such processing [G2]. Whether a developer who never sees the data is a controller turns on who decides purposes and means; the EDPB says access to data is not required to be a controller [G3]. Unsettled. | ICO's 2013 app guidance (secondary source) said a developer is unlikely to be a controller if the code runs solely on the device [U2]. Written under the repealed 1998 Act, so indicative only. |
| **The website (logs only)** | IP addresses are an "online identifier", so personal data (Art. 1) [E1]. Femio is controller of those logs. Hosting abroad may be a cross-border transfer needing a licence or permit (Art. 14) [E1]; a framework is "forthcoming" [E3]. | IP-based logs are plausibly personal data (Art. 1(4): data that can identify "indirectly") [S1]. Transfer abroad is governed by Art. 29 and the Transfer Regulation (adequacy, safeguards, impact assessment) [S1][S3]. | IP addresses are personal data (Art. 4(1), Recital 30) [G1]. Needs Art. 13 information and a lawful basis (legitimate interest for security logs). | Same. |
| **What remains** | Plain-language policy; a contact; 72-hour breach notice to the Centre for a personal-data breach (Art. 7) [E1]; DPO only if the controller is a legal entity [E3][E4]; children's data is sensitive, so 18+ only. | Privacy policy before collection (Art. 12) and notice (Art. 13) [S1]; breach notice to SDAIA (Art. 20) [S1]; 18+. | Art. 13 notice; breach to the authority within 72 h if risk (Art. 33) [G1]; Art. 27 representative exempt if processing is occasional, not large-scale special-category, and unlikely to cause risk [G4]; cookies: strictly necessary only, so no banner (Art. 5(3) ePrivacy, [PRIVATE_LAUNCH §4], not re-verified). | Same as EU; ICO 72 h. |

### What the "licensing from 31 Oct 2026" claim actually is (verified)

It is **not a new licensing law starting that day.** Law 151/2020 already prohibits collecting, storing or processing sensitive data without a licence from the Personal Data Protection Centre (Art. 12) [E1]. The issuing law (Art. 6) gives addressees **one year from the date the Executive Regulations are issued** to regularise their position [E1]. The Executive Regulations (Ministerial Decision 816/2025) were issued on 1 Nov 2025 and not publicly available until 25 Dec 2025 [E2]. So the grace period ends on **31 Oct or 1 Nov 2026** (Clyde & Co says 31 Oct; CMS says 1 Nov) [E3][E2]. CMS flags uncertainty over whether the Centre will treat the period as running to the end of 2026 [E2]. Licences last three years; fees depend on database size and small databases may be exempt; review takes up to 90 working days; foreign entities appoint a local representative [E2][E3]. Fines run EGP 200,000 to 5 million [E3]. The repo's earlier docs cited no source for the date; it is now sourced, but only to law-firm summaries. **The Executive Regulations' own text was not retrieved** [NEEDS SOURCE: Art. 2 licence-for-any-collection claim in PRIVATE_LAUNCH §2].

### Residual risks, stated plainly

1. **Untested theory.** "We hold no health data, so no sensitive-data licence" has no regulator ruling behind it in Egypt, Saudi Arabia, the EU or the UK. A regulator could read "provides the means" widely (GDPR Recital 18 wording [G2]; Egypt's "controller" definition includes specifying the method of processing [E1]).
2. **Web logs are real personal data** held on US-operated infrastructure. Vercel is a processor under its DPA, may process outside the visitor's country, and relies on SCCs and the Data Privacy Frameworks [V1]. Whether Egypt's Art. 14 or Saudi Art. 29 requires a permit for that is **[NEEDS SOURCE]**. Vercel's own page does not state log retention or location [V1]; plan-dependent retention is unverified.
3. **Entity status.** If KM Digital Labs is not a legal entity, the DPO duty (legal entities only [E3]) may not apply, but who the "controller" is for Saudi and Egyptian purposes is then the owner personally. Owner to confirm.
4. **Saudi controller register.** The PDPL lets SDAIA keep a national register of controllers (Art. 30(4)(c)) [S1]; whether it is mandatory for us is **[NEEDS SOURCE]**.
5. **Device-to-device transfer.** On Android 12 and later, `allowBackup="false"` stops cloud backup but may not stop a phone-to-phone transfer on some devices; `dataExtractionRules` with a `device-transfer` block is needed to stop both [A1]. The policy below says only what is true once that is set.
6. **Medical-device classification** in Saudi Arabia (SFDA) and Egypt (EDA) for fertility-prediction software was not verified; a third-party guide cites SFDA documents MDS-G23 and MDS-G27 but I could not confirm them [NEEDS SOURCE].
7. **Leaving the phone.** The backup file is one she saves herself. If she emails it, it is no longer on a device she controls; that is her act, and the policy says so.

### Breach plan for the website host (one box)

*What could leak:* IP addresses and request lines in host logs. *Worse case:* someone takes over the Vercel or Google Play account and publishes false legal text or a tampered app. *Do:* (1) Turn on two-factor sign-in on Vercel, Google Play, the domain registrar and the email account (owner action, 10 minutes). (2) On any notice from Vercel or Google, log the date, what was exposed and who is affected in a one-page incident log. (3) If it is only logs, the risk is low: record the decision and stop. (4) If personal data of Egyptian residents is exposed, notify the Centre within 72 hours (Art. 7) [E1]; Saudi: notify SDAIA on knowing of a breach (Art. 20; hour limits are in the Implementing Regulations, **[NEEDS SOURCE]**) [S1]; EU and UK: authority within 72 hours if there is a risk to people (Art. 33) [G1]. (5) If the app or site is tampered with, pull the Play release and redeploy the last good build.

### Source key (tags used above)

- **E1** Law 151/2020, English translation (unofficial, by a law firm; the Arabic Official Gazette text is authoritative): https://acc.com/sites/default/files/program-materials/upload/Data%20Protection%20Law%20-%20Egypt%20-%20EN%20-%20MBH.PDF
- **E2** CMS, Executive Regulations issued, one-year countdown: https://cms.law/en/are/legal-updates/egypt-s-pdpl-executive-regulations-issued-one-year-compliance-countdown-begins
- **E3** Clyde & Co, 21 Jan 2026: https://www.clydeco.com/en/insights/2026/01/egypt-regulatory-update-on-data-privacy (it does not address apps or on-device data)
- **E4** DLA Piper Egypt (DPO Art. 8, licence fees Art. 26): https://www.dlapiperdataprotection.com/?t=law&c=EG
- **S1** SDAIA, PDPL English text, read in full: https://sdaia.gov.sa/en/SDAIA/about/Documents/Personal%20Data%20English%20V2-23April2023-%20Reviewed-.pdf
- **S2** IAPP, enforcement from 14 Sep 2024, health-data articles of the Implementing Regulations: https://iapp.org/news/a/saudi-arabia-publishes-final-personal-data-protection-law
- **S3** Mayer Brown, transfer regulation: https://www.mayerbrown.com/en/insights/publications/2023/08/saudi-data-protection-law-updates-on-implementing-regulations-and-data-transfer--what-you-need-to-know (not fetched in full)
- **G1** GDPR text: https://eur-lex.europa.eu/eli/reg/2016/679/oj; **G2** Recital 18: https://gdpr-info.eu/recitals/no-18/; **G3** EDPB Guidelines 07/2020 (summary only; final text not read): https://www.dataprotection.ie/news-media/consultations/guidelines-072020-concepts-controller-and-processor-gdpr; **G4** Art. 27: https://gdpr-info.eu/art-27-gdpr/
- **U1** ICO territorial scope: https://ico.org.uk/media2/migrated/4031113/ic-327905-y2y5-knowledge-hub-territorial-scope.pdf (old; EU part out of date); **U2** Hunton on ICO app guidance: https://www.hunton.com/privacy-and-cybersecurity-law-blog/uk-ico-publishes-app-developer-guidance
- **V1** Vercel privacy notice: https://vercel.com/legal/privacy-policy; Vercel Web Analytics (no cookies, no IP stored per point, visitor hash discarded after 24 h): https://vercel.com/docs/analytics/privacy-policy
- **A1** Android Auto Backup: https://developer.android.com/identity/data/autobackup

---

## 2 · Privacy policy

> **Superseded 2026-11-24 (ADR-080).** The live text is `apps/web/messages/*.json` keys `privacy` and `healthData` (four languages); the review behind it is `docs/compliance/PRIVACY_REVIEW_2026-11-24.md`. The drafts below are kept for the record.

> **R14 truth pass, 2026-11-27** (audit `docs/33_REBUILD_V3/audit-2026-11-26/02-privacy.md`; R14.2 and R14.14). Changed in all four catalogues (`privacy`, `healthData`, `appDemo.privacy`), each sentence checked against the file named:
> - **Redaction (PRIV-1, JUDGE-3).** "Removes numbers, dates, names and contacts" is gone. Now: numbers, e-mail addresses and links are removed, she sees and edits the exact text before anything is sent, femio does not remove names, and a question about herself stays on the phone. Proof: `apps/mobile/lib/domain/assistant/redaction.dart` (`_email`, `_url`, `_digits`, `isAboutHer`); `ask_screen.dart` (editable text before send).
> - **What the record holds (PRIV-3).** Adds flow, discharge, sexual activity, basal body temperature, ovulation tests, and the health record (visits, labs, scans, medicines with dose marks and reminders, conditions, allergies, procedures, documents and photos). "No photos or files" becomes "sees only a photo or file you choose to add; no camera permission". Proof: `lib/domain/health_record.dart` (`RecordKind`), `log_vocabulary.g.dart` (`LogDimension`), `medicines.dart`, `record_attachment.dart`, `data/attachment_store.dart` (sealed with the record key), `AndroidManifest.xml` (no CAMERA permission).
> - **Birth year (PRIV-4).** It checks 18+ and shapes age-based guidance (TTC seek-help timing, tips, visit questions); a separate yes/no question, not saved, settles the edge year. Proof: `lib/domain/age_gate.dart`, `features/today/period_hero.dart`, `domain/assistant/personal_triggers.dart`, `domain/assistant/visit_summary.dart`; `app_en.arb` `eighteenSub`.
> - **Lock screen and widget (PRIV-5, PRIV-14).** Medicine-reminder words she writes show on the notification and lock screen; the widget shows the pregnancy week or next-period range once she turns details on; both are kept outside the encrypted file. Proof: `data/reminder_scheduler.dart` (`body: plan[i].label`), `android/.../widget/FemioWidgetProvider.kt` (plain `SharedPreferences`).
> - **Share and export (PRIV-7).** New list item: sharing a document or visit summary (plain copy to the app she picks, or the clipboard) and the unencrypted CSV saved where she chooses. Proof: `data/share_channel.dart`, `FilesChannel.kt` (`share`), `features/settings/csv_actions.dart`.
> - **Google's AI telemetry (PRIV-2, C2-C3).** "No analytics" becomes "no analytics of its own"; the technical-usage line now covers every use of Google's AI software, Cloud boost off included, with Google's own list of data types. Traffic is still **not verified** (owner action 33).
> - **Google Play in the summary (PRIV-8).** The summary names Google Play (installs, updates, ratings, payments) beside the AI.
> - **Consent receipt.** Stored inside her encrypted file on the phone, no femio copy, included in her backup. Proof: `data/profile.dart` (`cloudConsent`), `domain/assistant/cloud_consent.dart`.
> - **Cookie (PRIV-10).** Names `NEXT_LOCALE`, the next-intl session cookie holding only the language code. Proof: `apps/web/src/middleware.ts` (next-intl middleware); live header `Set-Cookie: NEXT_LOCALE=en; Path=/; SameSite=lax` (audit §6).
> - **Left for the owner:** console facts (paid tier, logging off; PRIV-6, owner actions 29-30), Vercel Analytics switched on and the effective date (PRIV-9, owner action 31). `apps/web/src/lib/legal/policy-truth.test.ts` now fails if a catalogue claims name removal again, drops `NEXT_LOCALE`, or loses a section the English text has.

*Publish at `[URL]` as an ordinary web page (Play rejects PDFs and geo-blocked pages) [P1]. Also link it inside the app (Settings). Opening a link in the phone's browser needs no `INTERNET` permission in the app.* Ready for `apps/web/messages/en.json` / `ar.json` under `privacy` once reshaped into heading/body pairs; sentences are full and ICU-safe.

### 2.1 English

**femio privacy policy** · Effective `[DATE]` · Version 1

**The short version**
- The femio app keeps your records **on your phone only**. We do not have a server for them. We cannot see them, and we cannot get them back for you.
- The femio app has no account and no sign-in. It shows ads on the guide screens only, through Google, and those ads never see your records. The app uses the internet for those ads and for nothing else.
- The femio website measures visits only if you allow it when asked, and it never records what you type into a calculator. Ads, if shown, appear only on article pages and only after you allow them.
- femio is for women aged 18 and over. The articles on the website are open to everyone.
- You can see, copy and delete everything the app holds, yourself, inside the app.

**Who we are.** femio is made by `[ENTITY]`, Cairo, Egypt (Dr Khaled Hassanein). Questions about privacy: `[EMAIL]`.

**What the app stores, on your phone**
When you use the app you may enter: your birth year (only to check that you are 18 or over), your language, your period and cycle dates, symptoms, mood, notes you type, weight, appointments, pregnancy and baby-movement logs, and contraction timer sessions. This is health information, so we handle it with care. It is kept in a private file that only the femio app can open. `[CONFIRM AT RELEASE: keep this sentence only if the encrypted store ships] The file is encrypted, and the key is held by your phone's secure hardware. [IF NOT SHIPPED, USE: The file is protected by your phone's own storage encryption. We do not add a second lock.]` `[CONFIRM AT RELEASE: only if app lock ships] You can switch on an app lock.`

**What the app does not collect**
No name. No email. No phone number. No contacts, photos or files. No analytics. No crash-report tool of our own. femio **never** sends your records off your phone. The one thing that leaves your phone is the ad request on the guide screens: Google's ads software sends Google your advertising ID, your device type and your internet address (which shows roughly where you are), and notes which ads were shown. It never receives your records, your cycle dates or what you read, and we ask for non-personalised ads. You can reset or delete your advertising ID in Android's settings. femio Plus removes the ads.

**Backups are files you save yourself**
femio can save a backup file when you ask. You choose where it goes: your phone's files, a cloud drive, an email. After that, the file is in your hands, not ours. It contains your records, so keep it somewhere private. We have switched off Android's automatic cloud backup for femio, so Google does not copy your records. `[CONFIRM: only if dataExtractionRules also set; see §1 risk 5] We have also blocked phone-to-phone transfer of the app's data.` If you lose your phone, or reset it, and you have no backup file, your records are gone. We cannot recover them.

**Reminders** are created on your phone. No server sends them.

**What Google may see.** You may install femio from Google Play. Google tells us totals, such as how many people installed the app or how many crashes happened, under Google's own policy. On the guide screens Google also serves the ads described above, under Google's advertising policy. Neither contains your records; femio never sends your records to Google.

**The website (femioapp.com)**
- **Records kept by our host.** Our host (Vercel) keeps ordinary server logs: your IP address, the time, the page you asked for, your browser type and the website you came from. We use them only to keep the site running and safe. We do not use them for advertising, and we do not combine them with anything else. Our host keeps them for a short period `[CONFIRM retention in Vercel dashboard]`. Our host may process them outside your country, using the legal safeguards it describes in its own privacy notice.
- **Measurement, only if you allow it.** When you first visit, we ask. If you press Allow, Google Analytics counts which pages are opened, in which language and country, which calculator was opened and whether the app link was clicked, and a Meta pixel counts page views so we can see whether our posts reach readers. We never send a date you tapped, a result you saw or anything you typed. If you press Only necessary, nothing is measured and no measurement cookie is set. To change your choice, clear this site’s cookies in your browser and we will ask again. *(ADR-075, 2026-10-28: Google Tag Manager with Consent Mode v2 defaulted to denied; a Google-certified consent banner; the closed event list in `docs/34_GROWTH_OPS/01_ANALYTICS_AND_PIXELS.md` §4.)*
- **Ads on article pages.** Some article pages may show ads served by Google AdSense, only after you allow them. We block sensitive categories, and we never place ads on the calculators, the help page or these legal pages.
- **Your browser's memory.** The site may remember your language and light or dark choice in your browser. It does not track you.
- **Calculators and search run in your browser.** What you type into a calculator is not sent to us.
- **Links to others.** Some pages link to other sites, such as medical sources and Find A Helpline. Their own policies apply. Our help link opens without telling the other site which page you came from.

**If you need urgent help.** femio is not an emergency service. See the "Need help now?" link in the app and on the site.

**Age.** femio's tracker is for women aged 18 and over. The app asks your birth year once and stops if you are under 18. We do not knowingly collect information from anyone under 18.

**Your rights, and how to use them**
Because your records are only on your phone, you hold them. In the app you can look at them, change them, save a copy (export) and delete everything (Settings, "Delete everything on this phone"). For the website's server logs, write to `[EMAIL]` and we will answer within 30 days. You may also complain to your data protection authority: the Personal Data Protection Centre (Egypt), SDAIA (Saudi Arabia), the ICO (United Kingdom) or the authority in your EU country.

**If this changes.** If we ever add online features that store anything about you, we will update this page first, tell you in the app, and ask you before anything is stored. We will keep old versions available.

**Contact:** `[EMAIL]` · `[ENTITY]`, Cairo, Egypt.

### 2.2 العربية (فصحى رسمية، بصيغة المؤنث)

**سياسة الخصوصية في femio** · تاريخ السريان `[DATE]` · الإصدار 1

**باختصار**
- يحفظ تطبيق femio سجلاتكِ **على هاتفكِ فقط**. ليس لدينا خادم لها، ولا نستطيع الاطلاع عليها ولا استرجاعها لكِ.
- لا يوجد في تطبيق femio حساب ولا تسجيل دخول. يعرض إعلانات في شاشات الدلائل فقط عبر Google، ولا تطّلع تلك الإعلانات أبدًا على سجلاتكِ. يستخدم التطبيق الإنترنت لهذه الإعلانات ولا لشيء غيرها.
- لا يقيس موقع femio الزيارات إلا إذا سمحتِ بذلك عند السؤال، ولا يسجّل أبدًا ما تكتبينه في أي حاسبة. والإعلانات، إن ظهرت، تظهر في صفحات المقالات فقط وبعد موافقتكِ.
- femio مخصص للنساء من عمر 18 عامًا فما فوق. أما المقالات في الموقع فمتاحة للجميع.
- يمكنكِ بنفسكِ، داخل التطبيق، الاطلاع على كل ما يحفظه وأخذ نسخة منه وحذفه.

**من نحن.** يُقدّم femio شركة `[ENTITY]` في القاهرة، مصر (د. خالد حسانين). للاستفسار عن الخصوصية: `[EMAIL]`.

**ما يحفظه التطبيق على هاتفكِ**
قد تُدخلين أثناء الاستخدام: سنة ميلادكِ (للتحقق فقط من أن عمركِ 18 عامًا أو أكثر)، ولغتكِ، وتواريخ الدورة الشهرية، والأعراض، والمزاج، وملاحظات تكتبينها، والوزن، والمواعيد، وسجلات الحمل وحركة الجنين، وجلسات مؤقّت الانقباضات. هذه معلومات صحية، ولذلك نتعامل معها بعناية. وهي محفوظة في ملف خاص لا يفتحه إلا تطبيق femio. `[تأكيد عند الإصدار: تُبقى الجملة فقط إذا صدر التخزين المشفّر] الملف مشفّر، ومفتاحه محفوظ في عتاد الهاتف الآمن. [وإلا فاستخدمي: الملف محمي بتشفير التخزين في هاتفكِ نفسه، ولا نضيف قفلًا ثانيًا.]` `[تأكيد عند الإصدار: فقط إذا صدر قفل التطبيق] يمكنكِ تفعيل قفل للتطبيق.`

**ما لا يجمعه التطبيق**
لا اسم، ولا بريد إلكتروني، ولا رقم هاتف، ولا جهات اتصال، ولا صور أو ملفات، ولا أدوات تحليل، ولا أداة تقارير أعطال خاصة بنا. لا يرسل femio سجلاتكِ خارج هاتفكِ **أبدًا**. الشيء الوحيد الذي يغادر هاتفكِ هو طلب الإعلان في شاشات الدلائل: يرسل برنامج إعلانات Google إلى Google معرّف الإعلانات الخاص بكِ ونوع جهازكِ وعنوان الإنترنت (الذي يدل تقريبًا على مكانكِ)، ويسجّل الإعلانات التي عُرضت. ولا يتلقى أبدًا سجلاتكِ ولا تواريخ دورتكِ ولا ما تقرئينه، ونطلب إعلانات غير مخصّصة. يمكنكِ إعادة تعيين معرّف الإعلانات أو حذفه من إعدادات Android. ويزيل femio Plus الإعلانات.

**النسخ الاحتياطية ملفات تحفظينها بنفسكِ**
يمكن لـ femio حفظ ملف نسخة احتياطية عندما تطلبين ذلك. وأنتِ من تختارين مكانه: ملفات الهاتف، أو مساحة سحابية، أو بريد إلكتروني. وبعد ذلك يصبح الملف في يدكِ لا في أيدينا. يحتوي الملف على سجلاتكِ، فاحتفظي به في مكان خاص. وقد أوقفنا النسخ الاحتياطي السحابي التلقائي في أندرويد لتطبيق femio، فلا تنسخ Google سجلاتكِ. `[تأكيد: فقط إذا ضُبطت dataExtractionRules أيضًا] كما منعنا نقل بيانات التطبيق من هاتف إلى آخر.` وإذا فُقد هاتفكِ أو أُعيد ضبطه ولم يكن لديكِ ملف نسخة احتياطية فستضيع سجلاتكِ، ولا نستطيع استرجاعها.

**التذكيرات** تُنشأ على هاتفكِ، ولا يرسلها أي خادم.

**ما قد تراه Google.** قد تثبّتين femio من متجر Google Play. تُعطينا Google إجماليات، مثل عدد مرات التثبيت أو عدد الأعطال، وفق سياستها الخاصة. وفي شاشات الدلائل تعرض Google أيضًا الإعلانات الموصوفة أعلاه، وفق سياستها الإعلانية. لا يتضمن أيٌّ منهما سجلاتكِ، ولا يرسل femio سجلاتكِ إلى Google أبدًا.

**الموقع الإلكتروني (femioapp.com)**
- **سجلات تحتفظ بها جهة الاستضافة.** تحتفظ جهة الاستضافة لدينا (Vercel) بسجلات الخادم المعتادة: عنوان IP، والوقت، والصفحة المطلوبة، ونوع المتصفح، والموقع الذي جئتِ منه. نستخدمها فقط لتشغيل الموقع وحمايته. لا نستخدمها للإعلان ولا نربطها بأي بيانات أخرى. وتحتفظ بها الجهة المضيفة مدة قصيرة `[تأكيد مدة الاحتفاظ من لوحة Vercel]`. وقد تعالجها خارج بلدكِ بالضمانات القانونية التي تصفها في إشعار الخصوصية الخاص بها.
- **القياس، فقط إذا سمحتِ به.** عند زيارتكِ الأولى نسألكِ. إذا ضغطتِ «سماح» تحسب أداة Google Analytics الصفحات التي فُتحت، وبأي لغة ومن أي بلد، وأي حاسبة فُتحت، وهل نُقر رابط التطبيق، ويحسب بكسل Meta مشاهدات الصفحات لنعرف هل تصل منشوراتنا إلى القارئات. لا نرسل أبدًا تاريخًا لمستِه ولا نتيجة رأيتِها ولا شيئًا كتبتِه. وإذا ضغطتِ «الضروري فقط» فلا يُقاس شيء ولا يُحفظ أي ملف تعريف ارتباط للقياس. ولتغيير اختياركِ احذفي ملفات تعريف الارتباط لهذا الموقع من متصفحكِ وسنسألكِ مرة أخرى.
- **إعلانات في صفحات المقالات.** قد تعرض بعض صفحات المقالات إعلانات من Google AdSense، وبعد موافقتكِ فقط. نحجب الفئات الحساسة، ولا نضع إعلانات في الحاسبات ولا في صفحة المساعدة ولا في هذه الصفحات القانونية.
- **ذاكرة متصفحكِ.** قد يتذكر الموقع لغتكِ واختيار الوضع الفاتح أو الداكن في متصفحكِ، ولا يتتبعكِ.
- **الحاسبات والبحث تعمل داخل متصفحكِ.** ما تكتبينه في أي حاسبة لا يُرسل إلينا.
- **روابط إلى جهات أخرى.** تحتوي بعض الصفحات على روابط إلى مواقع أخرى، مثل المصادر الطبية وFind A Helpline. تسري عليها سياساتها الخاصة. ويُفتح رابط المساعدة عندنا دون إخبار الموقع الآخر بالصفحة التي جئتِ منها.

**إذا احتجتِ إلى مساعدة عاجلة.** femio ليس خدمة طوارئ. انظري رابط «تحتاجين مساعدة الآن؟» في التطبيق وفي الموقع.

**العمر.** متابعة femio مخصصة للنساء من عمر 18 عامًا فما فوق. يسأل التطبيق عن سنة ميلادكِ مرة واحدة ويتوقف إن كان عمركِ أقل من 18. ولا نجمع عن قصد معلومات من أي شخص دون 18 عامًا.

**حقوقكِ وكيف تمارسينها**
لأن سجلاتكِ على هاتفكِ فقط، فهي بين يديكِ. يمكنكِ داخل التطبيق الاطلاع عليها وتعديلها وحفظ نسخة منها (تصدير) وحذف كل شيء (الإعدادات، «حذف كل شيء من هذا الهاتف»). أما سجلات خادم الموقع فراسلينا على `[EMAIL]` ونرد خلال 30 يومًا. ولكِ أيضًا أن تشتكي إلى سلطة حماية البيانات: مركز حماية البيانات الشخصية (مصر)، أو الهيئة السعودية للبيانات والذكاء الاصطناعي (SDAIA)، أو ICO (المملكة المتحدة)، أو السلطة في بلدكِ الأوروبي.

**عند أي تغيير.** إذا أضفنا يومًا خدمات عبر الإنترنت تحفظ شيئًا عنكِ، فسنحدّث هذه الصفحة أولًا، ونخبركِ داخل التطبيق، ونطلب موافقتكِ قبل حفظ أي شيء. وسنُبقي النسخ القديمة متاحة.

**للتواصل:** `[EMAIL]` · `[ENTITY]`، القاهرة، مصر.

---

## 3 · Terms of use

*Wording avoids the claims-lint words (diagnos*, cure*, treat*, prevent*, contracept*, "birth control"). I ran the English text against the lint patterns; see §9.*

### 3.1 English

**femio terms of use** · Effective `[DATE]` · Version 1

1. **What femio is.** femio gives you information and tools to record and understand your own health: a cycle and pregnancy tracker and a library of articles and calculators. It is for wellness, education and tracking.
2. **What femio is not.** It is not medical advice. It is not a medical device. It does not identify a medical condition, choose or change any medicine or care plan, or replace your doctor, midwife or pharmacist. Using femio does not create a doctor and patient relationship.
3. **Not a way to avoid pregnancy.** Fertile-window and cycle predictions are estimates. They do not stop a pregnancy from happening and must not be relied on to avoid one. If you do not want to become pregnant, speak to a clinician about a method that is meant for that.
4. **Estimates, with ranges.** Predictions are shown as ranges because bodies vary and your entries may be incomplete. A prediction can be wrong. Late or irregular cycles can have many causes; talk to a clinician if you are worried.
5. **Emergencies.** If you may be in danger or have urgent symptoms, call your local emergency number or go to the nearest emergency department. femio cannot call anyone for you and does not watch your entries.
6. **Who may use the app.** You must be 18 or older to use the tracker. The articles on the website are open to everyone.
7. **Your responsibilities.** Enter information truthfully for your own use. Keep your phone secure. Keep your backup files private. Do not copy, resell or take apart the app or the site, overload the site, or use either to harm anyone.
8. **Your records are yours, and on your phone.** We do not hold them, so we cannot restore them, move them or recover them. Save a backup if you want a copy.
9. **What we own.** The femio name, logo, software, design and original articles belong to `[ENTITY]`. Guidance we cite from medical bodies belongs to them and is credited. You may read and use femio for yourself; you may not copy our content for commercial use without written permission.
10. **Limits.** femio is provided as it is. We work hard to be accurate and we cite our sources, but no tool can know your situation, and decisions about your health are for you and your clinician. To the extent the law allows, `[ENTITY]` is not liable for loss caused by relying on femio instead of professional care. Nothing in these terms limits liability that the law does not allow to be limited, such as fraud or gross fault, or removes rights you have as a consumer.
11. **Changes and ending.** We may update these terms and the app. If a change matters to you we will say so in the app. You can stop using femio at any time by deleting everything and removing the app.
12. **Law.** These terms are governed by the laws of the Arab Republic of Egypt, and the competent courts of Cairo decide disputes, **except** that mandatory consumer rules of the country where you live still apply to you, including in Saudi Arabia, and nothing here stops you from using rights or courts that those rules give you.
13. **Contact:** `[EMAIL]`.

### 3.2 العربية

**شروط استخدام femio** · تاريخ السريان `[DATE]` · الإصدار 1

1. **ما هو femio.** يقدّم femio معلومات وأدوات تساعدكِ على تسجيل صحتكِ وفهمها: متابعة للدورة والحمل، ومكتبة مقالات وحاسبات. وهو للتوعية والتثقيف والمتابعة الصحية.
2. **ما ليس femio.** ليس نصيحة طبية، وليس جهازًا طبيًا. لا يحدّد حالة مرضية، ولا يختار دواءً أو خطة رعاية ولا يغيّرهما، ولا يحلّ محل طبيبتكِ أو طبيبكِ أو القابلة أو الصيدلانية. واستخدامه لا ينشئ علاقة طبيب ومريضة.
3. **ليس وسيلة لتجنّب الحمل.** توقعات الخصوبة والدورة تقديرات، وهي لا تمنع حدوث الحمل ولا يجوز الاعتماد عليها لتجنّبه. وإن كنتِ لا ترغبين في الحمل فاستشيري مختصة أو مختصًا في وسيلة مخصصة لذلك.
4. **تقديرات بنطاقات.** تُعرض التوقعات بنطاقات لأن الأجسام تتفاوت ولأن إدخالاتكِ قد تكون ناقصة. وقد يخطئ التوقع. وللتأخر أو عدم انتظام الدورة أسباب كثيرة، فاستشيري مختصة إن كنتِ قلقة.
5. **الطوارئ.** إذا كنتِ في خطر أو لديكِ أعراض عاجلة فاتصلي برقم الطوارئ المحلي أو توجّهي إلى أقرب قسم طوارئ. لا يستطيع femio الاتصال بأحد نيابةً عنكِ، ولا يراقب إدخالاتكِ.
6. **من يحق لها الاستخدام.** يجب أن يكون عمركِ 18 عامًا أو أكثر لاستخدام المتابعة. أما مقالات الموقع فمتاحة للجميع.
7. **مسؤولياتكِ.** أدخلي المعلومات بصدق لاستخدامكِ الشخصي، وحافظي على أمان هاتفكِ وعلى خصوصية ملفات النسخ الاحتياطي. ولا يجوز نسخ التطبيق أو الموقع أو إعادة بيعهما أو تفكيكهما أو إرهاق الموقع، ولا استخدامهما للإضرار بأحد.
8. **سجلاتكِ لكِ، وهي على هاتفكِ.** لا نحتفظ بها، ولذلك لا نستطيع استعادتها أو نقلها أو استرجاعها. احفظي نسخة احتياطية إن أردتِ نسخة.
9. **ما نملكه.** اسم femio وشعاره وبرمجياته وتصميمه ومقالاته الأصلية مملوكة لـ `[ENTITY]`. أما الإرشادات التي نستشهد بها من الجهات الطبية فهي ملك لها ونذكر مصدرها. يحق لكِ قراءة femio واستخدامه لنفسكِ، ولا يجوز نسخ محتوانا للاستخدام التجاري دون إذن كتابي.
10. **الحدود.** يُقدَّم femio كما هو. نجتهد في الدقة ونذكر مصادرنا، لكن لا أداة تعرف حالتكِ، والقرارات الصحية لكِ ولطبيبتكِ أو طبيبكِ. وبالقدر الذي يسمح به القانون، لا تتحمل `[ENTITY]` المسؤولية عن ضرر ناتج عن الاعتماد على femio بدلًا من الرعاية المهنية. ولا يحدّ أي بند هنا من مسؤولية لا يجيز القانون الحد منها، كالغش أو الخطأ الجسيم، ولا ينتقص من حقوقكِ بصفتكِ مستهلكة.
11. **التعديل والإنهاء.** قد نحدّث هذه الشروط والتطبيق، وإن كان التعديل مهمًا لكِ فسنبلغكِ في التطبيق. ولكِ التوقف عن استخدام femio في أي وقت بحذف كل شيء وإزالة التطبيق.
12. **القانون.** تخضع هذه الشروط لقوانين جمهورية مصر العربية، وتختص محاكم القاهرة بالنظر في المنازعات، **باستثناء** أن قواعد حماية المستهلك الآمرة في بلد إقامتكِ، ومنها المملكة العربية السعودية، تبقى سارية عليكِ، ولا يمنع أي بند هنا استعمال الحقوق أو اللجوء إلى المحاكم التي تقررها لكِ تلك القواعد.
13. **للتواصل:** `[EMAIL]`.

*Law note: Egyptian Civil Code limits on exclusion-of-liability clauses (fraud and gross fault) and consumer-protection Law 181/2018 are the reason for the carve-out in clause 10. I did not retrieve either text: **[NEEDS SOURCE]**. The carve-out is worded so it stays true whatever the exact article numbers are.*

---

## 4 · Google Play pack

### 4.1 Data safety form, line by line

> **Superseded 2026-11-24 (ADR-080):** current answers are in `docs/store/data-safety-and-declarations.md`.

Definitions (Google): to **collect** is to transmit data off the device, including by SDKs; **sharing** is transferring collected data to a third party; data processed only on the device and never sent off it need not be disclosed [P2].

| Console question | Answer for femio | Why |
|---|---|---|
| Does your app collect or share any of the required user data types? | **Yes** (since ADR-076, 2026-10-29) | Her records never leave the device, but Google's ads SDK transmits the advertising ID, app-set ID, IP address, ad interactions and diagnostics for advertising, analytics and fraud prevention (Google's own disclosure page for the SDK, read 2026-10-29). Google's definition of "collect" includes an SDK's transmission [P2]. The exact rows are in `docs/store/data-safety-and-declarations.md`. |
| Is all collected data encrypted in transit? | **Yes** | The only transmission is the ads SDK's, which Google documents as TLS-encrypted. |
| Do you provide a way for users to request data deletion? | **Yes**: Settings, "Delete everything on this phone". No server copy exists | Deletion badge needs a request mechanism [P2]. No account is created, so the account-deletion path rules do not apply [P3]. |
| Data types (Personal info, Health and fitness, Location, Contacts, Photos, Files, App activity, Device IDs…) | **Device or other IDs**; **Approximate location** (inferred from the IP address, which Play says must be disclosed); **App interactions**; **Diagnostics**: each collected and shared, for advertising (and analytics / fraud prevention for the SDK), required, not optional | What the ads SDK sends. **No Health and fitness, no Personal info**: her entries are processed on the device only [P2] and never given to the SDK; the tripwire forbids any network code of our own. |
| Security practices: data encrypted at rest | The form has no at-rest question. Say it in the policy only once the encrypted store ships | Policy wording is conditional (§2). |
| Independent security review | No | None done. |
| Privacy policy URL | `[URL]` (a web page, not a PDF, readable worldwide without login, also linked inside the app) | Required even when no data is collected [P2][P1]. |
| Families policy / apps for children | Not applicable; target audience 18+ | §4.4. |

*Confirm every question wording on the Console on the day; Google changes the form.* **Guard to add to CI (not written by me):** fail the build if the merged release manifest contains `android.permission.INTERNET` or any new dependency beyond `flutter`, `flutter_localizations`, `intl`, `path_provider`. The Data safety answer is only true while that guard holds.

### 4.2 Health apps declaration

Source: Play Console, Policy, App content, "Health Apps" [P4][P5]. Select **the features femio really has** (under-declaring is the risk):
- Health and fitness: **Period Tracking**.
- Medical: **Reproductive and Sexual Health** (conception and pregnancy tools: fertile window, contraction timer, baby-movement log) and **Medical Reference and Education** (the article library).
- Do **not** select "Medical Device Apps", "Clinical Decision Support" or "Disease Prevention". The app does not claim to identify, manage or reduce any condition. If the Console shows a second page of questions, answer from `01_PRODUCT_SCOPE.md`; the declared intended use is "wellness, education and tracking".
- If the Console offers "My app doesn't provide any health features", do **not** use it [P5].

### 4.3 The disclaimer Google requires

Apps not regulated as medical devices need a clear disclaimer **in the app description** with this wording, and a reminder to consult a healthcare professional [P6]:

> EN (store description, paste exactly): "femio is not a medical device and does not diagnose, treat, cure, or prevent any medical condition. femio is for wellness, education and tracking only. Always talk to your doctor or another health professional about your health."
>
> AR (store description): "تطبيق femio ليس جهازًا طبيًا، ولا يشخّص أي حالة طبية ولا يعالجها ولا يشفي منها ولا يقي منها. هو للتوعية والتثقيف والمتابعة الصحية فقط. استشيري دائمًا طبيبتكِ أو طبيبكِ أو أي مختصة أو مختص صحي في أمور صحتكِ."

**Lint conflict:** the Google sentence contains diagnose, treat, cure, prevent. Keep it in the store-listing file (not in `messages/*.json` or the ARB files) and give it a reviewed exception if the lint is ever extended to listings. The **in-app** disclaimer in §5 uses lint-clean words.

### 4.4 Target audience, content rating, account

- **Target age group: 18 and over only.** Tick "restrict minor access": users Google identifies as under 18 cannot find, download or buy the app [P7]. This keeps femio out of the Families policy. No youthful imagery in the listing (Google may reject it) [P7].
- **Content rating (IARC questionnaire):** answer literally and completely; misrepresentation can lead to removal [P8]. Hints: no violence, no gambling, no purchases, no user-generated content, no sharing of location, no chat. The health content is educational; answer the sexual-content question about **reproductive-health education**, not sexual content for entertainment. The page gives no expected rating and I do not guess one. [NEEDS SOURCE for which IARC category suits a health-reference app.]
- **Ads:** declare **"Yes, contains ads"** (ADR-076: Google AdMob banners on the guide screens only). **App access:** all features work without sign-in. **Government, news, financial apps:** no.
- **Closed testing (personal developer accounts created after 13 Nov 2023):** a closed test with **at least 12 testers opted in continuously for at least 14 days** before you may apply for production access; a tester who leaves and rejoins restarts the 14 days. Then press "Apply for production", describing the test, the app and its readiness. Google's review "usually takes about seven days" [P9]. (This closes the plan's `[NEEDS CHECK]` on review time.)

### 4.5 What commonly rejects health apps (each tied to a source or flagged)

1. Missing or inconsistent **Health apps declaration** [P6][P5].
2. **Privacy policy** that is a PDF, geo-blocked, behind login, not linked in the store listing **and inside the app**, or that does not cover this app [P1].
3. **Data safety answers that do not match the build** (an SDK or permission you did not declare) [P2].
4. **Missing non-device disclaimer** in the description [P6].
5. **Misleading or harmful health claims**, such as accuracy promises or "clinically proven" without evidence; claims that contradict medical consensus [P6]. Never write "safe days", "cannot get pregnant today" or "prevents pregnancy".
6. **Health permissions beyond need** (femio asks for none) [P6].
7. Closed-test requirement not met for a personal account [P9].
8. Youthful marketing on an 18+ app [P7].
9. Other common causes (metadata keyword stuffing, target API level, impersonation): **[NEEDS SOURCE]**, not verified in this session.

Sources: **P1** https://support.google.com/googleplay/android-developer/answer/9859455 · **P2** https://support.google.com/googleplay/android-developer/answer/10787469 · **P3** https://support.google.com/googleplay/android-developer/answer/13327111 · **P4** https://support.google.com/googleplay/android-developer/answer/13996367 · **P5** https://support.google.com/googleplay/android-developer/answer/14738291 · **P6** https://support.google.com/googleplay/android-developer/answer/16679511 · **P7** https://support.google.com/googleplay/android-developer/answer/9285070 · **P8** https://support.google.com/googleplay/android-developer/answer/9859655 · **P9** https://support.google.com/googleplay/android-developer/answer/14151465 (all read 2026-10-27).

---

## 5 · In-app strings (ARB keys; EN and AR)

All table strings are lint-clean in English (the commentary below the table quotes the banned phrase on purpose). Use Western digits and the Latin wordmark **femio** in Arabic (the current `app_ar.arb` writes "فيميو" in `under18Body`; change it, report 12 flags the split). No em-dashes.

| Key | English | العربية |
|---|---|---|
| `wellnessDisclaimer` | femio is a wellness and education tool for tracking your own health. It is not a medical device and does not replace your clinician. | femio أداة للتوعية والمتابعة الصحية الشخصية، وليست جهازًا طبيًا ولا تغني عن استشارة الطبيبة أو الطبيب. |
| `predictionNote` (every fertility and prediction surface) | Predictions are estimates, not guarantees, and must not be relied on to avoid pregnancy. | التوقعات تقديرات وليست ضمانات، ولا يجوز الاعتماد عليها لتجنّب الحمل. |
| `endometriosisFooter` | femio helps you track symptoms and get ready for a talk with your clinician. It cannot tell you whether you have endometriosis, what stage it is, or how to manage it. | يساعدكِ femio على تسجيل الأعراض والتحضير للحديث مع الطبيبة أو الطبيب. ولا يستطيع أن يخبركِ إن كنتِ مصابة ببطانة الرحم المهاجرة (الانتباذ البطاني الرحمي)، ولا أن يحدد مرحلتها، ولا أن يضع لكِ خطة للتعامل معها. |
| `backupHonesty` | Your records live only on this phone. If you lose or reset the phone, they are gone unless you have saved a backup file. We cannot recover them for you. | سجلاتكِ محفوظة على هذا الهاتف فقط. إذا فُقد الهاتف أو أُعيد ضبطه فستضيع السجلات ما لم تكوني قد حفظتِ ملف نسخة احتياطية. ولا نستطيع استرجاعها لكِ. |
| `deleteConfirmTitle` | Delete everything on this phone? | حذف كل شيء من هذا الهاتف؟ |
| `deleteConfirmBody` | This removes all your records and settings from femio on this phone. It cannot be undone, and we cannot restore it. Backup files you saved elsewhere are not deleted. | سيحذف femio جميع سجلاتكِ وإعداداتكِ من هذا الهاتف. لا يمكن التراجع عن ذلك ولا نستطيع استعادتها. ولن تُحذف ملفات النسخ الاحتياطي التي حفظتِها في مكان آخر. |
| `deleteConfirmAction` / `deleteConfirmCancel` | Delete everything / Keep my records | احذفي كل شيء / أبقي سجلاتي |
| `under18Body` (exists; AR wordmark fixed) | femio's tracker is for women aged 18 and over in this first version. Every guide on femioapp.com is open to you, with no account. | المتابعة في femio للنساء من عمر 18 عامًا فما فوق في هذا الإصدار الأول. وكل الأدلة على femioapp.com متاحة لكِ بلا حساب. |
| `firstRunStorageNotice` (new, shown once; replaces a consent step, see §7 row 21) | Your records stay on this phone. femio has no account and no server, and cannot see what you enter. | تبقى سجلاتكِ على هذا الهاتف. لا يوجد في femio حساب ولا خادم، ولا يستطيع أن يرى ما تُدخلينه. |
| `privacyLine` (exists) | Stored on this phone only. | محفوظ على هذا الهاتف فقط. |

**Mandated fertility sentence, two options.** `docs/compliance/*` require the exact words "Predictions are estimates, not guarantees, and are not a method of birth control." The claims lint bans "birth control" as a whole phrase. Default above: reworded with the same meaning. Alternative if the owner wants the verbatim sentence: add a reviewed per-key exception for `predictionNote` in `scripts/claims-lint.mjs` (the lint header allows this). The ARB files are not scanned today, so either option passes now.

---

## 6 · Crisis resources, Egypt and Saudi Arabia

Rules (from `docs/compliance/CRISIS_RESOURCES.md`): numbers only in country-specific content after re-verification; never promise cost, confidentiality, hours, language or dispatch; keep emergency services visually separate from support services; country and language are separate settings; re-check every 12 months. **I list numbers and operators only.** Accessed 2026-10-27.

| Country | Type | Service | Number | Official source read |
|---|---|---|---|---|
| Egypt | Emergency | Egyptian Ambulance Organization (ambulance) | **123** | The Organization's own page: https://www.facebook.com/EAO.Ambulance.Organization/ (official channel; a government website page was not retrieved). Reported by press 2026-06-03: https://www.youm7.com/story/2026/6/3/%D9%87%D9%8A%D8%A6%D8%A9-%D8%A7%D9%84%D8%A5%D8%B3%D8%B9%D8%A7%D9%81-%D8%A7%D9%84%D8%AE%D8%B7-%D8%A7%D9%84%D8%B3%D8%A7%D8%AE%D9%86-123-%D9%8A%D8%B9%D9%85%D9%84-%D8%B9%D9%84%D9%89-%D9%85%D8%AF%D8%A7%D8%B1-%D8%A7%D9%84%D8%B3%D8%A7%D8%B9%D8%A9-%D9%84%D8%AA%D9%84%D9%82%D9%89/7435398 |
| Egypt | Crisis / mental health | General Secretariat of Mental Health and Addiction Treatment hotline | **16328** | The Secretariat's page: https://www.facebook.com/GSMHATMOHEGYPt/ and the health-initiative site https://www.100millionseha.eg/happiness (listed in search excerpts; the Secretariat's own platform https://mentalhealth.mohp.gov.eg/mental/web/ar shows the hotline only as an image, so I could not read it there). The same Secretariat page lists 105 and 15335 as consultation lines: not shipped until read on an official page. |
| Egypt | Support, not crisis | National Council for Women, complaints office (legal and social advice) | **15115** | https://ncw.gov.eg/Page/385/%D9%85%D9%83%D8%AA%D8%A8-%D8%B4%D9%83%D8%A7%D9%88%D9%89-%D8%A7%D9%84%D9%85%D8%B1%D8%A3%D8%A9 |
| Saudi Arabia | Emergency | Saudi Red Crescent Authority (ambulance reports) | **997** | https://www.srca.gov.sa/contact-us/ |
| Saudi Arabia | Support | Ministry of Health call centre (medical consultations and reports) | **937** | https://www.moh.gov.sa/ministry/about/pages/contactus.aspx |
| Saudi Arabia | Crisis / mental health | Ministry of Health call centre for psychological consultations | **920033360** | https://www.moh.gov.sa/ministry/information-and-services/pages/psychiatry.aspx (the page attributes it to the Ministry's call centre; the brief called it the National Center for Mental Health Promotion, whose site is https://ncmh.org.sa/ and which does not state the number on the page I read) |
| Saudi Arabia | Support / safety | Family-violence reports centre, Ministry of Human Resources and Social Development | **1919** | https://www.hrsd.gov.sa/ministry-services/services/%D8%A7%D9%84%D8%A5%D8%A8%D9%84%D8%A7%D8%BA-%D8%B9%D9%86-%D8%A7%D9%84%D8%B9%D9%86%D9%81-%D8%A7%D9%84%D8%A3%D8%B3%D8%B1%D9%8A |

**Not shipped, [NEEDS SOURCE]:** Saudi 911 (described by secondary sites as a unified emergency number operating in some regions) and 999 (police): the official national portal https://my.gov.sa/en/emergency-contact blocked my fetch. Egypt 08008880700 (a Ministry of Health number quoted in press in 2023). Ship them only after someone reads the official page. Because emergency access differs by region, the screen must also show the global fallback below.

**Arabic labels for the screen:** الإسعاف (مصر) 123 · الخط الساخن للصحة النفسية، الأمانة العامة للصحة النفسية وعلاج الإدمان 16328 · مكتب شكاوى المرأة، المجلس القومي للمرأة 15115 · الإسعاف، هيئة الهلال الأحمر السعودي 997 · مركز اتصال وزارة الصحة 937 · الاستشارات النفسية، وزارة الصحة 920033360 · مركز بلاغات العنف الأسري 1919.

**Global fallback (verbatim from `docs/compliance/CRISIS_RESOURCES.md`; Arabic verbatim from `crisis.json`, owner-approved 2026-08-11):**

> If you may act on thoughts of harming yourself or someone else, or you are in immediate danger, contact the emergency services available where you are now or go to the nearest emergency department. You can also use [Find A Helpline](https://findahelpline.com/) to find a crisis service for your country. If you can, stay with someone you trust while you get help.
>
> إذا كنتِ قد تُقدِمين على إيذاء نفسكِ أو إيذاء شخصٍ آخر، أو كنتِ في خطر مباشر، فاتصلي بخدمات الطوارئ المتاحة في المكان الذي أنتِ فيه الآن، أو توجّهي إلى أقرب قسم طوارئ. إن استطعتِ، ابقي مع شخصٍ تثقين به إلى أن تحصلي على المساعدة.

**If you are worried about someone else (verbatim):** "If you think the person is in immediate danger, do not leave them alone if it is safe for you to stay. Contact the emergency services available where they are, a crisis service, a health worker, or a trusted family member." Arabic: see `worriedBody` in `crisis.json`.

---

## 7 · Compliance checklist mapped to report 10, Appendix A

Legend: **CLOSED** = this pack settles it on paper. **TEXT READY** = the text exists here; a build or owner step remains. **PARTLY** = advanced, not finished. Rows not listed are untouched by this pack (2, 20, 28, 31, 36, 37, 41–45, 49–54 except as noted).

| # | Item | Status after this pack | What is left |
|---|---|---|---|
| 5 | Crash-reporting decision for Android | **CLOSED (decision)**: no crash SDK in v1; Android vitals totals only (§2) | Owner accepts; policy says so |
| 7 | Backup honesty copy | **TEXT READY** (`backupHonesty`) | Build the backup screen |
| 8 | Delete all data (UI) | **TEXT READY** (`delete*`) | Build the dialog; add confirm (report 04 bug) |
| 9 | Privacy policy for v1 | **CLOSED (draft, EN+AR)** | Fill `[ENTITY]`, `[EMAIL]`, retention; load into `en.json`/`ar.json` |
| 10 | Terms of use for v1 | **CLOSED (draft, EN+AR)** | Same |
| 11 | Terms state not a contraceptive | **CLOSED** (clause 3, lint-clean) | Owner picks default or exception (§5) |
| 12 | Teen wording removed (18+) | **CLOSED** | Delete old `Teens and guardians` key |
| 13 | Play Data safety answers | **CLOSED (answers)** | Enter in Console; add the manifest guard |
| 14 | Play Health declaration | **CLOSED (answers)** | Enter in Console |
| 15 | Play non-device disclaimer | **CLOSED** (Google wording sourced, §4.3) | Paste into listing |
| 16 | In-app wellness disclaimer | **TEXT READY** | Place on health screens |
| 18 | Target audience 18+ | **TEXT READY** (§4.4) | Owner sets in Console |
| 19 | Play account type | **PARTLY**: personal account needs 12 testers × 14 days (§4.4) | Owner creates account |
| 21 | Consent step or documented exemption | **PARTLY**: reasoning in §1 (nothing is collected); `firstRunStorageNotice` is a notice, not a consent | Record as an ADR; owner confirms no separate consent screen |
| 22–24 | Egypt, Saudi, UK answers | **PARTLY**: regulatory note and residual risks (§1), not a lawyer's opinion | Owner accepts the risks; Egypt grace period ends 31 Oct or 1 Nov 2026 |
| 25 | Controller entity | **PARTLY**: placeholder `[ENTITY]` | Owner supplies legal form |
| 26 | Publishable privacy contact | **PARTLY**: placeholder `[EMAIL]` | Create the mailbox |
| 27 | DPO decision | **PARTLY**: recommendation: none for v1 unless `[ENTITY]` is a legal entity under Egypt Art. 8 [E4] | Owner confirms |
| 29 | Breach runbook for residual data | **PARTLY**: one-box plan (§1) | Fold into `BREACH_RUNBOOK.md`, fill roles |
| 30 | Processor register | **PARTLY**: v1 processors are Vercel (logs) and Google Play (totals); none touches health data | Update `PROCESSOR_REGISTER.md`; remove Stripe; confirm Vercel DPA accepted |
| 33 | Cookies essential only until consent (ADR-075) | **PARTLY**: policy states it; measurement cookies only after Allow | Verify the built site sets no cookie (next-intl may set `NEXT_LOCALE`) |
| 34 | Vercel Web Analytics statement | **PARTLY**: optional sentence in §2 | Decide on/off |
| 38 | Mandated prediction sentence | **TEXT READY** | Add to every fertility surface; extend a guard |
| 39 | Endometriosis footer | **TEXT READY** | Add where endometriosis content appears |
| 46 | Verified Egypt and Saudi numbers | **CLOSED** for 123, 16328, 15115, 997, 937, 920033360, 1919 (§6) | 911, 999, 08008880700 still **[NEEDS SOURCE]**; re-verify before launch |
| 47 | Crisis route in the app | **TEXT READY** (country table, labels, global fallback) | Build the route; country picker separate from language |

**Rows already done and relied on:** 1, 3, 4, 17, 32, 35, 40, 48, 54.

---

## 8 · Supporting tables (release gates, data map, processors, publishing steps)

### 8.1 Truth table: every promise in the policy and the check that proves it

A privacy policy that is wrong is worse than none (the FTC's Flo and Premom matters are in `HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`). Each promise below must be true on release day; the QA runbook (`05`) should run these.

| Promise in §2 | Check that proves it | Status today |
|---|---|---|
| "No permission to use the internet" | `aapt dump permissions` on the release AAB shows no `INTERNET`; CI fails if it appears | Main manifest Checked clean (report 10); release test missing |
| "No analytics or crash tool; ads only on guide screens, never reading her records" | `pubspec.yaml` carries Google's `google_mobile_ads` and nothing else that sends data; the tripwire forbids analytics, crash, attribution and mediation packages and any network code under `lib/` | Changed by ADR-076 (2026-10-29); the notice was rewritten the same day |
| "Google does not copy your records" | `allowBackup="false"` and `dataExtractionRules` (cloud and device transfer) in the manifest; install on a test phone, back up, restore, confirm the record is absent [A1] | `allowBackup` not set today (report 04) |
| "The file is encrypted" / "app lock" | Encrypted store and lock shipped in R4; unit test that the file on disk is not readable JSON | Not built; sentences stay conditional |
| "Delete everything" works | Widget test: confirm dialog, then store empty, then app returns to onboarding | `clear()` exists; UI unchecked |
| "Backups are files you save yourself" | Export and import round trip test; file carries no account or device identifier | Not built |
| "Calculators and search run in your browser" | Playwright guard: zero network requests to non-origin hosts while using a calculator | Planned in R2 |
| "No tracking cookies" | Crawl the built site and assert no `Set-Cookie` other than `NEXT_LOCALE` | next-intl sets the session cookie `NEXT_LOCALE` (live header, 2026-11-26); the policy names it since 2026-11-27 (R14.14) |
| "Help link does not tell the other site where you came from" | `rel="noopener noreferrer"`, `referrerPolicy="no-referrer"`, no query string (existing `directory.ts` build check) | Exists for the web (report 10 §3.8) |
| Host keeps logs "for a short period" | Read the retention for the Vercel plan in the dashboard and state the figure | Unknown; Vercel's pages conflict [V1] |

### 8.2 Data map for the v1 on-device record (input to `DATA_MAP.md`, row 20)

All fields: purpose = the feature the woman uses; lawful basis = not applicable to Femio (it never receives them); special category = yes (health); retention = until she deletes; processors = none; region = her phone; consent group = none required (nothing collected).

| Field | Where it appears | Note |
|---|---|---|
| Birth year | Onboarding | Age gate, and age-based guidance (TTC seek-help timing, tips, visit questions); no full date of birth (corrected 2026-11-27, PRIV-4) |
| Language | Onboarding / Settings | Not health data |
| Life-stage flag (e.g. after birth) | Profile | Health data |
| Cycle and period dates, flow | Log, Calendar | Health data |
| Symptoms, mood, free-text notes | Log | Free text can disclose anything, including risk (hence the crisis route) |
| Weight | Pregnancy tools | Health data |
| Appointments and visit questions | Appointments | Free text |
| Pregnancy logs, baby movements, contraction sessions | Pregnancy tools | Health data; no verdicts |
| App lock settings (R4) | Settings | Security setting |
| Discharge, sexual activity, basal temperature, ovulation tests | Log, Say it | Health data; sexual activity is "sex life" data (GDPR Art. 9) (added 2026-11-27) |
| Health record: visits, labs, scans, medicines with dose marks, conditions, allergies, procedures | My record (R11) | Health data; free text (added 2026-11-27) |
| Documents and photos | My record (R11.2) | Each file sealed with the record key; no camera permission (added 2026-11-27) |
| Medicine-reminder words, widget lines | Medicines, Settings | Opt-in; kept outside the encrypted file so Android can show them, so not encrypted (added 2026-11-27) |
| Cloud boost consent receipt | Settings, Assistant | Inside the encrypted record; travels in her backup (added 2026-11-27) |

### 8.3 Processor and recipient register for v1

| Party | Role | Touches health data? | Region | Agreement |
|---|---|---|---|---|
| Vercel | Host of the static site; processor of web logs | No | Provider processes in the US and elsewhere; SCCs and DPFs per its notice [V1] | Vercel DPA applies to the account `[owner confirms it is accepted]` |
| Google Play | Distribution; gives install and crash totals | No | Google | Google developer terms |
| Find A Helpline (ThroughLine) | Third party reached only if she clicks | No (no data sent by femio) | n/a | None; link terms analysis in `CRISIS_RESOURCES.md` |
| Supabase, Payload CMS, PostHog, Sentry (app) | Retired from runtime in v3 | n/a | n/a | Remove from the old register; Stripe row also removed (not available to the owner) |

### 8.4 Publishing steps (ten minutes each, in this order)

1. Fill the four placeholders at the top. 2. Create the mailbox `[EMAIL]` and test it. 3. Load §2 and §3 into `privacy` and `terms` message keys for en and ar, with the old keys deleted; remove `noindex`. 4. Add the effective date and version number to both pages. 5. Link the policy in the app (Settings) and in the Play listing. 6. Paste the store disclaimer (§4.3). 7. Run the §8.1 checks. 8. Turn on two-factor sign-in on Vercel, Google Play, the registrar and the mailbox. 9. Owner says "publish" (`OWNER_ACTIONS.md` item 4). 10. Put a re-check date in the calendar: crisis numbers and this pack, 2027-10-27, or earlier if the app gains any online feature.

## 9 · Verification, decisions for the lead, and what I could not source

**Checked:** the English text of §2.1, §3.1 and the §5 English strings were scanned against the exact patterns in `scripts/claims-lint.mjs` (diagnos*, cure(s), curing, treat(s), treating, treatment, prevent(s), preventing, contracept*, birth control): no hits. §4.3 (Google's sentence) contains the banned words by Google's requirement and is excluded on purpose.

**Decisions for the lead (defaults taken):** (1) wording of the mandated sentence, reworded by default (§5); (2) policy encryption and lock sentences are conditional on R4 shipping them; (3) add `dataExtractionRules` with `cloud-backup` and `device-transfer` excludes, not just `allowBackup=false` [A1]; (4) release-manifest guard for `INTERNET`; (5) if Sentry stays on the static site, the policy needs one more sentence: "Our site sends error reports with no personal content and no stored IP address."

**Could not source:** the Executive Regulations' own text, the Egypt licence-for-any-collection claim and fee waiver, Art. 14 permit for hosting abroad; Saudi Implementing Regulations hour limits and the register duty; Saudi 911 and 999; Egypt 08008880700, 105, 15335; Vercel log retention and region; SFDA and EDA classification; Egyptian Civil Code and Law 181/2018 articles; Play's IARC category; other Play rejection causes; EDPB final text and current ICO app guidance.
