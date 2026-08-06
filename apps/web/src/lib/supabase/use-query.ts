"use client";

import { useEffect, useRef, useState } from "react";
import { createClient } from "./client";

type SupabaseClient = ReturnType<typeof createClient>;

export type QueryState<T> =
  | { status: "loading"; data: null; error: null }
  | { status: "ready"; data: T; error: null }
  | { status: "error"; data: null; error: string };

/**
 * Read data from Supabase in the browser (P4.0, ADR-048).
 *
 * The tracker used to read its data in server components, which is why it could not
 * be built for iOS/Android: a Capacitor bundle has no server to run them. Every
 * tracker screen now goes through this hook instead, so the same code renders on the
 * web and on a device.
 *
 * Deliberately small. It is a fetch-once-on-mount helper, not a cache: the tracker
 * writes through `saveOrQueue` and then refreshes, and inventing an invalidation
 * layer for four screens would be the kind of scaffolding the audit warned about.
 * Reach for a real query library when there is a real reason.
 *
 * Errors are surfaced, never swallowed. An empty screen that silently means "the
 * request failed" is the exact shape of the `.get('docs', [])` mistake in ADR-046,
 * and here it would read as "you have never logged anything" — which, to someone
 * looking at her own health record, is a worse lie than an error message.
 */
export function useSupabaseQuery<T>(
  run: (supabase: SupabaseClient) => Promise<T>,
  deps: readonly unknown[] = [],
): QueryState<T> & { refresh: () => void } {
  const [state, setState] = useState<QueryState<T>>({
    status: "loading",
    data: null,
    error: null,
  });
  const [nonce, setNonce] = useState(0);

  // The caller passes an inline closure, so it is a new function every render;
  // keeping it in a ref lets `deps` alone decide when to re-run.
  const runRef = useRef(run);
  runRef.current = run;

  useEffect(() => {
    let cancelled = false;
    setState({ status: "loading", data: null, error: null });

    void (async () => {
      try {
        const data = await runRef.current(createClient());
        if (!cancelled) setState({ status: "ready", data, error: null });
      } catch (cause) {
        if (cancelled) return;
        const message = cause instanceof Error ? cause.message : String(cause);
        setState({ status: "error", data: null, error: message });
      }
    })();

    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, nonce]);

  return { ...state, refresh: () => setNonce((n) => n + 1) };
}

/**
 * Throw on a Supabase error instead of returning `{ data: null }`.
 *
 * The server components this replaced destructured `{ data }` and ignored `error`,
 * so a failed read rendered as "no data". In a client screen that would be a blank
 * dashboard with no explanation. Wrapping every read in this means a failure reaches
 * the error branch above and says so.
 */
export async function unwrap<T>(
  query: PromiseLike<{ data: T; error: { message: string } | null }>,
): Promise<T> {
  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return data;
}
