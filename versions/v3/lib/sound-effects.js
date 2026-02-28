/**
 * sound-effects.js — One-shot sound effects for Zork I v3
 *
 * Watches the game text output (.BufferWindow) for specific text patterns
 * and plays short audio clips when matched. Shares mute state with
 * ambient-audio.js via the same localStorage key.
 *
 * Audio files: CC0-licensed from BigSoundBank (bigsoundbank.com)
 */
(function () {
  'use strict';

  // ── ifhub integration ─────────────────────────────────────────────
  var audioBase = window.SOUND_AUDIO_BASE || '';
  var ifhubMode = !!audioBase;
  var masterVolume = 1.0;
  var ifhubMuted = false;

  var STORAGE_KEY = 'zork1-audio-muted';
  var SOUND_TRIGGERS = [
    // Original triggers
    { id: 'bird',     pattern: /chirping of a song bird/i,
      src: audioBase + 'audio/sfx/bird.mp3',       volume: 0.25, cooldownMs: 10000 },
    { id: 'mailbox',  pattern: /You open the small mailbox/i,
      src: audioBase + 'audio/sfx/creak.mp3',      volume: 0.3,  cooldownMs: 5000 },
    { id: 'window',   pattern: /you open the window/i,
      src: audioBase + 'audio/sfx/window.mp3',     volume: 0.3,  cooldownMs: 5000 },
    // Puzzle & event triggers
    { id: 'trapdoor', pattern: /door reluctantly opens/i,
      src: audioBase + 'audio/sfx/trapdoor.mp3',   volume: 0.2,  cooldownMs: 5000 },
    { id: 'bell',     pattern: /bell suddenly becomes red hot/i,
      src: audioBase + 'audio/sfx/bell.mp3',       volume: 0.25, cooldownMs: 5000 },
    { id: 'spirits',  pattern: /flee through the walls/i,
      src: audioBase + 'audio/sfx/spirits.mp3',    volume: 0.3,  cooldownMs: 5000 },
    { id: 'bat',      pattern: /bat grabs you/i,
      src: audioBase + 'audio/sfx/bat.mp3',        volume: 0.2,  cooldownMs: 5000 },
    { id: 'cyclops',  pattern: /cyclops.*flees the room/i,
      src: audioBase + 'audio/sfx/footsteps.mp3',  volume: 0.25, cooldownMs: 5000 },
    { id: 'machine',  pattern: /machine comes to life/i,
      src: audioBase + 'audio/sfx/machine.mp3',    volume: 0.2,  cooldownMs: 5000 },
    { id: 'inflate',  pattern: /boat inflates and appears seaworthy/i,
      src: audioBase + 'audio/sfx/inflate.mp3',    volume: 0.2,  cooldownMs: 5000 },
    { id: 'coffin',   pattern: /open the gold coffin/i,
      src: audioBase + 'audio/sfx/coffin.mp3',     volume: 0.2,  cooldownMs: 5000 },
    { id: 'match',    pattern: /matches starts to burn/i,
      src: audioBase + 'audio/sfx/match.mp3',      volume: 0.25, cooldownMs: 5000 },
    { id: 'grue',     pattern: /Oh, no!.*grue/i,
      src: audioBase + 'audio/sfx/grue.mp3',       volume: 0.3,  cooldownMs: 5000 },
    { id: 'flood',    pattern: /sluice gates open/i,
      src: audioBase + 'audio/sfx/flood.mp3',      volume: 0.25, cooldownMs: 5000 },
    // Recurring triggers (subtle, longer cooldowns)
    { id: 'sword',    pattern: /sword is glowing/i,
      src: audioBase + 'audio/sfx/sword.mp3',      volume: 0.15, cooldownMs: 30000 },
    { id: 'thief',    pattern: /thief just left.*robbed you blind/i,
      src: audioBase + 'audio/sfx/laugh.mp3',      volume: 0.15, cooldownMs: 30000 },
  ];

  // Track cooldowns per trigger
  var lastPlayed = {};

  function isMuted() {
    if (ifhubMode) return ifhubMuted;
    try { return localStorage.getItem(STORAGE_KEY) === '1'; }
    catch (e) { return false; }
  }

  function isOnCooldown(trigger) {
    var last = lastPlayed[trigger.id] || 0;
    return (performance.now() - last) < trigger.cooldownMs;
  }

  function playEffect(trigger) {
    if (isMuted() || isOnCooldown(trigger)) return;
    lastPlayed[trigger.id] = performance.now();
    var el = document.createElement('audio');
    el.src = trigger.src;
    el.volume = trigger.volume * masterVolume;
    el.play().catch(function () {});
    el.addEventListener('ended', function () { el.remove(); });
  }

  function onBufferMutation(mutations) {
    for (var i = 0; i < mutations.length; i++) {
      var added = mutations[i].addedNodes;
      for (var j = 0; j < added.length; j++) {
        var text = added[j].textContent;
        if (!text) continue;
        for (var k = 0; k < SOUND_TRIGGERS.length; k++) {
          if (SOUND_TRIGGERS[k].pattern.test(text)) {
            playEffect(SOUND_TRIGGERS[k]);
            break; // one sound per added node
          }
        }
      }
    }
  }

  function attachObserver(buf) {
    var observer = new MutationObserver(onBufferMutation);
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

  // ── ifhub API (only in ifhub mode) ─────────────────────────────────

  if (ifhubMode) {
    window.ifhubSfx = {
      setMuted: function (val) { ifhubMuted = !!val; },
      setMasterVolume: function (v) { masterVolume = Math.max(0, Math.min(1, v)); }
    };
  }

  // Init
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', startObserving);
  } else {
    startObserving();
  }
})();
