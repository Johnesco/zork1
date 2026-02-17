@@ globals.zil — Global Objects
@@ The shared global object tree used by all three Zork games. In ZIL,
@@ "global" objects are always in scope regardless of the player's location
@@ — they represent abstract concepts (the grue, ground, air, yourself)
@@ and catch-all vocabulary (paths, stairs, sailor) that the parser should
@@ recognize everywhere. The file also sets up the internal plumbing that
@@ the parser needs: the pronoun object (IT), the NOT-HERE-OBJECT for
@@ graceful "you can't see that" messages, and PSEUDO-OBJECT for location-
@@ specific fake nouns defined via room PSEUDO properties.
@@
@@ ---
			"Generic GLOBALS file for
			    The ZORK Trilogy
		       started on 7/28/83 by MARC"

"SUBTITLE GLOBAL OBJECTS"

@@ GLOBAL-OBJECTS is the root container for all always-in-scope objects.
@@ Its FLAGS are a superset of every flag the parser might test, ensuring
@@ that global children pass any flag-based object search filter.
<OBJECT GLOBAL-OBJECTS
	(FLAGS RMUNGBIT INVISIBLE TOUCHBIT SURFACEBIT TRYTAKEBIT
	       OPENBIT SEARCHBIT TRANSBIT ONBIT RLANDBIT FIGHTBIT
	       STAGGERED WEARBIT)>

@@ LOCAL-GLOBALS holds objects that are "local globals" — in scope only
@@ when a room's GLOBAL property references them (e.g., stairs, paths).
@@ The PSEUDO property lets rooms define ad-hoc nouns (like "painting")
@@ that map to verb routines without needing a real object.
<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZMGCK)
	(DESCFCN PATH-OBJECT)
        (GLOBAL GLOBAL-OBJECTS)
	(ADVFCN 0)
	(FDESC "F")
	(LDESC "F")
	(PSEUDO "FOOBAR" V-WALK)
	(CONTFCN 0)
	(VTYPE 1)
	(SIZE 0)
	(CAPACITY 0)>

;"Yes, this synonym for LOCAL-GLOBALS needs to exist... sigh"

@@ ROOMS — a container whose sole purpose is to be the parent of all
@@ ROOM objects, giving the parser a tree to search for room names.
<OBJECT ROOMS
	(IN TO ROOMS)>

@@ INTNUM — a pseudo-object that lets the parser accept bare numbers
@@ as noun phrases (e.g., "turn dial to 3"). TOOLBIT marks it as a
@@ tool-like object that won't be refused by TAKE restrictions.
<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(SYNONYM INTNUM)
	(FLAGS TOOLBIT)
	(DESC "number")>

@@ PSEUDO-OBJECT — target for room-specific PSEUDO nouns. When a room
@@ defines (PSEUDO "PAINTING" V-LOOK-PAINTING), the parser routes the
@@ action through this object with CRETIN-FCN as the fallback.
<OBJECT PSEUDO-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "pseudo")
	(ACTION CRETIN-FCN)>

@@ IT — the pronoun object. The parser stores the last noun phrase
@@ referent here, so "take lamp; examine it" resolves IT to the lamp.
@@ THEM, HER, HIM are synonyms for the same pronoun resolution.
<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THEM HER HIM)
	(DESC "random object")
	(FLAGS NDESCBIT TOUCHBIT)>

@@ NOT-HERE-OBJECT — when the parser matches a word but can't find the
@@ corresponding object in scope, it substitutes this sentinel. The
@@ action routine then prints "You can't see any <noun> here!" using
@@ the raw input tokens rather than an object DESC.
<OBJECT NOT-HERE-OBJECT
	(DESC "such thing" ;"[not here]")
	(ACTION NOT-HERE-OBJECT-F)>

