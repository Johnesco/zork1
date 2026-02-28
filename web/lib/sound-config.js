/**
 * sound-config.js — Zork I sound effect triggers
 *
 * All triggers are text-matching (regex against game output).
 * Audio files: CC0-licensed from BigSoundBank (bigsoundbank.com)
 */
SoundEngine.init({
  storageKey: 'zork1-audio-muted',

  // Style_user1 triggers (none yet — Zork1 is a ZIL port, no story.ni control)
  sfx: {},

  // Text-matching triggers
  textTriggers: [
    // Original triggers
    { id: 'bird',     pattern: /chirping of a song bird/i,
      src: 'audio/sfx/bird.mp3',       volume: 0.25, cooldownMs: 10000 },
    { id: 'mailbox',  pattern: /You open the small mailbox/i,
      src: 'audio/sfx/creak.mp3',      volume: 0.3,  cooldownMs: 5000 },
    { id: 'window',   pattern: /you open the window/i,
      src: 'audio/sfx/window.mp3',     volume: 0.3,  cooldownMs: 5000 },
    // Puzzle & event triggers
    { id: 'trapdoor', pattern: /door reluctantly opens/i,
      src: 'audio/sfx/trapdoor.mp3',   volume: 0.2,  cooldownMs: 5000 },
    { id: 'bell',     pattern: /bell suddenly becomes red hot/i,
      src: 'audio/sfx/bell.mp3',       volume: 0.25, cooldownMs: 5000 },
    { id: 'spirits',  pattern: /flee through the walls/i,
      src: 'audio/sfx/spirits.mp3',    volume: 0.3,  cooldownMs: 5000 },
    { id: 'bat',      pattern: /bat grabs you/i,
      src: 'audio/sfx/bat.mp3',        volume: 0.2,  cooldownMs: 5000 },
    { id: 'cyclops',  pattern: /cyclops.*flees the room/i,
      src: 'audio/sfx/footsteps.mp3',  volume: 0.25, cooldownMs: 5000 },
    { id: 'machine',  pattern: /machine comes to life/i,
      src: 'audio/sfx/machine.mp3',    volume: 0.2,  cooldownMs: 5000 },
    { id: 'inflate',  pattern: /boat inflates and appears seaworthy/i,
      src: 'audio/sfx/inflate.mp3',    volume: 0.2,  cooldownMs: 5000 },
    { id: 'coffin',   pattern: /open the gold coffin/i,
      src: 'audio/sfx/coffin.mp3',     volume: 0.2,  cooldownMs: 5000 },
    { id: 'match',    pattern: /matches starts to burn/i,
      src: 'audio/sfx/match.mp3',      volume: 0.25, cooldownMs: 5000 },
    { id: 'grue',     pattern: /Oh, no!.*grue/i,
      src: 'audio/sfx/grue.mp3',       volume: 0.3,  cooldownMs: 5000 },
    { id: 'flood',    pattern: /sluice gates open/i,
      src: 'audio/sfx/flood.mp3',      volume: 0.25, cooldownMs: 5000 },
    // Recurring triggers (subtle, longer cooldowns)
    { id: 'sword',    pattern: /sword is glowing/i,
      src: 'audio/sfx/sword.mp3',      volume: 0.15, cooldownMs: 30000 },
    { id: 'thief',    pattern: /thief just left.*robbed you blind/i,
      src: 'audio/sfx/laugh.mp3',      volume: 0.15, cooldownMs: 30000 }
  ]
});
