import { contentCollection } from "./factory";

export const Articles = contentCollection({
  slug: "articles",
  labels: { singular: "Article", plural: "Articles" },
  bodyFields: [
    { name: "excerpt", type: "textarea", localized: true },
    { name: "body", type: "richText", localized: true },
  ],
});