@@ NOT-HERE-OBJECT-F — prints the "can't see" message, handling both
@@ PRSO and PRSI positions, and formatting the original typed noun.
<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ)
	 ;"This COND is game independent (except the TELL)"
	 <COND (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "Those things aren't here!" CR>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 ;"Here is the default 'cant see any' printer"
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<TELL "You can't see any ">
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!" CR>)
	       (T
		<TELL "The " D ,WINNER " seems confused. \"I don't see any ">
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!\"" CR>)>
	 <RTRUE>>

@@ NOT-HERE-PRINT — reconstructs the player's typed noun from the
@@ raw input buffer (P-ITBL) rather than using an object DESC, since
@@ the object wasn't found. Handles the OOPS-flagged case (P-OFLAG)
@@ and distinguishes PRSO vs PRSI noun clause positions.
<ROUTINE NOT-HERE-PRINT (PRSO?)
 <COND (,P-OFLAG
	<COND (,P-XADJ <PRINTB ,P-XADJN>)>
	<COND (,P-XNAM <PRINTB ,P-XNAM>)>)
       (.PRSO?
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
       (T
	<BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

@@ NULL-F — a no-op routine used as a placeholder ACTION for objects
@@ that don't need custom behavior. Always returns false.
<ROUTINE NULL-F ("OPTIONAL" A1 A2)
	 <RFALSE>>

/^L

"Objects shared by all three Zorks go here"

@@ LOAD-MAX and LOAD-ALLOWED control inventory weight limits.
@@ Both default to 100 "size units" across the trilogy.
<GLOBAL LOAD-MAX 100>

<GLOBAL LOAD-ALLOWED 100>

@@ BLESSINGS — a vocabulary catch for "count your blessings" type input.
<OBJECT BLESSINGS
	(IN GLOBAL-OBJECTS)
	(SYNONYM BLESSINGS GRACES)
	(DESC "blessings")
	(FLAGS NDESCBIT)>

@@ STAIRS — a local-global that responds to "go up/down stairs" in any
@@ room that lists STAIRS in its GLOBAL property. CLIMBBIT allows the
@@ CLIMB verb to target it. The routine nudges the player to specify
@@ a direction instead.
<OBJECT STAIRS
	(IN LOCAL-GLOBALS)
	(SYNONYM STAIRS STEPS STAIRCASE STAIRWAY)
	(ADJECTIVE STONE DARK MARBLE FORBIDDING STEEP)
	(DESC "stairs")
	(FLAGS NDESCBIT CLIMBBIT)
	(ACTION STAIRS-F)>

<ROUTINE STAIRS-F ()
	 <COND (<VERB? THROUGH>
		<TELL
"You should say whether you want to go up or down." CR>)>>

@@ SAILOR — an Easter egg. Typing "hello sailor" increments a counter;
@@ every 10th/20th time it chides you. In Zork III the sailor actually
@@ appears on a Viking ship, but in Zork I it's just a running joke
@@ inherited from the mainframe Dungeon.
<OBJECT SAILOR
	(IN GLOBAL-OBJECTS)
	(SYNONYM SAILOR FOOTPAD AVIATOR)
	(DESC "sailor")
	(FLAGS NDESCBIT)
	(ACTION SAILOR-FCN)>

<ROUTINE SAILOR-FCN ()
	  <COND (<VERB? TELL>
		 <SETG P-CONT <>>
		 <SETG QUOTE-FLAG <>>
		 <TELL "You can't talk to the sailor that way." CR>)
		(<VERB? EXAMINE>
		 %<COND (<==? ,ZORK-NUMBER 3>
			 '<COND (<NOT <FSET? ,VIKING-SHIP ,INVISIBLE>>
				 <TELL
"He looks like a sailor." CR>
				 <RTRUE>)>)
			(ELSE T)>
		 <TELL
"There is no sailor to be seen." CR>)
		(<VERB? HELLO>
		 <SETG HS <+ ,HS 1>>
		 %<COND (<==? ,ZORK-NUMBER 3>
			 '<COND (<NOT <FSET? ,VIKING-SHIP ,INVISIBLE>>
		                 <TELL
"The seaman looks up and maneuvers the boat toward shore. He cries out \"I
have waited three ages for someone to say those words and save me from
sailing this endless ocean. Please accept this gift. You may find it
useful!\" He throws something which falls near you in the sand, then sails
off toward the west, singing a lively, but somewhat uncouth, sailor song." CR>
		                 <FSET ,VIKING-SHIP ,INVISIBLE>
		                 <MOVE ,VIAL ,HERE>)
		                (<==? ,HERE ,FLATHEAD-OCEAN>
		                 <COND (,SHIP-GONE
			                <TELL "Nothing happens anymore." CR>)
			               (T
				        <TELL "Nothing happens yet." CR>)>)
				(T <TELL "Nothing happens here." CR>)>)
			(T
			 '<COND (<0? <MOD ,HS 20>>
				 <TELL
"You seem to be repeating yourself." CR>)
				(<0? <MOD ,HS 10>>
				 <TELL
"I think that phrase is getting a bit worn out." CR>)
				(T
				 <TELL "Nothing happens here." CR>)>)>)>>

