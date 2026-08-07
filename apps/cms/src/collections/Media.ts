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
  // An explicit allowlist rather than `upload: true`. Payload's `image-size`
  // dependency has two unpatched DoS advisories in its ICNS and JXL/HEIF parsers
  // (GHSA-w3rx-r6r6-pgpr, GHSA-5p2g-fcmc-qvqq — no 2.0.3 published), and these are
  // the only formats Femio's content actually needs. Defence-in-depth, not a fix:
  // image-size sniffs magic bytes, so a file declared image/png could still carry
  // ICNS data. Uploads are staff-only regardless (`create: isStaff`).
  upload: {
    mimeTypes: ["image/jpeg", "image/png", "image/webp", "image/avif", "image/svg+xml"],
  },
  fields: [{ name: "alt", type: "text", localized: true, required: true }],
};
