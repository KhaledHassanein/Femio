import type { Field } from "payload";

// Shared E-E-A-T + review-workflow fields for every content collection
// (femio-medical-content). Workflow controls live in the sidebar.
export const editorialFields: Field[] = [
  {
    name: "reviewStatus",
    type: "select",
    defaultValue: "draft",
    admin: { position: "sidebar" },
    options: [
      { label: "Draft", value: "draft" },
      { label: "In medical review", value: "in_review" },
      { label: "Changes requested", value: "changes_requested" },
      { label: "Approved", value: "approved" },
    ],
  },
  {
    name: "medicalReviewer",
    type: "relationship",
    relationTo: "users",
    admin: { position: "sidebar", description: "Reviewer who approved this content." },
  },
  { name: "lastReviewed", type: "date", admin: { position: "sidebar" } },
  { name: "nextReviewDue", type: "date", admin: { position: "sidebar" } },
  {
    name: "readingLevelOk",
    type: "checkbox",
    label: "Reading level grade 6–8 verified",
    admin: { position: "sidebar" },
  },
  {
    name: "disclaimerType",
    type: "select",
    defaultValue: "general",
    admin: { position: "sidebar" },
    options: [
      { label: "General wellness", value: "general" },
      { label: "Screening (discuss with clinician)", value: "screening" },
      { label: "Emergency / red-flag", value: "emergency" },
      { label: "None", value: "none" },
    ],
  },
  {
    name: "sources",
    type: "array",
    labels: { singular: "Source", plural: "Sources" },
    admin: { description: "Tier-1/2 citations (femio-medical-content). Not localized." },
    fields: [
      { name: "title", type: "text", required: true },
      { name: "url", type: "text" },
      {
        name: "tier",
        type: "select",
        options: [
          { label: "Tier 1", value: "1" },
          { label: "Tier 2", value: "2" },
          { label: "Tier 3", value: "3" },
        ],
      },
    ],
  },
];
