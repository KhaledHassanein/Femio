import type { CollectionConfig } from "payload";
import { isStaff } from "../access/roles";

// Images/illustrations for content. Alt text is localized + required (a11y).
export const Media: CollectionConfig = {
  slug: "media",
  access: {
    read: () => true,
    create: isStaff,
    update: isStaff,
    delete: isStaff,
  },
  upload: true,
  fields: [{ name: "alt", type: "text", localized: true, required: true }],
};
