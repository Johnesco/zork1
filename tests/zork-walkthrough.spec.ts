import { test, expect, Page } from '@playwright/test';

// ── Helpers ──────────────────────────────────────────────────────────

async function waitForInput(page: Page, timeout = 30_000) {
  await page.locator('input.LineInput').waitFor({ state: 'visible', timeout });
}

async function send(page: Page, cmd: string) {
  const input = page.locator('input.LineInput');
  await input.fill(cmd);
  await input.press('Enter');
  await waitForInput(page);
}

async function getOutput(page: Page): Promise<string> {
  return page.locator('.BufferWindow').innerText();
}

async function getRecentOutput(page: Page, lines = 25): Promise<string> {
  const all = await getOutput(page);
  return all.split('\n').slice(-lines).join('\n');
}

async function getStatus(page: Page): Promise<string> {
  return page.locator('.GridWindow').innerText();
}

async function attackUntilDead(page: Page, enemy: string, victoryPattern: RegExp, maxAttempts = 60) {
  for (let i = 0; i < maxAttempts; i++) {
    await send(page, `attack ${enemy}`);
    const out = await getRecentOutput(page);
    if (victoryPattern.test(out)) return;
  }
  throw new Error(`${enemy} not defeated after ${maxAttempts} attacks`);
}

// ── The Walkthrough ──────────────────────────────────────────────────

