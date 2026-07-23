import type { CollectionConfig } from "payload";
import { isAdmin, isAdminField } from "../access/roles";

// Back-office staff accounts. Roles gate content authoring vs medical-review vs
// translation (mirrors the app's staff_roles). Only admins manage users + roles;
// Payload still allows the very first user to be created via the setup flow.
export const Users: CollectionConfig = {
  slug: "users",
  auth: true,
  admin: { useAsTitle: "email", defaultColumns: ["email", "name", "roles"] },
  access: {
    read: ({ req }) => Boolean(req.user),
    create: isAdmin,
    update: isAdmin,
    delete: isAdmin,
    admin: ({ req }) => Boolean(req.user),
  },
  fields: [
    { name: "name", type: "text" },
    {
      name: "roles",
      type: "select",
      hasMany: true,
      required: true,
      defaultValue: ["editor"],
      access: { update: isAdminField },
      options: [
        { label: "Admin", value: "admin" },
        { label: "Editor", value: "editor" },
        { label: "Medical reviewer", value: "medical_reviewer" },
        { label: "Translator", value: "translator" },
      ],
    },
  ],
};
