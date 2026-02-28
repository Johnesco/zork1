/**
 * sound-engine.js — Shared sound effects engine for IF Hub projects
 *
 * Supports two trigger modes:
 *   1. Style_user1 spans: Precise triggers from story.ni via Glulx Text Effects.
 *      The game emits [first custom style] text which GlkOte renders as
 *      <span class="Style_user1">. The engine parses "SFX:<id>" commands.
 *   2. Text matching: Regex patterns matched against game output text.
 *      Good for ambient or incidental sounds tied to prose.
 *
 * Two runtime contexts:
 *   - Standalone: local mute button, localStorage persistence
 *   - ifhub: controlled by parent frame via window.ifhubSfx API, no local button
 *
 * Usage (in a per-game sound-config.js):
 *
 *   SoundEngine.init({
 *     storageKey: 'mygame-audio-muted',
 *     sfx: {
 *       glass: { src: 'audio/sfx/glass.mp3', volume: 0.4 }
 *     },
 *     textTriggers: [
 *       { id: 'bird', pattern: /chirping of a song bird/i,
 *         src: 'audio/sfx/bird.mp3', volume: 0.25, cooldownMs: 10000 }
 *     ]
 *   });
 */
(function () {
  'use strict';

  // ── ifhub integration ─────────────────────────────────────────────
  var audioBase = window.SOUND_AUDIO_BASE || '';
  var ifhubMode = !!audioBase;
  var masterVolume = 1.0;
  var ifhubMuted = false;

  // ── State (populated by init) ─────────────────────────────────────
  var storageKey = '';
  var sfxMap = {};          // { id: { src, volume } }
  var textTriggers = [];    // [{ id, pattern, src, volume, cooldownMs }]
  var lastPlayed = {};      // cooldown tracker per trigger id

  // ── Mute / volume ─────────────────────────────────────────────────

  function isMuted() {
    if (ifhubMode) return ifhubMuted;
    try { return localStorage.getItem(storageKey) === '1'; }
    catch (e) { return false; }
  }

  function setMuted(val) {
    try { localStorage.setItem(storageKey, val ? '1' : '0'); }
    catch (e) {}
  }

  // ── Playback ──────────────────────────────────────────────────────

  function play(src, volume) {
    if (isMuted()) return;
    var el = document.createElement('audio');
    el.src = src;
    el.volume = volume * masterVolume;
    el.play().catch(function () {});
    el.addEventListener('ended', function () { el.remove(); });
  }

  function isOnCooldown(id, cooldownMs) {
    if (!cooldownMs) return false;
    var last = lastPlayed[id] || 0;
    return (performance.now() - last) < cooldownMs;
  }

  // ── Style_user1 handler ───────────────────────────────────────────

  function handleSfxCommand(text) {
    var t = text.trim();
    if (t.indexOf('SFX:') !== 0) return;
    var id = t.substring(4);
    var entry = sfxMap[id];
    if (entry) {
      play(entry.src, entry.volume);
    }
  }

  // ── Text-matching handler ─────────────────────────────────────────

  function checkTextTriggers(text) {
    for (var i = 0; i < textTriggers.length; i++) {
      var t = textTriggers[i];
      if (t.pattern.test(text) && !isOnCooldown(t.id, t.cooldownMs)) {
        lastPlayed[t.id] = performance.now();
        play(t.src, t.volume);
        return; // one sound per text node
      }
    }
  }

  // ── MutationObserver ──────────────────────────────────────────────

  function onMutation(mutations) {
    for (var i = 0; i < mutations.length; i++) {
      var added = mutations[i].addedNodes;
      for (var j = 0; j < added.length; j++) {
        var node = added[j];
        if (node.nodeType !== 1) continue;

        // Style_user1 spans (precise triggers from story.ni)
        if (node.classList && node.classList.contains('Style_user1')) {
          handleSfxCommand(node.textContent);
        } else {
          var spans = node.querySelectorAll('.Style_user1');
          for (var k = 0; k < spans.length; k++) {
            handleSfxCommand(spans[k].textContent);
          }
        }

        // Text-matching triggers
        if (textTriggers.length > 0) {
          var text = node.textContent;
          if (text) checkTextTriggers(text);
        }
      }
    }
  }

  function attachObserver(buf) {
    var observer = new MutationObserver(onMutation);
    observer.observe(buf, { childList: true, subtree: true });
  }

  function startObserving() {
    var buf = document.querySelector('.BufferWindow');
    if (buf) { attachObserver(buf); return; }
    var poll = setInterval(function () {
      buf = document.querySelector('.BufferWindow');
      if (buf) { clearInterval(poll); attachObserver(buf); }
    }, 500);
  }

  // ── Mute button (standalone mode only) ─────────────────────────────

  function createMuteButton() {
    var btn = document.createElement('button');
    btn.id = 'sfx-mute-btn';
    var muted = isMuted();

    function render() {
      btn.textContent = muted ? '\u{1F507}' : '\u{1F509}';
      btn.title = muted ? 'Unmute sound effects' : 'Mute sound effects';
    }
    render();

    btn.style.cssText = [
      'position:fixed', 'bottom:12px', 'right:12px', 'z-index:9999',
      'background:rgba(0,0,0,0.6)', 'color:#ccc', 'border:1px solid #444',
      'border-radius:4px', 'padding:6px 10px', 'cursor:pointer',
      'font-size:18px', 'line-height:1', 'opacity:0.7'
    ].join(';');

    btn.addEventListener('mouseenter', function () { btn.style.opacity = '1'; });
    btn.addEventListener('mouseleave', function () { btn.style.opacity = '0.7'; });

    btn.addEventListener('click', function () {
      muted = !muted;
      setMuted(muted);
      render();
    });

    document.body.appendChild(btn);
  }

  // ── ifhub API ──────────────────────────────────────────────────────

  if (ifhubMode) {
    window.ifhubSfx = {
      setMuted: function (val) { ifhubMuted = !!val; },
      setMasterVolume: function (v) { masterVolume = Math.max(0, Math.min(1, v)); }
    };
  }

  // ── Public API ─────────────────────────────────────────────────────

  window.SoundEngine = {
    init: function (config) {
      storageKey = config.storageKey || 'sound-muted';

      // Build sfx map with audioBase prefix
      sfxMap = {};
      if (config.sfx) {
        var ids = Object.keys(config.sfx);
        for (var i = 0; i < ids.length; i++) {
          var id = ids[i];
          var entry = config.sfx[id];
          sfxMap[id] = {
            src: audioBase + entry.src,
            volume: entry.volume != null ? entry.volume : 0.3
          };
        }
      }

      // Build text triggers with audioBase prefix
      textTriggers = [];
      if (config.textTriggers) {
        for (var j = 0; j < config.textTriggers.length; j++) {
          var t = config.textTriggers[j];
          textTriggers.push({
            id: t.id,
            pattern: t.pattern,
            src: audioBase + t.src,
            volume: t.volume != null ? t.volume : 0.3,
            cooldownMs: t.cooldownMs || 5000
          });
        }
      }

      startObserving();
      if (!ifhubMode) {
        createMuteButton();
      }
    }
  };
})();
