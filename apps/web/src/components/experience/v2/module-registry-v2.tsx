"use client";

import type { ReactNode } from "react";

import { RENDERERS_BY_ID, type ModuleContext } from "@/components/experience/module-registry";
import type { ModuleSpecV2 } from "@/lib/experience/v2/types";
import type { ModuleRenderer } from "./home-shell";

/**
 * The v2 registry (RB-C4, `docs/29_REBUILD/06` §1).
 *
 * ## Why this is an adapter and not a second registry
 *
 * `ModuleId` is shared between the two contracts — v2 changed the *envelope* a
 * module arrives in, not the set of things a module can be. So every renderer v1
 * already has is the correct renderer for v2, and copying them would create two
 * lists that drift: a module fixed in one and not the other is a bug nobody sees
 * until a flag flips.
 *
 * What v2 adds — the accessible name, the motion tokens, first-party measurement —
 * is applied by `ModuleHost`, once, around whatever this returns. That split is the
 * point of the redesign: the *contract* is enforced by the host and the type, and
 * the *content* stays wherever it already was.
 *
 * ## What this deliberately does not do
 *
 * It does not filter, reorder or hide. The served document decides which modules
 * appear and in what order; a registry that second-guessed it would put the
 * decision back in the client, which is the whole thing ADR-060/061 moved to the
 * backend. An id with no renderer draws nothing and says so in development rather
 * than throwing — a served document naming a module this build has not shipped yet
 * is an ordinary consequence of deploying a document and a client separately, not
 * an error.
 */
export function createModuleRenderer(ctx: ModuleContext): ModuleRenderer {
  return (spec: ModuleSpecV2): ReactNode => {
    const render = RENDERERS_BY_ID[spec.id];
    if (!render) {
      if (process.env.NODE_ENV !== "production") {
        // Loud in development, silent in production. A missing renderer is a
        // deployment-order fact, not a user-facing failure, and an exception here
        // would take the whole dashboard down for one unimplemented card.
        // eslint-disable-next-line no-console
        console.warn(
          `[experience/v2] served module "${spec.id}" has no renderer in this build — ` +
            `it will not appear. This is expected while a document leads a client.`,
        );
      }
      return null;
    }
    // `spec` is passed through because v1's renderer signature already accepts one
    // and two modules read `params` from it. The v2 spec is a superset, so the
    // fields v1 reads are all present.
    return render(ctx, spec as never);
  };
}
