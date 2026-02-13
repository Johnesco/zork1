"Zork I: The Great Underground Empire" by "Infocom (translated to Inform 7)"

The story headline is "An Interactive Fiction".
The story genre is "Fantasy".
The release number is 1.
The story creation year is 1980.
The story description is "ZORK is a game of adventure, danger, and low cunning. In it you will explore some of the most amazing territory ever seen by mortals. No computer should be without one!"

Use American dialect.
Use scoring.
The maximum score is 350.

Part 1 - Configuration and Extensions

Chapter 1 - Bibliographic and Settings

The player is in West-of-House.

When play begins:
	now the left hand status line is "[the player's surroundings] [if in darkness]   [otherwise]   Score: [score]/[turn count][end if]";
	now the right hand status line is "";
	say "[bold type]ZORK I: The Great Underground Empire[roman type][line break]Copyright (c) 1980, 1981, 1982, 1983 Infocom, Inc. All rights reserved.[line break]ZORK is a registered trademark of Infocom, Inc.[line break]Revision 88 / Serial number 840726[paragraph break]".

Chapter 2 - Verbosity Modes

Verbosity mode is a kind of value. The verbosity modes are superbrief-mode, brief-mode, and verbose-mode.
The current verbosity is a verbosity mode that varies. The current verbosity is brief-mode.

Superbriefing is an action out of world.
Understand "superbrief" as superbriefing.
Carry out superbriefing:
	now the current verbosity is superbrief-mode;
	say "Superbrief descriptions."

Verbosing is an action out of world.
Understand "verbose" as verbosing.
Carry out verbosing:
	now the current verbosity is verbose-mode;
	say "Maximum verbosity.";
	try looking.

Briefing is an action out of world.
Understand "brief" as briefing.
Carry out briefing:
	now the current verbosity is brief-mode;
	say "Brief descriptions."

Chapter 3 - Score Ranks

Table of Rankings
score	rank
0	"Beginner"
25	"Amateur Adventurer"
50	"Novice Adventurer"
100	"Junior Adventurer"
200	"Adventurer"
300	"Master"
330	"Wizard"
350	"Master Adventurer"

After printing the player's obituary:
	say "[line break]";
	follow the score and rank rule.

This is the score and rank rule:
	say "Your score is [score] (total of 350 points), in [turn count] move[if turn count is not 1]s[end if].[line break]This gives you the rank of ";
	let current-rank be "Beginner";
	repeat through the Table of Rankings:
		if the score is at least the score entry:
			now current-rank is the rank entry;
	say "[current-rank].[line break]".

Carry out requesting the score:
	if the player-is-dead is true:
		say "You're dead! How can you think of your score?";
		stop the action;
	follow the score and rank rule;
	stop the action.

Chapter 4 - Death and Resurrection

The player-deaths is a number that varies. The player-deaths is 0.
The player-is-dead is a truth state that varies. The player-is-dead is false.
The always-lit-mode is a truth state that varies. The always-lit-mode is false.

To die saying (reason - text):
	say "[reason][line break]";
	if the player-is-dead is true:
		say "[line break]It takes a talented person to be killed while already dead. YOU are such a talent. Unfortunately, it takes a talented person to deal with it. I am not such a talent. Sorry.[line break]";
		end the story;
		stop;
	if the lucky-flag is false:
		say "Bad luck, huh?[line break]";
	decrease the score by 10;
	say "[line break]    ****  You have died  ****[line break][line break]";
	if the player-deaths is at least 2:
		say "You clearly are a suicidal maniac. We don't allow psychotics in the cave, since they may harm other adventurers. Your remains will be installed in the Land of the Living Dead, where your fellow adventurers may gloat over them.[line break]";
		end the story;
		stop;
	increase the player-deaths by 1;
	if South Temple is visited:
		say "As you take your last breath, you feel relieved of your burdens. The feeling passes as you find yourself before the gates of Hell, where the spirits jeer at you and deny you entry. Your senses are disturbed. The objects in the dungeon appear indistinct, bleached of color, even unreal.[paragraph break]";
		now the player-is-dead is true;
		now the troll-flag is true;
		now the always-lit-mode is true;
		scatter-possessions;
		move the player to Entrance to Hades;
	otherwise:
		say "Now, let's take a look here...[line break]Well, you probably deserve another chance. I can't quite fix you up completely, but you can't have everything.[paragraph break]";
		scatter-possessions;
		move the player to Forest1.

To scatter-possessions:
	now every thing carried by the player is in West-of-House;
	if the player encloses the brass lantern:
		now the brass lantern is in Living Room;
	now the match-lit is false;
	now the match-timer is 0.

Chapter 5 - Dead-State Action Intercepts

Before attacking when the player-is-dead is true: say "All such attacks are vain in your condition." instead.
Before opening something when the player-is-dead is true: say "Even such an action is beyond your capabilities." instead.
Before closing something when the player-is-dead is true: say "Even such an action is beyond your capabilities." instead.
Before eating something when the player-is-dead is true: say "Even such an action is beyond your capabilities." instead.
Before drinking something when the player-is-dead is true: say "Even such an action is beyond your capabilities." instead.
Before switching on something when the player-is-dead is true: say "You need no light to guide you." instead.
Before switching off something when the player-is-dead is true: say "Even such an action is beyond your capabilities." instead.
Before waiting when the player-is-dead is true: say "Might as well. You've got an eternity." instead.
Before taking something when the player-is-dead is true: say "Your hand passes through its object." instead.
Before dropping something when the player-is-dead is true: say "You have no possessions." instead.
Before throwing something at when the player-is-dead is true: say "You have no possessions." instead.
Before taking inventory when the player-is-dead is true: say "You have no possessions." instead.
Before looking when the player-is-dead is true:
	say "The room looks strange and unearthly and objects appear indistinct.";
	say "[line break]Although there is no light, the room seems dimly illuminated." instead.

Before doing something when the player-is-dead is true and the current action is not praying and the current action is not looking and the current action is not taking inventory and the current action is not waiting and the current action is not diagnosing and the current action is not attacking and the current action is not going:
	say "You can't even do that." instead.

Chapter 6 - Darkness and Grues

The dark-warning-given is a truth state that varies. The dark-warning-given is false.

Rule for printing the description of a dark room:
	if the always-lit-mode is true:
		say "It is pitch black.[line break]" instead;
	if the dark-warning-given is false:
		say "It is pitch black. You are likely to be eaten by a grue.[line break]";
		now the dark-warning-given is true;
	otherwise:
		grue-death.

To grue-death:
	let R be a random number between 1 and 3;
	if R is 1:
		die saying "Oh, no! A lurking grue slithered into the room and devoured you!";
	otherwise if R is 2:
		die saying "Oh, no! You have walked into the slavering fangs of a lurking grue!";
	otherwise:
		die saying "Oh, no! You have walked into a den of hungry grues and it[apostrophe]s dinner time!".

Every turn when in darkness:
	if the always-lit-mode is false:
		now the dark-warning-given is false.

After going to a dark room:
	if the always-lit-mode is false:
		now the dark-warning-given is false;
	continue the action.

After deciding the scope of the player when in darkness:
	repeat with item running through things enclosed by the location:
		place item in scope.

Chapter 6 - Lamp Timer System

The lamp-turns is a number that varies. The lamp-turns is 0.
The lamp-stage is a number that varies. The lamp-stage is 0.
The lamp-burned-out is a truth state that varies. The lamp-burned-out is false.

Every turn when the brass lantern is lit:
	increase the lamp-turns by 1;
	if the lamp-stage is 0 and the lamp-turns is at least 100:
		now the lamp-stage is 1;
		if the player can see the brass lantern:
			say "The lamp appears a bit dimmer.[line break]";
	if the lamp-stage is 1 and the lamp-turns is at least 170:
		now the lamp-stage is 2;
		if the player can see the brass lantern:
			say "The lamp is definitely dimmer now.[line break]";
	if the lamp-stage is 2 and the lamp-turns is at least 185:
		now the lamp-stage is 3;
		if the player can see the brass lantern:
			say "The lamp is nearly out.[line break]";
	if the lamp-turns is at least 200:
		now the lamp-burned-out is true;
		now the brass lantern is not lit;
		now the lamp-stage is 4;
		if the player can see the brass lantern:
			say "You'd better have more light than from the brass lantern.[line break]".

Chapter 6a - Candle Timer System

The candle-turns is a number that varies. The candle-turns is 0.
The candle-stage is a number that varies. The candle-stage is 0.
The candles-burned-out is a truth state that varies. The candles-burned-out is false.

Every turn when the pair of candles is lit (this is the candle timer rule):
	increase the candle-turns by 1;
	if the candle-stage is 0 and the candle-turns is at least 20:
		now the candle-stage is 1;
		if the player can see the pair of candles:
			say "The candles grow shorter.[line break]";
	if the candle-stage is 1 and the candle-turns is at least 30:
		now the candle-stage is 2;
		if the player can see the pair of candles:
			say "The candles are becoming quite short.[line break]";
	if the candle-stage is 2 and the candle-turns is at least 35:
		now the candle-stage is 3;
		if the player can see the pair of candles:
			say "The candles won't last long now.[line break]";
	if the candle-turns is at least 40:
		now the candles-burned-out is true;
		now the pair of candles is not lit;
		now the candle-stage is 4;
		if the player can see the pair of candles:
			say "You'd better have more light than from the pair of candles.[line break]".

Chapter 6b - Match Lighting System

The match-lit is a truth state that varies. The match-lit is false.
The match-timer is a number that varies. The match-timer is 0.

Lighting-match is an action applying to nothing. Understand "light match" and "light a match" and "strike match" as lighting-match.

Instead of switching on the matchbook:
	try lighting-match.

Carry out lighting-match:
	if the player does not carry the matchbook:
		say "You don't have the matchbook." instead;
	if the match-count is 0:
		say "I'm afraid that you have run out of matches." instead;
	decrease the match-count by 1;
	if the player is in Drafty Room or the player is in Timber Room:
		say "This room is drafty, and the match goes out instantly." instead;
	now the match-lit is true;
	now the match-timer is 2;
	say "One of the matches starts to burn."

Every turn when the match-lit is true (this is the match burn timer rule):
	decrease the match-timer by 1;
	if the match-timer is at most 0:
		now the match-lit is false;
		say "The match has gone out.[line break]".

Extinguishing-match is an action applying to nothing. Understand "blow out match" and "extinguish match" as extinguishing-match.

Carry out extinguishing-match:
	if the match-lit is true:
		now the match-lit is false;
		now the match-timer is 0;
		say "The match is out.";
	otherwise:
		say "No match is lit."

Chapter 7 - Trophy Case Scoring

The trophy-case-score is a number that varies. The trophy-case-score is 0.

Every turn (this is the trophy case scoring rule):
	let new-score be 0;
	repeat with item running through things in the trophy case:
		increase new-score by the treasure-value of the item;
		repeat with inner running through things enclosed by the item:
			increase new-score by the treasure-value of the inner;
	if new-score is not the trophy-case-score:
		let diff be new-score minus the trophy-case-score;
		increase the score by diff;
		now the trophy-case-score is new-score;
	if the score is 350 and the won-flag is false:
		now the won-flag is true;
		now the ancient map is visible;
		say "[line break]An almost inaudible voice whispers in your ear, [quotation mark]Look to your treasures for the final secret.[quotation mark][line break]".

Chapter 8 - Treasure Values

A thing has a number called treasure-value.
A person can be defeated. A person is usually not defeated. The treasure-value of a thing is usually 0.
A thing has a number called point-value. The point-value of a thing is usually 0.

Chapter 9 - Lucky Flag

The lucky-flag is a truth state that varies. The lucky-flag is true.

Part 2 - The World

Chapter 1 - Forest and Outside of House

Section 1 - Regions

House Exterior is a region.
The Forest Area is a region.
The House Interior is a region.
The Underground is a region.

Section 2 - Rooms Outside the House

West-of-House is a room. "You are standing in an open field west of a white house, with a boarded front door.[if the won-flag is true] A secret path leads southwest into the forest.[end if]".
The printed name of West-of-House is "West of House".
West-of-House is in House Exterior.

The white house is a backdrop. The white house is in House Exterior and Forest Area. The description of the white house is "The house is a beautiful colonial house which is painted white. It is clear that the owners must have been extremely wealthy."
Understand "house" and "white" and "beautiful" and "colonial" as the white house.

North-of-House is a room. "You are facing the north side of a white house. There is no door here, and all the windows are boarded up. To the north a narrow path winds through the trees."
The printed name of North-of-House is "North of House".
North-of-House is in House Exterior.

South-of-House is a room. "You are facing the south side of a white house. There is no door here, and all the windows are boarded."
The printed name of South-of-House is "South of House".
South-of-House is in House Exterior.

Behind House is a room. The printed name of Behind House is "Behind House".
Behind House is in House Exterior.

The description of Behind House is "You are behind the white house. A path leads into the forest to the east. In one corner of the house there is a small window which is [if the kitchen-window is open]open[otherwise]slightly ajar[end if]."

Section 3 - Map Connections Around the House

North-of-House is north of West-of-House. South-of-House is south of West-of-House.
Northeast of West-of-House is North-of-House. Southeast of West-of-House is South-of-House.
North of Behind House is North-of-House. South of Behind House is South-of-House.
Southwest of Behind House is South-of-House. Northwest of Behind House is North-of-House.
East of South-of-House is Behind House. West of South-of-House is West-of-House.
Northeast of South-of-House is Behind House. Northwest of South-of-House is West-of-House.
East of North-of-House is Behind House. West of North-of-House is West-of-House.
East of Behind House is Clearing.

Instead of going east in West-of-House:
	say "The door is boarded and you can't remove the boards."

Instead of going south in North-of-House:
	say "The windows are all boarded."

Instead of going north in South-of-House:
	say "The windows are all boarded."

Section 4 - Forest Rooms

Forest1 is a room. The printed name of Forest1 is "Forest". "This is a forest, with trees in all directions. To the east, there appears to be sunlight."
Forest1 is in Forest Area.
Forest1 is west of West-of-House.

Forest2 is a room. The printed name of Forest2 is "Forest". "This is a dimly lit forest, with large trees all around."
Forest2 is in Forest Area.

Mountains is a room. The printed name of Mountains is "Forest". "The forest thins out, revealing impassable mountains."

Forest3 is a room. The printed name of Forest3 is "Forest". "This is a dimly lit forest, with large trees all around."
Forest3 is in Forest Area.
Forest3 is south of South-of-House.
Northwest of Forest3 is South-of-House.
West of Forest3 is Forest1. South of Forest1 is Forest3.

Forest Path is a room. "This is a path winding through a dimly lit forest. The path heads north-south here. One particularly large tree with some low branches stands at the edge of the path."
Forest Path is in Forest Area.
North of North-of-House is Forest Path.
South of Forest Path is North-of-House. East of Forest Path is Forest2. West of Forest Path is Forest1. North of Forest1 is Grating Clearing.

East of Forest1 is Forest Path.

Forest2 is east of Mountains. Forest2 is north of Mountains. Forest2 is south of Mountains. Forest2 is west of Mountains.

North of Forest2 is nowhere. South of Forest2 is Clearing. West of Forest2 is Forest Path. East of Forest2 is Mountains.

North of Forest3 is Clearing. East of Forest3 is nowhere.

Instead of going north in Forest2:
	say "The forest becomes impenetrable to the north."

Instead of going east in Forest3:
	say "The rank undergrowth prevents eastward movement."

Instead of going south in Forest3:
	say "Storm-tossed trees block your way."

Instead of going up in Forest1:
	say "There is no tree here suitable for climbing."

Instead of going up in Forest2:
	say "There is no tree here suitable for climbing."

Instead of going up in Forest3:
	say "There is no tree here suitable for climbing."

Instead of going up in Mountains:
	say "The mountains are impassable."

Instead of going east in Mountains:
	say "The mountains are impassable."

Instead of going west in Forest1:
	say "You would need a machete to go further west."

Up a Tree is a room. "You are about 10 feet above the ground nestled among some large branches. The nearest branch above you is above your reach."
Up a Tree is in Forest Area.
Up a Tree is above Forest Path.

Instead of going up in Up a Tree:
	say "You cannot climb any higher."

Clearing is a room. "You are in a small clearing in a well marked forest path that extends to the east and west."
Clearing is in Forest Area.

North of Clearing is Forest2. South of Clearing is Forest3. West of Clearing is Behind House.
[East of Clearing is connected in Phase 7 - see Canyon View]

Instead of going up in Clearing:
	say "There is no tree here suitable for climbing."

Grating Clearing is a room. The printed name of Grating Clearing is "Clearing".
Grating Clearing is in Forest Area.
North of Forest Path is Grating Clearing. East of Grating Clearing is Forest2. West of Grating Clearing is Forest1. South of Grating Clearing is Forest Path.
The description of Grating Clearing is "You are in a clearing, with a forest surrounding you on all sides. A path leads south.[if the grate is visible and the grate is open] There is an open grating, descending into darkness.[otherwise if the grate is visible] There is a grating securely fastened into the ground.[end if]".

Instead of going north in Grating Clearing:
	say "The forest becomes impenetrable to the north."

Instead of going down in Grating Clearing:
	if the grate is not visible:
		say "You can't go that way." instead;
	if the grate is open:
		say "(through the grating)[line break]";
		move the player to Grating Room instead;
	otherwise:
		say "The grating is closed!" instead.

Section 5 - Songbird Ambient

The forest-songbird is a backdrop. The printed name of the forest-songbird is "songbird".
Understand "bird" and "songbird" and "song" as the forest-songbird.
The forest-songbird is in Forest Area.
The description of the forest-songbird is "The songbird is not here but is probably nearby."

