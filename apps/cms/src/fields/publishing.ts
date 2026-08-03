import type { Field } from "payload";

/**
 * Public authorship + SEO fields for health content (P1.6.6).
 *
 * Separate from `editorialFields` on purpose: those are the **workflow** (who
 * may approve, when it was reviewed), while these are what the **public page**
 * shows and what search engines read. Doc 15 §8 requires every published health
 * page to name its author and its medical reviewer with credentials, linked to
 * their bio — and the `users` relationship in the workflow fields cannot do that
 * job, because a CMS login is not a public identity and its email must never
 * become a byline.
 */
export const publishingFields: Field[] = [
  {
    name: "authors",
    type: "relationship",
    relationTo: "people",
    hasMany: true,
    admin: {
      position: "sidebar",
      description: "Public byline(s). Shown on the page and in Article schema.",
    },
  },
  {
    name: "medicalReviewerProfile",
    type: "relationship",
    relationTo: "people",
    admin: {
      position: "sidebar",
      description:
        "The clinician shown publicly as reviewer. Separate from the workflow reviewer above, which is the account that approved it.",
    },
  },
  {
    // Set on first publish and kept thereafter, so an edit doesn't reset the
    // article's age — `datePublished` and `dateModified` are different signals
    // and search engines treat them differently.
    name: "firstPublishedAt",
    type: "date",
    admin: { position: "sidebar", description: "Set automatically on first publish." },
  },
  {
    name: "seo",
    type: "group",
    admin: { description: "Search + social. Leave blank to fall back to the page's own copy." },
    fields: [
      {
        name: "seoTitle",
        type: "text",
        localized: true,
        admin: { description: "~30–60 characters. Editable separately from the H1." },
      },
      {
        name: "metaDescription",
        type: "textarea",
        localized: true,
        admin: { description: "~120–160 characters, unique per page, written for a human." },
      },
      {
        name: "canonicalOverride",
        type: "text",
        admin: {
          description:
            "Exceptional cases only — the canonical is generated from locale + slug by default.",
        },
      },
      {
        name: "noIndex",
        type: "checkbox",
        defaultValue: false,
        admin: { description: "Keep this page out of search results." },
      },
      { name: "socialTitle", type: "text", localized: true },
      { name: "socialDescription", type: "textarea", localized: true },
      {
        name: "socialImage",
        type: "upload",
        relationTo: "media",
        admin: { description: "1200×630. The Media record needs localized alt text." },
      },
    ],
  },
];