@@ GROUND — always in scope so "put X on ground" works as DROP.
@@ In Zork I, also handles DIG and the Sandy Cave special case.
<OBJECT GROUND
	(IN GLOBAL-OBJECTS)
	(SYNONYM GROUND SAND DIRT FLOOR)
	(DESC "ground")
	(ACTION GROUND-FUNCTION)>

<ROUTINE GROUND-FUNCTION ()
	 <COND (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,GROUND>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       %<COND (<==? ,ZORK-NUMBER 1>
		       '(<EQUAL? ,HERE ,SANDY-CAVE>
			 <SAND-FUNCTION>))
		      (T
		       '(<NULL-F>
			 <RFALSE>))>
	       (<VERB? DIG>
		<TELL "The ground is too hard for digging here." CR>)>>

@@ GRUE — the iconic lurking monster. This global object is always
@@ in scope so the player can EXAMINE or ASK ABOUT the grue anywhere.
@@ The actual grue attack logic (darkness kills) lives in the main
@@ loop, not here — this just provides flavor text.
<OBJECT GRUE
	(IN GLOBAL-OBJECTS)
	(SYNONYM GRUE)
	(ADJECTIVE LURKING SINISTER HUNGRY SILENT)
	(DESC "lurking grue")
	(ACTION GRUE-FUNCTION)>

