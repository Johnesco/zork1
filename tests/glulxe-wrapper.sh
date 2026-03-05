#!/bin/bash
# Wrapper around glulxe that disables output buffering so regtest.py
# sees the prompt character (">") in real time instead of waiting for
# a full buffer.
cat | stdbuf -oL "$@"
