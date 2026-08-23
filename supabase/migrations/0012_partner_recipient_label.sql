-- ============================================================================
-- Femio — partner sharing: name the recipient at the moment of consent (P4.5b)
--
-- Art. 9(2)(a) requires *explicit* consent, and the design's own §1 spells out
-- what that means here: "the specific data and the specific recipient are named
-- at the moment of consent — not 'allow sharing' in a settings list."
--
-- 0011 delivered half of that. The categories are named and ticked individually,
-- but the **recipient was not named at all**: she generated a code and consent
-- attached to whoever redeemed it. That is granular consent, and it is not
-- explicit consent, because at the moment she agreed there was no identified
-- recipient to agree about.
--
-- So the invite now carries a label she writes herself — "Sam", "my husband",
-- "Dr Aziz". Three consequences, and the third is the one that matters:
--   1. The consent record names a person, which is what Art. 9(2)(a) asks for.
--   2. The "what they can see right now" panel can say *who*, which is the
--      question she actually has when she opens it months later.
--   3. **It is hers, not his.** He never sees it and cannot set it, so it cannot
--      become a field he asks her to change. Free text she wrote for herself is
--      the category §4 refuses to disclose, and this one is no exception.
--
-- Nullable, because 0011 rows exist and a NOT NULL would either reject them or
-- invent a name for a person Femio has never been told about.
-- ============================================================================

alter table public.partner_links
  add column if not exists recipient_label text;

comment on column public.partner_links.recipient_label is
  'What she calls the recipient, in her own words. Names the person for Art. 9(2)(a) explicit consent. NEVER disclosed to the recipient — partner_shared_rows does not read it.';

-- A length ceiling rather than a validation: this is a label, not a prose field,
-- and an unbounded text column she believes is private is an invitation to write
-- something that belongs nowhere near a disclosure feature.
alter table public.partner_links
  drop constraint if exists partner_links_recipient_label_len;
alter table public.partner_links
  add constraint partner_links_recipient_label_len
  check (recipient_label is null or char_length(recipient_label) <= 60);