<ROUTINE GRUE-FUNCTION ()
    <COND (<VERB? EXAMINE>
	   <TELL
"The grue is a sinister, lurking presence in the dark places of the
earth. Its favorite diet is adventurers, but its insatiable
appetite is tempered by its fear of light. No grue has ever been
seen by the light of day, and few have survived its fearsome jaws
to tell the tale." CR>)
	  (<VERB? FIND>
	   <TELL
"There is no grue here, but I'm sure there is at least one lurking
in the darkness nearby. I wouldn't let my light go out if I were
you!" CR>)
	  (<VERB? LISTEN>
	   <TELL
"It makes no sound but is always lurking in the darkness nearby." CR>)>>

@@ LUNGS — catches "hold breath", "breathe", etc. No action routine;
@@ the verb handlers deal with breathing.
<OBJECT LUNGS
	(IN GLOBAL-OBJECTS)
	(SYNONYM LUNGS AIR MOUTH BREATH)
	(DESC "blast of air")
	(FLAGS NDESCBIT)>

@@ ME — the player character object. "CRETIN" is the DESC because
@@ Zork's narrator is famously snarky ("you cretin"). ACTORBIT marks
@@ it as capable of being an actor for commands like "me, go north".
@@ The action routine handles self-referential commands with trademark
@@ Infocom wit: eating yourself, attacking yourself, throwing yourself.
<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(SYNONYM ME MYSELF SELF CRETIN)
	(DESC "cretin")
	(FLAGS ACTORBIT)
	(ACTION CRETIN-FCN)>

<ROUTINE CRETIN-FCN ()
	 <COND (<VERB? TELL>
		<SETG P-CONT <>>
		<SETG QUOTE-FLAG <>>
		<TELL
"Talking to yourself is said to be a sign of impending mental collapse." CR>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,ME>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<VERB? MAKE>
		<TELL "Only you can do that." CR>)
	       (<VERB? DISEMBARK>
		<TELL "You'll have to do that on your own." CR>)
	       (<VERB? EAT>
		<TELL "Auto-cannibalism is not the answer." CR>)
	       (<VERB? ATTACK MUNG>
		<COND (<AND ,PRSI <FSET? ,PRSI ,WEAPONBIT>>
		       <JIGS-UP "If you insist.... Poof, you're dead!">)
		      (T
		       <TELL "Suicide is not the answer." CR>)>)
	       (<VERB? THROW>
		<COND (<==? ,PRSO ,ME>
		       <TELL
"Why don't you just walk like normal people?" CR>)>)
	       (<VERB? TAKE>
		<TELL "How romantic!" CR>)
	       (<VERB? EXAMINE>
		<COND %<COND (<==? ,ZORK-NUMBER 1>
			      '(<EQUAL? ,HERE <LOC ,MIRROR-1> <LOC ,MIRROR-2>>
		                <TELL
"Your image in the mirror looks tired." CR>))
			     (<==? ,ZORK-NUMBER 3>
			      '(,INVIS
				<TELL
"A good trick, as you are currently invisible." CR>))
			     (T
			      '(<NULL-F> <RTRUE>))>
		      (T
		       %<COND (<==? ,ZORK-NUMBER 3>
			       '<TELL
"What you can see looks pretty much as usual, sorry to say." CR>)
			      (ELSE
			       '<TELL
"That's difficult unless your eyes are prehensile." CR>)>)>)>>

@@ ADVENTURER — the internal player object that tracks inventory,
@@ location, and combat stats. Separate from ME (which is the vocabulary
@@ object for self-reference). SACREDBIT prevents the thief from stealing it.
<OBJECT ADVENTURER
	(SYNONYM ADVENTURER)
	(DESC "cretin")
	(FLAGS NDESCBIT INVISIBLE SACREDBIT ACTORBIT)
	(STRENGTH 0)
	(ACTION 0)>

@@ PATHOBJ — catches "follow path", "take trail", etc. A local-global
@@ so it only appears in rooms that declare it via GLOBAL property.
<OBJECT PATHOBJ
	(IN GLOBAL-OBJECTS)
	(SYNONYM TRAIL PATH)
        (ADJECTIVE FOREST NARROW LONG WINDING)
	(DESC "passage")
	(FLAGS NDESCBIT)
	(ACTION PATH-OBJECT)>

<ROUTINE PATH-OBJECT ()
	 <COND (<VERB? TAKE FOLLOW>
		<TELL "You must specify a direction to go." CR>)
	       (<VERB? FIND>
		<TELL "I can't help you there...." CR>)
	       (<VERB? DIG>
		<TELL "Not a chance." CR>)>>

@@ ZORKMID — the currency of the Great Underground Empire. A global
@@ object so the player can ask about zorkmids anywhere.
<OBJECT ZORKMID
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZORKMID)
	(DESC "zorkmid")
	(ACTION ZORKMID-FUNCTION)>

<ROUTINE ZORKMID-FUNCTION ()
    <COND (<VERB? EXAMINE>
	   <TELL
"The zorkmid is the unit of currency of the Great Underground Empire." CR>)
	  (<VERB? FIND>
	   <TELL
"The best way to find zorkmids is to go out and look for them." CR>)>>

@@ HANDS — the player's bare hands, used as a default weapon when no
@@ weapon is specified for ATTACK. TOOLBIT marks it as a valid instrument.
<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(SYNONYM PAIR HANDS HAND)
	(ADJECTIVE BARE)
	(DESC "pair of hands")
	(FLAGS NDESCBIT TOOLBIT)>
