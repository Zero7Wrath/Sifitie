(() => {
  const key = "sift-settings";
  window.SiftSettings = {
    load() {
      try {
        const saved = JSON.parse(localStorage.getItem(key) || "{}");
        if (saved.accent) {
          document.documentElement.style.setProperty("--sift-accent", saved.accent);
          const input = document.getElementById("sift-accent");
          if (input) input.value = saved.accent;
        }
        if (saved.opacity) {
          document.documentElement.style.setProperty("--sift-opacity", saved.opacity);
          const input = document.getElementById("sift-opacity");
          if (input) input.value = Math.round(saved.opacity * 100);
        }
      } catch {}
    },
    save() {
      const accent = document.getElementById("sift-accent")?.value || "#4da3ff";
      const opacity = Number(document.getElementById("sift-opacity")?.value || 96) / 100;
      localStorage.setItem(key, JSON.stringify({ accent, opacity }));
    }
  };
  document.addEventListener("input", event => {
    if (event.target?.id === "sift-accent" || event.target?.id === "sift-opacity") {
      window.SiftSettings.save();
    }
  });
})();