(() => {
  window.SiftClient = {
    version: "1.0.0",
    isOpen() {
      return !!document.querySelector("#sift-gui:not([hidden])");
    },
    openGUI() {
      window.SiftGUI?.open();
    },
    closeGUI() {
      window.SiftGUI?.close();
    },
    toggleGUI() {
      window.SiftGUI?.toggle();
    }
  };
})();