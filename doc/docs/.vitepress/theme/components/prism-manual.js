if (typeof window !== "undefined") {
  // Prevent Prism from auto-highlighting every code block on page load.
  // We only want explicit highlight() calls inside YueCompiler.
  window.Prism = window.Prism || {};
  window.Prism.manual = true;
}