Instead of taking the forest-songbird:
	say "The songbird is not here but is probably nearby."

Every turn when the player is in the Forest Area (this is the songbird singing rule):
	if a random chance of 15 in 100 succeeds:
		say "You hear in the distance the chirping of a song bird.[line break]".

Section 6 - Forest Trees

The forest-trees is a backdrop. The printed name of the forest-trees is "trees".
Understand "tree" and "trees" and "branch" and "large" and "forest" and "pines" and "hemlocks" as the forest-trees.
The forest-trees is in Forest Area.
The description of the forest-trees is "The trees are tall and closely grown."

Instead of climbing the forest-trees when the player is in Forest Path:
	try going up.

Instead of climbing the forest-trees when the player is in Up a Tree:
	try going up.

Section 7 - Objects Outside the House

The small mailbox is a closed openable container in West-of-House. "There is a small mailbox here."
The description of the small mailbox is "It's a small mailbox."
Understand "mailbox" and "box" as the small mailbox.
The carrying capacity of the small mailbox is 2.

Instead of taking the small mailbox:
	say "It is securely anchored."

The leaflet is in the small mailbox. The description of the leaflet is "WELCOME TO ZORK![paragraph break]ZORK is a game of adventure, danger, and low cunning. In it you will explore some of the most amazing territory ever seen by mortals. No computer should be without one!"
Understand "advertisement" and "leaflet" and "booklet" and "mail" and "small" as the leaflet.

The front door is scenery in West-of-House.
Understand "door" and "front" and "boarded" as the front door.
The description of the front door is "The door is boarded shut."

Instead of opening the front door:
	say "The door is nailed shut."

Instead of attacking the front door:
	say "You can't break down the door."

The boards are scenery in West-of-House.
Understand "boards" and "board" as the boards.
The description of the boards is "The boards are securely fastened."

Instead of taking the boards:
	say "The boards are securely fastened."

Section 8 - Kitchen Window (a door)

The kitchen-window is a door. The kitchen-window is not open. The kitchen-window is scenery.
The printed name of the kitchen-window is "kitchen window".
Understand "window" and "kitchen" and "small" as the kitchen-window.
The kitchen-window is west of Behind House and east of Kitchen.

The description of the kitchen-window is "[if the kitchen-window-touched is false]The window is slightly ajar, but not enough to allow entry.[otherwise if the kitchen-window is open]The window is open.[otherwise]The window is closed.[end if]".

The kitchen-window-touched is a truth state that varies. The kitchen-window-touched is false.

Instead of opening the kitchen-window:
	if the kitchen-window is open:
		say "It is already open." instead;
	now the kitchen-window is open;
	now the kitchen-window-touched is true;
	say "With great effort, you open the window far enough to allow entry."

Instead of closing the kitchen-window:
	if the kitchen-window is not open:
		say "It is already closed." instead;
	now the kitchen-window is not open;
	now the kitchen-window-touched is true;
	say "The window closes (more easily than it opened)."

Chapter 2 - The House Interior

Section 1 - Kitchen

Kitchen is a room. Kitchen is in House Interior.
The description of Kitchen is "You are in the kitchen of the white house. A table seems to have been used recently for the preparation of food. A passage leads to the west and a dark staircase can be seen leading upward. A dark chimney leads down and to the east is a small window which is [if the kitchen-window is open]open[otherwise]slightly ajar[end if]."

West of Kitchen is Living Room. Above Kitchen is Attic.

Instead of going down in Kitchen:
	say "Only Santa Claus climbs down chimneys."

The chimney is scenery in Kitchen. Understand "chimney" and "dark" and "narrow" as the chimney.
The description of the chimney is "The chimney leads downward, and looks climbable."

The kitchen table is a supporter in Kitchen. The kitchen table is scenery.
Understand "table" and "kitchen" as the kitchen table.

The glass bottle is a closed transparent openable container on the kitchen table. "A bottle is sitting on the table."
Understand "bottle" and "container" and "clear" and "glass" as the glass bottle.
The carrying capacity of the glass bottle is 1.

Instead of inserting something into the glass bottle when the glass bottle contains something (called the existing contents):
	say "The bottle is full."

The quantity of water is a thing in the glass bottle.
Understand "water" and "quantity" and "liquid" and "h2o" as the quantity of water.
The description of the quantity of water is "It looks like plain water."

Instead of drinking the quantity of water:
	remove the quantity of water from play;
	say "Thank you very much. I was rather thirsty (from strenuously carrying everything for you)."

The brown sack is a closed openable container on the kitchen table. "On the table is an elongated brown sack, smelling of hot peppers."
Understand "bag" and "sack" and "brown" and "elongated" and "smelly" as the brown sack.
The carrying capacity of the brown sack is 2.

Instead of smelling the brown sack:
	if the lunch is in the brown sack:
		say "It smells of hot peppers.";
	otherwise:
		say "It smells faintly of hot peppers."

The lunch is in the brown sack. The description of the lunch is "It looks like a hot pepper sandwich."
Understand "food" and "sandwich" and "lunch" and "dinner" and "hot" and "pepper" as the lunch.

Instead of eating the lunch:
	remove the lunch from play;
	say "Thank you very much. It really hit the spot."

The clove of garlic is in the brown sack. The description of the clove of garlic is "It's a clove of garlic."
Understand "garlic" and "clove" as the clove of garlic.

Section 2 - Attic

Attic is a room. "This is the attic. The only exit is a stairway leading down."
Attic is in House Interior. Attic is a dark room.

The attic table is a supporter in Attic. The attic table is scenery.
Understand "table" as the attic table.

The nasty knife is on the attic table. "On a table is a nasty-looking knife."
Understand "knives" and "knife" and "blade" and "nasty" as the nasty knife.

The rope is in Attic. "A large coil of rope is lying in the corner."
Understand "rope" and "hemp" and "coil" and "large" as the rope.
The description of the rope is "It's a large coil of sturdy hemp rope."

Section 3 - Living Room

Living Room is a room. Living Room is in House Interior.

The description of Living Room is "You are in the living room. There is a doorway to the east[if the magic-flag is true]. To the west is a cyclops-shaped opening in an old wooden door, above which is some strange gothic lettering, [otherwise], a wooden door with strange gothic lettering to the west, which appears to be nailed shut, [end if]a trophy case, [if the rug-moved is false]and a large oriental rug in the center of the room.[otherwise if the trap door is open]and a rug lying beside an open trap door.[otherwise]and a closed trap door at your feet.[end if]"

The trophy case is a transparent open unopenable container in Living Room. The trophy case is scenery. "The trophy case is mounted firmly to the wall."
Understand "case" and "trophy" as the trophy case.
The carrying capacity of the trophy case is 100.

Instead of taking the trophy case:
	say "The trophy case is securely fastened to the wall."

The sword is in Living Room. "Above the trophy case hangs an elvish sword of great antiquity."
Understand "sword" and "orcrist" and "glamdring" and "blade" and "elvish" and "old" and "antique" as the sword.
The description of the sword is "It's an old elvish sword of great antiquity."
The treasure-value of the sword is 0.

The brass lantern is in Living Room. "A battery-powered brass lantern is on the trophy case."
Understand "lamp" and "lantern" and "light" and "brass" as the brass lantern.
The description of the brass lantern is "[if the lamp-burned-out is true]The lamp has burned out.[otherwise if the brass lantern is lit]The lamp is on.[otherwise]The lamp is turned off.[end if]".

Instead of switching on the brass lantern:
	if the lamp-burned-out is true:
		say "A burned-out lamp won't light." instead;
	now the brass lantern is lit;
	say "The brass lantern is now on."

Instead of switching off the brass lantern:
	if the lamp-burned-out is true:
		say "The lamp has already burned out." instead;
	now the brass lantern is not lit;
	say "The brass lantern is now off."

The old wooden door is scenery in Living Room. Understand "door" and "wooden" and "gothic" and "strange" and "lettering" and "writing" as the old wooden door.
The description of the old wooden door is "[if the magic-flag is true]The door has a cyclops-shaped opening in it.[otherwise]The engravings translate to 'This space intentionally left blank.'[end if]".

Instead of opening the old wooden door:
	say "The door is nailed shut."

Section 4 - Rug and Trap Door Puzzle

The rug-moved is a truth state that varies. The rug-moved is false.

The carpet is scenery in Living Room. Understand "rug" and "carpet" and "large" and "oriental" as the carpet.
The description of the carpet is "[if the rug-moved is false]A large oriental rug covers the center of the room.[otherwise]The carpet has been moved to one side of the room.[end if]".

Instead of taking the carpet:
	say "The rug is extremely heavy and cannot be carried."

Instead of pushing the carpet:
	try the-rug-move.
Instead of pulling the carpet:
	try the-rug-move.

The-rug-move is an action applying to nothing.

Carry out the-rug-move:
	if the rug-moved is true:
		say "Having moved the carpet previously, you find it impossible to move it again." instead;
	now the rug-moved is true;
	now the trap door is visible;
	say "With a great effort, the rug is moved to one side of the room, revealing the dusty cover of a closed trap door."

Instead of looking under the carpet:
	if the rug-moved is false and the trap door is not open:
		say "Underneath the rug is a closed trap door. As you drop the corner of the rug, the trap door is once again concealed from view.";
	otherwise if the trap door is open:
		say "You see a rickety staircase descending into darkness.";
	otherwise:
		say "There is nothing else under the carpet."

Raising-rug is an action applying to one thing. Understand "raise [something]" as raising-rug when the noun is the carpet.
Instead of raising-rug the carpet:
	if the rug-moved is true:
		say "The rug is too heavy to lift.";
	otherwise:
		say "The rug is too heavy to lift, but in trying to take it you have noticed an irregularity beneath it."

The trap door is a door. The trap door is scenery. The trap door is closed and openable.
Understand "door" and "trapdoor" and "trap-door" and "cover" and "trap" and "dusty" as the trap door.
The trap door is below Living Room and above Cellar.

A thing can be visible or invisible. A thing is usually visible. The trap door is invisible.

Before doing anything to the trap door when the trap door is invisible:
	say "You can't see any such thing." instead.

Before going down in Living Room:
	if the rug-moved is false:
		say "You can't go that way." instead;
	if the trap door is not open:
		say "The trap door is closed." instead.

Instead of opening the trap door when the player is in Living Room:
	if the trap door is invisible:
		say "You can't see any such thing." instead;
	if the trap door is open:
		say "It is already open." instead;
	now the trap door is open;
	say "The door reluctantly opens to reveal a rickety staircase descending into darkness."

Instead of closing the trap door when the player is in Living Room:
	if the trap door is not open:
		say "It is already closed." instead;
	now the trap door is not open;
	say "The door swings shut and closes."

The trap-door-touched is a truth state that varies. The trap-door-touched is false.

Section 5 - Objects in the Tree

The bird's nest is in Up a Tree. "Beside you on the branch is a small bird's nest."
Understand "nest" and "bird's" as the bird's nest.
The bird's nest is an open container. The carrying capacity of the bird's nest is 3.
The description of the bird's nest is "The bird's nest is a rough collection of twigs and grass."

The jewel-encrusted egg is in the bird's nest. "In the bird's nest is a large egg encrusted with precious jewels, apparently scavenged by a childless songbird. The egg is covered with fine gold inlay, and ornamented in lapis lazuli and mother-of-pearl. Unlike most eggs, this one is hinged and closed with a delicate looking clasp. The egg appears extremely fragile."
Understand "egg" and "jewel" and "encrusted" and "jeweled" and "bird's" as the jewel-encrusted egg.
The jewel-encrusted egg is a closed openable container. The carrying capacity of the jewel-encrusted egg is 1.
The treasure-value of the jewel-encrusted egg is 5.
The point-value of the jewel-encrusted egg is 5.

The golden clockwork canary is in the jewel-encrusted egg. "There is a golden clockwork canary nestled in the egg. It has ruby eyes and a silver beak. Through a crystal window below its left wing you can see intricate machinery inside. It appears to have wound down."
Understand "canary" and "clockwork" and "gold" and "golden" as the golden clockwork canary.
The treasure-value of the golden clockwork canary is 6.
The description of the golden clockwork canary is "The canary is a beautiful golden clockwork device. It appears to have wound down."

The broken jewel-encrusted egg is a thing. The printed name of the broken jewel-encrusted egg is "broken jewel-encrusted egg". "There is a somewhat ruined egg here."
Understand "broken" and "egg" and "jewel" and "encrusted" as the broken jewel-encrusted egg.
The broken jewel-encrusted egg is an open container. The carrying capacity of the broken jewel-encrusted egg is 1.
The treasure-value of the broken jewel-encrusted egg is 2.

The broken clockwork canary is a thing. The printed name of the broken clockwork canary is "broken clockwork canary". "There is a golden clockwork canary nestled in the egg. It seems to have recently had a bad experience. The mountings for its jewel-like eyes are empty, and its silver beak is crumpled. Through a cracked crystal window below its left wing you can see the remains of intricate machinery. It is not clear what result winding it would have, as the mainspring seems sprung."
Understand "broken" and "canary" and "clockwork" and "gold" and "golden" as the broken clockwork canary.
The treasure-value of the broken clockwork canary is 1.

The beautiful brass bauble is a thing. "A beautiful brass bauble is here."
Understand "bauble" and "brass" and "beautiful" as the beautiful brass bauble.
The treasure-value of the beautiful brass bauble is 1.
The point-value of the beautiful brass bauble is 1.

Section 6 - Egg Fragility

The egg-broken is a truth state that varies. The egg-broken is false.

To break-the-egg:
	if the egg-broken is true, stop;
	now the egg-broken is true;
	if the golden clockwork canary is in the jewel-encrusted egg:
		now the broken clockwork canary is in the broken jewel-encrusted egg;
		remove the golden clockwork canary from play;
	otherwise:
		remove the broken clockwork canary from play;
	now the broken jewel-encrusted egg is in the holder of the jewel-encrusted egg;
	remove the jewel-encrusted egg from play.

Instead of opening the jewel-encrusted egg:
	if the jewel-encrusted egg is open:
		say "The egg is already open." instead;
	say "You have neither the tools nor the expertise."

Prying open it with is an action applying to two things. Understand "open [something] with [something]" as prying open it with.

Instead of prying open the jewel-encrusted egg with something:
	if the jewel-encrusted egg is open:
		say "The egg is already open." instead;
	if the second noun is a weapon:
		say "The egg is now open, but the clumsiness of your attempt has seriously compromised its esthetic appeal.";
		break-the-egg;
	otherwise:
		say "The concept of using a [second noun] is certainly original."

A thing can be a weapon or not a weapon. A thing is usually not a weapon.
The sword is a weapon. The nasty knife is a weapon.

Instead of attacking the jewel-encrusted egg:
	say "Your rather indelicate handling of the egg has caused it some damage, although you have succeeded in opening it.";
	break-the-egg.

After dropping the jewel-encrusted egg in Up a Tree:
	say "The egg falls to the ground and springs open, seriously damaged.";
	now the jewel-encrusted egg is in Forest Path;
	break-the-egg.

After dropping the bird's nest in Up a Tree:
	if the jewel-encrusted egg is in the bird's nest:
		say "The nest falls to the ground, and the egg spills out of it, seriously damaged.";
		now the bird's nest is in Forest Path;
		now the jewel-encrusted egg is in Forest Path;
		break-the-egg;
	otherwise:
		say "The bird's nest falls to the ground.";
		now the bird's nest is in Forest Path.

Section 7 - Canary Wind-up and Bauble

The canary-sang is a truth state that varies. The canary-sang is false.

Winding is an action applying to one thing. Understand "wind [something]" and "wind up [something]" as winding.
Carry out winding: say "You can't wind that."

Instead of winding the golden clockwork canary:
	if the canary-sang is false and the player is in the Forest Area:
		now the canary-sang is true;
		say "The canary chirps, slightly off-key, an aria from a forgotten opera. From out of the greenery flies a lovely songbird. It perches on a limb just over your head and opens its beak to sing. As it does so a beautiful brass bauble drops from its mouth, bounces off the top of your head, and lands glimmering in the grass. As the canary winds down, the songbird flies away.";
		if the player is in Up a Tree:
			now the beautiful brass bauble is in Forest Path;
		otherwise:
			now the beautiful brass bauble is in the location of the player;
	otherwise:
		say "The canary chirps blithely, if somewhat tinnily, for a short time."

Instead of winding the broken clockwork canary:
	say "There is an unpleasant grinding noise from inside the canary."

Chapter 3 - Global Flags

The troll-flag is a truth state that varies. The troll-flag is false.
The magic-flag is a truth state that varies. The magic-flag is false.
The cyclops-flag is a truth state that varies. The cyclops-flag is false.
The dome-flag is a truth state that varies. The dome-flag is false.
The lld-flag is a truth state that varies. The lld-flag is false.
The low-tide is a truth state that varies. The low-tide is false.
The rainbow-flag is a truth state that varies. The rainbow-flag is false.
The won-flag is a truth state that varies. The won-flag is false.
The grate-revealed is a truth state that varies. The grate-revealed is false.
The coffin-cure is a truth state that varies. The coffin-cure is false.
The gate-flag is a truth state that varies. The gate-flag is false.
The gates-open is a truth state that varies. The gates-open is false.

Part 3 - Underground Rooms

Chapter 1 - Cellar and Vicinity

Cellar is a dark room. "You are in a dark and damp cellar with a narrow passageway leading north, and a crawlway to the south. On the west is the bottom of a steep metal ramp which is unclimbable."
Cellar is in the Underground.

