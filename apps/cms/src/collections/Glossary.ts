import { contentCollection } from "./factory";

export const Glossary = contentCollection({
  slug: "glossary",
  titleName: "term",
  titleLabel: "Term",
  labels: { singular: "Glossary term", plural: "Glossary" },
  bodyFields: [{ name: "definition", type: "richText", localized: true }],
});
