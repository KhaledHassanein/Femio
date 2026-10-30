# Help now: sixteen countries with official sources (R6.16) — evidence, 2026-10-30

**What the owner asked** (dashboard note on `help-now`, 2026-10-30): sources from official websites,
not Facebook; at least ten countries beyond Egypt and Saudi Arabia; everyone else sent to find a
helpline.

**Method.** A Haiku subagent gathered candidate numbers and pages. The lead then fetched every cited
page itself (`scratchpad/verify_helplines.py`, `verify_rest.py`, firecrawl for the pages that refuse
plain fetches) and kept a number only when it appeared on a government portal, a national health
service page or the operator's own site. Status per number is in the `sourceUrl` comments of
`apps/web/src/lib/crisis/country-numbers.ts`.

| Check | Result | Evidence |
|---|---|---|
| Numbers verified | 37 numbers, 16 countries, each read on its `sourceUrl` on 2026-10-30; Egypt's two Facebook sources replaced (eao.gov.eg/faq, mohp.gov.eg) | `country-numbers.ts`; `pnpm crisis-lint` |
| Not shipped | Qatar 16003, Bahrain 80008006 (number not on the cited official page); Algeria, Tunisia, Iraq (no official page found) | header comment of `country-numbers.ts` |
| Arabic, 390×844, light | sixteen chips, Lebanon chosen: 140 (Red Cross) as emergency, 1564 as support, "Find a Helpline" line | `ar-light-lebanon.png` |
| Arabic, dark | same page in dark | `ar-dark-lebanon.png` |
| English | United Kingdom chosen: 999, 111, 0808 2000 247 (Refuge) | `en-light-uk.png` |
| French | France chosen: 15, 3114, 3919 | `fr-light-france.png` |
| Data test | 16 countries in order, exact number set, no social-media source, emergency first, names in four languages | `country-numbers.test.ts` (6 tests) |
| Gate | `pnpm gate` green: 689 unit tests, 22 guards (the untranslated-copy guard needed seven allow-list entries for words identical in French/Spanish: Qatar, Oman, France, Canada, Kuwait, Police, Violences Femmes Info) | session log `gate-r616.log` |

**Not verified:** Spanish page beyond the strings; the live site until deployed; the app's help
screen still lists Egypt and Saudi Arabia only (R6.17). Screenshots are synthetic (local dev server).
