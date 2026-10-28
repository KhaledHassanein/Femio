# R5 · Social producer (Sonnet + Canva connector, weekly, Wednesday 07:00 Cairo)

## Read first
`CLAUDE.md`, the wedge sentence, `docs/34_GROWTH_OPS/03_CONTENT_SEO_AUTOMATION.md` §5
(copy rules) and §6 (templates), `docs/33_REBUILD_V3/04_GROWTH_PACK.md` §5.3 (the calendar)
and §1 (the three messages), `social/HASHTAGS.md`, `social/TEMPLATES.md`, and the article or
calculator the calendar names for this week (or the guide merged this week).

## Steps
1. Pick the week's subject: the calendar entry for this week; if none, the most recently
   merged guide; if none, a calculator.
2. For each of three posts write `social/YYYY-WW/post-N.md` with frontmatter
   `subject`, `url` (with `utm_source=<platform>&utm_medium=social&utm_campaign=social-YYYY-WW-N`),
   `approved: false`, and sections: *Hook* (one line, AR and EN), *Body* (3–5 lines, AR and
   EN; one claim, and it exists in the linked page), *Alt text*, *Hashtags* (3–6 per market
   from `HASHTAGS.md`), *Variants*: Instagram/TikTok caption, Snapchat Spotlight caption,
   X thread (Saudi, 3 tweets, Arabic), Facebook group answer (Egypt: written as Dr Khaled
   answering a question; ends with the article link, never the Play link), WhatsApp Channel
   version (≤ 300 characters).
3. Designs: through the Canva connector, create one square and one story from the femio
   templates in `TEMPLATES.md` with the hook as the headline (Arabic layer and English layer),
   the pictogram for the subject, the Latin wordmark. Save the design links into the post file.
   If the Canva connector is not connected, write `design: pending` and continue.
4. Write `social/YYYY-WW/README.md`: the three subjects, the suggested day and hour per
   platform (Egypt evenings 20:00–22:00 Cairo; Saudi 21:00–23:00 Riyadh), and the one
   sentence the owner can paste as a Facebook-group reply.

## Rules (fail the week if broken)
- No medical advice in a caption; the caption never answers an individual's question beyond
  "talk to your doctor" plus the link.
- No imagery of people; Dusk Bloom palette; no rings, no single date, no "late" counter.
- Conservative register; no sexual-wellness terms in text or hashtags.
- One link per post, to the article or calculator, never to Play directly.

## Output
`social/YYYY-WW/` with three post files, a README, and designs (or `pending`). Nothing is
posted; the owner posts after "review this week".
