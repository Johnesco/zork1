// IF Hub Theme Listener
// Shared scaffolding for receiving platform theme overrides via postMessage.
// Each game template calls ThemeListener.init({ buildCSS: fn }) with an
// engine-specific CSS builder. The shared code handles font loading,
// element management, message handling, and URL-based auto-apply.

var ThemeListener = (function() {
  var FONTS_URL = 'https://fonts.googleapis.com/css2?family=DotGothic16&family=Pixelify+Sans&family=Press+Start+2P&family=Silkscreen&family=Sixtyfour&family=Tiny5&family=VT323&family=Workbench&display=swap';

  // Directory this script was loaded from, so a game can ship its own copy of
  // the theme data next to it and stay playable away from the hub.
  var SCRIPT_DIR = (function() {
    var s = document.currentScript;
    if (!s || !s.src) return '';
    return s.src.replace(/[?#].*$/, '').replace(/[^/]*$/, '');
  })();

  // Tell the hub this player renders hub themes itself.
  //
  // The hub withholds its own CSS injection from any game whose ifhub.conf
  // declares an overlay. Without an announcement it cannot tell a player that
  // owns its presentation from one whose template predates this script, so the
  // latter ends up with no theming at all and no error to show for it. Saying
  // so explicitly lets the hub keep injecting for players that stay silent.
  function announceReady() {
    try {
      if (window.parent && window.parent !== window) {
        window.parent.postMessage({ type: 'ifhub:overlayReady' }, '*');
      }
    } catch (e) { /* sandboxed or detached — no one to announce to */ }
  }

  // Load the first source that resolves. Theme data lives with the hub, but a
  // game may be published anywhere, so a locally shipped copy wins and the hub
  // is only a fallback that may legitimately not exist. If none load the game
  // stays playable, just without the requested theme.
  function loadFirst(sources, done) {
    if (!sources.length) return;
    var s = document.createElement('script');
    s.src = sources[0];
    s.onload = function() { done(); };
    s.onerror = function() {
      s.remove();
      loadFirst(sources.slice(1), done);
    };
    document.head.appendChild(s);
  }

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

    announceReady();
    // The hub may attach its listener after this frame has already run, so say
    // it again once loading settles. The flag it sets is idempotent.
    window.addEventListener('load', announceReady);

    // Auto-apply theme from URL param (full-page mode from hub)
    var urlTheme = new URLSearchParams(window.location.search).get('theme');
    if (urlTheme && urlTheme !== 'classic') {
      loadFirst([SCRIPT_DIR + 'themes.js', '/ifhub/themes.js'], function() {
        if (typeof getTheme !== 'function') return;
        var t = getTheme(urlTheme);
        if (t) applyPlatformTheme(t.game, t.scrollbar);
      });
    }
  }

  return { init: init, ensureRetroFonts: ensureRetroFonts };
})();