Instead of going west in Cellar:
	say "You try to ascend the ramp, but it is impossible, and you slide back down."

Instead of opening the trap door when the player is in Cellar:
	if the trap door is not open:
		say "The door is locked from above." instead.

Instead of closing the trap door when the player is in Cellar:
	if the trap door is open:
		say "The door closes and locks.";
		now the trap door is not open;
	otherwise:
		say "It is already closed."

After going down from Living Room to Cellar:
	if the trap-door-touched is false:
		now the trap-door-touched is true;
		now the trap door is not open;
		say "The trap door crashes shut, and you hear someone barring it.[paragraph break]";
	continue the action.

North of Cellar is Troll-Room. South of Cellar is East-of-Chasm.

Chapter 2 - Troll-Room

Troll-Room is a dark room. The printed name of Troll-Room is "The Troll Room". "This is a small room with passages to the east and south and a forbidding hole leading west. Bloodstains and deep scratches (perhaps made by an axe) mar the walls."
Troll-Room is in the Underground.

Instead of going east in Troll-Room:
	if the troll-flag is false:
		say "The troll fends you off with a menacing gesture.";
	otherwise:
		move the player to East-West Passage.

Instead of going west in Troll-Room:
	if the troll-flag is false:
		say "The troll fends you off with a menacing gesture.";
	otherwise:
		move the player to Maze1.

Chapter 3 - Troll NPC

The troll is a person in Troll-Room. "[if the troll-unconscious is true]An unconscious troll is sprawled on the floor. All passages out of the room are open.[otherwise if the troll carries the bloody axe]A nasty-looking troll, brandishing a bloody axe, blocks all passages out of the room.[otherwise]A pathetically babbling troll is here.[end if]"
Understand "troll" and "nasty" as the troll.
The description of the troll is "[if the troll-unconscious is true]An unconscious troll is sprawled on the floor. All passages out of the room are open.[otherwise if the troll carries the bloody axe]A nasty-looking troll, brandishing a bloody axe, blocks all passages out of the room.[otherwise]A pathetically babbling troll is here.[end if]".

The troll-unconscious is a truth state that varies. The troll-unconscious is false.
The troll-unconscious-timer is a number that varies. The troll-unconscious-timer is 0.

The troll-strength is a number that varies. The troll-strength is 2.

The bloody axe is carried by the troll. "There is a bloody axe here."
Understand "axe" and "ax" and "bloody" as the bloody axe.
The bloody axe is a weapon.

To kill the troll with fog:
	say "Almost as soon as the troll breathes his last breath, a cloud of sinister black fog envelops him, and when the fog lifts, the carcass has disappeared.";
	now the troll is defeated;
	now the troll-flag is true;
	if the troll carries the bloody axe:
		now the bloody axe is in Troll-Room;
	remove the troll from play.

Instead of taking the bloody axe when the troll is not defeated and the troll carries the bloody axe:
	say "The troll swings it out of your reach."

Instead of attacking the troll:
	if the troll is defeated:
		say "There is no troll here.";
	otherwise if the troll-unconscious is true:
		kill the troll with fog;
	otherwise:
		let W be a random weapon carried by the player;
		if W is nothing:
			say "Striking the troll with your bare hands is a losing proposition. I'd recommend a weapon.";
		otherwise:
			let hit-chance be a random number between 1 and 10;
			if hit-chance is at least 4:
				decrease the troll-strength by 1;
				if the troll-strength is at most 0:
					now the troll-unconscious is true;
					now the troll-unconscious-timer is 3;
					now the troll-flag is true;
					if the troll carries the bloody axe:
						now the bloody axe is in Troll-Room;
					say "The troll appears dazed. He stumbles and falls to the floor unconscious.";
				otherwise:
					say "The troll takes a step backwards in pain.";
			otherwise:
				say "The troll dodges your blow."

Instead of destroying the troll:
	if the troll is defeated:
		say "There is no troll here.";
	otherwise if the troll-unconscious is true:
		kill the troll with fog;
	otherwise:
		say "The troll laughs at your puny gesture."

Instead of giving something to the troll:
	if the troll-unconscious is true:
		say "The troll is unconscious.";
	otherwise if the noun is the bloody axe:
		say "The troll scratches his head in confusion, then takes the axe.";
		now the troll carries the bloody axe;
	otherwise if the noun is the troll:
		say "You would have to get the troll first, and that seems unlikely.";
	otherwise:
		say "The troll, who is not overly proud, graciously accepts the gift";
		if the noun is a weapon:
			if a random chance of 1 in 5 succeeds:
				say " and eats it hungrily. Poor troll, he dies from an internal hemorrhage and his carcass disappears in a sinister black fog.";
				remove the noun from play;
				kill the troll with fog;
			otherwise:
				say " and, being for the moment sated, throws it back. Fortunately, the troll has poor control, and the [noun] falls to the floor. He does not look pleased.";
				now the noun is in Troll-Room;
		otherwise:
			say " and not having the most discriminating tastes, gleefully eats it.";
			if the noun is a container:
				spill the contents of the noun;
			remove the noun from play.

Instead of throwing something at the troll:
	if the troll-unconscious is true:
		say "The troll is unconscious.";
	otherwise if the noun is the bloody axe and the troll carries the bloody axe:
		say "You would have to get the axe first, and that seems unlikely.";
	otherwise if the noun is the bloody axe:
		say "The troll scratches his head in confusion, then takes the axe.";
		now the troll carries the bloody axe;
	otherwise:
		say "The troll, who is remarkably coordinated, catches the [noun]";
		if the noun is a weapon:
			if a random chance of 1 in 5 succeeds:
				say " and eats it hungrily. Poor troll, he dies from an internal hemorrhage and his carcass disappears in a sinister black fog.";
				remove the noun from play;
				kill the troll with fog;
			otherwise:
				say " and, being for the moment sated, throws it back. Fortunately, the troll has poor control, and the [noun] falls to the floor. He does not look pleased.";
				now the noun is in Troll-Room;
		otherwise:
			say " and not having the most discriminating tastes, gleefully eats it.";
			if the noun is a container:
				spill the contents of the noun;
			remove the noun from play.

Instead of taking the troll:
	say "The troll spits in your face, grunting [quotation mark]Better luck next time[quotation mark] in a rather barbarous accent."

Instead of pushing the troll:
	say "The troll spits in your face, grunting [quotation mark]Better luck next time[quotation mark] in a rather barbarous accent."

Instead of asking the troll about:
	say "The troll isn't much of a conversationalist."

Instead of telling the troll about:
	say "The troll isn't much of a conversationalist."

Instead of answering the troll that:
	say "The troll isn't much of a conversationalist."

Instead of listening to the troll:
	say "Every so often the troll says something, probably uncomplimentary, in his guttural tongue."

Every turn when the troll is not defeated and the troll-unconscious is false and the troll is in Troll-Room and the player is in Troll-Room and the troll does not carry the bloody axe (this is the troll weapon recovery rule):
	if the bloody axe is in Troll-Room and a random chance of 3 in 4 succeeds:
		now the troll carries the bloody axe;
		now the troll-flag is false;
		say "The troll, angered and humiliated, recovers his weapon. He appears to have an axe to grind with you.";
	otherwise:
		say "The troll, disarmed, cowers in terror, pleading for his life in the guttural tongue of the trolls."

Every turn when the troll is not defeated and the troll-unconscious is false and the troll carries the bloody axe and the troll is in Troll-Room and the player is in Troll-Room (this is the troll attacks rule):
	if a random chance of 1 in 3 succeeds:
		let W be a random weapon carried by the player;
		if W is not nothing:
			say "The troll swings his axe, but you parry the blow with your [W].";
		otherwise:
			say "The troll hits you with a glancing blow from his axe.";
			die saying "The wound is fatal."

Every turn when the troll-unconscious is true and the troll-unconscious-timer > 0 (this is the troll recovery rule):
	decrease the troll-unconscious-timer by 1;
	if the troll-unconscious-timer is 0:
		now the troll-unconscious is false;
		now the troll-flag is false;
		now the troll-strength is 2;
		if the bloody axe is in Troll-Room:
			now the troll carries the bloody axe;
		if the player is in Troll-Room:
			say "The troll stirs, quickly resuming a fighting stance."

Chapter 4 - East-of-Chasm

East-of-Chasm is a dark room. "You are on the east edge of a chasm, the bottom of which cannot be seen. A narrow passage goes north, and the path you are on continues to the east."
The printed name of East-of-Chasm is "East of Chasm".
East-of-Chasm is in the Underground.

East of East-of-Chasm is Gallery.

Instead of going down in East-of-Chasm:
	say "The chasm probably leads straight to the infernal regions."

Gallery is a dark room. "This is an art gallery. Most of the paintings have been stolen by vandals with exceptional taste. The vandals left through either the north or west exits."
Gallery is in the Underground.

North of Gallery is Studio.

Studio is a dark room. "This appears to have been an artist's studio. The walls and floors are splattered with paints of 69 different colors. Strangely enough, nothing of value is hanging here. At the south end of the room is an open door (also covered with paint). A dark and narrow chimney leads up from a fireplace; although you might be able to get up it, it seems unlikely you could get back down."
Studio is in the Underground.

The ZORK owner's manual is in Studio. "Loosely attached to a wall is a small piece of paper."
Understand "manual" and "piece" and "paper" and "zork" and "owner's" and "small" as the ZORK owner's manual.
The description of the ZORK owner's manual is "Congratulations![paragraph break]You are the privileged owner of ZORK I: The Great Underground Empire, a self-contained and self-maintaining universe. If used and maintained in accordance with normal operating practices for small universes, ZORK will provide many months of trouble-free operation."

The painting is in Gallery. "Fortunately, there is still one chance for you to be a vandal, for on the far wall is a painting of unparalleled beauty."
Understand "painting" and "art" and "canvas" and "beautiful" as the painting.
The description of the painting is "This is a masterwork of painting. It depicts a serene scene of a farmhouse on a hillside."
The treasure-value of the painting is 4.
The point-value of the painting is 6.

Chapter 5 - Maze

Maze1 is a dark room. The printed name of Maze1 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze1 is in the Underground.
North of Maze1 is Maze1. South of Maze1 is Maze2. West of Maze1 is Maze4.

Maze2 is a dark room. The printed name of Maze2 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze2 is in the Underground.
South of Maze2 is Maze1. East of Maze2 is Maze3.

Instead of going down in Maze2:
	move the player to Maze4.

Maze3 is a dark room. The printed name of Maze3 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze3 is in the Underground.
West of Maze3 is Maze2. North of Maze3 is Maze4. Up from Maze3 is Maze5.

Maze4 is a dark room. The printed name of Maze4 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze4 is in the Underground.
West of Maze4 is Maze3. North of Maze4 is Maze1. East of Maze4 is Dead End 1.

Dead End 1 is a dark room. The printed name of Dead End 1 is "Dead End". "You have come to a dead end in the maze."
Dead End 1 is in the Underground.
South of Dead End 1 is Maze4.

Maze5 is a dark room. The printed name of Maze5 is "Maze". "This is part of a maze of twisty little passages, all alike.[line break]A skeleton, probably the remains of a luckless adventurer, lies here."
Maze5 is in the Underground.
East of Maze5 is Dead End 2. North of Maze5 is Maze3. Southwest of Maze5 is Maze6.

The skeleton is scenery in Maze5.  Understand "bones" and "skeleton" and "body" as the skeleton.
The description of the skeleton is "It's a skeleton, probably the remains of a luckless adventurer."

Instead of taking the skeleton:
	skeleton-curse.
Instead of pushing the skeleton:
	skeleton-curse.
Instead of attacking the skeleton:
	skeleton-curse.

To skeleton-curse:
	say "A ghost appears in the room and is appalled at your desecration of the remains of a fellow adventurer. He casts a curse on your valuables and banishes them to the Land of the Living Dead.";
	repeat with item running through things carried by the player:
		if the treasure-value of item is greater than 0:
			now item is in Land of the Dead.

The burned-out lantern is in Maze5. "The deceased adventurer's useless lantern is here."
Understand "lantern" and "lamp" and "rusty" and "burned" and "dead" and "useless" as the burned-out lantern when the burned-out lantern is visible.

The leather bag of coins is in Maze5. "An old leather bag, bulging with coins, is here."
Understand "bag" and "coins" and "old" and "leather" as the leather bag of coins.
The treasure-value of the leather bag of coins is 10.
The point-value of the leather bag of coins is 5.

The skeleton key is in Maze5. Understand "key" and "skeleton" as the skeleton key.
The description of the skeleton key is "It's a rusty old skeleton key."

The rusty knife is in Maze5. "Beside the skeleton is a rusty knife."
Understand "knife" and "rusty" as the rusty knife.
The rusty knife is a weapon.

Dead End 2 is a dark room. The printed name of Dead End 2 is "Dead End". "You have come to a dead end in the maze."
Dead End 2 is in the Underground.
West of Dead End 2 is Maze5.

Maze6 is a dark room. The printed name of Maze6 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze6 is in the Underground.
Down from Maze6 is Maze5. East of Maze6 is Maze7. West of Maze6 is Maze6. Up from Maze6 is Maze9.

Maze7 is a dark room. The printed name of Maze7 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze7 is in the Underground.
Up from Maze7 is Maze14. West of Maze7 is Maze6. East of Maze7 is Maze8. South of Maze7 is Maze15.

Instead of going down in Maze7:
	move the player to Dead End 1.

Maze8 is a dark room. The printed name of Maze8 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze8 is in the Underground.
Northeast of Maze8 is Maze7. West of Maze8 is Maze8. Southeast of Maze8 is Dead End 3.

Dead End 3 is a dark room. The printed name of Dead End 3 is "Dead End". "You have come to a dead end in the maze."
Dead End 3 is in the Underground.
North of Dead End 3 is Maze8.

Maze9 is a dark room. The printed name of Maze9 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze9 is in the Underground.
North of Maze9 is Maze6. East of Maze9 is Maze10. South of Maze9 is Maze13. West of Maze9 is Maze12. Northwest of Maze9 is Maze9.

Instead of going down in Maze9:
	move the player to Maze11.

Maze10 is a dark room. The printed name of Maze10 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze10 is in the Underground.
East of Maze10 is Maze9. West of Maze10 is Maze13. Up from Maze10 is Maze11.

Maze11 is a dark room. The printed name of Maze11 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze11 is in the Underground.
Northeast of Maze11 is Grating Room. Down from Maze11 is Maze10. Northwest of Maze11 is Maze13. Southwest of Maze11 is Maze12.

Grating Room is a dark room. Grating Room is in the Underground.
Southwest of Grating Room is Maze11.
The description of Grating Room is "You are in a small room near the maze. There are twisty passages in the immediate vicinity.[if the grate is open] Above you is an open grating with sunlight pouring in.[otherwise if the grate is not locked] Above you is a grating.[otherwise] Above you is a grating locked with a skull-and-crossbones lock.[end if]".

The grate is a door. The grate is scenery. The grate is closed and openable and lockable and locked. The matching key of the grate is the skeleton key.
Understand "grate" and "grating" as the grate.
The grate is above Grating Room and below Grating Clearing.

Before locking the grate with something when the grate is open:
	say "You'd need to close the grate first." instead.

Instead of going up in Grating Room:
	if the grate is not open:
		say "The grating is closed." instead;
	move the player to Grating Clearing.

Maze12 is a dark room. The printed name of Maze12 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze12 is in the Underground.
Southwest of Maze12 is Maze11. East of Maze12 is Maze13. Up from Maze12 is Maze9. North of Maze12 is Dead End 4.

Instead of going down in Maze12:
	move the player to Maze5.

Dead End 4 is a dark room. The printed name of Dead End 4 is "Dead End". "You have come to a dead end in the maze."
Dead End 4 is in the Underground.
South of Dead End 4 is Maze12.

Maze13 is a dark room. The printed name of Maze13 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze13 is in the Underground.
East of Maze13 is Maze9. Down from Maze13 is Maze12. South of Maze13 is Maze10. West of Maze13 is Maze11.

Maze14 is a dark room. The printed name of Maze14 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze14 is in the Underground.
West of Maze14 is Maze15. Northwest of Maze14 is Maze14. Northeast of Maze14 is Maze7. South of Maze14 is Maze7.

Maze15 is a dark room. The printed name of Maze15 is "Maze". "This is part of a maze of twisty little passages, all alike."
Maze15 is in the Underground.
West of Maze15 is Maze14. South of Maze15 is Maze7. Southeast of Maze15 is Cyclops-Room.

Chapter 6 - Grating and Leaves

The pile of leaves is in Grating Clearing. "On the ground is a pile of leaves."
Understand "leaves" and "leaf" and "pile" as the pile of leaves.

Instead of burning the pile of leaves:
	if the grate-revealed is false:
		remove the pile of leaves from play;
		now the grate-revealed is true;
		now the grate is visible;
		say "The leaves burn and are consumed. In the clearing there is now a grating visible in the ground.";
	otherwise:
		remove the pile of leaves from play;
		say "The leaves burn and are consumed."

Instead of taking the pile of leaves:
	say "You take the pile of leaves.";
	now the player carries the pile of leaves.

Instead of looking under the pile of leaves:
	if the grate-revealed is false:
		say "Underneath the pile of leaves you can see a grating.";
		now the grate-revealed is true;
		now the grate is visible;
	otherwise:
		say "There is nothing else under the leaves."

Chapter 7 - Cyclops-Room, Strange Passage, Treasure Room

Cyclops-Room is a dark room. Cyclops-Room is in the Underground.
The printed name of Cyclops-Room is "Cyclops Room".

