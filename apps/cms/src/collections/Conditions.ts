import { contentCollection } from "./factory";

export const Conditions = contentCollection({
  slug: "conditions",
  labels: { singular: "Condition", plural: "Conditions" },
  publishing: true,
  bodyFields: [
    { name: "summary", type: "textarea", localized: true },
    { name: "body", type: "richText", localized: true },
  ],
});
