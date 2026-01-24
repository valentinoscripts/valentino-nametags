# Lucky Nametags

A performance-focused nametag system for FiveM. Designed with optimization in mind!

## ✨ Features
* **Auto-Framework Detection**: Seamlessly supports ESX, QB-Core, QBX, or Standalone modes.
* **Dynamic Scaling**: Nametag size adjusts automatically based on the distance between players.
* **Privacy Mode**: Players can hide their own tags from others using the `/ntmask` command.
* **Social Highlights**: Ability to "Friend" or "Mark" players with unique, customizable colors.
* **Smart Visibility**: Built-in line-of-sight checks to prevent seeing tags through walls or objects.
* **Performance Optimized**: Uses efficient threading and State Bags for high-speed data syncing.

## ⌨️ Commands
| Command | Action |
| :--- | :--- |
| `/tognames` | Toggles all nametags on or off locally. |
| `/togids` | Toggles the display of Server IDs in the nametag. |
| `/ntmask` | Toggles your own visibility to other players. |
| `/friend <id>` | Highlights a player with your configured Friend color. |
| `/mark <id>` | Highlights a player with your configured Mark color. |

## Installation
1. Ensure [ox_lib](https://github.com/overextended/ox_lib) is installed and started.
2. Place the `lucky-nametags` folder into your resources directory.
3. Add `ensure lucky-nametags` to your `server.cfg`.
4. Customize colors, fonts, and distances in `config.lua`.

---
*Developed by **LuckyScripts***
