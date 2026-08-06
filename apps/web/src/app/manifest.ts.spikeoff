import type { MetadataRoute } from "next";

// PWA web app manifest (served at /manifest.webmanifest). Colors are literal hex
// because the manifest is platform JSON, not styled markup — they mirror the
// Femio tokens: background = --surface (#FAFAF9), theme = --primary (violet-600).
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Femio",
    short_name: "Femio",
    description: "One account for a woman's whole health life.",
    start_url: "/",
    display: "standalone",
    background_color: "#FAFAF9",
    theme_color: "#7C3AED",
    icons: [
      {
        src: "/icons/app-icon.svg",
        sizes: "any",
        type: "image/svg+xml",
        purpose: "any",
      },
    ],
  };
}
