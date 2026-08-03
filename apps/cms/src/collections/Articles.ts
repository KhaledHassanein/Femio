import { contentCollection } from "./factory";

export const Articles = contentCollection({
  slug: "articles",
  labels: { singular: "Article", plural: "Articles" },
  publishing: true,
  bodyFields: [
    { name: "excerpt", type: "textarea", localized: true },
    { name: "body", type: "richText", localized: true },
  ],
});
