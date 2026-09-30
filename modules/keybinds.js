(() => {
  const blocked = new Set(["INPUT", "TEXTAREA", "SELECT"]);
  document.addEventListener("keydown", event => {
    if (event.defaultPrevented) return;
    if (blocked.has(document.activeElement?.tagName)) return;

    if (event.altKey && event.key.toLowerCase() === "z") {
      event.preventDefault();
      window.SiftGUI?.toggle();
    }
  });
})();