The description of Cyclops-Room is "This room has an exit on the northwest, and a staircase leading up.[paragraph break][if the magic-flag is true]The east wall, previously solid, now has a cyclops-sized opening in it.[otherwise if the cyclops-asleep is true]The cyclops is sleeping blissfully at the foot of the stairs.[otherwise if the cyclops is in Cyclops-Room and the cyclops-wrath is 0]A cyclops, who looks prepared to eat horses (much less mere adventurers), blocks the staircase. From his state of health, and the bloodstains on the walls, you gather that he is not very friendly, though he likes people.[otherwise if the cyclops is in Cyclops-Room and the cyclops-wrath > 0]The cyclops is standing in the corner, eyeing you closely. I don't think he likes you very much. He looks extremely hungry, even for a cyclops.[otherwise if the cyclops is in Cyclops-Room and the cyclops-fed is true]The cyclops, having eaten the hot peppers, appears to be gasping. His enflamed tongue protrudes from his man-sized mouth.[end if]".

Instead of going east in Cyclops-Room:
	if the magic-flag is true:
		move the player to Strange Passage;
	otherwise:
		say "The east wall is solid rock."

Instead of going up in Cyclops-Room:
	if the cyclops-flag is true:
		move the player to Treasure Room;
	otherwise:
		say "The cyclops doesn[apostrophe]t look like he'll let you past."

Strange Passage is a dark room. "This is a long passage. To the west is one entrance. On the east there is an old wooden door, with a large opening in it (about cyclops sized)."
Strange Passage is in the Underground.
West of Strange Passage is Cyclops-Room. East of Strange Passage is Living Room.

Treasure Room is a dark room. "This is a large room, whose east wall is solid granite. A number of discarded bags, which crumble at your touch, are scattered about on the floor. There is an exit down a staircase."
Treasure Room is in the Underground.
Down from Treasure Room is Cyclops-Room.

Chapter 8 - Cyclops NPC

The cyclops is a person in Cyclops-Room. "A cyclops, who looks like he hasn't eaten in a while, is blocking the staircase."
Understand "cyclops" and "monster" and "eye" and "hungry" and "giant" as the cyclops.
The description of the cyclops is "[if the cyclops-asleep is true]The cyclops is sleeping like a baby, albeit a very ugly one.[otherwise]A hungry cyclops is standing at the foot of the stairs.[end if]".

The cyclops-fed is a truth state that varies. The cyclops-fed is false.
The cyclops-watered is a truth state that varies. The cyclops-watered is false.
The cyclops-asleep is a truth state that varies. The cyclops-asleep is false.
The cyclops-wrath is a number that varies. The cyclops-wrath is 0.
The cyclops-wrath-timer is a number that varies. The cyclops-wrath-timer is 0.

Instead of giving the lunch to the cyclops:
	if the cyclops-asleep is true:
		say "No use. He's fast asleep.";
	otherwise:
		remove the lunch from play;
		now the cyclops-fed is true;
		if the cyclops-wrath > 0:
			now the cyclops-wrath is 0 minus the cyclops-wrath;
		otherwise if the cyclops-wrath is 0:
			now the cyclops-wrath is -1;
		now the cyclops-wrath-timer is 1;
		say "The cyclops says [quotation mark]Mmm Mmm. I love hot peppers! But oh, could I use a drink. Perhaps I could drink the blood of that thing.[quotation mark] From the gleam in his eye, it could be surmised that you are [quotation mark]that thing.[quotation mark]"

Instead of giving the quantity of water to the cyclops:
	if the cyclops-asleep is true:
		say "No use. He's fast asleep.";
	otherwise if the cyclops-fed is false:
		say "The cyclops apparently is not thirsty and refuses your generous offer.";
	otherwise:
		remove the quantity of water from play;
		now the cyclops-watered is true;
		now the cyclops-asleep is true;
		now the cyclops-flag is true;
		say "The cyclops takes the bottle, checks that it's open, and drinks the water. A moment later, he lets out a yawn that nearly blows you over, and then falls fast asleep (what did you put in that drink, anyway?)."

Instead of giving the glass bottle to the cyclops when the quantity of water is in the glass bottle:
	try giving the quantity of water to the cyclops.

Instead of giving something to the cyclops:
	if the cyclops-asleep is true:
		say "No use. He's fast asleep.";
	otherwise if the noun is the clove of garlic:
		say "The cyclops may be hungry, but there is a limit.";
	otherwise if the noun is not the lunch and the noun is not the quantity of water and the noun is not the glass bottle:
		say "The cyclops is not so stupid as to eat THAT!"

Instead of attacking the cyclops:
	if the cyclops-asleep is true:
		say "The cyclops yawns and stares at the thing that woke him up.";
		now the cyclops-asleep is false;
		now the cyclops-flag is false;
		if the cyclops-wrath < 0:
			now the cyclops-wrath is 0 minus the cyclops-wrath;
	otherwise:
		now the cyclops-wrath-timer is 1;
		say "The cyclops shrugs but otherwise ignores your pitiful attempt."

Every turn when the cyclops-wrath-timer > 0 and the player is in Cyclops-Room and the cyclops-asleep is false (this is the cyclops wrath rule):
	let W be the cyclops-wrath;
	if W < 0:
		let W be 0 minus W;
	if W > 5:
		die saying "The cyclops, tired of all of your games and trickery, grabs you firmly. As he licks his chops, he says [quotation mark]Mmm. Just like Mom used to make [apostrophe]em.[quotation mark] It[apostrophe]s nice to be appreciated.";
	if the cyclops-wrath >= 0:
		increase the cyclops-wrath by 1;
	otherwise:
		decrease the cyclops-wrath by 1;
	let V be the cyclops-wrath;
	if V < 0:
		let V be 0 minus V;
	if V is 1:
		say "The cyclops seems somewhat agitated.";
	otherwise if V is 2:
		say "The cyclops appears to be getting more agitated.";
	otherwise if V is 3:
		say "The cyclops is moving about the room, looking for something.";
	otherwise if V is 4:
		say "The cyclops was looking for salt and pepper. No doubt they are condiments for his upcoming snack.";
	otherwise if V is 5:
		say "The cyclops is moving toward you in an unfriendly manner.";
	otherwise if V is 6:
		say "You have two choices: 1. Leave  2. Become dinner."

Odysseusing is an action applying to nothing.
Understand "odysseus" and "ulysses" as odysseusing.

Carry out odysseusing:
	if the player is in Cyclops-Room and the cyclops is in Cyclops-Room and the cyclops-asleep is false:
		say "The cyclops, hearing the name of his father's deadly nemesis, flees the room by knocking down the wall on the east of the room.";
		remove the cyclops from play;
		now the cyclops-flag is true;
		now the magic-flag is true;
	otherwise if the player is in Cyclops-Room and the cyclops-asleep is true:
		say "The cyclops is asleep and can't hear you.";
	otherwise:
		say "Wasn't he a sailor?"

Destroying is an action applying to one thing.
Understand "destroy [something]" and "break [something]" and "mung [something]" as destroying.
Carry out destroying: try attacking the noun.

Instead of destroying the cyclops:
	if the cyclops-asleep is true:
		say "The cyclops yawns and stares at the thing that woke him up.";
		now the cyclops-asleep is false;
		now the cyclops-flag is false;
		if the cyclops-wrath < 0:
			now the cyclops-wrath is 0 minus the cyclops-wrath;
	otherwise:
		now the cyclops-wrath-timer is 1;
		say "[quotation mark]Do you think I'm as stupid as my father was?[quotation mark], he says, dodging."

Instead of asking the cyclops about:
	if the cyclops-asleep is true:
		say "No use talking to him. He's fast asleep.";
	otherwise:
		say "The cyclops prefers eating to making conversation."

Instead of telling the cyclops about:
	if the cyclops-asleep is true:
		say "No use talking to him. He's fast asleep.";
	otherwise:
		say "The cyclops prefers eating to making conversation."

Instead of answering the cyclops that:
	if the cyclops-asleep is true:
		say "No use talking to him. He's fast asleep.";
	otherwise:
		say "The cyclops prefers eating to making conversation."

The chalice is in Treasure Room. "There is a silver chalice, intricately engraved, here."
Understand "chalice" and "cup" and "silver" as the chalice.
The description of the chalice is "It's a beautifully engraved silver chalice."
The treasure-value of the chalice is 10.
The point-value of the chalice is 5.

Chapter 9 - East-West Passage and Round Room Area

East-West Passage is a dark room. "This is a narrow east-west passageway. There is a narrow stairway leading down at the north end of the room."
East-West Passage is in the Underground.

East of Troll-Room is nowhere. [blocked by troll check - handled by instead rule]
East of East-West Passage is Round Room. West of East-West Passage is Troll-Room. Down from East-West Passage is Chasm.
North of East-West Passage is Chasm.

Round Room is a dark room. "This is a circular stone room with passages in all directions. Several of them have unfortunately been blocked by cave-ins."
Round Room is in the Underground.
East of Round Room is Loud Room. North of Round Room is North-South Passage. South of Round Room is Narrow Passage. Southeast of Round Room is Engravings Cave.

Chapter 10 - Dam and Reservoir Area

Deep Canyon is a dark room. Deep Canyon is in the Underground.
The description of Deep Canyon is "You are on the south edge of a deep canyon. Passages lead off to the east, northwest and southwest. A stairway leads down.[if the gates-open is true and the low-tide is false] You can hear a loud roaring sound, like that of rushing water, from below.[otherwise if the gates-open is false and the low-tide is true][otherwise] You can hear the sound of flowing water from below.[end if]".
Northwest of Deep Canyon is Reservoir-South. Southwest of Deep Canyon is North-South Passage. Down from Deep Canyon is Loud Room.

Loud Room is a dark room. Loud Room is in the Underground.
East of Loud Room is Damp Cave. West of Loud Room is Round Room. Up from Loud Room is Deep Canyon.

The loud-room-quiet is a truth state that varies. The loud-room-quiet is false.

The description of Loud Room is "This is a large room with a ceiling which cannot be detected from the ground. There is a narrow passage from east to west and a stone stairway leading upward.[if the loud-room-quiet is true or (the gates-open is false and the low-tide is true)] The room is eerie in its quietness.[otherwise] The room is deafeningly loud with an undetermined rushing sound. The sound seems to reverberate from all of the walls, making it difficult even to think.[end if]".

The platinum bar is in Loud Room. "On the ground is a large platinum bar."
Understand "bar" and "platinum" and "large" as the platinum bar.
The treasure-value of the platinum bar is 10.
The point-value of the platinum bar is 5.

Instead of taking the platinum bar when the loud-room-quiet is false:
	say "The acoustics of the room change as the platinum bar is carried through it. Unfortunately, the unpleasant consequences of this action are that the room now reflects sound more perfectly, and the painful clanging increases to an unbearable level. You stagger and drop the bar, and run from the room.";
	move the player to Round Room.

Echoing is an action applying to nothing.
Understand "echo" as echoing.

Carry out echoing:
	if the player is in Loud Room:
		if the loud-room-quiet is false:
			now the loud-room-quiet is true;
			say "The acoustics of the room change subtly, and the clanging dies away to a distant murmur.";
		otherwise:
			say "Echo echo echo...";
	otherwise:
		say "Echo echo echo..."

Damp Cave is a dark room. "This cave has exits to the west and east, and narrows to a crack toward the south. The earth is particularly damp here."
Damp Cave is in the Underground.

Instead of going south in Damp Cave:
	say "It is too narrow for most insects."

North-South Passage is a dark room. "This is a high north-south passage, which forks to the northeast."
North-South Passage is in the Underground.
North of North-South Passage is Chasm. Northeast of North-South Passage is Deep Canyon. South of North-South Passage is Round Room.

Chasm is a dark room. The printed name of Chasm is "Chasm". "A chasm runs southwest to northeast and the path follows it. You are on the south side of the chasm, where a crack opens into a passage."
Chasm is in the Underground.
Northeast of Chasm is Reservoir-South. Southwest of Chasm is East-West Passage. Up from Chasm is East-West Passage. South of Chasm is North-South Passage.

Instead of going down in Chasm:
	say "Are you out of your mind?"

Reservoir-South is a dark room. The printed name of Reservoir-South is "Reservoir South". Reservoir-South is in the Underground.
The description of Reservoir-South is "[if the low-tide is true and the gates-open is true]You are in a long room, to the north of which was formerly a lake. However, with the water level lowered, there is merely a wide stream running through the center of the room.[otherwise if the gates-open is true]You are in a long room. To the north is a large lake, too deep to cross. You notice, however, that the water level appears to be dropping at a rapid rate. Before long, it might be possible to cross to the other side from here.[otherwise if the low-tide is true]You are in a long room, to the north of which is a wide area which was formerly a reservoir, but now is merely a stream. You notice, however, that the level of the stream is rising quickly and that before long it will be impossible to cross here.[otherwise]You are in a long room on the south shore of a large lake, far too deep and wide for crossing.[end if][paragraph break]There is a path along the stream to the east or west, a steep pathway climbing southwest along the edge of a chasm, and a path leading into a canyon to the southeast.".

Southeast of Reservoir-South is Deep Canyon.
East of Reservoir-South is Dam-Room. West of Reservoir-South is Stream View.
Southwest of Reservoir-South is Chasm.

Instead of going north in Reservoir-South:
	if the low-tide is true:
		move the player to Reservoir;
	otherwise:
		say "You would drown."

Dam-Room is a dark room. The printed name of Dam-Room is "Dam".
Dam-Room is in the Underground.
The description of Dam-Room is "You are standing on the top of Flood Control Dam #3, which was quite a tourist attraction in times far distant. There are paths to the north, south, and west, and a scramble down.[paragraph break][if the low-tide is true and the gates-open is true]The water level behind the dam is low: The sluice gates have been opened. Water rushes through the dam and downstream.[otherwise if the gates-open is true]The sluice gates are open, and water rushes through the dam. The water level behind the dam is still high.[otherwise if the low-tide is true]The sluice gates are closed. The water level in the reservoir is quite low, but the level is rising quickly.[otherwise]The sluice gates on the dam are closed. Behind the dam, there can be seen a wide reservoir. Water is pouring over the top of the now abandoned dam.[end if][paragraph break]There is a control panel here, on which a large metal bolt is mounted. Directly above the bolt is a small green plastic bubble[if the gate-flag is true] which is glowing serenely[end if]."
South of Dam-Room is Deep Canyon. Down from Dam-Room is Dam-Base. East of Dam-Room is Dam-Base. North of Dam-Room is Dam-Lobby.
West of Dam-Room is Reservoir-South.

The dam is scenery in Dam-Room. Understand "dam" and "gate" and "gates" and "fcd" as the dam.
The description of the dam is "This is Flood Control Dam #3, quite an impressive engineering feat."

The bolt is scenery in Dam-Room. Understand "bolt" and "nut" and "metal" and "large" as the bolt.
The description of the bolt is "It's a large metal bolt attached to the dam structure."

The green bubble is scenery in Dam-Room. Understand "bubble" and "small" and "green" and "plastic" as the green bubble.
The description of the green bubble is "A small green plastic bubble is floating in the stream."

The control panel is scenery in Dam-Room. Understand "panel" and "control" as the control panel.
The description of the control panel is "The control panel is part of the dam infrastructure."

Dam-Lobby is a dark room. The printed name of Dam-Lobby is "Dam Lobby". "This room appears to have been the waiting room for groups touring the dam. There are open doorways here to the north and east marked 'Private', and there is a path leading south over the top of the dam."
Dam-Lobby is in the Underground.
South of Dam-Lobby is Dam-Room. North of Dam-Lobby is Maintenance Room. East of Dam-Lobby is Maintenance Room.

The tour guidebook is in Dam-Lobby. "Some guidebooks entitled 'Flood Control Dam #3' are on the reception desk."
Understand "guide" and "book" and "guidebooks" and "tour" as the tour guidebook.
The description of the tour guidebook is "[fixed letter spacing]   Flood Control Dam #3[line break][line break]FCD#3 was constructed in year 783 of the Great Underground Empire to harness the mighty Frigid River. This work was supported by a grant of 37 million zorkmids from your omnipotent local tyrant Lord Dimwit Flathead the Excessive. This impressive structure is composed of 370,000 cubic feet of concrete, is 256 feet tall at the center, and 193 feet wide at the top. The lake created behind the dam has a volume of 1.7 billion cubic feet, an area of 12 million square feet, and a shore line of 36 thousand feet.[line break][line break]The construction of FCD#3 took 112 days from ground breaking to the dedication. It required a work force of 384 slaves, 34 slave drivers, 12 engineers, 2 turtle doves, and a partridge in a pear tree. The work was managed by a command team composed of 2345 bureaucrats, 2347 secretaries (at least two of whom could type), 12,256 paper shufflers, 52,469 rubber stampers, 245,193 red tape processors, and nearly one million dead trees.[line break][line break]We will now point out some of the more interesting features of FCD#3 as we conduct you on a guided tour of the facilities:[line break][line break]      1) You start your tour here in the Dam-Lobby. You will notice on your right that....[variable letter spacing]"

The matchbook is in Dam-Lobby. "There is a matchbook whose cover says 'Visit Beautiful FCD#3' here."
Understand "match" and "matches" and "matchbook" as the matchbook.
The description of the matchbook is "The matchbook isn't very interesting, except for what's written on it."
The match-count is a number that varies. The match-count is 6.

Reading is an action applying to one thing. Understand "read [something]" as reading.

