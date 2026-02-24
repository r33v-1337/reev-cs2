# Reev - CS2 Internal Cheese

![CS2](https://img.shields.io/badge/Game-Counter--Strike%202-yellow)
![Status](https://img.shields.io/badge/Status-Undetected-green)
![Windows](https://img.shields.io/badge/Platform-Windows-blue)

An advanced internal Cheese for Counter-Strike 2 with a modern UI and comprehensive feature set.

---

## 🎮 Features

### Legitbot
- Aimbot with customizable FOV, smoothing, and reaction time
- Multiple hitbox selection with priority system (Head, Chest, Stomach, Pelvis, Arms, Legs, Feet)
- Target priority options (FOV, Distance, Health)
- Smoothing types (Linear, Slow)
- FOV circle visualization
- Conditions (Visible, No smoke, No flash, Behind walls)
- Per-weapon configuration (Pistol, Rifle, SMG, Sniper, Shotgun, Machine Gun)
- Recoil Control System (RCS) with per-weapon scaling
- Assisted recoil compensation

### Triggerbot
- Automatic fire when crosshair is on target
- Customizable delay and hitchance
- Head only option
- Scope requirement for snipers
- Activation modes (Always, Hold, Toggle)

### Visuals

#### Player ESP
- Name ESP with custom fonts (Pixel, Skynight, Banita, Mamboe, Dispol, Galber, Santa, WonderKids)
- Bounding Box with multiple styles (Normal, Corners, Corners Animated, Glow, Segmented, 3D, Dashed Neon, Chamfer)
- Health Bar with styles (Classic, Gradient, Modern) and text option
- Weapon Name and Icon ESP
- Skeleton ESP
- Off-screen (OOF) Arrows
- Glow effect
- Flags (Money, Armor, Kit, Scoped, Defusing, Latency)

#### Chams (Colored Models)
- Enemy Visible/Invisible Chams
- On Shot Chams
- Backtrack Chams
- Local Player Chams
- Viewmodel Weapon Chams
- Dropped Weapon Chams
- C4 Chams
- Materials: Latex, Bloom, Glow, Solid, Xray, Spectrum, Glitch, Clown

#### World Visuals
- Grenade Prediction with line styles (Glow, Dashed, Rainbow, Beam, Dotted)
- Molotov/Inferno area visualization
- World color modulation (Lighting, Sun, Clouds, Sky)
- Exposure adjustment
- Snow weather effect
- Local bullet tracers
- World and 2D Hitmarkers

#### Local Visuals
- Third Person
- Remove Scope overlay
- Remove Flash
- Remove Smoke
- World FOV and Viewmodel FOV
- Penetration Crosshair with damage display

### Skins
- Full inventory browser
- Knife changer
- Glove changer
- Weapon skin changer
- Sticker support

### Misc

#### Movement
- Bunny Hop (Assist/Full modes)
- Auto Duck
- Jump Bug
- Air Strafe (Simple, Aggressive, Exploit)
- Subtick Strafer
- Quick Stop
- Edge Jump (keybind)
- Edge Bug (keybind)
- Fake Duck (keybind)

#### Utility
- Auto Accept Match
- Auto Pistol
- Auto Knife
- Auto Zeus
- Distant Scout sound
- Gameplay recoil modes (Off, View only, Full)
- Hit Sound with volume control (Metallic, Light, Coin, Money, Whack)
- Toxic Chat (On Kill)
- Vote Kick Tracker

#### Autobuy
- Primary weapon selection
- Secondary weapon selection
- Additional items (Armor, Taser, Grenades, Defuser)

#### Overlay
- Indicators
- Spectators list
- Watermark
- Radar with customizable range and options
- Grenade Panel
- Scoreboard overlay
- Hit Logs
- Team Damage Indicator

#### Models
- Custom player model support
- Load custom models from game folder

### Lua Scripting
- Full Lua API support
- Custom script loading
- OnPaint callbacks

### Menu
- Modern dark theme with accent color customization
- Darken background option
- Flying logos animation
- Global search (Ctrl+F)
- Keyboard navigation (1-7 for tabs, arrow keys)
- Config system (Local and Public configs)
- Built-in Radio player

---

## 📥 Installation

1. Download `ReevLoader.exe`
2. Launch CS2
3. Run `ReevLoader.exe`
4. Press `INSERT` to open the menu

---

## ⌨️ Default Keybinds

| Key | Action |
|-----|--------|
| `INSERT` | Toggle Menu |
| `~` | Panic Key (Unload) |
| `1-7` | Quick tab switch |
| `Ctrl+F` | Global search |

---

## 📁 Github File Structure

```
Reev-Cheese/
├── ReevLoader.exe      # Injector
├── reev_release.dll    # Main DLL
├── configs/            # Config files
├── fonts/              # Custom fonts
└── particles/          # Particle effects
```

---

## ⚠️ Disclaimer

This software is for educational purposes only. Use at your own risk. The developers are not responsible for any bans or consequences resulting from the use of this software.

---

## 📝 Changelog

See [changelog.txt](changelog.txt) for the latest updates.

---

## 💬 Support

For support and updates, join our community.
https://discord.gg/zmBjcWhu5r

---

*Last updated: January 2026*
