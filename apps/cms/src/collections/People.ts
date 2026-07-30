import type { CollectionConfig } from "payload";
import { readPublishedOrStaff } from "../access/content";
import { isEditor, isStaff } from "../access/roles";

// Public bio pages for authors and medical reviewers (P1.9b.3b). Doc 15 §7/§8
// requires every published health page to name its author and its reviewer with
// credentials, each linked to a bio page carrying `Person` schema with `sameAs`
// professional profiles — this collection is that source of truth.
//
// Deliberately NOT built on `contentCollection`: a bio is not medical content, so
// it carries no sources/disclaimer/review-status fields and no medical-review gate.
// Drafts are still on, so a bio only becomes public when it is published.
export const People: CollectionConfig = {
  slug: "people",
  labels: { singular: "Person", plural: "People" },
  admin: {
    useAsTitle: "name",
    defaultColumns: ["name", "credentials", "_status", "updatedAt"],
    description: "Author / medical-reviewer bios shown on public bio pages.",
  },
  versions: { drafts: true },
  access: {
    read: readPublishedOrStaff,
    create: isEditor,
    update: isStaff,
    delete: isEditor,
  },
  fields: [
    // Localized because a name is transliterated per script (Arabic especially),
    // not because the person changes.
    { name: "name", type: "text", required: true, localized: true },
    { name: "slug", type: "text", required: true, unique: true, index: true },
    {
      name: "roles",
      type: "select",
      hasMany: true,
      admin: { description: "How this person appears on content (doc 15 §8)." },
      options: [
        { label: "Author", value: "author" },
        { label: "Medical reviewer", value: "medical_reviewer" },
      ],
    },
    {
      name: "credentials",
      type: "text",
      localized: true,
      admin: { description: "Post-nominals as they should be printed, e.g. “MD, MRCOG”." },
    },
    { name: "jobTitle", type: "text", localized: true },
    { name: "affiliation", type: "text", localized: true },
    {
      name: "bio",
      type: "richText",
      localized: true,
      admin: { description: "Short professional biography (expertise, experience)." },
    },
    { name: "photo", type: "upload", relationTo: "media" },
    {
      name: "sameAs",
      type: "array",
      labels: { singular: "Profile link", plural: "Profile links" },
      admin: {
        description:
          "Professional profiles used as `sameAs` in Person schema (registry entry, PubMed, LinkedIn, ORCID). Not localized.",
      },
      fields: [
        { name: "label", type: "text", required: true },
        { name: "url", type: "text", required: true },
      ],
    },
  ],
};
