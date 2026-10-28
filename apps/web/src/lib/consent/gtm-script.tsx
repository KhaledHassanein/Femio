import { gtmInlineScript, gtmNoScriptSrc, isGtmId } from "./gtm";

/**
 * Mounts the Tag Manager container with the consent defaults ahead of it (ADR-075).
 * Server component: it renders two static elements or nothing. Nothing is rendered when
 * `NEXT_PUBLIC_GTM_ID` is unset or malformed, which is how previews, tests and a
 * declined decision stay collection-free without a code change.
 */
export function GtmScript({ id }: { id: string | undefined }) {
  if (!isGtmId(id)) return null;
  return (
    <>
      <script id="femio-consent-gtm" dangerouslySetInnerHTML={{ __html: gtmInlineScript(id) }} />
      <noscript>
        <iframe src={gtmNoScriptSrc(id)} height="0" width="0" style={{ display: "none", visibility: "hidden" }} title="" />
      </noscript>
    </>
  );
}
