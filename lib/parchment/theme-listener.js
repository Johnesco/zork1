// IF Hub Theme Listener
// Shared scaffolding for receiving platform theme overrides via postMessage.
// Each game template calls ThemeListener.init({ buildCSS: fn }) with an
// engine-specific CSS builder. The shared code handles font loading,
// element management, message handling, and URL-based auto-apply.

var ThemeListener = (function() {
  var FONTS_URL = 'https://fonts.googleapis.com/css2?family=DotGothic16&family=Pixelify+Sans&family=Press+Start+2P&family=Silkscreen&family=Sixtyfour&family=Tiny5&family=VT323&family=Workbench&display=swap';

  function ensureRetroFonts() {
    if (document.getElementById('retro-platform-fonts')) return;
    var link = document.createElement('link');
    link.id = 'retro-platform-fonts';
    link.rel = 'stylesheet';
    link.href = FONTS_URL;
    document.head.appendChild(link);
  }

  function removePlatformTheme() {
    var el = document.getElementById('platform-theme-override');
    if (el) el.remove();
  }

  // opts.buildCSS(g, sb) — returns CSS string for this engine
  // opts.onApply(g, sb)  — optional callback after theme applied
  // opts.onRemove()      — optional callback after theme removed
  // opts.dispatchResize  — default true, dispatch resize after apply/remove
  function init(opts) {
    opts = opts || {};
    var buildCSS = opts.buildCSS;
    var onApply = opts.onApply;
    var onRemove = opts.onRemove;
    var dispatchResize = opts.dispatchResize !== false;

    function applyPlatformTheme(g, sb) {
      ensureRetroFonts();
      removePlatformTheme();
      var style = document.createElement('style');
      style.id = 'platform-theme-override';
      style.textContent = buildCSS(g, sb);
      document.head.appendChild(style);
      if (onApply) onApply(g, sb);
      if (dispatchResize) setTimeout(function() { window.dispatchEvent(new Event('resize')); }, 50);
    }

    window.addEventListener('message', function(e) {
      if (!e.data) return;
      if (e.data.type === 'ifhub:applyTheme') {
        applyPlatformTheme(e.data.game, e.data.scrollbar);
      }
      if (e.data.type === 'ifhub:restoreOverlay') {
        removePlatformTheme();
        if (onRemove) onRemove();
        if (dispatchResize) setTimeout(function() { window.dispatchEvent(new Event('resize')); }, 50);
      }
    });

    // Auto-apply theme from URL param (full-page mode from hub)
    var urlTheme = new URLSearchParams(window.location.search).get('theme');
    if (urlTheme && urlTheme !== 'classic') {
      var s = document.createElement('script');
      s.src = '/ifhub/themes.js';
      s.onload = function() {
        var t = getTheme(urlTheme);
        if (t) applyPlatformTheme(t.game, t.scrollbar);
      };
      document.head.appendChild(s);
    }
  }

  return { init: init, ensureRetroFonts: ensureRetroFonts };
})();
