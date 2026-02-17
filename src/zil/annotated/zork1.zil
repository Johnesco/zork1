@@ zork1.zil — Project Manifest
@@ The top-level build file for Zork I. This file configures the Z-machine
@@ target, sets default property values shared by all objects, then includes
@@ the shared "substrate" libraries (parser, verbs, macros, etc.) followed
@@ by the two Zork I-specific script files: dungeon.zil (world model) and
@@ actions.zil (game logic). The ZORK-NUMBER global (set to 1) is used by
@@ conditional compilation throughout the substrate to select Zork I-specific
@@ code paths — the same substrate was shared across all three Zork games.
@@
@@ ---
;"ZORK1 for
	        Zork I: The Great Underground Empire
	(c) Copyright 1983 Infocom, Inc.  All Rights Reserved."

;"Settings"

<CONSTANT RELEASEID 1>
<VERSION ZIP>
<FREQUENT-WORDS?>
<SETG ZORK-NUMBER 1>

;"Default Property Values"

<PROPDEF SIZE 5>
<PROPDEF CAPACITY 0>
<PROPDEF VALUE 0>
<PROPDEF TVALUE 0>

;"Substrate"

<INSERT-FILE "../zork-substrate/main">
<INSERT-FILE "../zork-substrate/clock">
<INSERT-FILE "../zork-substrate/parser">
<INSERT-FILE "../zork-substrate/syntax">
<INSERT-FILE "../zork-substrate/macros">
<INSERT-FILE "../zork-substrate/verbs">
<INSERT-FILE "../zork-substrate/globals">

;"Script"

<INSERT-FILE "dungeon">
<INSERT-FILE "actions">
