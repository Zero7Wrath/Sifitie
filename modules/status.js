(() => {
  function update() {
    const node = document.getElementById("sift-status");
    if (!node) return;
    node.textContent = "Local UI: ready";
    node.style.cssText = "margin:14px 0;padding:10px;border-left:3px solid var(--sift-accent);background:#121923;";
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", update, { once:true });
  else update();
})();