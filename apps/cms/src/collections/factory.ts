import type { CollectionConfig, Field } from "payload";
import { readPublishedOrStaff } from "../access/content";
import { isEditor, isStaff } from "../access/roles";
import { editorialFields } from "../fields/editorial";
import { publishingFields } from "../fields/publishing";
import { enforceReviewGate } from "../hooks/review-gate";

// All content collections share the same shape: a localized title, a shared
// (non-localized) slug, collection-specific body fields, then the editorial /
// review fields — plus drafts + the review gate. This factory keeps the five
// collections consistent and small.
export function contentCollection(args: {
  slug: string;
  titleName?: string;
  titleLabel?: string;
  labels?: { singular: string; plural: string };
  bodyFields: Field[];
  /**
   * Public authorship + SEO fields (P1.6.6). Opt-in: they belong on long-form
   * health pages that carry a byline, not on a glossary term or a one-line tip.
   */
  publishing?: boolean;
}): CollectionConfig {
  const titleName = args.titleName ?? "title";

  return {
    slug: args.slug,
    labels: args.labels,
    admin: {
      useAsTitle: titleName,
      defaultColumns: [titleName, "reviewStatus", "_status", "updatedAt"],
    },
    versions: { drafts: true },
    access: {
      read: readPublishedOrStaff,
      create: isEditor,
      update: isStaff,
      delete: isEditor,
    },
    hooks: { beforeChange: [enforceReviewGate] },
    fields: [
      { name: titleName, label: args.titleLabel, type: "text", required: true, localized: true },
      { name: "slug", type: "text", required: true, unique: true, index: true },
      ...args.bodyFields,
      ...(args.publishing ? publishingFields : []),
      ...editorialFields,
    ],
  };
}
