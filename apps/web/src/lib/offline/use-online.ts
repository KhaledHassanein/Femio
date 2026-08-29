"use client";

import { useEffect, useState } from "react";

/**
 * Whether the browser currently believes it has a connection (RB-C7).
 *
 * ## Why a screen needs to know
 *
 * A read that fails offline and a read that fails because the server is broken
 * look identical to `useSupabaseQuery` — both arrive as `status: "error"` — and
 * telling her "something went wrong, try again" when the real answer is "you have
 * no signal" sends her to retry a thing that cannot succeed. The distinction is
 * not cosmetic: one is worth retrying now and the other is worth waiting out.
 *
 * ## It starts optimistic, deliberately
 *
 * The initial value is `true` even on a device that is offline, because
 * `navigator` does not exist during the server render and a hydration mismatch is
 * a worse failure than one frame of optimism. The effect corrects it immediately.
 *
 * `navigator.onLine` only knows whether an interface is up — a captive portal or a
 * dead uplink still reads as online. That is why this **explains a failure that
 * already happened** rather than pre-emptively blocking a request: it is trusted
 * for its `false`, which is reliable, and never for its `true`.
 */
export function useOnline(): boolean {
  const [online, setOnline] = useState(true);

  useEffect(() => {
    const update = () => setOnline(navigator.onLine);
    update();
    window.addEventListener("online", update);
    window.addEventListener("offline", update);
    return () => {
      window.removeEventListener("online", update);
      window.removeEventListener("offline", update);
    };
  }, []);

  return online;
}
