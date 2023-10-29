# FAQ's

<br>

**Topics:**

* [Adrenaline - My games aren't working?](#adrenaline---my-games-arent-working)
* [Adrenaline opens then closes without loading the game?](#adrenaline-opens-then-closes-without-loading-the-game)
* [RetroArch fails to load games with "&" symbol in the game name](#retroarch-fails-to-load-games-with--symbol-in-the-game-name)
* [PICO-8 games won't launch](#pico-8-games-wont-launch)
* [ScummVM some games won't launch](#scummvm-some-games-wont-launch)
* [Atari 5200 loads the memopad in RetroArch?](#atari-5200-loads-the-memopad-in-retroarch)
* [Missing artwork - How should I name my games so covers are found?](#missing-artwork---how-should-i-name-my-games-so-covers-are-found)
* [Why is there no option to download homebrew covers?](#why-is-there-no-option-to-download-homebrew-covers)
* [How do I add disk based games?](#how-do-i-add-disk-based-games)
* [PS1 and RetroArch, how do I set it up?](#ps1-and-retroarch-how-do-i-set-it-up)
* [Can I set RetroFlow to launch when the Vita boots up?](#can-i-set-retroflow-to-launch-when-the-vita-boots-up)
* [Some systems aren't showing?](#some-systems-arent-showing)
* [Can I change a core for RetroArch?](#can-i-change-a-core-for-retroarch)
* [Can I change the game folder locations?](#can-i-change-the-game-folder-locations)
* [Can I use HexFlow too?](#can-i-use-hexflow-too)
* [Do I need to create bubbles for games?](#do-i-need-to-create-bubbles-for-games)
* [Can I change the Mega Drive name to Genesis?](#can-i-change-the-mega-drive-name-to-genesis)
<br><br>

### Adrenaline - My games aren't working?
 * If Adrenaline games aren't launching, please install [Adrenaline Bubble Manager](https://github.com/ONElua/AdrenalineBubbleManager/releases). <br>
Or try installing [AdrBubbleBooterInstaller](https://vitadb.rinnegatamante.it/#/info/307).
 * Check you have installed the 'RetroFlow Adrenaline Launcher' and that Adrenaline is functioning okay outside of RetroFlow.
<br><br>

### Adrenaline opens then closes without loading the game?
Behaviour: Adrenaline opens and then closes without loading the game (returning you to the livearea).

This is a known issue with Adrenaline, called the 'double launch bug'. This can be easily fixed by following the guide here: [https://github.com/TheOfficialFloW/Adrenaline#getting-rid-of-double-launch-bug](https://github.com/TheOfficialFloW/Adrenaline#getting-rid-of-double-launch-bug)
<br><br>

### RetroArch fails to load games with "&" symbol in the game name
This appears to be an issue with RetroArch version 1.11 onward, try installing an [older version](https://buildbot.libretro.com/stable/) of RetroArch until the issue is resolved.
<br><br>
### PICO-8 games won't launch
Support for launchers was added after July 5, 2021. Please try a more current version of [FAKE-08](https://github.com/jtothebell/fake-08/releases). 
<br><br>
### ScummVM some games won't launch
I found some games don't launch on ScummVM version 2.7.0, please try a previous version such as 2.6.1. Direct download link: [https://downloads.scummvm.org/frs/scummvm/2.6.1/scummvm-2.6.1-vita.vpk](https://downloads.scummvm.org/frs/scummvm/2.6.1/scummvm-2.6.1-vita.vpk).
<br><br>
### Atari 5200 loads the memopad in RetroArch?
When the game is running in RetroArch bring up the RetroArch quick menu.

Go to 'Options > Atari System' and selected 5200.
Then go back one level and select 'Overrides > Save core overrides'.

The games should work provided you have everything else setup.
<br><br>

### Missing artwork - How should I name my games so covers are found?
It's recommended that your roms are named using the **no-intro** file naming convention, e.g. "Game Name (USA)", these names are used to match with cover images.
<br><br>

### Why is there no option to download homebrew covers?
Covers haven't been made for homebrew applications as it's not necessary as the app icon is used. 

If you move a homebrew game port into the Vita category you can download a cover if it's available. Vita style covers for homebrew applications won't be added, but you can always add your own.
<br><br>

### How do I add disk based games?
 * PC Engine CD and TurboGrafx-CD - RetroFlow will look for '.cue' files for these CD systems. Please make sure all the games are loose with the system's game folder with .cue files.
 * Dreamcast - '.gdi' and '.cdi' games are supported.
 * PS1 using RetroArch - They will use the 'PCSX ReARMed' core, more information on supported extensions here: [https://docs.libretro.com/library/pcsx_rearmed/](https://docs.libretro.com/library/pcsx_rearmed/)
<br><br>

### PS1 and RetroArch, how do I set it up?
RetroArch Playstation 1 games use the 'PCSX ReARMed' core, more information on supported extensions and setup see here: [https://docs.libretro.com/library/pcsx_rearmed/](https://docs.libretro.com/library/pcsx_rearmed/)
<br><br>

### Can I set RetroFlow to launch when the Vita boots up?
If you want to auto-launch **RetroFlow Launcher** every time your PS Vita boots up you can use the [**AutoBoot**](https://vitadb.rinnegatamante.it/#/info/261) plugin by Rinnegatamante. Please be careful using this app, use at your own risk. The title ID for RetroFlow is "RETROFLOW".
<br><br>

### Some systems aren't showing?
Empty collections are hidden by default, once you add some games into the game's folder, they will appear.
<br><br>

### Can I change a core for RetroArch?
The cores have been set by system and cannot be changed on a game-by-game basis.

To change the core for an entire system, search for "Retroarch Cores" in the file below and edit the core file names accordingly. `ux0:/app/RETROFLOW/index.lua`

The RetroArch core files can be found here: `ux0:/app/RETROVITA/`
<br><br>

### Can I change the rom folder locations?
Yes, from version 4.0 onwards.
Go to 'Scan settings' and then 'Edit game directories' to change the path to rom folders.
<br><br>

### Can I use HexFlow too?
Yes; RetroFlow is separate, it uses different folders and a different title ID.
<br><br>

### Do I need to create bubbles for games?
No; RetroFlow doesn't need bubbles for games.
<br><br>

### Can I change the Mega Drive name to Genesis?
Sure; changing your language to 'English - American' will change the 'Mega Drive' name and logo to 'Genesis'.
<br><br>

[< Back to main page](https://github.com/jimbob4000/RetroFlow-Launcher)