Instead of reading the matchbook:
	say "[fixed letter spacing](Close cover before striking)[line break][line break]YOU too can make BIG MONEY in the exciting field of PAPER SHUFFLING![line break][line break]Mr. Anderson of Muddle, Mass. says: 'Before I took this course I was a lowly bit twiddler. Now with what I learned at GUE Tech I feel really important and can obfuscate and confuse with the best.'[line break][line break]Dr. Blank had this to say: 'Ten short days ago all I could look forward to was a dead-end job as a doctor. Now I have a promising future and make really big Zorkmids.'[line break][line break]GUE Tech can't promise these fantastic results to everyone. But when you earn your degree from GUE Tech, your future will be brighter.[variable letter spacing]"

Maintenance Room is a dark room. "This is what appears to have been the maintenance room for Flood Control Dam #3. Apparently, this room has been ransacked recently, for most of the valuable equipment is gone. On the wall in front of you is a group of buttons colored blue, yellow, brown, and red. There are doorways to the west and south."
Maintenance Room is in the Underground.
South of Maintenance Room is Dam-Lobby. West of Maintenance Room is Dam-Lobby.

The yellow button is scenery in Maintenance Room. Understand "yellow" and "button" as the yellow button.
The brown button is scenery in Maintenance Room. Understand "brown" and "button" as the brown button.
The red button is scenery in Maintenance Room. Understand "red" and "button" as the red button.
The blue button is scenery in Maintenance Room. Understand "blue" and "button" as the blue button.

Instead of pushing the yellow button:
	now the gate-flag is true;
	say "Click."

Instead of pushing the brown button:
	now the gate-flag is false;
	say "Click."

Instead of pushing the red button:
	say "The lights within the room come on."

The water-level is a number that varies. The water-level is 0.
The maint-flooded is a truth state that varies. The maint-flooded is false.

The leak is scenery. The leak is invisible.
Understand "leak" and "pipe" and "pipes" and "stream" and "water" as the leak.
The description of the leak is "Water is pouring out of a crack in the east wall."

Instead of pushing the blue button:
	if the water-level is 0:
		now the water-level is 1;
		now the leak is visible;
		now the leak is in Maintenance Room;
		say "There is a rumbling sound and a stream of water appears to burst from the east wall of the room (apparently, a leak has occurred in a pipe).";
	otherwise:
		say "The blue button appears to be jammed."

Plugging it with is an action applying to two things. Understand "plug [something] with [something]" and "fix [something] with [something]" and "patch [something] with [something]" as plugging it with.
Carry out plugging it with: say "That doesn't work."

Instead of plugging the leak with the viscous material:
	if the water-level > 0:
		now the water-level is -1;
		say "By some miracle of Zorkian technology, you have managed to stop the leak in the dam."

Instead of putting the viscous material on the leak:
	try plugging the leak with the viscous material.

Every turn when the water-level > 0 and the maint-flooded is false (this is the maintenance flooding rule):
	increase the water-level by 1;
	if the player is in Maintenance Room:
		if the water-level is 2:
			say "The water level here is now up to your ankles.[line break]";
		otherwise if the water-level is 4:
			say "The water level here is now up to your shin.[line break]";
		otherwise if the water-level is 6:
			say "The water level here is now up to your knees.[line break]";
		otherwise if the water-level is 8:
			say "The water level here is now up to your hips.[line break]";
		otherwise if the water-level is 10:
			say "The water level here is now up to your waist.[line break]";
		otherwise if the water-level is 12:
			say "The water level here is now up to your chest.[line break]";
		otherwise if the water-level is 13:
			say "The water level here is now up to your neck.[line break]";
	if the water-level is at least 14:
		now the maint-flooded is true;
		if the player is in Maintenance Room and the player is not in the magic boat:
			die saying "I'm afraid you have done drowned yourself.";
		otherwise if the player is in Maintenance Room and the player is in the magic boat:
			die saying "The rising water carries your boat over the top of the dam and plunges you to your death."

Instead of going to Maintenance Room when the maint-flooded is true:
	say "The room is full of water and cannot be entered." instead.

The wrench is in Maintenance Room. Understand "wrench" and "tool" as the wrench.
The description of the wrench is "It's a wrench."

The screwdriver is in Maintenance Room. Understand "screwdriver" and "tool" and "driver" as the screwdriver.
The description of the screwdriver is "It's a screwdriver."

The tube is in Maintenance Room. "There is an object which looks like a tube of toothpaste here."
Understand "tube" and "tooth" and "paste" as the tube.
The tube is a closed openable container. The carrying capacity of the tube is 1.
The description of the tube is "The label reads: 'Frobozz Magic Gunk Company --- All-Purpose Gunk'."

The viscous material is in the tube. Understand "material" and "gunk" and "viscous" and "putty" as the viscous material.
The description of the viscous material is "It's a viscous, putty-like material."

The group of tool chests is scenery in Maintenance Room. Understand "chest" and "chests" and "group" and "toolchests" and "tool" as the group of tool chests.
The description of the group of tool chests is "The chests are all empty."

Chapter 11 - Reservoir Area

Reservoir is a dark room. Reservoir is in the Underground.
The description of Reservoir is "[if the low-tide is true]You are on what used to be a large lake, but which is now a large mud pile. There are [quotation mark]shores[quotation mark] to the north and south.[otherwise]You are on the lake. Beaches can be seen north and south. Upstream a small stream enters the lake through a narrow cleft in the rocks. The dam can be seen downstream.[end if]".
North of Reservoir is Reservoir-North. South of Reservoir is Reservoir-South.

Reservoir-North is a dark room. The printed name of Reservoir-North is "Reservoir North". Reservoir-North is in the Underground.
The description of Reservoir-North is "[if the low-tide is true and the gates-open is true]You are in a large cavernous room, the south of which was formerly a lake. However, with the water level lowered, there is merely a wide stream running through there.[otherwise if the gates-open is true]You are in a large cavernous area. To the south is a wide lake, whose water level appears to be falling rapidly.[otherwise if the low-tide is true]You are in a cavernous area, to the south of which is a very wide stream. The level of the stream is rising rapidly, and it appears that before long it will be impossible to cross to the other side.[otherwise]You are in a large cavernous room, north of a large lake.[end if][paragraph break]There is a slimy stairway leaving the room to the north.".
North of Reservoir-North is Atlantis Room.

Instead of going south in Reservoir-North:
	if the low-tide is true:
		move the player to Reservoir;
	otherwise:
		say "You would drown."

Stream View is a dark room. "You are standing on a path beside a gently flowing stream. The path follows the stream, which flows from west to east."
Stream View is in the Underground.
East of Stream View is Reservoir-South.

Instead of going west in Stream View:
	say "The stream emerges from a spot too small for you to enter."

The hand-held air pump is in Reservoir-North. "There is a small pump here."
Understand "pump" and "air-pump" and "tool" and "small" and "hand-held" as the hand-held air pump.
The description of the hand-held air pump is "It's a small hand-held air pump."

Chapter 12 - Dam-Base and River

Dam-Base is a room. The printed name of Dam-Base is "Dam Base". "You are at the base of Flood Control Dam #3, which looms above you and to the north. The river Frigid is flowing by here. Along the river are the White Cliffs which seem to form giant walls stretching from north to south along the shores of the river as it winds its way downstream."
Dam-Base is in the Underground.
North of Dam-Base is Dam-Room. Up from Dam-Base is Dam-Room.

The pile of plastic is in Dam-Base. "There is a folded pile of plastic here which has a small valve attached."
Understand "boat" and "pile" and "plastic" and "valve" and "inflatable" as the pile of plastic.
The description of the pile of plastic is "It's a pile of folded plastic with a small valve attached."

Chapter 13 - Mirror Rooms and Connecting Passages

Mirror Room 1 is a dark room. The printed name of Mirror Room 1 is "Mirror Room".
Mirror Room 1 is in the Underground.
The description of Mirror Room 1 is "You are in a large square room with tall ceilings. On the south wall is an enormous mirror which fills the entire wall.[if the mirror-broken is true] Unfortunately, the mirror has been destroyed by your recklessness.[end if] There are exits to the east, west, and north."
North of Mirror Room 1 is Cold Passage. West of Mirror Room 1 is Twisting Passage. East of Mirror Room 1 is Small Cave.

The mirror-one is scenery in Mirror Room 1. The printed name of the mirror-one is "mirror". Understand "mirror" and "reflection" and "enormous" as the mirror-one.
The description of the mirror-one is "[if the mirror-broken is true]The mirror is broken into many pieces.[otherwise]There is an ugly person staring back at you.[end if]".

Mirror Room 2 is a dark room. The printed name of Mirror Room 2 is "Mirror Room".
Mirror Room 2 is in the Underground.
The description of Mirror Room 2 is "You are in a large square room with tall ceilings. On the south wall is an enormous mirror which fills the entire wall.[if the mirror-broken is true] Unfortunately, the mirror has been destroyed by your recklessness.[end if] There are exits to the east, west, and north."
West of Mirror Room 2 is Winding-Passage. North of Mirror Room 2 is Narrow Passage. East of Mirror Room 2 is Tiny Cave.

The mirror-two is scenery in Mirror Room 2. The printed name of the mirror-two is "mirror". Understand "mirror" and "reflection" and "enormous" as the mirror-two.
The description of the mirror-two is "[if the mirror-broken is true]The mirror is broken into many pieces.[otherwise]There is an ugly person staring back at you.[end if]".

Rubbing-mirror is an action applying to one thing. Understand "rub [something]" as rubbing-mirror when the noun is the mirror-one or the noun is the mirror-two.

Instead of rubbing-mirror the mirror-one:
	say "There is a rumble from deep within the earth and the room shakes.";
	move the player to Mirror Room 2.

Instead of rubbing-mirror the mirror-two:
	say "There is a rumble from deep within the earth and the room shakes.";
	move the player to Mirror Room 1.

The mirror-broken is a truth state that varies. The mirror-broken is false.

Instead of attacking the mirror-one:
	if the mirror-broken is true:
		say "Haven't you done enough damage already?";
	otherwise:
		say "You have broken the mirror. I hope you have a seven years[apostrophe] supply of good luck handy.";
		now the lucky-flag is false;
		now the mirror-broken is true.

Instead of attacking the mirror-two:
	if the mirror-broken is true:
		say "Haven't you done enough damage already?";
	otherwise:
		say "You have broken the mirror. I hope you have a seven years[apostrophe] supply of good luck handy.";
		now the lucky-flag is false;
		now the mirror-broken is true.

Instead of taking the mirror-one:
	say "The mirror is many times your size. Give up."

Instead of taking the mirror-two:
	say "The mirror is many times your size. Give up."

Small Cave is a dark room. The printed name of Small Cave is "Cave". "This is a tiny cave with entrances west and north, and a staircase leading down."
Small Cave is in the Underground.
North of Small Cave is Mirror Room 1. Down from Small Cave is Atlantis Room. South of Small Cave is Atlantis Room. West of Small Cave is Twisting Passage.

Tiny Cave is a dark room. The printed name of Tiny Cave is "Cave". "This is a tiny cave with entrances west and north, and a dark, forbidding staircase leading down."
Tiny Cave is in the Underground.
North of Tiny Cave is Mirror Room 2. West of Tiny Cave is Winding-Passage. Down from Tiny Cave is Entrance to Hades.

Every turn when the player is in Tiny Cave and the pair of candles is lit (this is the drafty cave candle rule):
	if a random chance of 50 in 100 succeeds:
		now the pair of candles is not lit;
		say "A gust of wind blows out your candles![line break]";
		if in darkness:
			say "It is now completely dark.[line break]".

Cold Passage is a dark room. "This is a cold and damp corridor where a long east-west passageway turns into a southward path."
Cold Passage is in the Underground.
South of Cold Passage is Mirror Room 1. West of Cold Passage is Slide Room.

Narrow Passage is a dark room. "This is a long and narrow corridor where a long north-south passageway briefly narrows even further."
Narrow Passage is in the Underground.
North of Narrow Passage is Round Room. South of Narrow Passage is Mirror Room 2.

Winding-Passage is a dark room. "This is a winding passage. It seems that there are only exits on the east and north."
The printed name of Winding-Passage is "Winding Passage".
Winding-Passage is in the Underground.
North of Winding-Passage is Mirror Room 2. East of Winding-Passage is Tiny Cave.

Twisting Passage is a dark room. "This is a winding passage. It seems that there are only exits on the east and north."
Twisting Passage is in the Underground.
North of Twisting Passage is Mirror Room 1. East of Twisting Passage is Small Cave.

Atlantis Room is a dark room. "This is an ancient room, long under water. There is an exit to the south and a staircase leading up."
Atlantis Room is in the Underground.
Up from Atlantis Room is Small Cave. South of Atlantis Room is Reservoir-North.

The crystal trident is in Atlantis Room. "On the shore lies Poseidon's own crystal trident."
Understand "trident" and "fork" and "crystal" and "poseidon" as the crystal trident.
The treasure-value of the crystal trident is 4.
The point-value of the crystal trident is 11.

Chapter 14 - Temple, Dome, Egypt, and Hades

Engravings Cave is a dark room. "You have entered a low cave with passages leading northwest and east."
Engravings Cave is in the Underground.
Northwest of Engravings Cave is Round Room. East of Engravings Cave is Dome Room.

The engraved wall is in Engravings Cave. "There are old engravings on the walls here."
Understand "wall" and "engravings" and "inscription" and "old" and "ancient" as the engraved wall.
The description of the engraved wall is "The engravings were incised in the living rock of the cave wall by an unknown hand. They depict, in symbolic form, the beliefs of the ancient Zorkers. Skillfully interwoven with the bas reliefs are excerpts illustrating the major religious tenets of that time. Unfortunately, a later age seems to have considered them blasphemous and just as skillfully excised them."

Dome Room is a dark room. Dome Room is in the Underground.
The description of Dome Room is "You are at the periphery of a large dome, which forms the ceiling of another room below. Protecting you from a precipitous drop is a wooden railing which circles the dome.[if the dome-flag is true] Hanging down from the railing is a rope which ends about ten feet from the floor below.[end if]".
West of Dome Room is Engravings Cave.

The wooden railing is scenery in Dome Room. Understand "railing" and "rail" and "wooden" as the wooden railing.
The description of the wooden railing is "It's a sturdy wooden railing, suitable for tying things to."

Instead of going down in Dome Room:
	if the dome-flag is true:
		move the player to Torch-Room;
	otherwise:
		say "You cannot go down without fracturing many bones."

Instead of tying the rope to the wooden railing:
	if the dome-flag is true:
		say "The rope is already tied to it.";
	otherwise:
		now the dome-flag is true;
		say "The rope drops over the side and comes within ten feet of the floor."

Understand "tie [something] to [something]" as tying it to.
Carry out tying it to:
	say "You can't tie those things together."

Torch-Room is a dark room. The printed name of Torch-Room is "Torch Room". Torch-Room is in the Underground.
The description of Torch-Room is "This is a large room with a prominent doorway leading to a down staircase. Above you is a large dome. Up around the edge of the dome (20 feet up) is a wooden railing. In the center of the room sits a white marble pedestal.[if the dome-flag is true] A piece of rope descends from the railing above, ending some five feet above your head.[end if]".
South of Torch-Room is North Temple. Down from Torch-Room is North Temple.

Instead of going up in Torch-Room:
	say "You cannot reach the rope."

The pedestal is a supporter in Torch-Room. The pedestal is scenery.
Understand "pedestal" and "white" and "marble" as the pedestal.
The description of the pedestal is "It's a white marble pedestal."

The torch is a thing on the pedestal. The initial appearance of the torch is "Sitting on the pedestal is a flaming torch, made of ivory."
Understand "torch" and "ivory" and "flaming" as the torch.
The torch is lit. The description of the torch is "It's a flaming ivory torch."
The treasure-value of the torch is 14.
The point-value of the torch is 6.

North Temple is a dark room. The printed name of North Temple is "Temple". "This is the north end of a large temple. On the east wall is an ancient inscription, probably a prayer in a long-forgotten language. Below the prayer is a staircase leading down. The west wall is solid granite. The exit to the north end of the room is through huge marble pillars."
North Temple is in the Underground.
Down from North Temple is Egypt Room. East of North Temple is Egypt Room. North of North Temple is Torch-Room.
Up from North Temple is Torch-Room.
South of North Temple is South Temple.

The brass bell is in North Temple.
Understand "bell" and "small" and "brass" as the brass bell.
The description of the brass bell is "It's a small brass bell."

The prayer is scenery in North Temple. Understand "prayer" and "inscription" and "ancient" and "old" as the prayer.
The description of the prayer is "The prayer is inscribed in an ancient script, rarely used today. It seems to be a philippic against small insects, absent-mindedness, and the picking up and dropping of small objects. The final verse consigns trespassers to the land of the dead. All evidence indicates that the beliefs of the ancient Zorkers were obscure."

South Temple is a dark room. The printed name of South Temple is "Altar". "This is the south end of a large temple. In front of you is what appears to be an altar. In one corner is a small hole in the floor which leads into darkness. You probably could not get back up it."
South Temple is in the Underground.
North of South Temple is North Temple.

Instead of going down in South Temple:
	if the coffin-cure is true:
		move the player to Tiny Cave;
	otherwise:
		say "You haven't a prayer of getting the coffin down there."

The altar is a supporter in South Temple. The altar is scenery.
Understand "altar" as the altar.
The description of the altar is "It's a massive stone altar."

