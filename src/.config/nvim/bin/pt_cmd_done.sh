#!/usr/bin/env bash

# Used by project_terminals.lua to signal that a command has completed.
# The signal is a custom OSC request.

echo -e "\e]8084;$1 $2\e\\"
