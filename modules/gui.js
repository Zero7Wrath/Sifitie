(() => {
  const rootId = "sift-gui";
  window.SiftGUI = {
    open() {
      const root = document.getElementById(rootId);
      if (root) root.hidden = false;
      document.documentElement.classList.add("sift-gui-open");
    },
    close() {
      const root = document.getElementById(rootId);
      if (root) root.hidden = true;
      document.documentElement.classList.remove("sift-gui-open");
    },
    toggle() {
      const root = document.getElementById(rootId);
      if (!root || root.hidden) this.open();
      else this.close();
    }
  };

  function build() {
    if (document.getElementById(rootId)) return;

    const root = document.createElement("section");
    root.id = rootId;
    root.hidden = true;
    root.innerHTML = `
      <div class="sift-backdrop" data-sift-close></div>
      <div class="sift-window" role="dialog" aria-label="Sift GUI">
        <header class="sift-titlebar">
          <strong>SIFT</strong>
          <span>HTML CLIENT GUI</span>
          <button type="button" data-sift-close aria-label="Close">×</button>
        </header>
        <nav class="sift-tabs">
          <button class="sift-tab active" data-sift-tab="home">Home</button>
          <button class="sift-tab" data-sift-tab="settings">Settings</button>
          <button class="sift-tab" data-sift-tab="about">About</button>
        </nav>
        <main class="sift-content">
          <div data-sift-page="home">
            <h2>Welcome to Sift</h2>
            <p>Your local HTML client interface is ready.</p>
            <div id="sift-status"></div>
            <button class="sift-action" data-sift-notify>Test notification</button>
          </div>
          <div data-sift-page="settings" hidden>
            <h2>Settings</h2>
            <label>Accent <input id="sift-accent" type="color" value="#4da3ff"></label>
            <label>GUI opacity <input id="sift-opacity" type="range" min="70" max="100" value="96"></label>
          </div>
          <div data-sift-page="about" hidden>
            <h2>Sift</h2>
            <p>A local UI layer for HTML projects.</p>
            <p>Toggle the GUI with <kbd>Alt</kbd> + <kbd>Z</kbd>.</p>
          </div>
        </main>
      </div>
    `;
    document.body.appendChild(root);

    root.addEventListener("click", event => {
      const close = event.target.closest("[data-sift-close]");
      if (close) SiftGUI.close();

      const tab = event.target.closest("[data-sift-tab]");
      if (tab) {
        document.querySelectorAll(".sift-tab").forEach(x => x.classList.remove("active"));
        document.querySelectorAll("[data-sift-page]").forEach(x => x.hidden = true);
        tab.classList.add("active");
        const page = document.querySelector('[data-sift-page="' + tab.dataset.siftTab + '"]');
        if (page) page.hidden = false;
      }

      if (event.target.closest("[data-sift-notify]") && window.SiftNotify) {
        SiftNotify.show("Sift GUI is working.");
      }
    });

    const accent = document.getElementById("sift-accent");
    const opacity = document.getElementById("sift-opacity");
    accent?.addEventListener("input", e => document.documentElement.style.setProperty("--sift-accent", e.target.value));
    opacity?.addEventListener("input", e => document.documentElement.style.setProperty("--sift-opacity", Number(e.target.value) / 100));

    if (window.SiftSettings) SiftSettings.load();
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", build, { once: true });
  else build();
})();