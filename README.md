
# RetroFlow Launcher

[![](https://github.com/jimbob4000/RetroFlow-Launcher/raw/main/Media/main_screen.png "main_screen")](https://github.com/jimbob4000/RetroFlow-Launcher/blob/main/Media/main_screen.png)

<!--- **Project archived:** RetroFlow is no longer in active development. --->

## About
This is a modded version of [HexFlow Launcher](https://github.com/VitaHEX-Games/HexFlow-Launcher); a 3d coverflow like launcher for PS Vita. 

With RetroFlow you can also integerate retro games without the need to create bubbles for Adrenaline, RetroArch, DaedalusX64 and Flycast.

**Main features added since forking from HexFlow:**

* No need to create bubbles for games
* Retro game categories added
* Favourite games category 
* Recently played category
* Ability to search for games
* Ability to rename games
* Support for game backgrounds images
* Support for multiple music tracks
* Support for multiple wallapers
* Load from cache for faster startup
* File browser added for setting up game directories
* Fully translated

**Supported systems:**
PS Vita, PSP, Playstation, Nintendo 64, Super Nintendo, Nintendo Entertainment System, Game Boy Advance, Game Boy Color, Game Boy, Sega Dreamcast, Sega CD, Sega 32X, Sega Mega Drive / Genesis, Sega Master System, Sega Game Gear, PC Engine, PC Engine CD, TurboGrafx-16, TurboGrafx-CD, Commodore Amiga, Commodore 64, WonderSwan, WonderSwan Color, MSX, MSX2, ZX Spectrum, Atari Lynx, Atari 600, Atari 5200, Atari 7800, ColecoVision, Vectrex, FBA 2012, MAME 2003 Plus, MAME 2000, Neo Geo (FBA 2012) and Neo Geo Pocket Color.


# Installation

## 1. Install the RetroFlow VPK's.

* Install the [latest version of RetroFlow](https://github.com/jimbob4000/RetroFlow-Launcher/releases) 
* Also install the 'RetroFlow Adrenaline launcher' VPK from the [latest version of RetroFlow](https://github.com/jimbob4000/RetroFlow-Launcher/releases).
* 'RetroFlow Launcher' is the app you will use to browse games. 'RetroFlow Adrenaline launcher' is needed for launching Playstation and PSP games.

## 2. Install any other necessary apps
* [Adrenaline](https://github.com/TheOfficialFloW/Adrenaline) is required for Playstation and PSP games.
* [DaedalusX64](https://github.com/Rinnegatamante/DaedalusX64-vitaGL/releases) is required for N64 games. 
* [RetroArch](https://www.retroarch.com/index.php?page=platforms) is required for other retro systems.  
* [Flycast](https://www.psx-place.com/threads/release-flycast-vita-v-1-0-3-sega-dreamcast-emulator-for-psvita-pstv.38180/) is required to play Dreamcast games. Also see the [compatability list](https://newflycast.rinnegatamante.it/)  as not all games are playable yet.
* **Important:** If Adrenaline games aren't launching after you have finished the setup, please install [AdrBubbleBooterInstaller](https://vitadb.rinnegatamante.it/#/info/307). Or try installing [Adrenaline Bubble Manager](https://github.com/ONElua/AdrenalineBubbleManager/releases).


## 3. Check your PS1 and PSP are in the right Adrenaline folders


* PS1 and PSP games with eboot files should be saved here: `ux0:pspemu/PSP/GAME/`
* PSP ISO and CSO games should be saved here: `ux0:pspemu/ISO/`
* uma0, ur0, imc0 and xmc0 partitions are also supported.
* **Tip:** PS1 games can also be launched using RetroArch, helpful for games which don't run well in Adrenaline.

## 4. Add your retro games to RetroFlow

For best results it's recommended that your games are named using the **no-intro** file naming convention, e.g. "Game Name (USA)", these names are used to download matching cover images.

#### Option 1 - Use the default folders

* Launch RetroFlow for the first time, RetroFlow will create the folders where you can save your games.
* Once it's finshed loading; close RetroFlow and copy or move your favourite retro games into the relevant game subfolders here: `ux0:/data/RetroFlow/ROMS/`

#### Option 2 - Use your own  game folders

* If you don't want to save your games in the RetroFlow data folder, you can use your own directories.
* Go to 'Scan settings' and then 'Edit game directories' to change the path to game folders.
* Once you are done, select 'Rescan' to find the games.

#### Disc based games

 * PC Engine CD and TurboGrafx-CD: RetroFlow will look for '.cue' files for these CD systems. Please make sure all the games are loose with the system's rom folder with .cue files.
 * Dreamcast:  '.gdi' and '.cdi' games are supported.
 * PS1 using RetroArch - They will use the 'PCSX ReARMed' core, more information on supported extensions here: [https://docs.libretro.com/library/pcsx_rearmed/](https://docs.libretro.com/library/pcsx_rearmed/)

**Note:** 
If you're using an old version of RetroFlow (below v5) you will need to rename PSP and maybe PS1 games too, please see the guide here: [Legacy guide - Renaming PSP and PSX](https://raw.githubusercontent.com/jimbob4000/RetroFlow-Launcher/main/docs/Legacy_guide_-_Renaming_PSP_and_PSX.md). 

## 5. Rescan to find your games

* Press 'Start' and go to 'Scan Settings', then select 'Rescan'
* Your retro games should now appear when you restart the app.
* 'Startup scan' can be turned off once you have finished adding your games, the app will startup faster when it's turned off.


## 6. Download covers & backgrounds

* To download cover images, press start, then choose which covers or backgrounds you would like to download.
* From version 5 onwards you can also extract background images for PSP games from PSP iso files.


# Controls

Navigate your library using the **DPad** or the **Left Stick** or with the **Touch Screen**.

**DPad Up**: Skip to favorites category

**R/L triggers**: Skip 5 items

**Cross**: Select/Launch game/app

**Square**: Change Category/Rename game

**Triangle**: Game Details/Add or remove favorites/About

**Circle**: Change View/Cancel

**Start**: Settings menu

**Select**: Search

**DPad Down + Square**: Go back one category

**DPad Down + L/R triggers**: Skip games alphabetically

# Customisation


## Adding Custom game covers & backgrounds

#### Covers:
* Custom covers can be saved in the game folders here: `ux0:/data/RetroFlow/COVERS/`.

#### Backgounds:
* Custom game backgrounds can be saved in the game folders here: `ux0:/data/RetroFlow/BACKGROUNDS/`.

#### Filenames:
* For Vita, PSP, PSX games and Homebrew the The cover image file name must match the **Game ID** or the **Game Name** of each app. 
* For retro games the cover image name should match the **Game Name** i.e. "Game Name (USA).png".

#### Image format:
* Cover and background images must be in **png** format. 


## Adding Custom wallpaper & music

#### Wallpaper:
* You can add as many wallpapers as you like by saving them here: `ux0:/data/RetroFlow/WALLPAPER/`. 
* Images must be in .jpg or .png format, the recommended size is 960px x 544px. 
* Some custom backgrounds are available [HERE](https://github.com/andiweli/hexflow-covers/tree/main/Backgrounds)
You can change your background within the app by going to the settings menu > theme > custom background.

#### Custom  Music:
* Songs can be added to `ux0:/data/RetroFlow/MUSIC/`. 
* Music must be in **.ogg** format.



# Possible incompatabilities

**Repatch**
Potential issue with repatch / repatch_4 plugins in the tai config. May cause the Vita to shutdown. Try disabling these if you encounter an issue.

**PSP Categories lite**
This PSP plugin is unsupported, if you're experiencing please try without the plugin.


# Credits

* Original [HexFlow](https://github.com/VitaHEX-Games/HexFlow-Launcher) app by: VitaHex Games.
* Programming/UI: Sakis RG.
* Developed with [Lua Player Plus](http://rinnegatamante.github.io/lpp-vita/) by Rinnegatamante.
* Scanning PSP and PSX games made possible by using [ONELua](http://onelua.x10.mx/) by Team ONElua.
* Aurora wallaper: Photo by [Maria Vojtovicova](https://unsplash.com/@maripopeo).


### Special thanks

* Creckeryop
* andiweli: [HEXFlow Covers database](https://github.com/andiweli/hexflow-covers)
* DRok17: for his work on bubble builders.
* Rinnegatamante: for tips and support with Lua.  
* Leecherman: for his work on AdrBubbleBooter and the [PSP ISO Renamer](https://sites.google.com/site/theleecherman/PSPISORenamer)
* BlackSheepBoy69: for sharing tips and code from [HexFlow Launcher Unofficial Custom](https://github.com/BlackSheepBoy69/HexFlow-Launcher-Unofficial-Custom)

#### Translations

* French - @chronoss
* German - @stuermerandreas
* Spanish - @kodyna91
* Italian - @TheheroGAC
* Russian - @\_novff
* Portuguese - @nighto
* Japanese - @iGlitch
* Chinese - @acd13141
* Polish - @SK00RUPA



# Support

**Help and FAQ's:**
For Help and answers to frequent questions please visit the [FAQ's](https://raw.githubusercontent.com/jimbob4000/RetroFlow-Launcher/main/docs/FAQs.md) page.

**Feature requests:** 
Please note that I'm not a developer, this mod started as a personal project, please be mindful that there may be some redundant code, or some requests that will be beyond my knowledge to implement.
Please feel free to build upon the mod as long as you provide credit to the original HexFlow developer and the people who contributed to the project.

**Supporting developers:** 
I don't accept dontations or payment for this project, however if you would like to support VitaHex; the developer of the original HexFlow app you can support their work by becoming a [Patron](https://www.patreon.com/vitahex).

You can also donate to them using [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RM8ECMVYMTXGJ&source=url). If you would like to follow them, you can find VitaHex on [Twitter](https://twitter.com/VitaHex), or their website [vitahex.weebly.com](https://vitahex.weebly.com/).
