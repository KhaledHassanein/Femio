# ThroughLine (Find A Helpline) — link confirmation

Status: **draft, awaiting send** · Owner: Khaled (or DPO) · Ties to
`docs/compliance/CRISIS_RESOURCES.md § Directory policy`, ADR-013, P1.26.1

## Why this exists

Femio's crisis screen offers one optional outbound link to
<https://findahelpline.com>. Our reading of ThroughLine's Terms of Service is that
plain inbound hyperlinks are unrestricted and that their permission requirements
attach to the API, widgets, partner-branded subdomains, scraping and commercial
exploitation of their Services — none of which Femio does. That analysis is
recorded in `CRISIS_RESOURCES.md`.

One clause is written broadly enough to be worth closing in writing rather than by
interpretation: *"You must not, without ThroughLine's prior written permission: use
the Services for a commercial or business purpose."* It is aimed at use **of** the
Services, not at being linked to — but Femio is a commercial product, and a
one-line reply from them turns a reasonable reading into a documented fact. That is
a cheap trade for a safety-critical surface.

## What to send

To: hello@throughlinecare.com (confirm the current address on
<https://www.throughlinecare.com/contact>)
Subject: Linking to Find A Helpline from a women's-health app — confirmation request

> Hello,
>
> I'm the founder of Femio, a women's-health education and tracking app. We show a
> crisis-support screen that always leads with local emergency services, and we
> would like it to also offer one optional link to Find A Helpline so that someone
> who needs a helpline in their own country can find a maintained, verified list
> rather than whatever we could keep current ourselves.
>
> To be precise about what we are and aren't doing:
>
> - a single plain hyperlink to https://findahelpline.com, opened in a new tab;
> - no query string, parameters or deep links — our build actively rejects them;
> - no API use, no widget, no embedding, no copy or cache of your data;
> - no co-branding and no partner subdomain;
> - the link carries no referrer and we record nothing when it is used — we
>   deliberately collect no analytics on our crisis screen at all.
>
> Our reading of your Terms of Service is that this is ordinary inbound linking and
> needs no agreement, and that your permission requirements apply to the API,
> widgets, partner-branded sites and commercial exploitation of the Services. Since
> Femio is a commercial product, I would rather have your confirmation in writing
> than rely on my own reading.
>
> Could you confirm that a link of this kind is fine as-is? If you would prefer we
> use a partner arrangement or a different destination, please tell me and we will
> follow that instead — and if you would rather we didn't link at all, we will
> remove it; our crisis screen works without it.
>
> Thank you for maintaining the directory. It is the reason we could avoid shipping
> a stale phone-number list.
>
> [Name]
> [Role], Femio — [email]

## When a reply arrives

1. Paste the answer (or a link to the thread) under **Outcome** below, with the date.
2. Update `CRISIS_RESOURCES.md § Directory policy` to state that terms are
   confirmed, replacing the "residual question" paragraph.
3. Tell Claude Code — it closes **P1.26.1**'s commercial-terms half and removes the
   last engineering caveat on `NEXT_PUBLIC_CRISIS_DIRECTORY_URL`.

If they decline or ask for an agreement: unset `NEXT_PUBLIC_CRISIS_DIRECTORY_URL`
in Vercel and redeploy. The link disappears; the emergency-services route and the
rest of the crisis screen are unaffected (proven by an e2e test that runs with the
variable unset).

## Outcome

**2026-08-03 — Khaled approved keeping the link**, on the strength of the terms analysis in
`CRISIS_RESOURCES.md` (no restriction on inbound links; permission attaches to API/widgets/
partner subdomains/scraping/commercial exploitation *of the Services*, none of which Femio does).

⚠ **This is the owner accepting the residual risk, not ThroughLine's written confirmation.** The
email above has not been sent, so the "commercial purpose" clause remains closed by interpretation
rather than in writing. That is a defensible position — but if the DPO wants the file complete
before launch (P0.12), send it then; it costs one email and upgrades this record from a judgement
to a fact.

_Status: link stays live. Written confirmation optional, still recommended for the DPO file._