The black book is on the altar. "On the altar is a large black book, open to page 569."
Understand "book" and "prayer" and "page" and "large" and "black" as the black book.
The description of the black book is "Commandment #12592[paragraph break]Oh ye who go about saying unto each: 'Hello sailor':[line break]Dost thou know the magnitude of thy sin before the gods?[line break]Yea, verily, thou shalt be ground between two stones.[line break]Shall the angry gods cast thy body into the whirlpool?[line break]Surely, thy eye shall be put out with a sharp stick![line break]Even unto the ends of the earth shalt thou wander and[line break]Unto the land of the dead shalt thou be sent at last.[line break]Surely thou shalt repent of thy cunning."

The pair of candles is on the altar. "On the two ends of the altar are burning candles."
Understand "candles" and "pair" and "burning" as the pair of candles.
The pair of candles is lit.
The description of the pair of candles is "[if the candles-burned-out is true]Alas, there's not much left of the candles. Certainly not enough to burn.[otherwise if the pair of candles is lit]The candles are burning.[otherwise]The candles are out.[end if]".

Egypt Room is a dark room. The printed name of Egypt Room is "Egyptian Room". "This is a room which looks like an Egyptian tomb. There is an ascending staircase to the west."
Egypt Room is in the Underground.
West of Egypt Room is North Temple. Up from Egypt Room is North Temple.

The gold coffin is in Egypt Room. "The solid-gold coffin used for the burial of Ramses II is here."
Understand "coffin" and "casket" and "solid" and "gold" as the gold coffin.
The gold coffin is a closed openable container.
The treasure-value of the gold coffin is 10.
The point-value of the gold coffin is 15.
The carrying capacity of the gold coffin is 5.

The sceptre is in the gold coffin. "A sceptre, possibly that of ancient Egypt itself, is in the coffin. The sceptre is ornamented with colored enamel, and tapers to a sharp point."
Understand "sceptre" and "scepter" and "sharp" and "egyptian" and "ancient" and "enameled" as the sceptre.
The sceptre is a weapon.
The treasure-value of the sceptre is 4.
The point-value of the sceptre is 6.

Entrance to Hades is a dark room. Entrance to Hades is in the Underground.
Up from Entrance to Hades is Tiny Cave.
The description of Entrance to Hades is "You are outside a large gateway, on which is inscribed[paragraph break]    [italic type]Abandon every hope all ye who enter here![roman type][paragraph break]The gate is open; through it you can see a desolation, with a pile of mangled bodies in one corner. Thousands of voices, lamenting some hideous fate, can be heard.[if the lld-flag is false and the player-is-dead is false][paragraph break]The way through the gate is barred by evil spirits, who jeer at your attempts to pass.[end if]".

Instead of going south in Entrance to Hades:
	if the lld-flag is true:
		move the player to Land of the Dead;
	otherwise:
		say "Some invisible force prevents you from passing through the gate."

Instead of going inside in Entrance to Hades:
	if the lld-flag is true:
		move the player to Land of the Dead;
	otherwise:
		say "Some invisible force prevents you from passing through the gate."

The ghosts is scenery in Entrance to Hades. The printed name of the ghosts is "ghosts".
Understand "ghosts" and "spirits" and "fiends" and "force" and "invisible" and "evil" as the ghosts.
The description of the ghosts is "You see a number of ghostly spirits swirling around."

Land of the Dead is a dark room. The printed name of Land of the Dead is "Land of the Dead". "You have entered the Land of the Living Dead. Thousands of lost souls can be heard weeping and moaning. In the corner are stacked the remains of dozens of previous adventurers less fortunate than yourself. A passage exits to the north."
Land of the Dead is in the Underground.
North of Land of the Dead is Entrance to Hades.

The crystal skull is in Land of the Dead. "Lying in one corner of the room is a beautifully carved crystal skull. It appears to be grinning at you rather nastily."
Understand "skull" and "head" and "crystal" as the crystal skull.
The treasure-value of the crystal skull is 10.
The point-value of the crystal skull is 10.

Chapter 15 - Exorcism Ceremony

The xb-flag is a truth state that varies. The xb-flag is false.
The xc-flag is a truth state that varies. The xc-flag is false.
The xb-timer is a number that varies. The xb-timer is 0.
The hot-bell-timer is a number that varies. The hot-bell-timer is 0.

Ringing is an action applying to one thing. Understand "ring [something]" as ringing.
Carry out ringing: say "You can't ring that."

The red hot brass bell is a thing. "On the ground is a red hot bell."
Understand "bell" and "hot" and "red" and "brass" as the red hot brass bell.
The description of the red hot brass bell is "It's a red hot brass bell."

Instead of taking the red hot brass bell:
	say "The bell is very hot and cannot be taken."

Instead of ringing the brass bell:
	if the player is in Entrance to Hades and the lld-flag is false:
		now the xb-flag is true;
		now the xb-timer is 6;
		now the hot-bell-timer is 20;
		remove the brass bell from play;
		now the red hot brass bell is in Entrance to Hades;
		say "The bell suddenly becomes red hot and falls to the ground. The wraiths, as if paralyzed, stop their jeering and slowly turn to face you. On their ashen faces, the expression of a long-forgotten terror takes shape.";
		if the player carries the pair of candles:
			say "[line break]In your confusion, the candles drop to the ground (and they are out).";
			now the pair of candles is in Entrance to Hades;
			now the pair of candles is not lit;
	otherwise:
		say "Ding, dong."

Lighting-candles is an action applying to one thing.
Understand "light [something]" as lighting-candles when the noun is the pair of candles.

Instead of lighting-candles the pair of candles:
	if the candles-burned-out is true:
		say "Alas, there's not much left of the candles. Certainly not enough to burn.";
	otherwise if the pair of candles is lit:
		say "The candles are already lit.";
	otherwise if the match-lit is true:
		say "The candles are lit.";
		now the pair of candles is lit;
	otherwise if the player can see the torch:
		say "The heat from the torch is so intense that the candles are vaporized.";
		remove the pair of candles from play;
	otherwise:
		say "You should say what to light them with."

Instead of switching off the pair of candles:
	if the pair of candles is lit:
		now the pair of candles is not lit;
		say "The flame is extinguished.";
		if in darkness:
			say " It's really dark in here....";
	otherwise:
		say "The candles are not lighted."

Every turn when the xb-flag is true and the player is in Entrance to Hades and the xc-flag is false (this is the candle flame power rule):
	if the player carries the pair of candles and the pair of candles is lit:
		now the xc-flag is true;
		say "The flames flicker wildly and appear to dance. The earth beneath your feet trembles, and your legs nearly buckle beneath you. The spirits cower at your unearthly power.[line break]";
		now the xb-timer is 0.

Every turn when the xb-timer > 0 (this is the xb timer rule):
	decrease the xb-timer by 1;
	if the xb-timer is 0 and the xc-flag is false:
		if the player is in Entrance to Hades:
			say "The tension of this ceremony is broken, and the wraiths, amused but shaken at your clumsy attempt, resume their hideous jeering.[line break]";
		now the xb-flag is false.

Every turn when the hot-bell-timer > 0 (this is the hot bell cooling rule):
	decrease the hot-bell-timer by 1;
	if the hot-bell-timer is 0:
		remove the red hot brass bell from play;
		now the brass bell is in Entrance to Hades;
		if the player is in Entrance to Hades:
			say "The bell appears to have cooled down.[line break]".

Instead of reading the black book:
	if the xc-flag is true and the player is in Entrance to Hades and the lld-flag is false:
		now the lld-flag is true;
		remove the ghosts from play;
		say "Each word of the prayer reverberates through the hall in a deafening confusion. As the last word fades, a voice, loud and commanding, speaks: [quotation mark]Begone, fiends![quotation mark] A heart-stopping scream fills the cavern, and the spirits, sensing a greater power, flee through the walls.";
	otherwise:
		say "[description of the black book]".

Chapter 16 - River and Falls Area

River1 is a room. The printed name of River1 is "Frigid River". "You are on the Frigid River in the vicinity of the Dam. The river flows quietly here. There is a landing on the west shore."
River1 is in the Underground.
West of River1 is Dam-Base. Down from River1 is River2.

Instead of going up in River1:
	say "You cannot go upstream due to strong currents."

Instead of going east in River1:
	say "The White Cliffs prevent your landing here."

River2 is a room. The printed name of River2 is "Frigid River". "The river turns a corner here making it impossible to see the Dam. The White Cliffs loom on the east bank and large rocks prevent landing on the west."
River2 is in the Underground.
Down from River2 is River3.

Instead of going up in River2:
	say "You cannot go upstream due to strong currents."

Instead of going east in River2:
	say "The White Cliffs prevent your landing here."

Instead of going west in River2:
	say "Just in time you steer away from the rocks."

River3 is a room. The printed name of River3 is "Frigid River". "The river descends here into a valley. There is a narrow beach on the west shore below the cliffs. In the distance a faint rumbling can be heard."
River3 is in the Underground.
Down from River3 is River4. West of River3 is White Cliffs North.

Instead of going up in River3:
	say "You cannot go upstream due to strong currents."

White Cliffs North is a room. The printed name of White Cliffs North is "White Cliffs Beach". "You are on a narrow strip of beach which runs along the base of the White Cliffs. There is a narrow path heading south along the Cliffs and a tight passage leading west into the cliffs themselves."
White Cliffs North is in the Underground.

East of Damp Cave is White Cliffs North.

Instead of going south in White Cliffs North:
	if the player carries the pile of plastic or the player does not carry the magic boat:
		move the player to White Cliffs South instead;
	say "The path is too narrow with an inflated boat."

Instead of going west in White Cliffs North:
	if the player carries the pile of plastic or the player does not carry the magic boat:
		move the player to Damp Cave instead;
	say "The path is too narrow with an inflated boat."

White Cliffs South is a room. The printed name of White Cliffs South is "White Cliffs Beach". "You are on a rocky, narrow strip of beach beside the Cliffs. A narrow path leads north along the shore."
White Cliffs South is in the Underground.

Instead of going north in White Cliffs South:
	if the player carries the pile of plastic or the player does not carry the magic boat:
		move the player to White Cliffs North instead;
	say "The path is too narrow with an inflated boat."

River4 is a room. The printed name of River4 is "Frigid River". "The river is running faster here and the sound ahead appears to be that of rushing water. On the east shore is a sandy beach. A small area of beach can also be seen below the cliffs on the west shore."
River4 is in the Underground.
Down from River4 is River5. West of River4 is White Cliffs South. East of River4 is Sandy Beach.

Instead of going up in River4:
	say "You cannot go upstream due to strong currents."

River5 is a room. The printed name of River5 is "Frigid River". "The sound of rushing water is nearly unbearable here. On the east shore is a large landing area."
River5 is in the Underground.
East of River5 is Shore.

Instead of going up in River5:
	say "You cannot go upstream due to strong currents."

Instead of going down in River5:
	die saying "Unfortunately, the magic boat doesn't provide protection from the rocks and boulders one meets at the bottom of waterfalls. Including this one."

Section - River Current System

The river-current-timer is a number that varies. The river-current-timer is 0.
The river-current-active is a truth state that varies. The river-current-active is false.

Every turn when the river-current-active is true (this is the river current rule):
	decrease the river-current-timer by 1;
	if the river-current-timer is at most 0:
		if the player is in River1:
			say "The flow of the river carries you downstream.[line break]";
			move the player to River2;
			now the river-current-timer is 4;
		otherwise if the player is in River2:
			say "The flow of the river carries you downstream.[line break]";
			move the player to River3;
			now the river-current-timer is 3;
		otherwise if the player is in River3:
			say "The flow of the river carries you downstream.[line break]";
			move the player to River4;
			now the river-current-timer is 2;
		otherwise if the player is in River4:
			say "The flow of the river carries you downstream.[line break]";
			move the player to River5;
			now the river-current-timer is 1;
		otherwise if the player is in River5:
			die saying "Unfortunately, the magic boat doesn't provide protection from the rocks and boulders one meets at the bottom of waterfalls. Including this one.";
		otherwise:
			now the river-current-active is false.

After going to River1:
	now the river-current-active is true;
	now the river-current-timer is 4;
	continue the action.

After going to River2:
	now the river-current-active is true;
	now the river-current-timer is 4;
	continue the action.

After going to River3:
	now the river-current-active is true;
	now the river-current-timer is 3;
	continue the action.

After going to River4:
	now the river-current-active is true;
	now the river-current-timer is 2;
	continue the action.

After going to River5:
	now the river-current-active is true;
	now the river-current-timer is 1;
	continue the action.

After going to Shore:
	now the river-current-active is false;
	continue the action.

After going to Sandy Beach:
	now the river-current-active is false;
	continue the action.

After going to White Cliffs North:
	now the river-current-active is false;
	continue the action.

After going to White Cliffs South:
	now the river-current-active is false;
	continue the action.

After going to Dam-Base:
	now the river-current-active is false;
	continue the action.

Shore is a room. "You are on the east shore of the river. The water here seems somewhat treacherous. A path travels from north to south here, the south end quickly turning around a sharp corner."
Shore is in the Underground.
North of Shore is Sandy Beach. South of Shore is Aragain Falls.

Sandy Beach is a room. "You are on a large sandy beach on the east shore of the river, which is flowing quickly by. A path runs beside the river to the south here, and a passage is partially buried in sand to the northeast."
Sandy Beach is in the Underground.
Northeast of Sandy Beach is Sandy Cave. South of Sandy Beach is Shore.

The shovel is in Sandy Beach. Understand "shovel" and "tool" as the shovel.
The description of the shovel is "It's a sturdy shovel."

Sandy Cave is a room. "This is a sand-filled cave whose exit is to the southwest."
Sandy Cave is in the Underground.
Southwest of Sandy Cave is Sandy Beach.

The sand is scenery in Sandy Cave. Understand "sand" as the sand.
The description of the sand is "It's just sand."

The beautiful jeweled scarab is in Sandy Cave. The beautiful jeweled scarab is invisible.
Understand "scarab" and "bug" and "beetle" and "beautiful" and "carved" and "jeweled" as the beautiful jeweled scarab.
The treasure-value of the beautiful jeweled scarab is 5.
The point-value of the beautiful jeweled scarab is 5.

The dig-count is a number that varies. The dig-count is 0.

Digging is an action applying to one thing. Understand "dig [something]" and "dig in [something]" as digging.
Carry out digging:
	say "The ground is too hard for digging here."

Instead of digging the sand:
	if the player does not carry the shovel:
		say "You need a shovel to dig here.";
	otherwise:
		increase the dig-count by 1;
		if the dig-count < 4:
			say "You dig for a while but find nothing.";
		otherwise:
			now the beautiful jeweled scarab is visible;
			say "You uncover a beautiful jeweled scarab!";
			now the beautiful jeweled scarab is in Sandy Cave.

Aragain Falls is a room. "You are at the top of Aragain Falls, an enormous waterfall with a drop of about 450 feet. The only path here is on the north end."
Aragain Falls is in the Underground.

Instead of going west in Aragain Falls:
	if the rainbow-flag is true:
		move the player to On-the-Rainbow;
	otherwise:
		say "You can't go that way."

Instead of going down in Aragain Falls:
	say "It's a long way..."

On-the-Rainbow is a room. "You are on top of a rainbow (I bet you never thought you would walk on a rainbow), with a magnificent view of the Falls. The rainbow travels east-west here."
The printed name of On-the-Rainbow is "On the Rainbow".
On-the-Rainbow is in the Underground.
West of On-the-Rainbow is End of Rainbow. East of On-the-Rainbow is Aragain Falls.

End of Rainbow is a room. "You are on a small, rocky beach on the continuation of the Frigid River past the Falls. The beach is narrow due to the presence of the White Cliffs. The river canyon opens here and sunlight shines in from above. A rainbow crosses over the falls to the east and a narrow path continues to the southwest."
End of Rainbow is in the Underground.
Southwest of End of Rainbow is Canyon Bottom.

Instead of going east in End of Rainbow:
	if the rainbow-flag is true:
		move the player to On-the-Rainbow;
	otherwise:
		say "You can't go that way."

The pot of gold is in End of Rainbow. The pot of gold is invisible. "At the end of the rainbow is a pot of gold."
Understand "pot" and "gold" as the pot of gold.
The treasure-value of the pot of gold is 10.
The point-value of the pot of gold is 10.

Canyon Bottom is a room. "You are beneath the walls of the river canyon which may be climbable here. The lesser part of the runoff of Aragain Falls flows by below. To the north is a narrow path."
Canyon Bottom is in the Underground.
Up from Canyon Bottom is Rocky Ledge. North of Canyon Bottom is End of Rainbow.

Rocky Ledge is a room. The printed name of Rocky Ledge is "Rocky Ledge". "You are on a ledge about halfway up the wall of the river canyon. You can see from here that the main flow from Aragain Falls twists along a passage which it is impossible for you to enter. Below you is the canyon bottom. Above you is more cliff, which appears climbable."
Rocky Ledge is in the Underground.
Up from Rocky Ledge is Canyon View. Down from Rocky Ledge is Canyon Bottom.

Canyon View is a room. "You are at the top of the Great Canyon on its west wall. From here there is a marvelous view of the canyon and parts of the Frigid River upstream. Across the canyon, the walls of the White Cliffs join the mighty ramparts of the Flathead Mountains to the east. Following the Canyon upstream to the north, Aragain Falls may be seen, complete with rainbow. The mighty Frigid River flows out from a great dark cavern. To the west and south can be seen an immense forest, stretching for miles around. A path leads northwest. It is possible to climb down into the canyon from here."
Canyon View is in the Underground.
East of Canyon View is Rocky Ledge. Down from Canyon View is Rocky Ledge.
Northwest of Canyon View is Clearing. West of Canyon View is Forest3.
East of Clearing is Canyon View.

Instead of going south in Canyon View:
	say "Storm-tossed trees block your way."

Chapter 17 - Sceptre and Rainbow

