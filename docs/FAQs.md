[< Back to main page](https://github.com/jimbob4000/RetroFlow-Launcher)
<br><br>

# FAQ's

### My Adrenaline games aren't working?
If Adrenaline games aren't launching, please install [AdrBubbleBooterInstaller](https://vitadb.rinnegatamante.it/#/info/307). <br>
Or try installing [Adrenaline Bubble Manager](https://github.com/ONElua/AdrenalineBubbleManager/releases).

### Missing artwork - How should I name my games so covers are found?
It's recommended that your roms are named using the **no-intro** file naming convention, e.g. "Game Name (USA)", these names are used to match with cover images.

### How do I add disk based games?
 * PC Engine CD and TurboGrafx-CD - RetroFlow will look for '.cue' files for these CD systems. Please make sure all the games are loose with the system's rom folder with .cue files.
 * Dreamcast - '.gdi' and '.cdi' games are supported.
 * PS1 using RetroArch - They will use the 'PCSX ReARMed' core, more information on supported extensions here: [https://docs.libretro.com/library/pcsx_rearmed/](https://docs.libretro.com/library/pcsx_rearmed/)

### PS1 and RetroArch, how do I set it up?
RetroArch Playstation 1 games use the 'PCSX ReARMed' core, more information on supported extensions and setup see here: [https://docs.libretro.com/library/pcsx_rearmed/](https://docs.libretro.com/library/pcsx_rearmed/)

### Can I set RetroFlow to launch when the Vita boots up?

If you want to auto-launch **RetroFlow Launcher** every time your PS Vita boots up you can use the [**AutoBoot**](https://vitadb.rinnegatamante.it/#/info/261) plugin by Rinnegatamante. Please be careful using this app, use at your own risk.

### Some systems aren't showing?
Empty collections are hidden by default, once you add some games into the roms folder, they will appear.

### Can I change a core for RetroArch?
The cores have been set by system and cannot be changed on a game-by-game basis at the moment.

To change the core for an entire system, search for "Retroarch Cores" in the file below and edit the core file names accordingly. `ux0:/app/RETROFLOW/index.lua`

The RetroArch core files can be found here: `ux0:/app/RETROVITA/`

### Can I change the rom folder locations?
Yes, from version 4.0 onwards.
Go to 'Scan settings' and then 'Edit game directories' to change the path to game folders.

### Can I use HexFlow too?
Yes; RetroFlow is seperate, it uses different folders and a different title ID.

### Do I need to create bubbles for games?
No; RetroFlow doesn't need bubbles for games.

### Can I change the Mega Drive name to Genesis?
Sure; changing your language to 'English - American' will change the 'Mega Drive' name and logo to 'Genesis'.

<br>

[< Back to main page](https://github.com/jimbob4000/RetroFlow-Launcher)
