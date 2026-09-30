(() => {
  const css = `
    :root { --sift-accent:#4da3ff; --sift-red:#ff3d3d; --sift-opacity:.96; }
    #sift-gui { position:fixed; inset:0; z-index:2147483647; font:14px/1.4 system-ui,sans-serif; color:#eee; }
    #sift-gui[hidden] { display:none; }
    .sift-backdrop { position:absolute; inset:0; background:rgba(0,0,0,.58); backdrop-filter:blur(3px); }
    .sift-window { position:absolute; top:50%; left:50%; width:min(720px,90vw); max-height:80vh; transform:translate(-50%,-50%); overflow:hidden; border:1px solid var(--sift-accent); border-radius:12px; background:rgba(12,15,22,var(--sift-opacity)); box-shadow:0 18px 60px rgba(0,0,0,.5); }
    .sift-titlebar { display:flex; align-items:center; gap:12px; padding:12px 16px; border-bottom:1px solid #28303d; background:#101722; }
    .sift-titlebar strong { color:var(--sift-accent); letter-spacing:3px; }
    .sift-titlebar span { flex:1; color:#8f9aaa; font-size:12px; }
    .sift-titlebar button { border:0; background:transparent; color:#fff; font-size:24px; cursor:pointer; }
    .sift-tabs { display:flex; gap:4px; padding:8px; border-bottom:1px solid #28303d; }
    .sift-tab,.sift-action { border:1px solid #303a49; border-radius:7px; padding:8px 12px; background:#151c27; color:#ddd; cursor:pointer; }
    .sift-tab.active,.sift-action:hover { border-color:var(--sift-accent); color:#fff; }
    .sift-content { padding:20px; overflow:auto; max-height:60vh; }
    .sift-content label { display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-bottom:1px solid #252d39; }
    kbd { padding:2px 6px; border:1px solid #596273; border-radius:4px; background:#202735; }
    .sift-toast { position:fixed; right:20px; bottom:20px; padding:11px 15px; border-left:3px solid var(--sift-accent); border-radius:7px; background:#111722; box-shadow:0 8px 30px rgba(0,0,0,.4); }
  `;
  const style = document.createElement("style");
  style.id = "sift-style";
  style.textContent = css;
  document.head.appendChild(style);
})();