Carry out waving: say "You wave [the noun] around. Nothing happens."

Instead of waving the sceptre:
	if the player is in On-the-Rainbow or the player is in Aragain Falls or the player is in End of Rainbow:
		if the rainbow-flag is false:
			now the rainbow-flag is true;
			now the pot of gold is visible;
			say "Suddenly, the rainbow appears to become solid and, I venture, walkable (I think the giveaway was the stairs and bannister).[paragraph break]A shimmering pot of gold appears at the end of the rainbow.";
		otherwise:
			now the rainbow-flag is false;
			now the pot of gold is invisible;
			say "The rainbow seems to have become somewhat run-of-the-mill.";
			if the player is in On-the-Rainbow:
				die saying "The structural integrity of the rainbow is severely compromised, leaving you hanging in midair, supported only by water vapor. Bye.";
	otherwise:
		say "A dazzling display of color briefly emanates from the sceptre."

Chapter 18 - Coal Mine Area

Mine Entrance is a dark room. "You are standing at the entrance of what might have been a coal mine. The shaft enters the west wall, and there is another exit on the south end of the room."
Mine Entrance is in the Underground.
South of Mine Entrance is Slide Room.

Squeaky Room is a dark room. "You are in a small room. Strange squeaky sounds may be heard coming from the passage at the north end. You may also escape to the east."
Squeaky Room is in the Underground.
West of Mine Entrance is Squeaky Room. East of Squeaky Room is Mine Entrance. North of Squeaky Room is Bat-Room.

Bat-Room is a dark room. Bat-Room is in the Underground.
The printed name of Bat-Room is "Bat Room".
South of Bat-Room is Squeaky Room. East of Bat-Room is Shaft Room.

The bat is a person in Bat-Room. The bat is scenery.
Understand "bat" and "vampire" and "deranged" as the bat.
The description of the bat is "[if the player encloses the clove of garlic]You can see a deranged vampire bat cowering in the corner, repelled by the garlic.[otherwise]A deranged vampire bat is swooping overhead.[end if]".

Instead of going north in Bat-Room:
	if the player carries the clove of garlic or the clove of garlic is in Bat-Room:
		continue the action;
	otherwise:
		say "    Fweep![line break]    Fweep![line break]    Fweep![line break][line break]The bat grabs you by the scruff of your neck and lifts you away....[paragraph break]";
		let R be a random number between 1 and 8;
		if R is 1:
			move the player to Mine1;
		otherwise if R is 2:
			move the player to Mine2;
		otherwise if R is 3:
			move the player to Mine3;
		otherwise if R is 4:
			move the player to Mine4;
		otherwise if R is 5:
			move the player to Ladder Top;
		otherwise if R is 6:
			move the player to Ladder Bottom;
		otherwise if R is 7:
			move the player to Squeaky Room;
		otherwise:
			move the player to Mine Entrance.

The description of Bat-Room is "You are in a small room which has doors only to the south and east. [if the clove of garlic is enclosed by the player]In the corner of the room on the ceiling is a deranged vampire bat who is obviously deranged by the strong smell of garlic.[otherwise]A deranged vampire bat, hanging from the ceiling, swoops down at you![end if]".

The jade figurine is in Bat-Room. "There is an exquisite jade figurine here."
Understand "figurine" and "jade" and "exquisite" as the jade figurine.
The treasure-value of the jade figurine is 5.
The point-value of the jade figurine is 5.

Shaft Room is a dark room. "This is a large room, in the middle of which is a small shaft descending through the floor into darkness below. To the west and the north are exits from this room. Constructed over the top of the shaft is a metal framework to which a heavy iron chain is attached."
Shaft Room is in the Underground.
West of Shaft Room is Bat-Room. North of Shaft Room is Smelly Room.

Instead of going down in Shaft Room:
	say "You wouldn't fit and would die if you could."

Smelly Room is a dark room. "This is a small nondescript room. However, from the direction of a small descending staircase a foul odor can be detected. To the south is a narrow tunnel."
Smelly Room is in the Underground.
Down from Smelly Room is Gas Room. South of Smelly Room is Shaft Room.

Gas Room is a dark room. "This is a small room which smells strongly of coal gas. There is a short climb up some stairs and a narrow tunnel leading east."
Gas Room is in the Underground.
Up from Gas Room is Smelly Room. East of Gas Room is Mine1.

Every turn when the player is in Gas Room (this is the gas room explosion rule):
	if the brass lantern is lit and the player carries the brass lantern:
		die saying "Oh dear. It appears that the smell coming from this room was coal gas. I would have thought twice about carrying a lit lamp in here.[paragraph break]   BOOOOOOOOOOOM";
	if the torch is lit and the player carries the torch:
		die saying "Oh dear. It appears that the smell coming from this room was coal gas. I would have thought twice about carrying a lit torch in here.[paragraph break]   BOOOOOOOOOOOM";
	if the pair of candles is lit and the player carries the pair of candles:
		die saying "Oh dear. It appears that the smell coming from this room was coal gas. I would have thought twice about carrying lit candles in here.[paragraph break]   BOOOOOOOOOOOM";
	if the match-lit is true:
		die saying "Oh dear. It appears that the smell coming from this room was coal gas. I would have thought twice about lighting a match in here.[paragraph break]   BOOOOOOOOOOOM".

The sapphire-encrusted bracelet is in Gas Room.
Understand "bracelet" and "jewel" and "sapphire" as the sapphire-encrusted bracelet.
The treasure-value of the sapphire-encrusted bracelet is 5.
The point-value of the sapphire-encrusted bracelet is 5.

Mine1 is a dark room. The printed name of Mine1 is "Coal Mine". "This is a nondescript part of a coal mine."
Mine1 is in the Underground.
North of Mine1 is Gas Room. East of Mine1 is Mine1. Northeast of Mine1 is Mine2.

Mine2 is a dark room. The printed name of Mine2 is "Coal Mine". "This is a nondescript part of a coal mine."
Mine2 is in the Underground.
North of Mine2 is Mine2. South of Mine2 is Mine1. Southeast of Mine2 is Mine3.

Mine3 is a dark room. The printed name of Mine3 is "Coal Mine". "This is a nondescript part of a coal mine."
Mine3 is in the Underground.
South of Mine3 is Mine3. Southwest of Mine3 is Mine4. East of Mine3 is Mine2.

Mine4 is a dark room. The printed name of Mine4 is "Coal Mine". "This is a nondescript part of a coal mine."
Mine4 is in the Underground.
North of Mine4 is Mine3. West of Mine4 is Mine4. Down from Mine4 is Ladder Top.

Ladder Top is a dark room. "This is a very small room. In the corner is a rickety wooden ladder, leading downward. It might be safe to descend. There is also a staircase leading upward."
Ladder Top is in the Underground.
Down from Ladder Top is Ladder Bottom. Up from Ladder Top is Mine4.

Ladder Bottom is a dark room. "This is a rather wide room. On one side is the bottom of a narrow wooden ladder. To the west and the south are passages leaving the room."
Ladder Bottom is in the Underground.
South of Ladder Bottom is Dead End 5. West of Ladder Bottom is Timber Room. Up from Ladder Bottom is Ladder Top.

Dead End 5 is a dark room. The printed name of Dead End 5 is "Dead End". "You have come to a dead end in the mine."
Dead End 5 is in the Underground.
North of Dead End 5 is Ladder Bottom.

The small pile of coal is in Dead End 5.
Understand "coal" and "pile" and "heap" and "small" as the small pile of coal.
The description of the small pile of coal is "It's a small pile of coal."

Timber Room is a dark room. "This is a long and narrow passage, which is cluttered with broken timbers. A wide passage comes from the east and turns at the west end of the room into a very narrow passageway. From the west comes a strong draft."
Timber Room is in the Underground.
East of Timber Room is Ladder Bottom.

Instead of going west in Timber Room:
	let total-carried be 0;
	repeat with item running through things carried by the player:
		increase total-carried by 1;
	if total-carried > 0:
		say "You cannot fit through this passage with that load.";
	otherwise:
		move the player to Drafty Room.

Drafty Room is a dark room. The printed name of Drafty Room is "Drafty Room". "This is a small drafty room in which is the bottom of a long shaft. To the south is a passageway and to the east a very narrow passage. In the shaft can be seen a heavy iron chain."
Drafty Room is in the Underground.
South of Drafty Room is Machine-Room.

Instead of going east in Drafty Room:
	let total-carried be 0;
	repeat with item running through things carried by the player:
		increase total-carried by 1;
	if total-carried > 0:
		say "You cannot fit through this passage with that load.";
	otherwise:
		move the player to Timber Room.

The lowered-basket is in Drafty Room. The printed name of the lowered-basket is "basket". "From the chain is suspended a basket."
Understand "cage" and "dumbwaiter" and "basket" as the lowered-basket.

The raised-basket is an open container in Shaft Room. The printed name of the raised-basket is "basket". "At the end of the chain is a basket."
Understand "cage" and "dumbwaiter" and "basket" as the raised-basket.
The carrying capacity of the raised-basket is 10.

The basket-is-at-top is a truth state that varies. The basket-is-at-top is true.

Raising-basket is an action applying to one thing. Understand "raise [something]" as raising-basket when the noun is the raised-basket or the noun is the lowered-basket.

Instead of raising-basket something:
	if the basket-is-at-top is true:
		say "The basket is already at the top.";
	otherwise:
		now the basket-is-at-top is true;
		now the raised-basket is in Shaft Room;
		now the lowered-basket is in Drafty Room;
		say "The basket is raised to the top of the shaft."

Lowering is an action applying to one thing. Understand "lower [something]" as lowering.
Carry out lowering: say "You can't lower that."

Instead of lowering the raised-basket:
	if the basket-is-at-top is false:
		say "The basket is already at the bottom.";
	otherwise:
		now the basket-is-at-top is false;
		now the raised-basket is in Drafty Room;
		now the lowered-basket is in Shaft Room;
		say "The basket is lowered to the bottom of the shaft."

Instead of lowering the lowered-basket:
	try lowering the raised-basket.

Machine-Room is a dark room. Machine-Room is in the Underground.
The printed name of Machine-Room is "Machine Room".
North of Machine-Room is Drafty Room.
The description of Machine-Room is "This is a large, cold room whose sole exit is to the north. In one corner there is a machine which is reminiscent of a clothes dryer. On its face is a switch which is labelled [quotation mark]START[quotation mark]. The switch does not appear to be manipulable by any human hand (unless the fingers are about 1/16 by 1/4 inch). On the front of the machine is a large lid, which is [if the machine is open]open[otherwise]closed[end if].".

The machine is a closed openable container in Machine-Room. The machine is scenery.
Understand "machine" and "pdp10" and "dryer" and "lid" as the machine.
The carrying capacity of the machine is 5.
The description of the machine is "It's a machine which is reminiscent of a clothes dryer. On its face is a switch labelled [quotation mark]START[quotation mark]. On the front is a large lid, which is [if the machine is open]open[otherwise]closed[end if]."

The machine switch is scenery in Machine-Room. Understand "switch" and "start" as the machine switch.
The description of the machine switch is "The switch is labelled [quotation mark]START[quotation mark]. It does not appear to be manipulable by any human hand (unless the fingers are about 1/16 by 1/4 inch)."

Instead of switching on the machine switch:
	if the machine is not closed:
		say "The machine must be closed first.";
	otherwise if the small pile of coal is in the machine:
		remove the small pile of coal from play;
		now the huge diamond is in the machine;
		say "The machine comes to life (figuratively) with a dazzling display of colored lights and bizarre noises. After a few moments, the excitement abates.";
	otherwise:
		let found-something be false;
		repeat with item running through things in the machine:
			now found-something is true;
			remove item from play;
			now the small piece of vitreous slag is in the machine;
		if found-something is true:
			say "The machine comes to life (figuratively) with a dazzling display of colored lights and bizarre noises. After a few moments, the excitement abates.";
		otherwise:
			say "The machine comes to life (figuratively) with a dazzling display of colored lights and bizarre noises. After a few moments, the excitement abates."

The huge diamond is a thing. "There is an enormous diamond (perfectly cut) here."
Understand "diamond" and "huge" and "enormous" as the huge diamond.
The treasure-value of the huge diamond is 10.
The point-value of the huge diamond is 10.

The small piece of vitreous slag is a thing. Understand "gunk" and "piece" and "slag" and "small" and "vitreous" as the small piece of vitreous slag.
The description of the small piece of vitreous slag is "It's a small piece of vitreous slag."

Slide Room is a dark room. "This is a small chamber, which appears to have been part of a coal mine. On the south wall of the chamber the letters 'Granite Wall' are etched in the rock. To the east is a long passage, and there is a steep metal slide twisting downward. To the north is a small opening."
Slide Room is in the Underground.
East of Slide Room is Cold Passage. North of Slide Room is Mine Entrance.

Instead of going down in Slide Room:
	say "You tumble down the slide....";
	move the player to Cellar.

The broken timber is in Timber Room.
Understand "timbers" and "pile" and "wooden" and "broken" as the broken timber.
The description of the broken timber is "They're just a pile of broken timbers."

Chapter 19 - Stone Barrow and Endgame

Stone Barrow is a room. "You are standing in front of a massive barrow of stone. In the east face is a huge stone door which is open. You cannot see into the dark of the tomb."
Northeast of Stone Barrow is West-of-House.

Instead of going southwest in West-of-House:
	if the won-flag is true:
		move the player to Stone Barrow;
	otherwise:
		say "You can't go that way."

Instead of going inside in Stone Barrow:
	say "Inside the Barrow[line break]As you enter the barrow, the door closes inexorably behind you. Around you it is dark, but ahead is an enormous cavern, brightly lit. Through its center runs a wide stream. Spanning the stream is a small wooden footbridge, and beyond a path leads into a dark tunnel. Above the bridge, floating in the air, is a large sign. It reads: All ye who stand before this bridge have completed a great and perilous adventure which has tested your wit and courage. You have mastered the first part of the ZORK trilogy. Those who pass over this bridge must be prepared to undertake an even greater adventure that will severely test your skill and bravery![paragraph break]The ZORK trilogy continues with 'ZORK II: The Wizard of Frobozz' and is completed in 'ZORK III: The Dungeon Master.'[line break]";
	end the story finally saying "Congratulations!"

Instead of going west in Stone Barrow:
	try going inside.

Chapter 20 - In-Stream

In-Stream is a room. The printed name of In-Stream is "Stream". "You are on the gently flowing stream. The upstream route is too narrow to navigate, and the downstream route is invisible due to twisting walls. There is a narrow beach to land on."
In-Stream is in the Underground.

Up from Reservoir is In-Stream. West of Reservoir is In-Stream.
Down from In-Stream is Reservoir. East of In-Stream is Reservoir.

Instead of going up in In-Stream:
	say "The channel is too narrow."

Instead of going west in In-Stream:
	say "The channel is too narrow."

Landing is an action applying to nothing. Understand "land" as landing.
Carry out landing:
	if the player is in In-Stream:
		move the player to Stream View;
	otherwise:
		say "You're not on the water."

Part 4 - The Thief

Chapter 1 - Thief NPC

The thief is a person. "[if the thief-unconscious is true]There is a suspicious-looking individual lying unconscious on the ground.[otherwise]There is a suspicious-looking individual, holding a large bag, leaning against one wall. He is armed with a vicious-looking stiletto.[end if]"
Understand "thief" and "robber" and "man" and "person" and "shady" and "suspicious" and "seedy" as the thief.
The thief is in Round Room.
The description of the thief is "The thief is a slippery character with beady eyes that flit back and forth. He carries, along with an unmistakable arrogance, a large bag over his shoulder and a vicious stiletto, whose blade is aimed menacingly in your direction. I'd watch out if I were you."

The thief-strength is a number that varies. The thief-strength is 5.
The thief-unconscious is a truth state that varies. The thief-unconscious is false.
The thief-unconscious-timer is a number that varies. The thief-unconscious-timer is 0.

The large bag is carried by the thief. The large bag is a container. The carrying capacity of the large bag is 100.
Understand "bag" and "large" and "thief's" as the large bag.
The description of the large bag is "[if the thief-unconscious is true]The bag is underneath the thief, so one can't say what, if anything, is inside.[otherwise if the thief is defeated]It's a large bag.[otherwise]The bag is closed and you can't see what's inside.[end if]".

The stiletto is carried by the thief. The stiletto is a weapon.
Understand "stiletto" and "vicious" as the stiletto.
The description of the stiletto is "It's a vicious-looking stiletto."

Instead of taking the stiletto when the thief is not defeated and the thief carries the stiletto:
	say "The thief swings it out of your reach."

Instead of taking the large bag:
	if the thief-unconscious is true:
		say "Sadly for you, the robber collapsed on top of the bag. Trying to take it would wake him.";
	otherwise if the thief is not defeated:
		say "The bag will be taken over his dead body.";
	otherwise:
		continue the action.

Instead of opening the large bag when the thief is not defeated:
	say "Getting close enough would be a good trick."

Instead of inserting something into the large bag when the thief is not defeated:
	say "It would be a good trick."

The thief-active is a truth state that varies. The thief-active is true.
The thief-here-count is a number that varies. The thief-here-count is 0.
The thief-engrossed is a truth state that varies. The thief-engrossed is false.

