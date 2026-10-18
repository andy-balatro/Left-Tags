# Left Tags

A [Lovely](https://github.com/ethangreen-dev/lovely-injector) mod for Balatro that stacks skip tags up the left margin instead of the right one. That frees the bottom-right corner for something else, like a Twitch chat panel on stream. It doesn't need Steamodded.

- Tags are drawn a bit smaller so they fit between the window's edge and the HUD.
- Their tooltips open to the right, since the left side is off screen.
- When the bottom tag is used up, the next one slides down the left margin.

The layout is made for a 16:9 window. In narrower windows the tags get cut off at the left edge.

The mod replaces the game's `add_tag`, so other mods that also replace it won't work with it.

## Install

1. Install Lovely: download `lovely-x86_64-pc-windows-msvc.zip` from the [Lovely releases](https://github.com/ethangreen-dev/lovely-injector/releases) and copy `version.dll` into the Balatro game directory (Steam → Balatro → Manage → Browse local files).
2. Download `Left-Tags.zip` from the [latest release](https://github.com/andy-balatro/Left-Tags/releases/latest) and extract it into `%AppData%\Balatro\Mods`, so you get `Mods\Left-Tags\lovely.toml`.

## Development

Link the repo into the mods folder so edits apply on the next game launch (PowerShell, from this repo):

```powershell
New-Item -ItemType Junction -Path "$env:APPDATA\Balatro\Mods\Left-Tags" -Target "$PWD"
```

To check what got injected, look at `%AppData%\Balatro\Mods\lovely\dump\main.lua`. Errors go to `Mods\lovely\log`.
