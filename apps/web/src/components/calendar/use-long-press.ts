"use client";

import { useCallback, useRef } from "react";

/** How long a press must last to count as a long-press (02_DESIGN_SPEC §2.2). */
export const LONG_PRESS_MS = 500;
/** Finger travel that cancels a pending long-press. */
const SLOP_PX = 8;

/**
 * Pointer handlers for "long-press to set the end of a period" on a day cell.
 *
 * Why a hook rather than a library: the behaviour is six lines, the gesture has a
 * keyboard twin (Shift+Enter) so it never has to be perfect, and every dependency
 * ships to every page.
 */
export function useLongPress(onLongPress: () => void) {
  const timer = useRef<number | null>(null);
  const origin = useRef<{ x: number; y: number } | null>(null);
  const fired = useRef(false);

  const clear = useCallback(() => {
    if (timer.current !== null) window.clearTimeout(timer.current);
    timer.current = null;
    origin.current = null;
  }, []);

  const onPointerDown = useCallback(
    (event: React.PointerEvent) => {
      fired.current = false;
      origin.current = { x: event.clientX, y: event.clientY };
      timer.current = window.setTimeout(() => {
        fired.current = true;
        onLongPress();
        clear();
      }, LONG_PRESS_MS);
    },
    [clear, onLongPress],
  );

  const onPointerMove = useCallback(
    (event: React.PointerEvent) => {
      if (!origin.current) return;
      const dx = event.clientX - origin.current.x;
      const dy = event.clientY - origin.current.y;
      if (dx * dx + dy * dy > SLOP_PX * SLOP_PX) clear();
    },
    [clear],
  );

  /** True when the click that follows was a long-press, so the tap handler skips it. */
  const consumedByLongPress = useCallback(() => {
    const was = fired.current;
    fired.current = false;
    return was;
  }, []);

  return {
    handlers: {
      onPointerDown,
      onPointerMove,
      onPointerUp: clear,
      onPointerCancel: clear,
      onPointerLeave: clear,
      onContextMenu: (event: React.MouseEvent) => event.preventDefault(),
    },
    consumedByLongPress,
  };
}
