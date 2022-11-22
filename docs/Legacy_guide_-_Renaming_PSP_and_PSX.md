[< Back to main page](https://github.com/jimbob4000/RetroFlow-Launcher)
<br><br>

#Legacy guide for naming PSP and PS1 games

###For RetroFlow versions below v5
RetroFlow uses the game ID's for Playstation and PSP for cover matching.
Please use the guides below.



## Playstation games

### PS1 using Adrenaline
For PSX2PSP, game folder name must match with the GameID. For example:

    ux0:pspemu/PSP/GAME/**SLES01234**

Games will need to be in a EBOOT format, see here for information on [how to convert PSX Disc Images to EBOOT for PSP](https://www.cfwaifu.com/psx2psp/).
RetroFlow also uses the ID to lookup the name of the game.

## PSP games

Renaming PSP games is necessary for cover matching. RetroFlow will look for a title ID in the filename. Follow the guides below to rename, or use the latest version of RetroFlow to avoid the entire process.

Games can be named with just the title ID like so: "UCUS98766.iso" but this isn't recommended. We recommend renaming games using the tools below.

### Windows users

Please rename PSP ISO and CSO files using Leecherman's [PSP ISO Renamer tool](https://sites.google.com/site/theleecherman/PSPISORenamer) using the following parameters:

    %NAME% (%REGION%) [%ID%]

The result should look like this (please notice the square brackets):

    Cars 2 (US) [UCUS-98766].iso




### Mac users
You can use the [UMD FileRenamer app here](https://github.com/BrosMakingSoftware/UMD_FileRenamer/releases/tag/v1.0).

Step 1. Download the UMD FileRenamer app above
Open the 'UMD_FileRenamer-1.0.jar' file and select your folder of games, then rename.

Step 2. Replace (parenthesis) with [brackets]
In the finder, select all the games, right click and select 'rename items'.
Replace the opening and closing parenthesis with square brackets instead.

    Name (XXXX-XXXXX).iso

Will be renamed to:

    Name [XXXX-XXXXX].iso

The game names will be missing the region code, but it's not required for the RetroFlow to work.


<br>

[< Back to main page](https://github.com/jimbob4000/RetroFlow-Launcher)