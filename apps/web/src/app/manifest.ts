import type { MetadataRoute } from "next";

/**
 * Web app manifest (served at /manifest.webmanifest).
 *
 * The website is not an installable app (the product is the Android app), but
 * Android still reads the manifest for the icon and colours it shows when a
 * woman adds the site to her home screen, and the icon set here is what search
 * engines and share sheets pick up. `display: "browser"` says so explicitly.
 * Colours are literal hex because a manifest is platform JSON, not styled
 * markup; they mirror femio.tokens.css: background = porcelain --bg, theme =
 * plum-600 --primary. Icons come from scripts/brand/generate-icons.mjs.
 */
export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "femio",
    short_name: "femio",
    description: "Period, ovulation and pregnancy tracking that stays on your phone.",
    start_url: "/",
    display: "browser",
    background_color: "#FBF7F3",
    theme_color: "#8A3572",
    icons: [
      { src: "/icons/icon-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
      { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png", purpose: "any" },
      { src: "/icons/maskable-192.png", sizes: "192x192", type: "image/png", purpose: "maskable" },
      { src: "/icons/maskable-512.png", sizes: "512x512", type: "image/png", purpose: "maskable" },
      { src: "/icons/app-icon.svg", sizes: "any", type: "image/svg+xml", purpose: "any" },
    ],
  };
}
