import { contentCollection } from "./factory";

export const FAQs = contentCollection({
  slug: "faqs",
  titleName: "question",
  titleLabel: "Question",
  labels: { singular: "FAQ", plural: "FAQs" },
  bodyFields: [{ name: "answer", type: "richText", localized: true }],
});
