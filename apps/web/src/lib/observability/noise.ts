/**
 * Browser errors that are not Femio's bugs, so they never reach Sentry.
 *
 * Every Sentry issue is an alert email. Before launch the only traffic is bots,
 * crawlers and the owner, and nearly all of it produces this class of event: a
 * browser extension throwing into the page, a network that dropped mid-request,
 * or a tab that kept an old build open across a deploy. None of these is
 * actionable, and an inbox full of them is how a real one gets ignored.
 *
 * Kept narrow on purpose: each entry names a class of error with an external
 * cause. A Femio error that happens to match one is the cost, and it is small,
 * because each of these also surfaces through the screen's own error state.
 */
export const IGNORE_ERRORS: (string | RegExp)[] = [
  // Layout observers firing faster than a frame. Benign, browser-internal.
  "ResizeObserver loop limit exceeded",
  "ResizeObserver loop completed with undelivered notifications",
  // The network went away. The offline states handle this for the user.
  /^(TypeError: )?(Failed to fetch|Load failed|NetworkError.*)$/,
  // A tab open across a deploy asks for chunks that no longer exist; a reload fixes it.
  /ChunkLoadError/,
  /Loading chunk [\w-]+ failed/,
  // Safari private mode / blocked storage — the offline queue degrades already.
  /QuotaExceededError/,
  // A navigation cancelled a pending one.
  "AbortError: The user aborted a request.",
  "AbortError: The operation was aborted.",
];

/** Scripts injected by extensions and in-app browsers, never shipped by us. */
export const DENY_URLS: RegExp[] = [
  /^chrome-extension:\/\//i,
  /^moz-extension:\/\//i,
  /^safari-(web-)?extension:\/\//i,
  /^webkit-masked-url:\/\//i,
];
