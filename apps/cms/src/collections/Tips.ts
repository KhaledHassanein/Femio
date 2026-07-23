import { contentCollection } from "./factory";

export const Tips = contentCollection({
  slug: "tips",
  labels: { singular: "Tip", plural: "Tips" },
  bodyFields: [{ name: "body", type: "textarea", localized: true }],
});