Every turn when the thief is not defeated and the thief-active is true (this is the thief daemon rule):
	if a random chance of 1 in 5 succeeds:
		let thief-room be the location of the thief;
		if thief-room is the location of the player:
			if the player carries the clove of garlic:
				do nothing; [garlic repels]
			otherwise:
				let stolen-item be nothing;
				repeat with item running through things carried by the player:
					if the treasure-value of item > 0:
						now stolen-item is item;
						break;
				if stolen-item is not nothing:
					now stolen-item is in the large bag;
					let R be a random number between 1 and 4;
					if R is 1:
						say "A seedy-looking individual with a large bag just wandered through the room. On the way through, he quietly abstracted some valuables from your possession, mumbling something about [quotation mark]Doing unto others before...[quotation mark]";
					otherwise if R is 2:
						say "The thief just left, still carrying his large bag. You may not have noticed that he robbed you blind first.";
					otherwise if R is 3:
						say "A seedy-looking individual with a large bag just wandered through the room. On the way through, he appropriated the [stolen-item].";
					otherwise:
						say "A [quotation mark]lean and hungry[quotation mark] gentleman just wandered through, carrying a large bag. On the way, he helped himself to the [stolen-item].";
					let new-dest be a random dark room that is in the Underground;
					if new-dest is a room:
						move the thief to new-dest;
				otherwise:
					let R be a random number between 1 and 2;
					if R is 1:
						say "A [quotation mark]lean and hungry[quotation mark] gentleman just wandered through, carrying a large bag. Finding nothing of value, he left disgruntled.";
					otherwise:
						say "The thief, finding nothing of value, left disgusted.";
					let new-dest be a random dark room that is in the Underground;
					if new-dest is a room:
						move the thief to new-dest;
		otherwise:
			if a random chance of 1 in 3 succeeds:
				let dir be a random direction;
				let new-room be the room dir from thief-room;
				if new-room is a room:
					move the thief to new-room.

Every turn when the jewel-encrusted egg is in the large bag and the jewel-encrusted egg is closed (this is the thief opens egg rule):
	now the jewel-encrusted egg is open.

Every turn when the player is in Treasure Room and the thief is not defeated and the thief is not in Treasure Room (this is the thief lair rule):
	move the thief to Treasure Room;
	say "You hear a scream of anguish as you violate the robber's hideaway. Using passages unknown to you, he rushes to its defense."

To kill the thief with magic:
	say "Almost as soon as the thief breathes his last breath, a cloud of sinister black fog envelops him, and when the fog lifts, the carcass has disappeared.";
	if the player is in Treasure Room:
		say "[line break]As the thief dies, the power of his magic decreases, and his treasures reappear:";
	repeat with item running through things in the large bag:
		now item is in the location of the player;
	now the thief is defeated;
	remove the thief from play.

Instead of attacking the thief:
	if the thief is not in the location of the player:
		say "There is no thief here." instead;
	if the thief is defeated:
		say "The thief is already dead.";
	otherwise if the thief-unconscious is true:
		kill the thief with magic;
	otherwise:
		let W be a random weapon carried by the player;
		if W is nothing:
			say "Trying to attack the thief with your bare hands is suicidal.";
		otherwise:
			let hit-chance be a random number between 1 and 10;
			if hit-chance is at least 3:
				decrease the thief-strength by 1;
				if the thief-strength is at most 0:
					now the thief-unconscious is true;
					now the thief-unconscious-timer is 3;
					if the thief carries the stiletto:
						now the stiletto is in the location of the player;
					say "The thief is stunned and appears dazed. He stumbles and falls to the ground.";
				otherwise:
					say "You wound the thief with your [W].";
			otherwise:
				say "The thief deftly dodges your blow."

Instead of destroying the thief:
	if the thief-unconscious is true:
		kill the thief with magic;
	otherwise if the thief is not defeated:
		say "The thief laughs at your puny attempt.";
	otherwise:
		say "There is no thief here."

Every turn when the thief-unconscious is true and the thief-unconscious-timer > 0 (this is the thief recovery rule):
	decrease the thief-unconscious-timer by 1;
	if the thief-unconscious-timer is 0:
		now the thief-unconscious is false;
		now the thief-strength is 5;
		if the stiletto is in the location of the thief:
			now the thief carries the stiletto;
			if the player is in the location of the thief:
				say "The robber, somewhat surprised at this turn of events, nimbly retrieves his stiletto.";
		if the player is in the location of the thief:
			say "The robber revives, briefly feigning continued unconsciousness, and, when he sees his moment, scrambles away from you.";
		let new-dest be a random dark room that is in the Underground;
		if new-dest is a room:
			move the thief to new-dest.

Chapter 2 - Sword Glow

The sword-glowing is a truth state that varies. The sword-glowing is false.

Every turn when the player carries the sword (this is the sword glow rule):
	let danger-near be false;
	if the troll is not defeated and the troll is in the location of the player:
		now danger-near is true;
	if the thief is not defeated and the thief is in the location of the player:
		now danger-near is true;
	if danger-near is true and the sword-glowing is false:
		now the sword-glowing is true;
		say "Your sword is glowing with a faint blue glow.";
	if danger-near is false and the sword-glowing is true:
		now the sword-glowing is false;
		say "Your sword is no longer glowing."

Part 5 - Miscellaneous Actions and Rules

Chapter 0 - Container Safety

Before inserting something into a container (called the target):
	if the target is enclosed by the noun:
		say "That would be quite a trick." instead.

To spill the contents of (C - a container):
	repeat with item running through things in C:
		now item is in the holder of C.

Chapter 1 - Hello Sailor

Understand "hello sailor" as a mistake ("Nothing happens here.").

Chapter 2 - Pray

Praying is an action applying to nothing. Understand "pray" as praying.
Carry out praying:
	if the player-is-dead is true and the player is in South Temple:
		now the player-is-dead is false;
		now the always-lit-mode is false;
		scatter-possessions;
		say "From the distance the sound of a lone trumpet is heard. The room becomes very bright and you feel disembodied. In a moment, the brightness fades and you find yourself rising as if from a long sleep, deep in the woods. In the distance you can faintly hear a songbird and the sounds of the forest.";
		move the player to Forest1;
	otherwise if the player-is-dead is true:
		say "Your prayers are not heard.";
	otherwise if the player is in South Temple:
		say "If you pray enough, your prayers may be answered.";
	otherwise:
		say "If you pray hard enough, something may happen."

Chapter 3 - Jump

Instead of jumping:
	say "Wheeeeee!!!!!";

Chapter 4 - Diagnose

Diagnosing is an action out of world. Understand "diagnose" as diagnosing.
Carry out diagnosing:
	if the player-is-dead is true:
		say "You are dead.";
	otherwise:
		say "You are in perfect health.";
	if the player-deaths is 1:
		say "[line break]You have been killed once.";
	otherwise if the player-deaths > 1:
		say "[line break]You have been killed [player-deaths in words] times."

Chapter 5 - Rusty Knife Curse

Every turn when the player carries the rusty knife and the player carries the sword (this is the rusty knife curse rule):
	say "As the rust of the knife reaches the sword, they react violently, and the rusty knife disintegrates.";
	remove the rusty knife from play.

Chapter 6 - Chimney Passage

Instead of going up in Studio:
	let items-carried be 0;
	repeat with item running through things carried by the player:
		increase items-carried by 1;
	if items-carried is 0:
		say "Going up empty-handed is a bad idea.";
	otherwise if items-carried > 2:
		say "You can't get up there with what you're carrying.";
	otherwise if the player carries the brass lantern and items-carried <= 2:
		move the player to Kitchen;
	otherwise:
		say "You can't get up there with what you're carrying."

Chapter 7 - Room Visit Points

The cellar-visited is a truth state that varies. The cellar-visited is false.
The kitchen-visited is a truth state that varies. The kitchen-visited is false.
The east-west-visited is a truth state that varies. The east-west-visited is false.
The treasure-room-visited is a truth state that varies. The treasure-room-visited is false.

After going to Cellar when the cellar-visited is false:
	now the cellar-visited is true;
	increase the score by 25;
	continue the action.

After going to Kitchen when the kitchen-visited is false:
	now the kitchen-visited is true;
	increase the score by 10;
	continue the action.

After going to East-West Passage when the east-west-visited is false:
	now the east-west-visited is true;
	increase the score by 5;
	continue the action.

After going to Treasure Room when the treasure-room-visited is false:
	now the treasure-room-visited is true;
	increase the score by 25;
	continue the action.

Chapter 8 - Ancient Map

The ancient map is in the trophy case. The ancient map is invisible.
Understand "parchment" and "map" and "antique" and "old" and "ancient" as the ancient map.
The description of the ancient map is "The map shows a forest with three clearings. The largest clearing contains a house. Three paths leave the large clearing. One of these paths, leading southwest, is marked 'To Stone Barrow'."

Chapter 9 - Lurking Grue

The lurking grue is a backdrop. The lurking grue is everywhere.
Understand "grue" and "lurking" and "sinister" and "hungry" and "silent" as the lurking grue.
The description of the lurking grue is "The grue is a sinister, lurking presence in the dark places of the earth. Its favorite diet is adventurers, but its insatiable appetite is tempered by its fear of light. No grue has ever been seen by the light of day, and few have survived its fearsome jaws to tell the tale."

Chapter 10 - Additional Game Verbs

Understand "xyzzy" as a mistake ("A hollow voice says [quotation mark]Fool.[quotation mark]").
Understand "plugh" as a mistake ("A hollow voice says [quotation mark]Fool.[quotation mark]").

Zorking is an action applying to nothing. Understand "zork" as zorking.
Carry out zorking: say "At your service!"

Frobozzing is an action applying to nothing. Understand "frobozz" as frobozzing.
Carry out frobozzing: say "The FROBOZZ Corporation created, owns, and operates this dungeon."

Winning is an action applying to nothing. Understand "win" as winning.
Carry out winning: say "Naturally!"

Yelling is an action applying to nothing. Understand "yell" and "scream" and "shout" as yelling.
Carry out yelling: say "Aaaarrrrgggghhhh!"

Repenting is an action applying to nothing. Understand "repent" as repenting.
Carry out repenting: say "It could very well be too late!"

Instead of waiting: say "Time passes..."

Swimming is an action applying to nothing. Understand "swim" as swimming.
Instead of swimming: say "Swimming isn't usually allowed in the dungeon."

Instead of kissing someone: say "I'd sooner kiss a pig."

Instead of smelling something: say "It smells like a [noun]."

Instead of listening to something: say "The [noun] makes no sound."

Chapter 10a - Burn Action

Burning it with is an action applying to two things. Understand "burn [something] with [something]" and "light [something] with [something]" as burning it with.

Carry out burning it with:
	if the noun is the pair of candles and the second noun is the matchbook and the match-lit is true:
		try lighting-candles the pair of candles instead;
	say "You can't burn that."

Chapter 11 - Boat System

The magic boat is a thing. The magic boat is an open enterable container. The carrying capacity of the magic boat is 10.
Understand "boat" and "raft" and "magic" and "plastic" and "seaworthy" and "inflat" as the magic boat.
The description of the magic boat is "It's a seaworthy magic boat."

The punctured boat is a thing. "There is a large punctured boat here."
Understand "boat" and "pile" and "plastic" and "punctured" and "large" as the punctured boat.
The description of the punctured boat is "It's a punctured boat beyond repair."

The tan label is a thing. The tan label is in the magic boat.
Understand "label" and "fineprint" and "print" and "tan" and "fine" as the tan label.
The description of the tan label is "!!!!FROBOZZ MAGIC BOAT COMPANY!!!![paragraph break]Hello, Sailor![paragraph break]Instructions for use:[paragraph break]   To get into a body of water, say 'Launch'.[line break]   To get to shore, say 'Land' or the direction in which you want to maneuver the boat.[paragraph break]Warranty:[line break]  This boat is guaranteed against all defects for a period of 76 milliseconds from date of purchase or until first used, whichever comes first.[paragraph break]Warning:[line break]   This boat is made of thin plastic.[line break]   Good Luck!"

The boat-inflated is a truth state that varies. The boat-inflated is false.
The boat-punctured is a truth state that varies. The boat-punctured is false.

Inflating is an action applying to one thing. Understand "inflate [something]" and "pump up [something]" as inflating.
Carry out inflating: say "You can't inflate that."

Instead of inflating the pile of plastic:
	if the player carries the hand-held air pump or the hand-held air pump is in the location of the player:
		say "The boat inflates and appears seaworthy.[line break](You are now in the magic boat.)";
		now the boat-inflated is true;
		now the pile of plastic is nowhere;
		now the magic boat is in the location of the player;
		now the player is in the magic boat;
	otherwise:
		say "You don't have anything to inflate it with."

Instead of inflating the magic boat:
	say "It's already inflated."

Deflating is an action applying to one thing. Understand "deflate [something]" as deflating.
Carry out deflating: say "You can't deflate that."

Instead of deflating the magic boat:
	say "The boat deflates.";
	now the boat-inflated is false;
	let R be the location of the magic boat;
	if the player is in the magic boat:
		move the player to R;
	repeat with item running through things in the magic boat:
		now item is in R;
	now the magic boat is nowhere;
	now the pile of plastic is in R.

Before entering the magic boat:
	let sharp-items be false;
	if the player carries the sword:
		now sharp-items is true;
	if the player carries the sceptre:
		now sharp-items is true;
	if the player carries the nasty knife:
		now sharp-items is true;
	if the player carries the rusty knife:
		now sharp-items is true;
	if sharp-items is true:
		say "The pointy object pokes a hole in the boat, which deflates instantly.";
		now the boat-punctured is true;
		spill the contents of the magic boat;
		now the magic boat is nowhere;
		now the punctured boat is in the location of the player;
		stop the action.

Launching is an action applying to nothing. Understand "launch" as launching.
Carry out launching:
	if the player is not in the magic boat:
		say "You're not in a boat.";
	otherwise if the player is in Dam-Base:
		say "You push off from the shore.";
		move the magic boat to River1;
		now the river-current-active is true;
		now the river-current-timer is 4;
	otherwise if the player is in White Cliffs North:
		say "You push off from the shore.";
		move the magic boat to River3;
		now the river-current-active is true;
		now the river-current-timer is 3;
	otherwise if the player is in White Cliffs South:
		say "You push off from the shore.";
		move the magic boat to River4;
		now the river-current-active is true;
		now the river-current-timer is 2;
	otherwise if the player is in Shore:
		say "You push off from the shore.";
		move the magic boat to River5;
		now the river-current-active is true;
		now the river-current-timer is 1;
	otherwise if the player is in Sandy Beach:
		say "You push off from the shore.";
		move the magic boat to River4;
		now the river-current-active is true;
		now the river-current-timer is 2;
	otherwise if the player is in Reservoir-South or the player is in Reservoir-North:
		say "You push off from the shore.";
		move the magic boat to Reservoir;
	otherwise if the player is in Stream View:
		say "You push off from the shore.";
		move the magic boat to In-Stream;
	otherwise:
		say "You're not near any water."

Chapter 12 - Buoy and Emerald

The red buoy is in River4. "There is a red buoy here (probably a warning)."
Understand "buoy" and "red" as the red buoy.
The red buoy is a closed openable container. The carrying capacity of the red buoy is 3.

The large emerald is in the red buoy.
Understand "emerald" and "large" as the large emerald.
The treasure-value of the large emerald is 5.
The point-value of the large emerald is 10.

Chapter 13 - Trunk of Jewels

The trunk of jewels is in Reservoir. The trunk of jewels is invisible.
Understand "trunk" and "chest" and "jewels" and "old" as the trunk of jewels.
The treasure-value of the trunk of jewels is 15.
The point-value of the trunk of jewels is 5.
The description of the trunk of jewels is "There is an old trunk here, bulging with assorted jewels."

After going to Reservoir:
	if the low-tide is true and the trunk of jewels is invisible:
		now the trunk of jewels is visible;
		say "Lying half buried in the mud is an old trunk, bulging with jewels.[line break]";
	continue the action.

Chapter 14 - Gate/Bolt Interaction

Turning-bolt is an action applying to one thing. Understand "turn [something]" as turning-bolt when the noun is the bolt.

Instead of turning-bolt the bolt:
	if the player does not carry the wrench:
		say "The bolt won't turn with your best effort.";
	otherwise if the gate-flag is false:
		say "The bolt won't turn with your best effort.";
	otherwise if the gates-open is true:
		now the gates-open is false;
		now the reservoir-fill-timer is 8;
		say "The sluice gates close and water starts to collect behind the dam.";
	otherwise:
		now the gates-open is true;
		now the reservoir-empty-timer is 8;
		say "The sluice gates open and water pours through the dam."

The reservoir-fill-timer is a number that varies. The reservoir-fill-timer is 0.
The reservoir-empty-timer is a number that varies. The reservoir-empty-timer is 0.

Every turn when the reservoir-empty-timer > 0 (this is the reservoir emptying rule):
	decrease the reservoir-empty-timer by 1;
	if the reservoir-empty-timer is 0:
		now the low-tide is true;
		now the trunk of jewels is visible;
		if the player is in Dam-Room:
			say "The water level behind the dam is now quite low."

Every turn when the reservoir-fill-timer > 0 (this is the reservoir filling rule):
	decrease the reservoir-fill-timer by 1;
	if the reservoir-fill-timer is 0:
		now the low-tide is false;
		now the trunk of jewels is invisible;
		if the player is in Reservoir:
			die saying "You are lifted up by the rising river! You try to swim, but the currents are too strong. You come closer, closer to the awesome structure of Flood Control Dam #3. The dam beckons to you. The roar of the water nearly deafens you, but you remain conscious as you tumble over the dam toward your certain doom among the rocks at its base.";
		if the player is in Dam-Room:
			say "The water level behind the dam is now quite high."

Chapter 15 - Room Entering Points

After going to a room (called destination) (this is the coffin cure rule):
	if the player carries the gold coffin:
		now the coffin-cure is true;
	continue the action.
