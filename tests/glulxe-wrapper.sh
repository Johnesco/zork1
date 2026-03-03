#!/bin/bash
# Wrapper around glulxe that answers "n" to the sound prompt before
# forwarding test commands. Required because regtest.py's cheap mode
# waits for "\n>" which the yes/no sound prompt doesn't produce.
#
# Uses stdbuf to disable output buffering so regtest.py sees the
# prompt character (">") in real time instead of waiting for a full buffer.
{ echo "n"; cat; } | stdbuf -oL "$@"
