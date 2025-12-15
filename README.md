# sd_combatlog

Track and visualize player disconnections (combat logs) in 3D world space using ox_lib.

## Features
- Detects when players disconnect and logs their last position.
- Use commands (`/combat`, `/combatlog`) to toggle 3D markers showing recent disconnections.
- Displays player name, disconnect reason, time, and elapsed seconds since disconnect.
- **Secure by design** – data is stored server-side and only sent to the client on demand when the command is used.
- Configurable cache duration and search distance.
- Customizable 3D text style (font, scale, color, outline).
- Auto-hide display after configurable duration.
- Localized notifications/messages (EN, CS included).

## Requirements
- ox_lib (init script and locale enabled)

## Installation
1. Place this resource into your server resources.
2. Ensure dependencies and this resource in `server.cfg`:
   ```cfg
   ensure ox_lib
   ensure sd_combatlog
   ```
3. Adjust `config.lua` to match your preferences.
4. Done.

## Usage
- Use `/combat` or `/combatlog` to toggle the display of nearby disconnections.
- 3D markers will appear at the last known position of disconnected players within range.
- Each marker shows:
  - Player name and server ID
  - Disconnect reason
  - Disconnect time
  - Seconds elapsed since disconnect
- The display automatically hides after the configured duration.

## Notes
- Logs are cached server-side and automatically removed after `Config.Cache.Duration`.
- Only disconnections within `Config.Cache.Distance` of the command user are shown.
- No data is sent to clients until explicitly requested via command – prevents unnecessary network traffic and keeps information secure.
- Debug mode available via `Config.Debug` for testing purposes.

## Credits
- Author: `fashion.demon`