test('Complete Zork I walkthrough - all treasures, 350 points', async ({ page }) => {
  test.setTimeout(10 * 60 * 1000);

  await page.goto('/');
  await waitForInput(page, 60_000);
  let out = await getOutput(page);
  expect(out).toContain('ZORK I');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 1 — Surface: collect supplies, egg from tree             ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'open mailbox');
  await send(page, 'take leaflet');
  await send(page, 'drop leaflet');
  await send(page, 'south');               // South of House
  await send(page, 'east');                // Behind House
  await send(page, 'open window');
  await send(page, 'west');                // Kitchen via window (+10 pts)
  await send(page, 'take sack');
  await send(page, 'open sack');
  await send(page, 'take garlic');
  await send(page, 'take bottle');
  await send(page, 'west');                // Living Room
  await send(page, 'take sword');
  await send(page, 'take lantern');
  await send(page, 'east');                // Kitchen
  await send(page, 'up');                  // Attic
  await send(page, 'turn on lantern');
  await send(page, 'take rope');
  await send(page, 'down');                // Kitchen
  await send(page, 'east');                // Behind House
  await send(page, 'north');               // North of House
  await send(page, 'north');               // Forest Path
  await send(page, 'up');                  // Up a Tree
  await send(page, 'take egg');
  await send(page, 'down');                // Forest Path
  await send(page, 'south');               // North of House
  await send(page, 'west');                // West of House
  await send(page, 'south');               // South of House
  await send(page, 'east');                // Behind House
  await send(page, 'west');                // Kitchen (through window)
  await send(page, 'west');                // Living Room

  // Don't deposit egg yet — carry it underground so the thief can steal and open it

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 2 — Troll, Maze, Cyclops                                 ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'move rug');
  await send(page, 'open trap door');
  await send(page, 'turn on lantern');
  await send(page, 'down');                // Cellar (+25 pts)
  await send(page, 'north');               // Troll Room

  await attackUntilDead(page, 'troll', /too much for him|dies|is dead/i);

  // Maze -> coins + skeleton key
  await send(page, 'west');                // Maze1
  await send(page, 'south');               // Maze2
  await send(page, 'east');                // Maze3
  await send(page, 'up');                  // Maze5
  await send(page, 'take coins');
  await send(page, 'take key');
  // Continue to Cyclops Room
  await send(page, 'southwest');           // Maze6
  await send(page, 'east');                // Maze7
  await send(page, 'south');               // Maze15
  await send(page, 'southeast');           // Cyclops Room

  await send(page, 'odysseus');
  out = await getRecentOutput(page);
  expect(out).toContain('flees');

  await send(page, 'east');                // Strange Passage
  await send(page, 'east');                // Living Room
  await send(page, 'put coins in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 3 — Gallery painting, Dome/Temple/Egypt treasures        ║
  // ╚══════════════════════════════════════════════════════════════════╝

  // Drop unneeded items (keep egg — we need the thief to steal and open it)
  await send(page, 'drop sack');
  await send(page, 'drop bottle');
  await send(page, 'drop garlic');

  await send(page, 'open trap door');
  await send(page, 'down');                // Cellar
  await send(page, 'south');               // East of Chasm
  await send(page, 'east');                // Gallery
  await send(page, 'take painting');
  await send(page, 'west');                // East of Chasm
  await send(page, 'north');               // Cellar
  await send(page, 'north');               // Troll Room
  await send(page, 'east');                // East-West Passage (+5 pts)
  await send(page, 'east');                // Round Room
  await send(page, 'southeast');           // Engravings Cave
  await send(page, 'east');                // Dome Room
  await send(page, 'tie rope to railing');
  await send(page, 'down');                // Torch Room
  await send(page, 'take torch');
  await send(page, 'south');               // North Temple
  await send(page, 'take bell');
  await send(page, 'south');               // South Temple (Altar)
  await send(page, 'take book');
  await send(page, 'take candles');
  await send(page, 'north');               // North Temple
  await send(page, 'down');                // Egypt Room
  await send(page, 'take coffin');
  await send(page, 'open coffin');
  await send(page, 'take sceptre');
  await send(page, 'up');                  // North Temple
  await send(page, 'south');               // South Temple
  await send(page, 'pray');                // -> Forest1

  await send(page, 'east');                // West of House
  await send(page, 'south');               // South of House
  await send(page, 'east');                // Behind House
  await send(page, 'west');                // Kitchen
  await send(page, 'west');                // Living Room
  await send(page, 'turn off lantern');

  await send(page, 'put painting in case');
  await send(page, 'put coffin in case');
  await send(page, 'put torch in case');

  // Keep: sword, sceptre, bell, book, candles, lantern, key

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 4 — Dam, Loud Room (platinum bar), Reservoir (trunk)     ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'turn on lantern');
  await send(page, 'open trap door');
  await send(page, 'down');                // Cellar
  await send(page, 'north');               // Troll Room
  await send(page, 'east');                // E-W Passage
  await send(page, 'east');                // Round Room

  // Stash exorcism items here — we'll pick them up for Hades later
  await send(page, 'drop bell');
  await send(page, 'drop book');
  await send(page, 'drop candles');

  // Loud Room — echo puzzle for platinum bar
  await send(page, 'east');                // Loud Room
  await send(page, 'echo');
  out = await getRecentOutput(page);
  expect(out).toContain('clanging dies');
  await send(page, 'take platinum bar');
  await send(page, 'west');                // Round Room

  // Navigate to Dam
  await send(page, 'north');               // N-S Passage
  await send(page, 'north');               // Chasm
  await send(page, 'northeast');           // Reservoir South
  await send(page, 'east');                // Dam Room
  await send(page, 'north');               // Dam Lobby
  await send(page, 'take matchbook');
  await send(page, 'north');               // Maintenance Room
  await send(page, 'take wrench');
  await send(page, 'open tube');
  await send(page, 'take tube');
  await send(page, 'push yellow button');
  await send(page, 'south');               // Dam Lobby
  await send(page, 'south');               // Dam Room
  await send(page, 'turn bolt');
  out = await getRecentOutput(page);
  expect(out).toContain('sluice gates open');

  // Wait 8 turns for reservoir to drain
  for (let i = 0; i < 8; i++) await send(page, 'wait');

  // Reservoir — trunk of jewels
  await send(page, 'west');                // Reservoir South
  await send(page, 'north');               // Reservoir (drained)
  await send(page, 'take trunk');
  await send(page, 'north');               // Reservoir North
  await send(page, 'take pump');

  // Return to surface and deposit
  await send(page, 'south');               // Reservoir
  await send(page, 'south');               // Reservoir South
  await send(page, 'southwest');           // Chasm
  await send(page, 'south');               // N-S Passage
  await send(page, 'south');               // Round Room
  await send(page, 'west');                // E-W Passage
  await send(page, 'west');                // Troll Room
  await send(page, 'south');               // Cellar
  await send(page, 'up');                  // Living Room

  await send(page, 'put platinum bar in case');
  await send(page, 'put trunk in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 5 — Exorcism at Hades for crystal skull                  ║
  // ╚══════════════════════════════════════════════════════════════════╝

  // Drop unneeded items
  await send(page, 'drop wrench');
  await send(page, 'drop tube');

  await send(page, 'open trap door');
  await send(page, 'down');                // Cellar
  await send(page, 'north');               // Troll Room
  await send(page, 'east');                // E-W Passage
  await send(page, 'east');                // Round Room

  // Pick up exorcism items stashed here
  await send(page, 'take bell');
  await send(page, 'take book');
  await send(page, 'take candles');

  // Drop heavy/unneeded items
  await send(page, 'drop pump');
  await send(page, 'drop sceptre');
  await send(page, 'drop key');
  await send(page, 'drop sword');

  await send(page, 'south');               // Narrow Passage
  await send(page, 'south');               // Mirror Room 2
  await send(page, 'east');                // Tiny Cave
  await send(page, 'down');                // Entrance to Hades

  // Exorcism ceremony
  await send(page, 'ring bell');
  out = await getRecentOutput(page);
  expect(out).toContain('red hot');

  await send(page, 'take candles');
  await send(page, 'light match');
  await send(page, 'light candles');
  out = await getRecentOutput(page);
  expect(out).toContain('flicker wildly');

  await send(page, 'read book');
  out = await getRecentOutput(page);
  expect(out).toContain('Begone');

  // Grab skull from Land of the Dead
  await send(page, 'south');               // Land of the Dead
  await send(page, 'take skull');
  await send(page, 'north');               // Entrance to Hades

  await send(page, 'drop candles');
  await send(page, 'drop book');
  await send(page, 'drop matchbook');

  // Return to Round Room
  await send(page, 'up');                  // Tiny Cave
  await send(page, 'west');                // Mirror Room 2
  await send(page, 'north');               // Narrow Passage
  await send(page, 'north');               // Round Room

  // Pick up stashed items
  await send(page, 'take sceptre');
  await send(page, 'take pump');
  await send(page, 'take key');
  await send(page, 'take sword');

  // Return to Living Room and deposit
  await send(page, 'west');                // E-W Passage
  await send(page, 'west');                // Troll Room
  await send(page, 'south');               // Cellar
  await send(page, 'up');                  // Living Room
  await send(page, 'put skull in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 6 — River: emerald, scarab, rainbow/pot of gold          ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'open trap door');
  await send(page, 'down');                // Cellar
  await send(page, 'north');               // Troll Room
  await send(page, 'east');                // E-W Passage
  await send(page, 'east');                // Round Room
  await send(page, 'north');               // N-S Passage
  await send(page, 'north');               // Chasm
  await send(page, 'northeast');           // Reservoir South
  await send(page, 'east');                // Dam Room
  await send(page, 'down');                // Dam Base

  // Drop sharp items (they puncture the boat on boarding)
  await send(page, 'drop sword');
  await send(page, 'drop key');

  // Inflate boat (auto-enters, bypasses sharp-item check)
  await send(page, 'inflate pile of plastic');
  out = await getRecentOutput(page);
  expect(out).toContain('seaworthy');

  await send(page, 'launch');

  // Drift downstream: River1(4t) -> River2(4t) -> River3(3t) -> River4(2t)
  // We need to reach River4 to grab the buoy, then land at Sandy Beach.
  for (let i = 0; i < 11; i++) await send(page, 'wait');

  // Should be at or near River4. Take buoy and land east.
  await send(page, 'take buoy');
  await send(page, 'east');                // Sandy Beach
  await send(page, 'exit');                // Leave the boat

  await send(page, 'open buoy');
  await send(page, 'take emerald');
  await send(page, 'drop buoy');

  // Sandy Cave — dig for scarab
  await send(page, 'take shovel');
  await send(page, 'northeast');           // Sandy Cave
  await send(page, 'dig sand');
  await send(page, 'dig sand');
  await send(page, 'dig sand');
  await send(page, 'dig sand');            // Scarab uncovered
  await send(page, 'take scarab');
  await send(page, 'drop shovel');
  await send(page, 'southwest');           // Sandy Beach

  // Navigate to Aragain Falls and wave sceptre
  await send(page, 'south');               // Shore
  await send(page, 'south');               // Aragain Falls
  await send(page, 'wave sceptre');
  out = await getRecentOutput(page);
  expect(out).toContain('rainbow');

  await send(page, 'west');                // On the Rainbow
  await send(page, 'west');                // End of Rainbow
  await send(page, 'take pot of gold');

  // Exit via canyon to surface
  await send(page, 'southwest');           // Canyon Bottom
  await send(page, 'up');                  // Rocky Ledge
  await send(page, 'up');                  // Canyon View
  await send(page, 'northwest');           // Clearing
  await send(page, 'west');                // Behind House
  await send(page, 'west');                // Kitchen
  await send(page, 'west');                // Living Room
  await send(page, 'turn off lantern');

  await send(page, 'put emerald in case');
  await send(page, 'put scarab in case');
  await send(page, 'put pot of gold in case');
  await send(page, 'put sceptre in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 7 — Crystal trident from Atlantis Room                   ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'turn on lantern');
  await send(page, 'open trap door');
  await send(page, 'down');                // Cellar
  await send(page, 'north');               // Troll Room
  await send(page, 'east');                // E-W Passage
  await send(page, 'east');                // Round Room
  await send(page, 'north');               // N-S Passage
  await send(page, 'north');               // Chasm
  await send(page, 'northeast');           // Reservoir South
  await send(page, 'north');               // Reservoir (drained)
  await send(page, 'north');               // Reservoir North
  await send(page, 'north');               // Atlantis Room
  await send(page, 'take trident');

  // Return to surface
  await send(page, 'south');               // Reservoir North
  await send(page, 'south');               // Reservoir
  await send(page, 'south');               // Reservoir South
  await send(page, 'southwest');           // Chasm
  await send(page, 'south');               // N-S Passage
  await send(page, 'south');               // Round Room
  await send(page, 'west');                // E-W Passage
  await send(page, 'west');                // Troll Room
  await send(page, 'south');               // Cellar
  await send(page, 'up');                  // Living Room
  await send(page, 'put trident in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 8 — Coal Mine: jade, bracelet, coal→diamond              ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'open trap door');
  await send(page, 'down');                // Cellar
  await send(page, 'north');               // Troll Room
  await send(page, 'east');                // E-W Passage
  await send(page, 'east');                // Round Room

  // Route to mine: Round Room -> Narrow -> Mirror Room 2 -> rub mirror -> Mirror Room 1
  //   -> Cold Passage -> Slide Room -> Mine Entrance -> Squeaky -> Bat Room
  await send(page, 'south');               // Narrow Passage
  await send(page, 'south');               // Mirror Room 2
  await send(page, 'rub mirror');          // Mirror Room 1
  await send(page, 'north');               // Cold Passage
  await send(page, 'west');                // Slide Room
  await send(page, 'north');               // Mine Entrance
  await send(page, 'west');                // Squeaky Room
  await send(page, 'north');               // Bat Room
  await send(page, 'take jade');
  await send(page, 'east');                // Shaft Room

  // Get bracelet from Gas Room (lamp off to avoid explosion)
  await send(page, 'north');               // Smelly Room
  await send(page, 'turn off lantern');
  await send(page, 'down');                // Gas Room (dark — 1 turn grace)
  await send(page, 'take bracelet');
  await send(page, 'up');                  // Smelly Room
  await send(page, 'turn on lantern');
  await send(page, 'south');               // Shaft Room

  // Get coal: Shaft Room -> Smelly -> Gas Room -> mines -> Dead End 5
  await send(page, 'north');               // Smelly Room
  await send(page, 'turn off lantern');
  await send(page, 'down');                // Gas Room
  await send(page, 'east');                // Mine1
  await send(page, 'turn on lantern');
  await send(page, 'northeast');           // Mine2
  await send(page, 'southeast');           // Mine3
  await send(page, 'southwest');           // Mine4
  await send(page, 'down');                // Ladder Top
  await send(page, 'down');                // Ladder Bottom
  await send(page, 'south');               // Dead End 5
  await send(page, 'take coal');

  // Return to Shaft Room with coal (long trek back through mines)
  await send(page, 'north');               // Ladder Bottom
  await send(page, 'up');                  // Ladder Top
  await send(page, 'up');                  // Mine4
  await send(page, 'north');               // Mine3
  await send(page, 'east');                // Mine2
  await send(page, 'south');               // Mine1
  await send(page, 'turn off lantern');
  await send(page, 'west');                // Gas Room
  await send(page, 'up');                  // Smelly Room
  await send(page, 'turn on lantern');
  await send(page, 'south');               // Shaft Room

  // Basket system: put coal in basket at top, lower to Drafty Room
  await send(page, 'put coal in basket');
  await send(page, 'lower basket');

  // Walk through mines to Timber Room -> narrow passage -> Drafty Room
  await send(page, 'north');               // Smelly Room
  await send(page, 'turn off lantern');
  await send(page, 'down');                // Gas Room
  await send(page, 'east');                // Mine1
  await send(page, 'turn on lantern');
  await send(page, 'northeast');           // Mine2
  await send(page, 'southeast');           // Mine3
  await send(page, 'southwest');           // Mine4
  await send(page, 'down');                // Ladder Top
  await send(page, 'down');                // Ladder Bottom
  await send(page, 'west');                // Timber Room

  // Must be completely empty-handed to pass through narrow passage
  await send(page, 'drop all');
  await send(page, 'west');                // Drafty Room (dark, empty-handed)

  // Operate machine in darkness
  await send(page, 'take coal');
  await send(page, 'south');               // Machine Room (dark)
  await send(page, 'put coal in machine');
  await send(page, 'close machine');
  await send(page, 'turn on switch');
  await send(page, 'open machine');
  await send(page, 'take diamond');

  // Use basket to ferry diamond back up
  await send(page, 'north');               // Drafty Room
  await send(page, 'put diamond in basket');
  await send(page, 'raise basket');        // Sends basket+diamond to Shaft Room
  await send(page, 'east');                // Timber Room (empty-handed)

  // Retrieve our items
  await send(page, 'take all');
  await send(page, 'turn on lantern');

  // Back through mines to Shaft Room
  await send(page, 'east');                // Ladder Bottom
  await send(page, 'up');                  // Ladder Top
  await send(page, 'up');                  // Mine4
  await send(page, 'north');               // Mine3
  await send(page, 'east');                // Mine2
  await send(page, 'south');               // Mine1
  await send(page, 'turn off lantern');
  await send(page, 'west');                // Gas Room
  await send(page, 'up');                  // Smelly Room
  await send(page, 'turn on lantern');
  await send(page, 'south');               // Shaft Room

  // Take diamond from basket
  await send(page, 'take diamond');

  // Exit mine: Bat Room -> Squeaky -> Mine Entrance -> Slide Room -> down (Cellar)
  await send(page, 'west');                // Bat Room
  await send(page, 'south');               // Squeaky Room
  await send(page, 'east');                // Mine Entrance
  await send(page, 'south');               // Slide Room
  await send(page, 'down');                // Cellar (via slide)
  await send(page, 'up');                  // Living Room

  await send(page, 'put jade in case');
  await send(page, 'put bracelet in case');
  await send(page, 'put diamond in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 9 — Chalice from Treasure Room                           ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'west');                // Strange Passage (via cyclops opening)
  await send(page, 'west');                // Cyclops Room
  await send(page, 'up');                  // Treasure Room (+25 pts)
  await send(page, 'take chalice');
  await send(page, 'down');                // Cyclops Room
  await send(page, 'east');                // Strange Passage
  await send(page, 'east');                // Living Room
  await send(page, 'put chalice in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 10 — Kill the Thief (thief has the egg, opened it)       ║
  // ╚══════════════════════════════════════════════════════════════════╝

  // The thief lair rule brings him to Treasure Room when player is there.
  await send(page, 'take sword');
  await send(page, 'west');                // Strange Passage
  await send(page, 'west');                // Cyclops Room
  await send(page, 'up');                  // Treasure Room

  // Wait one turn for the thief lair rule to bring the thief here
  await send(page, 'wait');

  // If we still have the egg, wait for the thief to steal and open it
  await send(page, 'inventory');
  out = await getRecentOutput(page);
  if (/egg/i.test(out)) {
    for (let i = 0; i < 30; i++) {
      await send(page, 'wait');
      out = await getRecentOutput(page);
      if (/rummages|takes the/i.test(out)) break;
    }
    // One more turn for the thief-opens-egg rule to fire
    await send(page, 'wait');
  }

  // Attack the thief
  await attackUntilDead(page, 'thief', /drops to the ground|mortally wounded/i);

  // Pick up everything the thief dropped (includes opened egg with canary)
  await send(page, 'take all');

  // Return to Living Room
  await send(page, 'down');                // Cyclops Room
  await send(page, 'east');                // Strange Passage
  await send(page, 'east');                // Living Room

  // Deposit thief's loot into trophy case
  await send(page, 'put all in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 11 — Canary + Bauble                                     ║
  // ╚══════════════════════════════════════════════════════════════════╝

  // Take canary from the open egg in the trophy case
  await send(page, 'take canary');

  // Go to forest and wind canary for bauble
  await send(page, 'east');                // Kitchen
  await send(page, 'east');                // Behind House
  await send(page, 'north');               // North of House
  await send(page, 'north');               // Forest Path
  await send(page, 'wind canary');
  out = await getRecentOutput(page);
  expect(out).toContain('bauble');
  await send(page, 'take bauble');

  // Return to Living Room
  await send(page, 'south');               // North of House
  await send(page, 'west');                // West of House
  await send(page, 'south');               // South of House
  await send(page, 'east');                // Behind House
  await send(page, 'west');                // Kitchen
  await send(page, 'west');                // Living Room

  await send(page, 'put canary in case');
  await send(page, 'put bauble in case');

  // ╔══════════════════════════════════════════════════════════════════╗
  // ║ PHASE 12 — Endgame: verify score, enter Stone Barrow           ║
  // ╚══════════════════════════════════════════════════════════════════╝

  await send(page, 'score');
  out = await getRecentOutput(page);
  expect(out).toContain('350');

  // Read the ancient map (revealed when score hits 350)
  await send(page, 'take map');
  await send(page, 'read map');
  out = await getRecentOutput(page);
  expect(out).toContain('Stone Barrow');

  // Navigate to Stone Barrow via the secret southwest path
  await send(page, 'east');                // Kitchen
  await send(page, 'east');                // Behind House
  await send(page, 'north');               // North of House
  await send(page, 'west');                // West of House
  await send(page, 'southwest');           // Stone Barrow
  out = await getRecentOutput(page);
  expect(out).toContain('Stone Barrow');

  // Enter the barrow to win the game!
  await send(page, 'enter');
  out = await getOutput(page);
  expect(out).toContain('Congratulations');
});
