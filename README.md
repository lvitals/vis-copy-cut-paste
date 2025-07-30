vis-copy-cut-paste

Clipboard copy, cut, and paste plugin for the vis editor.

Features

- Copy selected text to the system clipboard using Ctrl+C in visual mode.
- Cut selected text to the system clipboard using Ctrl+X in visual mode.
- Paste clipboard contents at the cursor position using Ctrl+V in insert, normal, and visual modes.
- Select all text with Ctrl+A in normal, visual, and insert modes.

Installation

Place the vis-copy-cut-paste.lua file in your vis plugins directory, for example:
~/.config/vis/plugins/vis-copy-cut-paste/init.lua

Make sure to require or load the plugin in your visrc.lua:
require('vis-copy-cut-paste')

Usage

In visual mode, select text and press Ctrl+C to copy or Ctrl+X to cut.
In any mode, press Ctrl+V to paste from the clipboard.
Press Ctrl+A to select all text.

Dependencies

Requires vis-clipboard utility to handle system clipboard operations.

Notes

The plugin uses temporary files to transfer clipboard contents.
Ctrl+X mapping works in visual mode to cut text and exit visual mode afterwards.

License

This plugin is licensed under the MIT
