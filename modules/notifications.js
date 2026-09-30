(() => {
  window.SiftNotify = {
    show(message, timeout = 2200) {
      const toast = document.createElement("div");
      toast.className = "sift-toast";
      toast.textContent = message;
      document.body.appendChild(toast);
      setTimeout(() => toast.remove(), timeout);
    }
  };
})();