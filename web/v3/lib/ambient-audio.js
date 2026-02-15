/**
 * Ambient Audio for Zork I — room-triggered crossfading sound loops.
 *
 * Watches the GlkOte status bar (.GridWindow .GridLine span) for room-name
 * changes via MutationObserver, maps rooms to sound zones, and crossfades
 * between <audio> elements.  Works with Quixe, Parchment, and Glulxe.
 *
 * Audio files live in ../audio/<zone>.mp3.  Missing files are handled
 * gracefully (no errors, just silence).
 */
(function () {
  'use strict';

  // ── Zone audio config ───────────────────────────────────────────────
  var ZONES = {
    forest:    { src: 'audio/forest.mp3',    volume: 0.4  },
    house:     { src: 'audio/house.mp3',     volume: 0.2  },
    cave:      { src: 'audio/cave.mp3',      volume: 0.3  },
    water:     { src: 'audio/water.mp3',     volume: 0.4  },
    rapids:    { src: 'audio/rapids.mp3',    volume: 0.5  },
    loud:      { src: 'audio/loud.mp3',      volume: 0.7  },
    hades:     { src: 'audio/hades.mp3',     volume: 0.5  },
    mine:      { src: 'audio/mine.mp3',      volume: 0.3  },
    machinery: { src: 'audio/machinery.mp3', volume: 0.35 },
    // silence — no audio element, handled as null
  };

  // ── Room → zone mapping ─────────────────────────────────────────────
  // Keys are the room names as they appear in the GlkOte status bar.
  // Rooms not listed here fall through to "silence" (no audio).
  var ROOM_ZONES = {
    // — Forest / above-ground outdoors —
    'West of House':       'forest',
    'North of House':      'forest',
    'South of House':      'forest',
    'Behind House':        'forest',
    'Forest':              'forest',   // Forest1, Forest2, Forest3, Mountains
    'Forest Path':         'forest',
    'Up a Tree':           'forest',
    'Clearing':            'forest',   // Clearing + Grating Clearing
    'Canyon View':         'forest',
    'Rocky Ledge':         'forest',
    'On the Rainbow':      'forest',
    'End of Rainbow':      'forest',
    'Stone Barrow':        'forest',

    // — House interior —
    'Kitchen':             'house',
    'Living Room':         'house',
    'Attic':               'house',

    // — General underground (caves, passages, maze, temples, etc.) —
    'Cellar':              'cave',
    'The Troll Room':      'cave',
    'East of Chasm':       'cave',
    'Gallery':             'cave',
    'Studio':              'cave',
    'Maze':                'cave',     // Maze1–Maze15
    'Dead End':            'cave',     // Dead End 1–5
    'Grating Room':        'cave',
    'Cyclops Room':        'cave',
    'Strange Passage':     'cave',
    'Treasure Room':       'cave',
    'East-West Passage':   'cave',
    'Round Room':          'cave',
    'Deep Canyon':         'cave',
    'Damp Cave':           'cave',
    'North-South Passage': 'cave',
    'Chasm':               'cave',
    'Cold Passage':        'cave',
    'Narrow Passage':      'cave',
    'Winding Passage':     'cave',
    'Twisting Passage':    'cave',
    'Atlantis Room':       'cave',
    'Engravings Cave':     'cave',
    'Dome Room':           'cave',
    'Torch Room':          'cave',
    'Temple':              'cave',     // North Temple
    'Altar':               'cave',     // South Temple
    'Egyptian Room':       'cave',
    'Mirror Room':         'cave',     // Mirror Room 1 & 2
    'Cave':                'cave',     // Small Cave, Tiny Cave
    'Small Cave':          'cave',
    'Tiny Cave':           'cave',

    // — Water zones (calm) —
    'Frigid River':        'water',    // River1–River3 (calm sections)
    'White Cliffs Beach':  'water',    // White Cliffs North & South
    'Shore':               'water',
    'Sandy Beach':         'water',
    'Sandy Cave':          'water',
    'Stream':              'water',    // In-Stream
    'Stream View':         'water',
    'Dam Base':            'water',
    'Dam Lobby':           'water',
    'Reservoir South':     'water',
    'Reservoir North':     'water',
    'Reservoir':           'water',

    // — Rapids / falls —
    'Aragain Falls':       'rapids',
    'Canyon Bottom':       'rapids',

    // — Loud Room —
    'Loud Room':           'loud',

    // — Hades —
    'Entrance to Hades':   'hades',
    'Land of the Dead':    'hades',

    // — Mine —
    'Mine Entrance':       'mine',
    'Squeaky Room':        'mine',
    'Bat Room':            'mine',
    'Shaft Room':          'mine',
    'Smelly Room':         'mine',
    'Gas Room':            'mine',
    'Coal Mine':           'mine',     // Mine1–Mine4
    'Ladder Top':          'mine',
    'Ladder Bottom':       'mine',
    'Timber Room':         'mine',
    'Drafty Room':         'mine',
    'Slide Room':          'mine',

    // — Machinery —
    'Dam':                 'machinery',
    'Maintenance Room':    'machinery',
    'Machine Room':        'machinery',
  };

  // ── State ───────────────────────────────────────────────────────────
  var FADE_MS        = 1000;
  var STORAGE_KEY    = 'zork1-audio-muted';
  var currentRoom    = null;
  var currentZone    = null;
  var muted          = localStorage.getItem(STORAGE_KEY) === '1';

  var audioA         = null;

  // ── Helpers ─────────────────────────────────────────────────────────

  function makeAudio(zone) {
    var cfg = ZONES[zone];
    if (!cfg) return null;
    var el = document.createElement('audio');
    el.src = cfg.src;
    el.loop = true;
    el.volume = 0;
    el.preload = 'auto';
    return el;
  }

  function fadeAudio(el, targetVol, doneCallback) {
    if (!el) { if (doneCallback) doneCallback(); return; }
    var startVol = el.volume;
    var startTime = performance.now();

    function step(now) {
      var elapsed = now - startTime;
      var t = Math.min(elapsed / FADE_MS, 1);
      el.volume = startVol + (targetVol - startVol) * t;
      if (t < 1) {
        requestAnimationFrame(step);
      } else {
        el.volume = targetVol;
        if (doneCallback) doneCallback();
      }
    }
    requestAnimationFrame(step);
  }

  function crossfadeTo(zone) {
    var cfg = ZONES[zone];
    var targetVol = (cfg && !muted) ? cfg.volume : 0;

    // Fade out old
    var oldAudio = audioA;
    fadeAudio(oldAudio, 0, function () {
      if (oldAudio) {
        oldAudio.pause();
        oldAudio.removeAttribute('src');
        oldAudio.load(); // release resources
      }
    });

    // Create and fade in new
    if (zone && cfg) {
      var newAudio = makeAudio(zone);
      newAudio.addEventListener('error', function () {
        console.log('[ambient] Failed to load audio: ' + cfg.src);
      });
      newAudio.play().then(function () {
        console.log('[ambient] Playing: ' + cfg.src);
        fadeAudio(newAudio, muted ? 0 : targetVol);
      }).catch(function () {
        // Autoplay blocked — we'll try on next user interaction
        console.log('[ambient] Autoplay blocked, will retry on interaction');
        var resume = function () {
          newAudio.play().then(function () {
            console.log('[ambient] Resumed: ' + cfg.src);
            fadeAudio(newAudio, muted ? 0 : cfg.volume);
          }).catch(function (e) {
            console.log('[ambient] Retry failed: ' + e);
          });
          document.removeEventListener('click', resume);
          document.removeEventListener('keydown', resume);
        };
        document.addEventListener('click', resume);
        document.addEventListener('keydown', resume);
      });
      audioA = newAudio;
    } else {
      audioA = null;
    }
  }

  // ── Room detection ──────────────────────────────────────────────────

  function extractRoomName(gridWindow) {
    // The status bar has .GridLine elements; the first line's first span
    // contains the room name, possibly followed by score/turns text.
    var firstLine = gridWindow.querySelector('.GridLine');
    if (!firstLine) return null;

    var text = firstLine.textContent || '';
    // The status line looks like "  Room Name          Score: 0  Moves: 1"
    // or just the room name padded with spaces.
    // Strategy: trim, then strip trailing "Score:..." or "S: N  T: N" etc.
    text = text.trim();

    // Strip common trailing patterns (score/moves counters)
    // Patterns seen: "Score: 0  Moves: 1", "0/1", etc.
    text = text.replace(/\s{2,}.*$/, '');  // everything after 2+ spaces
    text = text.trim();

    return text || null;
  }

  function onRoomChange(roomName) {
    if (roomName === currentRoom) return;
    var zone = ROOM_ZONES[roomName] || null;
    console.log('[ambient] Room: "' + roomName + '" → zone: ' + (zone || 'silence'));
    currentRoom = roomName;

    if (zone === currentZone) return; // same zone, no audio change
    currentZone = zone;
    crossfadeTo(zone);
  }

  // ── MutationObserver setup ──────────────────────────────────────────

  function startObserving() {
    // Wait for .GridWindow to appear (engines create it dynamically)
    var grid = document.querySelector('.GridWindow');
    if (grid) {
      attachObserver(grid);
      return;
    }

    // Poll until the grid appears
    var poll = setInterval(function () {
      grid = document.querySelector('.GridWindow');
      if (grid) {
        clearInterval(poll);
        attachObserver(grid);
      }
    }, 500);
  }

  function attachObserver(grid) {
    console.log('[ambient] Observing .GridWindow for room changes');

    var observer = new MutationObserver(function () {
      var name = extractRoomName(grid);
      if (name) onRoomChange(name);
    });

    observer.observe(grid, {
      childList: true,
      characterData: true,
      subtree: true,
    });

    // Initial read
    var name = extractRoomName(grid);
    if (name) onRoomChange(name);
  }

  // ── Mute button ─────────────────────────────────────────────────────

  function createMuteButton() {
    var btn = document.createElement('button');
    btn.id = 'ambient-mute-btn';
    btn.setAttribute('aria-label', 'Toggle ambient audio');
    btn.title = 'Toggle ambient audio';

    // CSS-only speaker icon via pseudo-elements
    var style = document.createElement('style');
    style.textContent =
      '#ambient-mute-btn {' +
        'position: fixed; bottom: 12px; right: 12px; z-index: 9999;' +
        'width: 36px; height: 36px; border-radius: 50%;' +
        'background: rgba(26,24,16,0.7); border: 1px solid #3a2a10;' +
        'cursor: pointer; display: flex; align-items: center; justify-content: center;' +
        'transition: background 0.2s;' +
        'padding: 0;' +
      '}' +
      '#ambient-mute-btn:hover { background: rgba(58,48,32,0.9); }' +
      '#ambient-mute-btn svg { width: 18px; height: 18px; fill: #aa9966; }' +
      '#ambient-mute-btn.muted svg .sound-wave { display: none; }' +
      '#ambient-mute-btn.muted svg .mute-x { display: inline; }' +
      '#ambient-mute-btn:not(.muted) svg .mute-x { display: none; }';
    document.head.appendChild(style);

    // SVG speaker icon with sound waves + mute X
    btn.innerHTML =
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">' +
        '<polygon points="6,9 2,9 2,15 6,15 11,19 11,5"/>' +
        '<path class="sound-wave" d="M14,9.5 C14.8,10.3 15.3,11.1 15.3,12 C15.3,12.9 14.8,13.7 14,14.5" ' +
          'stroke="#aa9966" stroke-width="1.5" fill="none" stroke-linecap="round"/>' +
        '<path class="sound-wave" d="M16,7.5 C17.5,9 18.3,10.5 18.3,12 C18.3,13.5 17.5,15 16,16.5" ' +
          'stroke="#aa9966" stroke-width="1.5" fill="none" stroke-linecap="round"/>' +
        '<line class="mute-x" x1="15" y1="9" x2="21" y2="15" ' +
          'stroke="#aa9966" stroke-width="2" stroke-linecap="round"/>' +
        '<line class="mute-x" x1="21" y1="9" x2="15" y2="15" ' +
          'stroke="#aa9966" stroke-width="2" stroke-linecap="round"/>' +
      '</svg>';

    if (muted) btn.classList.add('muted');

    btn.addEventListener('click', function () {
      muted = !muted;
      localStorage.setItem(STORAGE_KEY, muted ? '1' : '0');
      btn.classList.toggle('muted', muted);

      if (audioA) {
        if (muted) {
          fadeAudio(audioA, 0);
        } else {
          var cfg = ZONES[currentZone];
          if (cfg) fadeAudio(audioA, cfg.volume);
        }
      }
    });

    document.body.appendChild(btn);
  }

  // ── River zone disambiguation ───────────────────────────────────────
  // Rivers 1-3 are calm ("water"), rivers 4-5 are rapids.
  // Since they all display as "Frigid River", we can't distinguish them
  // from the status bar alone. Default to "water"; players near the falls
  // will hear rapids from Aragain Falls / Canyon Bottom entries.

  // ── Init ────────────────────────────────────────────────────────────

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
      createMuteButton();
      startObserving();
    });
  } else {
    createMuteButton();
    startObserving();
  }

})();
