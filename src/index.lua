-- RetroFlow Launcher - HexFlow Mod version by jimbob4000
-- Based on HexFlow Launcher  version 0.5 by VitaHEX
-- https://www.patreon.com/vitahex

local oneLoopTimer = Timer.new()

dofile("app0:addons/threads.lua")
local working_dir = "ux0:/app"
local appversion = "5.1.2"
function System.currentDirectory(dir)
    if dir == nil then
        return working_dir
    else
        working_dir = dir
    end
end

loading_tasks = 0
loading_progress = 0

local loadingImage = Graphics.loadImage("app0:DATA/loading.png")

local romsMainDir = "ux0:/data/RetroFlow/ROMS/"
local covDir = "ux0:/data/RetroFlow/COVERS/"
local snapDir = "ux0:/data/RetroFlow/BACKGROUNDS/"

-- Tidy up legacy COVER folder structure to a more standard naming convention
if System.doesDirExist("ux0:/data/RetroFlow/COVERS/MAME") then System.rename("ux0:/data/RetroFlow/COVERS/MAME", "ux0:/data/RetroFlow/COVERS/MAME 2000") end
if System.doesDirExist("ux0:/data/RetroFlow/ROMS/MAME 2000") then System.rename("ux0:/data/RetroFlow/ROMS/MAME 2000", "ux0:/data/RetroFlow/ROMS/MAME 2000") end

-- Default system rom folders
romDir_Default =
{
["Atari_2600"] = "ux0:/data/RetroFlow/ROMS/Atari - 2600",
["Atari_5200"] = "ux0:/data/RetroFlow/ROMS/Atari - 5200",
["Atari_7800"] = "ux0:/data/RetroFlow/ROMS/Atari - 7800",
["Atari_Lynx"] = "ux0:/data/RetroFlow/ROMS/Atari - Lynx",
["WonderSwan"] = "ux0:/data/RetroFlow/ROMS/Bandai - WonderSwan",
["WonderSwan_Color"] = "ux0:/data/RetroFlow/ROMS/Bandai - WonderSwan Color",
["ColecoVision"] = "ux0:/data/RetroFlow/ROMS/Coleco - ColecoVision",
["Commodore_64"] = "ux0:/data/RetroFlow/ROMS/Commodore - 64",
["Amiga"] = "ux0:/data/RetroFlow/ROMS/Commodore - Amiga",
["FBA_2012"] = "ux0:/data/RetroFlow/ROMS/FBA 2012",
["Vectrex"] = "ux0:/data/RetroFlow/ROMS/GCE - Vectrex",
["MAME_2000"] = "ux0:/data/RetroFlow/ROMS/MAME 2000",
["MAME_2003Plus"] = "ux0:/data/RetroFlow/ROMS/MAME 2003 Plus",
["MSX"] = "ux0:/data/RetroFlow/ROMS/Microsoft - MSX",
["MSX2"] = "ux0:/data/RetroFlow/ROMS/Microsoft - MSX2",
["PC_Engine"] = "ux0:/data/RetroFlow/ROMS/NEC - PC Engine",
["PC_Engine_CD"] = "ux0:/data/RetroFlow/ROMS/NEC - PC Engine CD",
["TurboGrafx_16"] = "ux0:/data/RetroFlow/ROMS/NEC - TurboGrafx 16",
["TurboGrafx_CD"] = "ux0:/data/RetroFlow/ROMS/NEC - TurboGrafx CD",
["Game_Boy"] = "ux0:/data/RetroFlow/ROMS/Nintendo - Game Boy",
["Game_Boy_Advance"] = "ux0:/data/RetroFlow/ROMS/Nintendo - Game Boy Advance",
["Game_Boy_Color"] = "ux0:/data/RetroFlow/ROMS/Nintendo - Game Boy Color",
["Nintendo_64"] = "ux0:/data/RetroFlow/ROMS/Nintendo - Nintendo 64",
["Nintendo_Entertainment_System"] = "ux0:/data/RetroFlow/ROMS/Nintendo - Nintendo Entertainment System",
["Super_Nintendo"] = "ux0:/data/RetroFlow/ROMS/Nintendo - Super Nintendo Entertainment System",
["Sega_32X"] = "ux0:/data/RetroFlow/ROMS/Sega - 32X",
["Sega_Dreamcast"] = "ux0:/data/RetroFlow/ROMS/Sega - Dreamcast",
["Sega_Game_Gear"] = "ux0:/data/RetroFlow/ROMS/Sega - Game Gear",
["Sega_Master_System"] = "ux0:/data/RetroFlow/ROMS/Sega - Master System - Mark III",
["Sega_Mega_Drive"] = "ux0:/data/RetroFlow/ROMS/Sega - Mega Drive - Genesis",
["Sega_CD"] = "ux0:/data/RetroFlow/ROMS/Sega - Mega-CD - Sega CD",
["ZX_Spectrum"] = "ux0:/data/RetroFlow/ROMS/Sinclair - ZX Spectrum",
["Neo_Geo"] = "ux0:/data/RetroFlow/ROMS/SNK - Neo Geo - FBA 2012",
["Neo_Geo_Pocket_Color"] = "ux0:/data/RetroFlow/ROMS/SNK - Neo Geo Pocket Color",
["PlayStation"] = "ux0:/data/RetroFlow/ROMS/Sony - PlayStation - RetroArch",

}

adr_partition_table =
{
[1] = "ux0",
[2] = "ur0",
[3] = "imc0",
[4] = "xmc0",
[5] = "uma0",
}

-- Create directory: Main
local cur_dir = "ux0:/data/RetroFlow/"
System.createDirectory("ux0:/data/RetroFlow/")

function print_table_rom_dirs(def_table_name)
    dofile("app0:addons/printTable.lua")
    print_table_rom_dirs((def_table_name))
end

-- Create directory: Roms
System.createDirectory(romsMainDir)

-- Create default rom sub folders
for k, v in pairs(romDir_Default) do
    System.createDirectory(tostring(v))
end

-- Save a copy of the default locations to an lua file so it can be customised later
if not System.doesFileExist("ux0:/data/RetroFlow/rom_directories.lua") then
    print_table_rom_dirs(romDir_Default)
end

if System.doesFileExist("ux0:/data/RetroFlow/rom_directories.lua") then
    -- File exists, import user rom dirs
    db_romdir = "ux0:/data/RetroFlow/rom_directories.lua"
    romUserDir = {}
    romUserDir = dofile(db_romdir)

    -- File not empty
    if romUserDir ~= nil then 
        -- Legacy fix, if playstation retroarch missing, use default
        if romUserDir.PlayStation == nil then
            romUserDir.PlayStation = "ux0:/data/RetroFlow/ROMS/Sony - PlayStation - RetroArch"
        end
    -- File empty, use defaults
    else
        romUserDir = {}
        romUserDir = romDir_Default
    end

else
    -- File not found, use default rom dirs
    romUserDir = {}
    romUserDir = romDir_Default
end



SystemsToScan =
{
    [1] = 
    {
        ["apptype"] = 1,
        ["table"] = "games_table",
        ["user_db_file"] = "db_games.lua",
        -- ["romFolder"] = "",
        ["localCoverPath"] = covDir .. "Sony - PlayStation Vita" .. "/",
        ["localSnapPath"] = snapDir .. "Sony - PlayStation Vita" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PSVita/",
        ["onlineSnapPathSystem"] = "",
        ["Missing_Cover"] = "missing_cover_psv.png",
    },
    [2] = 
    {
        ["apptype"] = 0,
        ["table"] = "homebrews_table",
        ["user_db_file"] = "db_homebrews.lua",
        -- ["romFolder"] = "",
        ["localCoverPath"] = covDir .. "Homebrew" .. "/",
        ["localSnapPath"] = snapDir .. "Homebrew" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/HOMEBREW/",
        ["onlineSnapPathSystem"] = "",
        ["Missing_Cover"] = "missing_cover_homebrew.png",
    },
    [3] = 
    {
        ["apptype"] = 2,
        ["table"] = "psp_table",
        ["user_db_file"] = "db_psp.lua",
        -- ["romFolder"] = "",
        ["localCoverPath"] = covDir .. "Sony - PlayStation Portable" .. "/",
        ["localSnapPath"] = snapDir .. "Sony - PlayStation Portable" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PSP/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/PSP/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_psp.png",
    },
    [4] = 
    {
        ["apptype"] = 3,
        ["table"] = "psx_table",
        ["user_db_file"] = "db_psx.lua",
        ["romFolder"] = romUserDir.PlayStation,
        ["localCoverPath"] = covDir .. "Sony - PlayStation" .. "/",
        ["localSnapPath"] = snapDir .. "Sony - PlayStation" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PS1/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/PS1/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_psx.png",
    },
    [5] = 
    {
        ["apptype"] = 5,
        ["table"] = "n64_table",
        ["user_db_file"] = "db_n64.lua",
        ["romFolder"] = romUserDir.Nintendo_64,
        ["localCoverPath"] = covDir .. "Nintendo - Nintendo 64" .. "/",
        ["localSnapPath"] = snapDir .. "Nintendo - Nintendo 64" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/N64/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Nintendo_-_Nintendo_64/ec7430189022b591a8fb0fa16101201f861363f8/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_n64.png",
    },
    [6] = 
    {
        ["apptype"] = 6,
        ["table"] = "snes_table",
        ["user_db_file"] = "db_snes.lua",
        ["romFolder"] = romUserDir.Super_Nintendo,
        ["localCoverPath"] = covDir .. "Nintendo - Super Nintendo Entertainment System" .. "/",
        ["localSnapPath"] = snapDir .. "Nintendo - Super Nintendo Entertainment System" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/SNES/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Nintendo_-_Super_Nintendo_Entertainment_System/5c469e48755fec26b4b9d651b6962a2cdea3133d/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_snes.png",
    },
    [7] = 
    {
        ["apptype"] = 7,
        ["table"] = "nes_table",
        ["user_db_file"] = "db_nes.lua",
        ["romFolder"] = romUserDir.Nintendo_Entertainment_System,
        ["localCoverPath"] = covDir .. "Nintendo - Nintendo Entertainment System" .. "/",
        ["localSnapPath"] = snapDir .. "Nintendo - Nintendo Entertainment System" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/NES/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Nintendo_-_Nintendo_Entertainment_System/f4415b21a256bcbe7b30a9d71a571d6ba4815c71/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_nes.png",
    },
    [8] = 
    {
        ["apptype"] = 8,
        ["table"] = "gba_table",
        ["user_db_file"] = "db_gba.lua",
        ["romFolder"] = romUserDir.Game_Boy_Advance,
        ["localCoverPath"] = covDir .. "Nintendo - Game Boy Advance" .. "/",
        ["localSnapPath"] = snapDir .. "Nintendo - Game Boy Advance" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GBA/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Nintendo_-_Game_Boy_Advance/fd58a8fae1cec5857393c0405c3d0514c7fdf6cf/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_gba.png",
    },
    [9] = 
    {
        ["apptype"] = 9,
        ["table"] = "gbc_table",
        ["user_db_file"] = "db_gbc.lua",
        ["romFolder"] = romUserDir.Game_Boy_Color,
        ["localCoverPath"] = covDir .. "Nintendo - Game Boy Color" .. "/",
        ["localSnapPath"] = snapDir .. "Nintendo - Game Boy Color" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GBC/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Nintendo_-_Game_Boy_Color/a0cc546d2b4e2eebefdcf91b90ae3601c377c3ce/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_gbc.png",
    },
    [10] = 
    {
        ["apptype"] = 10,
        ["table"] = "gb_table",
        ["user_db_file"] = "db_gb.lua",
        ["romFolder"] = romUserDir.Game_Boy,
        ["localCoverPath"] = covDir .. "Nintendo - Game Boy" .. "/",
        ["localSnapPath"] = snapDir .. "Nintendo - Game Boy" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GB/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Nintendo_-_Game_Boy/d5ad94ba8c5159381d7f618ec987e609d23ae203/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_gb.png",
    },
    [11] = 
    {
        ["apptype"] = 11,
        ["table"] = "dreamcast_table",
        ["user_db_file"] = "db_dreamcast.lua",
        ["romFolder"] = romUserDir.Sega_Dreamcast,
        ["localCoverPath"] = covDir .. "Sega - Dreamcast" .. "/",
        ["localSnapPath"] = snapDir .. "Sega - Dreamcast" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/DC/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/DC/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_dreamcast_eur.png",
    },
    [12] = 
    {
        ["apptype"] = 12,
        ["table"] = "sega_cd_table",
        ["user_db_file"] = "db_sega_cd.lua",
        ["romFolder"] = romUserDir.Sega_CD,
        ["localCoverPath"] = covDir .. "Sega - Mega-CD - Sega CD" .. "/",
        ["localSnapPath"] = snapDir .. "Sega - Mega-CD - Sega CD" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/SEGA_CD/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Sega_-_Mega-CD_-_Sega_CD/a8737a2a394645f27415f7346ac2ceb0cfcd0942/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_sega_cd.png",
    },
    [13] = 
    {
        ["apptype"] = 13,
        ["table"] = "s32x_table",
        ["user_db_file"] = "db_32x.lua",
        ["romFolder"] = romUserDir.Sega_32X,
        ["localCoverPath"] = covDir .. "Sega - 32X" .. "/",
        ["localSnapPath"] = snapDir .. "Sega - 32X" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/32X/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Sega_-_32X/4deb45e651e29506a7bfc440408b3343f0e1a3ae/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_32x.png",
    },
    [14] = 
    {
        ["apptype"] = 14,
        ["table"] = "md_table",
        ["user_db_file"] = "db_md.lua",
        ["romFolder"] = romUserDir.Sega_Mega_Drive,
        ["localCoverPath"] = covDir .. "Sega - Mega Drive - Genesis" .. "/",
        ["localSnapPath"] = snapDir .. "Sega - Mega Drive - Genesis" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MD/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Sega_-_Mega_Drive_-_Genesis/6ac232741f979a6f0aa54d077ff392fe170f4725/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_md.png",
    },
    [15] = 
    {
        ["apptype"] = 15,
        ["table"] = "sms_table",
        ["user_db_file"] = "db_sms.lua",
        ["romFolder"] = romUserDir.Sega_Master_System,
        ["localCoverPath"] = covDir .. "Sega - Master System - Mark III" .. "/",
        ["localSnapPath"] = snapDir .. "Sega - Master System - Mark III" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/SMS/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Sega_-_Master_System_-_Mark_III/02f8c7f989db6124475b7e0978c27af8534655eb/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_sms.png",
    },
    [16] = 
    {
        ["apptype"] = 16,
        ["table"] = "gg_table",
        ["user_db_file"] = "db_gg.lua",
        ["romFolder"] = romUserDir.Sega_Game_Gear,
        ["localCoverPath"] = covDir .. "Sega - Game Gear" .. "/",
        ["localSnapPath"] = snapDir .. "Sega - Game Gear" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GG/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Sega_-_Game_Gear/b99b424d2adcf5ccd45c372db2c15f01653f2b92/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_gg.png",
    },
    [17] = 
    {
        ["apptype"] = 17,
        ["table"] = "tg16_table",
        ["user_db_file"] = "db_tg16.lua",
        ["romFolder"] = romUserDir.TurboGrafx_16,
        ["localCoverPath"] = covDir .. "NEC - TurboGrafx 16" .. "/",
        ["localSnapPath"] = snapDir .. "NEC - TurboGrafx 16" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/TG16/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/NEC_-_PC_Engine_-_TurboGrafx_16/d0d6e27f84d757416799e432154e0adcadb154c9/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_tg16.png",
    },
    [18] = 
    {
        ["apptype"] = 18,
        ["table"] = "tgcd_table",
        ["user_db_file"] = "db_tgcd.lua",
        ["romFolder"] = romUserDir.TurboGrafx_CD,
        ["localCoverPath"] = covDir .. "NEC - TurboGrafx CD" .. "/",
        ["localSnapPath"] = snapDir .. "NEC - TurboGrafx CD" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/TG_CD/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/NEC_-_PC_Engine_CD_-_TurboGrafx-CD/cd554a5cdca862f090e6c3f9510a3b1b6c2d5b38/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_tgcd.png",
    },
    [19] = 
    {
        ["apptype"] = 19,
        ["table"] = "pce_table",
        ["user_db_file"] = "db_pce.lua",
        ["romFolder"] = romUserDir.PC_Engine,
        ["localCoverPath"] = covDir .. "NEC - PC Engine" .. "/",
        ["localSnapPath"] = snapDir .. "NEC - PC Engine" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/PCE/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/NEC_-_PC_Engine_-_TurboGrafx_16/d0d6e27f84d757416799e432154e0adcadb154c9/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_pce.png",
    },
    [20] = 
    {
        ["apptype"] = 20,
        ["table"] = "pcecd_table",
        ["user_db_file"] = "db_pcecd.lua",
        ["romFolder"] = romUserDir.PC_Engine_CD,
        ["localCoverPath"] = covDir .. "NEC - PC Engine CD" .. "/",
        ["localSnapPath"] = snapDir .. "NEC - PC Engine CD" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/PCE_CD/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/NEC_-_PC_Engine_CD_-_TurboGrafx-CD/cd554a5cdca862f090e6c3f9510a3b1b6c2d5b38/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_pcecd.png",
    },
    [21] = 
    {
        ["apptype"] = 21,
        ["table"] = "amiga_table",
        ["user_db_file"] = "db_amiga.lua",
        ["romFolder"] = romUserDir.Amiga,
        ["localCoverPath"] = covDir .. "Commodore - Amiga" .. "/",
        ["localSnapPath"] = snapDir .. "Commodore - Amiga" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/AMIGA/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Commodore_-_Amiga/b6446e83b3dc93446371a5dbfb0f24574eb56461/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_amiga.png",
    },
    [22] = 
    {
        ["apptype"] = 22,
        ["table"] = "c64_table",
        ["user_db_file"] = "db_c64.lua",
        ["romFolder"] = romUserDir.Commodore_64,
        ["localCoverPath"] = covDir .. "Commodore - 64" .. "/",
        ["localSnapPath"] = snapDir .. "Commodore - 64" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/C64/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Commodore_-_64/df90042ef9823d1b0b9d3ec303051f555dca2246/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_c64.png",
    },
    [23] = 
    {
        ["apptype"] = 23,
        ["table"] = "wswan_col_table",
        ["user_db_file"] = "db_wswan_col.lua",
        ["romFolder"] = romUserDir.WonderSwan_Color,
        ["localCoverPath"] = covDir .. "Bandai - WonderSwan Color" .. "/",
        ["localSnapPath"] = snapDir .. "Bandai - WonderSwan Color" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/WSWAN_COL/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Bandai_-_WonderSwan_Color/5b57a78fafa4acb8590444c15c116998fcea9dce/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_wswan_col.png",
    },
    [24] = 
    {
        ["apptype"] = 24,
        ["table"] = "wswan_table",
        ["user_db_file"] = "db_wswan.lua",
        ["romFolder"] = romUserDir.WonderSwan,
        ["localCoverPath"] = covDir .. "Bandai - WonderSwan" .. "/",
        ["localSnapPath"] = snapDir .. "Bandai - WonderSwan" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/WSWAN/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Bandai_-_WonderSwan/3913706e173ec5f8c0cdeebd225b16f4dc3dd6c6/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_wswan.png",
    },
    [25] = 
    {
        ["apptype"] = 25,
        ["table"] = "msx2_table",
        ["user_db_file"] = "db_msx2.lua",
        ["romFolder"] = romUserDir.MSX2,
        ["localCoverPath"] = covDir .. "Microsoft - MSX2" .. "/",
        ["localSnapPath"] = snapDir .. "Microsoft - MSX2" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MSX2/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Microsoft_-_MSX2/12d7e10728cc4c3314b8b14b5a9b1892a886d2ab/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_msx2.png",
    },
    [26] = 
    {
        ["apptype"] = 26,
        ["table"] = "msx1_table",
        ["user_db_file"] = "db_msx1.lua",
        ["romFolder"] = romUserDir.MSX,
        ["localCoverPath"] = covDir .. "Microsoft - MSX" .. "/",
        ["localSnapPath"] = snapDir .. "Microsoft - MSX" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MSX/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Microsoft_-_MSX/ed54675a51597fd5bf66a45318a273f330b7662f/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_msx1.png",
    },
    [27] = 
    {
        ["apptype"] = 27,
        ["table"] = "zxs_table",
        ["user_db_file"] = "db_zxs.lua",
        ["romFolder"] = romUserDir.ZX_Spectrum,
        ["localCoverPath"] = covDir .. "Sinclair - ZX Spectrum" .. "/",
        ["localSnapPath"] = snapDir .. "Sinclair - ZX Spectrum" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/ZXS/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Sinclair_-_ZX_Spectrum/d23c953dc9853983fb2fce2b8e96a1ccc08b70e8/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_zxs.png",
    },
    [28] = 
    {
        ["apptype"] = 28,
        ["table"] = "atari_7800_table",
        ["user_db_file"] = "db_atari_7800.lua",
        ["romFolder"] = romUserDir.Atari_7800,
        ["localCoverPath"] = covDir .. "Atari - 7800" .. "/",
        ["localSnapPath"] = snapDir .. "Atari - 7800" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/ATARI_7800/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Atari_-_7800/eff4d49a71a62764dd66d414b1bf7a843f85f7ae/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_atari_7800.png",
    },
    [29] = 
    {
        ["apptype"] = 29,
        ["table"] = "atari_5200_table",
        ["user_db_file"] = "db_atari_5200.lua",
        ["romFolder"] = romUserDir.Atari_5200,
        ["localCoverPath"] = covDir .. "Atari - 5200" .. "/",
        ["localSnapPath"] = snapDir .. "Atari - 5200" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/ATARI_5200/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Atari_-_5200/793489381646954046dd1767a1af0fa4f6b86c24/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_atari_5200.png",
    },
    [30] = 
    {
        ["apptype"] = 30,
        ["table"] = "atari_2600_table",
        ["user_db_file"] = "db_atari_2600.lua",
        ["romFolder"] = romUserDir.Atari_2600,
        ["localCoverPath"] = covDir .. "Atari - 2600" .. "/",
        ["localSnapPath"] = snapDir .. "Atari - 2600" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/ATARI_2600/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Atari_-_2600/ea2ba38f9bace8e85539d12e2f65e31c797c6585/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_atari_2600.png",
    },
    [31] = 
    {
        ["apptype"] = 31,
        ["table"] = "atari_lynx_table",
        ["user_db_file"] = "db_atari_lynx.lua",
        ["romFolder"] = romUserDir.Atari_Lynx,
        ["localCoverPath"] = covDir .. "Atari - Lynx" .. "/",
        ["localSnapPath"] = snapDir .. "Atari - Lynx" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/ATARI_LYNX/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Atari_-_Lynx/91278444136e9c19f89331421ffe84cce6f82fb9/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_atari_lynx.png",
    },
    [32] = 
    {
        ["apptype"] = 32,
        ["table"] = "colecovision_table",
        ["user_db_file"] = "db_colecovision.lua",
        ["romFolder"] = romUserDir.ColecoVision,
        ["localCoverPath"] = covDir .. "Coleco - ColecoVision" .. "/",
        ["localSnapPath"] = snapDir .. "Coleco - ColecoVision" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/COLECOVISION/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/Coleco_-_ColecoVision/332c63436431ea5fceedf50b94447bb6e7a8e1f5/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_colecovision.png",
    },
    [33] = 
    {
        ["apptype"] = 33,
        ["table"] = "vectrex_table",
        ["user_db_file"] = "db_vectrex.lua",
        ["romFolder"] = romUserDir.Vectrex,
        ["localCoverPath"] = covDir .. "GCE - Vectrex" .. "/",
        ["localSnapPath"] = snapDir .. "GCE - Vectrex" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/VECTREX/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/GCE_-_Vectrex/ed03e5d1214399d2f4429109874b2ad3d8a18709/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_vectrex.png",
    },
    [34] = 
    {
        ["apptype"] = 34,
        ["table"] = "fba_table",
        ["user_db_file"] = "db_fba.lua",
        ["romFolder"] = romUserDir.FBA_2012,
        ["localCoverPath"] = covDir .. "FBA 2012" .. "/",
        ["localSnapPath"] = snapDir .. "FBA 2012" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_fba.png",
    },
    [35] = 
    {
        ["apptype"] = 35,
        ["table"] = "mame_2003_plus_table",
        ["user_db_file"] = "db_mame_2003_plus.lua",
        ["romFolder"] = romUserDir.MAME_2003Plus,
        ["localCoverPath"] = covDir .. "MAME 2003 Plus" .. "/",
        ["localSnapPath"] = snapDir .. "MAME 2003 Plus" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_mame.png",
    },
    [36] = 
    {
        ["apptype"] = 36,
        ["table"] = "mame_2000_table",
        ["user_db_file"] = "db_mame_2000.lua",
        ["romFolder"] = romUserDir.MAME_2000,
        ["localCoverPath"] = covDir .. "MAME 2000" .. "/",
        ["localSnapPath"] = snapDir .. "MAME 2000" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_mame.png",
    },
    [37] = 
    {
        ["apptype"] = 37,
        ["table"] = "neogeo_table",
        ["user_db_file"] = "db_neogeo.lua",
        ["romFolder"] = romUserDir.Neo_Geo,
        ["localCoverPath"] = covDir .. "SNK - Neo Geo - FBA 2012" .. "/",
        ["localSnapPath"] = snapDir .. "SNK - Neo Geo - FBA 2012" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/NEOGEO/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/NEOGEO/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_neogeo.png",
    },
    [38] = 
    {
        ["apptype"] = 38,
        ["table"] = "ngpc_table",
        ["user_db_file"] = "db_ngpc.lua",
        ["romFolder"] = romUserDir.Neo_Geo_Pocket_Color,
        ["localCoverPath"] = covDir .. "SNK - Neo Geo Pocket Color" .. "/",
        ["localSnapPath"] = snapDir .. "SNK - Neo Geo Pocket Color" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/NEOGEO_PC/Covers/",
        ["onlineSnapPathSystem"] = "https://raw.githubusercontent.com/libretro-thumbnails/SNK_-_Neo_Geo_Pocket_Color/f940bd5da36105397897c093dda77ef06d51cbcf/Named_Snaps/",
        ["Missing_Cover"] = "missing_cover_ngpc.png",
    },
    [39] = 
    {
        ["apptype"] = 39,
        ["table"] = "psm_table",
        ["user_db_file"] = "db_psm.lua",
        -- ["romFolder"] = "",
        ["localCoverPath"] = covDir .. "Sony - PlayStation Mobile" .. "/",
        ["localSnapPath"] = snapDir .. "Sony - PlayStation Mobile" .. "/",
        ["onlineCoverPathSystem"] = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/HOMEBREW/",
        ["onlineSnapPathSystem"] = "",
        ["Missing_Cover"] = "missing_cover_psm.png",
    },
    [40] = 
    {
        -- ["apptype"] = 40,
        ["table"] = "fav_count",
        -- ["user_db_file"] = "",
        -- ["romFolder"] = "",
        -- ["localCoverPath"] = "",
        -- ["onlineCoverPathSystem"] = "",
        -- ["Missing_Cover"] = "",
    },
    [41] = 
    {
        -- ["apptype"] = 41,
        ["table"] = "recently_played_table",
        -- ["user_db_file"] = "",
        -- ["romFolder"] = "",
        -- ["localCoverPath"] = "",
        -- ["onlineCoverPathSystem"] = "",
        -- ["Missing_Cover"] = "",
    },
    [42] = 
    {
        -- ["apptype"] = 42,
        ["table"] = "search_results_table",
        -- ["user_db_file"] = "",
        -- ["romFolder"] = "",
        -- ["localCoverPath"] = "",
        -- ["onlineCoverPathSystem"] = "",
        -- ["Missing_Cover"] = "",
    },
}

-- Counts
local syscount = #SystemsToScan
count_of_systems = syscount - 1 -- Minus: Favorites, Recently played
count_of_categories = syscount
count_of_start_categories = syscount - 1  -- Minus: Search
count_of_cache_files = syscount - 3 -- -- Minus: Search, Fav, Recent
count_of_get_covers = syscount - 5 -- Minus psm
count_of_get_snaps = syscount - 6 -- Minus psm and vita too


Network.init()


Sound.init()
local click = Sound.open("app0:/DATA/click2.ogg")
local sndMusic = click--temp
local imgCoverTmp = Graphics.loadImage("app0:/DATA/noimg.png")
local backTmp = Graphics.loadImage("app0:/DATA/noimg.png")



local btnT = Graphics.loadImage("app0:/DATA/t.png")
local btnS = Graphics.loadImage("app0:/DATA/s.png")
local imgWifi = Graphics.loadImage("app0:/DATA/wifi.png")
local imgBattery = Graphics.loadImage("app0:/DATA/bat.png")
local imgBack = Graphics.loadImage("app0:/DATA/back_01.jpg")
local imgFloor = Graphics.loadImage("app0:/DATA/floor.png")
local imgFavorite_small_on = Graphics.loadImage("app0:/DATA/fav-small-on.png")
local imgFavorite_large_on = Graphics.loadImage("app0:/DATA/fav-large-on.png")
local imgFavorite_large_off = Graphics.loadImage("app0:/DATA/fav-large-off.png")
local imgHidden_small_on = Graphics.loadImage("app0:/DATA/hidden-small-on.png")
local imgHidden_large_on = Graphics.loadImage("app0:/DATA/hidden-large-on.png")
local setting_icon_theme = Graphics.loadImage("app0:/DATA/setting-icon-theme.png")
local setting_icon_artwork = Graphics.loadImage("app0:/DATA/setting-icon-artwork.png")
local setting_icon_categories = Graphics.loadImage("app0:/DATA/setting-icon-categories.png")
local setting_icon_language = Graphics.loadImage("app0:/DATA/setting-icon-language.png")
local setting_icon_scanning = Graphics.loadImage("app0:/DATA/setting-icon-scanning.png")
local setting_icon_search = Graphics.loadImage("app0:/DATA/setting-icon-search.png")
local setting_icon_sounds = Graphics.loadImage("app0:/DATA/setting-icon-sounds.png")
local setting_icon_about = Graphics.loadImage("app0:/DATA/setting-icon-about.png")
local setting_icon_other = Graphics.loadImage("app0:/DATA/setting-icon-other.png")
local file_browser_folder_open = Graphics.loadImage("app0:/DATA/file-browser-folder-open.png")
local file_browser_folder_closed = Graphics.loadImage("app0:/DATA/file-browser-folder-closed.png")
local file_browser_file = Graphics.loadImage("app0:/DATA/file-browser-file.png")
local footer_gradient = Graphics.loadImage("app0:/DATA/footer_gradient.png")


-- Start of ROM Browser setup

local grey_dir = Color.new(200, 200, 200)
local white_opaque = Color.new(255, 255, 255, 100)
local transparent = Color.new(255, 255, 255, 0)

local scripts = System.listDirectory("ux0:/")

function scripts_sort_by_folder_first()
    sorted_directories = {}
    for k, v in pairs(scripts) do
        if v.directory == true then
            table.insert(sorted_directories, v)
        end
    end
    table.sort(sorted_directories, function(a, b) return (a.name:lower() < b.name:lower()) end)

    sorted_files = {}
    for k, v in pairs(scripts) do
        if v.directory == false then
            table.insert(sorted_files, v)
        end
    end
    table.sort(sorted_files, function(a, b) return (a.name:lower() < b.name:lower()) end)

    scripts = {}
    for k, v in pairs(sorted_directories) do
        table.insert(scripts, v)
    end
    for k, v in pairs(sorted_files) do
        table.insert(scripts, v)
    end
end

scripts_sort_by_folder_first()
for k, v in pairs(scripts) do
    v.previous_directory = false
    v.save = false
end

selection = {}
selection.name = "Use this directory"
selection.directory = true
selection.previous_directory = false
selection.save = true

level_up = {}
level_up.name = "..."
level_up.directory = true
level_up.previous_directory = true
level_up.save = false

local cur_dir_fm = "ux0:/"

-- Init a index
local i = 1

-- End of ROM Browser setup



Graphics.setImageFilters(imgFloor, FILTER_LINEAR, FILTER_LINEAR)


-- CREATE DIRECTORIES

-- Create directory: Backgrounds
local background_dir = "ux0:/data/RetroFlow/WALLPAPER/"
System.createDirectory(background_dir)

-- Create directory: Music
local music_dir = "ux0:/data/RetroFlow/MUSIC/"
System.createDirectory(music_dir)

-- Create directory: Cover Folders
System.createDirectory(covDir)
for k, v in pairs(SystemsToScan) do
    System.createDirectory(tostring(v.localCoverPath))
end

-- Create directory: Snap Folders
System.createDirectory(snapDir)
for k, v in pairs(SystemsToScan) do
    System.createDirectory(tostring(v.localSnapPath))
end

-- Create directory: User Database
local user_DB_Folder = "ux0:/data/RetroFlow/TITLES/"
System.createDirectory(user_DB_Folder)

-- Create directory: Databases
local db_Folder = "ux0:/data/RetroFlow/DATABASES/"
System.createDirectory(db_Folder)

-- Copy databases from app to data
if not System.doesFileExist(db_Folder .. "/mame_2000.db") then
    System.copyFile("app0:/addons/mame_2000.db", db_Folder .. "/mame_2000.db")
end
if not System.doesFileExist(db_Folder .. "/mame_2003_plus.db") then
    System.copyFile("app0:/addons/mame_2003_plus.db", db_Folder .. "/mame_2003_plus.db")
end
if not System.doesFileExist(db_Folder .. "/neogeo.db") then
    System.copyFile("app0:/addons/neogeo.db", db_Folder .. "/neogeo.db")
end
if not System.doesFileExist(db_Folder .. "/fba_2012.db") then
    System.copyFile("app0:/addons/fba_2012.db", db_Folder .. "/fba_2012.db")
end


-- Table Cache
local db_Cache_Folder = "ux0:/data/RetroFlow/CACHE/"
System.createDirectory(db_Cache_Folder)

-- Move old background images to new location
if System.doesFileExist("ux0:/data/RetroFlow/Background.jpg") then System.rename("ux0:/data/RetroFlow/Background.jpg", "ux0:/data/RetroFlow/WALLPAPER/Background.jpg") end
if System.doesFileExist("ux0:/data/RetroFlow/Background.png") then System.rename("ux0:/data/RetroFlow/Background.png", "ux0:/data/RetroFlow/WALLPAPER/Background.png") end
if not System.doesFileExist(background_dir .. "Aurora.png") then System.copyFile("app0:/DATA/Aurora.png", background_dir .. "Aurora.png") end


-- Retroarch Cores
core =
{
SNES = "app0:/snes9x2005_libretro.self",
NES = "app0:/quicknes_libretro.self",
GBA = "app0:/gpsp_libretro.self",
GBC = "app0:/gambatte_libretro.self",
GB = "app0:/gambatte_libretro.self",
SEGA_CD = "app0:/genesis_plus_gx_libretro.self",
s32X = "app0:/picodrive_libretro.self",
MD = "app0:/genesis_plus_gx_libretro.self",
SMS = "app0:/smsplus_libretro.self",
GG = "app0:/smsplus_libretro.self",
TG16 = "app0:/mednafen_pce_fast_libretro.self",
TGCD = "app0:/mednafen_pce_fast_libretro.self",
PCE = "app0:/mednafen_pce_fast_libretro.self",
PCECD = "app0:/mednafen_pce_fast_libretro.self",
AMIGA = "app0:/puae_libretro.self",
C64 = "app0:/vice_x64_libretro.self",
WSWAN_COL = "app0:/mednafen_wswan_libretro.self",
WSWAN = "app0:/mednafen_wswan_libretro.self",
MSX2 = "app0:/fmsx_libretro.self",
MSX1 = "app0:/fmsx_libretro.self",
ZXS = "app0:/fuse_libretro.self",
ATARI_7800 = "app0:/prosystem_libretro.self",
ATARI_5200 = "app0:/atari800_libretro.self",
ATARI_2600 = "app0:/stella2014_libretro.self",
ATARI_LYNX = "app0:/handy_libretro.self",
COLECOVISION = "app0:/bluemsx_libretro.self",
VECTREX = "app0:/vecx_libretro.self",
FBA = "app0:/fbalpha2012_libretro.self",
MAME_2003_PLUS = "app0:/mame2003_plus_libretro.self",
MAME_2000 = "app0:/mame2000_libretro.self",
NEOGEO = "app0:/fbalpha2012_neogeo_libretro.self",
NGPC = "app0:/mednafen_ngp_libretro.self",
PS1 = "app0:/pcsx_rearmed_libretro.self",
}

-- Launcher App Directory
local launch_dir_adr = "ux0:/app/RETROLNCR/"
local launch_app_adr = "RETROLNCR"

-- Create Overrides file
if not System.doesFileExist(cur_dir .. "/overrides.dat") then
    local file_over = System.openFile(cur_dir .. "/overrides.dat", FCREATE)
    System.writeFile(file_over, " ", 1)
    System.closeFile(file_over)
end

-- Create Favorites file
if not System.doesFileExist(cur_dir .. "/favorites.dat") then
    local file_favorites = System.openFile(cur_dir .. "/favorites.dat", FCREATE)
    System.writeFile(file_favorites, " ", 1)
    System.closeFile(file_favorites)
end

-- load textures
local imgBox = Graphics.loadImage("app0:/DATA/vita_cover.png")
local imgBoxPSP = Graphics.loadImage("app0:/DATA/psp_cover.png")
local imgBoxPSX = Graphics.loadImage("app0:/DATA/psx_cover.png")
local imgBoxBLANK = Graphics.loadImage("app0:/DATA/blank_cover.png")

-- Load models
local modBox = Render.loadObject("app0:/DATA/box.obj", imgBox)
local modCover = Render.loadObject("app0:/DATA/cover.obj", imgCoverTmp)
local modBoxNoref = Render.loadObject("app0:/DATA/box_noreflx.obj", imgBox)
local modCoverNoref = Render.loadObject("app0:/DATA/cover_noreflx.obj", imgCoverTmp)

local modBoxPSP = Render.loadObject("app0:/DATA/boxpsp.obj", imgBoxPSP)
local modCoverPSP = Render.loadObject("app0:/DATA/coverpsp.obj", imgCoverTmp)
local modBoxPSPNoref = Render.loadObject("app0:/DATA/boxpsp_noreflx.obj", imgBoxPSP)
local modCoverPSPNoref = Render.loadObject("app0:/DATA/coverpsp_noreflx.obj", imgCoverTmp)

local modBoxPSX = Render.loadObject("app0:/DATA/boxpsx.obj", imgBoxPSX)
local modCoverPSX = Render.loadObject("app0:/DATA/coverpsx.obj", imgCoverTmp)
local modBoxPSXNoref = Render.loadObject("app0:/DATA/boxpsx_noreflx.obj", imgBoxPSX)
local modCoverPSXNoref = Render.loadObject("app0:/DATA/coverpsx_noreflx.obj", imgCoverTmp)

local modCoverN64 = Render.loadObject("app0:/DATA/covern64.obj", imgCoverTmp)
local modCoverN64Noref = Render.loadObject("app0:/DATA/covern64_noreflx.obj", imgCoverTmp)

local modCoverNES = Render.loadObject("app0:/DATA/covernes.obj", imgCoverTmp)
local modCoverNESNoref = Render.loadObject("app0:/DATA/covernes_noreflx.obj", imgCoverTmp)

local modCoverGB = Render.loadObject("app0:/DATA/covergb.obj", imgCoverTmp)
local modCoverGBNoref = Render.loadObject("app0:/DATA/covergb_noreflx.obj", imgCoverTmp)

local modCoverMD = Render.loadObject("app0:/DATA/covermd.obj", imgCoverTmp)
local modCoverMDNoref = Render.loadObject("app0:/DATA/covermd_noreflx.obj", imgCoverTmp)

local modCoverTAPE = Render.loadObject("app0:/DATA/covertape.obj", imgCoverTmp)
local modCoverTAPENoref = Render.loadObject("app0:/DATA/covertape_noreflx.obj", imgCoverTmp)

local modCoverATARI = Render.loadObject("app0:/DATA/coveratari.obj", imgCoverTmp)
local modCoverATARINoref = Render.loadObject("app0:/DATA/coveratari_noreflx.obj", imgCoverTmp)

local modCoverLYNX = Render.loadObject("app0:/DATA/coverlynx.obj", imgCoverTmp)
local modCoverLYNXNoref = Render.loadObject("app0:/DATA/coverlynx_noreflx.obj", imgCoverTmp)

local modCoverHbr = Render.loadObject("app0:/DATA/cover_square.obj", imgCoverTmp)
local modCoverHbrNoref = Render.loadObject("app0:/DATA/cover_square_noreflx.obj", imgCoverTmp)

local modBackground = Render.loadObject("app0:/DATA/planebg.obj", imgBack)
local modDefaultBackground = Render.loadObject("app0:/DATA/planebg.obj", imgBack)
local modFloor = Render.loadObject("app0:/DATA/planefloor.obj", imgFloor)

local img_path = ""

fontname = "font-SawarabiGothic-Regular.woff"
fnt20 = Font.load("app0:/DATA/" .. fontname)
fnt22 = Font.load("app0:/DATA/" .. fontname)
fnt25 = Font.load("app0:/DATA/" .. fontname)

Font.setPixelSizes(fnt20, 20)
Font.setPixelSizes(fnt22, 22)
Font.setPixelSizes(fnt25, 25)

-- Escape magic characters
function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

-- Search
local hasTyped = false
local ret_search = ""

-- Rename
local rename_keyboard = false
local ret_rename = ""

-- Loading progress
-- loading_tasks = 0


function count_cache_and_reload()
    cache_file_count = System.listDirectory(db_Cache_Folder)
    if #cache_file_count ~= count_of_cache_files then
        -- Files missing - rescan
        cache_all_tables()
        files_table = import_cached_DB()
    else
        files_table = import_cached_DB()
    end
end


-- PRINT TABLE FUNCTIONS
function delete_cache()
    dofile("app0:addons/printTable.lua")
    delete_tables()

    local sfo_scan_isos_lua = "ux0:/data/RetroFlow/TITLES/sfo_scan_isos.lua"
    local sfo_scan_games_lua = "ux0:/data/RetroFlow/TITLES/sfo_scan_games.lua"
    local sfo_scan_retroarch_lua = "ux0:/data/RetroFlow/TITLES/sfo_scan_retroarch.lua"

    if System.doesFileExist(sfo_scan_isos_lua) then
        System.deleteFile(sfo_scan_isos_lua)
    end
    if System.doesFileExist(sfo_scan_games_lua) then
        System.deleteFile(sfo_scan_games_lua)
    end
    if System.doesFileExist(sfo_scan_retroarch_lua) then
        System.deleteFile(sfo_scan_retroarch_lua)
    end
end
function cache_all_tables()
    dofile("app0:addons/printTable.lua")
    print_tables()
end
function update_cached_table(def_user_db_file, def_table_name)
    dofile("app0:addons/printTable.lua")
    print_table_system((def_user_db_file), (def_table_name))
end
function update_cached_table_recently_played()
    dofile("app0:addons/printTable.lua")
    print_table_recently_played()
end
function update_cached_table_recently_played_pre_launch()
    dofile("app0:addons/printTable.lua")
    print_table_recently_played_pre_launch()
end
function update_cached_table_renamed_games()
    dofile("app0:addons/printTable.lua")
    print_table_renamed_games()
end
function update_cached_table_hidden_games()
    dofile("app0:addons/printTable.lua")
    print_table_hidden_games()
end
function update_cached_table_launch_overrides()
    dofile("app0:addons/printTable.lua")
    print_table_launch_overrides()
end



local menuX = 0
local menuY = 0
local showMenu = 0
local showCat = 1 -- Category: 0 = all, 1 = games, 2 = homebrews, 3 = psp, 4 = psx, 5 = N64, 6 = SNES, 7 = NES, 8 = GBA, 9 = GBC, 10 = GB, 11 = MD, 12 = SMS, 13 = GG, 14 = MAME, 15 = AMIGA, 16 = TG16, 17 = TG CD, 18 = PCE, 19 = PCE CD, 20 = NGPC, 21 = Favorites
local showView = 0

local info = System.extractSfo("app0:/sce_sys/param.sfo")
local app_version = info.version
local app_title = info.short_title
local app_category = info.category
local app_titleid = info.titleid
local app_size = 0

local master_index = 1
local p = 1
local oldpad = 0
local delayTouch = 8.0
local delayButton = 8.0
local hideBoxes = 0.3 -- used to be 1
local prvRotY = 0

local gettingCovers = false
local gettingBackgrounds = false
local scanComplete = false
local bgscanComplete = false

-- Init Colors
local black = Color.new(0, 0, 0)
local grey = Color.new(45, 45, 45)
local darkalpha = Color.new(40, 40, 40, 180)
local dark = Color.new(40, 40, 40, 255)
local blackalpha = Color.new(0, 0, 0, 215)
local lightgrey = Color.new(58, 58, 58)
local white = Color.new(255, 255, 255)
local red = Color.new(190, 0, 0)
local blue = Color.new(2, 72, 158)
local yellow = Color.new(225, 184, 0)
local green = Color.new(79, 152, 37)
local purple = Color.new(151, 0, 185)
local darkpurple = Color.new(77, 4, 160)
local orange = Color.new(220, 120, 0)
local bg = Color.new(153, 217, 234)
local themeCol = Color.new(2, 72, 158)
local loading_bar_bg = Color.new(255,255,255,50)
local transparent = Color.new(255, 255, 255, 0)
local timercolor = transparent

local targetX = 0
local xstart = 0
local ystart = 0
local space = 1
local touchdown = 0
local startCovers = false
local inPreview = false
local apptype = 0
local appdir = ""
local getCovers = 0
local getRomDir = 1
local getSnaps = 0
local tmpappcat = 0

local game_adr_bin_driver = 0
local game_adr_exec_bin = 0

local prevX = 0
local prevZ = 0
local prevRot = 0

local total_all = 0
local total_games = 0
local total_homebrews = 0
local total_favorites = 0
local curTotal = 1

-- Settings
local startCategory = 1
local setReflections = 1
local setSounds = 1
local setMusic = 1
local themeColor = 0 -- 0 blue, 1 red, 2 yellow, 3 green, 4 grey, 5 black, 6 purple, 7 darkpurple, 8 orange
local menuItems = 3
local setBackground = 1
local setLanguage = 0

local showHomebrews = 1 -- On
local startupScan = 0 -- 0 Off, 1 On
local showRecentlyPlayed = 1 -- On
local showAll = 1 -- On
local Adrenaline_roms = 5 -- All partitions
local Game_Backgrounds = 1 -- On
local setMusicShuffle = 1 -- On

local setSwap_X_O_buttons = 0 -- 0 Off
local setAdrPSButton = 0 -- 0 Menu
local showHidden = 0 -- 0 Off

function SaveSettings()
    local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
    settings = {}
    local settings = "Reflections=" .. setReflections .. " " .. "\nSounds=" .. setSounds .. " " .. "\nColor=" .. themeColor .. " " .. "\nBackground=" .. setBackground .. " " .. "\nLanguage=" .. setLanguage .. " " .. "\nView=" .. showView .. " " .. "\nHomebrews=" .. showHomebrews .. " " .. "\nScan=" .. startupScan .. " " .. "\nCategory=" .. startCategory .. " " .. "\nRecent=" .. showRecentlyPlayed .. " " .. "\nAll=" .. showAll .. " " .. "\nAdrenaline_rom_location=" .. Adrenaline_roms .. " " .. "\nGame_Backgrounds=" .. Game_Backgrounds .. " " .. "\nMusic=" .. setMusic .. " " .. "\nMusic_Shuffle=" .. setMusicShuffle .. " " .. "\nSwap_X_O_buttons=" .. setSwap_X_O_buttons .. " " .. "\nAdrenaline_PS_Button=" .. setAdrPSButton .. " " .. "\nShow_hidden_games=" .. showHidden
    file_settings = io.open(cur_dir .. "/config.dat", "w")
    file_settings:write(settings)
    file_settings:close()
end

if System.doesFileExist(cur_dir .. "/config.dat") then
    local file_config = System.openFile(cur_dir .. "/config.dat", FREAD)
    local filesize = System.sizeFile(file_config)
    local str = System.readFile(file_config, filesize)
    System.closeFile(file_config)
    
    -- Convert space seperated setting numbers to values, can be 1 or more digits
    local function tovector(s)
        local settingValue = {}
        s:gsub("\n", " "):gsub('%-?%d+', function(n) settingValue[#settingValue+1] = tonumber(n) end)
        return settingValue
    end

    local settingValue = tovector(str)

    local getReflections = settingValue[1]; if getReflections ~= nil then setReflections = getReflections end
    local getSounds = settingValue[2]; if getSounds ~= nil then setSounds = getSounds end
    local getthemeColor = settingValue[3]; if getthemeColor ~= nil then themeColor = getthemeColor end
    local getBackground = settingValue[4]; if getBackground ~= nil then setBackground = getBackground end
    local getLanguage = settingValue[5]; if getLanguage ~= nil then setLanguage = getLanguage end
    local getView = settingValue[6]; if getView ~= nil then showView = getView end
    local getHomebrews = settingValue[7]; if getHomebrews ~= nil then showHomebrews = getHomebrews end
    local getStartupScan = settingValue[8]; if getStartupScan ~= nil then startupScan = getStartupScan end
    local getCategory = settingValue[9]; if getCategory ~= nil then startCategory = getCategory end
    local getRecent = settingValue[10]; if getRecent ~= nil then showRecentlyPlayed = getRecent end
    local getAll = settingValue[11]; if getAll ~= nil then showAll = getAll end
    local getAdrenaline_rom_location = settingValue[12]; if getAdrenaline_rom_location ~= nil then Adrenaline_roms = getAdrenaline_rom_location end
    local getGame_Backgrounds = settingValue[13]; if getGame_Backgrounds ~= nil then Game_Backgrounds = getGame_Backgrounds end
    local getMusic = settingValue[14]; if getMusic ~= nil then setMusic = getMusic end
    local getMusicShuffle = settingValue[15]; if getMusicShuffle ~= nil then setMusicShuffle = getMusicShuffle end
    local getSwap_X_O_buttons = settingValue[16]; if getSwap_X_O_buttons ~= nil then setSwap_X_O_buttons = getSwap_X_O_buttons end
    local getAdrPSButton = settingValue[17]; if getAdrPSButton ~= nil then setAdrPSButton = getAdrPSButton end
    local getHidden = settingValue[18]; if getHidden ~= nil then showHidden = getHidden end

    selectedwall = setBackground

    if startCategory > 41 then
        startCategory = 1
    else
    end

else

    -- Get language number from Vita OS and to translation file number
    if      System.getLanguage() == 0  then setLanguage = 9  -- Japanese
    elseif  System.getLanguage() == 1  then setLanguage = 1  -- English (United States)
    elseif  System.getLanguage() == 2  then setLanguage = 3  -- French
    elseif  System.getLanguage() == 3  then setLanguage = 5  -- Spanish
    elseif  System.getLanguage() == 4  then setLanguage = 2  -- German
    elseif  System.getLanguage() == 5  then setLanguage = 4  -- Italian
    elseif  System.getLanguage() == 6  then setLanguage = 12 -- Dutch
    elseif  System.getLanguage() == 7  then setLanguage = 6  -- Portuguese
    elseif  System.getLanguage() == 8  then setLanguage = 8  -- Russian
    elseif  System.getLanguage() == 9  then setLanguage = 17 -- Korean
    elseif  System.getLanguage() == 10 then setLanguage = 10 -- Chinese (Traditional)
    elseif  System.getLanguage() == 11 then setLanguage = 18 -- Chinese (Simplified)
    elseif  System.getLanguage() == 12 then setLanguage = 15 -- Finnish
    elseif  System.getLanguage() == 13 then setLanguage = 7  -- Swedish
    elseif  System.getLanguage() == 14 then setLanguage = 13 -- Danish
    elseif  System.getLanguage() == 15 then setLanguage = 14 -- Norwegian
    elseif  System.getLanguage() == 16 then setLanguage = 11 -- Polski
    elseif  System.getLanguage() == 17 then setLanguage = 6  -- Portuguese (Brazil)
    elseif  System.getLanguage() == 18 then setLanguage = 0  -- English (United Kingdom)
    elseif  System.getLanguage() == 19 then setLanguage = 16 -- Turkish
    elseif  System.getLanguage() == 20 then setLanguage = 5  -- Spanish (Latin America)
    else setLanguage = 0
    end

    SaveSettings()
end

-- Legacy fix - Languages got added bit by bit and were out of logical order.
    --These two lookups allow the menu to be reordered without affecting people's config files

    -- Language - Lookup 'set language' and cross reference to set the choose language menu
    function xchooseLanguageLookup(setLanguage)
        if     setLanguage == 1     then return 1  -- English (United States)
        elseif setLanguage == 2     then return 2  -- German
        elseif setLanguage == 3     then return 3  -- French
        elseif setLanguage == 4     then return 4  -- Italian
        elseif setLanguage == 5     then return 5  -- Spanish
        elseif setLanguage == 6     then return 6  -- Portuguese
        elseif setLanguage == 7     then return 9  -- Swedish
        elseif setLanguage == 8     then return 15 -- Russian
        elseif setLanguage == 9     then return 18 -- Japanese
        elseif setLanguage == 10    then return 16 -- Chinese (Traditional)
        elseif setLanguage == 11    then return 8  -- Polski
        elseif setLanguage == 12    then return 7  -- Dutch
        elseif setLanguage == 13    then return 10 -- Danish
        elseif setLanguage == 14    then return 11 -- Norwegian
        elseif setLanguage == 15    then return 12 -- Finnish
        elseif setLanguage == 16    then return 13 -- Turkish
        elseif setLanguage == 17    then return 20 -- Korean
        elseif setLanguage == 18    then return 17 -- Chinese (Simplified)
        elseif setLanguage == 19    then return 19 -- Japanese (Ryukyuan)
        elseif setLanguage == 20    then return 14 -- Hungarian
        else                             return 0  -- English (United Kingdom)
        end
    end


    -- Language - Lookup 'choose language menu' and cross reference to set the language number
    function xsetLanguageLookup(chooseLanguage)
        if     chooseLanguage == 1  then return 1  -- English (United States)
        elseif chooseLanguage == 2  then return 2  -- German
        elseif chooseLanguage == 3  then return 3  -- French
        elseif chooseLanguage == 4  then return 4  -- Italian
        elseif chooseLanguage == 5  then return 5  -- Spanish
        elseif chooseLanguage == 6  then return 6  -- Portuguese
        elseif chooseLanguage == 7  then return 12 -- Dutch
        elseif chooseLanguage == 8  then return 11 -- Polski
        elseif chooseLanguage == 9  then return 7  -- Swedish
        elseif chooseLanguage == 10 then return 13 -- Danish
        elseif chooseLanguage == 11 then return 14 -- Norwegian
        elseif chooseLanguage == 12 then return 15 -- Finnish
        elseif chooseLanguage == 13 then return 16 -- Turkish
        elseif chooseLanguage == 14 then return 20 -- Hungarian
        elseif chooseLanguage == 15 then return 8  -- Russian
        elseif chooseLanguage == 16 then return 10 -- Chinese (Traditional)
        elseif chooseLanguage == 17 then return 18 -- Chinese (Simplified)
        elseif chooseLanguage == 18 then return 9  -- Japanese
        elseif chooseLanguage == 19 then return 19 -- Japanese (Ryukyuan)        
        elseif chooseLanguage == 20 then return 17 -- Korean
        
        else                             return 0  -- English (United Kingdom)
        end
    end

-- Language - Lookup 'set language' and cross reference to set the choose language menu
local chooseLanguage = 0
chooseLanguage = xchooseLanguageLookup(setLanguage)

-- Check if the get info screen needs to be wider for long translations
local wide_getinfoscreen = false
-- Hungarian
if setLanguage == 20 then
    wide_getinfoscreen = true
else
    wide_getinfoscreen = false
end


-- Check for PSP and PSX titles for scanning
if not System.doesFileExist("ux0:/data/RetroFlow/TITLES/sfo_scan_isos.lua") then
    -- Launch Onelua bin to scan titles
    System.launchEboot("app0:/launch_scan.bin")
end

showCat = startCategory


-- Music - Legacy Fix - Move music files from old directory to new
if System.doesFileExist("ux0:/data/RetroFlow/Music.ogg") then System.rename("ux0:/data/RetroFlow/Music.ogg", "ux0:/data/RetroFlow/MUSIC/Music.ogg") end

-- Music - Scan Music Directory
music_dir = System.listDirectory("ux0:/data/RetroFlow/MUSIC/")

-- Music - Add to music tracks if ogg
music_sequential = {}
for i, file in pairs(music_dir) do
    if not file.directory then
        if string.match(file.name, "%.ogg") then
            file.name = file.name
            table.insert(music_sequential, file)
        end
    else
    end
end

-- Music - Shuffle

-- local track = 1
-- local music_shuffled = {}



function Shuffle(music_sequential)
    math.randomseed( os.time() )
    music_shuffled = {}
    for i = 1, #music_sequential do music_shuffled[i] = music_sequential[i] end
    for i = #music_sequential, 2, -1 do
        local j = math.random(i)
        music_shuffled[i], music_shuffled[j] = music_shuffled[j], music_shuffled[i]
    end
    return music_shuffled
end

-- Music -  
function PlayMusic()

    -- How many tracks?

    -- Just 1 - loop
    if #music_sequential == 1 then
        if System.doesFileExist(cur_dir .. "/MUSIC/" .. music_sequential[track].name) then
            sndMusic = Sound.open(cur_dir .. "/MUSIC/" .. music_sequential[track].name)
            Sound.play(sndMusic, true) -- Loop as only 1 song
        end

    -- More than 1 - don't loop, change track
    elseif #music_sequential > 1 then

        -- Suffle is on
        if setMusicShuffle == 1 then
            
            -- If reached end, go back to track 1
            if track > #music_shuffled then
                track = 1
            end
            if System.doesFileExist(cur_dir .. "/MUSIC/" .. music_shuffled[track].name) then
                sndMusic = Sound.open(cur_dir .. "/MUSIC/" .. music_shuffled[track].name)
                Sound.play(sndMusic, false) -- Don't loop
            end

        -- Suffle is off
        else
            -- If reached end, go back to track 1
            if track > #music_sequential then
                track = 1
            end
            if System.doesFileExist(cur_dir .. "/MUSIC/" .. music_sequential[track].name) then
                sndMusic = Sound.open(cur_dir .. "/MUSIC/" .. music_sequential[track].name)
                Sound.play(sndMusic, false) -- Don't loop
            end
        end
    else

    -- No tracks - do nothing
    end

end

-- Music -  Play if enabled   
if setMusic == 1 then
    if setMusicShuffle == 1 then
        Shuffle(music_sequential)
    else
    end
    track = 1
    PlayMusic()
end


function SetThemeColor()
    if themeColor == 1 then
        themeCol = red
    elseif themeColor == 2 then
        themeCol = yellow
    elseif themeColor == 3 then
        themeCol = green
    elseif themeColor == 4 then
        themeCol = lightgrey
    elseif themeColor == 5 then
        themeCol = black
    elseif themeColor == 6 then
        themeCol = purple
    elseif themeColor == 7 then
        themeCol = darkpurple
    elseif themeColor == 8 then
        themeCol = orange
    else
        themeCol = blue -- default blue
    end
end
SetThemeColor()


-- Speed related settings
local cpu_speed = 444 -- Was 333
System.setBusSpeed(222)
System.setGpuSpeed(222)
System.setGpuXbarSpeed(166)
System.setCpuSpeed(cpu_speed)

function OneshotPrint(my_func)
    my_func()
    Screen.flip()
    my_func()
    Screen.flip()
    my_func()
end

local lang_lines = {}
local lang_default = 
{
-- Footer
["Settings"] = "Settings",
["Launch"] = "Launch",
["Details"] = "Details",
["Category"] = "Category",
["View"] = "View",
["Close"] = "Close",
["Select"] = "Select",
["About"] = "About",

-- General settings
["Language_colon"] = "Language: ",
["Homebrews_Category_colon"] = "Homebrews Category: ",
["Recently_Played_colon"] = "Recently Played: ",
["Startup_scan_colon"] = "Startup scan: ",
["On"] = "On",
["Off"] = "Off",

-- Appearance
["Custom_Background_colon"] = "Custom Background: ",
["Reflection_Effect_colon"] = "Reflection Effect: ",
["Theme_Color_colon"] = "Theme Color: ",
["Red"] = "Red",
["Yellow"] = "Yellow",
["Green"] = "Green",
["Grey"] = "Grey",
["Black"] = "Black",
["Purple"] = "Purple",
["Dark_Purple"] = "Dark Purple",
["Orange"] = "Orange",
["Blue"] = "Blue",

-- Audio
["Audio"] = "Audio",
["Sounds_colon"] = "Sounds: ",
["Music_colon"] = "Music: ",
["Shuffle_music_colon"] = "Shuffle music: ",
["Skip_track"] = "Skip track",

-- Startup Categories
["Startup_Category_colon"] = "Startup Category: ",
["Favorites"] = "Favorites",
["Recently_Played"] = "Recently Played",
["PS_Vita"] = "PS Vita",
["Homebrews"] = "Homebrews",
["PSP"] = "PSP",
["PlayStation"] = "PlayStation",
["Nintendo_64"] = "Nintendo 64",
["Super_Nintendo"] = "Super Nintendo",
["Nintendo_Entertainment_System"] = "Nintendo Entertainment System",
["Game_Boy_Advance"] = "Game Boy Advance",
["Game_Boy_Color"] = "Game Boy Color",
["Game_Boy"] = "Game Boy",
["Sega_Dreamcast"] = "Sega Dreamcast",
["Sega_Mega_Drive"] = "Sega Mega Drive",
["Sega_Master_System"] = "Sega Master System",
["Sega_Game_Gear"] = "Sega Game Gear",
["MAME_2000"] = "MAME 2000",
["Amiga"] = "Amiga",
["TurboGrafx_16"] = "TurboGrafx-16",
["TurboGrafx_CD"] = "TurboGrafx-CD",
["PC_Engine"] = "PC Engine",
["PC_Engine_CD"] = "PC Engine CD",
["Neo_Geo_Pocket_Color"] = "Neo Geo Pocket Color",
["Playstation_Mobile"] = "Playstation Mobile",
["Sega_CD"] = "Sega CD",
["Sega_32X"] = "Sega 32X",
["Commodore_64"] = "Commodore 64",
["WonderSwan_Color"] = "WonderSwan Color",
["WonderSwan"] = "WonderSwan",
["MSX2"] = "MSX2",
["MSX"] = "MSX",
["ZX_Spectrum"] = "ZX Spectrum",
["Atari_7800"] = "Atari 7800",
["Atari_5200"] = "Atari 5200",
["Atari_2600"] = "Atari 2600",
["Atari_Lynx"] = "Atari Lynx",
["ColecoVision"] = "ColecoVision",
["Vectrex"] = "Vectrex",
["FBA_2012"] = "FBA 2012",
["MAME_2003Plus"] = "MAME 2003 Plus",
["Neo_Geo"] = "Neo Geo",

-- Download
["Download_Covers_colon"] = "Download Covers: ",
["Download_Covers"] = "Download Covers",
["Download_Backgrounds_colon"] = "Download Backgrounds: ",
["Extract_PSP_backgrounds"] = "Extract PSP backgrounds",

["All"] = "All",
["Reload_Covers_Database"] = "Reload Covers Database",
["Reload_Backgound_Database"] = "Reload Background Database",
["Internet_Connection_Required"] = "Internet Connection Required",
["Cover"] = "Cover",
["Background"] = "Background",
["Found"] = "Found",
["found_exclamation"] = "found!",
["Cover_not_found"] = "Cover not found",
["Background_not_found"] = "Background not found",
["of"] = " of ",

["Downloading_covers"] = "Downloading covers",
["Downloading_all_covers"] = "Downloading all covers",
["Downloading_PS_Vita_covers"] = "Downloading PS Vita covers",
["Downloading_PSP_covers"] = "Downloading PSP covers",
["Downloading_PS1_covers"] = "Downloading PS1 covers",
["Downloading_N64_covers"] = "Downloading N64 covers",
["Downloading_SNES_covers"] = "Downloading SNES covers",
["Downloading_NES_covers"] = "Downloading NES covers",
["Downloading_GBA_covers"] = "Downloading GBA covers",
["Downloading_GBC_covers"] = "Downloading GBC covers",
["Downloading_GB_covers"] = "Downloading GB covers",
["Downloading_DC_covers"] = "Downloading DC covers",
["Downloading_MD_covers"] = "Downloading MD covers",
["Downloading_SMS_covers"] = "Downloading SMS covers",
["Downloading_GG_covers"] = "Downloading GG covers",
["Downloading_MAME_2000_covers"] = "Downloading MAME 2000 covers",
["Downloading_AMIGA_covers"] = "Downloading AMIGA covers",
["Downloading_TG_16_covers"] = "Downloading TG-16 covers",
["Downloading_TG_CD_covers"] = "Downloading TG-CD covers",
["Downloading_PCE_covers"] = "Downloading PCE covers",
["Downloading_PCE_CD_covers"] = "Downloading PCE-CD covers",
["Downloading_NG_PC_covers"] = "Downloading NG-PC covers",
["Downloading_SCD_covers"] = "Downloading SCD covers",
["Downloading_32X_covers"] = "Downloading 32X covers",
["Downloading_C64_covers"] = "Downloading C64 covers",
["Downloading_WSWANCOL_covers"] = "Downloading WSWANCOL covers",
["Downloading_WSWAN_covers"] = "Downloading WSWAN covers",
["Downloading_MSX2_covers"] = "Downloading MSX2 covers",
["Downloading_MSX_covers"] = "Downloading MSX covers",
["Downloading_ZXS_covers"] = "Downloading ZXS covers",
["Downloading_A7800_covers"] = "Downloading A7800 covers",
["Downloading_A5200_covers"] = "Downloading A5200 covers",
["Downloading_A600_covers"] = "Downloading A600 covers",
["Downloading_LYNX_covers"] = "Downloading LYNX covers",
["Downloading_COLECO_covers"] = "Downloading COLECO covers",
["Downloading_VECTREX_covers"] = "Downloading VECTREX covers",
["Downloading_FBA2012_covers"] = "Downloading FBA2012 covers",
["Downloading_MAME_2003_covers"] = "Downloading MAME 2003 covers",
["Downloading_NG_covers"] = "Downloading NG covers",

["Downloading_backgrounds"] = "Downloading backgrounds",
["Downloading_all_backgrounds"] = "Downloading all backgrounds",
["Downloading_PS_Vita_backgrounds"] = "Downloading PS Vita backgrounds",
["Downloading_PSP_backgrounds"] = "Downloading PSP backgrounds",
["Downloading_PS1_backgrounds"] = "Downloading PS1 backgrounds",
["Downloading_N64_backgrounds"] = "Downloading N64 backgrounds",
["Downloading_SNES_backgrounds"] = "Downloading SNES backgrounds",
["Downloading_NES_backgrounds"] = "Downloading NES backgrounds",
["Downloading_GBA_backgrounds"] = "Downloading GBA backgrounds",
["Downloading_GBC_backgrounds"] = "Downloading GBC backgrounds",
["Downloading_GB_backgrounds"] = "Downloading GB backgrounds",
["Downloading_DC_backgrounds"] = "Downloading DC backgrounds",
["Downloading_MD_backgrounds"] = "Downloading MD backgrounds",
["Downloading_SMS_backgrounds"] = "Downloading SMS backgrounds",
["Downloading_GG_backgrounds"] = "Downloading GG backgrounds",
["Downloading_MAME_2000_backgrounds"] = "Downloading MAME 2000 backgrounds",
["Downloading_AMIGA_backgrounds"] = "Downloading AMIGA backgrounds",
["Downloading_TG_16_backgrounds"] = "Downloading TG-16 backgrounds",
["Downloading_TG_CD_backgrounds"] = "Downloading TG-CD backgrounds",
["Downloading_PCE_backgrounds"] = "Downloading PCE backgrounds",
["Downloading_PCE_CD_backgrounds"] = "Downloading PCE-CD backgrounds",
["Downloading_NG_PC_backgrounds"] = "Downloading NG-PC backgrounds",
["Downloading_SCD_backgrounds"] = "Downloading SCD backgrounds",
["Downloading_32X_backgrounds"] = "Downloading 32X backgrounds",
["Downloading_C64_backgrounds"] = "Downloading C64 backgrounds",
["Downloading_WSWANCOL_backgrounds"] = "Downloading WSWANCOL backgrounds",
["Downloading_WSWAN_backgrounds"] = "Downloading WSWAN backgrounds",
["Downloading_MSX2_backgrounds"] = "Downloading MSX2 backgrounds",
["Downloading_MSX_backgrounds"] = "Downloading MSX backgrounds",
["Downloading_ZXS_backgrounds"] = "Downloading ZXS backgrounds",
["Downloading_A7800_backgrounds"] = "Downloading A7800 backgrounds",
["Downloading_A5200_backgrounds"] = "Downloading A5200 backgrounds",
["Downloading_A600_backgrounds"] = "Downloading A600 backgrounds",
["Downloading_LYNX_backgrounds"] = "Downloading LYNX backgrounds",
["Downloading_COLECO_backgrounds"] = "Downloading COLECO backgrounds",
["Downloading_VECTREX_backgrounds"] = "Downloading VECTREX backgrounds",
["Downloading_FBA2012_backgrounds"] = "Downloading FBA2012 backgrounds",
["Downloading_MAME_2003_backgrounds"] = "Downloading MAME 2003 backgrounds",
["Downloading_NG_backgrounds"] = "Downloading NG backgrounds",

-- Info Screen
["App_ID_colon"] = "App ID: ",
["Size_colon"] = "Size: ",
["Version_colon"] = "Version: ",
["Download_Cover"] = "Download Cover",
["Download_Background"] = "Download Background",
["Override_Category_colon"] = "Override Category: ",
["Press_X_to_apply_Category"] = "Press X to apply Category",
["Press_O_to_apply_Category"] = "Press O to apply Category",
["Default"] = "Default",
["Favorite"] = "Favorite",
["Rename"] = "Rename",
["PS_Vita_Game"] = "PS Vita Game",
["Homebrew"] = "Homebrew",
["PSP_Game"] = "PSP Game",
["PS1_Game"] = "PlayStation Game",
["N64_Game"] = "Nintendo 64 Game",
["SNES_Game"] = "Super Nintendo Game",
["NES_Game"] = "Nintendo Entertainment System Game",
["GBA_Game"] = "Game Boy Advance Game",
["GBC_Game"] = "Game Boy Color Game",
["GB_Game"] = "Game Boy Game",
["DC_Game"] = "Sega Dreamcast Game",
["MD_Game"] = "Sega Mega Drive Game",
["SMS_Game"] = "Sega Master System Game",
["GG_Game"] = "Sega Game Gear Game",
["MAME_2000_Game"] = "MAME 2000 Game",
["Amiga_Game"] = "Amiga Game",
["TurboGrafx_16_Game"] = "TurboGrafx-16 Game",
["TurboGrafx_CD_Game"] = "TurboGrafx-CD Game",
["PC_Engine_Game"] = "PC Engine Game",
["PC_Engine_CD_Game"] = "PC Engine CD Game",
["Neo_Geo_Pocket_Color_Game"] = "Neo Geo Pocket Color Game",
["Playstation_Mobile_Game"] = "Playstation Mobile Game",
["SCD_Game"] = "Sega CD Game",
["S32X_Game"] = "Sega 32X Game",
["C64_Game"] = "Commodore 64 Game",
["WSWANCOL_Game"] = "WonderSwan Color Game",
["WSWAN_Game"] = "WonderSwan Game",
["MSX2_Game"] = "MSX2 Game",
["MSX_Game"] = "MSX Game",
["ZXS_Game"] = "ZX Spectrum Game",
["A7800_Game"] = "Atari 7800 Game",
["A5200_Game"] = "Atari 5200 Game",
["A600_Game"] = "Atari 600 Game",
["LYNX_Game"] = "Atari Lynx Game",
["COLECO_Game"] = "ColecoVision Game",
["VECTREX_Game"] = "Vectrex Game",
["FBA2012_Game"] = "FBA 2012 Game",
["MAME2003_Game"] = "MAME 2003 Plus Game",
["Neo_Geo_Game"] = "Neo Geo Game",

-- Missing launcher message
["Please_install_RetroFlow_Adrenaline_Launcher"] = "Please install RetroFlow Adrenaline Launcher.",
["The_VPK_is_saved_here"] = "The VPK is saved here",

-- Search
["Search"] = "Search",
["Search_Results"] = "Search Results",
["Search_No_Results"] = "Press select to search again",

-- Settings Menu
["Categories"] = "Categories",
["Sounds"] = "Sounds",
["Artwork"] = "Artwork",
["Scan_Settings"] = "Scan Settings",
["Adrenaline_roms"] = "Adrenaline games: ",
["All_Category"] = "All Category: ",
["Back_Chevron"] = "<  Back",
["Theme"] = "Theme",
["Game_backgounds_colon"] = "Game Backgrounds: ",

-- Game directories
["Home"] = "Home",
["Directory_not_found"] = "Directory not found",
["Edit_game_directories"] = "Edit game directories...",
["Game_directories"] = "Game directories",
["Use_this_directory"] = "Use this directory",
["Rescan"] = "Rescan",
["Back"] = "Back",

-- Scan progress
["Scanning_titles"] = "Scanning titles...",
["Scanning_games_ellipsis"] = "Scanning games...",
["Scan_complete"] = "Scan complete",
["Reloading_ellipsis"] = "Reloading...",

-- Guides
["Help_and_Guides"] = "Help",

["guide_1_heading"] = "Adding games",
["guide_1_content"] = "Game directories: \nPlace your games in 'ux0:/data/RetroFlow/ROMS/', or to use your own file directories, go to 'Scan Settings' then 'Edit game directories'. \n\nOnce you have added your games, select 'Rescan' to add them to RetroFlow. \n\nFilenames: \nIt's important that your games are named using the 'no-intro' file naming convention, e.g. 'Sonic (USA)', otherwise images won't be downloaded.",

["guide_2_heading"] = "Adrenaline games not loading?",
["guide_2_content"] = "If Adrenaline games aren't loading and you have installed the RetroFlow Adrenaline Launcher, please install AdrBubbleBooterInstaller: https://vitadb.rinnegatamante.it/#/info/307. \n\nOr try installing Adrenaline Bubble Manager: https://github.com/ONElua/AdrenalineBubbleManager/releases/",

["guide_3_heading"] = "Custom game covers & backgrounds",
["guide_3_content"] = "Covers: \nCustom covers can be saved in the game folders here: 'ux0:/data/RetroFlow/COVERS/'. \n\nBackgounds: \nCustom game backgrounds can be saved in the game folders here: 'ux0:/data/RetroFlow/BACKGROUNDS/'. \n\nFilenames:\nThe filename must match the App ID or the App Name Images must be in .png format.",

["guide_4_heading"] = "Custom wallpaper & music",
["guide_4_content"] = "Wallpaper: \nYou can add as many wallpapers as you like by saving them here: 'ux0:/data/RetroFlow/WALLPAPER/'. \nImages must be in .jpg or .png format and the size should be 960px x 544px. \n\nMusic: \nSongs can be added to 'ux0:/data/RetroFlow/MUSIC/'. \nMusic must be in .ogg format.",

["guide_5_heading"] = "Control shortcuts",
["guide_5_content"] = "DPad Up: Skip to favourites category \n\nDPad Down + Square: Go back one category \n\nDPad Down + L/R triggers: Skip games alphabetically",

["guide_6_heading"] = "About",
["guide_6_content"] = "RetroFlow by jimbob4000 is a modified version of the HexFlow app. \n\nThe originalHexFlow app is by VitaHex. Support VitaHex's projects on patreon.com/vitahex \n\nMore information:\nFor more information and full credits, please visit: https://github.com/jimbob4000/RetroFlow-Launcher",

-- Other Settings
["Other_Settings"] = "Other Settings",
["Swap_X_and_O_buttons_colon"] = "Swap X and O buttons: ",
["Adrenaline_PS_button_colon"] = "Adrenaline PS button:",
["Menu"] = "Menu",
["LiveArea"] = "LiveArea",
["Standard"] = "Standard",

-- Game options
["Options"] = "Options",
["Adrenaline_options"] = "Adrenaline options",
["Driver_colon"] = "Driver: ",
["Execute_colon"] = "Execute: ",
["Save"] = "Save",
["Add_to_favorites"] = "Add to favorites",
["Remove_from_favorites"] = "Remove from favorites",
["Show_hidden_games_colon"] = "Show hidden games:",
["Hide_game"] = "Hide game",
["Unhide_game"] = "Unhide game",
["Remove_from_recently_played"] = "Remove from recently played",
["Retroarch_options"] = "RetroArch options",
["Core_colon"] = "Core:",

}

-- Define fonts for languages
font_default =                "font-SawarabiGothic-Regular.woff"
font_korean =                 "font-NotoSansCJKkr-Regular-Slim.otf"
font_chinese_simplified =     "font-NotoSansCJKsc-Regular-Slim.otf"
font_chinese_traditional =    "font-NotoSansCJKtc-Regular.otf"



function ChangeFont(new_font)
    if fontname ~= (new_font) then 

        -- Load Standard font
        fontname = (new_font) 
        fnt20 = Font.load("app0:/DATA/" .. (new_font))
        fnt22 = Font.load("app0:/DATA/" .. (new_font))
        fnt25 = Font.load("app0:/DATA/" .. (new_font))

        Font.setPixelSizes(fnt20, 20)
        Font.setPixelSizes(fnt22, 22)
        Font.setPixelSizes(fnt25, 25)

    end
end


function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end


-- GET WALLPAPER - START

-- Add default: workaround hack as game backgrounds only show if setBackground is not 0
wallpaper_table_default =
{
    [1] = 
    {
        ["filename"] = "back_01.jpg",
        ["wallpaper_string"] = lang_lines.Off,
        ["wallpaper_path"] = "app0:/DATA/back_01.jpg",
    },
}

-- Scan wallpaper folder for settings
local wallpaper_table_scanned = {}
files_wallpaper = System.listDirectory("ux0:/data/RetroFlow/WALLPAPER/")
for i, file in pairs(files_wallpaper) do
    if not file.directory then
        if string.match(file.name, "%.png") or string.match(file.name, "%.jpg") then
            wallpaper_name_noExtension = file.name:match("(.+)%..+$")
            -- wallpaper_name_noExtension = file.name
            file.filename = file.name
            file.wallpaper_string = wallpaper_name_noExtension
            file.wallpaper_path = "ux0:/data/RetroFlow/WALLPAPER/" .. file.name
            table.insert(wallpaper_table_scanned, file)
        end
    end
end
table.sort(wallpaper_table_scanned, function(a, b) return (a.filename:lower() < b.filename:lower()) end)

-- Combine default and scanned, so default is number 1
local wallpaper_table_settings = {}
wallpaper_table_settings = TableConcat(wallpaper_table_default, wallpaper_table_scanned)

-- GET WALLPAPER - END


-- Custom Background

-- If setting is for a deleted wallpaper, set to default
if selectedwall == nil then
    selectedwall = 1
end

if selectedwall > #wallpaper_table_settings then
    setBackground = 1
    SaveSettings()
end

local imgCustomBack = imgBack
if selectedwall == 0 or selectedwall > #wallpaper_table_settings then
else
    local selected_wallpaper_path = tostring(wallpaper_table_settings[selectedwall].wallpaper_path)
    if selected_wallpaper_path == nil then
        setBackground = 0
        SaveSettings()
    else
        if System.doesFileExist(wallpaper_table_settings[selectedwall].wallpaper_path) then
            imgCustomBack = Graphics.loadImage(wallpaper_table_settings[selectedwall].wallpaper_path)
            Graphics.setImageFilters(imgCustomBack, FILTER_LINEAR, FILTER_LINEAR)
            Render.useTexture(modBackground, imgCustomBack)
        end
    end
end


function ChangeLanguage(def)

    setLanguage = (def)
    if #lang_lines>0 then
        for k in pairs (lang_lines) do
            lang_lines [k] = nil
        end
    end

    lang = "EN.lua"
    if setLanguage == 1 then
        lang = "EN_USA.lua"
        ChangeFont(font_default)
    elseif setLanguage == 2 then
        lang = "DE.lua"
        ChangeFont(font_default)
    elseif setLanguage == 3 then
        lang = "FR.lua"
        ChangeFont(font_default)
    elseif setLanguage == 4 then
        lang = "IT.lua"
        ChangeFont(font_default)
    elseif setLanguage == 5 then
        lang = "SP.lua"
        ChangeFont(font_default)
    elseif setLanguage == 6 then
        lang = "PT.lua"
        ChangeFont(font_default)
    elseif setLanguage == 7 then
        lang = "SW.lua"
        ChangeFont(font_default)
    elseif setLanguage == 8 then
        lang = "RU.lua"
        ChangeFont(font_default)
    elseif setLanguage == 9 then
        lang = "JA.lua"
        ChangeFont(font_default)
    elseif setLanguage == 10 then
        lang = "CN_T.lua"
        ChangeFont(font_chinese_traditional)
    elseif setLanguage == 11 then
        lang = "PL.lua"
        ChangeFont(font_default)
    elseif setLanguage == 12 then
        lang = "NL.lua"
        ChangeFont(font_default)
    elseif setLanguage == 13 then
        lang = "DA.lua"
        ChangeFont(font_default)
    elseif setLanguage == 14 then
        lang = "NO.lua"
        ChangeFont(font_default)
    elseif setLanguage == 15 then
        lang = "FI.lua"
        ChangeFont(font_default)
    elseif setLanguage == 16 then
        lang = "TR.lua"
        ChangeFont(font_default)
    elseif setLanguage == 17 then
        lang = "KO.lua"
        ChangeFont(font_korean)
    elseif setLanguage == 18 then
        lang = "CN_S.lua"
        ChangeFont(font_chinese_simplified)
    elseif setLanguage == 19 then
        lang = "JA_ryu.lua"
        ChangeFont(font_default)
    elseif setLanguage == 20 then
        lang = "HU.lua"
        ChangeFont(font_default)
    else
        lang = "EN.lua"
        ChangeFont(font_default)
    end
    
    -- Import lang file
    if System.doesFileExist("app0:/translations/" .. lang) then
        langfile = {}
        langfile = "app0:/translations/" .. lang
        -- lang_lines = {}
        lang_lines = dofile(langfile)
    else
        -- If missing use default EN table
        lang_lines = lang_default
    end

    if setLanguage == 3 or setLanguage == 8 or setLanguage == 9 or setLanguage == 12 or setLanguage == 19 then
    -- French, Russian, Japanese, Dutch, Japanese (Ryukyuan) language fix
        setting_x_offset = 460
    else
        -- setting_x_offset = 365
        setting_x_offset = 400
    end

    -- Update wallpaper table string for 'Off'
    wallpaper_table_settings[1].wallpaper_string = lang_lines.Off

    -- Check if the get info screen needs to be wider for long translations
    -- Hungarian
    if setLanguage == 20 then
        wide_getinfoscreen = true
    else
        wide_getinfoscreen = false
    end

end


ChangeLanguage(xsetLanguageLookup(chooseLanguage))


function Swap_X_O_buttons()
    if setSwap_X_O_buttons == 1 then 
        -- Swap buttons is - On

        -- Update buttons
        SCE_CTRL_CROSS_MAP = SCE_CTRL_CIRCLE
        SCE_CTRL_CIRCLE_MAP = SCE_CTRL_CROSS

        -- Swap images
        btnO = Graphics.loadImage("app0:/DATA/x.png")
        btnX = Graphics.loadImage("app0:/DATA/o.png")
    else 
        -- Swap buttons is - Off

        -- Update buttons
        SCE_CTRL_CROSS_MAP = SCE_CTRL_CROSS
        SCE_CTRL_CIRCLE_MAP = SCE_CTRL_CIRCLE

        -- Swap images
        btnX = Graphics.loadImage("app0:/DATA/x.png")
        btnO = Graphics.loadImage("app0:/DATA/o.png")
    end
end
Swap_X_O_buttons()


-- Menu Layout
    btnMargin = 32 -- Distance between footer buttons

    -- Setting screen positions

    -- Horizontal positions
    setting_x = 78

    -- Mini menu extra margin
    mini_menu_x_margin = 60

    
    if setLanguage == 3 or setLanguage == 8 or setLanguage == 9 or setLanguage == 12 or setLanguage == 19 then
    -- French, Russian, Japanese, Dutch, Japanese (Ryukyuan) language fix
        setting_x_offset = 460
    else
        -- setting_x_offset = 365
        setting_x_offset = 400
    end
    setting_x_icon = 75
    setting_x_icon_offset = 115

    -- Vertical positions
    setting_yh = 43 -- Header
    setting_y0 = 92
    setting_y1 = 139
    setting_y2 = 186
    setting_y3 = 233
    setting_y4 = 280
    setting_y5 = 327
    setting_y6 = 374
    setting_y7 = 421
    setting_y_smallfont_offset = 2

function vertically_centre_mini_menu(def_menuItems)
    y_available_space = 496
    y_centre_box_height = (def_menuItems + 2) *47 + 3
    y_centre_top_margin = (y_available_space - y_centre_box_height) / 2
    y_centre_selection_start = y_centre_top_margin + 47 + 3
    y_centre_selection_end = y_centre_selection_start + 47
    y_centre_white_line_start = y_centre_top_margin + 47
    y_centre_text_offset = y_centre_top_margin - 32
end 


-- Message - Check if RetroFlow Adrenaline Launcher needs to be installed
    if not System.doesAppExist("RETROLNCR") then

        if Adrenaline_roms == 1 then
            adr_partition = "ux0"
        elseif Adrenaline_roms == 2 then
            adr_partition = "ur0"
        elseif Adrenaline_roms == 3 then
            adr_partition = "imc0"
        elseif Adrenaline_roms == 4 then
            adr_partition = "xmc0"
        else 
            adr_partition = "uma0"
        end
    
        if System.doesDirExist(adr_partition  .. ":/pspemu") then
            System.setMessage(lang_lines.Please_install_RetroFlow_Adrenaline_Launcher .. "\n" .. lang_lines.The_VPK_is_saved_here .. "\n\nux0:/app/RETROFLOW/payloads/\nRetroFlow Adrenaline Launcher.vpk", false, BUTTON_OK)
            --                Please install RetroFlow Adrenaline Launcher.     The VPK is saved here:
        else
        end
    end


function PrintCentered(font, x, y, text, color, size)
    text = text:gsub("\n","")
    local width = Font.getTextWidth(font,text)
    Font.print(font, x - width / 2, y, text, color)
end


function FreeMemory()
    if setMusic == 1 then
        if #music_sequential > 1 then
            Sound.close(sndMusic)
        elseif #music_sequential == 1 then
            Sound.close(sndMusic)
        end
    end
    Sound.close(click)
    Graphics.freeImage(imgCoverTmp)
    Graphics.freeImage(btnX)
    Graphics.freeImage(btnT)
    Graphics.freeImage(btnS)
    Graphics.freeImage(btnO)
    Graphics.freeImage(imgWifi)
    Graphics.freeImage(imgBack)
    Graphics.freeImage(imgBattery)
    Graphics.freeImage(imgBox)
    Graphics.freeImage(imgFavorite_small_on)
    Graphics.freeImage(imgFavorite_large_on)
    Graphics.freeImage(imgFavorite_large_off)
    Graphics.freeImage(imgHidden_large_on)
    Graphics.freeImage(imgHidden_small_on)
    Graphics.freeImage(setting_icon_theme)
    Graphics.freeImage(setting_icon_artwork)
    Graphics.freeImage(setting_icon_categories)
    Graphics.freeImage(setting_icon_language)
    Graphics.freeImage(setting_icon_scanning)
    Graphics.freeImage(setting_icon_search)
    Graphics.freeImage(setting_icon_sounds)
    Graphics.freeImage(setting_icon_about)
    Graphics.freeImage(setting_icon_other)
    Graphics.freeImage(file_browser_folder_open)
    Graphics.freeImage(file_browser_folder_closed)
    Graphics.freeImage(file_browser_file)
    Graphics.freeImage(footer_gradient)
end


function xCatLookup(CatNum)  -- Credit to BlackSheepBoy69 - CatNum = Showcat
    if CatNum == 1 then      return games_table
    elseif CatNum == 2 then  return homebrews_table
    elseif CatNum == 3 then  return psp_table
    elseif CatNum == 4 then  return psx_table
    elseif CatNum == 5 then  return n64_table
    elseif CatNum == 6 then  return snes_table
    elseif CatNum == 7 then  return nes_table
    elseif CatNum == 8 then  return gba_table
    elseif CatNum == 9 then  return gbc_table
    elseif CatNum == 10 then     return gb_table
    elseif CatNum == 11 then     return dreamcast_table
    elseif CatNum == 12 then     return sega_cd_table
    elseif CatNum == 13 then     return s32x_table
    elseif CatNum == 14 then     return md_table
    elseif CatNum == 15 then     return sms_table
    elseif CatNum == 16 then     return gg_table
    elseif CatNum == 17 then     return tg16_table
    elseif CatNum == 18 then     return tgcd_table
    elseif CatNum == 19 then     return pce_table
    elseif CatNum == 20 then     return pcecd_table
    elseif CatNum == 21 then     return amiga_table
    elseif CatNum == 22 then     return c64_table
    elseif CatNum == 23 then     return wswan_col_table
    elseif CatNum == 24 then     return wswan_table
    elseif CatNum == 25 then     return msx2_table
    elseif CatNum == 26 then     return msx1_table
    elseif CatNum == 27 then     return zxs_table
    elseif CatNum == 28 then     return atari_7800_table
    elseif CatNum == 29 then     return atari_5200_table
    elseif CatNum == 30 then     return atari_2600_table
    elseif CatNum == 31 then     return atari_lynx_table
    elseif CatNum == 32 then     return colecovision_table
    elseif CatNum == 33 then     return vectrex_table
    elseif CatNum == 34 then     return fba_table
    elseif CatNum == 35 then     return mame_2003_plus_table
    elseif CatNum == 36 then     return mame_2000_table
    elseif CatNum == 37 then     return neogeo_table
    elseif CatNum == 38 then     return ngpc_table
    elseif CatNum == 39 then     return psm_table
    elseif CatNum == 40 then     return fav_count
    elseif CatNum == 41 then     return recently_played_table
    elseif CatNum == 42 then     return search_results_table
    else             return files_table
    end
end


function xAppNumTableLookup(AppTypeNum)
    if AppTypeNum == 1 then return games_table
    elseif AppTypeNum == 2 then  return psp_table
    elseif AppTypeNum == 3 then  return psx_table
    elseif AppTypeNum == 5 then  return n64_table
    elseif AppTypeNum == 6 then  return snes_table
    elseif AppTypeNum == 7 then  return nes_table
    elseif AppTypeNum == 8 then  return gba_table
    elseif AppTypeNum == 9 then  return gbc_table
    elseif AppTypeNum == 10 then return gb_table
    elseif AppTypeNum == 11 then return dreamcast_table
    elseif AppTypeNum == 12 then return sega_cd_table
    elseif AppTypeNum == 13 then return s32x_table
    elseif AppTypeNum == 14 then return md_table
    elseif AppTypeNum == 15 then return sms_table
    elseif AppTypeNum == 16 then return gg_table
    elseif AppTypeNum == 17 then return tg16_table
    elseif AppTypeNum == 18 then return tgcd_table
    elseif AppTypeNum == 19 then return pce_table
    elseif AppTypeNum == 20 then return pcecd_table
    elseif AppTypeNum == 21 then return amiga_table
    elseif AppTypeNum == 22 then return c64_table
    elseif AppTypeNum == 23 then return wswan_col_table
    elseif AppTypeNum == 24 then return wswan_table
    elseif AppTypeNum == 25 then return msx2_table
    elseif AppTypeNum == 26 then return msx1_table
    elseif AppTypeNum == 27 then return zxs_table
    elseif AppTypeNum == 28 then return atari_7800_table
    elseif AppTypeNum == 29 then return atari_5200_table
    elseif AppTypeNum == 30 then return atari_2600_table
    elseif AppTypeNum == 31 then return atari_lynx_table
    elseif AppTypeNum == 32 then return colecovision_table
    elseif AppTypeNum == 33 then return vectrex_table
    elseif AppTypeNum == 34 then return fba_table
    elseif AppTypeNum == 35 then return mame_2003_plus_table
    elseif AppTypeNum == 36 then return mame_2000_table
    elseif AppTypeNum == 37 then return neogeo_table
    elseif AppTypeNum == 38 then return ngpc_table
    elseif AppTypeNum == 39 then return psm_table
    elseif AppTypeNum == 40 then return fav_count
    elseif AppTypeNum == 41 then return recently_played_table
    elseif AppTypeNum == 42 then return search_results_table
    else return homebrews_table
    end
end

function xAppDbFileLookup(AppTypeNum)
    if AppTypeNum == 1 then return "db_games.lua"
    elseif AppTypeNum == 2 then  return "db_psp.lua"
    elseif AppTypeNum == 3 then  return "db_psx.lua"
    elseif AppTypeNum == 5 then  return "db_n64.lua"
    elseif AppTypeNum == 6 then  return "db_snes.lua"
    elseif AppTypeNum == 7 then  return "db_nes.lua"
    elseif AppTypeNum == 8 then  return "db_gba.lua"
    elseif AppTypeNum == 9 then  return "db_gbc.lua"
    elseif AppTypeNum == 10 then return "db_gb.lua"
    elseif AppTypeNum == 11 then return "db_dreamcast.lua"
    elseif AppTypeNum == 12 then return "db_sega_cd.lua"
    elseif AppTypeNum == 13 then return "db_32x.lua"
    elseif AppTypeNum == 14 then return "db_md.lua"
    elseif AppTypeNum == 15 then return "db_sms.lua"
    elseif AppTypeNum == 16 then return "db_gg.lua"
    elseif AppTypeNum == 17 then return "db_tg16.lua"
    elseif AppTypeNum == 18 then return "db_tgcd.lua"
    elseif AppTypeNum == 19 then return "db_pce.lua"
    elseif AppTypeNum == 20 then return "db_pcecd.lua"
    elseif AppTypeNum == 21 then return "db_amiga.lua"
    elseif AppTypeNum == 22 then return "db_c64.lua"
    elseif AppTypeNum == 23 then return "db_wswan_col.lua"
    elseif AppTypeNum == 24 then return "db_wswan.lua"
    elseif AppTypeNum == 25 then return "db_msx2.lua"
    elseif AppTypeNum == 26 then return "db_msx1.lua"
    elseif AppTypeNum == 27 then return "db_zxs.lua"
    elseif AppTypeNum == 28 then return "db_atari_7800.lua"
    elseif AppTypeNum == 29 then return "db_atari_5200.lua"
    elseif AppTypeNum == 30 then return "db_atari_2600.lua"
    elseif AppTypeNum == 31 then return "db_atari_lynx.lua"
    elseif AppTypeNum == 32 then return "db_colecovision.lua"
    elseif AppTypeNum == 33 then return "db_vectrex.lua"
    elseif AppTypeNum == 34 then return "db_fba.lua"
    elseif AppTypeNum == 35 then return "db_mame_2003_plus.lua"
    elseif AppTypeNum == 36 then return "db_mame_2000.lua"
    elseif AppTypeNum == 37 then return "db_neogeo.lua"
    elseif AppTypeNum == 38 then return "db_ngpc.lua"
    elseif AppTypeNum == 39 then return "db_psm.lua"
    else return "db_homebrews.lua"
    end
end

function xAppNumTableLookup_Missing_Cover(AppTypeNum)
    if AppTypeNum == 1 then return "missing_cover_psv"
    elseif AppTypeNum == 2 then  return "missing_cover_psp"
    elseif AppTypeNum == 3 then  return "missing_cover_psx"
    elseif AppTypeNum == 5 then  return "missing_cover_n64"
    elseif AppTypeNum == 6 then  return "missing_cover_snes"
    elseif AppTypeNum == 7 then  return "missing_cover_nes"
    elseif AppTypeNum == 8 then  return "missing_cover_gba"
    elseif AppTypeNum == 9 then  return "missing_cover_gbc"
    elseif AppTypeNum == 10 then return "missing_cover_gb"

    elseif AppTypeNum == 11 then 
        if setLanguage == 0 then -- EN - Blue logo
            return "missing_cover_dreamcast_eur"
        elseif setLanguage == 1 then -- USA - Red logo
            return "missing_cover_dreamcast_usa"
        elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
            return "missing_cover_dreamcast_j"
        else -- Blue logo
            return "missing_cover_dreamcast_eur"
        end

    elseif AppTypeNum == 12 then return "missing_cover_sega_cd"
    elseif AppTypeNum == 13 then return "missing_cover_32x"

    elseif AppTypeNum == 14 then
        if setLanguage == 1 then -- USA - Genesis
            return "missing_cover_md_usa"
        else -- Megadrive
            return "missing_cover_md"
        end

    elseif AppTypeNum == 15 then return "missing_cover_sms"
    elseif AppTypeNum == 16 then return "missing_cover_gg"
    elseif AppTypeNum == 17 then return "missing_cover_tg16"
    elseif AppTypeNum == 18 then return "missing_cover_tgcd"
    elseif AppTypeNum == 19 then return "missing_cover_pce"
    elseif AppTypeNum == 20 then return "missing_cover_pcecd"
    elseif AppTypeNum == 21 then return "missing_cover_amiga"
    elseif AppTypeNum == 22 then return "missing_cover_c64"
    elseif AppTypeNum == 23 then return "missing_cover_wswan_col"
    elseif AppTypeNum == 24 then return "missing_cover_wswan"
    elseif AppTypeNum == 25 then return "missing_cover_msx2"
    elseif AppTypeNum == 26 then return "missing_cover_msx1"
    elseif AppTypeNum == 27 then return "missing_cover_zxs"
    elseif AppTypeNum == 28 then return "missing_cover_atari_7800"
    elseif AppTypeNum == 29 then return "missing_cover_atari_5200"
    elseif AppTypeNum == 30 then return "missing_cover_atari_2600"
    elseif AppTypeNum == 31 then return "missing_cover_atari_lynx"
    elseif AppTypeNum == 32 then return "missing_cover_colecovision"
    elseif AppTypeNum == 33 then return "missing_cover_vectrex"
    elseif AppTypeNum == 34 then return "missing_cover_fba"
    elseif AppTypeNum == 35 then return "missing_cover_mame"
    elseif AppTypeNum == 36 then return "missing_cover_mame"
    elseif AppTypeNum == 37 then return "missing_cover_neogeo"
    elseif AppTypeNum == 38 then return "missing_cover_ngpc"
    elseif AppTypeNum == 39 then return "missing_cover_psm"
    else return "missing_cover_homebrew"
    end
end

-- Find game table key
function find_game_table_pos_key(tbl, search)
    for key, data in pairs(tbl) do
       if data.name == (search) then 
          return key
       end
    end
end

-- Manipulate Rom Name - remove region code and url encode spaces for image download
function cleanRomNames()
    -- file.name = {}
    -- romname_withExtension = file.name
    romname_noExtension = {}
    romname_noExtension = romname_withExtension:match("(.+)%..+$")

    -- remove space before parenthesis " (" then letters and numbers "(.*)"
    romname_noRegion_noExtension = {}
    romname_noRegion_noExtension = romname_noExtension:gsub(" %(", "("):gsub('%b()', '')

    -- encode url
    local function urlencode (str)
       str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
          function (c) return string.format ("%%%%%02X", string.byte(c)) end)
       str = string.gsub (str, " ", "%%%%20")
       str = string.gsub (str, "%(", "%%%%28")
       str = string.gsub (str, "%)", "%%%%29")
       return str
    end

    romname_url_encoded = {}
    romname_url_encoded = urlencode (romname_noExtension)

    -- Check if name contains parenthesis, if yes strip out to show as version
    if string.find(romname_noExtension, "%(") and string.find(romname_noExtension, "%)") then
        
        
        -- Remove all text except for within "()"
        romname_region_initial = {}
        if romname_noExtension:match("%((.+)%)") ~= nil then
            romname_region_initial = romname_noExtension:match("%((.+)%)")
        else
            romname_region_initial = {}
        end


        -- Tidy up remainder when more than one set of parenthesis used, replace  ") (" with ", "
        if romname_region_initial:gsub("%) %(", ', ') ~= nil then
            romname_region = romname_region_initial:gsub("%) %(", ', ')
        else
            romname_region = " "
        end

    -- If no parenthesis, then add blank to prevent nil error
    else
        -- romname_region = " "
        romname_region = " "
    end
end



function AutoMakeBootBin(def_rom_location, def_driver, def_bin)

    -- Driver and bin tables
    local drivers = { "ENABLE", "INFERN0", "MARCH33", "NP9660" } -- 0,0,1,2
    local bins = { "ENABLE", "EBOOT.BIN", "EBOOT.OLD", "BOOT.BIN" } -- 0,0,1,2

    -- Cleanup game path for writing to bin (set to lowercase and gsub path)
    local path_game = tostring(def_rom_location)

    if System.doesFileExist(path_game .. "/EBOOT.PBP") then
        path_game = path_game .. "/EBOOT.PBP"
    end

    local path2game = path_game:gsub("/pspemu/", "pspemu/")
    local path2game = string.lower(path2game)
    
    local driver = tostring(def_driver)
    local bin = tostring(def_bin)

    -- Copy boot bin for editing
    if System.doesDirExist("ux0:/app/RETROLNCR/data") then

        -- If boot.bin exists, copy and edit
        if System.doesFileExist("app0:payloads/boot.bin") then 
            System.copyFile("app0:payloads/boot.bin", "ux0:/app/RETROLNCR/data/boot.bin")

            local fp = io.open("ux0:/app/RETROLNCR/data/boot.bin", "r+")
            if fp then
                local number = 0
                                    
                -- Driver 
                fp:seek("set",0x04)
                if driver == "INFERN0" then number = "\x00\x00\x00\x00"
                elseif driver == "MARCH33" then number = "\x01\x00\x00\x00"
                elseif driver == "NP9660" then number = "\x02\x00\x00\x00"
                end
                fp:write(number)

                number = 0

                -- Bin Execute
                fp:seek("set",0x08)
                if bin == "EBOOT.BIN" then number = "\x00\x00\x00\x00"
                elseif bin == "EBOOT.OLD" then number = "\x01\x00\x00\x00"
                elseif bin == "BOOT.BIN" then number = "\x02\x00\x00\x00"
                end
                fp:write(number)

                -- Path2game
                fp:seek("set",0x40)
                local fill = 256 - #path2game
                for j=1,fill do
                    path2game = path2game..string.char(00)
                end
                fp:write(path2game)

                -- PSbutton 00 Menu 01 LiveArea 02 Standard
                fp:seek("set",0x14)
                if setAdrPSButton == 0 then psbutton_number = "\x00\x00\x00\x00"
                elseif setAdrPSButton == 1 then psbutton_number = "\x01\x00\x00\x00"
                elseif setAdrPSButton == 2 then psbutton_number = "\x02\x00\x00\x00"
                else
                end
                fp:write(psbutton_number)     

                --Close
                fp:close()

            end--fp

            System.launchApp("RETROLNCR")
        else
            -- boot.bin not found
        end
    else
        -- Launcher not found
    end

end

function launch_Adrenaline(def_rom_location, def_rom_title_id, def_rom_filename)

    -- Check if game has custom launch overrides
    if #launch_overrides_table ~= nil then
        local key = find_game_table_pos_key(launch_overrides_table, app_titleid)
        if key ~= nil then
            -- Overrides found
            saved_driver = launch_overrides_table[key].driver
            if saved_driver == 1 then 
                driver = "INFERN0"
            elseif saved_driver == 2 then
                driver = "MARCH33"
            elseif saved_driver == 3 then
                driver = "NP9660"
            else
                driver = "INFERN0"
            end

            saved_bin = launch_overrides_table[key].bin
            if saved_bin == 1 then 
                bin = "EBOOT.BIN"
            elseif saved_bin == 2 then
                bin = "EBOOT.OLD"
            elseif saved_bin == 3 then
                bin = "BOOT.BIN"
            else
                bin = "EBOOT.BIN"
            end

        else
            -- Overrides not found, use default
            driver = "INFERN0"
            bin = "EBOOT.BIN"
        end
    else
        -- Table is empty, use default
        driver = "INFERN0"
        bin = "EBOOT.BIN"
    end

    -- Delete the old Adrenaline inf file
    if  System.doesFileExist(launch_dir_adr .. "data/boot.inf") then
        System.deleteFile(launch_dir_adr .. "data/boot.inf")
    end

    -- Delete the old Adrenaline bin file
    if  System.doesFileExist(launch_dir_adr .. "data/boot.bin") then
        System.deleteFile(launch_dir_adr .. "data/boot.bin")
    end



    AutoMakeBootBin((def_rom_location), driver, bin)

end


function launch_retroarch(def_core_name)
    System.executeUri("psgm:play?titleid=RETROVITA" .. "&param=" .. (def_core_name) .. "&param2=" .. rom_location)
    System.exit()
end

function launch_DaedalusX64()
    System.executeUri("psgm:play?titleid=DEDALOX64" .. "&param=" .. rom_location)
    System.exit()
end

function launch_Flycast()
    System.executeUri("psgm:play?titleid=FLYCASTDC" .. "&param=" .. rom_location)
    System.exit()
end

function launch_psmobile(def_rom_title_id)
    System.executeUri("psgm:play?titleid=" .. (def_rom_title_id))
    System.exit()
end


function CreateUserTitleTable_for_File(def_user_db_file, def_table_name)

    table.sort((def_table_name), function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    local file_over = System.openFile(user_DB_Folder .. (def_user_db_file), FCREATE)
    System.closeFile(file_over)

    file = io.open(user_DB_Folder .. (def_user_db_file), "w")
    file:write('return {' .. "\n")
    for k, v in pairs((def_table_name)) do

        if v.directory == false then
            file:write('["' .. v.name .. '"] = {name = "' .. v.name_title_search .. '"},' .. "\n")
        end
    end
    file:write('}')
    file:close()

end

function CreateUserTitleTable_for_PSM(def_user_db_file, def_table_name)

    table.sort((def_table_name), function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    local file_over = System.openFile(user_DB_Folder .. (def_user_db_file), FCREATE)
    System.closeFile(file_over)

    file = io.open(user_DB_Folder .. (def_user_db_file), "w")
    file:write('return {' .. "\n")
    for k, v in pairs((def_table_name)) do

        file:write('["' .. v.name .. '"] = {title = "' .. v.title .. '", version = "' .. v.version .. '"},' .. "\n")
    end
    file:write('}')
    file:close()

end




function update_md_regional_cover()
    -- Megadrive, update regional missing cover

    if setLanguage == 1 then -- USA - Genesis
        for k, v in pairs(md_table) do
              if v.icon_path=="app0:/DATA/missing_cover_md.png" then
                  v.icon_path="app0:/DATA/missing_cover_md_usa.png"
              end
        end
    else -- Megadrive
        for k, v in pairs(md_table) do
              if v.icon_path=="app0:/DATA/missing_cover_md_usa.png" then
                  v.icon_path="app0:/DATA/missing_cover_md.png"
              end
        end
    end
end

function update_dc_regional_cover()
    -- Dreamcast, update regional missing cover

    if setLanguage == 0 then -- EN - Blue logo
        for k, v in pairs(dreamcast_table) do
              if v.icon_path=="app0:/DATA/missing_cover_dreamcast_usa.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_j.png" then
                  v.icon_path="app0:/DATA/missing_cover_dreamcast_eur.png"
              end
        end
    elseif setLanguage == 1 then -- USA - Red logo
        for k, v in pairs(dreamcast_table) do
              if v.icon_path=="app0:/DATA/missing_cover_dreamcast_eur.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_j.png" then
                  v.icon_path="app0:/DATA/missing_cover_dreamcast_usa.png"
              end
        end
    elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
        for k, v in pairs(dreamcast_table) do
              if v.icon_path=="app0:/DATA/missing_cover_dreamcast_eur.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_usa.png" then
                  v.icon_path="app0:/DATA/missing_cover_dreamcast_j.png"
              end
        end
    else -- Blue logo
        for k, v in pairs(dreamcast_table) do
              if v.icon_path=="app0:/DATA/missing_cover_dreamcast_usa.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_j.png" then
                  v.icon_path="app0:/DATA/missing_cover_dreamcast_eur.png"
              end
        end
    end
end


-- Check for hidden game names
function check_for_hidden_tag_on_scan(def_file_name, def_app_type)
    if #hidden_games_table ~= nil then
        local key = find_game_table_pos_key(hidden_games_table, (def_file_name))
        if key ~= nil then
            -- Yes - Find in files table
            if hidden_games_table[key].app_type == (def_app_type) then
                
                if hidden_games_table[key].hidden == true then
                    return true
                else
                    return false
                end

            end
        else
          -- No
          return false
        end
    else
        return false
    end
end


function create_fav_count_table(def_table_input)
    -- Note: showHomebrews = 1 -- On
    -- Note: showHidden = 0 -- 0 Off

    fav_count = {}
    for l, file in pairs((def_table_input)) do

        -- Fav, not hidden
        if file.favourite==true and file.hidden==false then

            -- showHomebrews is off
            if showHomebrews == 0 then
                -- ignore homebrew apps
                if file.app_type ~= nil then
                    if file.favourite==true then
                        table.insert(fav_count, file)
                    end
                else
                end

            -- showHomebrews is on
            else
                if file.favourite==true then
                    table.insert(fav_count, file)
                end
            end

        -- Fav hidden
        elseif file.favourite==true and file.hidden==true then

            -- Show hidden is on
            if showHidden==1 then

                -- showHomebrews is off
                if showHomebrews == 0 then
                    -- ignore homebrew apps
                    if file.app_type ~= nil then
                        if file.favourite==true then
                            table.insert(fav_count, file)
                        end
                    else
                    end
                else
                    if file.favourite==true then
                        table.insert(fav_count, file)
                    end
                end
            else
            end
        else
        end
    end
end


function include_game_in_recent(def_app_type, def_game_path)
    local adr_partition_string = ""

    -- Adrenaline partition settings
    if Adrenaline_roms == 1 then
        adr_partition_string = "ux0:/pspemu"
    elseif Adrenaline_roms == 2 then
        adr_partition_string = "ur0:/pspemu"
    elseif Adrenaline_roms == 3 then
        adr_partition_string = "imc0:/pspemu"
    elseif Adrenaline_roms == 4 then
        adr_partition_string = "xmc0:/pspemu"
    elseif Adrenaline_roms == 5 then
        adr_partition_string = "" -- All partitions
    else 
        adr_partition_string = "uma0:/pspemu"
    end

    -- If adrenaline game and partition selected (not all)
    if (def_app_type) == 2 or (def_app_type) == 3 and Adrenaline_roms <= 4 then
        if string.match((def_game_path), adr_partition_string) then
            -- If game path includes adrenaline partition name, then include
            return true
        else
            -- If game path does not include partition name, then exclude
            return false
        end
    -- If homebrew
    elseif (def_app_type) == 0 then
        if showHomebrews == 1 then
            -- If show homebrew on, include
            return true
        else
            -- If show homebrew off, exclude
            return false
        end
    else
        -- Include
        return true
    end


end

function import_recently_played()

    local file_over = System.openFile(cur_dir .. "/overrides.dat", FREAD)
    local filesize = System.sizeFile(file_over)
    local str = System.readFile(file_over, filesize)
    System.closeFile(file_over)

    -- RECENTLY PLAYED
    if showRecentlyPlayed == 1 then
        if System.doesFileExist("ux0:/data/RetroFlow/recently_played.lua") then
            db_Cache_recently_played = "ux0:/data/RetroFlow/recently_played.lua"

            local db_recently_played = {}
            db_recently_played = dofile(db_Cache_recently_played)

            for k, v in ipairs(db_recently_played) do

                -- Legacy fix, add default app type to recently played table
                if v.app_type_default ~= nil then
                    -- do nothing
                else
                    local key = find_game_table_pos_key(xAppNumTableLookup(v.app_type), v.name)
                    if key ~= nil then
                        v.app_type_default = xAppNumTableLookup(v.app_type)[key].app_type_default
                    else
                    end
                end

                -- Check rom exists
                -- If file
                if v.directory == false then
                    if System.doesFileExist(v.game_path) then
                        if include_game_in_recent(v.app_type, v.game_path) == true then
                            table.insert(recently_played_table, v)
                            --add blank icon to all
                            v.icon = imgCoverTmp
                            v.icon_path = v.icon_path
                            v.apptitle = v.apptitle
                        end
                    end
                else
                    -- Not file, is folder
                    if System.doesDirExist(v.game_path) then
                        if include_game_in_recent(v.app_type, v.game_path) == true then
                            table.insert(recently_played_table, v)
                            --add blank icon to all
                            v.icon = imgCoverTmp
                            v.icon_path = v.icon_path
                            v.apptitle = v.apptitle
                        end
                    end
                end
            end

            -- apply_overrides_to_recently_played
            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                
                for k, v in pairs(recently_played_table) do

                    if string.match(str, v.name .. "=1") then
                        v.app_type=1
                        v.cover_path_online = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PSVita/"
                        v.cover_path_local = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/"

                        if "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/" .. v.apptitle .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/" .. v.apptitle .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/" .. v.apptitle .. ".png" --custom cover by app name
                        elseif "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/" .. v.name .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/" .. v.name .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/" .. v.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. v.name .. "/icon0.png") then
                                v.icon_path = "ur0:/appmeta/" .. v.name .. "/icon0.png"  --app icon
                            else
                                v.icon_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    elseif string.match(str, v.name .. "=2") then
                        v.app_type=2
                        v.cover_path_online = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PSP/"
                        v.cover_path_local = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/"

                        if "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/" .. v.apptitle .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/" .. v.apptitle .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/" .. v.apptitle .. ".png" --custom cover by app name
                        elseif "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/" .. v.name .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/" .. v.name .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/" .. v.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                v.icon_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                            else
                                v.icon_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    elseif string.match(str, v.name .. "=3") then
                        v.app_type=3
                        v.cover_path_online = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PS1/"
                        v.cover_path_local = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation/"

                        if "ux0:/data/RetroFlow/COVERS/Sony - PlayStation/" .. v.apptitle .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Sony - PlayStation/" .. v.apptitle .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation/" .. v.apptitle .. ".png" --custom cover by app name
                        elseif "ux0:/data/RetroFlow/COVERS/Sony - PlayStation/" .. v.name .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Sony - PlayStation/" .. v.name .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Sony - PlayStation/" .. v.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                v.icon_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                            else
                                v.icon_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    elseif string.match(str, v.name .. "=4") then
                        v.app_type=0
                        v.cover_path_online = "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/HOMEBREW/"
                        v.cover_path_local = "ux0:/data/RetroFlow/COVERS/Homebrew/"

                        if "ux0:/data/RetroFlow/COVERS/Homebrew/" .. v.apptitle .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Homebrew/" .. v.apptitle .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Homebrew/" .. v.apptitle .. ".png" --custom cover by app name
                        elseif "ux0:/data/RetroFlow/COVERS/Homebrew/" .. v.name .. ".png" and System.doesFileExist("ux0:/data/RetroFlow/COVERS/Homebrew/" .. v.name .. ".png") then
                            v.icon_path = "ux0:/data/RetroFlow/COVERS/Homebrew/" .. v.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. v.name .. "/icon0.png") then
                                v.icon_path = "ur0:/appmeta/" .. v.name .. "/icon0.png"  --app icon
                            else
                                v.icon_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    else
                        -- Fix for existing lists which don't have the snap path local entry
                        if v.snap_path_local == nil then
                            v.snap_path_local = ""
                        end 

                    end
                end
            end

            
        end
    else
    end

    -- Remove hidden games from recent if necessary
    if showHidden == 0 and #recently_played_table ~= nil then
        for l, file in pairs(recently_played_table) do
            if file.hidden == true then
                table.remove(recently_played_table,l)
            else
            end
        end
    end

end


function import_renamed_games()

    renamed_games_table = {}
    if System.doesFileExist("ux0:/data/RetroFlow/renamed_games.lua") then
        db_Cache_renamed_games = "ux0:/data/RetroFlow/renamed_games.lua"

        local db_renamed_games = {}
        db_renamed_games = dofile(db_Cache_renamed_games)

        for k, v in ipairs(db_renamed_games) do
            table.insert(renamed_games_table, v)
        end
    end
end

function import_hidden_games()

    hidden_games_table = {}
    if System.doesFileExist("ux0:/data/RetroFlow/hidden_games.lua") then
        db_Cache_hidden_games = "ux0:/data/RetroFlow/hidden_games.lua"

        local db_hidden_games = {}
        db_hidden_games = dofile(db_Cache_hidden_games)

        for k, v in ipairs(db_hidden_games) do
            if v.directory == false then
                if System.doesFileExist(v.game_path) then
                    table.insert(hidden_games_table, v)
                else
                end
            else
                if System.doesDirExist(v.game_path) then
                    table.insert(hidden_games_table, v)
                else
                end
            end

        end
    end
end

function import_launch_overrides()

    launch_overrides_table = {}
    if System.doesFileExist("ux0:/data/RetroFlow/launch_overrides.lua") then
        db_Cache_launch_overrides = "ux0:/data/RetroFlow/launch_overrides.lua"

        local db_launch_overrides = {}
        db_launch_overrides = dofile(db_Cache_launch_overrides)

        for k, v in ipairs(db_launch_overrides) do
            table.insert(launch_overrides_table, v)
        end
    end
end

import_launch_overrides()

function count_loading_tasks()

    -- Initial setup

        if Adrenaline_roms == 1 then
            adr_partition = "ux0"
        elseif Adrenaline_roms == 2 then
            adr_partition = "ur0"
        elseif Adrenaline_roms == 3 then
            adr_partition = "imc0"
        elseif Adrenaline_roms == 4 then
            adr_partition = "xmc0"
        else 
            adr_partition = "uma0"
        end

    -- Count functions   

        function count_loading_tasks_dir(def_adrenaline_rom_location)
            local files = System.listDirectory((def_adrenaline_rom_location))
            for i, file in pairs(files) do
                loading_tasks = loading_tasks + 1
            end
        end

        function count_loading_tasks_adrenaline (def_adrenaline_rom_location)
            if System.doesDirExist(def_adrenaline_rom_location) then
                local dir_count = System.listDirectory(def_adrenaline_rom_location)
                for i, file in pairs(dir_count) do
                    loading_tasks = loading_tasks + 1

                    -- Add categories lite folder contents to loading tasks
                    if file.directory == true then
                            sub_dir = System.listDirectory(def_adrenaline_rom_location .. "/" .. file.name)
                        for i, file in pairs(sub_dir) do
                            if System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/EBOOT.pbp") then
                                loading_tasks = loading_tasks + 1
                            end
                            if string.match(file.name, "%.iso") or string.match(file.name, "%.cso") then
                                loading_tasks = loading_tasks + 1
                            end
                        end
                    end

                    -- Minus categories lite folders from loading tasks
                    if file.directory == true and not System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/EBOOT.pbp") then
                        loading_tasks = loading_tasks - 1
                    end
                    if file.directory == true and System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/" .. "%.iso") then
                        loading_tasks = loading_tasks - 1
                    end
                    if file.directory == true and System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/" .. "%.cso") then
                        loading_tasks = loading_tasks - 1
                    end

                end
            end
        end

        function count_loading_tasks_Rom_Simple(def, def_table_name)
            if System.doesDirExist(SystemsToScan[(def)].romFolder) then
                local files = System.listDirectory((SystemsToScan[(def)].romFolder))
                for i, file in pairs(files) do
                    loading_tasks = loading_tasks + 1
                end
            end
        end

    -- Count commands

        -- Count Vita and Playstatio Mobile
        count_loading_tasks_dir("ux0:/app")
        if System.doesDirExist("ux0:/psm") then
            count_loading_tasks_dir("ux0:/psm")
        else
        end

        -- Count Adrenaline
        if Adrenaline_roms == 5 then
            for k, v in pairs(adr_partition_table) do
                count_loading_tasks_adrenaline (tostring(v)  .. ":/pspemu/ISO")
                count_loading_tasks_adrenaline (tostring(v)  .. ":/pspemu/ISO")
            end
        else
            count_loading_tasks_adrenaline (adr_partition  .. ":/pspemu/ISO")
        end

        -- Count retro systems
        for k, v in pairs(SystemsToScan) do
            if k >= 4 and k <= 38 then
                count_loading_tasks_Rom_Simple (k)
            end
        end

end

function update_loading_screen_progress()

    loading_progress = loading_progress + 1

    Graphics.initBlend()
    Screen.clear()
    Graphics.drawImage(0, 0, loadingImage)

    local loading_bar_width = 300
    local loading_percent = (loading_progress / loading_tasks) * 100
    local loading_percent_width = (loading_bar_width / 100) * loading_percent

    -- Set max width
    if loading_percent_width >= loading_bar_width then
        loading_percent_width = loading_bar_width
    end

    PrintCentered(fnt20, 480, 445, lang_lines.Scanning_games_ellipsis, white, 20) -- Scanning games...

    -- Progress bar background
    Graphics.fillRect(330, 630, 490, 496, loading_bar_bg)

    -- Progress bar percent
    Graphics.fillRect(330, 330 + loading_percent_width, 490, 496, white)

    Graphics.termBlend()
    Screen.flip()
    Screen.clear()
end

function update_loading_screen_complete()

    loading_progress = loading_tasks -- set to tasks to move to 100% if stuck)

    Graphics.initBlend()
    Screen.clear()
    Graphics.drawImage(0, 0, loadingImage)

    local loading_bar_width = 300
    local loading_percent = (loading_progress / loading_tasks) * 100
    local loading_percent_width = (loading_bar_width / 100) * loading_percent

    PrintCentered(fnt20, 480, 445, lang_lines.Scan_complete, white, 20) -- Scan complete 

    -- Progress bar background
    Graphics.fillRect(330, 630, 490, 496, loading_bar_bg)

    -- Progress bar percent
    Graphics.fillRect(330, 330 + loading_percent_width, 490, 496, white)

    Graphics.termBlend()
    Screen.flip()
    Screen.clear()
end

function listDirectory(dir)
    dir = System.listDirectory(dir)
    -- vita_table = {}
    folders_table = {}
    files_table = {}
    games_table = {}
    homebrews_table = {}
    psp_table = {}
    psx_table = {}
    n64_table = {}
    snes_table = {}
    nes_table = {}
    gba_table = {}
    gbc_table = {}
    gb_table = {}
    dreamcast_table = {}
    sega_cd_table = {}
    s32x_table = {}
    md_table = {}
    sms_table = {}
    gg_table = {}
    tg16_table = {}
    tgcd_table = {}
    pce_table = {}
    pcecd_table = {}
    amiga_table = {}
    c64_table = {}
    wswan_col_table = {}
    wswan_table = {}
    msx2_table = {}
    msx1_table = {}
    zxs_table = {}
    atari_7800_table = {}
    atari_5200_table = {}
    atari_2600_table = {}
    atari_lynx_table = {}
    colecovision_table = {}
    vectrex_table = {}
    fba_table = {}
    mame_2003_plus_table = {}
    mame_2000_table = {}
    neogeo_table = {} 
    ngpc_table = {}
    psm_table = {}
    recently_played_table = {}
    search_results_table = {}
    fav_count = {}
    renamed_games_table = {}
    hidden_games_table = {}

    -- psxdbfull = {}
    -- pspdbfull = {}
    -- mamedbfull = {}

    loading_progress = 0
    local customCategory = 0
    
    local file_over = System.openFile(cur_dir .. "/overrides.dat", FREAD)
    local filesize = System.sizeFile(file_over)
    local str = System.readFile(file_over, filesize)
    System.closeFile(file_over)

    local fileFav_over = System.openFile(cur_dir .. "/favorites.dat", FREAD)
    local fileFavsize = System.sizeFile(fileFav_over)
    local strFav = System.readFile(fileFav_over, fileFavsize)
    System.closeFile(fileFav_over)

    local bubble_filter = System.openFile("app0:/addons/adrenaline_bubble_filter.dat", FREAD)
    local bubble_filtersize = System.sizeFile(bubble_filter)
    local bubble_filter_title_codes = System.readFile(bubble_filter, bubble_filtersize)
    System.closeFile(bubble_filter)

    import_renamed_games()
    import_hidden_games()

    -- Import onelua sfo scanned psp and psx titles
    if System.doesFileExist (user_DB_Folder .. "sfo_scan_isos.lua") then
        sfo_scan_isos_db = dofile(user_DB_Folder .. "sfo_scan_isos.lua")
    else
        sfo_scan_isos_db = {}
    end
    if System.doesFileExist (user_DB_Folder .. "sfo_scan_games.lua") then
        sfo_scan_games_db = dofile(user_DB_Folder .. "sfo_scan_games.lua")
    else
        sfo_scan_games_db = {}
    end
    if System.doesFileExist (user_DB_Folder .. "sfo_scan_retroarch.lua") then
        sfo_scan_retroarch_db = dofile(user_DB_Folder .. "sfo_scan_retroarch.lua")
    else
        sfo_scan_retroarch_db = {}
    end


    for i, file in pairs(dir) do
    local custom_path, custom_path_id, app_type = nil, nil, nil

        if file.directory then
            -- Filter bubbles by the first 4 characters, eg SLUS
            name4chars = string.sub(file.name, 1, 4)            
            if string.find(bubble_filter_title_codes, name4chars,1,true) ~= nil then
                bubble = true
            else
                bubble = false
            end
        end

        if file.directory
            and not string.match(file.name, "RETROFLOW") -- Don't index Retroflow
            and not string.match(file.name, "RETROLNCR") -- Don't index Retroflow Adrenaline Launcher
            and not string.match(file.name, "ADRLANCHR") -- Don't index Adrenaline Launcher
            and not string.match(file.name, "PSPEMU" .. "%d") -- Don't index PSPEMU001 games, but include PSPEMUCFW (Adrenaline)
            and not System.doesFileExist(working_dir .. "/" .. file.name .. "/data/config.bin") -- Don't scan PSP and PSX Bubbles
            and not bubble == true -- Don't scan PSP and PSX Bubbles
            and string.len(file.name) == 9 -- Only use folders with 9 characters
            then

            -- get app name to match with custom cover file name
            if System.doesFileExist(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo")
                -- app_title = info.short_title:gsub("\n"," "):gsub("™",""):gsub("â„¢",""):gsub(" ®",""):gsub("â€¢",""):gsub("Â®",""):gsub('[Â]',''):gsub('[®]',''):gsub('[â]',''):gsub('[„]',''):gsub('[¢]',''):gsub("„","")
                app_title = info.short_title:gsub("\n"," "):gsub("™",""):gsub(" ®",""):gsub("®","")
                file.titleid = tostring(info.titleid)
                file.version = tostring(info.version)
            end

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end


            file.game_path = (working_dir .. "/" .. file.name)

            file.filename = file.name
            file.name = file.name
            file.title = app_title
            file.name_online = file.name
            file.version = file.version
            file.name_title_search = file.name
            file.apptitle = app_title
            file.date_played = 0

            -- Check for renamed game names
            if #renamed_games_table ~= nil then
                local key = find_game_table_pos_key(renamed_games_table, file.titleid)
                if key ~= nil then
                  -- Yes - Find in files table
                  app_title = renamed_games_table[key].title
                  file.title = renamed_games_table[key].title
                  file.apptitle = renamed_games_table[key].title
                else
                  -- No
                end
            else
            end
            
            -- Added for caching sfo scan results
            -- table.insert(vita_table, file)

            if string.match(file.name, "PCS") and not string.match(file.name, "PCSI") then
                
                
                --CHECK FOR OVERRIDDEN CATEGORY of VITA game
                if System.doesFileExist(cur_dir .. "/overrides.dat") then
                    
                    --0 default, 1 vita, 2 psp, 3 psx, 4 homebrew
                    file.app_type_default=1

                    -- VITA
                    if string.match(str, file.name .. "=1") then
                        table.insert(games_table, file)

                        table.insert(folders_table, file)
                        file.app_type=1

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[1].localCoverPath
                        file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[1].localSnapPath

                        if SystemsToScan[1].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[1].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[1].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[1].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- PSP
                    elseif string.match(str, file.name .. "=2") then
                        table.insert(psp_table, file)

                        table.insert(folders_table, file)
                        file.app_type=2

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[3].localCoverPath
                        file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[3].localSnapPath

                        if SystemsToScan[3].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[3].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[3].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[3].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[3].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[3].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- PSX
                    elseif string.match(str, file.name .. "=3") then
                        table.insert(psx_table, file)

                        table.insert(folders_table, file)
                        file.app_type=3

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[4].localCoverPath
                        file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[4].localSnapPath

                        if SystemsToScan[4].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[4].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[4].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[4].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[4].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- HOMEBREW
                    elseif string.match(str, file.name .. "=4") then
                        -- Homebrew
                        table.insert(homebrews_table, file)

                        table.insert(folders_table, file)
                        file.app_type=0

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[2].localCoverPath
                        file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[2].localSnapPath

                        if SystemsToScan[2].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[2].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[2].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[2].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- DEFAULT - VITA
                    else
                        table.insert(games_table, file)

                        table.insert(folders_table, file)
                        file.app_type=1

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_local = SystemsToScan[1].localCoverPath
                        file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                        file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[1].localSnapPath

                        if SystemsToScan[1].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[1].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[1].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[1].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    end

                -- NO OVERRIDE - VITA
                else
                    table.insert(games_table, file)

                    table.insert(folders_table, file)
                    file.app_type=1

                    -- Check for hidden game names
                    file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                    file.cover_path_local = SystemsToScan[1].localCoverPath
                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                    file.snap_path_local = SystemsToScan[1].localSnapPath

                    if SystemsToScan[1].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. app_title .. ".png") then
                        img_path = SystemsToScan[1].localCoverPath .. app_title .. ".png" --custom cover by app name
                    elseif SystemsToScan[1].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. file.name .. ".png") then
                        img_path = SystemsToScan[1].localCoverPath .. file.name .. ".png" --custom cover by app id
                    else
                        if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                            img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                        else
                            img_path = "app0:/DATA/noimg.png" --blank grey
                        end
                    end

                end
                --END OVERRIDDEN CATEGORY of Vita game

            else
                
                file.app_type_default=0
            --CHECK FOR OVERRIDDEN CATEGORY of HOMEBREW game
                if System.doesFileExist(cur_dir .. "/overrides.dat") then
                    --0 default, 1 vita, 2 psp, 3 psx, 4 homebrew

                    -- VITA
                    if string.match(str, file.name .. "=1") then
                        table.insert(games_table, file)

                        table.insert(folders_table, file)
                        file.app_type=1

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[1].localCoverPath
                        file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[1].localSnapPath

                        if SystemsToScan[1].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[1].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[1].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[1].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[1].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "app0:/DATA/missing_cover_psv.png" --blank grey
                            end
                        end

                    -- PSP
                    elseif string.match(str, file.name .. "=2") then
                        table.insert(psp_table, file)

                        table.insert(folders_table, file)
                        file.app_type=2

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[3].localCoverPath
                        file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[3].localSnapPath

                        if SystemsToScan[3].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[3].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[3].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[3].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[3].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[3].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                    
                    -- PSX
                    elseif string.match(str, file.name .. "=3") then
                        table.insert(psx_table, file)

                        table.insert(folders_table, file)
                        file.app_type=3

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[4].localCoverPath
                        file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[4].localSnapPath

                        if SystemsToScan[4].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[4].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[4].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[4].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[4].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end


                    -- HOMEBREW
                    elseif string.match(str, file.name .. "=4") then
                        table.insert(homebrews_table, file)

                        table.insert(folders_table, file)
                        file.app_type=0

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[2].localCoverPath
                        file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[2].localSnapPath

                        if SystemsToScan[2].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[2].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[2].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[2].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- DEFAULT - HOMEBREW
                    else
                        table.insert(homebrews_table, file)

                        table.insert(folders_table, file)
                        file.app_type=0

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                        file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                        file.cover_path_local = SystemsToScan[2].localCoverPath
                        file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                        file.snap_path_local = SystemsToScan[2].localSnapPath

                        if SystemsToScan[2].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. app_title .. ".png") then
                            img_path = SystemsToScan[2].localCoverPath .. app_title .. ".png" --custom cover by app name
                        elseif SystemsToScan[2].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. file.name .. ".png") then
                            img_path = SystemsToScan[2].localCoverPath .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                    end

                -- NO OVERRIDE - HOMEBREW
                else
                    table.insert(homebrews_table, file)

                    table.insert(folders_table, file)
                    file.app_type=0

                    -- Check for hidden game names
                    file.hidden = check_for_hidden_tag_on_scan(file.titleid, file.app_type)

                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                    file.cover_path_local = SystemsToScan[2].localCoverPath
                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                    file.snap_path_local = SystemsToScan[2].localSnapPath

                    if SystemsToScan[2].localCoverPath .. app_title .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. app_title .. ".png") then
                        img_path = SystemsToScan[2].localCoverPath .. app_title .. ".png" --custom cover by app name
                    elseif SystemsToScan[2].localCoverPath .. file.name .. ".png" and System.doesFileExist(SystemsToScan[2].localCoverPath .. file.name .. ".png") then
                        img_path = SystemsToScan[2].localCoverPath .. file.name .. ".png" --custom cover by app id
                    else
                        if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                            img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                        else
                            img_path = "app0:/DATA/noimg.png" --blank grey
                        end
                    end

                end
                --END OVERRIDDEN CATEGORY of homebrew
            end

        end
        
        table.insert(files_table, count_of_systems, file.app_type)  

        update_loading_screen_progress(loading_progress)
        
        --add blank icon to all
        file.icon = imgCoverTmp
        file.icon_path = img_path
        
        table.insert(files_table, count_of_systems, file.icon) 
        table.insert(files_table, count_of_systems, file.apptitle) 
        
    end


    -- SCAN ROMS

    function scan_PSP_iso_subfolder (def_adrenaline_rom_location, def_user_db_file, def_subfolder_name)
        if  System.doesDirExist(def_adrenaline_rom_location .. "/" .. def_subfolder_name) then

            files_PSP = System.listDirectory(def_adrenaline_rom_location .. "/" .. def_subfolder_name)

            for i, file in pairs(files_PSP) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                if not file.directory 
                    and string.match(file.name, "%.") -- has an extension
                    and not string.match(file.name, "Thumbs%.db") 
                    and not string.match(file.name, "DS_Store") 
                    and not string.match(file.name, "%.sav") 
                    and not string.match(file.name, "%.srm") 
                    and not string.match(file.name, "%.mpk") 
                    and not string.match(file.name, "%.eep") 
                    and not string.match(file.name, "%.st0") 
                    and not string.match(file.name, "%.sta") 
                    and not string.match(file.name, "%.sr0") 
                    and not string.match(file.name, "%.ss0") 
                    and not string.match(file.name, "%._") then

                        if sfo_scan_isos_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.launch_argument = ("PATH=ms0:/ISO/" .. def_subfolder_name .. "/" .. file.name)
                            file.game_path = (def_adrenaline_rom_location .. "/" .. def_subfolder_name .. "/" .. file.name)
                            file.date_played = 0
                            file.app_type_default=2

                            -- import map_onelua_sfos(sfo_scan_isos_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_isos_db[romname_withExtension].title
                            app_title = sfo_scan_isos_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_isos_db[romname_withExtension].titleid
                            file.title = sfo_scan_isos_db[romname_withExtension].title
                            file.name_online = sfo_scan_isos_db[romname_withExtension].titleid
                            file.version = sfo_scan_isos_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_isos_db[romname_withExtension].title
                            file.apptitle = sfo_scan_isos_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end

                            custom_path = SystemsToScan[3].localCoverPath .. file.title .. ".png"
                            custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                            -- OVERRIDES START

                            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                                --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                                --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                                -- VITA
                                if string.match(str, file.name .. "=1") then
                                    table.insert(games_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=1

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[1].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[1].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[1].localCoverPath
                                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[1].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
                                            img_path = "app0:/DATA/missing_cover_psv.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- PSP
                                elseif string.match(str, file.name .. "=2") then
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                
                                -- PSX
                                elseif string.match(str, file.name .. "=3") then
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- HOMEBREW
                                elseif string.match(str, file.name .. "=4") then
                                    table.insert(homebrews_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=0

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = "ux0:/data/RetroFlow/COVERS/Homebrew/" .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[2].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[2].localCoverPath
                                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[2].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/icon_homebrew.png") then
                                            img_path = "app0:/DATA/icon_homebrew.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- DEFAULT - PSP
                                else
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                end
                            -- OVERRIDES END

                            -- NO OVERRIDE - PSP
                            else
                                table.insert(psp_table, file)

                                table.insert(folders_table, file)
                                file.app_type=2

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                file.cover_path_local = SystemsToScan[3].localCoverPath
                                file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                file.snap_path_local = SystemsToScan[3].localSnapPath

                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = custom_path --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = custom_path_id --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                        img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle) 

                        else
                        end

                    else
                    
                end
            end

        end
    end

    function scan_PSP_iso_folder (def_adrenaline_rom_location, def_user_db_file)
        if  System.doesDirExist(def_adrenaline_rom_location) then

            files_PSP = System.listDirectory(def_adrenaline_rom_location)

            for i, file in pairs(files_PSP) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                
                -- Scan subfolder for categories lite
                if file.directory then
                    scan_PSP_iso_subfolder (def_adrenaline_rom_location, def_user_db_file, file.name)
                end

                if not file.directory 
                        and string.match(file.name, "%.") -- has an extension
                        and not string.match(file.name, "Thumbs%.db") 
                        and not string.match(file.name, "DS_Store") 
                        and not string.match(file.name, "%.sav") 
                        and not string.match(file.name, "%.srm") 
                        and not string.match(file.name, "%.mpk") 
                        and not string.match(file.name, "%.eep") 
                        and not string.match(file.name, "%.st0") 
                        and not string.match(file.name, "%.sta") 
                        and not string.match(file.name, "%.sr0") 
                        and not string.match(file.name, "%.ss0") 
                        and not string.match(file.name, "%._") then

                        if sfo_scan_isos_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.launch_argument = ("PATH=ms0:/ISO/" .. file.name)
                            file.game_path = (def_adrenaline_rom_location .. "/" .. file.name)
                            file.date_played = 0
                            file.app_type_default=2

                            -- import map_onelua_sfos(sfo_scan_isos_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_isos_db[romname_withExtension].title
                            app_title = sfo_scan_isos_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_isos_db[romname_withExtension].titleid
                            file.title = sfo_scan_isos_db[romname_withExtension].title
                            file.name_online = sfo_scan_isos_db[romname_withExtension].titleid
                            file.version = sfo_scan_isos_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_isos_db[romname_withExtension].title
                            file.apptitle = sfo_scan_isos_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end

                            custom_path = SystemsToScan[3].localCoverPath .. file.title .. ".png"
                            custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                            -- OVERRIDES START

                            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                                --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                                --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                                -- VITA
                                if string.match(str, file.name .. "=1") then
                                    table.insert(games_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=1

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[1].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[1].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[1].localCoverPath
                                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[1].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
                                            img_path = "app0:/DATA/missing_cover_psv.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- PSP
                                elseif string.match(str, file.name .. "=2") then
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                
                                -- PSX
                                elseif string.match(str, file.name .. "=3") then
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- HOMEBREW
                                elseif string.match(str, file.name .. "=4") then
                                    table.insert(homebrews_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=0

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = "ux0:/data/RetroFlow/COVERS/Homebrew/" .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[2].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[2].localCoverPath
                                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[2].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/icon_homebrew.png") then
                                            img_path = "app0:/DATA/icon_homebrew.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- DEFAULT - PSP
                                else
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                end
                            -- OVERRIDES END

                            -- NO OVERRIDE - PSP
                            else
                                table.insert(psp_table, file)

                                table.insert(folders_table, file)
                                file.app_type=2

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                file.cover_path_local = SystemsToScan[3].localCoverPath
                                file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                file.snap_path_local = SystemsToScan[3].localSnapPath

                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = custom_path --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = custom_path_id --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                        img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle) 

                        else
                        end

                    else
                    
                end
            end

        end
    end

    function scan_PSP_game_folder_subfolder (def_adrenaline_rom_location, def_user_db_file, def_subfolder_name)
        if  System.doesDirExist(def_adrenaline_rom_location .. "/" .. def_subfolder_name) then

            files_PSP = System.listDirectory(def_adrenaline_rom_location .. "/" .. def_subfolder_name)

            for i, file in pairs(files_PSP) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                if file.directory and System.doesFileExist(def_adrenaline_rom_location .. "/" .. def_subfolder_name .. "/" .. file.name .. "/EBOOT.PBP") then

                    if string.match(file.name, "NPEG")
                    or string.match(file.name, "NPEH")
                    or string.match(file.name, "UCES")
                    or string.match(file.name, "ULES")
                    or string.match(file.name, "NPUG")
                    or string.match(file.name, "NPUH")
                    or string.match(file.name, "UCUS")
                    or string.match(file.name, "ULUS")
                    or string.match(file.name, "NPJG")
                    or string.match(file.name, "NPJH")
                    or string.match(file.name, "NPHG")
                    or string.match(file.name, "NPHH")
                    or string.match(file.name, "UCAS") then

                        if sfo_scan_games_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. def_subfolder_name .. "/" .. file.name .. "/EBOOT.PBP")
                            file.game_path = (def_adrenaline_rom_location .. "/" .. def_subfolder_name .. "/" .. file.name)
                            file.date_played = 0
                            file.app_type_default=2

                            -- import map_onelua_sfos(sfo_scan_games_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_games_db[romname_withExtension].title
                            app_title = sfo_scan_games_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_games_db[romname_withExtension].titleid
                            file.title = sfo_scan_games_db[romname_withExtension].title
                            file.name_online = sfo_scan_games_db[romname_withExtension].titleid
                            file.version = sfo_scan_games_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_games_db[romname_withExtension].title
                            file.apptitle = sfo_scan_games_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end


                            -- OVERRIDES START

                            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                                --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                                --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                                -- VITA
                                if string.match(str, file.name .. "=1") then
                                    table.insert(games_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=1

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[1].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[1].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[1].localCoverPath
                                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[1].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
                                            img_path = "app0:/DATA/missing_cover_psv.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- PSP
                                elseif string.match(str, file.name .. "=2") then
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                
                                -- PSX
                                elseif string.match(str, file.name .. "=3") then
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- HOMEBREW
                                elseif string.match(str, file.name .. "=4") then
                                    table.insert(homebrews_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=0

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[2].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[2].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[2].localCoverPath
                                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[2].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/icon_homebrew.png") then
                                            img_path = "app0:/DATA/icon_homebrew.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- DEFAULT - PSP
                                else
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                end
                            -- OVERRIDES END

                            -- NO OVERRIDE - PSP
                            else
                                table.insert(psp_table, file)

                                table.insert(folders_table, file)
                                file.app_type=2

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                file.cover_path_local = SystemsToScan[3].localCoverPath
                                file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                file.snap_path_local = SystemsToScan[3].localSnapPath

                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = custom_path --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = custom_path_id --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                        img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle)
                        else
                        end

                    else
                    end
                    
                end
            end

        end
    end

    function scan_PSP_game_folder (def_adrenaline_rom_location, def_user_db_file)
        if  System.doesDirExist(def_adrenaline_rom_location) then

            files_PSP = System.listDirectory(def_adrenaline_rom_location)

            for i, file in pairs(files_PSP) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                
                -- Scan subfolder for categories lite
                if file.directory and not System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/EBOOT.PBP") then
                    scan_PSP_game_folder_subfolder (def_adrenaline_rom_location, def_user_db_file, file.name)
                end

                if file.directory and System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/EBOOT.PBP") then

                    if string.match(file.name, "NPEG")
                    or string.match(file.name, "NPEH")
                    or string.match(file.name, "UCES")
                    or string.match(file.name, "ULES")
                    or string.match(file.name, "NPUG")
                    or string.match(file.name, "NPUH")
                    or string.match(file.name, "UCUS")
                    or string.match(file.name, "ULUS")
                    or string.match(file.name, "NPJG")
                    or string.match(file.name, "NPJH")
                    or string.match(file.name, "NPHG")
                    or string.match(file.name, "NPHH")
                    or string.match(file.name, "UCAS") then

                        if sfo_scan_games_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. file.name .. "/EBOOT.PBP")
                            file.game_path = (def_adrenaline_rom_location .. "/" .. file.name)
                            file.date_played = 0
                            file.app_type_default=2

                            -- import map_onelua_sfos(sfo_scan_games_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_games_db[romname_withExtension].title
                            app_title = sfo_scan_games_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_games_db[romname_withExtension].titleid
                            file.title = sfo_scan_games_db[romname_withExtension].title
                            file.name_online = sfo_scan_games_db[romname_withExtension].titleid
                            file.version = sfo_scan_games_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_games_db[romname_withExtension].title
                            file.apptitle = sfo_scan_games_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end


                            -- OVERRIDES START

                            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                                --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                                --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                                -- VITA
                                if string.match(str, file.name .. "=1") then
                                    table.insert(games_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=1

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[1].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[1].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[1].localCoverPath
                                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[1].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
                                            img_path = "app0:/DATA/missing_cover_psv.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- PSP
                                elseif string.match(str, file.name .. "=2") then
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                
                                -- PSX
                                elseif string.match(str, file.name .. "=3") then
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- HOMEBREW
                                elseif string.match(str, file.name .. "=4") then
                                    table.insert(homebrews_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=0

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[2].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[2].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[2].localCoverPath
                                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[2].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/icon_homebrew.png") then
                                            img_path = "app0:/DATA/icon_homebrew.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- DEFAULT - PSP
                                else
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                end
                            -- OVERRIDES END

                            -- NO OVERRIDE - PSP
                            else
                                table.insert(psp_table, file)

                                table.insert(folders_table, file)
                                file.app_type=2

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                file.cover_path_local = SystemsToScan[3].localCoverPath
                                file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                file.snap_path_local = SystemsToScan[3].localSnapPath

                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = custom_path --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = custom_path_id --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                        img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle)
                        else
                        end

                    else
                    end
                    
                end
            end

        end
    end

    function scan_PS1_game_folder_subfolder (def_adrenaline_rom_location, def_user_db_file, def_subfolder_name)
        if  System.doesDirExist(def_adrenaline_rom_location .. "/" .. def_subfolder_name) then

            files_PSX = System.listDirectory(def_adrenaline_rom_location .. "/" .. def_subfolder_name)

            for i, file in pairs(files_PSX) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                if file.directory and System.doesFileExist(def_adrenaline_rom_location .. "/" .. def_subfolder_name .. "/" .. file.name .. "/EBOOT.PBP") then

                    if not string.match(file.name, "NPEG")
                    and not string.match(file.name, "NPEH")
                    and not string.match(file.name, "UCES")
                    and not string.match(file.name, "ULES")
                    and not string.match(file.name, "NPUG")
                    and not string.match(file.name, "NPUH")
                    and not string.match(file.name, "UCUS")
                    and not string.match(file.name, "ULUS")
                    and not string.match(file.name, "NPJG")
                    and not string.match(file.name, "NPJH")
                    and not string.match(file.name, "NPHG")
                    and not string.match(file.name, "NPHH")
                    and not string.match(file.name, "UCAS") then

                        if sfo_scan_games_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. def_subfolder_name .. "/" .. file.name .. "/EBOOT.PBP")
                            file.game_path = (def_adrenaline_rom_location .. "/" .. def_subfolder_name .. "/" .. file.name)
                            file.date_played = 0
                            file.app_type_default=3

                            -- import map_onelua_sfos(sfo_scan_games_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_games_db[romname_withExtension].title
                            app_title = sfo_scan_games_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_games_db[romname_withExtension].titleid
                            file.title = sfo_scan_games_db[romname_withExtension].title
                            file.name_online = sfo_scan_games_db[romname_withExtension].titleid
                            file.version = sfo_scan_games_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_games_db[romname_withExtension].title
                            file.apptitle = sfo_scan_games_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end

                            -- OVERRIDES START

                            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                                --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                                --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                                -- VITA
                                if string.match(str, file.name .. "=1") then
                                    table.insert(games_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=1

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[1].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[1].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[1].localCoverPath
                                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[1].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
                                            img_path = "app0:/DATA/missing_cover_psv.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- PSP
                                elseif string.match(str, file.name .. "=2") then
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                
                                -- PSX
                                elseif string.match(str, file.name .. "=3") then
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- HOMEBREW
                                elseif string.match(str, file.name .. "=4") then
                                    table.insert(homebrews_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=0

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[2].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[2].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[2].localCoverPath
                                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[2].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/icon_homebrew.png") then
                                            img_path = "app0:/DATA/icon_homebrew.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- DEFAULT - PSX
                                else
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                end
                            -- OVERRIDES END

                            -- NO OVERRIDE
                            else
                                table.insert(psx_table, file)

                                table.insert(folders_table, file)
                                file.app_type=3

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                file.cover_path_local = SystemsToScan[4].localCoverPath
                                file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                file.snap_path_local = SystemsToScan[4].localSnapPath
                                
                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                        img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle)
                        else
                        end

                    else
                    end

                    
                end
            end
        end
    end

    function scan_PS1_game_folder (def_adrenaline_rom_location, def_user_db_file)
        if  System.doesDirExist(def_adrenaline_rom_location) then

            files_PSX = System.listDirectory(def_adrenaline_rom_location)

            for i, file in pairs(files_PSX) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                
                -- Scan subfolder for categories lite
                if file.directory and not System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/EBOOT.PBP") then
                    scan_PS1_game_folder_subfolder (def_adrenaline_rom_location, def_user_db_file, file.name)
                end

                if file.directory and System.doesFileExist(def_adrenaline_rom_location .. "/" .. file.name .. "/EBOOT.PBP") then

                    if not string.match(file.name, "NPEG")
                    and not string.match(file.name, "NPEH")
                    and not string.match(file.name, "UCES")
                    and not string.match(file.name, "ULES")
                    and not string.match(file.name, "NPUG")
                    and not string.match(file.name, "NPUH")
                    and not string.match(file.name, "UCUS")
                    and not string.match(file.name, "ULUS")
                    and not string.match(file.name, "NPJG")
                    and not string.match(file.name, "NPJH")
                    and not string.match(file.name, "NPHG")
                    and not string.match(file.name, "NPHH")
                    and not string.match(file.name, "UCAS") then

                        if sfo_scan_games_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. file.name .. "/EBOOT.PBP")
                            file.game_path = (def_adrenaline_rom_location .. "/" .. file.name)
                            file.date_played = 0
                            file.app_type_default=3

                            -- import map_onelua_sfos(sfo_scan_games_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_games_db[romname_withExtension].title
                            app_title = sfo_scan_games_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_games_db[romname_withExtension].titleid
                            file.title = sfo_scan_games_db[romname_withExtension].title
                            file.name_online = sfo_scan_games_db[romname_withExtension].titleid
                            file.version = sfo_scan_games_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_games_db[romname_withExtension].title
                            file.apptitle = sfo_scan_games_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end


                            -- OVERRIDES START

                            if System.doesFileExist(cur_dir .. "/overrides.dat") then
                                --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                                --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                                -- VITA
                                if string.match(str, file.name .. "=1") then
                                    table.insert(games_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=1

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[1].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[1].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[1].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[1].localCoverPath
                                    file.snap_path_online = SystemsToScan[1].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[1].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
                                            img_path = "app0:/DATA/missing_cover_psv.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- PSP
                                elseif string.match(str, file.name .. "=2") then
                                    table.insert(psp_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=2

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[3].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[3].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[3].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[3].localCoverPath
                                    file.snap_path_online = SystemsToScan[3].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[3].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
                                            img_path = "app0:/DATA/missing_cover_psp.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                
                                -- PSX
                                elseif string.match(str, file.name .. "=3") then
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- HOMEBREW
                                elseif string.match(str, file.name .. "=4") then
                                    table.insert(homebrews_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=0

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[2].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[2].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[2].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[2].localCoverPath
                                    file.snap_path_online = SystemsToScan[2].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[2].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/icon_homebrew.png") then
                                            img_path = "app0:/DATA/icon_homebrew.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                -- DEFAULT - PSX
                                else
                                    table.insert(psx_table, file)

                                    table.insert(folders_table, file)
                                    file.app_type=3

                                    -- Check for hidden game names
                                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                    custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                    custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                    file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                    file.cover_path_local = SystemsToScan[4].localCoverPath
                                    file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                    file.snap_path_local = SystemsToScan[4].localSnapPath

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = custom_path --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = custom_path_id --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                            img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end
                                end
                            -- OVERRIDES END

                            -- NO OVERRIDE
                            else
                                table.insert(psx_table, file)

                                table.insert(folders_table, file)
                                file.app_type=3

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                                custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                                file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                                file.cover_path_local = SystemsToScan[4].localCoverPath
                                file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                                file.snap_path_local = SystemsToScan[4].localSnapPath
                                
                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                        img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle)
                        else
                        end

                    else
                    end

                    
                end
            end
        end
    end

    if Adrenaline_roms == 1 then
        adr_partition = "ux0"
    elseif Adrenaline_roms == 2 then
        adr_partition = "ur0"
    elseif Adrenaline_roms == 3 then
        adr_partition = "imc0"
    elseif Adrenaline_roms == 4 then
        adr_partition = "xmc0"
    else 
        adr_partition = "uma0"
    end

    if Adrenaline_roms == 5 then
        for k, v in pairs(adr_partition_table) do
            scan_PSP_iso_folder     (tostring(v)  .. ":/pspemu/ISO",       "psp_iso_"     .. tostring(v) .. ".lua")
            scan_PSP_game_folder    (tostring(v)  .. ":/pspemu/PSP/GAME",  "psp_game_"    .. tostring(v) .. ".lua")
            scan_PS1_game_folder    (tostring(v)  .. ":/pspemu/PSP/GAME",  "psx_"         .. tostring(v) .. ".lua")
        end
    else
        scan_PSP_iso_folder     (adr_partition  .. ":/pspemu/ISO",       "psp_iso_"     .. adr_partition .. ".lua")
        scan_PSP_game_folder    (adr_partition  .. ":/pspemu/PSP/GAME",  "psp_game_"    .. adr_partition .. ".lua")
        scan_PS1_game_folder    (adr_partition  .. ":/pspemu/PSP/GAME",  "psx_"         .. adr_partition .. ".lua")
    end


    function scan_Rom_PS1_Eboot (def_ps1_rom_location, def_user_db_file)
        if  System.doesDirExist(def_ps1_rom_location) then

            files_PSX = System.listDirectory(def_ps1_rom_location)

            for i, file in pairs(files_PSX) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                if file.directory and System.doesFileExist(def_ps1_rom_location .. "/" .. file.name .. "/EBOOT.PBP") then

                    if not string.match(file.name, "NPEG")
                    and not string.match(file.name, "NPEH")
                    and not string.match(file.name, "UCES")
                    and not string.match(file.name, "ULES")
                    and not string.match(file.name, "NPUG")
                    and not string.match(file.name, "NPUH")
                    and not string.match(file.name, "UCUS")
                    and not string.match(file.name, "ULUS")
                    and not string.match(file.name, "NPJG")
                    and not string.match(file.name, "NPJH")
                    and not string.match(file.name, "NPHG")
                    and not string.match(file.name, "NPHH")
                    and not string.match(file.name, "UCAS") then

                        if sfo_scan_retroarch_db[file.name] ~= nil then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            -- file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. file.name .. "/EBOOT.PBP")
                            file.game_path = (def_ps1_rom_location .. "/" .. file.name .. "/EBOOT.PBP")
                            file.date_played = 0
                            file.app_type=3
                            file.app_type_default=3
                            file.directory = false -- fix for recently played

                            romname_withExtension = file.name

                            romname_noExtension = {}
                            romname_noExtension = file.name

                            -- import map_onelua_sfos(sfo_scan_retroarch_db)
                            romname_withExtension = tostring(file.name)
                            info = sfo_scan_retroarch_db[romname_withExtension].title
                            app_title = sfo_scan_retroarch_db[romname_withExtension].title
                            file.filename = romname_withExtension
                            file.name = sfo_scan_retroarch_db[romname_withExtension].titleid
                            file.title = sfo_scan_retroarch_db[romname_withExtension].title
                            file.name_online = sfo_scan_retroarch_db[romname_withExtension].titleid
                            file.version = sfo_scan_retroarch_db[romname_withExtension].region
                            file.name_title_search = sfo_scan_retroarch_db[romname_withExtension].title
                            file.apptitle = sfo_scan_retroarch_db[romname_withExtension].title

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end

                            -- Check for hidden game names
                            file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                            table.insert(psx_table, file)
                            table.insert(folders_table, file)

                            custom_path = SystemsToScan[4].localCoverPath .. app_title .. ".png"
                            custom_path_id = SystemsToScan[4].localCoverPath .. file.name .. ".png"

                            file.cover_path_online = SystemsToScan[4].onlineCoverPathSystem
                            file.cover_path_local = SystemsToScan[4].localCoverPath
                            file.snap_path_online = SystemsToScan[4].onlineSnapPathSystem
                            file.snap_path_local = SystemsToScan[4].localSnapPath
                            
                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = SystemsToScan[4].localCoverPath .. file.name .. ".png" --custom cover by app id
                            else
                                if System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
                                    img_path = "app0:/DATA/missing_cover_psx.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)
                            table.insert(files_table, count_of_systems, file.name_title_search)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon)                     
                            table.insert(files_table, count_of_systems, file.apptitle)
                        else
                        end

                    else
                    end

                    
                end
            end


        end
    end

    function Scan_Rom_PS1(def, def_table_name)

        if System.doesDirExist(SystemsToScan[(def)].romFolder) then

            files = System.listDirectory((SystemsToScan[(def)].romFolder))
            for i, file in pairs(files) do
                local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
                -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
                if not file.directory 
                    and string.match(file.name, "%.cue")
                    or string.match(file.name, "%.img")
                    or string.match(file.name, "%.mdf")
                    or string.match(file.name, "%.toc")
                    or string.match(file.name, "%.cbn")
                    or string.match(file.name, "%.m3u")
                    or string.match(file.name, "%.ccd")
                    or string.match(file.name, "%.pbp")
                    or string.match(file.name, "%.PBP")
                    -- and string.match(file.name, "%.") -- has an extension 
                    and not string.match(file.name, "eboot.pbp") 
                    and not string.match(file.name, "EBOOT.PBP")
                    and not string.match(file.name, "Thumbs%.db") 
                    and not string.match(file.name, "DS_Store") 
                    and not string.match(file.name, "%.sav") 
                    and not string.match(file.name, "%.srm") 
                    and not string.match(file.name, "%.mpk") 
                    and not string.match(file.name, "%.eep") 
                    and not string.match(file.name, "%.st0") 
                    and not string.match(file.name, "%.sta") 
                    and not string.match(file.name, "%.sr0") 
                    and not string.match(file.name, "%.ss0") 
                    and not string.match(file.name, "%._") then

                        if string.match(file.name, "%.pbp") or string.match(file.name, "%.PBP") then

                            if sfo_scan_retroarch_db[file.name] ~= nil then
                                -- check if game is in the favorites list
                                if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                    if string.find(strFav, file.name,1,true) ~= nil then
                                        file.favourite = true
                                    else
                                        file.favourite = false
                                    end
                                end

                                file.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name)

                                file.date_played = 0
                                file.app_type = 3
                                file.app_type_default = 3

                                romname_withExtension = file.name

                                romname_noExtension = {}
                                romname_noExtension = file.name

                                -- import map_onelua_sfos(sfo_scan_retroarch_db)
                                romname_withExtension = tostring(file.name)
                                info = sfo_scan_retroarch_db[romname_withExtension].title
                                app_title = sfo_scan_retroarch_db[romname_withExtension].title
                                file.filename = romname_withExtension
                                file.name = sfo_scan_retroarch_db[romname_withExtension].titleid
                                file.title = sfo_scan_retroarch_db[romname_withExtension].title
                                file.name_online = sfo_scan_retroarch_db[romname_withExtension].titleid
                                file.version = sfo_scan_retroarch_db[romname_withExtension].region
                                file.name_title_search = sfo_scan_retroarch_db[romname_withExtension].title
                                file.apptitle = sfo_scan_retroarch_db[romname_withExtension].title

                                -- Check for renamed game names
                                if #renamed_games_table ~= nil then
                                    local key = find_game_table_pos_key(renamed_games_table, file.name)
                                    if key ~= nil then
                                      -- Yes - Find in files table
                                      app_title = renamed_games_table[key].title
                                      file.title = renamed_games_table[key].title
                                      file.apptitle = renamed_games_table[key].title
                                    else
                                      -- No
                                    end
                                else
                                end

                                -- Check for hidden game names
                                file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                                custom_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png"
                                custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png"

                                file.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                                file.cover_path_local = (SystemsToScan[(def)].localCoverPath)
                                file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                                file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)

                                if custom_path and System.doesFileExist(custom_path) then
                                    img_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png" --custom cover by app name
                                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                    img_path = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png" --custom cover by app id
                                else
                                    if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                        img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                                    else
                                        img_path = "app0:/DATA/noimg.png" --blank grey
                                    end
                                end

                                table.insert(folders_table, file)
                                table.insert((def_table_name), file)

                                table.insert(files_table, count_of_systems, file.app_type) 
                                table.insert(files_table, count_of_systems, file.name)
                                table.insert(files_table, count_of_systems, file.title)
                                table.insert(files_table, count_of_systems, file.name_online)
                                table.insert(files_table, count_of_systems, file.version)

                                --add blank icon to all
                                file.icon = imgCoverTmp
                                file.icon_path = img_path
                                
                                table.insert(files_table, count_of_systems, file.icon) 
                                table.insert(files_table, count_of_systems, file.apptitle)
                            else
                            end

                        else

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file.name,1,true) ~= nil then
                                    file.favourite = true
                                else
                                    file.favourite = false
                                end
                            end

                            file.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name)

                            romname_withExtension = file.name
                            cleanRomNames()
                            info = romname_noRegion_noExtension
                            app_title = romname_noExtension
                            
                            
                            --table.insert(games_table, file)
                        
                            file.filename = file.name
                            file.name = romname_noExtension
                            file.title = romname_noRegion_noExtension
                            file.name_online = romname_url_encoded
                            file.version = romname_region
                            file.apptitle = romname_noRegion_noExtension
                            file.date_played = 0
                            file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                            file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                            file.app_type = 3
                            file.app_type_default = 3

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  file.title = renamed_games_table[key].title
                                  file.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end

                            -- Check for hidden game names
                            file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                            custom_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png"
                            custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png"

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png" --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png" --custom cover by app id
                            else
                                if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                    img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                            table.insert(folders_table, file)
                            table.insert((def_table_name), file)

                            table.insert(files_table, count_of_systems, file.app_type) 
                            table.insert(files_table, count_of_systems, file.name)
                            table.insert(files_table, count_of_systems, file.title)
                            table.insert(files_table, count_of_systems, file.name_online)
                            table.insert(files_table, count_of_systems, file.version)

                            file.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                            file.cover_path_local = (SystemsToScan[(def)].localCoverPath)

                            --add blank icon to all
                            file.icon = imgCoverTmp
                            file.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file.icon) 
                            table.insert(files_table, count_of_systems, file.apptitle)

                        end

                end


                -- Scan Sub Folders
                if file.directory then
                    file_subfolder = System.listDirectory((SystemsToScan[(def)].romFolder .. "/" .. file.name))
                    for i, file_subfolder in pairs(file_subfolder) do
                        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
                        if not file_subfolder.directory 
                            and string.match(file_subfolder.name, "%.cue")
                            or string.match(file_subfolder.name, "%.img")
                            or string.match(file_subfolder.name, "%.mdf")
                            or string.match(file_subfolder.name, "%.toc")
                            or string.match(file_subfolder.name, "%.cbn")
                            or string.match(file_subfolder.name, "%.m3u")
                            or string.match(file_subfolder.name, "%.ccd")
                            or string.match(file_subfolder.name, "%.pbp")
                            or string.match(file_subfolder.name, "%.PBP")
                            -- and string.match(file_subfolder.name, "%.") -- has an extension
                            and not string.match(file_subfolder.name, "eboot.pbp") 
                            and not string.match(file_subfolder.name, "EBOOT.PBP")
                            and not string.match(file_subfolder.name, "Thumbs%.db") 
                            and not string.match(file_subfolder.name, "DS_Store") 
                            and not string.match(file_subfolder.name, "%.sav") 
                            and not string.match(file_subfolder.name, "%.srm") 
                            and not string.match(file_subfolder.name, "%.mpk") 
                            and not string.match(file_subfolder.name, "%.eep") 
                            and not string.match(file_subfolder.name, "%.st0") 
                            and not string.match(file_subfolder.name, "%.sta") 
                            and not string.match(file_subfolder.name, "%.sr0") 
                            and not string.match(file_subfolder.name, "%.ss0") 
                            and not string.match(file_subfolder.name, "%._") then

                                if string.match(file_subfolder.name, "%.pbp") or string.match(file_subfolder.name, "%.PBP") then



                                    if sfo_scan_retroarch_db[file_subfolder.name] ~= nil then

                                        -- check if game is in the favorites list
                                        if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                            if string.find(strFav, file_subfolder.name,1,true) ~= nil then
                                                file_subfolder.favourite = true
                                            else
                                                file_subfolder.favourite = false
                                            end
                                        end

                                        file_subfolder.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name .. "/" .. file_subfolder.name)
                                        file_subfolder.date_played = 0
                                        file_subfolder.app_type = 3
                                        file_subfolder.app_type_default = 3


                                        romname_withExtension = file_subfolder.name

                                        -- import map_onelua_sfos(sfo_scan_retroarch_db)
                                        romname_withExtension = tostring(file_subfolder.name)
                                        info = sfo_scan_retroarch_db[romname_withExtension].title
                                        app_title = sfo_scan_retroarch_db[romname_withExtension].title
                                        file_subfolder.filename = romname_withExtension
                                        file_subfolder.name = sfo_scan_retroarch_db[romname_withExtension].titleid
                                        file_subfolder.title = sfo_scan_retroarch_db[romname_withExtension].title
                                        file_subfolder.name_online = sfo_scan_retroarch_db[romname_withExtension].titleid
                                        file_subfolder.version = sfo_scan_retroarch_db[romname_withExtension].region
                                        file_subfolder.name_title_search = sfo_scan_retroarch_db[romname_withExtension].title
                                        file_subfolder.apptitle = sfo_scan_retroarch_db[romname_withExtension].title

                                        -- Check for renamed game names
                                        if #renamed_games_table ~= nil then
                                            local key = find_game_table_pos_key(renamed_games_table, file_subfolder.name)
                                            if key ~= nil then
                                              -- Yes - Find in files table
                                              app_title = renamed_games_table[key].title
                                              file_subfolder.title = renamed_games_table[key].title
                                              file_subfolder.apptitle = renamed_games_table[key].title
                                            else
                                              -- No
                                            end
                                        else
                                        end

                                        -- Check for hidden game names
                                        file_subfolder.hidden = check_for_hidden_tag_on_scan(file_subfolder.name, file_subfolder.app_type)

                                        custom_path = (SystemsToScan[(def)].localCoverPath) .. app_title .. ".png"
                                        custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png"

                                        file_subfolder.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                                        file_subfolder.cover_path_local = (SystemsToScan[(def)].localCoverPath)
                                        file_subfolder.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                                        file_subfolder.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)

                                        if custom_path and System.doesFileExist(custom_path) then
                                            img_path = (SystemsToScan[(def)].localCoverPath) .. app_title .. ".png" --custom cover by app name
                                        elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                            img_path = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png" --custom cover by app id
                                        else
                                            if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                                img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                                            else
                                                img_path = "app0:/DATA/noimg.png" --blank grey
                                            end
                                        end

                                        table.insert(folders_table, file_subfolder)
                                        table.insert((def_table_name), file_subfolder)

                                        table.insert(files_table, count_of_systems, file_subfolder.app_type) 
                                        table.insert(files_table, count_of_systems, file_subfolder.name)
                                        table.insert(files_table, count_of_systems, file_subfolder.title)
                                        table.insert(files_table, count_of_systems, file_subfolder.name_online)
                                        table.insert(files_table, count_of_systems, file_subfolder.version)

                                        --add blank icon to all
                                        file_subfolder.icon = imgCoverTmp
                                        file_subfolder.icon_path = img_path
                                        
                                        table.insert(files_table, count_of_systems, file_subfolder.icon) 
                                        table.insert(files_table, count_of_systems, file_subfolder.apptitle)


                                    else

                                        -- check if game is in the favorites list
                                        if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                            if string.find(strFav, file_subfolder.name,1,true) ~= nil then
                                                file_subfolder.favourite = true
                                            else
                                                file_subfolder.favourite = false
                                            end
                                        end

                                        file_subfolder.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name .. "/" .. file_subfolder.name)

                                        romname_withExtension = file_subfolder.name
                                        cleanRomNames()
                                        info = romname_noRegion_noExtension
                                        app_title = romname_noRegion_noExtension
                                        

                                        file_subfolder.filename = file_subfolder.name
                                        file_subfolder.name = romname_noExtension
                                        file_subfolder.title = romname_noRegion_noExtension
                                        file_subfolder.name_online = romname_url_encoded
                                        file_subfolder.version = romname_region
                                        file_subfolder.apptitle = romname_noRegion_noExtension
                                        file_subfolder.date_played = 0
                                        file_subfolder.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                                        file_subfolder.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                                        file_subfolder.app_type = 3
                                        file_subfolder.app_type_default = 3

                                        -- Check for renamed game names
                                        if #renamed_games_table ~= nil then
                                            local key = find_game_table_pos_key(renamed_games_table, file_subfolder.name)
                                            if key ~= nil then
                                              -- Yes - Find in files table
                                              app_title = renamed_games_table[key].title
                                              file_subfolder.title = renamed_games_table[key].title
                                              file_subfolder.apptitle = renamed_games_table[key].title
                                            else
                                              -- No
                                            end
                                        else
                                        end

                                        -- Check for hidden game names
                                        file_subfolder.hidden = check_for_hidden_tag_on_scan(file_subfolder.name, file_subfolder.app_type)

                                        custom_path = (SystemsToScan[(def)].localCoverPath) .. app_title .. ".png"
                                        custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png"

                                        if custom_path and System.doesFileExist(custom_path) then
                                            img_path = (SystemsToScan[(def)].localCoverPath) .. app_title .. ".png" --custom cover by app name
                                        elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                            img_path = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png" --custom cover by app id
                                        else
                                            if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                                img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                                            else
                                                img_path = "app0:/DATA/noimg.png" --blank grey
                                            end
                                        end

                                        update_loading_screen_progress()

                                        table.insert(folders_table, file_subfolder)
                                        table.insert((def_table_name), file_subfolder)

                                        table.insert(files_table, count_of_systems, file_subfolder.app_type) 
                                        table.insert(files_table, count_of_systems, file_subfolder.name)
                                        table.insert(files_table, count_of_systems, file_subfolder.title)
                                        table.insert(files_table, count_of_systems, file_subfolder.name_online)
                                        table.insert(files_table, count_of_systems, file_subfolder.version)

                                        file_subfolder.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                                        file_subfolder.cover_path_local = (SystemsToScan[(def)].localCoverPath)

                                        --add blank icon to all
                                        file_subfolder.icon = imgCoverTmp
                                        file_subfolder.icon_path = img_path
                                        
                                        table.insert(files_table, count_of_systems, file_subfolder.icon) 
                                        table.insert(files_table, count_of_systems, file_subfolder.apptitle)
                                    end
                                else

                                    -- check if game is in the favorites list
                                    if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                        if string.find(strFav, file_subfolder.name,1,true) ~= nil then
                                            file_subfolder.favourite = true
                                        else
                                            file_subfolder.favourite = false
                                        end
                                    end

                                    file_subfolder.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name .. "/" .. file_subfolder.name)

                                    romname_withExtension = file_subfolder.name
                                    cleanRomNames()
                                    info = romname_noRegion_noExtension
                                    app_title = romname_noExtension
                                    

                                    file_subfolder.filename = file_subfolder.name
                                    file_subfolder.name = romname_noExtension
                                    file_subfolder.title = romname_noRegion_noExtension
                                    file_subfolder.name_online = romname_url_encoded
                                    file_subfolder.version = romname_region
                                    file_subfolder.apptitle = romname_noRegion_noExtension
                                    file_subfolder.date_played = 0
                                    file_subfolder.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                                    file_subfolder.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                                    file_subfolder.app_type = 3
                                    file_subfolder.app_type_default = 3

                                    -- Check for renamed game names
                                    if #renamed_games_table ~= nil then
                                        local key = find_game_table_pos_key(renamed_games_table, file_subfolder.name)
                                        if key ~= nil then
                                          -- Yes - Find in files table
                                          file_subfolder.title = renamed_games_table[key].title
                                          file_subfolder.apptitle = renamed_games_table[key].title
                                        else
                                          -- No
                                        end
                                    else
                                    end


                                    -- Check for hidden game names
                                    file_subfolder.hidden = check_for_hidden_tag_on_scan(file_subfolder.name, file_subfolder.app_type)

                                    custom_path = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.title .. ".png"
                                    custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png"

                                    if custom_path and System.doesFileExist(custom_path) then
                                        img_path = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.title .. ".png" --custom cover by app name
                                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                        img_path = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png" --custom cover by app id
                                    else
                                        if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                            img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                                        else
                                            img_path = "app0:/DATA/noimg.png" --blank grey
                                        end
                                    end

                                    table.insert(folders_table, file_subfolder)
                                    table.insert((def_table_name), file_subfolder)

                                    table.insert(files_table, count_of_systems, file_subfolder.app_type) 
                                    table.insert(files_table, count_of_systems, file_subfolder.name)
                                    table.insert(files_table, count_of_systems, file_subfolder.title)
                                    table.insert(files_table, count_of_systems, file_subfolder.name_online)
                                    table.insert(files_table, count_of_systems, file_subfolder.version)

                                    file_subfolder.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                                    file_subfolder.cover_path_local = (SystemsToScan[(def)].localCoverPath)

                                    --add blank icon to all
                                    file_subfolder.icon = imgCoverTmp
                                    file_subfolder.icon_path = img_path
                                    
                                    table.insert(files_table, count_of_systems, file_subfolder.icon) 
                                    table.insert(files_table, count_of_systems, file_subfolder.apptitle)

                                end

                        end
                    end
                end

            end
        
        else
        end
    end

    function Scan_Rom_Simple(def, def_table_name)

        if System.doesDirExist(SystemsToScan[(def)].romFolder) then

            files = System.listDirectory((SystemsToScan[(def)].romFolder))
            for i, file in pairs(files) do
                local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
                -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
                if not file.directory
                    and string.match(file.name, "%.") -- has an extension
                    and not string.match(file.name, "Thumbs%.db") 
                    and not string.match(file.name, "DS_Store") 
                    and not string.match(file.name, "%.sav") 
                    and not string.match(file.name, "%.srm") 
                    and not string.match(file.name, "%.mpk") 
                    and not string.match(file.name, "%.eep") 
                    and not string.match(file.name, "%.st0") 
                    and not string.match(file.name, "%.sta") 
                    and not string.match(file.name, "%.sr0") 
                    and not string.match(file.name, "%.ss0") 
                    and not string.match(file.name, "%._") then

                    -- check if game is in the favorites list
                    if System.doesFileExist(cur_dir .. "/favorites.dat") then
                        if string.find(strFav, file.name,1,true) ~= nil then
                            file.favourite = true
                        else
                            file.favourite = false
                        end
                    end

                    file.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name)

                    romname_withExtension = file.name
                    cleanRomNames()
                    info = romname_noRegion_noExtension
                    app_title = romname_noRegion_noExtension
                    
                    table.insert(folders_table, file)
                    --table.insert(games_table, file)

                    file.filename = file.name
                    file.name = romname_noExtension
                    file.title = romname_noRegion_noExtension
                    file.name_online = romname_url_encoded
                    file.version = romname_region
                    file.apptitle = romname_noRegion_noExtension
                    file.date_played = 0
                    file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                    file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                    file.app_type=((def))
                    file.app_type_default=((def))

                    -- Check for renamed game names
                    if #renamed_games_table ~= nil then
                        local key = find_game_table_pos_key(renamed_games_table, file.name)
                        if key ~= nil then
                          -- Yes - Find in files table
                          app_title = renamed_games_table[key].title
                          file.title = renamed_games_table[key].title
                          file.apptitle = renamed_games_table[key].title
                        else
                          -- No
                        end
                    else
                    end

                    -- Check for hidden game names
                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                    custom_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png"
                    custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png"

                    table.insert((def_table_name), file)

                    update_loading_screen_progress()

                    if custom_path and System.doesFileExist(custom_path) then
                        img_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png" --custom cover by app name
                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                        img_path = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png" --custom cover by app id
                    else
                        if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                            img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                        else
                            img_path = "app0:/DATA/noimg.png" --blank grey
                        end
                    end

                    table.insert(files_table, count_of_systems, file.app_type) 
                    table.insert(files_table, count_of_systems, file.name)
                    table.insert(files_table, count_of_systems, file.title)
                    table.insert(files_table, count_of_systems, file.name_online)
                    table.insert(files_table, count_of_systems, file.version)

                    file.app_type=((def))
                    file.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                    file.cover_path_local = (SystemsToScan[(def)].localCoverPath)

                    --add blank icon to all
                    file.icon = imgCoverTmp
                    file.icon_path = img_path
                    
                    table.insert(files_table, count_of_systems, file.icon) 
                    
                    table.insert(files_table, count_of_systems, file.apptitle) 

                end
            end
        
        else
        end
    end

    function Scan_Rom_Filter(def, def_table_name, def_filter)

        if System.doesDirExist(SystemsToScan[(def)].romFolder) then

            files = System.listDirectory((SystemsToScan[(def)].romFolder))
            for i, file in pairs(files) do
                local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
                -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
                if not file.directory and string.match(file.name, (def_filter)) 
                    and string.match(file.name, "%.") -- has an extension
                    and not string.match(file.name, "Thumbs%.db") 
                    and not string.match(file.name, "DS_Store") 
                    and not string.match(file.name, "%.sav") 
                    and not string.match(file.name, "%.srm") 
                    and not string.match(file.name, "%.mpk") 
                    and not string.match(file.name, "%.eep") 
                    and not string.match(file.name, "%.st0") 
                    and not string.match(file.name, "%.sta") 
                    and not string.match(file.name, "%.sr0") 
                    and not string.match(file.name, "%.ss0") 
                    and not string.match(file.name, "%._") then

                    -- check if game is in the favorites list
                    if System.doesFileExist(cur_dir .. "/favorites.dat") then
                        if string.find(strFav, file.name,1,true) ~= nil then
                            file.favourite = true
                        else
                            file.favourite = false
                        end
                    end

                    file.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name)

                    romname_withExtension = file.name
                    cleanRomNames()
                    info = romname_noRegion_noExtension
                    app_title = romname_noRegion_noExtension
                    
                    
                    --table.insert(games_table, file)
                
                    file.filename = file.name
                    file.name = romname_noExtension
                    file.title = romname_noRegion_noExtension
                    file.name_online = romname_url_encoded
                    file.version = romname_region
                    file.apptitle = romname_noRegion_noExtension
                    file.date_played = 0
                    file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                    file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                    file.app_type=((def))
                    file.app_type_default=((def))

                    -- Check for renamed game names
                    if #renamed_games_table ~= nil then
                        local key = find_game_table_pos_key(renamed_games_table, file.name)
                        if key ~= nil then
                          -- Yes - Find in files table
                          app_title = renamed_games_table[key].title
                          file.title = renamed_games_table[key].title
                          file.apptitle = renamed_games_table[key].title
                        else
                          -- No
                        end
                    else
                    end

                    -- Check for hidden game names
                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                    custom_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png"
                    custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png"

                    if custom_path and System.doesFileExist(custom_path) then
                        img_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png" --custom cover by app name
                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                        img_path = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png" --custom cover by app id
                    else
                        if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                            img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                        else
                            img_path = "app0:/DATA/noimg.png" --blank grey
                        end
                    end

                    table.insert(folders_table, file)
                    table.insert((def_table_name), file)

                    update_loading_screen_progress()

                    table.insert(files_table, count_of_systems, file.app_type) 
                    table.insert(files_table, count_of_systems, file.name)
                    table.insert(files_table, count_of_systems, file.title)
                    table.insert(files_table, count_of_systems, file.name_online)
                    table.insert(files_table, count_of_systems, file.version)

                    file.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                    file.cover_path_local = (SystemsToScan[(def)].localCoverPath)

                    --add blank icon to all
                    file.icon = imgCoverTmp
                    file.icon_path = img_path
                    
                    table.insert(files_table, count_of_systems, file.icon) 
                    table.insert(files_table, count_of_systems, file.apptitle) 

                end

                -- Scan Sub Folders
                if file.directory then
                    file_subfolder = System.listDirectory((SystemsToScan[(def)].romFolder .. "/" .. file.name))
                    for i, file_subfolder in pairs(file_subfolder) do
                        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
                        if not file_subfolder.directory and string.match(file_subfolder.name, (def_filter)) 
                            and string.match(file_subfolder.name, "%.") -- has an extension
                            and not string.match(file_subfolder.name, "Thumbs%.db") 
                            and not string.match(file_subfolder.name, "DS_Store") 
                            and not string.match(file_subfolder.name, "%.sav") 
                            and not string.match(file_subfolder.name, "%.srm") 
                            and not string.match(file_subfolder.name, "%.mpk") 
                            and not string.match(file_subfolder.name, "%.eep") 
                            and not string.match(file_subfolder.name, "%.st0") 
                            and not string.match(file_subfolder.name, "%.sta") 
                            and not string.match(file_subfolder.name, "%.sr0") 
                            and not string.match(file_subfolder.name, "%.ss0") 
                            and not string.match(file_subfolder.name, "%._") then

                            -- check if game is in the favorites list
                            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                                if string.find(strFav, file_subfolder.name,1,true) ~= nil then
                                    file_subfolder.favourite = true
                                else
                                    file_subfolder.favourite = false
                                end
                            end

                            file_subfolder.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name .. "/" .. file_subfolder.name)

                            romname_withExtension = file_subfolder.name
                            cleanRomNames()
                            info = romname_noRegion_noExtension
                            app_title = romname_noRegion_noExtension
                            

                            file_subfolder.filename = file_subfolder.name
                            file_subfolder.name = romname_noExtension
                            file_subfolder.title = romname_noRegion_noExtension
                            file_subfolder.name_online = romname_url_encoded
                            file_subfolder.version = romname_region
                            file_subfolder.apptitle = romname_noRegion_noExtension
                            file_subfolder.date_played = 0
                            file_subfolder.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                            file_subfolder.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                            file_subfolder.app_type=((def))
                            file_subfolder.app_type_default=((def))

                            -- Check for renamed game names
                            if #renamed_games_table ~= nil then
                                local key = find_game_table_pos_key(renamed_games_table, file_subfolder.name)
                                if key ~= nil then
                                  -- Yes - Find in files table
                                  app_title = renamed_games_table[key].title
                                  file_subfolder.title = renamed_games_table[key].title
                                  file_subfolder.apptitle = renamed_games_table[key].title
                                else
                                  -- No
                                end
                            else
                            end

                            -- Check for hidden game names
                            file_subfolder.hidden = check_for_hidden_tag_on_scan(file_subfolder.name, file_subfolder.app_type)

                            custom_path = (SystemsToScan[(def)].localCoverPath) .. app_title .. ".png"
                            custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png"

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = (SystemsToScan[(def)].localCoverPath) .. app_title .. ".png" --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = (SystemsToScan[(def)].localCoverPath) .. file_subfolder.name .. ".png" --custom cover by app id
                            else
                                if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                    img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                            table.insert(folders_table, file_subfolder)
                            table.insert((def_table_name), file_subfolder)

                            update_loading_screen_progress()

                            table.insert(files_table, count_of_systems, file_subfolder.app_type) 
                            table.insert(files_table, count_of_systems, file_subfolder.name)
                            table.insert(files_table, count_of_systems, file_subfolder.title)
                            table.insert(files_table, count_of_systems, file_subfolder.name_online)
                            table.insert(files_table, count_of_systems, file_subfolder.version)

                            file_subfolder.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                            file_subfolder.cover_path_local = (SystemsToScan[(def)].localCoverPath)

                            --add blank icon to all
                            file_subfolder.icon = imgCoverTmp
                            file_subfolder.icon_path = img_path
                            
                            table.insert(files_table, count_of_systems, file_subfolder.icon) 
                        
                            table.insert(files_table, count_of_systems, file_subfolder.apptitle) 

                        end
                    end
                end

            end
        
        else
        end
    end

    function Scan_Rom_DB_Lookup(def, def_table_name, def_user_db_file, def_sql_db_file)

        if System.doesDirExist(SystemsToScan[(def)].romFolder) then

            files = System.listDirectory((SystemsToScan[(def)].romFolder))

            for i, file in pairs(files) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
            if not file.directory and not string.match(file.name, "neogeo") 
                and string.match(file.name, "%.") -- has an extension
                and not string.match(file.name, "Thumbs%.db") 
                and not string.match(file.name, "%.sav") 
                and not string.match(file.name, "%.srm") 
                and not string.match(file.name, "%.mpk") 
                and not string.match(file.name, "%.eep") 
                and not string.match(file.name, "%.st0") 
                and not string.match(file.name, "%.sta") 
                and not string.match(file.name, "%.sr0") 
                and not string.match(file.name, "%.ss0")
                and not string.match(file.name, "DS_Store") 
                and not string.match(file.name, "%._") then

                    -- check if game is in the favorites list
                    if System.doesFileExist(cur_dir .. "/favorites.dat") then
                        if string.find(strFav, file.name,1,true) ~= nil then
                            file.favourite = true
                        else
                            file.favourite = false
                        end
                    end

                    file.game_path = ((SystemsToScan[(def)].romFolder) .. "/" .. file.name)

                    romname_withExtension = file.name
                    romname_noExtension = {}
                    romname_noExtension = romname_withExtension:match("(.+)%..+$")

                    -- LOOKUP TITLE ID: Get game name based on titleID, search saved table of data, or sql table of data if titleID not found

                    -- Load previous matches
                    if System.doesFileExist(user_DB_Folder .. (def_user_db_file)) then
                        database_rename_PSP = user_DB_Folder .. (def_user_db_file)
                        pspdb = dofile(database_rename_PSP)
                    else
                        pspdb = {}
                    end

                    -- Check if scanned titleID is a saved match
                    psp_search = pspdb[romname_noExtension]

                    -- If no
                    if psp_search == nil then

                        -- Load the full sql database to find the new titleID

                        if System.doesFileExist(cur_dir .. "/DATABASES/" .. (def_sql_db_file)) then
                            db = Database.open(cur_dir .. "/DATABASES/" .. (def_sql_db_file))

                            sql_db_search_mame = "\"" .. romname_noExtension .. "\""
                            search_term = "SELECT title FROM games where filename is "  .. sql_db_search_mame
                            sql_db_search_result = Database.execQuery(db, search_term)

                            if next(sql_db_search_result) == nil then
                                -- Not found; use the name without adding a game name
                                title = romname_noExtension
                            else
                                -- Found; use the game name from the full database
                                title = sql_db_search_result[1].title
                            end
                            Database.close(db)

                        else
                        end

                    -- If found; use the game name from the saved match
                    else
                        title = pspdb[romname_noExtension].name
                    end

                    romname_noRegion_noExtension = {}
                    romname_noRegion_noExtension = title:gsub('%b()', '')

                    -- Check if name contains parenthesis, if yes strip out to show as version
                    if string.find(title, "%(") and string.find(title, "%)") then
                        -- Remove all text except for within "()"
                        romname_region_initial = {}
                        romname_region_initial = title:match("%((.+)%)")

                        -- Tidy up remainder when more than one set of parenthesis used, replace  ") (" with ", "
                        romname_region = {}
                        romname_region = romname_region_initial:gsub("%) %(", ', ')
                    -- If no parenthesis, then add blank to prevent nil error
                    else
                        romname_region = " "
                    end

                    --end of function

                    info = romname_noRegion_noExtension
                    app_title = romname_noRegion_noExtension
                    
                    if not string.match(title, "bios") and not string.match(title, "Bios") and not string.match(title, "BIOS") then
                        table.insert(folders_table, file)
                    else
                    end
                    --table.insert(games_table, file)

                    -- file.filename = file.name
                    file.filename = file.name
                    file.name = romname_noExtension
                    file.title = romname_noRegion_noExtension
                    file.name_online = romname_noExtension
                    file.version = romname_region
                    file.name_title_search = title
                    file.apptitle = romname_noRegion_noExtension
                    file.date_played = 0
                    file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                    file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                    file.app_type=((def))
                    file.app_type_default=((def))

                    custom_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png"
                    custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png"

                    -- Check for renamed game names
                    if #renamed_games_table ~= nil then
                        local key = find_game_table_pos_key(renamed_games_table, file.name)
                        if key ~= nil then
                          -- Yes - Found in files table
                          file.title = renamed_games_table[key].title
                          file.apptitle = renamed_games_table[key].title
                        else
                          -- No
                        end
                    else
                    end

                    -- Check for hidden game names
                    file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)


                    if not string.match(title, "bios") and not string.match(title, "Bios") and not string.match(title, "BIOS") then
                        table.insert((def_table_name), file)

                        update_loading_screen_progress()
                    else
                    end


                    if custom_path and System.doesFileExist(custom_path) then
                        img_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png" --custom cover by app name
                    elseif custom_path_id and System.doesFileExist(custom_path_id) then
                        img_path = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png" --custom cover by app id
                    else
                        if System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                            img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                        else
                            img_path = "app0:/DATA/noimg.png" --blank grey
                        end
                    end

                    -- if not string.match(title, "bios") and not string.match(title, "Bios") and not string.match(title, "BIOS") then
                    --     table.insert(files_table, count_of_systems, file.app_type) 
                    --     table.insert(files_table, count_of_systems, file.name)
                    --     table.insert(files_table, count_of_systems, file.title)
                    --     table.insert(files_table, count_of_systems, file.name_online)
                    --     table.insert(files_table, count_of_systems, file.version)
                    --     table.insert(files_table, count_of_systems, file.name_title_search)
                    -- else
                    -- end
                    
                    file.app_type=((def))
                    file.app_type_default=((def))

                    -- file.filename = file.name
                    file.filename = romname_withExtension
                    file.name = romname_noExtension
                    file.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                    file.cover_path_local = (SystemsToScan[(def)].localCoverPath)
                    file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                    file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)

                    --add blank icon to all
                    file.icon = imgCoverTmp
                    file.icon_path = img_path
                    
                    if not string.match(title, "bios") and not string.match(title, "Bios") and not string.match(title, "BIOS") then
                        table.insert(files_table, count_of_systems, file.icon) 
                        table.insert(files_table, count_of_systems, file.apptitle) 
                    else
                    end

                end
            end

            -- LOOKUP TITLE ID: Delete old file and save new list of matches
            if not System.doesFileExist(user_DB_Folder .. (def_user_db_file)) then
                CreateUserTitleTable_for_File((def_user_db_file), (def_table_name))
            else
                System.deleteFile(user_DB_Folder .. (def_user_db_file))
                CreateUserTitleTable_for_File((def_user_db_file), (def_table_name))
            end

        else
        end
    end

    function Scan_PSM_DB_Lookup(def, def_table_name, def_user_db_file, def_sql_db_file)

        local psm_directory = "ux0:/psm"
        if System.doesDirExist(psm_directory) then

            files = System.listDirectory(psm_directory)

            for i, file in pairs(files) do
            local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
                -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
            if file.directory 
                and string.match(file.name, "NPNA") 
                or string.match(file.name, "NPOA")
                or string.match(file.name, "NPPA") then

                    local psm_bubble_installed = false

                    -- check if game is in the favorites list
                    if System.doesFileExist(cur_dir .. "/favorites.dat") then
                        if string.find(strFav, file.name,1,true) ~= nil then
                            file.favourite = true
                        else
                            file.favourite = false
                        end
                    end

                    file.game_path = psm_directory .. "/" .. file.name

                    file.titleid = tostring(file.name)

                    -- LOOKUP TITLE ID: Get game name based on titleID, search saved table of data, or sql table of data if titleID not found

                    -- Load previous matches
                    if System.doesFileExist(user_DB_Folder .. (def_user_db_file)) then
                        database_rename_PSM = user_DB_Folder .. (def_user_db_file)
                        psmdb = dofile(database_rename_PSM)
                    else
                        psmdb = {}
                    end

                    -- Check if scanned titleID is a saved match
                    psm_search = psmdb[file.name]

                    -- If no
                    if psm_search == nil then

                        -- Load the full sql database to find the new titleID

                        db = Database.open("ur0:shell/db/app.db")

                        sql_db_search_mame = "\"" .. file.name .. "\""
                        local query_string = "SELECT title FROM tbl_appinfo_icon where titleid is "  .. sql_db_search_mame
                        sql_db_search_result = Database.execQuery(db, query_string)

                        if next(sql_db_search_result) == nil then
                            -- Not found; use the name without adding a game name
                            title = file.name
                        else
                            -- Found; use the game name from the full database
                            psm_bubble_installed = true
                            title = sql_db_search_result[1].title
                        end
                        Database.close(db)


                        db = Database.open("ur0:shell/db/app.db")

                        sql_db_search_mame = "\"" .. file.name .. "\""
                        local query_string = "SELECT val FROM tbl_appinfo where key=3168212510 and (tbl_appinfo.titleID is  " .. sql_db_search_mame .. ")"
                        sql_db_search_result = Database.execQuery(db, query_string)

                        if next(sql_db_search_result) == nil then
                            -- Not found; use the name without adding a game name
                            version = " "
                        else
                            -- Found; use the game name from the full database
                            version = sql_db_search_result[1].val
                        end
                        Database.close(db)


                    -- If found; use the game name from the saved match
                    else
                        psm_bubble_installed = true
                        title = psmdb[file.name].title
                        version = psmdb[file.name].version
                    end
                    
                    if psm_bubble_installed == true then
                        table.insert(folders_table, file)

                        -- file.filename = file.name
                        file.filename = file.name
                        file.name = file.name
                        file.title = title
                        file.name_online = file.name
                        file.version = version
                        file.name_title_search = file.name
                        file.apptitle = title
                        file.date_played = 0
                        file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                        file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)
                        file.app_type=((def))
                        file.app_type_default=((def))

                        custom_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png"
                        custom_path_id = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png"

                        -- Check for renamed game names
                        if #renamed_games_table ~= nil then
                            local key = find_game_table_pos_key(renamed_games_table, file.name)
                            if key ~= nil then
                              -- Yes - Found in files table
                              file.title = renamed_games_table[key].title
                              file.apptitle = renamed_games_table[key].title
                            else
                              -- No
                            end
                        else
                        end

                        -- Check for hidden game names
                        file.hidden = check_for_hidden_tag_on_scan(file.name, file.app_type)

                        table.insert((def_table_name), file)
                        update_loading_screen_progress()

                        if custom_path and System.doesFileExist(custom_path) then
                            img_path = (SystemsToScan[(def)].localCoverPath) .. file.title .. ".png" --custom cover by app name
                        elseif custom_path_id and System.doesFileExist(custom_path_id) then
                            img_path = (SystemsToScan[(def)].localCoverPath) .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ur0:appmeta/" .. file.name .. "/pic0.png") then
                                img_path = "ur0:appmeta/" .. file.name .. "/pic0.png"  --app icon
                            elseif System.doesFileExist("app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)) then
                                img_path = "app0:/DATA/" .. (SystemsToScan[(def)].Missing_Cover)  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                        
                        file.app_type=((def))
                        file.app_type_default=((def))

                        -- file.filename = file.name 
                        file.filename = file.titleid
                        file.name = file.titleid
                        file.cover_path_online = (SystemsToScan[(def)].onlineCoverPathSystem)
                        file.cover_path_local = (SystemsToScan[(def)].localCoverPath)
                        file.snap_path_local = (SystemsToScan[(def)].localSnapPath)
                        file.snap_path_online = (SystemsToScan[(def)].onlineSnapPathSystem)

                        --add blank icon to all
                        file.icon = imgCoverTmp
                        file.icon_path = img_path
                        
                        table.insert(files_table, count_of_systems, file.icon) 
                        table.insert(files_table, count_of_systems, file.apptitle)

                    else
                    end

                end
            end

            -- LOOKUP TITLE ID: Delete old file and save new list of matches
            if not System.doesFileExist(user_DB_Folder .. (def_user_db_file)) then
                CreateUserTitleTable_for_PSM((def_user_db_file), (def_table_name))
            else
                System.deleteFile(user_DB_Folder .. (def_user_db_file))
                CreateUserTitleTable_for_PSM((def_user_db_file), (def_table_name))
            end

        else
        end
    end
    
    -- SCAN ROMS
    -- Scan_Type        (def,  def_table_name)
    scan_Rom_PS1_Eboot  (SystemsToScan[4].romFolder, "psx.lua") -- Retroarch rom folder
    Scan_Rom_PS1        (4, psx_table)
    Scan_Rom_Simple     (5, n64_table)
    Scan_Rom_Simple     (6, snes_table)
    Scan_Rom_Simple     (7, nes_table)
    Scan_Rom_Simple     (8, gba_table)
    Scan_Rom_Simple     (9, gbc_table)
    Scan_Rom_Simple     (10, gb_table)
    Scan_Rom_Filter     (11, dreamcast_table, "%.cdi")
    Scan_Rom_Filter     (11, dreamcast_table, "%.gdi")
    Scan_Rom_Filter     (12, sega_cd_table, "%.chd")
    Scan_Rom_Filter     (12, sega_cd_table, "%.cue")
    Scan_Rom_Simple     (13, s32x_table)
    Scan_Rom_Simple     (14, md_table)
    Scan_Rom_Simple     (15, sms_table)
    Scan_Rom_Simple     (16, gg_table)
    Scan_Rom_Simple     (17, tg16_table)
    Scan_Rom_Filter     (18, tgcd_table, "%.cue")
    Scan_Rom_Filter     (18, tgcd_table, "%.chd")
    Scan_Rom_Simple     (19, pce_table)
    Scan_Rom_Filter     (20, pcecd_table, "%.cue")
    Scan_Rom_Filter     (20, pcecd_table, "%.chd")
    Scan_Rom_Simple     (21, amiga_table)
    Scan_Rom_Simple     (22, c64_table)
    Scan_Rom_Simple     (23, wswan_col_table)
    Scan_Rom_Simple     (24, wswan_table)
    Scan_Rom_Simple     (25, msx2_table)
    Scan_Rom_Simple     (26, msx1_table)
    Scan_Rom_Simple     (27, zxs_table)
    Scan_Rom_Simple     (28, atari_7800_table)
    Scan_Rom_Simple     (29, atari_5200_table)
    Scan_Rom_Simple     (30, atari_2600_table)
    Scan_Rom_Simple     (31, atari_lynx_table)
    Scan_Rom_Simple     (32, colecovision_table)
    Scan_Rom_Simple     (33, vectrex_table)
    Scan_Rom_DB_Lookup  (34, fba_table, "fba_2012.lua", "fba_2012.db")
    Scan_Rom_DB_Lookup  (35, mame_2003_plus_table, "mame_2003_plus.lua", "mame_2003_plus.db")
    Scan_Rom_DB_Lookup  (36, mame_2000_table, "mame_2000.lua", "mame_2000.db")
    Scan_Rom_DB_Lookup  (37, neogeo_table, "neogeo.lua", "neogeo.db")
    Scan_Rom_Simple     (38, ngpc_table)
    Scan_PSM_DB_Lookup  (39, psm_table, "psm.lua")
  
    import_recently_played()
    update_md_regional_cover()
    update_dc_regional_cover()

    table.sort(files_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(folders_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(games_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(homebrews_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psp_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    table.sort(n64_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(snes_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(nes_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gba_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gbc_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gb_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(dreamcast_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(sega_cd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(s32x_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(md_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(sms_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gg_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tg16_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tgcd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pce_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pcecd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(amiga_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(c64_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(wswan_col_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(wswan_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(msx2_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(msx1_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(zxs_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_7800_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_5200_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_2600_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_lynx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(colecovision_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(vectrex_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(fba_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(mame_2003_plus_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(mame_2000_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(neogeo_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(ngpc_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psm_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    table.sort(recently_played_table, function(a, b) return (tonumber(a.date_played) > tonumber(b.date_played)) end)
    
    update_loading_screen_complete()

    -- CACHE ALL TABLES - PRINT AND SAVE
    cache_all_tables()

end


function import_cached_DB_tables(def_user_db_file, def_table_name)
    if System.doesFileExist(db_Cache_Folder .. (def_user_db_file)) then
        db_Cache = db_Cache_Folder .. (def_user_db_file)

        local db_import = {}
        db_import = dofile(db_Cache)

            for k, v in ipairs(db_import) do

                -- For each game to be imported, cross reference against then hidden games list
                for l, file in ipairs(hidden_games_table) do

                    -- Check the app type matches
                    if file.app_type == v.app_type then

                        -- Check if hidden game is in the import table
                        local key = {}
                        key = find_game_table_pos_key(db_import, file.name)

                        if key ~= nil then
                            -- Game found 
                            -- Update hidden key
                            if file.hidden == true then
                                db_import[key].hidden = true
                            else
                                db_import[key].hidden = false
                            end
                        else
                            -- Game not found
                            -- If showing hidden games, then check the game file / folder exists for adding to the import table
                            if showHidden==1 then
                                if v.directory == false then
                                    if System.doesFileExist(v.game_path) then
                                        table.insert(db_import, file)
                                    end
                                else
                                    if System.doesDirExist(v.game_path) then
                                        table.insert(db_import, file)
                                    end
                                end
                            else
                            end
                        end
                    else
                    end

                end

                -- If hiding games, only import non-hidden games
                if showHidden==0 then
                    if v.hidden==false then
                        table.insert(folders_table, v)
                        table.insert((def_table_name), v)

                        --add blank icon to all
                        v.icon = imgCoverTmp
                        v.icon_path = v.icon_path

                        v.apptitle = v.apptitle
                        table.insert(files_table, count_of_systems, v.apptitle)
                    else
                    end
                else
                    table.insert(folders_table, v)
                    table.insert((def_table_name), v)

                    --add blank icon to all
                    v.icon = imgCoverTmp
                    v.icon_path = v.icon_path

                    v.apptitle = v.apptitle
                    table.insert(files_table, count_of_systems, v.apptitle)
                end

            end
        
    end
end


function import_cached_DB()
    -- dir = System.listDirectory(dir)
    folders_table = {}
    files_table = {}
    games_table = {}
    homebrews_table = {}
    psp_table = {}
    psx_table = {}
    n64_table = {}
    snes_table = {}
    nes_table = {}
    gba_table = {}
    gbc_table = {}
    gb_table = {}
    dreamcast_table = {}
    sega_cd_table = {}
    s32x_table = {}
    md_table = {}
    sms_table = {}
    gg_table = {}
    tg16_table = {}
    tgcd_table = {}
    pce_table = {}
    pcecd_table = {}
    amiga_table = {}
    c64_table = {}
    wswan_col_table = {}
    wswan_table = {}
    msx2_table = {}
    msx1_table = {}
    zxs_table = {}
    atari_7800_table = {}
    atari_5200_table = {}
    atari_2600_table = {}
    atari_lynx_table = {}
    colecovision_table = {}
    vectrex_table = {}
    fba_table = {}
    mame_2003_plus_table = {}
    mame_2000_table = {}
    neogeo_table = {} 
    ngpc_table = {}
    psm_table = {}
    recently_played_table = {}
    search_results_table = {}
    fav_count = {}
    renamed_games_table = {}
    hidden_games_table = {}

    local file_over = System.openFile(cur_dir .. "/overrides.dat", FREAD)
    local filesize = System.sizeFile(file_over)
    local str = System.readFile(file_over, filesize)
    System.closeFile(file_over)

    import_renamed_games()
    import_hidden_games()

    import_cached_DB_tables("db_games.lua", games_table)
    if showHomebrews == 1 then
        import_cached_DB_tables("db_homebrews.lua", homebrews_table)
    else
    end
    import_cached_DB_tables("db_psp.lua", psp_table)
    import_cached_DB_tables("db_psx.lua", psx_table)
    import_cached_DB_tables("db_n64.lua", n64_table)
    import_cached_DB_tables("db_snes.lua", snes_table)
    import_cached_DB_tables("db_nes.lua", nes_table)
    import_cached_DB_tables("db_gba.lua", gba_table)
    import_cached_DB_tables("db_gbc.lua", gbc_table)
    import_cached_DB_tables("db_gb.lua", gb_table)
    import_cached_DB_tables("db_dreamcast.lua", dreamcast_table)
    import_cached_DB_tables("db_sega_cd.lua", sega_cd_table)
    import_cached_DB_tables("db_32x.lua", s32x_table)
    import_cached_DB_tables("db_md.lua", md_table)
    import_cached_DB_tables("db_sms.lua", sms_table)
    import_cached_DB_tables("db_gg.lua", gg_table)
    import_cached_DB_tables("db_tg16.lua", tg16_table)
    import_cached_DB_tables("db_tgcd.lua", tgcd_table)
    import_cached_DB_tables("db_pce.lua", pce_table)
    import_cached_DB_tables("db_pcecd.lua", pcecd_table)
    import_cached_DB_tables("db_amiga.lua", amiga_table)
    import_cached_DB_tables("db_c64.lua", c64_table)
    import_cached_DB_tables("db_wswan_col.lua", wswan_col_table)
    import_cached_DB_tables("db_wswan.lua", wswan_table)
    import_cached_DB_tables("db_msx2.lua", msx2_table)
    import_cached_DB_tables("db_msx1.lua", msx1_table)
    import_cached_DB_tables("db_zxs.lua", zxs_table)
    import_cached_DB_tables("db_atari_7800.lua", atari_7800_table)
    import_cached_DB_tables("db_atari_5200.lua", atari_5200_table)
    import_cached_DB_tables("db_atari_2600.lua", atari_2600_table)
    import_cached_DB_tables("db_atari_lynx.lua", atari_lynx_table)
    import_cached_DB_tables("db_colecovision.lua", colecovision_table)
    import_cached_DB_tables("db_vectrex.lua", vectrex_table)
    import_cached_DB_tables("db_fba.lua", fba_table)
    import_cached_DB_tables("db_mame_2003_plus.lua", mame_2003_plus_table)
    import_cached_DB_tables("db_mame_2000.lua", mame_2000_table)
    import_cached_DB_tables("db_neogeo.lua", neogeo_table)
    import_cached_DB_tables("db_ngpc.lua", ngpc_table)
    import_cached_DB_tables("db_psm.lua", psm_table)
    import_recently_played()
    update_md_regional_cover()
    update_dc_regional_cover()
    

    table.sort(files_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(folders_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(games_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(homebrews_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psp_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    table.sort(n64_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(snes_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(nes_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gba_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gbc_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gb_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(dreamcast_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(sega_cd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(s32x_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(md_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(sms_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gg_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tg16_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tgcd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pce_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pcecd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(amiga_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(c64_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(wswan_col_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(wswan_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(msx2_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(msx1_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(zxs_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_7800_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_5200_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_2600_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(atari_lynx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(colecovision_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(vectrex_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(fba_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(mame_2003_plus_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(mame_2000_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(neogeo_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(ngpc_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psm_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    table.sort(recently_played_table, function(a, b) return (tonumber(a.date_played) > tonumber(b.date_played)) end)

    return_table = TableConcat(folders_table, files_table)

    total_all = #files_table
    total_games = #games_table
    total_homebrews = #homebrews_table
    total_recently_played = #recently_played_table
    
    return return_table
end


function loadImage(img_path)
    imgTmp = Graphics.loadImage(img_path)
end


-- CHECK IF STARTUP SCAN IS ON
-- 0 Off, 1 On
if startupScan == 1 then
    -- Startup scan is ON

    -- Scan folders and games
    count_loading_tasks()
    files_table = listDirectory(System.currentDirectory())
    files_table = import_cached_DB()
else
    -- Startup scan is OFF

    -- Check cache files before importing, does the folder exist?
    if  System.doesDirExist(db_Cache_Folder) then

        -- Folder exists - Count files
        cache_file_count = System.listDirectory(db_Cache_Folder)
        if #cache_file_count ~= count_of_cache_files then
            -- Files missing - rescan
            count_loading_tasks()
            files_table = listDirectory(System.currentDirectory())
            files_table = import_cached_DB()
        else
            -- Files all pesent - Import Cached Database
            files_table = import_cached_DB()
        end
    else
        -- Folder missing - rescan
        count_loading_tasks()
        files_table = listDirectory(System.currentDirectory())
        files_table = import_cached_DB()
    end
end

function getAppSize(dir)
    local size = 0
    local function get_size(dir)
        local d = System.listDirectory(dir) or {}
        for _, v in ipairs(d) do
            if v.directory then
                get_size(dir .. "/" .. v.name)
            else
                size = size + v.size
            end
        end
    end
    get_size(dir)
    return size
end



function getRomSize()
    -- Get rom size in mb and kb for info screen
    local size = 0

    if System.doesFileExist(appdir) then
        tmpfile = System.openFile(appdir, FREAD)
        size = System.sizeFile(tmpfile)
        System.closeFile(tmpfile)

        if size < 900000 then -- Guessed at number, seems fine
            app_size = size/1024
            game_size = string.format("%02d", app_size) .. "Kb"
        else
            app_size = size/1024/1024
            game_size = string.format("%02d", app_size) .. "Mb"
        end
    else
        -- Error handling for missing game
        game_size = "0Kb"
    end
end


function wraptextlength(s, x, indent)
    --https://stackoverflow.com/questions/35006931/lua-line-breaks-in-strings
    x = x or 79
    indent = indent or ""
    local t = {""}
    local function cleanse(s) return s:gsub("@x%d%d%d",""):gsub("@r","") end

    for prefix, word, suffix, newline in s:gmatch("([ \t]*)(%S*)([ \t]*)(\n?)") do
        if #(cleanse(t[#t])) + #prefix + #cleanse(word) > x and #t > 0 then
            table.insert(t, word..suffix) -- add new element
        else -- add to the last element
            t[#t] = t[#t]..prefix..word..suffix
        end
        if #newline > 0 then 
            table.insert(t, "") 
        end
    end

    return indent..table.concat(t, "\n"..indent)
end

function GetPicPath(def_table_name)
    -- Get pic from backgrounds folder, or use default

    -- Check backgrounds folder
    if System.doesFileExist((def_table_name)[p].snap_path_local .. (def_table_name)[p].name .. ".png") then
        pic_path = (def_table_name)[p].snap_path_local .. (def_table_name)[p].name .. ".png"

    -- Not found? Then check ur0 pic
    elseif System.doesFileExist("ur0:/appmeta/" .. (def_table_name)[p].name .. "/pic0.png") then
        pic_path = "ur0:/appmeta/" .. (def_table_name)[p].name .. "/pic0.png"

    -- * Removed - causing errors for users, png encrypted?
    -- Still not found? Then check ux0 and use bg.png instead
    -- elseif System.doesFileExist("ux0:/app/" .. (def_table_name)[p].name .. "/sce_sys/livearea/contents/bg.png") then
    --     pic_path = "ux0:/app/" .. (def_table_name)[p].name .. "/sce_sys/livearea/contents/bg.png"

    -- * Removed - causing errors for users, png encrypted?
    -- Still not found? Then check ux0 and use bg0.png instead
    -- elseif System.doesFileExist("ux0:/app/" .. (def_table_name)[p].name .. "/sce_sys/livearea/contents/bg0.png") then
    --     pic_path = "ux0:/app/" .. (def_table_name)[p].name .. "/sce_sys/livearea/contents/bg0.png"

    -- Still not found? Are you kidding? Screw it, no background then
    else
        pic_path = ""
    end
end


function GetNameAndAppTypeSelected() -- Credit to BlackSheepBoy69 - This gives a massive performance boost VS reading whole app info.
    if #xCatLookup(showCat) > 0 then --if the currently-shown category isn't empty
        app_title = xCatLookup(showCat)[p].apptitle
        apptype = xCatLookup(showCat)[p].app_type -- needed for launching games from mixed categories
        filename = xCatLookup(showCat)[p].filename -- needed for adding to recent
        info = xCatLookup(showCat)[p].name -- added to fix error removing favs
    else
        app_title = "-"
    end

    if showCat == 42 and #search_results_table == 0 then
        app_title = lang_lines.Search_No_Results
    end

end

function GetInfoSelected()
    if showCat == 1 then
        if #games_table > 0 then
            info = games_table[p].name

            if string.match (games_table[p].game_path, "pspemu") or games_table[p].app_type_default == 3 then
                icon_path = "app0:/DATA/icon_psv.png"
            else
                icon_path = "ur0:/appmeta/" .. games_table[p].name .. "/icon0.png"
            end

            -- Get pic
            GetPicPath(games_table)

            app_title = games_table[p].title
            apptype = games_table[p].app_type
            appdir = games_table[p].game_path
            folder = games_table[p].directory
            filename = games_table[p].filename
            favourite_flag = games_table[p].favourite
            hide_game_flag = games_table[p].hidden
            game_path = games_table[p].game_path

            app_titleid = games_table[p].name
            app_version = games_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 2 then
        if #homebrews_table > 0 then
            info = homebrews_table[p].name
            icon_path = homebrews_table[p].icon_path

            -- if string.match (homebrews_table[p].icon_path, "pspemu") then
            --     icon_path = "app0:/DATA/icon_homebrew.png"
            -- else
            --     icon_path = homebrews_table[p].icon_path
            -- end

            -- Get pic
            GetPicPath(homebrews_table)

            app_title = homebrews_table[p].title
            apptype = homebrews_table[p].app_type
            appdir = homebrews_table[p].game_path
            folder = homebrews_table[p].directory
            filename = homebrews_table[p].filename
            favourite_flag = homebrews_table[p].favourite
            hide_game_flag = homebrews_table[p].hidden
            game_path = homebrews_table[p].game_path

            app_titleid = homebrews_table[p].name
            app_version = homebrews_table[p].version
        else
            app_title = "-"
        end

    elseif showCat == 3 then
        if #psp_table > 0 then
            info = psp_table[p].name
            icon_path = "app0:/DATA/icon_psp.png"
            pic_path = psp_table[p].snap_path_local .. psp_table[p].name .. ".png"
            app_title = psp_table[p].title
            apptype = psp_table[p].app_type
            appdir = psp_table[p].game_path
            folder = psp_table[p].directory
            filename = psp_table[p].filename
            favourite_flag = psp_table[p].favourite
            hide_game_flag = psp_table[p].hidden
            game_path = psp_table[p].game_path

            app_titleid = psp_table[p].name
            app_version = psp_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 4 then
        if #psx_table > 0 then
            info = psx_table[p].name
            icon_path = "app0:/DATA/icon_psx.png"
            pic_path = psx_table[p].snap_path_local .. psx_table[p].name .. ".png"
            app_title = psx_table[p].title
            apptype = psx_table[p].app_type
            appdir = psx_table[p].game_path
            folder = psx_table[p].directory
            filename = psx_table[p].filename
            favourite_flag = psx_table[p].favourite
            hide_game_flag = psx_table[p].hidden
            game_path = psx_table[p].game_path

            app_titleid = psx_table[p].name
            app_version = psx_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 5 then
        if #n64_table > 0 then
            info = n64_table[p].name            
            icon_path = "app0:/DATA/icon_n64.png"
            pic_path = n64_table[p].snap_path_local .. n64_table[p].name .. ".png"
            app_title = n64_table[p].title
            apptype = n64_table[p].app_type
            appdir = n64_table[p].game_path
            folder = n64_table[p].directory
            filename = n64_table[p].filename
            favourite_flag = n64_table[p].favourite
            hide_game_flag = n64_table[p].hidden
            game_path = n64_table[p].game_path

            app_titleid = n64_table[p].name
            app_version = n64_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 6 then
        if #snes_table > 0 then
            info = snes_table[p].name
            icon_path = "app0:/DATA/icon_snes.png"
            pic_path = snes_table[p].snap_path_local .. snes_table[p].name .. ".png"
            app_title = snes_table[p].title
            apptype = snes_table[p].app_type
            appdir = snes_table[p].game_path
            folder = snes_table[p].directory
            filename = snes_table[p].filename
            favourite_flag = snes_table[p].favourite
            hide_game_flag = snes_table[p].hidden
            game_path = snes_table[p].game_path

            app_titleid = snes_table[p].name
            app_version = snes_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 7 then
        if #nes_table > 0 then
            info = nes_table[p].name
            icon_path = "app0:/DATA/icon_nes.png"
            pic_path = nes_table[p].snap_path_local .. nes_table[p].name .. ".png"
            app_title = nes_table[p].title
            apptype = nes_table[p].app_type
            appdir = nes_table[p].game_path
            folder = nes_table[p].directory
            filename = nes_table[p].filename
            favourite_flag = nes_table[p].favourite
            hide_game_flag = nes_table[p].hidden
            game_path = nes_table[p].game_path

            app_titleid = nes_table[p].name
            app_version = nes_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 8 then
        if #gba_table > 0 then
            info = gba_table[p].name            
            icon_path = "app0:/DATA/icon_gba.png"
            pic_path = gba_table[p].snap_path_local .. gba_table[p].name .. ".png"
            app_title = gba_table[p].title
            apptype = gba_table[p].app_type
            appdir = gba_table[p].game_path
            folder = gba_table[p].directory
            filename = gba_table[p].filename
            favourite_flag = gba_table[p].favourite
            hide_game_flag = gba_table[p].hidden
            game_path = gba_table[p].game_path

            app_titleid = gba_table[p].name
            app_version = gba_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 9 then
        if #gbc_table > 0 then
            info = gbc_table[p].name            
            icon_path = "app0:/DATA/icon_gbc.png"
            pic_path = gbc_table[p].snap_path_local .. gbc_table[p].name .. ".png"
            app_title = gbc_table[p].title
            apptype = gbc_table[p].app_type
            appdir = gbc_table[p].game_path
            folder = gbc_table[p].directory
            filename = gbc_table[p].filename
            favourite_flag = gbc_table[p].favourite
            hide_game_flag = gbc_table[p].hidden
            game_path = gbc_table[p].game_path

            app_titleid = gbc_table[p].name
            app_version = gbc_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 10 then
        if #gb_table > 0 then
            info = gb_table[p].name            
            icon_path = "app0:/DATA/icon_gb.png"
            pic_path = gb_table[p].snap_path_local .. gb_table[p].name .. ".png"
            app_title = gb_table[p].title
            apptype = gb_table[p].app_type
            appdir = gb_table[p].game_path
            folder = gb_table[p].directory
            filename = gb_table[p].filename
            favourite_flag = gb_table[p].favourite
            hide_game_flag = gb_table[p].hidden
            game_path = gb_table[p].game_path

            app_titleid = gb_table[p].name
            app_version = gb_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 11 then
        if #dreamcast_table > 0 then
            info = dreamcast_table[p].name
            if setLanguage == 0 then -- EN - Blue logo
                icon_path = "app0:/DATA/icon_dreamcast_eur.png"
            elseif setLanguage == 1 then -- USA - Red logo
                icon_path = "app0:/DATA/icon_dreamcast_usa.png"
            elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
                icon_path = "app0:/DATA/icon_dreamcast_j.png"
            else -- Blue logo
                icon_path = "app0:/DATA/icon_dreamcast_eur.png"
            end
            pic_path = dreamcast_table[p].snap_path_local .. dreamcast_table[p].name .. ".png"
            app_title = dreamcast_table[p].title
            apptype = dreamcast_table[p].app_type
            appdir = dreamcast_table[p].game_path
            folder = dreamcast_table[p].directory
            filename = dreamcast_table[p].filename
            favourite_flag = dreamcast_table[p].favourite
            hide_game_flag = dreamcast_table[p].hidden
            game_path = dreamcast_table[p].game_path

            app_titleid = dreamcast_table[p].name
            app_version = dreamcast_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 12 then
        if #sega_cd_table > 0 then
            info = sega_cd_table[p].name            
            icon_path = "app0:/DATA/icon_sega_cd.png"
            pic_path = sega_cd_table[p].snap_path_local .. sega_cd_table[p].name .. ".png"
            app_title = sega_cd_table[p].title
            apptype = sega_cd_table[p].app_type
            appdir = sega_cd_table[p].game_path
            folder = sega_cd_table[p].directory
            filename = sega_cd_table[p].filename
            favourite_flag = sega_cd_table[p].favourite
            hide_game_flag = sega_cd_table[p].hidden
            game_path = sega_cd_table[p].game_path

            app_titleid = sega_cd_table[p].name
            app_version = sega_cd_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 13 then
        if #s32x_table > 0 then
            info = s32x_table[p].name            
            icon_path = "app0:/DATA/icon_32x.png"
            pic_path = s32x_table[p].snap_path_local .. s32x_table[p].name .. ".png"
            app_title = s32x_table[p].title
            apptype = s32x_table[p].app_type
            appdir = s32x_table[p].game_path
            folder = s32x_table[p].directory
            filename = s32x_table[p].filename
            favourite_flag = s32x_table[p].favourite
            hide_game_flag = s32x_table[p].hidden
            game_path = s32x_table[p].game_path

            app_titleid = s32x_table[p].name
            app_version = s32x_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 14 then
        if #md_table > 0 then
            info = md_table[p].name
            if setLanguage == 1 then
                icon_path = "app0:/DATA/icon_md_usa.png"
            else
                icon_path = "app0:/DATA/icon_md.png"
            end
            pic_path = md_table[p].snap_path_local .. md_table[p].name .. ".png"
            app_title = md_table[p].title
            apptype = md_table[p].app_type
            appdir = md_table[p].game_path
            folder = md_table[p].directory
            filename = md_table[p].filename
            favourite_flag = md_table[p].favourite
            hide_game_flag = md_table[p].hidden
            game_path = md_table[p].game_path

            app_titleid = md_table[p].name
            app_version = md_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 15 then
        if #sms_table > 0 then
            info = sms_table[p].name
            icon_path = "app0:/DATA/icon_sms.png"
            pic_path = sms_table[p].snap_path_local .. sms_table[p].name .. ".png"
            app_title = sms_table[p].title
            apptype = sms_table[p].app_type
            appdir = sms_table[p].game_path
            folder = sms_table[p].directory
            filename = sms_table[p].filename
            favourite_flag = sms_table[p].favourite
            hide_game_flag = sms_table[p].hidden
            game_path = sms_table[p].game_path

            app_titleid = sms_table[p].name
            app_version = sms_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 16 then
        if #gg_table > 0 then
            info = gg_table[p].name
            icon_path = "app0:/DATA/icon_gg.png"
            pic_path = gg_table[p].snap_path_local .. gg_table[p].name .. ".png"
            app_title = gg_table[p].title
            apptype = gg_table[p].app_type
            appdir = gg_table[p].game_path
            folder = gg_table[p].directory
            filename = gg_table[p].filename
            favourite_flag = gg_table[p].favourite
            hide_game_flag = gg_table[p].hidden
            game_path = gg_table[p].game_path

            app_titleid = gg_table[p].name
            app_version = gg_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 17 then
        if #tg16_table > 0 then
            info = tg16_table[p].name
            icon_path = "app0:/DATA/icon_tg16.png"
            pic_path = tg16_table[p].snap_path_local .. tg16_table[p].name .. ".png"
            app_title = tg16_table[p].title
            apptype = tg16_table[p].app_type
            appdir = tg16_table[p].game_path
            folder = tg16_table[p].directory
            filename = tg16_table[p].filename
            favourite_flag = tg16_table[p].favourite
            hide_game_flag = tg16_table[p].hidden
            game_path = tg16_table[p].game_path

            app_titleid = tg16_table[p].name
            app_version = tg16_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 18 then
        if #tgcd_table > 0 then
            info = tgcd_table[p].name
            icon_path = "app0:/DATA/icon_tgcd.png"
            pic_path = tgcd_table[p].snap_path_local .. tgcd_table[p].name .. ".png"
            app_title = tgcd_table[p].title
            apptype = tgcd_table[p].app_type
            appdir = tgcd_table[p].game_path
            folder = tgcd_table[p].directory
            filename = tgcd_table[p].filename
            favourite_flag = tgcd_table[p].favourite
            hide_game_flag = tgcd_table[p].hidden
            game_path = tgcd_table[p].game_path

            app_titleid = tgcd_table[p].name
            app_version = tgcd_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 19 then
        if #pce_table > 0 then
            info = pce_table[p].name
            icon_path = "app0:/DATA/icon_pce.png"
            pic_path = pce_table[p].snap_path_local .. pce_table[p].name .. ".png"
            app_title = pce_table[p].title
            apptype = pce_table[p].app_type
            appdir = pce_table[p].game_path
            folder = pce_table[p].directory
            filename = pce_table[p].filename
            favourite_flag = pce_table[p].favourite
            hide_game_flag = pce_table[p].hidden
            game_path = pce_table[p].game_path

            app_titleid = pce_table[p].name
            app_version = pce_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 20 then
        if #pcecd_table > 0 then
            info = pcecd_table[p].name
            icon_path = "app0:/DATA/icon_pcecd.png"
            pic_path = pcecd_table[p].snap_path_local .. pcecd_table[p].name .. ".png"
            app_title = pcecd_table[p].title
            apptype = pcecd_table[p].app_type
            appdir = pcecd_table[p].game_path
            folder = pcecd_table[p].directory
            filename = pcecd_table[p].filename
            favourite_flag = pcecd_table[p].favourite
            hide_game_flag = pcecd_table[p].hidden
            game_path = pcecd_table[p].game_path

            app_titleid = pcecd_table[p].name
            app_version = pcecd_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 21 then
        if #amiga_table > 0 then
            info = amiga_table[p].name
            icon_path = "app0:/DATA/icon_amiga.png"
            pic_path = amiga_table[p].snap_path_local .. amiga_table[p].name .. ".png"
            app_title = amiga_table[p].title
            apptype = amiga_table[p].app_type
            appdir = amiga_table[p].game_path
            folder = amiga_table[p].directory
            filename = amiga_table[p].filename
            favourite_flag = amiga_table[p].favourite
            hide_game_flag = amiga_table[p].hidden
            game_path = amiga_table[p].game_path

            app_titleid = amiga_table[p].name
            app_version = amiga_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 22 then
        if #c64_table > 0 then
            info = c64_table[p].name            
            icon_path = "app0:/DATA/icon_c64.png"
            pic_path = c64_table[p].snap_path_local .. c64_table[p].name .. ".png"
            app_title = c64_table[p].title
            apptype = c64_table[p].app_type
            appdir = c64_table[p].game_path
            folder = c64_table[p].directory
            filename = c64_table[p].filename
            favourite_flag = c64_table[p].favourite
            hide_game_flag = c64_table[p].hidden
            game_path = c64_table[p].game_path

            app_titleid = c64_table[p].name
            app_version = c64_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 23 then
        if #wswan_col_table > 0 then
            info = wswan_col_table[p].name            
            icon_path = "app0:/DATA/icon_wswan_col.png"
            pic_path = wswan_col_table[p].snap_path_local .. wswan_col_table[p].name .. ".png"
            app_title = wswan_col_table[p].title
            apptype = wswan_col_table[p].app_type
            appdir = wswan_col_table[p].game_path
            folder = wswan_col_table[p].directory
            filename = wswan_col_table[p].filename
            favourite_flag = wswan_col_table[p].favourite
            hide_game_flag = wswan_col_table[p].hidden
            game_path = wswan_col_table[p].game_path

            app_titleid = wswan_col_table[p].name
            app_version = wswan_col_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 24 then
        if #wswan_table > 0 then
            info = wswan_table[p].name            
            icon_path = "app0:/DATA/icon_wswan.png"
            pic_path = wswan_table[p].snap_path_local .. wswan_table[p].name .. ".png"
            app_title = wswan_table[p].title
            apptype = wswan_table[p].app_type
            appdir = wswan_table[p].game_path
            folder = wswan_table[p].directory
            filename = wswan_table[p].filename
            favourite_flag = wswan_table[p].favourite
            hide_game_flag = wswan_table[p].hidden
            game_path = wswan_table[p].game_path

            app_titleid = wswan_table[p].name
            app_version = wswan_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 25 then
        if #msx2_table > 0 then
            info = msx2_table[p].name            
            icon_path = "app0:/DATA/icon_msx2.png"
            pic_path = msx2_table[p].snap_path_local .. msx2_table[p].name .. ".png"
            app_title = msx2_table[p].title
            apptype = msx2_table[p].app_type
            appdir = msx2_table[p].game_path
            folder = msx2_table[p].directory
            filename = msx2_table[p].filename
            favourite_flag = msx2_table[p].favourite
            hide_game_flag = msx2_table[p].hidden
            game_path = msx2_table[p].game_path

            app_titleid = msx2_table[p].name
            app_version = msx2_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 26 then
        if #msx1_table > 0 then
            info = msx1_table[p].name            
            icon_path = "app0:/DATA/icon_msx1.png"
            pic_path = msx1_table[p].snap_path_local .. msx1_table[p].name .. ".png"
            app_title = msx1_table[p].title
            apptype = msx1_table[p].app_type
            appdir = msx1_table[p].game_path
            folder = msx1_table[p].directory
            filename = msx1_table[p].filename
            favourite_flag = msx1_table[p].favourite
            hide_game_flag = msx1_table[p].hidden
            game_path = msx1_table[p].game_path

            app_titleid = msx1_table[p].name
            app_version = msx1_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 27 then
        if #zxs_table > 0 then
            info = zxs_table[p].name            
            icon_path = "app0:/DATA/icon_zxs.png"
            pic_path = zxs_table[p].snap_path_local .. zxs_table[p].name .. ".png"
            app_title = zxs_table[p].title
            apptype = zxs_table[p].app_type
            appdir = zxs_table[p].game_path
            folder = zxs_table[p].directory
            filename = zxs_table[p].filename
            favourite_flag = zxs_table[p].favourite
            hide_game_flag = zxs_table[p].hidden
            game_path = zxs_table[p].game_path

            app_titleid = zxs_table[p].name
            app_version = zxs_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 28 then
        if #atari_7800_table > 0 then
            info = atari_7800_table[p].name            
            icon_path = "app0:/DATA/icon_atari_7800.png"
            pic_path = atari_7800_table[p].snap_path_local .. atari_7800_table[p].name .. ".png"
            app_title = atari_7800_table[p].title
            apptype = atari_7800_table[p].app_type
            appdir = atari_7800_table[p].game_path
            folder = atari_7800_table[p].directory
            filename = atari_7800_table[p].filename
            favourite_flag = atari_7800_table[p].favourite
            hide_game_flag = atari_7800_table[p].hidden
            game_path = atari_7800_table[p].game_path

            app_titleid = atari_7800_table[p].name
            app_version = atari_7800_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 29 then
        if #atari_5200_table > 0 then
            info = atari_5200_table[p].name            
            icon_path = "app0:/DATA/icon_atari_5200.png"
            pic_path = atari_5200_table[p].snap_path_local .. atari_5200_table[p].name .. ".png"
            app_title = atari_5200_table[p].title
            apptype = atari_5200_table[p].app_type
            appdir = atari_5200_table[p].game_path
            folder = atari_5200_table[p].directory
            filename = atari_5200_table[p].filename
            favourite_flag = atari_5200_table[p].favourite
            hide_game_flag = atari_5200_table[p].hidden
            game_path = atari_5200_table[p].game_path

            app_titleid = atari_5200_table[p].name
            app_version = atari_5200_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 30 then
        if #atari_2600_table > 0 then
            info = atari_2600_table[p].name            
            icon_path = "app0:/DATA/icon_atari_2600.png"
            pic_path = atari_2600_table[p].snap_path_local .. atari_2600_table[p].name .. ".png"
            app_title = atari_2600_table[p].title
            apptype = atari_2600_table[p].app_type
            appdir = atari_2600_table[p].game_path
            folder = atari_2600_table[p].directory
            filename = atari_2600_table[p].filename
            favourite_flag = atari_2600_table[p].favourite
            hide_game_flag = atari_2600_table[p].hidden
            game_path = atari_2600_table[p].game_path

            app_titleid = atari_2600_table[p].name
            app_version = atari_2600_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 31 then
        if #atari_lynx_table > 0 then
            info = atari_lynx_table[p].name            
            icon_path = "app0:/DATA/icon_atari_lynx.png"
            pic_path = atari_lynx_table[p].snap_path_local .. atari_lynx_table[p].name .. ".png"
            app_title = atari_lynx_table[p].title
            apptype = atari_lynx_table[p].app_type
            appdir = atari_lynx_table[p].game_path
            folder = atari_lynx_table[p].directory
            filename = atari_lynx_table[p].filename
            favourite_flag = atari_lynx_table[p].favourite
            hide_game_flag = atari_lynx_table[p].hidden
            game_path = atari_lynx_table[p].game_path

            app_titleid = atari_lynx_table[p].name
            app_version = atari_lynx_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 32 then
        if #colecovision_table > 0 then
            info = colecovision_table[p].name            
            icon_path = "app0:/DATA/icon_colecovision.png"
            pic_path = colecovision_table[p].snap_path_local .. colecovision_table[p].name .. ".png"
            app_title = colecovision_table[p].title
            apptype = colecovision_table[p].app_type
            appdir = colecovision_table[p].game_path
            folder = colecovision_table[p].directory
            filename = colecovision_table[p].filename
            favourite_flag = colecovision_table[p].favourite
            hide_game_flag = colecovision_table[p].hidden
            game_path = colecovision_table[p].game_path

            app_titleid = colecovision_table[p].name
            app_version = colecovision_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 33 then
        if #vectrex_table > 0 then
            info = vectrex_table[p].name            
            icon_path = "app0:/DATA/icon_vectrex.png"
            pic_path = vectrex_table[p].snap_path_local .. vectrex_table[p].name .. ".png"
            app_title = vectrex_table[p].title
            apptype = vectrex_table[p].app_type
            appdir = vectrex_table[p].game_path
            folder = vectrex_table[p].directory
            filename = vectrex_table[p].filename
            favourite_flag = vectrex_table[p].favourite
            hide_game_flag = vectrex_table[p].hidden
            game_path = vectrex_table[p].game_path

            app_titleid = vectrex_table[p].name
            app_version = vectrex_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 34 then
        if #fba_table > 0 then
            info = fba_table[p].name            
            icon_path = "app0:/DATA/icon_fba.png"
            pic_path = fba_table[p].snap_path_local .. fba_table[p].name .. ".png"
            app_title = fba_table[p].title
            apptype = fba_table[p].app_type
            appdir = fba_table[p].game_path
            folder = fba_table[p].directory
            filename = fba_table[p].filename
            favourite_flag = fba_table[p].favourite
            hide_game_flag = fba_table[p].hidden
            game_path = fba_table[p].game_path

            app_titleid = fba_table[p].name
            app_version = fba_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 35 then
        if #mame_2003_plus_table > 0 then
            info = mame_2003_plus_table[p].name            
            icon_path = "app0:/DATA/icon_mame.png"
            pic_path = mame_2003_plus_table[p].snap_path_local .. mame_2003_plus_table[p].name .. ".png"
            app_title = mame_2003_plus_table[p].title
            apptype = mame_2003_plus_table[p].app_type
            appdir = mame_2003_plus_table[p].game_path
            folder = mame_2003_plus_table[p].directory
            filename = mame_2003_plus_table[p].filename
            favourite_flag = mame_2003_plus_table[p].favourite
            hide_game_flag = mame_2003_plus_table[p].hidden
            game_path = mame_2003_plus_table[p].game_path

            app_titleid = mame_2003_plus_table[p].name
            app_version = mame_2003_plus_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 36 then
        if #mame_2000_table > 0 then
            info = mame_2000_table[p].name
            icon_path = "app0:/DATA/icon_mame.png"
            pic_path = mame_2000_table[p].snap_path_local .. mame_2000_table[p].name .. ".png"
            app_title = mame_2000_table[p].title
            apptype = mame_2000_table[p].app_type
            appdir = mame_2000_table[p].game_path
            folder = mame_2000_table[p].directory
            filename = mame_2000_table[p].filename
            favourite_flag = mame_2000_table[p].favourite
            hide_game_flag = mame_2000_table[p].hidden
            game_path = mame_2000_table[p].game_path

            app_titleid = mame_2000_table[p].name
            app_version = mame_2000_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 37 then
        if #neogeo_table > 0 then
            info = neogeo_table[p].name            
            icon_path = "app0:/DATA/icon_neogeo.png"
            pic_path = neogeo_table[p].snap_path_local .. neogeo_table[p].name .. ".png"
            app_title = neogeo_table[p].title
            apptype = neogeo_table[p].app_type
            appdir = neogeo_table[p].game_path
            folder = neogeo_table[p].directory
            filename = neogeo_table[p].filename
            favourite_flag = neogeo_table[p].favourite
            hide_game_flag = neogeo_table[p].hidden
            game_path = neogeo_table[p].game_path

            app_titleid = neogeo_table[p].name
            app_version = neogeo_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 38 then
        if #ngpc_table > 0 then
            info = ngpc_table[p].name
            icon_path = "app0:/DATA/icon_ngpc.png"
            pic_path = ngpc_table[p].snap_path_local .. ngpc_table[p].name .. ".png"
            app_title = ngpc_table[p].title
            apptype = ngpc_table[p].app_type
            appdir = ngpc_table[p].game_path
            folder = ngpc_table[p].directory
            filename = ngpc_table[p].filename
            favourite_flag = ngpc_table[p].favourite
            hide_game_flag = ngpc_table[p].hidden
            game_path = ngpc_table[p].game_path

            app_titleid = ngpc_table[p].name
            app_version = ngpc_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 39 then
        if #psm_table > 0 then
            info = psm_table[p].name
            icon_path = psm_table[p].icon_path

            -- Get pic
            GetPicPath(psm_table)

            app_title = psm_table[p].title
            apptype = psm_table[p].app_type
            appdir = psm_table[p].game_path
            folder = psm_table[p].directory
            filename = psm_table[p].filename
            favourite_flag = psm_table[p].favourite
            hide_game_flag = psm_table[p].hidden
            game_path = psm_table[p].game_path

            app_titleid = psm_table[p].name
            app_version = psm_table[p].version
        else
            app_title = "-"
        end

    elseif showCat == 40 then

        -- count favorites
        create_fav_count_table(files_table)

        if #fav_count > 0 then
            info = fav_count[p].name
            app_title = fav_count[p].title
            apptype = fav_count[p].app_type
            appdir = fav_count[p].game_path
            folder = fav_count[p].directory
            filename = fav_count[p].filename
            favourite_flag = fav_count[p].favourite
            hide_game_flag = fav_count[p].hidden
            game_path = fav_count[p].game_path

            app_titleid = fav_count[p].name
            app_version = fav_count[p].version

            -- Get pic
            GetPicPath(fav_count)

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. fav_count[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. fav_count[p].name .. "/icon0.png"

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. fav_count[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = fav_count[p].icon_path

            else
                icon_path = fav_count[p].icon_path

                if apptype==1 then
                    icon_path = "app0:/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "app0:/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "app0:/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "app0:/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "app0:/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "app0:/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "app0:/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "app0:/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "app0:/DATA/icon_gb.png"
                elseif apptype==11 then -- DC
                    if setLanguage == 0 then -- EN - Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    elseif setLanguage == 1 then -- USA - Red logo
                        icon_path = "app0:/DATA/icon_dreamcast_usa.png"
                    elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
                        icon_path = "app0:/DATA/icon_dreamcast_j.png"
                    else -- Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    end
                elseif apptype==12 then -- SEGA_CD
                    icon_path = "app0:/DATA/icon_sega_cd.png"
                elseif apptype==13 then -- 32X
                    icon_path = "app0:/DATA/icon_32x.png"
                elseif apptype==14 then -- MD
                    if setLanguage == 1 then
                        icon_path = "app0:/DATA/icon_md_usa.png"
                    else
                        icon_path = "app0:/DATA/icon_md.png"
                    end
                elseif apptype==15 then -- SMS
                    icon_path = "app0:/DATA/icon_sms.png"
                elseif apptype==16 then -- GG
                    icon_path = "app0:/DATA/icon_gg.png"
                elseif apptype==17 then -- TG16
                    icon_path = "app0:/DATA/icon_tg16.png"
                elseif apptype==18 then -- TGCD
                    icon_path = "app0:/DATA/icon_tgcd.png"
                elseif apptype==19 then -- PCE
                    icon_path = "app0:/DATA/icon_pce.png"
                elseif apptype==20 then -- PCECD
                    icon_path = "app0:/DATA/icon_pcecd.png"
                elseif apptype==21 then -- AMIGA
                    icon_path = "app0:/DATA/icon_amiga.png"
                elseif apptype==22 then -- C64
                    icon_path = "app0:/DATA/icon_c64.png"
                elseif apptype==23 then -- WSWAN_COL
                    icon_path = "app0:/DATA/icon_wswan_col.png"
                elseif apptype==24 then -- WSWAN
                    icon_path = "app0:/DATA/icon_wswan.png"
                elseif apptype==25 then -- MSX2
                    icon_path = "app0:/DATA/icon_msx2.png"
                elseif apptype==26 then -- MSX1
                    icon_path = "app0:/DATA/icon_msx1.png"
                elseif apptype==27 then -- ZXS
                    icon_path = "app0:/DATA/icon_zxs.png"
                elseif apptype==28 then -- ATARI_7800
                    icon_path = "app0:/DATA/icon_atari_7800.png"
                elseif apptype==29 then -- ATARI_5200
                    icon_path = "app0:/DATA/icon_atari_5200.png"
                elseif apptype==30 then -- ATARI_2600
                    icon_path = "app0:/DATA/icon_atari_2600.png"
                elseif apptype==31 then -- ATARI_LYNX
                    icon_path = "app0:/DATA/icon_atari_lynx.png"
                elseif apptype==32 then -- COLECOVISION
                    icon_path = "app0:/DATA/icon_colecovision.png"
                elseif apptype==33 then -- VECTREX
                    icon_path = "app0:/DATA/icon_vectrex.png"
                elseif apptype==34 then -- FBA
                    icon_path = "app0:/DATA/icon_fba.png"
                elseif apptype==35 then -- MAME_2003_PLUS
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==36 then -- MAME_2000
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==37 then -- NEOGEO
                    icon_path = "app0:/DATA/icon_neogeo.png"
                elseif apptype==38 then -- NGPC
                    icon_path = "app0:/DATA/icon_ngpc.png"
                else
                    icon_path = fav_count[p].icon_path
                end

            end
        else
            -- app_title = "-"
        end

    elseif showCat == 41 then

        if #recently_played_table > 0 then
            info = recently_played_table[p].name
            app_title = recently_played_table[p].title
            apptype = recently_played_table[p].app_type
            appdir = recently_played_table[p].game_path
            folder = recently_played_table[p].directory
            filename = recently_played_table[p].filename
            favourite_flag = recently_played_table[p].favourite
            hide_game_flag = recently_played_table[p].hidden
            game_path = recently_played_table[p].game_path

            app_titleid = recently_played_table[p].name
            app_version = recently_played_table[p].version

            -- Get pic
            GetPicPath(recently_played_table)

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. recently_played_table[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. recently_played_table[p].name .. "/icon0.png"

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. recently_played_table[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = recently_played_table[p].icon_path

            else
                pic_path = recently_played_table[p].snap_path_local .. recently_played_table[p].name .. ".png"
                icon_path = recently_played_table[p].icon_path

                if apptype==1 then
                    icon_path = "app0:/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "app0:/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "app0:/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "app0:/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "app0:/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "app0:/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "app0:/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "app0:/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "app0:/DATA/icon_gb.png"
                elseif apptype==11 then -- DC
                    if setLanguage == 0 then -- EN - Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    elseif setLanguage == 1 then -- USA - Red logo
                        icon_path = "app0:/DATA/icon_dreamcast_usa.png"
                    elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
                        icon_path = "app0:/DATA/icon_dreamcast_j.png"
                    else -- Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    end
                elseif apptype==12 then -- SEGA_CD
                    icon_path = "app0:/DATA/icon_sega_cd.png"
                elseif apptype==13 then -- 32X
                    icon_path = "app0:/DATA/icon_32x.png"
                elseif apptype==14 then -- MD
                    if setLanguage == 1 then
                        icon_path = "app0:/DATA/icon_md_usa.png"
                    else
                        icon_path = "app0:/DATA/icon_md.png"
                    end
                elseif apptype==15 then -- SMS
                    icon_path = "app0:/DATA/icon_sms.png"
                elseif apptype==16 then -- GG
                    icon_path = "app0:/DATA/icon_gg.png"
                elseif apptype==17 then -- TG16
                    icon_path = "app0:/DATA/icon_tg16.png"
                elseif apptype==18 then -- TGCD
                    icon_path = "app0:/DATA/icon_tgcd.png"
                elseif apptype==19 then -- PCE
                    icon_path = "app0:/DATA/icon_pce.png"
                elseif apptype==20 then -- PCECD
                    icon_path = "app0:/DATA/icon_pcecd.png"
                elseif apptype==21 then -- AMIGA
                    icon_path = "app0:/DATA/icon_amiga.png"
                elseif apptype==22 then -- C64
                    icon_path = "app0:/DATA/icon_c64.png"
                elseif apptype==23 then -- WSWAN_COL
                    icon_path = "app0:/DATA/icon_wswan_col.png"
                elseif apptype==24 then -- WSWAN
                    icon_path = "app0:/DATA/icon_wswan.png"
                elseif apptype==25 then -- MSX2
                    icon_path = "app0:/DATA/icon_msx2.png"
                elseif apptype==26 then -- MSX1
                    icon_path = "app0:/DATA/icon_msx1.png"
                elseif apptype==27 then -- ZXS
                    icon_path = "app0:/DATA/icon_zxs.png"
                elseif apptype==28 then -- ATARI_7800
                    icon_path = "app0:/DATA/icon_atari_7800.png"
                elseif apptype==29 then -- ATARI_5200
                    icon_path = "app0:/DATA/icon_atari_5200.png"
                elseif apptype==30 then -- ATARI_2600
                    icon_path = "app0:/DATA/icon_atari_2600.png"
                elseif apptype==31 then -- ATARI_LYNX
                    icon_path = "app0:/DATA/icon_atari_lynx.png"
                elseif apptype==32 then -- COLECOVISION
                    icon_path = "app0:/DATA/icon_colecovision.png"
                elseif apptype==33 then -- VECTREX
                    icon_path = "app0:/DATA/icon_vectrex.png"
                elseif apptype==34 then -- FBA
                    icon_path = "app0:/DATA/icon_fba.png"
                elseif apptype==35 then -- MAME_2003_PLUS
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==36 then -- MAME_2000
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==37 then -- NEOGEO
                    icon_path = "app0:/DATA/icon_neogeo.png"
                elseif apptype==38 then -- NGPC
                    icon_path = "app0:/DATA/icon_ngpc.png"
                else
                    icon_path = recently_played_table[p].icon_path
                end

            end
        else
            -- app_title = "-"
        end
            
    elseif showCat == 42 then

        if #search_results_table > 0 then
            info = search_results_table[p].name
            app_title = search_results_table[p].title
            apptype = search_results_table[p].app_type
            appdir = search_results_table[p].game_path
            folder = search_results_table[p].directory
            filename = search_results_table[p].filename
            favourite_flag = search_results_table[p].favourite
            hide_game_flag = search_results_table[p].hidden
            game_path = search_results_table[p].game_path

            app_titleid = search_results_table[p].name
            app_version = search_results_table[p].version

            -- Get pic
            GetPicPath(search_results_table)

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. search_results_table[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. search_results_table[p].name .. "/icon0.png" 

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. search_results_table[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = search_results_table[p].icon_path

            else
                pic_path = search_results_table[p].snap_path_local .. search_results_table[p].name .. ".png"
                icon_path = search_results_table[p].icon_path

                if apptype==1 then
                    icon_path = "app0:/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "app0:/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "app0:/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "app0:/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "app0:/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "app0:/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "app0:/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "app0:/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "app0:/DATA/icon_gb.png"
                elseif apptype==11 then -- DC
                    if setLanguage == 0 then -- EN - Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    elseif setLanguage == 1 then -- USA - Red logo
                        icon_path = "app0:/DATA/icon_dreamcast_usa.png"
                    elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
                        icon_path = "app0:/DATA/icon_dreamcast_j.png"
                    else -- Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    end
                elseif apptype==12 then -- SEGA_CD
                    icon_path = "app0:/DATA/icon_sega_cd.png"
                elseif apptype==13 then -- 32X
                    icon_path = "app0:/DATA/icon_32x.png"
                elseif apptype==14 then -- MD
                    if setLanguage == 1 then
                        icon_path = "app0:/DATA/icon_md_usa.png"
                    else
                        icon_path = "app0:/DATA/icon_md.png"
                    end
                elseif apptype==15 then -- SMS
                    icon_path = "app0:/DATA/icon_sms.png"
                elseif apptype==16 then -- GG
                    icon_path = "app0:/DATA/icon_gg.png"
                elseif apptype==17 then -- TG16
                    icon_path = "app0:/DATA/icon_tg16.png"
                elseif apptype==18 then -- TGCD
                    icon_path = "app0:/DATA/icon_tgcd.png"
                elseif apptype==19 then -- PCE
                    icon_path = "app0:/DATA/icon_pce.png"
                elseif apptype==20 then -- PCECD
                    icon_path = "app0:/DATA/icon_pcecd.png"
                elseif apptype==21 then -- AMIGA
                    icon_path = "app0:/DATA/icon_amiga.png"
                elseif apptype==22 then -- C64
                    icon_path = "app0:/DATA/icon_c64.png"
                elseif apptype==23 then -- WSWAN_COL
                    icon_path = "app0:/DATA/icon_wswan_col.png"
                elseif apptype==24 then -- WSWAN
                    icon_path = "app0:/DATA/icon_wswan.png"
                elseif apptype==25 then -- MSX2
                    icon_path = "app0:/DATA/icon_msx2.png"
                elseif apptype==26 then -- MSX1
                    icon_path = "app0:/DATA/icon_msx1.png"
                elseif apptype==27 then -- ZXS
                    icon_path = "app0:/DATA/icon_zxs.png"
                elseif apptype==28 then -- ATARI_7800
                    icon_path = "app0:/DATA/icon_atari_7800.png"
                elseif apptype==29 then -- ATARI_5200
                    icon_path = "app0:/DATA/icon_atari_5200.png"
                elseif apptype==30 then -- ATARI_2600
                    icon_path = "app0:/DATA/icon_atari_2600.png"
                elseif apptype==31 then -- ATARI_LYNX
                    icon_path = "app0:/DATA/icon_atari_lynx.png"
                elseif apptype==32 then -- COLECOVISION
                    icon_path = "app0:/DATA/icon_colecovision.png"
                elseif apptype==33 then -- VECTREX
                    icon_path = "app0:/DATA/icon_vectrex.png"
                elseif apptype==34 then -- FBA
                    icon_path = "app0:/DATA/icon_fba.png"
                elseif apptype==35 then -- MAME_2003_PLUS
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==36 then -- MAME_2000
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==37 then -- NEOGEO
                    icon_path = "app0:/DATA/icon_neogeo.png"
                elseif apptype==38 then -- NGPC
                    icon_path = "app0:/DATA/icon_ngpc.png"
                else
                    icon_path = search_results_table[p].icon_path
                end

            end
        else
            -- app_title = "-"
        end



    else
        if #files_table > 0 then
            info = files_table[p].name
            app_title = files_table[p].title
            apptype = files_table[p].app_type
            appdir = files_table[p].game_path
            folder = files_table[p].directory
            filename = files_table[p].filename
            favourite_flag = files_table[p].favourite
            hide_game_flag = files_table[p].hidden
            game_path = files_table[p].game_path

            app_titleid = files_table[p].name
            app_version = files_table[p].version

            -- Get pic
            GetPicPath(files_table)

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. files_table[p].name .. "/icon0.png"

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = files_table[p].icon_path

            else
                pic_path = files_table[p].snap_path_local .. files_table[p].name .. ".png"
                icon_path = files_table[p].icon_path

                if apptype==1 then
                    icon_path = "app0:/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "app0:/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "app0:/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "app0:/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "app0:/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "app0:/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "app0:/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "app0:/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "app0:/DATA/icon_gb.png"
                elseif apptype==11 then -- DC
                    if setLanguage == 0 then -- EN - Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    elseif setLanguage == 1 then -- USA - Red logo
                        icon_path = "app0:/DATA/icon_dreamcast_usa.png"
                    elseif setLanguage == 9 or setLanguage == 19 then -- Japan - Orange logo
                        icon_path = "app0:/DATA/icon_dreamcast_j.png"
                    else -- Blue logo
                        icon_path = "app0:/DATA/icon_dreamcast_eur.png"
                    end
                elseif apptype==12 then -- SEGA_CD
                    icon_path = "app0:/DATA/icon_sega_cd.png"
                elseif apptype==13 then -- 32X
                    icon_path = "app0:/DATA/icon_32x.png"
                elseif apptype==14 then -- MD
                    if setLanguage == 1 then
                        icon_path = "app0:/DATA/icon_md_usa.png"
                    else
                        icon_path = "app0:/DATA/icon_md.png"
                    end
                elseif apptype==15 then -- SMS
                    icon_path = "app0:/DATA/icon_sms.png"
                elseif apptype==16 then -- GG
                    icon_path = "app0:/DATA/icon_gg.png"
                elseif apptype==17 then -- TG16
                    icon_path = "app0:/DATA/icon_tg16.png"
                elseif apptype==18 then -- TGCD
                    icon_path = "app0:/DATA/icon_tgcd.png"
                elseif apptype==19 then -- PCE
                    icon_path = "app0:/DATA/icon_pce.png"
                elseif apptype==20 then -- PCECD
                    icon_path = "app0:/DATA/icon_pcecd.png"
                elseif apptype==21 then -- AMIGA
                    icon_path = "app0:/DATA/icon_amiga.png"
                elseif apptype==22 then -- C64
                    icon_path = "app0:/DATA/icon_c64.png"
                elseif apptype==23 then -- WSWAN_COL
                    icon_path = "app0:/DATA/icon_wswan_col.png"
                elseif apptype==24 then -- WSWAN
                    icon_path = "app0:/DATA/icon_wswan.png"
                elseif apptype==25 then -- MSX2
                    icon_path = "app0:/DATA/icon_msx2.png"
                elseif apptype==26 then -- MSX1
                    icon_path = "app0:/DATA/icon_msx1.png"
                elseif apptype==27 then -- ZXS
                    icon_path = "app0:/DATA/icon_zxs.png"
                elseif apptype==28 then -- ATARI_7800
                    icon_path = "app0:/DATA/icon_atari_7800.png"
                elseif apptype==29 then -- ATARI_5200
                    icon_path = "app0:/DATA/icon_atari_5200.png"
                elseif apptype==30 then -- ATARI_2600
                    icon_path = "app0:/DATA/icon_atari_2600.png"
                elseif apptype==31 then -- ATARI_LYNX
                    icon_path = "app0:/DATA/icon_atari_lynx.png"
                elseif apptype==32 then -- COLECOVISION
                    icon_path = "app0:/DATA/icon_colecovision.png"
                elseif apptype==33 then -- VECTREX
                    icon_path = "app0:/DATA/icon_vectrex.png"
                elseif apptype==34 then -- FBA
                    icon_path = "app0:/DATA/icon_fba.png"
                elseif apptype==35 then -- MAME_2003_PLUS
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==36 then -- MAME_2000
                    icon_path = "app0:/DATA/icon_mame.png"
                elseif apptype==37 then -- NEOGEO
                    icon_path = "app0:/DATA/icon_neogeo.png"
                elseif apptype==38 then -- NGPC
                    icon_path = "app0:/DATA/icon_ngpc.png"
                else
                    icon_path = files_table[p].icon_path
                end

            end
        else
            -- app_title = "-"
        end
    end
end

function update_recently_played_table_favorite(def)
    for k, v in pairs(recently_played_table) do
        if v.filename==filename then
            v.favourite=(def)
        end
    end
end

function update_favorites_table_system(def_table_name)
    if (def_table_name)[p].favourite == true then 
        (def_table_name)[p].favourite=false
        update_recently_played_table_favorite(false)
    else
        (def_table_name)[p].favourite=true
        update_recently_played_table_favorite(true)
    end
end

function update_favorites_table_favorites(def_table_name)
    if fav_count[p].favourite == true then
        fav_count[p].favourite=false
        for k, v in pairs((def_table_name)) do
              if v.filename==filename then
                  v.favourite=false
              end
        end
        update_recently_played_table_favorite(false)
    else
        fav_count[p].favourite=true
        for k, v in pairs((def_table_name)) do
              if v.filename==filename then
                  v.favourite=true
              end
        end
        update_recently_played_table_favorite(true)
    end
end


function update_favorites_table_recent(def_table_name)
    if recently_played_table[p].favourite == true then
        recently_played_table[p].favourite=false
        for k, v in pairs((def_table_name)) do
              if v.filename==filename then
                  v.favourite=false
              end
        end
    else
        recently_played_table[p].favourite=true
        for k, v in pairs((def_table_name)) do
              if v.filename==filename then
                  v.favourite=true
              end
        end
    end
end


function update_favorites_table_files(def_table_name)
    if files_table[p].favourite == true then
        files_table[p].favourite=false
        for k, v in pairs((def_table_name)) do
              if v.filename==filename then
                  v.favourite=false
              end
        end
    else
        files_table[p].favourite=true
        for k, v in pairs((def_table_name)) do
              if v.filename==filename then
                  v.favourite=true
              end
        end
    end
end

function AddOrRemoveFavorite()

    if System.doesFileExist(cur_dir .. "/favorites.dat") then
        local inf = assert(io.open(cur_dir .. "/favorites.dat", "rw"), "Failed to open favorites.dat")
        local lines = ""
        local favoriteExists = false;

        while(true) do
            local line = inf:read("*line")
            if not line then break end
            if string.find(line, filename .. "", 1,true) == nil then
                lines = lines .. line .. "\n"
            else
                favoriteExists = true;
            end
        end
        if not favoriteExists then
            lines = lines .. filename .. "\n"
        end
        inf:close()
        file_override = io.open(cur_dir .. "/favorites.dat", "w")
        file_override:write(lines)
        file_override:close()

        -- Update live favorites for all lists and cache
        if showCat == 1 then        update_favorites_table_system(games_table)          update_cached_table("db_games.lua", games_table)
        elseif showCat == 2 then    update_favorites_table_system(homebrews_table)      update_cached_table("db_homebrews.lua", homebrews_table)
        elseif showCat == 3 then    update_favorites_table_system(psp_table)            update_cached_table("db_psp.lua", psp_table)
        elseif showCat == 4 then    update_favorites_table_system(psx_table)            update_cached_table("db_psx.lua", psx_table)
        elseif showCat == 5 then    update_favorites_table_system(n64_table)            update_cached_table("db_n64.lua", n64_table)
        elseif showCat == 6 then    update_favorites_table_system(snes_table)           update_cached_table("db_snes.lua", snes_table)
        elseif showCat == 7 then    update_favorites_table_system(nes_table)            update_cached_table("db_nes.lua", nes_table)
        elseif showCat == 8 then    update_favorites_table_system(gba_table)            update_cached_table("db_gba.lua", gba_table)
        elseif showCat == 9 then    update_favorites_table_system(gbc_table)            update_cached_table("db_gbc.lua", gbc_table)
        elseif showCat == 10 then   update_favorites_table_system(gb_table)             update_cached_table("db_gb.lua", gb_table)
        elseif showCat == 11 then   update_favorites_table_system(dreamcast_table)      update_cached_table("db_dreamcast.lua", dreamcast_table)
        elseif showCat == 12 then   update_favorites_table_system(sega_cd_table)        update_cached_table("db_sega_cd.lua", sega_cd_table)
        elseif showCat == 13 then   update_favorites_table_system(s32x_table)           update_cached_table("db_32x.lua", s32x_table)
        elseif showCat == 14 then   update_favorites_table_system(md_table)             update_cached_table("db_md.lua", md_table)
        elseif showCat == 15 then   update_favorites_table_system(sms_table)            update_cached_table("db_sms.lua", sms_table)
        elseif showCat == 16 then   update_favorites_table_system(gg_table)             update_cached_table("db_gg.lua", gg_table)
        elseif showCat == 17 then   update_favorites_table_system(tg16_table)           update_cached_table("db_tg16.lua", tg16_table)
        elseif showCat == 18 then   update_favorites_table_system(tgcd_table)           update_cached_table("db_tgcd.lua", tgcd_table)
        elseif showCat == 19 then   update_favorites_table_system(pce_table)            update_cached_table("db_pce.lua", pce_table)
        elseif showCat == 20 then   update_favorites_table_system(pcecd_table)          update_cached_table("db_pcecd.lua", pcecd_table)
        elseif showCat == 21 then   update_favorites_table_system(amiga_table)          update_cached_table("db_amiga.lua", amiga_table)
        elseif showCat == 22 then   update_favorites_table_system(c64_table)            update_cached_table("db_c64.lua", c64_table)
        elseif showCat == 23 then   update_favorites_table_system(wswan_col_table)      update_cached_table("db_wswan_col.lua", wswan_col_table)
        elseif showCat == 24 then   update_favorites_table_system(wswan_table)          update_cached_table("db_wswan.lua", wswan_table)
        elseif showCat == 25 then   update_favorites_table_system(msx2_table)           update_cached_table("db_msx2.lua", msx2_table)
        elseif showCat == 26 then   update_favorites_table_system(msx1_table)           update_cached_table("db_msx1.lua", msx1_table)
        elseif showCat == 27 then   update_favorites_table_system(zxs_table)            update_cached_table("db_zxs.lua", zxs_table)
        elseif showCat == 28 then   update_favorites_table_system(atari_7800_table)     update_cached_table("db_atari_7800.lua", atari_7800_table)
        elseif showCat == 29 then   update_favorites_table_system(atari_5200_table)     update_cached_table("db_atari_5200.lua", atari_5200_table)
        elseif showCat == 30 then   update_favorites_table_system(atari_2600_table)     update_cached_table("db_atari_2600.lua", atari_2600_table)
        elseif showCat == 31 then   update_favorites_table_system(atari_lynx_table)     update_cached_table("db_atari_lynx.lua", atari_lynx_table)
        elseif showCat == 32 then   update_favorites_table_system(colecovision_table)   update_cached_table("db_colecovision.lua", colecovision_table)
        elseif showCat == 33 then   update_favorites_table_system(vectrex_table)        update_cached_table("db_vectrex.lua", vectrex_table)
        elseif showCat == 34 then   update_favorites_table_system(fba_table)            update_cached_table("db_fba.lua", fba_table)
        elseif showCat == 35 then   update_favorites_table_system(mame_2003_plus_table) update_cached_table("db_mame_2003_plus.lua", mame_2003_plus_table)
        elseif showCat == 36 then   update_favorites_table_system(mame_2000_table)      update_cached_table("db_mame_2000.lua", mame_2000_table)
        elseif showCat == 37 then   update_favorites_table_system(neogeo_table)         update_cached_table("db_neogeo.lua", neogeo_table)
        elseif showCat == 38 then   update_favorites_table_system(ngpc_table)           update_cached_table("db_ngpc.lua", ngpc_table)
        elseif showCat == 39 then   update_favorites_table_system(psm_table)            update_cached_table("db_psm.lua", psm_table)
        elseif showCat == 42 then   update_favorites_table_system(search_results_table)

        
        elseif showCat == 40 then
            -- Find game in other tables and update
            if apptype == 0 then        update_favorites_table_favorites(homebrews_table)       update_cached_table("db_homebrews.lua", homebrews_table)
            elseif apptype == 1 then    update_favorites_table_favorites(games_table)           update_cached_table("db_games.lua", games_table)
            elseif apptype == 2 then    update_favorites_table_favorites(psp_table)             update_cached_table("db_psp.lua", psp_table)
            elseif apptype == 3 then    update_favorites_table_favorites(psx_table)             update_cached_table("db_psx.lua", psx_table) 
            elseif apptype == 5 then    update_favorites_table_favorites(n64_table)             update_cached_table("db_n64.lua", n64_table)
            elseif apptype == 6 then    update_favorites_table_favorites(snes_table)            update_cached_table("db_snes.lua", snes_table)
            elseif apptype == 7 then    update_favorites_table_favorites(nes_table)             update_cached_table("db_nes.lua", nes_table)
            elseif apptype == 8 then    update_favorites_table_favorites(gba_table)             update_cached_table("db_gba.lua", gba_table)
            elseif apptype == 9 then    update_favorites_table_favorites(gbc_table)             update_cached_table("db_gbc.lua", gbc_table)
            elseif apptype == 10 then   update_favorites_table_favorites(gb_table)              update_cached_table("db_gb.lua", gb_table)
            elseif apptype == 11 then   update_favorites_table_favorites(dreamcast_table)       update_cached_table("db_dreamcast.lua", dreamcast_table)
            elseif apptype == 12 then   update_favorites_table_favorites(sega_cd_table)         update_cached_table("db_sega_cd.lua", sega_cd_table)
            elseif apptype == 13 then   update_favorites_table_favorites(s32x_table)            update_cached_table("db_32x.lua", s32x_table)
            elseif apptype == 14 then   update_favorites_table_favorites(md_table)              update_cached_table("db_md.lua", md_table)
            elseif apptype == 15 then   update_favorites_table_favorites(sms_table)             update_cached_table("db_sms.lua", sms_table)
            elseif apptype == 16 then   update_favorites_table_favorites(gg_table)              update_cached_table("db_gg.lua", gg_table)
            elseif apptype == 17 then   update_favorites_table_favorites(tg16_table)            update_cached_table("db_tg16.lua", tg16_table)
            elseif apptype == 18 then   update_favorites_table_favorites(tgcd_table)            update_cached_table("db_tgcd.lua", tgcd_table)
            elseif apptype == 19 then   update_favorites_table_favorites(pce_table)             update_cached_table("db_pce.lua", pce_table)
            elseif apptype == 20 then   update_favorites_table_favorites(pcecd_table)           update_cached_table("db_pcecd.lua", pcecd_table)
            elseif apptype == 21 then   update_favorites_table_favorites(amiga_table)           update_cached_table("db_amiga.lua", amiga_table)
            elseif apptype == 22 then   update_favorites_table_favorites(c64_table)             update_cached_table("db_c64.lua", c64_table)
            elseif apptype == 23 then   update_favorites_table_favorites(wswan_col_table)       update_cached_table("db_wswan_col.lua", wswan_col_table)
            elseif apptype == 24 then   update_favorites_table_favorites(wswan_table)           update_cached_table("db_wswan.lua", wswan_table)
            elseif apptype == 25 then   update_favorites_table_favorites(msx2_table)            update_cached_table("db_msx2.lua", msx2_table)
            elseif apptype == 26 then   update_favorites_table_favorites(msx1_table)            update_cached_table("db_msx1.lua", msx1_table)
            elseif apptype == 27 then   update_favorites_table_favorites(zxs_table)             update_cached_table("db_zxs.lua", zxs_table)
            elseif apptype == 28 then   update_favorites_table_favorites(atari_7800_table)      update_cached_table("db_atari_7800.lua", atari_7800_table)
            elseif apptype == 29 then   update_favorites_table_favorites(atari_5200_table)      update_cached_table("db_atari_5200.lua", atari_5200_table)
            elseif apptype == 30 then   update_favorites_table_favorites(atari_2600_table)      update_cached_table("db_atari_2600.lua", atari_2600_table)
            elseif apptype == 31 then   update_favorites_table_favorites(atari_lynx_table)      update_cached_table("db_atari_lynx.lua", atari_lynx_table)
            elseif apptype == 32 then   update_favorites_table_favorites(colecovision_table)    update_cached_table("db_colecovision.lua", colecovision_table)
            elseif apptype == 33 then   update_favorites_table_favorites(vectrex_table)         update_cached_table("db_vectrex.lua", vectrex_table)
            elseif apptype == 34 then   update_favorites_table_favorites(fba_table)             update_cached_table("db_fba.lua", fba_table)
            elseif apptype == 35 then   update_favorites_table_favorites(mame_2003_plus_table)  update_cached_table("db_mame_2003_plus.lua", mame_2003_plus_table)
            elseif apptype == 36 then   update_favorites_table_favorites(mame_2000_table)       update_cached_table("db_mame_2000.lua", mame_2000_table)
            elseif apptype == 37 then   update_favorites_table_favorites(neogeo_table)          update_cached_table("db_neogeo.lua", neogeo_table)
            elseif apptype == 38 then   update_favorites_table_favorites(ngpc_table)            update_cached_table("db_ngpc.lua", ngpc_table)
            elseif showCat == 39 then   update_favorites_table_favorites(psm_table)             update_cached_table("db_psm.lua", psm_table)
            else    
            end

        elseif showCat == 41 then
            -- Find game in other tables and update
            if apptype == 0 then        update_favorites_table_recent(homebrews_table)       update_cached_table("db_homebrews.lua", homebrews_table)    
            elseif apptype == 1 then    update_favorites_table_recent(games_table)           update_cached_table("db_games.lua", games_table)
            elseif apptype == 2 then    update_favorites_table_recent(psp_table)             update_cached_table("db_psp.lua", psp_table)
            elseif apptype == 3 then    update_favorites_table_recent(psx_table)             update_cached_table("db_psx.lua", psx_table) 
            elseif apptype == 5 then    update_favorites_table_recent(n64_table)             update_cached_table("db_n64.lua", n64_table)
            elseif apptype == 6 then    update_favorites_table_recent(snes_table)            update_cached_table("db_snes.lua", snes_table)
            elseif apptype == 7 then    update_favorites_table_recent(nes_table)             update_cached_table("db_nes.lua", nes_table)
            elseif apptype == 8 then    update_favorites_table_recent(gba_table)             update_cached_table("db_gba.lua", gba_table)
            elseif apptype == 9 then    update_favorites_table_recent(gbc_table)             update_cached_table("db_gbc.lua", gbc_table)
            elseif apptype == 10 then   update_favorites_table_recent(gb_table)              update_cached_table("db_gb.lua", gb_table)
            elseif apptype == 11 then   update_favorites_table_recent(dreamcast_table)       update_cached_table("dreamcast_table.lua", dreamcast_table)
            elseif apptype == 12 then   update_favorites_table_recent(sega_cd_table)         update_cached_table("db_sega_cd.lua", sega_cd_table)
            elseif apptype == 13 then   update_favorites_table_recent(s32x_table)            update_cached_table("db_32x.lua", s32x_table)
            elseif apptype == 14 then   update_favorites_table_recent(md_table)              update_cached_table("db_md.lua", md_table)
            elseif apptype == 15 then   update_favorites_table_recent(sms_table)             update_cached_table("db_sms.lua", sms_table)
            elseif apptype == 16 then   update_favorites_table_recent(gg_table)              update_cached_table("db_gg.lua", gg_table)
            elseif apptype == 17 then   update_favorites_table_recent(tg16_table)            update_cached_table("db_tg16.lua", tg16_table)
            elseif apptype == 18 then   update_favorites_table_recent(tgcd_table)            update_cached_table("db_tgcd.lua", tgcd_table)
            elseif apptype == 19 then   update_favorites_table_recent(pce_table)             update_cached_table("db_pce.lua", pce_table)
            elseif apptype == 20 then   update_favorites_table_recent(pcecd_table)           update_cached_table("db_pcecd.lua", pcecd_table)
            elseif apptype == 21 then   update_favorites_table_recent(amiga_table)           update_cached_table("db_amiga.lua", amiga_table)
            elseif apptype == 22 then   update_favorites_table_recent(c64_table)             update_cached_table("db_c64.lua", c64_table)
            elseif apptype == 23 then   update_favorites_table_recent(wswan_col_table)       update_cached_table("db_wswan_col.lua", wswan_col_table)
            elseif apptype == 24 then   update_favorites_table_recent(wswan_table)           update_cached_table("db_wswan.lua", wswan_table)
            elseif apptype == 25 then   update_favorites_table_recent(msx2_table)            update_cached_table("db_msx2.lua", msx2_table)
            elseif apptype == 26 then   update_favorites_table_recent(msx1_table)            update_cached_table("db_msx1.lua", msx1_table)
            elseif apptype == 27 then   update_favorites_table_recent(zxs_table)             update_cached_table("db_zxs.lua", zxs_table)
            elseif apptype == 28 then   update_favorites_table_recent(atari_7800_table)      update_cached_table("db_atari_7800.lua", atari_7800_table)
            elseif apptype == 29 then   update_favorites_table_recent(atari_5200_table)      update_cached_table("db_atari_5200.lua", atari_5200_table)
            elseif apptype == 30 then   update_favorites_table_recent(atari_2600_table)      update_cached_table("db_atari_2600.lua", atari_2600_table)
            elseif apptype == 31 then   update_favorites_table_recent(atari_lynx_table)      update_cached_table("db_atari_lynx.lua", atari_lynx_table)
            elseif apptype == 32 then   update_favorites_table_recent(colecovision_table)    update_cached_table("db_colecovision.lua", colecovision_table)
            elseif apptype == 33 then   update_favorites_table_recent(vectrex_table)         update_cached_table("db_vectrex.lua", vectrex_table)
            elseif apptype == 34 then   update_favorites_table_recent(fba_table)             update_cached_table("db_fba.lua", fba_table)
            elseif apptype == 35 then   update_favorites_table_recent(mame_2003_plus_table)  update_cached_table("db_mame_2003_plus.lua", mame_2003_plus_table)
            elseif apptype == 36 then   update_favorites_table_recent(mame_2000_table)       update_cached_table("db_mame_2000.lua", mame_2000_table)
            elseif apptype == 37 then   update_favorites_table_recent(neogeo_table)          update_cached_table("db_neogeo.lua", neogeo_table)
            elseif apptype == 38 then   update_favorites_table_recent(ngpc_table)            update_cached_table("db_ngpc.lua", ngpc_table)
            elseif apptype == 39 then   update_favorites_table_recent(psm_table)             update_cached_table("db_psm.lua", psm_table)
            else    
            end

        elseif showCat == 42 then
            -- Find game in other tables and update
            if apptype == 0 then        update_favorites_table_recent(homebrews_table)       update_cached_table("db_homebrews.lua", homebrews_table) 
            elseif apptype == 1 then    update_favorites_table_recent(games_table)           update_cached_table("db_games.lua", games_table)
            elseif apptype == 2 then    update_favorites_table_recent(psp_table)             update_cached_table("db_psp.lua", psp_table)
            elseif apptype == 3 then    update_favorites_table_recent(psx_table)             update_cached_table("db_psx.lua", psx_table) 
            elseif apptype == 5 then    update_favorites_table_recent(n64_table)             update_cached_table("db_n64.lua", n64_table)
            elseif apptype == 6 then    update_favorites_table_recent(snes_table)            update_cached_table("db_snes.lua", snes_table)
            elseif apptype == 7 then    update_favorites_table_recent(nes_table)             update_cached_table("db_nes.lua", nes_table)
            elseif apptype == 8 then    update_favorites_table_recent(gba_table)             update_cached_table("db_gba.lua", gba_table)
            elseif apptype == 9 then    update_favorites_table_recent(gbc_table)             update_cached_table("db_gbc.lua", gbc_table)
            elseif apptype == 10 then   update_favorites_table_recent(gb_table)              update_cached_table("db_gb.lua", gb_table)
            elseif apptype == 11 then   update_favorites_table_recent(dreamcast_table)       update_cached_table("db_dreamcast.lua", dreamcast_table)
            elseif apptype == 12 then   update_favorites_table_recent(sega_cd_table)         update_cached_table("db_sega_cd.lua", sega_cd_table)
            elseif apptype == 13 then   update_favorites_table_recent(s32x_table)            update_cached_table("db_32x.lua", s32x_table)
            elseif apptype == 14 then   update_favorites_table_recent(md_table)              update_cached_table("db_md.lua", md_table)
            elseif apptype == 15 then   update_favorites_table_recent(sms_table)             update_cached_table("db_sms.lua", sms_table)
            elseif apptype == 16 then   update_favorites_table_recent(gg_table)              update_cached_table("db_gg.lua", gg_table)
            elseif apptype == 17 then   update_favorites_table_recent(tg16_table)            update_cached_table("db_tg16.lua", tg16_table)
            elseif apptype == 18 then   update_favorites_table_recent(tgcd_table)            update_cached_table("db_tgcd.lua", tgcd_table)
            elseif apptype == 19 then   update_favorites_table_recent(pce_table)             update_cached_table("db_pce.lua", pce_table)
            elseif apptype == 20 then   update_favorites_table_recent(pcecd_table)           update_cached_table("db_pcecd.lua", pcecd_table)
            elseif apptype == 21 then   update_favorites_table_recent(amiga_table)           update_cached_table("db_amiga.lua", amiga_table)
            elseif apptype == 22 then   update_favorites_table_recent(c64_table)             update_cached_table("db_c64.lua", c64_table)
            elseif apptype == 23 then   update_favorites_table_recent(wswan_col_table)       update_cached_table("db_wswan_col.lua", wswan_col_table)
            elseif apptype == 24 then   update_favorites_table_recent(wswan_table)           update_cached_table("db_wswan.lua", wswan_table)
            elseif apptype == 25 then   update_favorites_table_recent(msx2_table)            update_cached_table("db_msx2.lua", msx2_table)
            elseif apptype == 26 then   update_favorites_table_recent(msx1_table)            update_cached_table("db_msx1.lua", msx1_table)
            elseif apptype == 27 then   update_favorites_table_recent(zxs_table)             update_cached_table("db_zxs.lua", zxs_table)
            elseif apptype == 28 then   update_favorites_table_recent(atari_7800_table)      update_cached_table("db_atari_7800.lua", atari_7800_table)
            elseif apptype == 29 then   update_favorites_table_recent(atari_5200_table)      update_cached_table("db_atari_5200.lua", atari_5200_table)
            elseif apptype == 30 then   update_favorites_table_recent(atari_2600_table)      update_cached_table("db_atari_2600.lua", atari_2600_table)
            elseif apptype == 31 then   update_favorites_table_recent(atari_lynx_table)      update_cached_table("db_atari_lynx.lua", atari_lynx_table)
            elseif apptype == 32 then   update_favorites_table_recent(colecovision_table)    update_cached_table("db_colecovision.lua", colecovision_table)
            elseif apptype == 33 then   update_favorites_table_recent(vectrex_table)         update_cached_table("db_vectrex.lua", vectrex_table)
            elseif apptype == 34 then   update_favorites_table_recent(fba_table)             update_cached_table("db_fba.lua", fba_table)
            elseif apptype == 35 then   update_favorites_table_recent(mame_2003_plus_table)  update_cached_table("db_mame_2003_plus.lua", mame_2003_plus_table)
            elseif apptype == 36 then   update_favorites_table_recent(mame_2000_table)       update_cached_table("db_mame_2000.lua", mame_2000_table)
            elseif apptype == 37 then   update_favorites_table_recent(neogeo_table)          update_cached_table("db_neogeo.lua", neogeo_table)
            elseif apptype == 38 then   update_favorites_table_recent(ngpc_table)            update_cached_table("db_ngpc.lua", ngpc_table)
            elseif apptype == 39 then   update_favorites_table_recent(psm_table)             update_cached_table("db_psm.lua", psm_table)
            else    
            end

        else
            -- Find game in files tables and update
            if apptype == 0 then        update_favorites_table_files(homebrews_table)       update_cached_table("db_homebrews.lua", homebrews_table)  
            elseif apptype == 1 then    update_favorites_table_files(games_table)           update_cached_table("db_games.lua", games_table)
            elseif apptype == 2 then    update_favorites_table_files(psp_table)             update_cached_table("db_psp.lua", psp_table)
            elseif apptype == 3 then    update_favorites_table_files(psx_table)             update_cached_table("db_psx.lua", psx_table) 
            elseif apptype == 5 then    update_favorites_table_files(n64_table)             update_cached_table("db_n64.lua", n64_table)
            elseif apptype == 6 then    update_favorites_table_files(snes_table)            update_cached_table("db_snes.lua", snes_table)
            elseif apptype == 7 then    update_favorites_table_files(nes_table)             update_cached_table("db_nes.lua", nes_table)
            elseif apptype == 8 then    update_favorites_table_files(gba_table)             update_cached_table("db_gba.lua", gba_table)
            elseif apptype == 9 then    update_favorites_table_files(gbc_table)             update_cached_table("db_gbc.lua", gbc_table)
            elseif apptype == 10 then   update_favorites_table_files(gb_table)              update_cached_table("db_gb.lua", gb_table)
            elseif apptype == 11 then   update_favorites_table_files(dreamcast_table)       update_cached_table("dreamcast_table.lua", dreamcast_table)
            elseif apptype == 12 then   update_favorites_table_files(sega_cd_table)         update_cached_table("db_sega_cd.lua", sega_cd_table)
            elseif apptype == 13 then   update_favorites_table_files(s32x_table)            update_cached_table("db_32x.lua", s32x_table)
            elseif apptype == 14 then   update_favorites_table_files(md_table)              update_cached_table("db_md.lua", md_table)
            elseif apptype == 15 then   update_favorites_table_files(sms_table)             update_cached_table("db_sms.lua", sms_table)
            elseif apptype == 16 then   update_favorites_table_files(gg_table)              update_cached_table("db_gg.lua", gg_table)
            elseif apptype == 17 then   update_favorites_table_files(tg16_table)            update_cached_table("db_tg16.lua", tg16_table)
            elseif apptype == 18 then   update_favorites_table_files(tgcd_table)            update_cached_table("db_tgcd.lua", tgcd_table)
            elseif apptype == 19 then   update_favorites_table_files(pce_table)             update_cached_table("db_pce.lua", pce_table)
            elseif apptype == 20 then   update_favorites_table_files(pcecd_table)           update_cached_table("db_pcecd.lua", pcecd_table)
            elseif apptype == 21 then   update_favorites_table_files(amiga_table)           update_cached_table("db_amiga.lua", amiga_table)
            elseif apptype == 22 then   update_favorites_table_files(c64_table)             update_cached_table("db_c64.lua", c64_table)
            elseif apptype == 23 then   update_favorites_table_files(wswan_col_table)       update_cached_table("db_wswan_col.lua", wswan_col_table)
            elseif apptype == 24 then   update_favorites_table_files(wswan_table)           update_cached_table("db_wswan.lua", wswan_table)
            elseif apptype == 25 then   update_favorites_table_files(msx2_table)            update_cached_table("db_msx2.lua", msx2_table)
            elseif apptype == 26 then   update_favorites_table_files(msx1_table)            update_cached_table("db_msx1.lua", msx1_table)
            elseif apptype == 27 then   update_favorites_table_files(zxs_table)             update_cached_table("db_zxs.lua", zxs_table)
            elseif apptype == 28 then   update_favorites_table_files(atari_7800_table)      update_cached_table("db_atari_7800.lua", atari_7800_table)
            elseif apptype == 29 then   update_favorites_table_files(atari_5200_table)      update_cached_table("db_atari_5200.lua", atari_5200_table)
            elseif apptype == 30 then   update_favorites_table_files(atari_2600_table)      update_cached_table("db_atari_2600.lua", atari_2600_table)
            elseif apptype == 31 then   update_favorites_table_files(atari_lynx_table)      update_cached_table("db_atari_lynx.lua", atari_lynx_table)
            elseif apptype == 32 then   update_favorites_table_files(colecovision_table)    update_cached_table("db_colecovision.lua", colecovision_table)
            elseif apptype == 33 then   update_favorites_table_files(vectrex_table)         update_cached_table("db_vectrex.lua", vectrex_table)
            elseif apptype == 34 then   update_favorites_table_files(fba_table)             update_cached_table("db_fba.lua", fba_table)
            elseif apptype == 35 then   update_favorites_table_files(mame_2003_plus_table)  update_cached_table("db_mame_2003_plus.lua", mame_2003_plus_table)
            elseif apptype == 36 then   update_favorites_table_files(mame_2000_table)       update_cached_table("db_mame_2000.lua", mame_2000_table)
            elseif apptype == 37 then   update_favorites_table_files(neogeo_table)          update_cached_table("db_neogeo.lua", neogeo_table)
            elseif apptype == 38 then   update_favorites_table_files(ngpc_table)            update_cached_table("db_ngpc.lua", ngpc_table)
            elseif apptype == 39 then   update_favorites_table_files(psm_table)             update_cached_table("db_psm.lua", psm_table)
            else    
            end

        end
        -- update_cached_table("db_files.lua", files_table)
        update_cached_table_recently_played()

        --Reload
        -- FreeIcons()
        -- FreeMemory()
        -- Network.term()

        

    end

end


function AddOrRemoveHidden(def_hide_game_flag)

    -- Recent cat
    if showCat == 41 then

        -- Update recent table
        if #recently_played_table ~= nil then
            recently_played_table[p].hidden=(def_hide_game_flag)
        end
        update_cached_table_recently_played()

        -- Update app type table
        local key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
        if key ~= nil then
            xAppNumTableLookup(apptype)[key].hidden=(def_hide_game_flag)
            update_cached_table(xAppDbFileLookup(apptype), xAppNumTableLookup(apptype))
        else
        end

    -- Other cats
    else
        -- Update app type table
        xAppNumTableLookup(apptype)[p].hidden=(def_hide_game_flag)
        update_cached_table(xAppDbFileLookup(apptype), xAppNumTableLookup(apptype))

        -- Update recent table
        if #recently_played_table ~= nil then
            local key = find_game_table_pos_key(recently_played_table, app_titleid)
            if key ~= nil then
                recently_played_table[key].hidden=(def_hide_game_flag)
                update_cached_table_recently_played()
            else
            end
        else
        end
        
    end

end


function AddtoRecentlyPlayed()

    -- Get system date and time
    day_num, dd, mm, yyyy = System.getDate()
    h,m,s = System.getTime()

    -- Format numbers to double digits
    if string.len(mm) == 1 then mm = "0" .. mm end
    if string.len(dd) == 1 then dd = "0" .. dd end
    if string.len(h) == 1 then h = "0" .. h end
    if string.len(m) == 1 then m = "0" .. m end
    if string.len(s) == 1 then s = "0" .. s end

    -- Create timestamp string
    timestamp = tonumber(yyyy .. mm .. dd .. h .. m .. s)
    
    recently_played_new = {}
    already_played = false

    -- If game in Recently played list - Update timestamp
    for k, v in pairs(recently_played_table) do
        if v.filename==filename then
            already_played = true
            v.date_played=timestamp
        end
    end

    if already_played == false then
        -- Lookup apptype and find relevent table, update timestamp and insert to recent
        for k, v in pairs(xAppNumTableLookup(apptype)) do 
            if v.filename==filename and already_played == false then
                v.date_played=timestamp
                table.insert(recently_played_new, v)
            else
            end
        end
    end

    -- Copy the recently played table to a new table
    for k, v in pairs(recently_played_table) do
        table.insert(recently_played_new, v)
    end


    -- Sort new table by date
    table.sort(recently_played_new, function(a, b) return (tonumber(a.date_played) > tonumber(b.date_played)) end)

    -- Select 20 most recent from new table and add to a newer table ready for saving
    recently_played_pre_launch_table = {}
    for k, v in pairs(recently_played_new) do
        if k < 21 then -- Limit to 20 games
            table.insert(recently_played_pre_launch_table, v)
        end
    end

end


function QuickOverride_Remove_from_current_table()
    if #xAppNumTableLookup(apptype) ~= nil then
        local key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
        if key ~= nil then
            table.remove(xAppNumTableLookup(apptype), key)
            update_cached_table(xAppDbFileLookup(apptype), xAppNumTableLookup(apptype))
        else
        end
    end
end

function QuickOverride_Vita()
    xAppNumTableLookup(apptype)[key].app_type = 1
    xAppNumTableLookup(apptype)[key].cover_path_online = SystemsToScan[1].onlineCoverPathSystem
    xAppNumTableLookup(apptype)[key].cover_path_local = SystemsToScan[1].localCoverPath
    xAppNumTableLookup(apptype)[key].snap_path_online = SystemsToScan[1].onlineSnapPathSystem
    xAppNumTableLookup(apptype)[key].snap_path_local = SystemsToScan[1].localSnapPath
    -- Cover
    if System.doesFileExist(SystemsToScan[1].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[1].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png" --custom cover by app name
    elseif System.doesFileExist(SystemsToScan[1].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[1].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png" --custom cover by app id
    elseif System.doesFileExist("ur0:/appmeta/" .. xAppNumTableLookup(apptype)[key].name .. "/icon0.png") then
        xAppNumTableLookup(apptype)[key].icon_path = "ur0:/appmeta/" .. xAppNumTableLookup(apptype)[key].name .. "/icon0.png"  --app icon
    elseif System.doesFileExist("app0:/DATA/missing_cover_psv.png") then
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/missing_cover_psv.png"
    else
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/noimg.png"
    end
end

function QuickOverride_PSP()
    xAppNumTableLookup(apptype)[key].app_type = 2
    xAppNumTableLookup(apptype)[key].cover_path_online = SystemsToScan[3].onlineCoverPathSystem
    xAppNumTableLookup(apptype)[key].cover_path_local = SystemsToScan[3].localCoverPath
    xAppNumTableLookup(apptype)[key].snap_path_online = SystemsToScan[3].onlineSnapPathSystem
    xAppNumTableLookup(apptype)[key].snap_path_local = SystemsToScan[3].localSnapPath
    -- Cover
    if System.doesFileExist(SystemsToScan[3].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[3].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png" --custom cover by app name
    elseif System.doesFileExist(SystemsToScan[3].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[3].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png" --custom cover by app id
    elseif System.doesFileExist("app0:/DATA/missing_cover_psp.png") then
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/missing_cover_psp.png"  --app icon
    else
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/noimg.png" --blank grey
    end
end

function QuickOverride_PSX()
    xAppNumTableLookup(apptype)[key].app_type = 3
    xAppNumTableLookup(apptype)[key].cover_path_online = SystemsToScan[4].onlineCoverPathSystem
    xAppNumTableLookup(apptype)[key].cover_path_local = SystemsToScan[4].localCoverPath
    xAppNumTableLookup(apptype)[key].snap_path_online = SystemsToScan[4].onlineSnapPathSystem
    xAppNumTableLookup(apptype)[key].snap_path_local = SystemsToScan[4].localSnapPath
    -- Cover
    if System.doesFileExist(SystemsToScan[4].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[4].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png" --custom cover by app name
    elseif System.doesFileExist(SystemsToScan[4].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[4].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png" --custom cover by app id
    elseif System.doesFileExist("app0:/DATA/missing_cover_psx.png") then
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/missing_cover_psx.png"  --app icon
    else
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/noimg.png" --blank grey
    end
end

function QuickOverride_Homebrew()
    xAppNumTableLookup(apptype)[key].app_type = 0
    xAppNumTableLookup(apptype)[key].cover_path_online = SystemsToScan[2].onlineCoverPathSystem
    xAppNumTableLookup(apptype)[key].cover_path_local = SystemsToScan[2].localCoverPath
    xAppNumTableLookup(apptype)[key].snap_path_online = SystemsToScan[2].onlineSnapPathSystem
    xAppNumTableLookup(apptype)[key].snap_path_local = SystemsToScan[2].localSnapPath
    -- Cover
    if System.doesFileExist(SystemsToScan[2].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[2].localCoverPath .. xAppNumTableLookup(apptype)[key].apptitle .. ".png" --custom cover by app name
    elseif System.doesFileExist(SystemsToScan[2].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png") then
        xAppNumTableLookup(apptype)[key].icon_path = SystemsToScan[2].localCoverPath .. xAppNumTableLookup(apptype)[key].name .. ".png" --custom cover by app id
    elseif System.doesFileExist("ur0:/appmeta/" .. xAppNumTableLookup(apptype)[key].name .. "/icon0.png") then
        xAppNumTableLookup(apptype)[key].icon_path = "ur0:/appmeta/" .. xAppNumTableLookup(apptype)[key].name .. "/icon0.png"  --app icon
    elseif System.doesFileExist("app0:/DATA/icon_homebrew.png") then
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/icon_homebrew.png"
    else
        xAppNumTableLookup(apptype)[key].icon_path = "app0:/DATA/noimg.png" --blank grey
    end
end

function QuickOverride_Category(tmpappcat)

    -- Remove current game from table

        if (tmpappcat)==1 then
            -- vita
            if #xAppNumTableLookup(apptype) ~= nil then
                key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                if key ~= nil then
                    QuickOverride_Vita()

                    if #recently_played_table ~= nil then
                        key_recent = find_game_table_pos_key(recently_played_table, app_titleid)
                        if key_recent ~= nil then
                            table.remove(recently_played_table,key_recent)
                            table.insert(recently_played_table, xAppNumTableLookup(apptype)[key])
                            update_cached_table_recently_played()
                            recently_played_table = {}
                            import_recently_played()
                        else
                        end
                    end

                    table.insert(games_table, xAppNumTableLookup(apptype)[key])
                    table.sort(games_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
                    update_cached_table("db_games.lua", games_table)
                else
                end
            end

        elseif (tmpappcat)==2 then
            -- psp
            if #xAppNumTableLookup(apptype) ~= nil then
                key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                if key ~= nil then
                    QuickOverride_PSP()

                    if #recently_played_table ~= nil then
                        key_recent = find_game_table_pos_key(recently_played_table, app_titleid)
                        if key_recent ~= nil then
                            table.remove(recently_played_table,key_recent)
                            table.insert(recently_played_table, xAppNumTableLookup(apptype)[key])
                            update_cached_table_recently_played()
                            recently_played_table = {}
                            import_recently_played()
                        else
                        end
                    end

                    table.insert(psp_table, xAppNumTableLookup(apptype)[key])
                    table.sort(psp_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
                    update_cached_table("db_psp.lua", psp_table)
                else
                end
            end
            
        elseif (tmpappcat)==3 then
            -- psx
            if #xAppNumTableLookup(apptype) ~= nil then
                key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                if key ~= nil then
                    QuickOverride_PSX()

                    if #recently_played_table ~= nil then
                        key_recent = find_game_table_pos_key(recently_played_table, app_titleid)
                        if key_recent ~= nil then
                            table.remove(recently_played_table,key_recent)
                            table.insert(recently_played_table, xAppNumTableLookup(apptype)[key])
                            update_cached_table_recently_played()
                            recently_played_table = {}
                            import_recently_played()
                        else
                        end
                    end

                    table.insert(psx_table, xAppNumTableLookup(apptype)[key])
                    table.sort(psx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
                    update_cached_table("db_psx.lua", psx_table)
                else
                end
            end
            
        elseif (tmpappcat)==4 then
            -- homebrew
            
            -- If homebrew is hidden then Temporarily import for caching
            if showHomebrews == 0 and #homebrews_table == 0 then
                if System.doesFileExist("ux0:/data/RetroFlow/CACHE/db_homebrews.lua") then
                    import_cached_DB_tables("db_homebrews.lua", homebrews_table)
                else
                end
            else
            end

            if #xAppNumTableLookup(apptype) ~= nil then
                key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                if key ~= nil then
                    QuickOverride_Homebrew()

                    if #recently_played_table ~= nil then
                        key_recent = find_game_table_pos_key(recently_played_table, app_titleid)
                        if key_recent ~= nil then
                            table.remove(recently_played_table,key_recent)
                            table.insert(recently_played_table, xAppNumTableLookup(apptype)[key])
                            update_cached_table_recently_played()
                            recently_played_table = {}
                            import_recently_played()
                        else
                        end
                    end

                    table.insert(homebrews_table, xAppNumTableLookup(apptype)[key])
                    table.sort(homebrews_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
                    update_cached_table("db_homebrews.lua", homebrews_table)
                else
                end
            end

            -- Remove homebrew if hidden
            if showHomebrews == 0 and #homebrews_table ~= nil then
                for l, file in pairs(files_table) do
                    if file.app_type == 0 then
                        table.remove(files_table,l)
                    else
                    end
                end
                homebrews_table = {}
            end

            -- Remove hidden games from homebrew
            if showHidden == 0 and #homebrews_table ~= nil then
                for l, file in pairs(homebrews_table) do
                    if file.hidden == true then
                        table.remove(homebrews_table,l)
                    else
                    end
                end
            end
            
        else

        end

        QuickOverride_Remove_from_current_table()

    -- If the last game is overriden, move to 1st to prevent nil error
    if p == curTotal then
        p = 1
        master_index = p
    end

    -- force icon change. Credit BlackSheepBoy69
    -- xCatLookup(showCat)[p].ricon = Graphics.loadImage(xCatLookup(showCat)[p].icon_path)

    -- Error fix for when Homebrew is off, overriding game to homebrew, and on all category - then reload files
    if showHomebrews == 0 and (tmpappcat)==4 and showCat == 0 then
        files_table = import_cached_DB()
        GetInfoSelected()
    end

    GetInfoSelected()
    oldpad = pad -- Prevents it from launching next game accidentally. Credit BlackSheepBoy69
    showMenu = 0

    Render.useTexture(modBackground, imgCustomBack)

    -- Instant cover update - Credit BlackSheepBoy69
    Threads.addTask(xCatLookup(showCat)[p], {
    Type = "ImageLoad",
    Path = xCatLookup(showCat)[p].icon_path,
    Table = xCatLookup(showCat)[p],
    Index = "ricon"
    })

end

function check_for_out_of_bounds()
    curTotal = #xCatLookup(showCat)
    if curTotal == 0 then
        p = 0 
        master_index = p
    end
    if p < 1 then
        p = curTotal
        if p >= 1 then
            master_index = p -- 0
        end
        startCovers = false
        GetInfoSelected()
    elseif p > curTotal then
        p = 1
        master_index = p
        startCovers = false
        GetInfoSelected()
    end
end

function OverrideCategory()
    if System.doesFileExist(cur_dir .. "/overrides.dat") then
        local inf = assert(io.open(cur_dir .. "/overrides.dat", "rw"), "Failed to open overrides.dat")
        local lines = ""
        while(true) do
            local line = inf:read("*line")
            if not line then break end
            
            if not string.find(line, app_titleid .. "", 1) then
                lines = lines .. line .. "\n"
            end
        end
        if tmpappcat>0 then
            lines = lines .. app_titleid .. "=" .. tmpappcat .. "\n"
        end
        inf:close()
        file_override = io.open(cur_dir .. "/overrides.dat", "w")
        file_override:write(lines)
        file_override:close()
        
        -- if startupScan == 0 then -- 0 Off, 1 On
        --     -- Startup scan is OFF
        --     -- Scan folders and games
        --     files_table = listDirectory(System.currentDirectory())
        --     -- Import Cached Database
        --     files_table = import_cached_DB()
        -- else
        -- end

        -- --Reload
        -- FreeIcons()
        -- FreeMemory()
        -- Network.term()
        -- dofile("app0:index.lua")

        if tmpappcat == 0 then
            -- Get default apptype from table
            key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
            if key ~= nil then
                tmpappcat = xAppNumTableLookup(apptype)[key].app_type_default
                -- If default apptype = 0 (homebrew) set to 4 
                if tmpappcat == 0 then
                    tmpappcat = 4
                end
            else
            end
        end

        QuickOverride_Category(tmpappcat)

    end
end

function DownloadCovers()
    local txt = lang_lines.Downloading_covers .. "..."
    --          Downloading covers
    local old_txt = txt
    local percent = 0
    local old_percent = 0
    local cvrfound = 0
    
    local app_idx = 1
    local running = false
    status = System.getMessageState()
    
    if Network.isWifiEnabled() then

        -- getCovers - 0 All, 1 PSV, 2 PSP, 3 PS1, 4 N64, 5 SNES, 6 NES, 7 GBA, 8 GBC, 9 GB, 10 MD, 11 SMS, 12 GG, 13 MAME, 14 AMIGA, 15 TG16, 16 TGCD, 17 PCE, 18 PCECD, 19 NGPC

        function DownloadCovers_System(def_getCovers, def_table_name, def_lang_lines_Downloading_SysName_covers)
                    
            if getCovers == 0 then -- sort all games by system
                table.sort(return_table, function(a, b) return (a.app_type < b.app_type) end)
            end

            if getCovers==(def_getCovers) and #(def_table_name) > 0 then -- Check getcover number against system
                
                if status ~= RUNNING then
                    if scanComplete == false then
                        System.setMessage("Downloading covers...", true)
                        System.setMessageProgMsg(txt)
                        
                        while app_idx <= #(def_table_name) do

                            if System.getAsyncState() ~= 0 then
                                -- Only downloading missing covers

                                -- Check if cover already exists
                                if System.doesFileExist((def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].name:gsub("%%","%%%%") .. ".png") or System.doesFileExist((def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].apptitle .. ".png") then
                                    -- Found - do nothing
                                else
                                    -- Not found - download
                                    Network.downloadFileAsync((def_table_name)[app_idx].cover_path_online .. (def_table_name)[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name:gsub("%%","%%%%") .. ".png")
                                    running = true
                                end
                            end
                            if System.getAsyncState() == 1 then
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                running = false
                            end
                            if running == false then

                                -- Check if cover already exists
                                if System.doesFileExist((def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].name .. ".png") or System.doesFileExist((def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].apptitle .. ".png") then
                                    -- Found - move on
                                    cvrfound = cvrfound + 1
                                    percent = (app_idx / #(def_table_name)) * 100
                                    clean_name = (def_table_name)[app_idx].name:gsub("\n","")
                                    txt = (def_lang_lines_Downloading_SysName_covers) .. "...\n" .. lang_lines.Cover .. " " .. clean_name .. "\n" .. lang_lines.Found .. " " .. cvrfound .. lang_lines.of .. #(def_table_name)

                                    Graphics.initBlend()
                                    Graphics.termBlend()
                                    Screen.flip()
                                    app_idx = app_idx + 1

                                else
                                    -- Cover doesn't already exist- If it has been downloaded, check size and move to directory, then move on
                                    if System.doesFileExist("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png") then
                                        tmpfile = System.openFile("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png", FREAD)
                                        size = System.sizeFile(tmpfile)
                                        if size < 1024 then
                                            System.deleteFile("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png")

                                        else
                                            System.rename("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png", (def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].name .. ".png")
                                            cvrfound = cvrfound + 1

                                            -- Update table
                                            (def_table_name)[app_idx].icon_path = (def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].name .. ".png"

                                            -- Is the game in the recently played list?
                                            if #recently_played_table ~= nil then
                                                local key = find_game_table_pos_key(recently_played_table, (def_table_name)[app_idx].name)
                                                if key ~= nil then
                                                    -- Yes - Found in files table
                                                    recently_played_table[key].icon_path = (def_table_name)[app_idx].cover_path_local .. (def_table_name)[app_idx].name .. ".png"
                                                else
                                                    -- No
                                                end
                                            else
                                            end
                                            
                                        end
                                        System.closeFile(tmpfile)
                                        
                                        percent = (app_idx / #(def_table_name)) * 100
                                        clean_name = (def_table_name)[app_idx].name:gsub("\n","")
                                        txt = (def_lang_lines_Downloading_SysName_covers) .. "...\n" .. lang_lines.Cover .. " " .. clean_name .. "\n" .. lang_lines.Found .. " " .. cvrfound .. lang_lines.of .. #(def_table_name)

                                        Graphics.initBlend()
                                        Graphics.termBlend()
                                        Screen.flip()
                                        app_idx = app_idx + 1
                                    end
                                
                                end

                            end
                            
                            if txt ~= old_txt then
                                System.setMessageProgMsg(txt)
                                old_txt = txt
                            end
                            if percent ~= old_percent then
                                System.setMessageProgress(percent)
                                old_percent = percent
                            end
                        end
                        if app_idx >= #(def_table_name) then
                            System.closeMessage()
                            -- scanComplete = true

                            cache_all_tables()
                            update_cached_table_recently_played()
                            
                            -- Redraw covers for current showcat game category 
                            for k in pairs (xCatLookup(showCat)) do
                                Threads.addTask(xCatLookup(showCat)[k], {
                                Type = "ImageLoad",
                                Path = xCatLookup(showCat)[k].icon_path,
                                Table = xCatLookup(showCat)[k],
                                Index = "ricon"
                                })
                            end
                        end
                    else
                    end
                end
            end

            if getCovers == 0 then -- sort all games by app title
                table.sort(return_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
            end
        end

        -- def_getCovers, def_table_name, def_lang_lines_Downloading_SysName_covers)
        DownloadCovers_System(0,    return_table,           lang_lines.Downloading_all_covers)
        DownloadCovers_System(1,    games_table,            lang_lines.Downloading_PS_Vita_covers)
        DownloadCovers_System(2,    psp_table,              lang_lines.Downloading_PSP_covers)
        DownloadCovers_System(3,    psx_table,              lang_lines.Downloading_PS1_covers)
                                                   -- Homebrew is number 4 kicking out numbers
        DownloadCovers_System(4,    n64_table,              lang_lines.Downloading_N64_covers)
        DownloadCovers_System(5,    snes_table,             lang_lines.Downloading_SNES_covers)
        DownloadCovers_System(6,    nes_table,              lang_lines.Downloading_NES_covers)
        DownloadCovers_System(7,    gba_table,              lang_lines.Downloading_GBA_covers)
        DownloadCovers_System(8,    gbc_table,              lang_lines.Downloading_GBC_covers)
        DownloadCovers_System(9,    gb_table,               lang_lines.Downloading_GB_covers)
        DownloadCovers_System(10,   dreamcast_table,        lang_lines.Downloading_DC_covers)
        DownloadCovers_System(11,   sega_cd_table,          lang_lines.Downloading_SCD_covers)
        DownloadCovers_System(12,   s32x_table,             lang_lines.Downloading_32X_covers)
        DownloadCovers_System(13,   md_table,               lang_lines.Downloading_MD_covers)
        DownloadCovers_System(14,   sms_table,              lang_lines.Downloading_SMS_covers)
        DownloadCovers_System(15,   gg_table,               lang_lines.Downloading_GG_covers)
        DownloadCovers_System(16,   tg16_table,             lang_lines.Downloading_TG_16_covers)
        DownloadCovers_System(17,   tgcd_table,             lang_lines.Downloading_TG_CD_covers)
        DownloadCovers_System(18,   pce_table,              lang_lines.Downloading_PCE_covers)
        DownloadCovers_System(19,   pcecd_table,            lang_lines.Downloading_PCE_CD_covers)
        DownloadCovers_System(20,   amiga_table,            lang_lines.Downloading_AMIGA_covers)
        DownloadCovers_System(21,   c64_table,              lang_lines.Downloading_C64_covers)
        DownloadCovers_System(22,   wswan_col_table,        lang_lines.Downloading_WSWANCOL_covers)
        DownloadCovers_System(23,   wswan_table,            lang_lines.Downloading_WSWAN_covers)
        DownloadCovers_System(24,   msx2_table,             lang_lines.Downloading_MSX2_covers)
        DownloadCovers_System(25,   msx1_table,             lang_lines.Downloading_MSX_covers)
        DownloadCovers_System(26,   zxs_table,              lang_lines.Downloading_ZXS_covers)
        DownloadCovers_System(27,   atari_7800_table,       lang_lines.Downloading_A7800_covers)
        DownloadCovers_System(28,   atari_5200_table,       lang_lines.Downloading_A5200_covers)
        DownloadCovers_System(29,   atari_2600_table,       lang_lines.Downloading_A600_covers)
        DownloadCovers_System(30,   atari_lynx_table,       lang_lines.Downloading_LYNX_covers)
        DownloadCovers_System(31,   colecovision_table,     lang_lines.Downloading_COLECO_covers)
        DownloadCovers_System(32,   vectrex_table,          lang_lines.Downloading_VECTREX_covers)
        DownloadCovers_System(33,   fba_table,              lang_lines.Downloading_FBA2012_covers)
        DownloadCovers_System(34,   mame_2003_plus_table,   lang_lines.Downloading_MAME_2003_covers)
        DownloadCovers_System(35,   mame_2000_table,        lang_lines.Downloading_MAME_2000_covers)
        DownloadCovers_System(36,   neogeo_table,           lang_lines.Downloading_NG_covers)
        DownloadCovers_System(37,   ngpc_table,             lang_lines.Downloading_NG_PC_covers)
        

    else
        if status ~= RUNNING then
            System.setMessage(lang_lines.Internet_Connection_Required, false, BUTTON_OK)
        end
    end

    gettingCovers = false
end


function DownloadSnaps()
    local txt = lang_lines.Downloading_backgrounds .. "..."
    --          Downloading covers
    local old_txt = txt
    local percent = 0
    local old_percent = 0
    local bgfound = 0
    
    local app_idx = 1
    local running = false
    status = System.getMessageState()
    
    if Network.isWifiEnabled() then

        -- getSnaps - 0 All, 1 PSV, 2 PSP, 3 PS1, 4 N64, 5 SNES, 6 NES, 7 GBA, 8 GBC, 9 GB, 10 MD, 11 SMS, 12 GG, 13 MAME, 14 AMIGA, 15 TG16, 16 TGCD, 17 PCE, 18 PCECD, 19 NGPC
        
        function DownloadSnaps_System(def_getSnaps, def_table_name, def_lang_lines_Downloading_SysName_backgrounds)
            if  getSnaps==(def_getSnaps) and #(def_table_name) > 0 then -- Check getcover number against system
                
                if status ~= RUNNING then
                    if bgscanComplete == false then
                        System.setMessage("Downloading backgrounds...", true)
                        System.setMessageProgMsg(txt)
                        
                        while app_idx <= #(def_table_name) do

                            if System.getAsyncState() ~= 0 then
                                -- Only downloading missing backgrounds

                                -- Check if background already exists
                                if System.doesFileExist((def_table_name)[app_idx].snap_path_local .. (def_table_name)[app_idx].name:gsub("%%","%%%%") .. ".png") or System.doesFileExist((def_table_name)[app_idx].snap_path_local .. (def_table_name)[app_idx].apptitle .. ".png") then
                                    -- Found - do nothing
                                else
                                    -- Not found - download
                                    Network.downloadFileAsync((def_table_name)[app_idx].snap_path_online .. (def_table_name)[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name:gsub("%%","%%%%") .. ".png")
                                    running = true
                                end

                            end
                            if System.getAsyncState() == 1 then
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                running = false
                            end
                            if running == false then

                                -- Check if background already exists
                                if System.doesFileExist((def_table_name)[app_idx].snap_path_local .. (def_table_name)[app_idx].name .. ".png") or System.doesFileExist((def_table_name)[app_idx].snap_path_local .. (def_table_name)[app_idx].apptitle .. ".png") then
                                    -- Found - move on
                                    bgfound = bgfound + 1
                                    percent = (app_idx / #(def_table_name)) * 100
                                    clean_name = (def_table_name)[app_idx].name:gsub("\n","")
                                    txt = (def_lang_lines_Downloading_SysName_backgrounds) .. "...\n" .. lang_lines.Background .. " " .. clean_name .. "\n" .. lang_lines.Found .. " " .. bgfound .. lang_lines.of .. #(def_table_name)

                                    Graphics.initBlend()
                                    Graphics.termBlend()
                                    Screen.flip()
                                    app_idx = app_idx + 1

                                else 
                                    -- Background doesn't already exist- If it has been downloaded, check size and move to directory, then move on
                                    if System.doesFileExist("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png") then
                                        tmpfile = System.openFile("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png", FREAD)
                                        size = System.sizeFile(tmpfile)
                                        if size < 1024 then
                                            System.deleteFile("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png")
                                        else
                                            System.rename("ux0:/data/RetroFlow/" .. (def_table_name)[app_idx].name .. ".png", (def_table_name)[app_idx].snap_path_local .. (def_table_name)[app_idx].name .. ".png")
                                            bgfound = bgfound + 1
                                            
                                        end
                                        System.closeFile(tmpfile)
                                        
                                        percent = (app_idx / #(def_table_name)) * 100
                                        clean_name = (def_table_name)[app_idx].name:gsub("\n","")
                                        txt = (def_lang_lines_Downloading_SysName_backgrounds) .. "...\n" .. lang_lines.Background .. " " .. clean_name .. "\n" .. lang_lines.Found .. " " .. bgfound .. lang_lines.of .. #(def_table_name)

                                        Graphics.initBlend()
                                        Graphics.termBlend()
                                        Screen.flip()
                                        app_idx = app_idx + 1
                                    end
                                end
                                
                            end
                            
                            if txt ~= old_txt then
                                System.setMessageProgMsg(txt)
                                old_txt = txt
                            end
                            if percent ~= old_percent then
                                System.setMessageProgress(percent)
                                old_percent = percent
                            end
                        end
                        if app_idx >= #(def_table_name) then
                            System.closeMessage()
                            -- bgscanComplete = true
                        end
                    else
                    end
                end
            end
        end

        -- def_getSnaps, def_table_name, def_lang_lines_Downloading_SysName_backgrounds)
        DownloadSnaps_System(0,    bg_table,               lang_lines.Downloading_all_backgrounds)
        -- DownloadSnaps_System(1,    games_table,            lang_lines.Downloading_PSP_backgrounds)
        DownloadSnaps_System(1,    psp_table,              lang_lines.Downloading_PSP_backgrounds)
        DownloadSnaps_System(2,    psx_table,              lang_lines.Downloading_PS1_backgrounds)
                                                   -- Homebrew is number 4 kicking out numbers
        DownloadSnaps_System(3,    n64_table,              lang_lines.Downloading_N64_backgrounds)
        DownloadSnaps_System(4,    snes_table,             lang_lines.Downloading_SNES_backgrounds)
        DownloadSnaps_System(5,    nes_table,              lang_lines.Downloading_NES_backgrounds)
        DownloadSnaps_System(6,    gba_table,              lang_lines.Downloading_GBA_backgrounds)
        DownloadSnaps_System(7,    gbc_table,              lang_lines.Downloading_GBC_backgrounds)
        DownloadSnaps_System(8,    gb_table,               lang_lines.Downloading_GB_backgrounds)
        DownloadSnaps_System(9,    dreamcast_table,        lang_lines.Downloading_DC_backgrounds)
        DownloadSnaps_System(10,   sega_cd_table,          lang_lines.Downloading_SCD_backgrounds)
        DownloadSnaps_System(11,   s32x_table,             lang_lines.Downloading_32X_backgrounds)
        DownloadSnaps_System(12,   md_table,               lang_lines.Downloading_MD_backgrounds)
        DownloadSnaps_System(13,   sms_table,              lang_lines.Downloading_SMS_backgrounds)
        DownloadSnaps_System(14,   gg_table,               lang_lines.Downloading_GG_backgrounds)
        DownloadSnaps_System(15,   tg16_table,             lang_lines.Downloading_TG_16_backgrounds)
        DownloadSnaps_System(16,   tgcd_table,             lang_lines.Downloading_TG_CD_backgrounds)
        DownloadSnaps_System(17,   pce_table,              lang_lines.Downloading_PCE_backgrounds)
        DownloadSnaps_System(18,   pcecd_table,            lang_lines.Downloading_PCE_CD_backgrounds)
        DownloadSnaps_System(19,   amiga_table,            lang_lines.Downloading_AMIGA_backgrounds)
        DownloadSnaps_System(20,   c64_table,              lang_lines.Downloading_C64_backgrounds)
        DownloadSnaps_System(21,   wswan_col_table,        lang_lines.Downloading_WSWANCOL_backgrounds)
        DownloadSnaps_System(22,   wswan_table,            lang_lines.Downloading_WSWAN_backgrounds)
        DownloadSnaps_System(23,   msx2_table,             lang_lines.Downloading_MSX2_backgrounds)
        DownloadSnaps_System(24,   msx1_table,             lang_lines.Downloading_MSX_backgrounds)
        DownloadSnaps_System(25,   zxs_table,              lang_lines.Downloading_ZXS_backgrounds)
        DownloadSnaps_System(26,   atari_7800_table,       lang_lines.Downloading_A7800_backgrounds)
        DownloadSnaps_System(27,   atari_5200_table,       lang_lines.Downloading_A5200_backgrounds)
        DownloadSnaps_System(28,   atari_2600_table,       lang_lines.Downloading_A600_backgrounds)
        DownloadSnaps_System(29,   atari_lynx_table,       lang_lines.Downloading_LYNX_backgrounds)
        DownloadSnaps_System(30,   colecovision_table,     lang_lines.Downloading_COLECO_backgrounds)
        DownloadSnaps_System(31,   vectrex_table,          lang_lines.Downloading_VECTREX_backgrounds)
        DownloadSnaps_System(32,   fba_table,              lang_lines.Downloading_FBA2012_backgrounds)
        DownloadSnaps_System(33,   mame_2003_plus_table,   lang_lines.Downloading_MAME_2003_backgrounds)
        DownloadSnaps_System(34,   mame_2000_table,        lang_lines.Downloading_MAME_2000_backgrounds)
        DownloadSnaps_System(35,   neogeo_table,           lang_lines.Downloading_NG_backgrounds)
        DownloadSnaps_System(36,   ngpc_table,             lang_lines.Downloading_NG_PC_backgrounds)
        
    else
        if status ~= RUNNING then
            System.setMessage(lang_lines.Internet_Connection_Required, false, BUTTON_OK)
        end
        
    end

    gettingBackgrounds = false
end

local function DrawCover(x, y, text, icon, sel, apptype)
    rot = 0
    extraz = 0
    extrax = 0
    extray = 0
    zoom = 0
    camX = 0
    Graphics.setImageFilters(icon, FILTER_LINEAR, FILTER_LINEAR)
    if showView == 1 then
        -- flat zoom out view
        space = 1.6
        zoom = 0
        if x > 0.5 then
            extraz = 6
            extrax = 1
        elseif x < -0.5 then
            extraz = 6
            extrax = -1
        end
    elseif showView == 2 then
        -- zoomin view
        space = 1.6
        zoom = -1
        extray = -0.6
        if x > 0.5 then
            rot = -1
            extraz = 0
            extrax = 1
        elseif x < -0.5 then
            rot = 1
            extraz = 0
            extrax = -1
        end
    elseif showView == 3 then
        -- left side view
        space = 1.5
        zoom = -0.6
        extray = -0.3
        camX = 1
        if x > 0.5 then
            rot = -0.5
            extraz = 2 + (x / 2)
            extrax = 0.6
        elseif x < -0.5 then
            rot = 0.5
            extraz = 2
            extrax = -10
        end
    elseif showView == 4 then
        -- scroll around
        space = 1
        zoom = 0
        if x > 0.5 then
            extraz = 2 + (x / 1.5)
            extrax = 1
        elseif x < -0.5 then
            extraz = 2 - (x / 1.5)
            extrax = -1
        end
    else
        -- default view
        space = 1
        zoom = 0
        if x > 0.5 then
            rot = -1
            extraz = 3
            extrax = 1
        elseif x < -0.5 then
            rot = 1
            extraz = 3
            extrax = -1
        end
    end
    
    Render.setCamera(camX, 0, 0, 0.0, 0.0, 0.0)
    
    if hideBoxes <= 0 then
        if apptype==1 then
            -- PSVita Boxes
            if setReflections == 1 then
                Render.useTexture(modCover, icon)
                Render.drawModel(modCover, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBox, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverNoref, icon)
                Render.drawModel(modCoverNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==2 then
            if setReflections == 1 then
                Render.useTexture(modCoverPSP, icon)
                Render.drawModel(modCoverPSP, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxPSP, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverPSPNoref, icon)
                Render.drawModel(modCoverPSPNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxPSPNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==3 then
            if setReflections == 1 then
                Render.useTexture(modCoverPSX, icon)
                Render.drawModel(modCoverPSX, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxPSX, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverPSXNoref, icon)
                Render.drawModel(modCoverPSXNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxPSXNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==5 or apptype==6 then
            if setReflections == 1 then
                Render.useTexture(modCoverN64, icon)
                Render.drawModel(modCoverN64, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverN64Noref, icon)
                Render.drawModel(modCoverN64Noref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==7 or apptype==12 or apptype==17 or apptype==18 or apptype==19 or apptype==20 or apptype==21 or apptype==23 or apptype==24 or apptype==34 or apptype==35 or apptype==36 or apptype==37 or apptype==38 then
            if setReflections == 1 then
                Render.useTexture(modCoverNES, icon)
                Render.drawModel(modCoverNES, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverNESNoref, icon)
                Render.drawModel(modCoverNESNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==8 or apptype==9 or apptype==10 or apptype==11 then
            if setReflections == 1 then
                Render.useTexture(modCoverGB, icon)
                Render.drawModel(modCoverGB, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverGBNoref, icon)
                Render.drawModel(modCoverGBNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==13 or apptype==14 or apptype==15 or apptype==16 then
            if setReflections == 1 then
                Render.useTexture(modCoverMD, icon)
                Render.drawModel(modCoverMD, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverMDNoref, icon)
                Render.drawModel(modCoverMDNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==22 or apptype==25 or apptype==26 or apptype==27 then
            if setReflections == 1 then
                Render.useTexture(modCoverTAPE, icon)
                Render.drawModel(modCoverTAPE, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverTAPENoref, icon)
                Render.drawModel(modCoverTAPENoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==28 or apptype==29 or apptype==30 or apptype==32 or apptype==33 then
            if setReflections == 1 then
                Render.useTexture(modCoverATARI, icon)
                Render.drawModel(modCoverATARI, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverATARINoref, icon)
                Render.drawModel(modCoverATARINoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==31 then
            if setReflections == 1 then
                Render.useTexture(modCoverLYNX, icon)
                Render.drawModel(modCoverLYNX, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverLYNXNoref, icon)
                Render.drawModel(modCoverLYNXNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        else
            -- Homebrew Icon
            if setReflections == 1 then
                Render.useTexture(modCoverHbr, icon)
                Render.drawModel(modCoverHbr, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverHbrNoref, icon)
                Render.drawModel(modCoverHbrNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        end
    else
        -- hideBoxes = hideBoxes - 0.1
    end
end

local FileLoad = {}

function FreeIcons()
    for k, v in pairs(files_table)              do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(games_table)              do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(psp_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(psx_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(n64_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(snes_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(nes_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(gba_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(gbc_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(gb_table)                 do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end 
    for k, v in pairs(dreamcast_table)          do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end 
    for k, v in pairs(sega_cd_table)            do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end 
    for k, v in pairs(s32x_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end 
    for k, v in pairs(md_table)                 do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(sms_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(gg_table)                 do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(tg16_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(tgcd_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(pce_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(pcecd_table)              do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(amiga_table)              do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(c64_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(wswan_col_table)          do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(wswan_table)              do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(msx2_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(msx1_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(zxs_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(atari_7800_table)         do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(atari_5200_table)         do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(atari_2600_table)         do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(atari_lynx_table)         do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(colecovision_table)       do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(vectrex_table)            do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(fba_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(mame_2003_plus_table)     do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(mame_2000_table)          do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(neogeo_table)             do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(ngpc_table)               do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(psm_table)                do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end

    for k, v in pairs(recently_played_table)    do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(homebrews_table)          do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
    for k, v in pairs(search_results_table)     do FileLoad[v] = nil Threads.remove(v) if v.ricon then Graphics.freeImage(v.ricon) v.ricon = nil end end
end

function DownloadSingleCover()
    cvrfound = 0
    app_idx = p
    running = false
    status = System.getMessageState()
    
    local coverspath = ""
    local onlineCoverspath = ""
    
    if Network.isWifiEnabled() then
        if apptype == 1 then
            coverspath = SystemsToScan[1].localCoverPath
            onlineCoverspath = SystemsToScan[1].onlineCoverPathSystem
        elseif apptype == 2 then
            coverspath = SystemsToScan[3].localCoverPath
            onlineCoverspath = SystemsToScan[3].onlineCoverPathSystem
        elseif apptype == 3 then
            coverspath = SystemsToScan[4].localCoverPath
            onlineCoverspath = SystemsToScan[4].onlineCoverPathSystem
        elseif apptype == 0 then
            coverspath = SystemsToScan[2].localCoverPath
            onlineCoverspath = SystemsToScan[2].onlineCoverPathSystem
        else
            coverspath = SystemsToScan[apptype].localCoverPath
            onlineCoverspath = SystemsToScan[apptype].onlineCoverPathSystem
        end

        app_titleid = app_titleid:gsub("\n","")

        Network.downloadFile(onlineCoverspath .. app_titleid:gsub("%%", '%%25'):gsub("%s+", '%%20') .. ".png", "ux0:/data/RetroFlow/" .. app_titleid .. ".png")
        
        if System.doesFileExist("ux0:/data/RetroFlow/" .. app_titleid .. ".png") then
            tmpfile = System.openFile("ux0:/data/RetroFlow/" .. app_titleid .. ".png", FREAD)
            size = System.sizeFile(tmpfile)
            if size < 1024 then
                System.deleteFile("ux0:/data/RetroFlow/" .. app_titleid .. ".png")
            else
                System.rename("ux0:/data/RetroFlow/" .. app_titleid .. ".png", coverspath .. app_titleid .. ".png")
                cvrfound = 1
            end
            System.closeFile(tmpfile)
            -- Delete image if not in covers folder
            if System.doesFileExist("ux0:/data/RetroFlow/" .. app_titleid .. ".png") then
                System.deleteFile("ux0:/data/RetroFlow/" .. app_titleid .. ".png")
            end
        end

        function update_cvrfound_showcats(def_table_name, def_user_db_file)
            local apptitle = (def_table_name)[app_idx].apptitle
            if System.doesFileExist(coverspath .. apptitle .. ".png") then
                (def_table_name)[app_idx].icon_path=coverspath .. apptitle .. ".png"
            else
                (def_table_name)[app_idx].icon_path=coverspath .. app_titleid .. ".png"
            end

            -- Instant cover update - Credit BlackSheepBoy69
            Threads.addTask((def_table_name)[app_idx], {
            Type = "ImageLoad",
            Path = (def_table_name)[app_idx].icon_path,
            Table = (def_table_name)[app_idx],
            Index = "ricon"
            })

            update_cached_table((def_user_db_file), (def_table_name))

            -- Update recently played cover if found
            if #recently_played_table ~= nil then
                key = find_game_table_pos_key(recently_played_table, app_titleid)
                if key ~= nil then
                    recently_played_table[key].icon_path=coverspath .. app_titleid .. ".png"
                    update_cached_table_recently_played()
                else
                end
            else
            end

        end


        function update_cvrfound_showcats_recent()
            local apptitle = recently_played_table[app_idx].apptitle
            if System.doesFileExist(coverspath .. apptitle .. ".png") then
                recently_played_table[app_idx].icon_path=coverspath .. apptitle .. ".png"
            else
                recently_played_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
            end

            -- Instant cover update - Credit BlackSheepBoy69
            Threads.addTask(recently_played_table[app_idx], {
            Type = "ImageLoad",
            Path = recently_played_table[app_idx].icon_path,
            Table = recently_played_table[app_idx],
            Index = "ricon"
            })

            update_cached_table_recently_played()

            -- Update game's category cover if found
            if #xAppNumTableLookup(apptype) ~= nil then
                key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                if key ~= nil then
                    xAppNumTableLookup(apptype)[key].icon_path=coverspath .. app_titleid .. ".png"
                    update_cached_table(xAppDbFileLookup(apptype), xAppNumTableLookup(apptype))
                else
                end
            else
            end

        end

        if cvrfound==1 then
            if showCat == 1 then update_cvrfound_showcats(games_table, "db_games.lua")
            elseif showCat == 2 then --"homebrews_table"
            elseif showCat == 3 then update_cvrfound_showcats(psp_table, "db_psp.lua")
            elseif showCat == 4 then update_cvrfound_showcats(psx_table, "db_psx.lua")
            elseif showCat == 5 then update_cvrfound_showcats(n64_table, "db_n64.lua")
            elseif showCat == 6 then update_cvrfound_showcats(snes_table, "db_snes.lua")
            elseif showCat == 7 then update_cvrfound_showcats(nes_table, "db_nes.lua")
            elseif showCat == 8 then update_cvrfound_showcats(gba_table, "db_gba.lua")
            elseif showCat == 9 then update_cvrfound_showcats(gbc_table, "db_gbc.lua")
            elseif showCat == 10 then update_cvrfound_showcats(gb_table, "db_gb.lua")
            elseif showCat == 11 then update_cvrfound_showcats(dreamcast_table, "db_dreamcast.lua")
            elseif showCat == 12 then update_cvrfound_showcats(sega_cd_table, "db_sega_cd.lua")
            elseif showCat == 13 then update_cvrfound_showcats(s32x_table, "db_32x.lua")
            elseif showCat == 14 then update_cvrfound_showcats(md_table, "db_md.lua")
            elseif showCat == 15 then update_cvrfound_showcats(sms_table, "db_sms.lua")
            elseif showCat == 16 then update_cvrfound_showcats(gg_table, "db_gg.lua")
            elseif showCat == 17 then update_cvrfound_showcats(tg16_table, "db_tg16.lua")
            elseif showCat == 18 then update_cvrfound_showcats(tgcd_table, "db_tgcd.lua")
            elseif showCat == 19 then update_cvrfound_showcats(pce_table, "db_pce.lua")
            elseif showCat == 20 then update_cvrfound_showcats(pcecd_table, "db_pcecd.lua")
            elseif showCat == 21 then update_cvrfound_showcats(amiga_table, "db_amiga.lua")
            elseif showCat == 22 then update_cvrfound_showcats(c64_table, "db_c64.lua")
            elseif showCat == 23 then update_cvrfound_showcats(wswan_col_table, "db_wswan_col.lua")
            elseif showCat == 24 then update_cvrfound_showcats(wswan_table, "db_wswan.lua")
            elseif showCat == 25 then update_cvrfound_showcats(msx2_table, "db_msx2.lua")
            elseif showCat == 26 then update_cvrfound_showcats(msx1_table, "db_msx1.lua")
            elseif showCat == 27 then update_cvrfound_showcats(zxs_table, "db_zxs.lua")
            elseif showCat == 28 then update_cvrfound_showcats(atari_7800_table, "db_atari_7800.lua")
            elseif showCat == 29 then update_cvrfound_showcats(atari_5200_table, "db_atari_5200.lua")
            elseif showCat == 30 then update_cvrfound_showcats(atari_2600_table, "db_atari_2600.lua")
            elseif showCat == 31 then update_cvrfound_showcats(atari_lynx_table, "db_atari_lynx.lua")
            elseif showCat == 32 then update_cvrfound_showcats(colecovision_table, "db_colecovision.lua")
            elseif showCat == 33 then update_cvrfound_showcats(vectrex_table, "db_vectrex.lua")
            elseif showCat == 34 then update_cvrfound_showcats(fba_table, "db_fba.lua")
            elseif showCat == 35 then update_cvrfound_showcats(mame_2003_plus_table, "db_mame_2003_plus.lua")
            elseif showCat == 36 then update_cvrfound_showcats(mame_2000_table, "db_mame_2000.lua")
            elseif showCat == 37 then update_cvrfound_showcats(neogeo_table, "db_neogeo.lua")
            elseif showCat == 38 then update_cvrfound_showcats(ngpc_table, "db_ngpc.lua")
            elseif showCat == 39 then update_cvrfound_showcats(psm_table, "db_psm.lua")
            elseif showCat == 40 then update_cvrfound_showcats(fav_count, "db_files.lua")
            elseif showCat == 41 then update_cvrfound_showcats_recent()
            elseif showCat == 42 then update_cvrfound_showcats(search_results_table, "db_files.lua")
            else update_cvrfound_showcats(files_table, "db_files.lua")
            end

            if status ~= RUNNING then
                -- System.setMessage(lang_lines.Cover .. " " .. app_titleid .. " " .. lang_lines.found_exclamation, false, BUTTON_OK)
            end
        else
            if status ~= RUNNING then
                System.setMessage(lang_lines.Cover_not_found, false, BUTTON_OK)
            end
        end
        
    else
        if status ~= RUNNING then
            System.setMessage(lang_lines.Internet_Connection_Required, false, BUTTON_OK)
        end
    end
    
    gettingCovers = false
end

function DownloadSingleSnap()
    bgfound = 0
    app_idx = p
    running = false
    status = System.getMessageState()
    
    local snapPath = ""
    local onlineSnapPath = ""
    
    if Network.isWifiEnabled() then
        if apptype == 1 then
            snapPath = SystemsToScan[1].localSnapPath
            onlineSnapPath = SystemsToScan[1].onlineSnapPathSystem
        elseif apptype == 2 then
            snapPath = SystemsToScan[3].localSnapPath
            onlineSnapPath = SystemsToScan[3].onlineSnapPathSystem
        elseif apptype == 3 then
            snapPath = SystemsToScan[4].localSnapPath
            onlineSnapPath = SystemsToScan[4].onlineSnapPathSystem
        elseif apptype == 0 then
            snapPath = SystemsToScan[2].localSnapPath
            onlineSnapPath = SystemsToScan[2].onlineSnapPathSystem
        else
            snapPath = SystemsToScan[apptype].localSnapPath
            onlineSnapPath = SystemsToScan[apptype].onlineSnapPathSystem
        end

        app_titleid = app_titleid:gsub("\n","")

        Network.downloadFile(onlineSnapPath .. app_titleid:gsub("%s+", '%%20') .. ".png", "ux0:/data/RetroFlow/" .. app_titleid .. ".png")
        
        if System.doesFileExist("ux0:/data/RetroFlow/" .. app_titleid .. ".png") then
            tmpfile = System.openFile("ux0:/data/RetroFlow/" .. app_titleid .. ".png", FREAD)
            size = System.sizeFile(tmpfile)
            System.closeFile(tmpfile)
            if size < 1024 then
                System.deleteFile("ux0:/data/RetroFlow/" .. app_titleid .. ".png")
            else
                System.rename("ux0:/data/RetroFlow/" .. app_titleid .. ".png", snapPath .. app_titleid .. ".png")
                bgfound = 1
            end
            -- Delete image if not in covers folder
            if System.doesFileExist("ux0:/data/RetroFlow/" .. app_titleid .. ".png") then
                System.deleteFile("ux0:/data/RetroFlow/" .. app_titleid .. ".png")
            end
        end

        if bgfound==1 then
            if showCat == 1 then pic_path = games_table[p].snap_path_local .. games_table[p].name .. ".png"
            elseif showCat == 2 then --"homebrews_table"
            elseif showCat == 3 then pic_path = psp_table[p].snap_path_local .. psp_table[p].name .. ".png"
            elseif showCat == 4 then pic_path = psx_table[p].snap_path_local .. psx_table[p].name .. ".png"
            elseif showCat == 5 then pic_path = n64_table[p].snap_path_local .. n64_table[p].name .. ".png"
            elseif showCat == 6 then pic_path = snes_table[p].snap_path_local .. snes_table[p].name .. ".png"
            elseif showCat == 7 then pic_path = nes_table[p].snap_path_local .. nes_table[p].name .. ".png"
            elseif showCat == 8 then pic_path = gba_table[p].snap_path_local .. gba_table[p].name .. ".png"
            elseif showCat == 9 then pic_path = gbc_table[p].snap_path_local .. gbc_table[p].name .. ".png"
            elseif showCat == 10 then pic_path = gb_table[p].snap_path_local .. gb_table[p].name .. ".png"
            elseif showCat == 11 then pic_path = dreamcast_table[p].snap_path_local .. dreamcast_table[p].name .. ".png"
            elseif showCat == 12 then pic_path = sega_cd_table[p].snap_path_local .. sega_cd_table[p].name .. ".png"
            elseif showCat == 13 then pic_path = s32x_table[p].snap_path_local .. s32x_table[p].name .. ".png"
            elseif showCat == 14 then pic_path = md_table[p].snap_path_local .. md_table[p].name .. ".png"
            elseif showCat == 15 then pic_path = sms_table[p].snap_path_local .. sms_table[p].name .. ".png"
            elseif showCat == 16 then pic_path = gg_table[p].snap_path_local .. gg_table[p].name .. ".png"
            elseif showCat == 17 then pic_path = tg16_table[p].snap_path_local .. tg16_table[p].name .. ".png"
            elseif showCat == 18 then pic_path = tgcd_table[p].snap_path_local .. tgcd_table[p].name .. ".png"
            elseif showCat == 19 then pic_path = pce_table[p].snap_path_local .. pce_table[p].name .. ".png"
            elseif showCat == 20 then pic_path = pcecd_table[p].snap_path_local .. pcecd_table[p].name .. ".png"
            elseif showCat == 21 then pic_path = amiga_table[p].snap_path_local .. amiga_table[p].name .. ".png"
            elseif showCat == 22 then pic_path = c64_table[p].snap_path_local .. c64_table[p].name .. ".png"
            elseif showCat == 23 then pic_path = wswan_col_table[p].snap_path_local .. wswan_col_table[p].name .. ".png"
            elseif showCat == 24 then pic_path = wswan_table[p].snap_path_local .. wswan_table[p].name .. ".png"
            elseif showCat == 25 then pic_path = msx2_table[p].snap_path_local .. msx2_table[p].name .. ".png"
            elseif showCat == 26 then pic_path = msx1_table[p].snap_path_local .. msx1_table[p].name .. ".png"
            elseif showCat == 27 then pic_path = zxs_table[p].snap_path_local .. zxs_table[p].name .. ".png"
            elseif showCat == 28 then pic_path = atari_7800_table[p].snap_path_local .. atari_7800_table[p].name .. ".png"
            elseif showCat == 29 then pic_path = atari_5200_table[p].snap_path_local .. atari_5200_table[p].name .. ".png"
            elseif showCat == 30 then pic_path = atari_2600_table[p].snap_path_local .. atari_2600_table[p].name .. ".png"
            elseif showCat == 31 then pic_path = atari_lynx_table[p].snap_path_local .. atari_lynx_table[p].name .. ".png"
            elseif showCat == 32 then pic_path = colecovision_table[p].snap_path_local .. colecovision_table[p].name .. ".png"
            elseif showCat == 33 then pic_path = vectrex_table[p].snap_path_local .. vectrex_table[p].name .. ".png"
            elseif showCat == 34 then pic_path = fba_table[p].snap_path_local .. fba_table[p].name .. ".png"
            elseif showCat == 35 then pic_path = mame_2003_plus_table[p].snap_path_local .. mame_2003_plus_table[p].name .. ".png"
            elseif showCat == 36 then pic_path = mame_2000_table[p].snap_path_local .. mame_2000_table[p].name .. ".png"
            elseif showCat == 37 then pic_path = neogeo_table[p].snap_path_local .. neogeo_table[p].name .. ".png"
            elseif showCat == 38 then pic_path = ngpc_table[p].snap_path_local .. ngpc_table[p].name .. ".png"
            elseif showCat == 39 then pic_path = psm_table[p].snap_path_local .. psm_table[p].name .. ".png"
            elseif showCat == 40 then pic_path = fav_count[p].snap_path_local .. fav_count[p].name .. ".png"
            elseif showCat == 41 then pic_path = recently_played_table[p].snap_path_local .. recently_played_table[p].name .. ".png"
            elseif showCat == 42 then pic_path = search_results_table[p].snap_path_local .. search_results_table[p].name .. ".png"
            else pic_path = files_table[p].snap_path_local .. files_table[p].name .. ".png"
            end

            if System.doesFileExist(pic_path) and Game_Backgrounds >= 1 then
                Graphics.freeImage(backTmp)
                backTmp = Graphics.loadImage(pic_path)
                Graphics.setImageFilters(backTmp, FILTER_LINEAR, FILTER_LINEAR)
                Render.useTexture(modBackground, backTmp)
            else
                Render.useTexture(modBackground, imgCustomBack)
            end

            -- Update recently played background if found
            if #recently_played_table ~= nil then
                key = find_game_table_pos_key(recently_played_table, app_titleid)
                if key ~= nil then
                    recently_played_table[key].snap_path_local=snapPath
                    update_cached_table_recently_played()
                else
                end
            else
            end
            

            if status ~= RUNNING then
                -- System.setMessage(lang_lines.Background .. " " .. app_titleid .. " " .. lang_lines.found_exclamation, false, BUTTON_OK)
            end
        else
            if status ~= RUNNING then
                System.setMessage(lang_lines.Background_not_found, false, BUTTON_OK)
            end
        end
        
    else
        if status ~= RUNNING then
            System.setMessage(lang_lines.Internet_Connection_Required, false, BUTTON_OK)
        end
    end
    
    gettingBackgrounds = false
end

function drawCategory (def)
    for l, file in pairs((def)) do

        if (def)[p+7] and (def)[p+7].ricon then -- Credit BlackSheepBoy69
            render_distance = 16
        else
            render_distance = 8
        end

        if (l >= master_index) then
            base_x = base_x + space
        end

        if l > p-render_distance and l < p+render_distance+2 then -- Credit BlackSheepBoy69 - Experimental fix.
            if FileLoad[file] == nil then --add a new check here
                FileLoad[file] = true
                Threads.addTask(file, {
                    Type = "ImageLoad",
                    Path = file.icon_path,
                    Table = file,
                    Index = "ricon"
                })
            end
            if file.ricon ~= nil then
                --draw visible covers only
                DrawCover(
                    (targetX + l * space) - (#(def) * space + space), 
                    -0.6, 
                    file.name, 
                    file.ricon, 
                    l==p, -- Credit BlackSheepBoy69 - Uses l==p (which returns as true or false) to say where selector goes.
                    file.app_type
                )

                -- Show fav icon if game if a favourite
                favourite_flag = (def)[p].favourite
                if (def)[p].favourite == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                end

                -- Show hidden icon if game is hidden
                hide_game_flag = (def)[p].hidden
                if (def)[p].hidden == true then
                    favourite_flag = (def)[p].favourite
                    if (def)[p].favourite == true then
                        Graphics.drawImage(685 - 42, 36, imgHidden_small_on)
                    else
                        Graphics.drawImage(685, 36, imgHidden_small_on)
                    end
                else
                end

            else
                --draw visible covers only
                DrawCover(
                    (targetX + l * space) - (#(def) * space + space),
                    -0.6,
                    file.name,
                    file.icon,
                    l==p, -- Credit BlackSheepBoy69 - Uses l==p (which returns as true or false) to say where selector goes.
                    file.app_type
                )

                -- Show fav icon if game if a favourite
                favourite_flag = (def)[p].favourite
                if (def)[p].favourite == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                end

                -- Show hidden icon if game is hidden
                hide_game_flag = (def)[p].hidden
                if (def)[p].hidden == true then
                    favourite_flag = (def)[p].favourite
                    if (def)[p].favourite == true then
                        Graphics.drawImage(685 - 42, 36, imgHidden_small_on)
                    else
                        Graphics.drawImage(685, 36, imgHidden_small_on)
                    end
                else
                end
        
            end
        else
            if FileLoad[file] == true then
                FileLoad[file] = nil
                Threads.remove(file)
            end
            if file.ricon then
                Graphics.freeImage(file.ricon)
                file.ricon = nil
            end
        end
        end
        if showView ~= 2 then
        PrintCentered(fnt20, 480, 462, p .. lang_lines.of .. #(def), white, 20)-- Draw total items
        end
end

functionTime = Timer.getTime(oneLoopTimer)

-- Main loop
while true do
    
    -- Threads update
    Threads.update()
    
    -- Reading input
    pad = Controls.read()
    
    mx, my = Controls.readLeftAnalog()
    
    -- touch input
    x1, y1 = Controls.readTouch()
    
    -- Initializing rendering
    Graphics.initBlend()
    Screen.clear(black)
    
    if delayButton > 0 then
        delayButton = delayButton - 0.1
    else
        delayButton = 0
    end

    if hideBoxes > 0 then
        hideBoxes = hideBoxes - 0.1
    else
        hideBoxes = 0
    end
    
    -- Music
    if setMusic == 1 then

        -- More than 1 track - move to next if the song is over
        if #music_sequential > 1 then
            
            -- Is it playing?

            if Sound.isPlaying(sndMusic) then
                -- Yes - do nothing
            else
                -- No - go to the next track
                track = track + 1 
                PlayMusic()
            end

        -- Only 1 track - do nothing
        else   
        end
    end

    -- search start - Checking for keyboard state
    state = Keyboard.getState()

    if rename_keyboard == false then

        if state ~= RUNNING and hasTyped == true then
                
            hasTyped = false

            -- Typed text
            ret_search = "" .. Keyboard.getInput()

            -- Bug fix, for when enter pressed without text, do nothing
            if string.len(ret_search) == 0 then
                state = CANCELED
                -- Terminating keyboard
                Keyboard.clear()
            end

            if state == CANCELED then
            else

                search_results_table = {}
                -- If already on search category, move away
                if showCat == 42 then 
                    showCat = 0
                end

                -- Typed text
                -- Converted to upper, lower case and proper case for broader results
                ret_search_lc = string.lower(ret_search)
                ret_search_uc = string.upper(ret_search)
                ret_search_pc = string.gsub(" "..ret_search, "%W%l", string.upper):sub(2)

                for l, file in pairs(files_table) do
                    if string.match(file.apptitle, escape_pattern(ret_search)) or string.match(file.apptitle, escape_pattern(ret_search_lc)) or string.match(file.apptitle, escape_pattern(ret_search_uc)) or string.match(file.apptitle, escape_pattern(ret_search_pc)) then
                        table.insert(search_results_table, file)
                        table.sort(search_results_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
                        local app_title = search_results_table[1].app_title
                    else
                        local app_title = lang_lines.Search_No_Results -- Workaround - hides last name shown before searching
                    end
                end

                showCat = 42
                p = 1
                master_index = p
                showMenu = 0
                GetNameAndAppTypeSelected()
            end

            -- Terminating keyboard
            Keyboard.clear()
        else
        end
    else
    end

    if rename_keyboard == true then
        
        if state ~= RUNNING and hasTyped == true then
            hasTyped = false

            -- Typed text
            ret_rename = "" .. Keyboard.getInput()

            -- Bug fix, for when enter pressed without text, do nothing
            if string.len(ret_rename) == 0 then
                state = CANCELED
                -- Terminating keyboard
                Keyboard.clear()
            end

            if state == CANCELED and rename_keyboard == true then
            else

                -- Update current table
                xCatLookup(showCat)[p].apptitle = ret_rename
                xCatLookup(showCat)[p].title = ret_rename    
                txtname = ret_rename

                -- START updating other tables -- 

                -- Recent
                if #recently_played_table ~= nil then
                    local key = find_game_table_pos_key(recently_played_table, app_titleid)
                    if key ~= nil then
                        -- Yes - Found in files table
                        recently_played_table[key].title = ret_rename
                        recently_played_table[key].apptitle = ret_rename


                        -- Look for custom cover name - Recent table

                            -- Custom name
                            if System.doesFileExist(recently_played_table[key].cover_path_local .. recently_played_table[key].apptitle .. ".png") then
                                recently_played_table[key].icon_path = (recently_played_table[key].cover_path_local .. recently_played_table[key].apptitle .. ".png")
                            
                            -- App name
                            elseif System.doesFileExist(recently_played_table[key].cover_path_local .. recently_played_table[key].name .. ".png") then
                                recently_played_table[key].icon_path = recently_played_table[key].cover_path_local .. recently_played_table[key].name .. ".png"
                            
                            -- Vita ur0 png
                            elseif System.doesFileExist("ur0:/appmeta/" .. recently_played_table[key].name .. "/icon0.png") then
                                recently_played_table[key].icon_path = "ur0:/appmeta/" .. recently_played_table[key].name .. "/icon0.png"

                            -- Missing cover png -- find me
                            elseif System.doesFileExist("app0:/DATA/" .. xAppNumTableLookup_Missing_Cover(recently_played_table[key].app_type) .. ".png") then
                                recently_played_table[key].icon_path = "app0:/DATA/" .. xAppNumTableLookup_Missing_Cover(recently_played_table[key].app_type) .. ".png"

                            -- Fallback - blank grey
                            else
                                recently_played_table[key].icon_path = "app0:/DATA/noimg.png" --blank grey
                            end


                        -- Look for custom cover name - Game table by app type

                            local key2 = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                            if key2 ~= nil then

                                -- Custom name
                                if System.doesFileExist(xAppNumTableLookup(apptype)[key2].cover_path_local .. recently_played_table[key].apptitle .. ".png") then
                                    xAppNumTableLookup(apptype)[key2].icon_path = xAppNumTableLookup(apptype)[key2].cover_path_local .. recently_played_table[key].apptitle .. ".png"
                                
                                -- App name
                                elseif System.doesFileExist(xAppNumTableLookup(apptype)[key2].cover_path_local .. recently_played_table[key].name .. ".png") then
                                    xAppNumTableLookup(apptype)[key2].icon_path = xAppNumTableLookup(apptype)[key2].cover_path_local .. recently_played_table[key].name .. ".png"
                                
                                -- Vita ur0 png
                                elseif System.doesFileExist("ur0:/appmeta/" .. recently_played_table[key].name .. "/icon0.png") then
                                    xAppNumTableLookup(apptype)[key2].icon_path = "ur0:/appmeta/" .. recently_played_table[key].name .. "/icon0.png"

                                -- Missing cover png -- find me
                                elseif System.doesFileExist("app0:/DATA/" .. xAppNumTableLookup_Missing_Cover(recently_played_table[key].app_type) .. ".png") then
                                    xAppNumTableLookup(apptype)[key2].icon_path = "app0:/DATA/" .. xAppNumTableLookup_Missing_Cover(recently_played_table[key].app_type) .. ".png"

                                -- Fallback - blank grey
                                else
                                    xAppNumTableLookup(apptype)[key2].icon_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            else
                            end

                        update_cached_table_recently_played()
                    else
                      -- No
                    end
                else
                end

                -- Favourites
                if #fav_count ~= nil then
                    local key = find_game_table_pos_key(fav_count, app_titleid)
                    if key ~= nil then
                        -- Yes - Found in files table
                        fav_count[key].title = ret_rename
                        fav_count[key].apptitle = ret_rename
                    else
                        -- No
                    end
                else
                end
                

                -- Look for custom cover name

                    -- Custom name
                    if System.doesFileExist(xCatLookup(showCat)[p].cover_path_local .. xCatLookup(showCat)[p].apptitle .. ".png") then
                        xCatLookup(showCat)[p].icon_path = xCatLookup(showCat)[p].cover_path_local .. xCatLookup(showCat)[p].apptitle .. ".png"
                    
                    -- App name
                    elseif System.doesFileExist(xCatLookup(showCat)[p].cover_path_local .. xCatLookup(showCat)[p].name .. ".png") then
                        xCatLookup(showCat)[p].icon_path = xCatLookup(showCat)[p].cover_path_local .. xCatLookup(showCat)[p].name .. ".png"
                    
                    -- Vita ur0 png
                    elseif System.doesFileExist("ur0:/appmeta/" .. xCatLookup(showCat)[p].name .. "/icon0.png") then
                        xCatLookup(showCat)[p].icon_path = "ur0:/appmeta/" .. xCatLookup(showCat)[p].name .. "/icon0.png"

                    -- Missing cover png -- find me
                    elseif System.doesFileExist("app0:/DATA/" .. xAppNumTableLookup_Missing_Cover(xAppNumTableLookup(showCat)[p].app_type) .. ".png") then
                        xCatLookup(showCat)[p].icon_path = "app0:/DATA/" .. xAppNumTableLookup_Missing_Cover(xAppNumTableLookup(showCat)[p].app_type) .. ".png"

                    -- Fallback - blank grey
                    else
                        xCatLookup(showCat)[p].icon_path = "app0:/DATA/noimg.png" --blank grey
                    end


                -- Renamed
                -- Has the game been renamed before?
                if #renamed_games_table ~= nil then
                    local key = find_game_table_pos_key(renamed_games_table, app_titleid)
                    if key ~= nil then
                        -- Yes - it's already in the rename list, update it.
                        renamed_games_table[key].title = ret_rename
                    else
                        -- No, it's new, add it to the rename list
                        renamed_game_temp = {}
                        table.insert(renamed_game_temp, {name = app_titleid, title = ret_rename})

                        for i, file in pairs(renamed_game_temp) do
                            table.insert(renamed_games_table, file)
                        end
                    end
                    -- Save the renamed table for importing on restart
                    update_cached_table_renamed_games()
                else
                end


                -- Apptype table
                update_cached_table(xAppDbFileLookup(apptype), xAppNumTableLookup(apptype))

                -- All other tables - re-import cache and rename if match rename table
                files_table = import_cached_DB()

                -- Get favourites list - so can stay on favourites category if renaming from there
                create_fav_count_table(return_table)

                -- END updating other tables -- 

                -- Get ready for reload - Game position may change due to alphabetical sorting, find its new position
                if #xCatLookup(showCat) ~= nil then
                    local key = find_game_table_pos_key(xCatLookup(showCat), app_titleid)
                    if key ~= nil then
                        p = key
                        master_index = p
                        -- showMenu = 0
                        
                        -- Instantly move to selection
                        if startCovers == false then
                            targetX = base_x
                            startCovers = true
                            GetInfoSelected()
                        end

                    else
                        showCat = 1
                        p = 1
                        master_index = p
                        -- showMenu = 0
                    end
                else
                end

                GetNameAndAppTypeSelected()
                -- Render.useTexture(modBackground, imgCustomBack)

                GetInfoSelected()

                

                -- Instant cover update - Credit BlackSheepBoy69
                Threads.addTask(xCatLookup(showCat)[p], {
                Type = "ImageLoad",
                Path = xCatLookup(showCat)[p].icon_path,
                Table = xCatLookup(showCat)[p],
                Index = "ricon"
                })

            end

            rename_keyboard = false
            -- Terminating keyboard
            Keyboard.clear()
        else
        end

    else
    end
    -- search end


    -- Graphics
    if setBackground >= 1 then
        Render.drawModel(modBackground, 0, 0, -5, 0, 0, 0)-- Draw Background as model
    else
        Render.drawModel(modDefaultBackground, 0, 0, -5, 0, 0, 0)-- Draw Background as model
    end
    
    Graphics.fillRect(0, 960, 496, 544, themeCol)-- footer bottom


-- MENU 0 - GAMES SCREEN
    if showMenu == 0 then
        -- MAIN VIEW
        -- Header
        h, m, s = System.getTime()
        Font.print(fnt20, 726, 34, string.format("%02d:%02d", h, m), white)-- Draw time
        life = System.getBatteryPercentage()
        Font.print(fnt20, 830, 34, life .. "%", white)-- Draw battery
        Graphics.drawImage(888, 39, imgBattery)
        Graphics.fillRect(891, 891 + (life / 5.2), 43, 51, white)

        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Launch)
        label2 = Font.getTextWidth(fnt20, lang_lines.Details)
        label3 = Font.getTextWidth(fnt20, lang_lines.Category)
        label4 = Font.getTextWidth(fnt20, lang_lines.View)
        
        if showCat == 1 then Font.print(fnt22, 32, 34, lang_lines.PS_Vita, white)
        elseif showCat == 2 then Font.print(fnt22, 32, 34, lang_lines.Homebrews, white)
        elseif showCat == 3 then Font.print(fnt22, 32, 34, lang_lines.PSP, white)
        elseif showCat == 4 then Font.print(fnt22, 32, 34, lang_lines.PlayStation, white)
        elseif showCat == 5 then Font.print(fnt22, 32, 34, lang_lines.Nintendo_64, white)
        elseif showCat == 6 then Font.print(fnt22, 32, 34, lang_lines.Super_Nintendo, white)
        elseif showCat == 7 then Font.print(fnt22, 32, 34, lang_lines.Nintendo_Entertainment_System, white)
        elseif showCat == 8 then Font.print(fnt22, 32, 34, lang_lines.Game_Boy_Advance, white)
        elseif showCat == 9 then Font.print(fnt22, 32, 34, lang_lines.Game_Boy_Color, white)
        elseif showCat == 10 then Font.print(fnt22, 32, 34, lang_lines.Game_Boy, white)
        elseif showCat == 11 then Font.print(fnt22, 32, 34, lang_lines.Sega_Dreamcast, white)
        elseif showCat == 12 then Font.print(fnt22, 32, 34, lang_lines.Sega_CD, white)
        elseif showCat == 13 then Font.print(fnt22, 32, 34, lang_lines.Sega_32X, white)
        elseif showCat == 14 then Font.print(fnt22, 32, 34, lang_lines.Sega_Mega_Drive, white)
        elseif showCat == 15 then Font.print(fnt22, 32, 34, lang_lines.Sega_Master_System, white)
        elseif showCat == 16 then Font.print(fnt22, 32, 34, lang_lines.Sega_Game_Gear, white)        
        elseif showCat == 17 then Font.print(fnt22, 32, 34, lang_lines.TurboGrafx_16, white)
        elseif showCat == 18 then Font.print(fnt22, 32, 34, lang_lines.TurboGrafx_CD, white)
        elseif showCat == 19 then Font.print(fnt22, 32, 34, lang_lines.PC_Engine, white)
        elseif showCat == 20 then Font.print(fnt22, 32, 34, lang_lines.PC_Engine_CD, white)
        elseif showCat == 21 then Font.print(fnt22, 32, 34, lang_lines.Amiga, white)
        elseif showCat == 22 then Font.print(fnt22, 32, 34, lang_lines.Commodore_64, white)
        elseif showCat == 23 then Font.print(fnt22, 32, 34, lang_lines.WonderSwan_Color, white)
        elseif showCat == 24 then Font.print(fnt22, 32, 34, lang_lines.WonderSwan, white)
        elseif showCat == 25 then Font.print(fnt22, 32, 34, lang_lines.MSX2, white)
        elseif showCat == 26 then Font.print(fnt22, 32, 34, lang_lines.MSX, white)
        elseif showCat == 27 then Font.print(fnt22, 32, 34, lang_lines.ZX_Spectrum, white)
        elseif showCat == 28 then Font.print(fnt22, 32, 34, lang_lines.Atari_7800, white)
        elseif showCat == 29 then Font.print(fnt22, 32, 34, lang_lines.Atari_5200, white)
        elseif showCat == 30 then Font.print(fnt22, 32, 34, lang_lines.Atari_2600, white)
        elseif showCat == 31 then Font.print(fnt22, 32, 34, lang_lines.Atari_Lynx, white)
        elseif showCat == 32 then Font.print(fnt22, 32, 34, lang_lines.ColecoVision, white)
        elseif showCat == 33 then Font.print(fnt22, 32, 34, lang_lines.Vectrex, white)
        elseif showCat == 34 then Font.print(fnt22, 32, 34, lang_lines.FBA_2012, white)
        elseif showCat == 35 then Font.print(fnt22, 32, 34, lang_lines.MAME_2003Plus, white)
        elseif showCat == 36 then Font.print(fnt22, 32, 34, lang_lines.MAME_2000, white)
        elseif showCat == 37 then Font.print(fnt22, 32, 34, lang_lines.Neo_Geo, white)
        elseif showCat == 38 then Font.print(fnt22, 32, 34, lang_lines.Neo_Geo_Pocket_Color, white)
        elseif showCat == 39 then Font.print(fnt22, 32, 34, lang_lines.Playstation_Mobile, white)
        elseif showCat == 40 then Font.print(fnt22, 32, 34, lang_lines.Favorites, white)
        elseif showCat == 41 then Font.print(fnt22, 32, 34, lang_lines.Recently_Played, white)
        elseif showCat == 42 then Font.print(fnt22, 32, 34, lang_lines.Search_Results, white)
        else Font.print(fnt22, 32, 34, lang_lines.All, white)
        end
        if Network.isWifiEnabled() then
            Graphics.drawImage(800, 35, imgWifi)-- wifi icon
        end

    
        if showView ~= 2 then
            Graphics.fillRect(0, 960, 424, 496, black)-- black footer bottom
            PrintCentered(fnt25, 480, 430, app_title, white, 25)-- Draw title
        else
            Graphics.fillRect(0, 960, 496, 544, themeCol)-- footer bottom
            
            -- Add gradient to mask out long names so they don't crash into the footer controls 
            Font.print(fnt22, 24, 506, app_title, white)
            Graphics.drawImage(900-(btnMargin * 8)-label1-label2-label3-label4, 496, footer_gradient, themeCol)
            Graphics.fillRect(900-(btnMargin * 8)-label1-label2-label3-label4+48, 960, 496, 544, themeCol)
        end

        

        Graphics.drawImage(900-label1, 510, btnX)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Launch, white)--Launch

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Details, white)--Details

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnS)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines.Category, white)--Category

        Graphics.drawImage(900-(btnMargin * 6)-label1-label2-label3-label4, 510, btnO)
        Font.print(fnt20, 900+28-(btnMargin * 6)-label1-label2-label3-label4, 508, lang_lines.View, white)--View
        
        -- Draw Covers
        base_x = 0
        
        if showCat == 1 then drawCategory (games_table)
        elseif showCat == 2 then drawCategory (homebrews_table)
        elseif showCat == 3 then drawCategory (psp_table)
        elseif showCat == 4 then drawCategory (psx_table)
        elseif showCat == 5 then drawCategory (n64_table)
        elseif showCat == 6 then drawCategory (snes_table)
        elseif showCat == 7 then drawCategory (nes_table)
        elseif showCat == 8 then drawCategory (gba_table)
        elseif showCat == 9 then drawCategory (gbc_table)
        elseif showCat == 10 then drawCategory (gb_table)
        elseif showCat == 11 then drawCategory (dreamcast_table)
        elseif showCat == 12 then drawCategory (sega_cd_table)
        elseif showCat == 13 then drawCategory (s32x_table)
        elseif showCat == 14 then drawCategory (md_table)
        elseif showCat == 15 then drawCategory (sms_table)
        elseif showCat == 16 then drawCategory (gg_table)
        elseif showCat == 17 then drawCategory (tg16_table)
        elseif showCat == 18 then drawCategory (tgcd_table)
        elseif showCat == 19 then drawCategory (pce_table)
        elseif showCat == 20 then drawCategory (pcecd_table)
        elseif showCat == 21 then drawCategory (amiga_table)
        elseif showCat == 22 then drawCategory (c64_table)
        elseif showCat == 23 then drawCategory (wswan_col_table)
        elseif showCat == 24 then drawCategory (wswan_table)
        elseif showCat == 25 then drawCategory (msx2_table) 
        elseif showCat == 26 then drawCategory (msx1_table) 
        elseif showCat == 27 then drawCategory (zxs_table)
        elseif showCat == 28 then drawCategory (atari_7800_table)
        elseif showCat == 29 then drawCategory (atari_5200_table)
        elseif showCat == 30 then drawCategory (atari_2600_table)
        elseif showCat == 31 then drawCategory (atari_lynx_table)
        elseif showCat == 32 then drawCategory (colecovision_table)
        elseif showCat == 33 then drawCategory (vectrex_table)
        elseif showCat == 34 then drawCategory (fba_table)
        elseif showCat == 35 then drawCategory (mame_2003_plus_table)
        elseif showCat == 36 then drawCategory (mame_2000_table)
        elseif showCat == 37 then drawCategory (neogeo_table)
        elseif showCat == 38 then drawCategory (ngpc_table)
        elseif showCat == 39 then drawCategory (psm_table)
        elseif showCat == 40 then
            -- count favorites
            create_fav_count_table(files_table)
            
            drawCategory (fav_count)
            GetNameAndAppTypeSelected() -- Added to refresh names as games removed from fav cat whilst on fav cat
        elseif showCat == 41 then drawCategory (recently_played_table)
        elseif showCat == 42 then drawCategory (search_results_table)
        else drawCategory (files_table)
        end

        -- Smooth move items horizontally
        if targetX ~= base_x then
            targetX = targetX - ((targetX - base_x) * 0.1)
        end
        
        -- Instantly move to selection
        if startCovers == false then
            targetX = base_x
            startCovers = true
            GetNameAndAppTypeSelected()
        end
        
        if setReflections==1 then
            floorY = 0
            if showView == 2 then
                floorY = -0.6
            elseif showView == 3 then
                floorY = -0.3
            end
            --Draw half transparent floor for reflection effect
            Render.drawModel(modFloor, 0, -0.6+floorY, 0, 0, 0, 0)
        end
        
        prevX = 0
        prevZ = 0
        prevRot = 0
        inPreview = false

-- MENU 1 - GET INFO
    elseif showMenu == 1 then
        
        -- PREVIEW
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select
        label3 = Font.getTextWidth(fnt20, lang_lines.Options)--Options
        -- label4 = Font.getTextWidth(fnt20, lang_lines.Favorite)--Favourite

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines.Options, white)--Options
        
        if wide_getinfoscreen == true then
            Graphics.fillRect(24, 470+24, 24, 470, darkalpha)
        else
            Graphics.fillRect(24, 470, 24, 470, darkalpha)
        end

        Render.setCamera(0, 0, 0, 0.0, 0.0, 0.0)
        if inPreview == false then
            if not pcall(loadImage, icon_path) then
                iconTmp = imgCoverTmp
            else
                iconTmp = Graphics.loadImage(icon_path)
            end
            -- set pic0 as background
            if System.doesFileExist(pic_path) and Game_Backgrounds >= 1 then
                Graphics.freeImage(backTmp)
                backTmp = Graphics.loadImage(pic_path)
                Graphics.setImageFilters(backTmp, FILTER_LINEAR, FILTER_LINEAR)
                Render.useTexture(modBackground, backTmp)
            else
                Render.useTexture(modBackground, imgCustomBack)
            end
            
            if folder == true then
                if System.doesDirExist(appdir) then
                    app_size = getAppSize(appdir)/1024/1024
                    game_size = string.format("%02d", app_size) .. "Mb"
                else
                    game_size = "0Kb"
                end
            else
                if string.find(filename, "%.cue") or string.find(filename, "%.gdi") then
                    -- Get game directory by trimming filename from gamepath
                    filename_len = string.len (filename)
                    game_path_len = string.len (appdir)
                    directory_len = game_path_len - filename_len -1
                    game_directory_path = string.sub(appdir, 1, directory_len)

                    if System.doesDirExist(game_directory_path) then
                        app_size = getAppSize(game_directory_path)/1024/1024
                        game_size = string.format("%02d", app_size) .. "Mb"
                    else
                        game_size = "0Kb"
                    end

                else
                    getRomSize()
                end

            end
            
            menuY=0
            tmpappcat=0
            tmpimagecat=0
            inPreview = true
        end
        
        -- animate cover zoom in
        if prevX < 1.4 then
            prevX = prevX + 0.1
        end
        if prevZ < 1 then
            prevZ = prevZ + 0.06
        end
        if prevRot > -0.6 then
            prevRot = prevRot - 0.04
        end
        
        
        -- Rescale icon images to 128px x 128px

        -- Get sizes
        original_w = Graphics.getImageWidth(iconTmp)
        original_h = Graphics.getImageHeight(iconTmp)

        -- Calculate ratio size to use
        if original_w == 128 then ratio_w = 1.0 else ratio_w = 128 / original_w end
        if original_h == 128 then ratio_h = 1.0 else ratio_h = 128 / original_h end

        -- Draw resized image  
        Graphics.drawScaleImage(50, 50, iconTmp, ratio_w, ratio_h)

        -- txtname = string.sub(app_title, 1, 32) .. "\n" .. string.sub(app_title, 33)
        txtname = wraptextlength(app_title, 32)
        
        
        
        function set_cover_image (def_table_name)
            --Graphics.setImageFilters(games_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if (def_table_name)[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, (def_table_name)[p].ricon) -- games_table
                Render.useTexture(modCoverHbrNoref, (def_table_name)[p].ricon) -- homebrews_table
                Render.useTexture(modCoverPSPNoref, (def_table_name)[p].ricon) -- psp_table
                Render.useTexture(modCoverPSXNoref, (def_table_name)[p].ricon) -- psx_table
                Render.useTexture(modCoverN64Noref, (def_table_name)[p].ricon) -- n64_table
                Render.useTexture(modCoverN64Noref, (def_table_name)[p].ricon) -- snes_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].ricon) -- nes_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].ricon) -- gba_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].ricon) -- gbc_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].ricon) -- gb_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].ricon) -- dreamcast_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].ricon) -- sega_cd_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- 32x_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- md_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- sms_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- gg_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- tg16_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- tgcd_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- pce_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- pcecd_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- amiga_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].ricon) -- c64_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].ricon) -- wswan_col_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].ricon) -- wswan_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].ricon) -- msx2_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].ricon) -- msx1_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].ricon) -- zxs_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].ricon) -- atari_7800_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].ricon) -- atari_5200_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].ricon) -- atari_2600_table
                Render.useTexture(modCoverLYNXNoref, (def_table_name)[p].ricon) -- atari_lynx_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].ricon) -- colecovision_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].ricon) -- vectrex_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- fba_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- mame_2003_plus_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- mame_2000_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- neogeo_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- ngpc_table
                Render.useTexture(modCoverHbrNoref, (def_table_name)[p].ricon) -- psm_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- fav_count
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- recently played
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].ricon) -- search

            else 
                Render.useTexture(modCoverNoref, (def_table_name)[p].icon) -- games_table
                Render.useTexture(modCoverHbrNoref, (def_table_name)[p].icon) -- homebrews_table
                Render.useTexture(modCoverPSPNoref, (def_table_name)[p].icon) -- psp_table
                Render.useTexture(modCoverPSXNoref, (def_table_name)[p].icon) -- psx_table
                Render.useTexture(modCoverN64Noref, (def_table_name)[p].icon) -- n64_table
                Render.useTexture(modCoverN64Noref, (def_table_name)[p].icon) -- snes_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].icon) -- nes_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].icon) -- gba_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].icon) -- gbc_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].icon) -- gb_table
                Render.useTexture(modCoverGBNoref, (def_table_name)[p].icon) -- dreamcast_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].icon) -- sega_cd_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- 32x_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- md_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- sms_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- gg_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- tg16_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- tgcd_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- pce_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- pcecd_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- amiga_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].icon) -- c64_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].icon) -- wswan_col_table
                Render.useTexture(modCoverNESNoref, (def_table_name)[p].icon) -- wswan_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].icon) -- msx2_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].icon) -- msx1_table
                Render.useTexture(modCoverTAPENoref, (def_table_name)[p].icon) -- zxs_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].icon) -- atari_7800_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].icon) -- atari_5200_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].icon) -- atari_2600_table
                Render.useTexture(modCoverLYNXNoref, (def_table_name)[p].icon) -- atari_lynx_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].icon) -- colecovision_table
                Render.useTexture(modCoverATARINoref, (def_table_name)[p].icon) -- vectrex_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- fba_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- mame_2003_plus_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- mame_2000_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- neogeo_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- ngpc_table
                Render.useTexture(modCoverHbrNoref, (def_table_name)[p].icon) -- psm_table
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- fav_count
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- recently played
                Render.useTexture(modCoverMDNoref, (def_table_name)[p].icon) -- search

            end
        end
        
        -- Set cover image
        if showCat == 1 then set_cover_image (games_table)
        elseif showCat == 2 then set_cover_image (homebrews_table)
        elseif showCat == 3 then set_cover_image (psp_table)
        elseif showCat == 4 then set_cover_image (psx_table)
        elseif showCat == 5 then set_cover_image (n64_table)
        elseif showCat == 6 then set_cover_image (snes_table)
        elseif showCat == 7 then set_cover_image (nes_table)
        elseif showCat == 8 then set_cover_image (gba_table)
        elseif showCat == 9 then set_cover_image (gbc_table)                
        elseif showCat == 10 then set_cover_image (gb_table)
        elseif showCat == 11 then set_cover_image (dreamcast_table)
        elseif showCat == 12 then set_cover_image (sega_cd_table)
        elseif showCat == 13 then set_cover_image (s32x_table)
        elseif showCat == 14 then set_cover_image (md_table)
        elseif showCat == 15 then set_cover_image (sms_table)
        elseif showCat == 16 then set_cover_image (gg_table)
        elseif showCat == 17 then set_cover_image (tg16_table)
        elseif showCat == 18 then set_cover_image (tgcd_table)
        elseif showCat == 19 then set_cover_image (pce_table)
        elseif showCat == 20 then set_cover_image (pcecd_table)
        elseif showCat == 21 then set_cover_image (amiga_table)
        elseif showCat == 22 then set_cover_image (c64_table)
        elseif showCat == 23 then set_cover_image (wswan_col_table)
        elseif showCat == 24 then set_cover_image (wswan_table)
        elseif showCat == 25 then set_cover_image (msx2_table)
        elseif showCat == 26 then set_cover_image (msx1_table)
        elseif showCat == 27 then set_cover_image (zxs_table)
        elseif showCat == 28 then set_cover_image (atari_7800_table)
        elseif showCat == 29 then set_cover_image (atari_5200_table)
        elseif showCat == 30 then set_cover_image (atari_2600_table)
        elseif showCat == 31 then set_cover_image (atari_lynx_table)
        elseif showCat == 32 then set_cover_image (colecovision_table)
        elseif showCat == 33 then set_cover_image (vectrex_table)
        elseif showCat == 34 then set_cover_image (fba_table)
        elseif showCat == 35 then set_cover_image (mame_2003_plus_table)
        elseif showCat == 36 then set_cover_image (mame_2000_table)
        elseif showCat == 37 then set_cover_image (neogeo_table)
        elseif showCat == 38 then set_cover_image (ngpc_table)
        elseif showCat == 39 then set_cover_image (psm_table)
        elseif showCat == 40 then set_cover_image (fav_count)
        elseif showCat == 41 then set_cover_image (recently_played_table)
        elseif showCat == 42 then set_cover_image (search_results_table)
        else set_cover_image (files_table)
        end
        
        local tmpapptype=""
        local tmpcatText=""
        local tmpimageText=""
        -- Draw box
        if apptype==1 then
            Render.drawModel(modCoverNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.PS_Vita_Game 
        elseif apptype==2 then
            Render.drawModel(modCoverPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.PSP_Game 
        elseif apptype==3 then
            Render.drawModel(modCoverPSXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.PS1_Game 
        elseif apptype==5 then
            Render.drawModel(modCoverN64Noref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.N64_Game 
        elseif apptype==6 then
            Render.drawModel(modCoverN64Noref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.SNES_Game 
        elseif apptype==7 then
            Render.drawModel(modCoverNESNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.NES_Game 
        elseif apptype==8 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.GBA_Game 
        elseif apptype==9 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.GBC_Game 
        elseif apptype==10 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.GB_Game
        elseif apptype==11 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.DC_Game
        elseif apptype==12 then
            Render.drawModel(modCoverNESNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.SCD_Game 
        elseif apptype==13 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.S32X_Game 
        elseif apptype==14 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.MD_Game 
        elseif apptype==15 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.SMS_Game 
        elseif apptype==16 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.GG_Game 
        elseif apptype==17 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.TurboGrafx_16_Game 
        elseif apptype==18 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.TurboGrafx_CD_Game 
        elseif apptype==19 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.PC_Engine_Game 
        elseif apptype==20 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.PC_Engine_CD_Game
        elseif apptype==21 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.Amiga_Game
        elseif apptype==22 then
            Render.drawModel(modCoverTAPENoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.C64_Game
        elseif apptype==23 then
            Render.drawModel(modCoverNESNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.WSWANCOL_Game
        elseif apptype==24 then
            Render.drawModel(modCoverNESNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.WSWAN_Game
        elseif apptype==25 then
            Render.drawModel(modCoverTAPENoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.MSX2_Game
        elseif apptype==26 then
            Render.drawModel(modCoverTAPENoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.MSX_Game
        elseif apptype==27 then
            Render.drawModel(modCoverTAPENoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.ZXS_Game
        elseif apptype==28 then
            Render.drawModel(modCoverATARINoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.A7800_Game
        elseif apptype==29 then
            Render.drawModel(modCoverATARINoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.A5200_Game
        elseif apptype==30 then
            Render.drawModel(modCoverATARINoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.A600_Game
        elseif apptype==31 then
            Render.drawModel(modCoverLYNXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.LYNX_Game
        elseif apptype==32 then
            Render.drawModel(modCoverATARINoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.COLECO_Game
        elseif apptype==33 then
            Render.drawModel(modCoverATARINoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.VECTREX_Game
        elseif apptype==34 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.FBA2012_Game
        elseif apptype==35 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.MAME2003_Game 
        elseif apptype==36 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.MAME_2000_Game 
        elseif apptype==37 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.Neo_Geo_Game 
        elseif apptype==38 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.Neo_Geo_Pocket_Color_Game 
        elseif apptype==39 then
            Render.drawModel(modCoverHbrNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.Playstation_Mobile_Game 
        else
            Render.drawModel(modCoverHbrNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines.Homebrew 
        end
    
        Font.print(fnt22, 50, 190, txtname, white)-- app name


        -- Show fav icon if game if a favourite
        if favourite_flag == true then
            if wide_getinfoscreen == true then
                Graphics.drawImage(420+24, 50, imgFavorite_large_on)
            else
                Graphics.drawImage(420, 50, imgFavorite_large_on)
            end
        else
            if wide_getinfoscreen == true then
                Graphics.drawImage(420+24, 50, imgFavorite_large_off)
            else
                Graphics.drawImage(420, 50, imgFavorite_large_off)
            end
        end

        if hide_game_flag == true then
            if wide_getinfoscreen == true then
                Graphics.drawImage(380+24, 50, imgHidden_large_on)
            else
                Graphics.drawImage(380, 50, imgHidden_large_on)
            end
        else
        end


        -- 0 Homebrew, 1 vita, 2 psp, 3 psx, 5+ Retro, 39 ps mobile

        if apptype == 0 or apptype == 1 or apptype == 2 or apptype == 3 or apptype == 39 then
            if string.match (game_path, "pspemu") or string.match (game_path, "ux0:/app/") or string.match (game_path, "ux0:/psm/") then
                Font.print(fnt22, 50, 240, tmpapptype .. "\n" .. lang_lines.App_ID_colon .. app_titleid .. "\n" .. lang_lines.Version_colon .. app_version .. "\n" .. lang_lines.Size_colon .. game_size, white)-- Draw info
                --                                               App ID:                                           Version:                                           Size:
            else
                Font.print(fnt22, 50, 240, tmpapptype .. "\n" .. lang_lines.Version_colon .. app_version .. "\n" .. lang_lines.Size_colon .. game_size, white)-- Draw info
                --                                               Version:                                           Size:
            end
        else
            Font.print(fnt22, 50, 240, tmpapptype .. "\n" .. lang_lines.Version_colon .. app_version .. "\n" .. lang_lines.Size_colon .. game_size, white)-- Draw info
            --                                               Version:                                           Size:
        end


        if tmpappcat==1 then
            tmpcatText = "PS Vita"
        elseif tmpappcat==2 then
            tmpcatText = "PSP"
        elseif tmpappcat==3 then
            tmpcatText = "PS1"
        elseif tmpappcat==4 then
            tmpcatText = lang_lines.Homebrew -- "Homebrew"
        else
            tmpcatText = lang_lines.Default -- Default
        end


        -- Download background - don't show on vita or homebrew

        if apptype == 0 or apptype == 1 then
            tmpimageText = lang_lines.Download_Cover
        elseif apptype == 39 then
            -- don't show anything for ps mobile
        else
            if tmpimagecat==1 then
                tmpimageText = lang_lines.Download_Background -- Backgrounds
            else
                tmpimageText = lang_lines.Download_Cover -- Covers
            end
        end

        -- Override not shown for retro & retroarch ps1
        if apptype == 0 or apptype == 1 or apptype == 2 or apptype == 3 then
            if string.match (game_path, "pspemu") or string.match (game_path, "ux0:/app/") then
                menuItems = 1
            else
                menuItems = 0
            end
        else
            menuItems = 0
        end


        -- 0 Homebrew, 1 Vita, 2 PSP, 3 PSX, 5+ Retro

        -- Vita and Homebrew
        -- if folder == true then -- start Disable category override for retro
        if apptype == 0 or apptype == 1 or apptype == 2 or apptype == 3 
        and string.match (game_path, "pspemu") 
        or string.match (game_path, "ux0:/app/") then
             -- start Disable category override for retro
            if menuY==1 then
                if wide_getinfoscreen == true then
                    Graphics.fillRect(24, 470+24, 350 + (menuY * 40), 430 + (menuY * 40), themeCol)-- selection two lines
                else
                    Graphics.fillRect(24, 470, 350 + (menuY * 40), 430 + (menuY * 40), themeCol)-- selection two lines
                end
            else
                if wide_getinfoscreen == true then
                    Graphics.fillRect(24, 470+24, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
                else
                    Graphics.fillRect(24, 470, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
                end
            end

            if setSwap_X_O_buttons == 1 then 
                -- Swap buttons is - On
                Press_Button_to_apply_Category = tostring(lang_lines.Press_O_to_apply_Category)
            else 
                -- Swap buttons is - Off
                Press_Button_to_apply_Category = tostring(lang_lines.Press_X_to_apply_Category)
            end

            -- Wrap text for wider languages: German, French, Russian, Portuguese, Dutch, Turkish, Hungarian
            if setLanguage == 2 or setLanguage == 3 or setLanguage == 6 or setLanguage == 8 or setLanguage == 12 or setLanguage == 16 or setLanguage == 20 then
                Font.print(fnt22, 50, 352+40, lang_lines.Override_Category_colon.. "\n< " .. tmpcatText .. " >\n( " .. Press_Button_to_apply_Category .. ")", white)
            else
                Font.print(fnt22, 50, 352+50, lang_lines.Override_Category_colon.. "< " .. tmpcatText .. " >\n( " .. Press_Button_to_apply_Category .. ")", white)
            end


        -- All other systems
        elseif apptype == 39 then
            -- dont show anything
        else
            if menuY==1 then
            else
                if wide_getinfoscreen == true then
                    Graphics.fillRect(24, 470+24, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
                else
                    Graphics.fillRect(24, 470, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
                end
            end
            -- Font.print(fnt22, 50, 352+3, "< " .. tmpimageText .. " >", white)
        end

        -- Download background - don't show on vita, homebrew or ps mobile
        if apptype == 0 or apptype == 1 or apptype == 39 then
            Font.print(fnt22, 50, 352+3, tmpimageText, white)
        else
            Font.print(fnt22, 50, 352+3, "< " .. tmpimageText .. " >", white)
        end
        

        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then
                if menuY == 0 then
                    if tmpimagecat==0 then
                        if gettingCovers == false then
                            gettingCovers = true
                            DownloadSingleCover()
                        end
                    else
                        if gettingBackgrounds == false then
                            gettingBackgrounds = true
                            DownloadSingleSnap()
                        end
                    end
                elseif menuY == 1 then
                    OverrideCategory()
                end

            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
                if menuY==0 then
                    -- Image downloads - cover or background
                    if apptype == 0 or apptype == 1 then
                        tmpimagecat=0
                    else
                        if tmpimagecat > 0 then
                            tmpimagecat = tmpimagecat - 1
                        else
                            tmpimagecat=1
                        end
                    end
                end

                if menuY==1 then
                    -- Vita and Homebrew override
                    if tmpappcat > 0 then
                        tmpappcat = tmpappcat - 1
                    else
                        tmpappcat=4 -- Limited to 4
                    end
                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                if menuY==0 then
                    -- Image downloads - cover or background
                    if apptype == 0 or apptype == 1 then
                        tmpimagecat=0
                    else
                        if tmpimagecat > 0 then
                            tmpimagecat = tmpimagecat - 1
                        else
                            tmpimagecat=1
                        end
                    end
                end

                if menuY==1 then
                    -- Vita and Homebrew override
                    if tmpappcat < 4 then  -- Limited to 4
                        tmpappcat = tmpappcat + 1
                    else
                        tmpappcat=0
                    end
                end

            end
        end

-- MENU 2 - SETTINGS
    elseif showMenu == 2 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select
        label3 = Font.getTextWidth(fnt20, lang_lines.Help_and_Guides)--Help and Guides
        label_lang = Font.getTextWidth(fnt20, lang_lines.Language_colon) + 12 --Language


        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines.Help_and_Guides, white)--Help and Guides

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Settings, white)--SETTINGS
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 7
        
        -- MENU 2 / #0 Search
        Graphics.drawImage(setting_x_icon, setting_y0, setting_icon_search)
        Font.print(fnt22, setting_x_icon_offset, setting_y0, lang_lines.Search, white)--Search
        
        -- MENU 2 / #1 Categories
        Graphics.drawImage(setting_x_icon, setting_y1, setting_icon_categories)
        Font.print(fnt22, setting_x_icon_offset, setting_y1, lang_lines.Categories, white)--Categories

        -- MENU 2 / #2 Appearance
        Graphics.drawImage(setting_x_icon, setting_y2, setting_icon_theme)
        Font.print(fnt22, setting_x_icon_offset, setting_y2, lang_lines.Theme, white)--Theme

        -- MENU 2 / #3 Audio
        Graphics.drawImage(setting_x_icon, setting_y3, setting_icon_sounds)
        Font.print(fnt22, setting_x_icon_offset, setting_y3, lang_lines.Audio, white)--Audio

        -- MENU 2 / #4 Artwork
        Graphics.drawImage(setting_x_icon, setting_y4, setting_icon_artwork)
        Font.print(fnt22, setting_x_icon_offset, setting_y4, lang_lines.Artwork, white)--Artwork

        -- MENU 2 / #5 Scanning
        Graphics.drawImage(setting_x_icon, setting_y5, setting_icon_scanning)
        Font.print(fnt22, setting_x_icon_offset, setting_y5, lang_lines.Scan_Settings, white)--Scanning

        -- MENU 2 / #6 Other Settings
        Graphics.drawImage(setting_x_icon, setting_y6, setting_icon_other)
        Font.print(fnt22, setting_x_icon_offset, setting_y6, lang_lines.Other_Settings, white)--Other Settings

        -- MENU 2 / #7 Language
        Graphics.drawImage(setting_x_icon, setting_y7, setting_icon_language)
        Font.print(fnt22, setting_x_icon_offset, setting_y7, lang_lines.Language_colon, white)--Language

        -- MENU 2 / #7 Language 
        if chooseLanguage == 1 then setLanguage = 1
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "English - American", white) -- English (United States)
            -- Megadrive, update regional missing cover
            for k, v in pairs(md_table) do
                  if v.icon_path=="app0:/DATA/missing_cover_md.png" then
                      v.icon_path="app0:/DATA/missing_cover_md_usa.png"
                  end
            end
            -- Dreamcast, update regional missing cover - USA - Red logo
            for k, v in pairs(dreamcast_table) do 
                  if v.icon_path=="app0:/DATA/missing_cover_dreamcast_eur.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_j.png" then
                      v.icon_path="app0:/DATA/missing_cover_dreamcast_usa.png"
                  end
            end
        elseif chooseLanguage == 2 then 
            -- setLanguage = 2
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Deutsch", white) -- German
        elseif chooseLanguage == 3 then 
            -- setLanguage = 3
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, " Français", white) -- French
        elseif chooseLanguage == 4 then 
            -- setLanguage = 4
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Italiano", white) -- Italian
        elseif chooseLanguage == 5 then 
            -- setLanguage = 5
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Español", white) -- Spanish
        elseif chooseLanguage == 6 then 
            -- setLanguage = 6
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Português", white) -- Portuguese
        elseif chooseLanguage == 7 then 
            -- setLanguage = 12
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Nederlands", white) -- Dutch
        elseif chooseLanguage == 8 then 
            -- setLanguage = 11
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Polski", white) -- Polish
        elseif chooseLanguage == 9 then 
            -- setLanguage = 7
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Svenska", white) -- Swedish
        elseif chooseLanguage == 10 then 
            -- setLanguage = 13
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Dansk", white) -- Danish
        elseif chooseLanguage == 11 then 
            -- setLanguage = 14
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Norsk", white) -- Norwegian
        elseif chooseLanguage == 12 then 
            -- setLanguage = 15
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Suomi", white) -- Finnish
        elseif chooseLanguage == 13 then 
            -- setLanguage = 16
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Türkçe", white) -- Turkish
        elseif chooseLanguage == 14 then
            -- setLanguage = 20
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Magyar", white) -- Hungarian
        elseif chooseLanguage == 15 then 
            -- setLanguage = 8
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "Pусский", white) -- Russian
        elseif chooseLanguage == 16 then 
            -- setLanguage = 10
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "繁體中文", white) -- Chinese (Traditional)
        elseif chooseLanguage == 17 then
            -- then setLanguage = 18
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "简体中文", white) -- Chinese (Simplified)
        elseif chooseLanguage == 18 then 
            -- setLanguage = 9
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "日本語", white) -- Japanese
            -- Dreamcast, update regional missing cover - Japan - Orange logo
            for k, v in pairs(dreamcast_table) do
                  if v.icon_path=="app0:/DATA/missing_cover_dreamcast_eur.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_usa.png" then
                      v.icon_path="app0:/DATA/missing_cover_dreamcast_j.png"
                  end
            end
        elseif chooseLanguage == 19 then
            -- then setLanguage = 18
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "琉球語派", white) -- Japanese (Ryukyuan)   
        elseif chooseLanguage == 20 then 
            -- setLanguage = 17
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "T한국어", white) -- Korean
        
        
        else 
            -- setLanguage = 0
            Font.print(fnt22, setting_x_icon_offset + label_lang, setting_y7, "English", white) -- English (United Kingdom)

            -- Megadrive, update regional missing cover
            for k, v in pairs(md_table) do
                  if v.icon_path=="app0:/DATA/missing_cover_md_usa.png" then
                      v.icon_path="app0:/DATA/missing_cover_md.png"
                  end
            end
            -- Dreamcast, update regional missing cover - Blue logo
            for k, v in pairs(dreamcast_table) do
                  if v.icon_path=="app0:/DATA/missing_cover_dreamcast_usa.png" or v.icon_path=="app0:/DATA/missing_cover_dreamcast_j.png" then
                      v.icon_path="app0:/DATA/missing_cover_dreamcast_eur.png"
                  end
            end
        end

        
        -- MENU 2 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 2 / #0 Search
                if menuY == 0 then
                    -- Search
                    if hasTyped==false then
                        Keyboard.start(tostring(lang_lines.Search), "", 512, TYPE_LATIN, MODE_TEXT)
                        hasTyped=true
                    end
                elseif menuY == 1 then -- Categories
                    showMenu = 3 
                    menuY = 0
                elseif menuY == 2 then -- Theme
                    showMenu = 4 
                    menuY = 0
                elseif menuY == 3 then -- Audio
                    showMenu = 12 
                    menuY = 0
                elseif menuY == 4 then -- Artwork
                    showMenu = 5 
                    menuY = 0
                elseif menuY == 5 then -- Scan Settings
                    showMenu = 6 
                    menuY = 0
                elseif menuY == 6 then -- Other Settings
                    showMenu = 19
                    menuY = 0
                elseif menuY == 7 then -- Language
                    if chooseLanguage < 20 then
                        chooseLanguage = chooseLanguage + 1
                    else
                        chooseLanguage = 0
                    end
                    ChangeLanguage(xsetLanguageLookup(chooseLanguage))
                else
                end

                --Save settings
                SaveSettings()

            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                state = Keyboard.getState()
                if state ~= RUNNING then
                    if menuY > 0 then
                        menuY = menuY - 1
                        else
                        menuY=menuItems
                    end
                else
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                state = Keyboard.getState()
                if state ~= RUNNING then
                    if menuY < menuItems then
                        menuY = menuY + 1
                        else
                        menuY=0
                    end
                else
                end
            elseif (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) then
                showMenu = 7 
                menuY = 0
            end
        end

-- MENU 3 - CATEGORIES
    elseif showMenu == 3 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Categories, white)--Categories
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 5

        -- MENU 3 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back

        -- MENU 3 / #1 Startup Category
        Font.print(fnt22, setting_x, setting_y1, lang_lines.Startup_Category_colon, white)--Startup Category

        if startCategory == 0 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.All, white)--ALL
        elseif startCategory == 1 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.PS_Vita, white)--GAMES
        elseif startCategory == 2 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Homebrews, white)--HOMEBREWS
        elseif startCategory == 3 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.PSP, white)--PSP
        elseif startCategory == 4 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.PlayStation, white)--PSX
        elseif startCategory == 5 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Nintendo_64, white)--N64
        elseif startCategory == 6 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Super_Nintendo, white)--SNES
        elseif startCategory == 7 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Nintendo_Entertainment_System, white)--NES
        elseif startCategory == 8 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Game_Boy_Advance, white)--GBA
        elseif startCategory == 9 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Game_Boy_Color, white)--GBC
        elseif startCategory == 10 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Game_Boy, white)--GB
        elseif startCategory == 11 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Sega_Dreamcast, white)--Sega_Dreamcast
        elseif startCategory == 12 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Sega_CD, white)--Sega_CD
        elseif startCategory == 13 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Sega_32X, white)--Sega_32X
        elseif startCategory == 14 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Sega_Mega_Drive, white)--MD
        elseif startCategory == 15 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Sega_Master_System, white)--SMS
        elseif startCategory == 16 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Sega_Game_Gear, white)--GG
        elseif startCategory == 17 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.TurboGrafx_16, white)--TG16
        elseif startCategory == 18 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.TurboGrafx_CD, white)--TGCD
        elseif startCategory == 19 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.PC_Engine, white)--PCE
        elseif startCategory == 20 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.PC_Engine_CD, white)--PCECD
        elseif startCategory == 21 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Amiga, white)--AMIGA
        elseif startCategory == 22 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Commodore_64, white)--Commodore_64
        elseif startCategory == 23 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.WonderSwan_Color, white)--WonderSwan_Color
        elseif startCategory == 24 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.WonderSwan, white)--WonderSwan
        elseif startCategory == 25 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.MSX2, white)--MSX2
        elseif startCategory == 26 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.MSX, white)--MSX
        elseif startCategory == 27 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.ZX_Spectrum, white)--ZX_Spectrum
        elseif startCategory == 28 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Atari_7800, white)--Atari_7800
        elseif startCategory == 29 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Atari_5200, white)--Atari_5200
        elseif startCategory == 30 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Atari_2600, white)--Atari_2600
        elseif startCategory == 31 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Atari_Lynx, white)--Atari_Lynx
        elseif startCategory == 32 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.ColecoVision, white)--ColecoVision
        elseif startCategory == 33 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Vectrex, white)--Vectrex
        elseif startCategory == 34 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.FBA_2012, white)--FBA_2012
        elseif startCategory == 35 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.MAME_2003Plus, white)--MAME_2003Plus
        elseif startCategory == 36 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.MAME_2000, white)--MAME_2000
        elseif startCategory == 37 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Neo_Geo, white)--Neo_Geo
        elseif startCategory == 38 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Neo_Geo_Pocket_Color, white)--Neo_Geo_Pocket_Color
        elseif startCategory == 39 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Playstation_Mobile, white)--Playstation_Mobile
        elseif startCategory == 40 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Favorites, white)--Favorite
        elseif startCategory == 41 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Recently_Played, white)--Recently Played
        end

        -- MENU 3 / #2 Show Homebews
        Font.print(fnt22, setting_x, setting_y2, lang_lines.Homebrews_Category_colon, white)--Show Homebrews
        if showHomebrews == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.Off, white)--OFF
        end

        -- MENU 3 / #3 Recently Played
        Font.print(fnt22, setting_x, setting_y3, lang_lines.Recently_Played_colon, white)--Recently Played
        if showRecentlyPlayed == 1 then
            Font.print(fnt22, setting_x_offset, setting_y3, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y3, lang_lines.Off, white)--OFF
        end

        -- MENU 3 / #4 All Category
        Font.print(fnt22, setting_x, setting_y4, lang_lines.All_Category, white)--All Category
        if showAll == 1 then
            Font.print(fnt22, setting_x_offset, setting_y4, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y4, lang_lines.Off, white)--OFF
        end

        -- MENU 4 / #5 Show hidden games
        Font.print(fnt22, setting_x, setting_y5, lang_lines.Show_hidden_games_colon, white)--Show hidden games
        if showHidden == 1 then
            Font.print(fnt22, setting_x_offset, setting_y5, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y5, lang_lines.Off, white)--OFF
        end


        -- MENU 3 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- count favorites
                create_fav_count_table(files_table)

                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 1 -- Categories

                elseif menuY == 1 then -- #1 Startup Category
                    if startCategory < count_of_start_categories then
                        startCategory = startCategory + 1
                    else
                        startCategory = 0
                    end
                    -- Skip empty categories
                    if startCategory == 1 then if #games_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 2 then if #homebrews_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 3 then if #psp_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 4 then if #psx_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 5 then if #n64_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 6 then if #snes_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 7 then if #nes_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 8 then if #gba_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 9 then if #gbc_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 10 then if #gb_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 11 then if #dreamcast_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 12 then if #sega_cd_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 13 then if #s32x_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 14 then if #md_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 15 then if #sms_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 16 then if #gg_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 17 then if #tg16_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 18 then if #tgcd_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 19 then if #pce_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 20 then if #pcecd_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 21 then if #amiga_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 22 then if #c64_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 23 then if #wswan_col_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 24 then if #wswan_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 25 then if #msx2_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 26 then if #msx1_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 27 then if #zxs_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 28 then if #atari_7800_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 29 then if #atari_5200_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 30 then if #atari_2600_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 31 then if #atari_lynx_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 32 then if #colecovision_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 33 then if #vectrex_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 34 then if #fba_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 35 then if #mame_2003_plus_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 36 then if #mame_2000_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 37 then if #neogeo_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 38 then if #ngpc_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 39 then if #psm_table == 0 then startCategory = startCategory + 1 end end
                    if startCategory == 40 then if #fav_count == 0 then startCategory = startCategory + 1 end end
                    -- if startCategory == 40 then if #recently_played_table == 0 then startCategory = startCategory + 1 end end

                elseif menuY == 2 then -- #2 Show Homebrews
                    if showHomebrews == 1 then
                        showHomebrews = 0
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                        GetInfoSelected()
                        -- If currently on homebrew category view, move to Vita category to hide empty homebrew category
                        if showCat == 2 then
                            showCat = 1
                            GetInfoSelected()
                        end
                    else
                        showHomebrews = 1
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                        GetInfoSelected()
                    end

                elseif menuY == 3 then -- #3 Recently Played
                    if showRecentlyPlayed == 1 then -- 0 Off, 1 On
                        showRecentlyPlayed = 0
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                        -- If currently on recent category view, move to Vita category to hide empty recent category
                        if showCat == 41 then
                            curTotal = #recently_played_table
                            if #recently_played_table == 0 then
                                showCat = 1
                            end
                        end
                    else
                        showRecentlyPlayed = 1
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                    end
                elseif menuY == 4 then -- #4 All Category
                    if showAll == 1 then -- 0 Off, 1 On
                        showAll = 0
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                        -- If currently on recent category view, move to Vita category to hide empty recent category
                        if showCat == 0 then
                            showCat = 1
                        end
                    else
                        showAll = 1
                    end

                elseif menuY == 5 then -- #5 Show hidden
                    if showHidden == 1 then
                        showHidden = 0
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                        if showCat == 40 then 
                            create_fav_count_table(files_table)
                        end
                        check_for_out_of_bounds()
                        GetNameAndAppTypeSelected()
                    else
                        showHidden = 1
                        -- Import cache to update All games category
                        FreeIcons()
                        count_cache_and_reload()
                        if showCat == 40 then 
                            create_fav_count_table(files_table)
                        end
                        check_for_out_of_bounds()
                        GetNameAndAppTypeSelected()
                    end
                end

                --Save settings
                SaveSettings()
                
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            end
        end

-- MENU 4 - THEME
    elseif showMenu == 4 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Theme, white)--Theme
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection


        menuItems = 3

        -- MENU 4 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back

        -- MENU 4 / #1 Theme Color
        Font.print(fnt22, setting_x, setting_y1,  lang_lines.Theme_Color_colon, white)
        if themeColor == 1 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Red, white)--Red
        elseif themeColor == 2 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Yellow, white)--Yellow
        elseif themeColor == 3 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Green, white)--Green
        elseif themeColor == 4 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Grey, white)--Grey
        elseif themeColor == 5 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Black, white)--Black
        elseif themeColor == 6 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Purple, white)--Purple
        elseif themeColor == 7 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Dark_Purple, white)--Dark Purple
        elseif themeColor == 8 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Orange, white)--Orange
        else
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Blue, white)--Blue
        end

        -- MENU 4 / #2 Reflections
        Font.print(fnt22, setting_x, setting_y2, lang_lines.Reflection_Effect_colon, white) -- REFLECTION
        if setReflections == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.Off, white)--OFF
        end

        -- MENU 4 / #3 Custom Background
        Font.print(fnt22, setting_x, setting_y3,  lang_lines.Custom_Background_colon, white)

        function wallpaper_print_string (def)
            if setBackground == (def) then
                Font.print(fnt22, setting_x_offset, setting_y3, tostring(wallpaper_table_settings[(def)].wallpaper_string), white) --FILENAME
            end
        end

        if setBackground == 0 then 
            Font.print(fnt22, setting_x_offset, setting_y3, lang_lines.Off, white) --OFF
        else
            wallpaper_print_string (setBackground)
        end


        -- MENU 4 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
    
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then
                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 2 -- Theme
                elseif menuY == 1 then -- #1 Theme Color
                    if themeColor < 7 then
                        themeColor = themeColor + 1
                    else
                        themeColor = 0
                    end
                    SetThemeColor()
                elseif menuY == 2 then -- #2 Reflections
                    if setReflections == 1 then
                        setReflections = 0
                    else
                        setReflections = 1
                    end
                elseif menuY == 3 then -- #3 Custom Background
                    bgtotal = #wallpaper_table_settings
                    if setBackground < bgtotal then
                        setBackground = setBackground + 1
                        -- Graphics.freeImage(imgBack)
                        imgBack = Graphics.loadImage(wallpaper_table_settings[setBackground].wallpaper_path)
                        imgCustomBack = imgBack
                        imgCustomBack = Graphics.loadImage(wallpaper_table_settings[setBackground].wallpaper_path)
                        Graphics.loadImage(wallpaper_table_settings[setBackground].wallpaper_path)
                        Render.useTexture(modBackground, imgCustomBack)
                    else
                        setBackground = 1 -- workaround hack as game backgrounds only show if setBackground is not 0
                        -- Graphics.freeImage(imgBack)
                        imgBack = Graphics.loadImage(wallpaper_table_settings[setBackground].wallpaper_path)
                        imgCustomBack = imgBack
                        imgCustomBack = Graphics.loadImage(wallpaper_table_settings[setBackground].wallpaper_path)
                        Graphics.loadImage(wallpaper_table_settings[setBackground].wallpaper_path)
                        Render.useTexture(modBackground, imgCustomBack)
                    end
                end

                --Save settings
                SaveSettings()

            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            end
            
        end

-- MENU 5 - ARTWORK
    elseif showMenu == 5 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Artwork, white)--Artwork
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 4

        -- MENU 5 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back


        -- MENU 5 / #1 Download Covers
        Font.print(fnt22, setting_x, setting_y1, lang_lines.Download_Covers_colon, white)

        if getCovers == 1 then
        Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.PS_Vita .. "  >", white)
        elseif getCovers == 2 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.PSP .. "  >", white)
        elseif getCovers == 3 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.PlayStation .."  >", white)
        elseif getCovers == 4 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Nintendo_64 .. "  >", white)
        elseif getCovers == 5 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Super_Nintendo .. "  >", white)
        elseif getCovers == 6 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Nintendo_Entertainment_System .. "  >", white)
        elseif getCovers == 7 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Game_Boy_Advance .. "  >", white)
        elseif getCovers == 8 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Game_Boy_Color .. "  >", white)
        elseif getCovers == 9 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Game_Boy .. "  >", white)
        elseif getCovers == 10 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Sega_Dreamcast .. "  >", white)
        elseif getCovers == 11 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Sega_CD .. "  >", white)
        elseif getCovers == 12 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Sega_32X .. "  >", white)
        elseif getCovers == 13 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Sega_Mega_Drive .. "  >", white)
        elseif getCovers == 14 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Sega_Master_System .. "  >", white)
        elseif getCovers == 15 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Sega_Game_Gear .. "  >", white)
        elseif getCovers == 16 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.TurboGrafx_16 .. "  >", white)
        elseif getCovers == 17 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.TurboGrafx_CD .. "  >", white)
        elseif getCovers == 18 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.PC_Engine .. "  >", white)
        elseif getCovers == 19 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.PC_Engine_CD .. "  >", white)
        elseif getCovers == 20 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Amiga .. "  >", white)
        elseif getCovers == 21 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Commodore_64 .. "  >", white)
        elseif getCovers == 22 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.WonderSwan_Color .. "  >", white)
        elseif getCovers == 23 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.WonderSwan .. "  >", white)
        elseif getCovers == 24 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.MSX2 .. "  >", white)
        elseif getCovers == 25 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.MSX .. "  >", white)
        elseif getCovers == 26 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.ZX_Spectrum .. "  >", white)
        elseif getCovers == 27 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Atari_7800 .. "  >", white)
        elseif getCovers == 28 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Atari_5200 .. "  >", white)
        elseif getCovers == 29 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Atari_2600 .. "  >", white)
        elseif getCovers == 30 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Atari_Lynx .. "  >", white)
        elseif getCovers == 31 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.ColecoVision .. "  >", white)
        elseif getCovers == 32 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Vectrex .. "  >", white)
        elseif getCovers == 33 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.FBA_2012 .. "  >", white)
        elseif getCovers == 34 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.MAME_2003Plus .. "  >", white)
        elseif getCovers == 35 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.MAME_2000 .. "  >", white)
        elseif getCovers == 36 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Neo_Geo .. "  >", white)
        elseif getCovers == 37 then
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.Neo_Geo_Pocket_Color .. "  >", white)
        else
            Font.print(fnt22, setting_x_offset, setting_y1, "<  " .. lang_lines.All .. "  >", white)
        end


        -- MENU 5 / #2 Download Backgrounds
        Font.print(fnt22, setting_x, setting_y2, lang_lines.Download_Backgrounds_colon, white)

        if getSnaps == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.PSP .. "  >", white)
        elseif getSnaps == 2 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.PlayStation .."  >", white)
        elseif getSnaps == 3 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Nintendo_64 .. "  >", white)
        elseif getSnaps == 4 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Super_Nintendo .. "  >", white)
        elseif getSnaps == 5 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Nintendo_Entertainment_System .. "  >", white)
        elseif getSnaps == 6 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Game_Boy_Advance .. "  >", white)
        elseif getSnaps == 7 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Game_Boy_Color .. "  >", white)
        elseif getSnaps == 8 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Game_Boy .. "  >", white)
        elseif getSnaps == 9 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Sega_Dreamcast .. "  >", white)
        elseif getSnaps == 10 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Sega_CD .. "  >", white)
        elseif getSnaps == 11 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Sega_32X .. "  >", white)
        elseif getSnaps == 12 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Sega_Mega_Drive .. "  >", white)
        elseif getSnaps == 13 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Sega_Master_System .. "  >", white)
        elseif getSnaps == 14 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Sega_Game_Gear .. "  >", white)
        elseif getSnaps == 15 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.TurboGrafx_16 .. "  >", white)
        elseif getSnaps == 16 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.TurboGrafx_CD .. "  >", white)
        elseif getSnaps == 17 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.PC_Engine .. "  >", white)
        elseif getSnaps == 18 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.PC_Engine_CD .. "  >", white)
        elseif getSnaps == 19 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Amiga .. "  >", white)
        elseif getSnaps == 20 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Commodore_64 .. "  >", white)
        elseif getSnaps == 21 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.WonderSwan_Color .. "  >", white)
        elseif getSnaps == 22 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.WonderSwan .. "  >", white)
        elseif getSnaps == 23 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.MSX2 .. "  >", white)
        elseif getSnaps == 24 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.MSX .. "  >", white)
        elseif getSnaps == 25 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.ZX_Spectrum .. "  >", white)
        elseif getSnaps == 26 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Atari_7800 .. "  >", white)
        elseif getSnaps == 27 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Atari_5200 .. "  >", white)
        elseif getSnaps == 28 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Atari_2600 .. "  >", white)
        elseif getSnaps == 29 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Atari_Lynx .. "  >", white)
        elseif getSnaps == 30 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.ColecoVision .. "  >", white)
        elseif getSnaps == 31 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Vectrex .. "  >", white)
        elseif getSnaps == 32 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.FBA_2012 .. "  >", white)
        elseif getSnaps == 33 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.MAME_2003Plus .. "  >", white)
        elseif getSnaps == 34 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.MAME_2000 .. "  >", white)
        elseif getSnaps == 35 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Neo_Geo .. "  >", white)
        elseif getSnaps == 36 then
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.Neo_Geo_Pocket_Color .. "  >", white)
        else
            Font.print(fnt22, setting_x_offset, setting_y2, "<  " .. lang_lines.All .. "  >", white)
        end

        -- MENU 5 / #3 Game Backgrounds
        Font.print(fnt22, setting_x, setting_y3, lang_lines.Extract_PSP_backgrounds, white) -- Game backgounds

        -- MENU 5 / #4 Game Backgrounds
        Font.print(fnt22, setting_x, setting_y4, lang_lines.Game_backgounds_colon, white) -- Game backgounds
        if Game_Backgrounds == 1 then
            Font.print(fnt22, setting_x_offset, setting_y4, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y3, lang_lines.Off, white)--OFF
        end

        -- MENU 5 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 5
                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 4 -- Artwork
                elseif menuY == 1 then -- #1 Download Covers
                    if gettingCovers == false then
                        gettingCovers = true
                        DownloadCovers()
                    end
                elseif menuY == 2 then -- #2 Download Backgrounds
                    if gettingBackgrounds == false then
                        gettingBackgrounds = true

                        if getSnaps == 0 then
                            if bg_table == nil then
                                bg_table = {}
                                for k, v in pairs(return_table) do
                                    if v.app_type == 0 then
                                            -- ignore homebrew
                                        elseif v.app_type == 1 then
                                            -- ignore vita
                                        else
                                        table.insert(bg_table, v)
                                    end
                                end
                                table.sort(bg_table, function(a, b) return (a.app_type < b.app_type) end)
                            end
                        end

                        DownloadSnaps()
                    end
                elseif menuY == 3 then -- #3 Extract PSP backgrounds from iso files
                    -- Create temporary file for Onelua to recognise as an instruction (OneLua will delete it after finding)
                    if not System.doesFileExist(cur_dir .. "/TITLES/onelua_extract_psp.dat") then
                        local file_over = System.openFile(cur_dir .. "/TITLES/onelua_extract_psp.dat", FCREATE)
                        System.writeFile(file_over, " ", 1)
                        System.closeFile(file_over)
                    end
                    -- Relaunch so OneLua eboot can extract the images
                    System.launchEboot("app0:/launch_scan.bin")

                elseif menuY == 4 then -- #3 Game Backgrounds
                    if Game_Backgrounds == 1 then
                        Game_Backgrounds = 0
                    else
                        Game_Backgrounds = 1
                    end
                end
                
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
                --covers download selection
                
                if menuY==1 then -- #1 Download Covers
                    if getCovers > 0 then
                        getCovers = getCovers - 1
                    else
                        getCovers = count_of_get_covers -- Check getcover number against sytem
                    end

                    -- Skip empty categories
                    if getCovers == 37 then if #ngpc_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 36 then if #neogeo_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 35 then if #mame_2000_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 34 then if #mame_2003_plus_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 33 then if #fba_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 32 then if #vectrex_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 31 then if #colecovision_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 30 then if #atari_lynx_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 29 then if #atari_2600_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 28 then if #atari_5200_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 27 then if #atari_7800_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 26 then if #zxs_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 25 then if #msx1_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 24 then if #msx2_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 23 then if #wswan_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 22 then if #wswan_col_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 21 then if #c64_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 20 then if #amiga_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 19 then if #pcecd_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 18 then if #pce_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 17 then if #tgcd_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 16 then if #tg16_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 15 then if #gg_table == 0 then getCovers = getCovers - 1 end end                
                    if getCovers == 14 then if #sms_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 13 then if #md_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 12 then if #s32x_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 11 then if #sega_cd_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 10 then if #dreamcast_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 9 then if #gb_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 8 then if #gbc_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 7 then if #gba_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 6 then if #nes_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 5 then if #snes_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 4 then if #n64_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 3 then if #psx_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 2 then if #psp_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 1 then if #games_table == 0 then getCovers = getCovers - 1 end end
                    if getCovers == 0 then if #return_table == 0 then getCovers = 36 end end

                elseif menuY==2 then -- #1 Download Backgrounds
                    if getSnaps > 0 then
                        getSnaps = getSnaps - 1
                    else
                        getSnaps = count_of_get_snaps -- Check getcover number against sytem
                    end

                    -- Skip empty categories
                    if getSnaps == 36 then if #ngpc_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 35 then if #neogeo_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 34 then if #mame_2000_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 33 then if #mame_2003_plus_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 32 then if #fba_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 31 then if #vectrex_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 30 then if #colecovision_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 29 then if #atari_lynx_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 28 then if #atari_2600_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 27 then if #atari_5200_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 26 then if #atari_7800_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 25 then if #zxs_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 24 then if #msx1_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 23 then if #msx2_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 22 then if #wswan_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 21 then if #wswan_col_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 20 then if #c64_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 19 then if #amiga_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 18 then if #pcecd_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 17 then if #pce_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 16 then if #tgcd_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 15 then if #tg16_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 14 then if #gg_table == 0 then getSnaps = getSnaps - 1 end end                
                    if getSnaps == 13 then if #sms_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 12 then if #md_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 11 then if #s32x_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 10 then if #sega_cd_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 9 then if #dreamcast_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 8 then if #gb_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 7 then if #gbc_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 6 then if #gba_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 5 then if #nes_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 4 then if #snes_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 3 then if #n64_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 2 then if #psx_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 1 then if #psp_table == 0 then getSnaps = getSnaps - 1 end end
                    if getSnaps == 0 then if #return_table == 0 then getSnaps = 35 end end

                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                --covers download selection
                if menuY==1 then -- #1 Download Covers
                    if getCovers < count_of_get_covers then -- Check getcover number against sytem
                        getCovers = getCovers + 1
                    else
                        getCovers=0
                    end

                    -- Skip empty categories
                    if getCovers == 0 then if #return_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 1 then if #games_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 2 then if #psp_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 3 then if #psx_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 4 then if #n64_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 5 then if #snes_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 6 then if #nes_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 7 then if #gba_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 8 then if #gbc_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 9 then if #gb_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 10 then if #dreamcast_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 11 then if #sega_cd_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 12 then if #s32x_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 13 then if #md_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 14 then if #sms_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 15 then if #gg_table == 0 then getCovers = getCovers + 1 end end                
                    if getCovers == 16 then if #tg16_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 17 then if #tgcd_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 18 then if #pce_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 19 then if #pcecd_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 20 then if #amiga_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 21 then if #c64_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 22 then if #wswan_col_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 23 then if #wswan_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 24 then if #msx2_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 25 then if #msx1_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 26 then if #zxs_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 27 then if #atari_7800_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 28 then if #atari_5200_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 29 then if #atari_2600_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 30 then if #atari_lynx_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 31 then if #colecovision_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 32 then if #vectrex_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 33 then if #fba_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 34 then if #mame_2003_plus_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 35 then if #mame_2000_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 36 then if #neogeo_table == 0 then getCovers = getCovers + 1 end end
                    if getCovers == 37 then if #ngpc_table == 0 then getCovers = 0 end end

                elseif menuY==2 then -- #1 Download Backgrounds
                    if getSnaps < count_of_get_snaps then -- Check getcover number against sytem
                        getSnaps = getSnaps + 1
                    else
                        getSnaps=0
                    end

                    -- Skip empty categories
                    if getSnaps == 0 then if #return_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 1 then if #psp_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 2 then if #psx_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 3 then if #n64_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 4 then if #snes_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 5 then if #nes_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 6 then if #gba_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 7 then if #gbc_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 8 then if #gb_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 9 then if #dreamcast_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 10 then if #sega_cd_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 11 then if #s32x_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 12 then if #md_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 13 then if #sms_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 14 then if #gg_table == 0 then getSnaps = getSnaps + 1 end end                
                    if getSnaps == 15 then if #tg16_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 16 then if #tgcd_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 17 then if #pce_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 18 then if #pcecd_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 19 then if #amiga_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 20 then if #c64_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 21 then if #wswan_col_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 22 then if #wswan_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 23 then if #msx2_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 24 then if #msx1_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 25 then if #zxs_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 26 then if #atari_7800_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 27 then if #atari_5200_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 28 then if #atari_2600_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 29 then if #atari_lynx_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 30 then if #colecovision_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 31 then if #vectrex_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 32 then if #fba_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 33 then if #mame_2003_plus_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 34 then if #mame_2000_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 35 then if #neogeo_table == 0 then getSnaps = getSnaps + 1 end end
                    if getSnaps == 36 then if #ngpc_table == 0 then getSnaps = 0 end end
                end
            end
        end

-- MENU 6 - SCAN SETTINGS
    elseif showMenu == 6 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Scan_Settings, white)--Scan_Settings
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 4

        -- MENU 6 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back

        -- MENU 6 / #1 Game directories
        Font.print(fnt22, setting_x, setting_y1, lang_lines.Edit_game_directories, white)--Edit_game_directories 

        -- MENU 6 / #2 Scan on Startup
        Font.print(fnt22, setting_x, setting_y2, lang_lines.Startup_scan_colon, white)--Scan on startup

        if startupScan == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.Off, white)--OFF
        end

        -- MENU 6 / #3 Adrenaline_roms
        Font.print(fnt22, setting_x, setting_y3, lang_lines.Adrenaline_roms, white)--Adrenaline_roms 

        if Adrenaline_roms == 1 then
            Font.print(fnt22, setting_x_offset, setting_y3, "<  " .. "ux0"  .. ":/pspemu" .. "  >", white)
        elseif Adrenaline_roms == 2 then
            Font.print(fnt22, setting_x_offset, setting_y3, "<  " .. "ur0"  .. ":/pspemu" .. "  >", white)
        elseif Adrenaline_roms == 3 then
            Font.print(fnt22, setting_x_offset, setting_y3, "<  " .. "imc0" .. ":/pspemu" .. "  >", white)
        elseif Adrenaline_roms == 4 then
            Font.print(fnt22, setting_x_offset, setting_y3, "<  " .. "xmc0" .. ":/pspemu" .. "  >", white)
        elseif Adrenaline_roms == 5 then
            Font.print(fnt22, setting_x_offset, setting_y3, "<  " .. lang_lines.All .. "  >", white)   
        else
            Font.print(fnt22, setting_x_offset, setting_y3, "<  " .. "uma0" .. ":/pspemu" .. "  >", white)
        end

        -- MENU 6 / #4 Rescan
        Font.print(fnt22, setting_x, setting_y4, lang_lines.Rescan, white)--Rescan

        

        -- MENU 6 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 2
                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 5 -- Scan settings
                elseif menuY == 1 then -- #1 Game directories
                    showMenu = 8
                    menuY = 0
                elseif menuY == 2 then -- #2 Scan on Startup 
                    if startupScan == 1 then -- 0 Off, 1 On
                        startupScan = 0
                        --Save settings
                        SaveSettings()
                        -- Print to Cache folder
                        FreeIcons()
                        count_cache_and_reload()
                    else
                        startupScan = 1
                        --Save settings
                        SaveSettings()
                        FreeIcons()
                        count_cache_and_reload()
                    end
                elseif menuY == 4 then -- #4 Rescan
                        delete_cache()
                        FreeIcons()
                        FreeMemory()
                        Network.term()
                        dofile("app0:index.lua")
                end
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
                if menuY==3 then -- #3 Adrenaline_roms selection
                    if Adrenaline_roms > 0 then
                        Adrenaline_roms = Adrenaline_roms - 1
                    else
                        Adrenaline_roms = 5
                    end
                    SaveSettings()
                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                if menuY==3 then -- #3 Adrenaline_roms selection
                    if Adrenaline_roms < 5 then
                        Adrenaline_roms = Adrenaline_roms + 1
                    else
                        Adrenaline_roms=0
                    end
                    SaveSettings()
                end
            end


        end

-- MENU 7 - ABOUT
    elseif showMenu == 7 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Help_and_Guides, white)--Help and Guides
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 6
        
        -- MENU 7 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 7 / #1 Guide 1
        Graphics.drawImage(setting_x_icon, setting_y1, setting_icon_about)
        Font.print(fnt22, setting_x_icon_offset, setting_y1, lang_lines.guide_1_heading, white)--Guide 1

        -- MENU 7 / #2 Guide 2
        Graphics.drawImage(setting_x_icon, setting_y2, setting_icon_about)
        Font.print(fnt22, setting_x_icon_offset, setting_y2, lang_lines.guide_2_heading, white)--Guide 2

        -- MENU 7 / #3 Guide 3
        Graphics.drawImage(setting_x_icon, setting_y3, setting_icon_about)
        Font.print(fnt22, setting_x_icon_offset, setting_y3, lang_lines.guide_3_heading, white)--Guide 3

        -- MENU 7 / #4 Guide 4
        Graphics.drawImage(setting_x_icon, setting_y4, setting_icon_about)
        Font.print(fnt22, setting_x_icon_offset, setting_y4, lang_lines.guide_4_heading, white)--Guide 4

        -- MENU 7 / #5 Guide 5
        Graphics.drawImage(setting_x_icon, setting_y5, setting_icon_about)
        Font.print(fnt22, setting_x_icon_offset, setting_y5, lang_lines.guide_5_heading, white)--Guide 5

        -- MENU 7 / #6 Guide 6
        Graphics.drawImage(setting_x_icon, setting_y6, setting_icon_about)
        Font.print(fnt22, setting_x_icon_offset, setting_y6, lang_lines.guide_6_heading, white)--Guide 6

        -- Hidden timer        
        Font.print(fnt20, 10, 508, "Overall load time: " .. (functionTime + oneLoopTime) / 1000 .. " s.  Functions: ".. functionTime / 1000 .. " s.   Main loop: ".. oneLoopTime / 1000 .. " s.", timercolor)


        
        -- MENU 7 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 2 / #0 Search
                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 0 -- Search
                elseif menuY == 1 then -- Guide 1
                    showMenu = 13 
                    menuY = 0
                elseif menuY == 2 then -- Guide 2
                    showMenu = 14 
                    menuY = 0
                elseif menuY == 3 then -- Guide 3
                    showMenu = 15 
                    menuY = 0
                elseif menuY == 4 then -- Guide 4
                    showMenu = 16 
                    menuY = 0
                elseif menuY == 5 then -- Guide 5
                    showMenu = 17 
                    menuY = 0
                elseif menuY == 6 then -- Guide 6
                    showMenu = 18 
                    menuY = 0
                else
                end

            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                state = Keyboard.getState()
                if state ~= RUNNING then
                    if menuY > 0 then
                        menuY = menuY - 1
                        else
                        menuY=menuItems
                    end
                else
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                state = Keyboard.getState()
                if state ~= RUNNING then
                    if menuY < menuItems then
                        menuY = menuY + 1
                        else
                        menuY=0
                    end
                else
                end
            elseif (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) then
                showMenu = 7 
                -- menuY = 0
            elseif (Controls.check(pad, SCE_CTRL_SELECT) and not Controls.check(oldpad, SCE_CTRL_SELECT)) then
                -- How hidden timer
                if timercolor == transparent then
                    timercolor = white
                else
                    timercolor = transparent
                end
                Screen.flip()
            end
        end

-- MENU 8 - EDIT GAME DIRECTORIES
    elseif showMenu == 8 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Game_directories, white)--Game_directories
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 3

        -- MENU 8 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back

        -- MENU 8 / #1 and 2 Game category and directory
            if getRomDir == 1 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Amiga .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Amiga, white)
                filebrowser_heading = lang_lines.Amiga
            elseif getRomDir == 2 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Atari_2600 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Atari_2600, white)
                filebrowser_heading = lang_lines.Atari_2600
            elseif getRomDir == 3 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Atari_5200 .."  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Atari_5200, white)
                filebrowser_heading = lang_lines.Atari_5200
            elseif getRomDir == 4 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Atari_7800 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Atari_7800, white)
                filebrowser_heading = lang_lines.Atari_7800
            elseif getRomDir == 5 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Atari_Lynx .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Atari_Lynx, white)
                filebrowser_heading = lang_lines.Atari_Lynx
            elseif getRomDir == 6 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.ColecoVision .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.ColecoVision, white)
                filebrowser_heading = lang_lines.ColecoVision
            elseif getRomDir == 7 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Commodore_64 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Commodore_64, white)
                filebrowser_heading = lang_lines.Commodore_64
            elseif getRomDir == 8 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.FBA_2012 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.FBA_2012, white)
                filebrowser_heading = lang_lines.FBA_2012
            elseif getRomDir == 9 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Game_Boy_Advance .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Game_Boy_Advance, white)
                filebrowser_heading = lang_lines.Game_Boy_Advance
            elseif getRomDir == 10 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Game_Boy_Color .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Game_Boy_Color, white)
                filebrowser_heading = lang_lines.Game_Boy_Color
            elseif getRomDir == 11 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Game_Boy .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Game_Boy, white)
                filebrowser_heading = lang_lines.Game_Boy
            elseif getRomDir == 12 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.MAME_2000 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.MAME_2000, white)
                filebrowser_heading = lang_lines.MAME_2000
            elseif getRomDir == 13 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.MAME_2003Plus .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.MAME_2003Plus, white)
                filebrowser_heading = lang_lines.MAME_2003Plus
            elseif getRomDir == 14 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.MSX .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.MSX, white)
                filebrowser_heading = lang_lines.MSX
            elseif getRomDir == 15 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.MSX2 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.MSX2, white)
                filebrowser_heading = lang_lines.MSX2
            elseif getRomDir == 16 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Neo_Geo_Pocket_Color .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Neo_Geo_Pocket_Color, white)
                filebrowser_heading = lang_lines.Neo_Geo_Pocket_Color
            elseif getRomDir == 17 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Neo_Geo .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Neo_Geo, white)
                filebrowser_heading = lang_lines.Neo_Geo
            elseif getRomDir == 18 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Nintendo_64 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Nintendo_64, white)
                filebrowser_heading = lang_lines.Nintendo_64
            elseif getRomDir == 19 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Nintendo_Entertainment_System .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Nintendo_Entertainment_System, white)
                filebrowser_heading = lang_lines.Nintendo_Entertainment_System
            elseif getRomDir == 20 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.PC_Engine_CD .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.PC_Engine_CD, white)
                filebrowser_heading = lang_lines.PC_Engine_CD
            elseif getRomDir == 21 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.PC_Engine .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.PC_Engine, white)
                filebrowser_heading = lang_lines.PC_Engine
            elseif getRomDir == 22 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.PlayStation .. " (RetroArch)" ..  "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.PlayStation, white)
                filebrowser_heading = lang_lines.PlayStation .. " (RetroArch)"
            elseif getRomDir == 23 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Sega_32X .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Sega_32X, white)
                filebrowser_heading = lang_lines.Sega_32X
            elseif getRomDir == 24 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Sega_CD .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Sega_CD, white)
                filebrowser_heading = lang_lines.Sega_CD
            elseif getRomDir == 25 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Sega_Dreamcast .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Sega_Dreamcast, white)
                filebrowser_heading = lang_lines.Sega_Dreamcast
            elseif getRomDir == 26 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Sega_Game_Gear .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Sega_Game_Gear, white)
                filebrowser_heading = lang_lines.Sega_Game_Gear
            elseif getRomDir == 27 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Sega_Master_System .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Sega_Master_System, white)
                filebrowser_heading = lang_lines.Sega_Master_System
            elseif getRomDir == 28 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Sega_Mega_Drive .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Sega_Mega_Drive, white)
                filebrowser_heading = lang_lines.Sega_Mega_Drive
            elseif getRomDir == 29 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Super_Nintendo .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Super_Nintendo, white)
                filebrowser_heading = lang_lines.Super_Nintendo
            elseif getRomDir == 30 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.TurboGrafx_16 .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.TurboGrafx_16, white)
                filebrowser_heading = lang_lines.TurboGrafx_16
            elseif getRomDir == 31 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.TurboGrafx_CD .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.TurboGrafx_CD, white)
                filebrowser_heading = lang_lines.TurboGrafx_CD
            elseif getRomDir == 32 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.Vectrex .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.Vectrex, white)
                filebrowser_heading = lang_lines.Vectrex
            elseif getRomDir == 33 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.WonderSwan_Color .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.WonderSwan_Color, white)
                filebrowser_heading = lang_lines.WonderSwan_Color
            elseif getRomDir == 34 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.WonderSwan .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.WonderSwan, white)
                filebrowser_heading = lang_lines.WonderSwan
            elseif getRomDir == 35 then
                Font.print(fnt22, setting_x, setting_y1, "<  " .. lang_lines.ZX_Spectrum .. "  >", white)
                Font.print(fnt20, setting_x, setting_y2 + setting_y_smallfont_offset, romUserDir.ZX_Spectrum, white)
                filebrowser_heading = lang_lines.ZX_Spectrum
            end

        -- MENU 8 / #3 Rescan
        Font.print(fnt22, setting_x, setting_y3, lang_lines.Rescan, white)--Rescan 

        -- MENU 8 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then
                -- MENU 8
                if menuY == 0 then -- #0 Back
                    showMenu = 6
                    menuY = 1
                end
                if menuY == 2 then -- #2 ROM Partitions
                    showMenu = 9
                    menuY = 0
                end
                if menuY == 3 then -- Rescan
                    delete_cache()
                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
                if menuY==1 then -- #1 category rom directory selection
                    if getRomDir > 1 then
                        getRomDir = getRomDir - 1
                    else
                        getRomDir = 35 -- Update number if add more systems
                    end
                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                if menuY==1 then -- #1 category rom directory selection
                    if getRomDir < 35 then -- Update number if add more systems
                        getRomDir = getRomDir + 1
                    else
                        getRomDir=1
                    end
                end
            end

        end

-- MENU 9 - ROM BROWSER PARTITIONS
    elseif showMenu == 9 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Back)--Back
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select
        label3 = Font.getTextWidth(fnt20, lang_lines.Close)--Close

        -- Draw footer
        Graphics.fillRect(0, 960, 496, 544, themeCol)-- footer bottom

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Back, white)--Back

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines.Close, white)--Close


        Graphics.fillRect(60, 900, 34, 460, darkalpha)--dark background

        Font.print(fnt22, setting_x, setting_yh, filebrowser_heading, white)--Game heading from menu 8
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47 +47), 129 + (menuY * 47 +47), themeCol)-- selection

        -- menuItems = 3

        menuItems = 4
        -- START ROM BROWSER PARTITIONS


            Font.print(fnt20, setting_x, setting_y0 + 2, lang_lines.Home, grey_dir) -- Home
            
            -- MENU 9 / #0 ux0 
            if System.doesDirExist("ux0:/") then
                Graphics.drawImage(setting_x_icon, setting_y1, setting_icon_scanning)
                Font.print(fnt22, setting_x_icon_offset, setting_y1, "ux0:", white)--ux0
            else
                Graphics.drawImage(setting_x_icon, setting_y1, setting_icon_scanning, white_opaque)
                Font.print(fnt22, setting_x_icon_offset, setting_y1, "ux0:", white_opaque)--ux0
            end

            -- MENU 9 / #1 uma0
            if System.doesDirExist("uma0:/") then
                Graphics.drawImage(setting_x_icon, setting_y2, setting_icon_scanning)
                Font.print(fnt22, setting_x_icon_offset, setting_y2, "uma0:", white)--uma0
            else
                Graphics.drawImage(setting_x_icon, setting_y2, setting_icon_scanning, white_opaque)
                Font.print(fnt22, setting_x_icon_offset, setting_y2, "uma0:", white_opaque)--uma0
            end

            -- MENU 9 / #2 imc0
            if System.doesDirExist("imc0:/") then
                Graphics.drawImage(setting_x_icon, setting_y3, setting_icon_scanning)
                Font.print(fnt22, setting_x_icon_offset, setting_y3, "imc0:", white)--imc0
            else
                Graphics.drawImage(setting_x_icon, setting_y3, setting_icon_scanning, white_opaque)
                Font.print(fnt22, setting_x_icon_offset, setting_y3, "imc0:", white_opaque)--imc0
            end

            -- MENU 9 / #3 xmc0
            if System.doesDirExist("xmc0:/") then
                Graphics.drawImage(setting_x_icon, setting_y4, setting_icon_scanning)
                Font.print(fnt22, setting_x_icon_offset, setting_y4, "xmc0:", white)--xmc0
            else
                Graphics.drawImage(setting_x_icon, setting_y4, setting_icon_scanning, white_opaque)
                Font.print(fnt22, setting_x_icon_offset, setting_y4, "xmc0:", white_opaque)--xmc0
            end

            -- MENU 9 / #4 grw0
            if System.doesDirExist("grw0:/") then
                Graphics.drawImage(setting_x_icon, setting_y5, setting_icon_scanning)
                Font.print(fnt22, setting_x_icon_offset, setting_y5, "grw0:", white)--xmc0
            else
                Graphics.drawImage(setting_x_icon, setting_y5, setting_icon_scanning, white_opaque)
                Font.print(fnt22, setting_x_icon_offset, setting_y5, "grw0:", white_opaque)--xmc0
            end


        -- END ROM BROWSER PARTITIONS


        -- MENU 9 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
                -- Check for input
                pad = Controls.read()
                if Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP) then

                    function check_partition_and_go_to_menu()

                        -- If partition exists - scan and go menu
                        if System.doesDirExist(selected_partition) then
                            scripts = System.listDirectory(selected_partition)
                            for k, v in pairs(scripts) do
                                v.previous_directory = false
                                v.save = false
                            end

                            -- Add level up
                            level_up = {}
                            level_up.name = "..."
                            level_up.directory = true
                            level_up.previous_directory = true
                            level_up.save = false
                            table.insert(scripts, 1, level_up) -- ...

                            scripts_sort_by_folder_first()
                            cur_dir_fm = selected_partition
                            showMenu = 11
                            menuY = 0      

                        -- If partition does not exist - go to not found menu
                        else
                            showMenu = 10
                            menuY = 0 
                        end
                    end


                    if menuY == 0 then
                        selected_partition = "ux0:/"
                        selected_partition_menuY = 0
                        check_partition_and_go_to_menu()
                    elseif menuY == 1 then
                        selected_partition = "uma0:/"
                        selected_partition_menuY = 1
                        check_partition_and_go_to_menu()
                    elseif menuY == 2 then
                        selected_partition = "imc0:/"
                        selected_partition_menuY = 2
                        check_partition_and_go_to_menu()
                    elseif menuY == 3 then
                        selected_partition = "xmc0:/"
                        selected_partition_menuY = 3
                        check_partition_and_go_to_menu()
                    elseif menuY == 4 then
                        selected_partition = "grw0:/"
                        selected_partition_menuY = 4
                        check_partition_and_go_to_menu()
                    else
                    end



                elseif Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP) then
                    oldpad = pad
                    showMenu = 8
                    menuY = 2
                elseif Controls.check(pad, SCE_CTRL_UP) and not Controls.check(oldpad, SCE_CTRL_UP) then
                    if menuY > 0 then
                        menuY = menuY - 1
                        else
                        menuY=menuItems
                    end
                elseif Controls.check(pad, SCE_CTRL_DOWN) and not Controls.check(oldpad, SCE_CTRL_DOWN) then
                    if menuY < menuItems then
                        menuY = menuY + 1
                        else
                        menuY=0
                    end
                elseif Controls.check(pad, SCE_CTRL_TRIANGLE) then
                    -- break
                    showMenu = 8
                    menuY = 2
                end

        end

-- MENU 10 - ROM BROWSER PARTITION NOT FOUND
    elseif showMenu == 10 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Back)--Back
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select
        label3 = Font.getTextWidth(fnt20, lang_lines.Close)--Close

        -- Draw footer
        Graphics.fillRect(0, 960, 496, 544, themeCol)-- footer bottom

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Back, white)--Back

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines.Close, white)--Close


        Graphics.fillRect(60, 900, 34, 460, darkalpha)--dark background

        Font.print(fnt22, setting_x, setting_yh, filebrowser_heading, white)--Game heading from menu 8
        Graphics.fillRect(60, 900, 78, 81, white)

        -- Graphics.fillRect(60, 900, 89 + (menuY * 50 +50), 150 + (menuY * 50 +50), themeCol)-- selection
        Graphics.fillRect(60, 900, 82 + (menuY * 47 +47), 129 + (menuY * 47 +47), themeCol)-- selection

        menuItems = 0

        Font.print(fnt20, setting_x, setting_y0 + 2, lang_lines.Directory_not_found, grey_dir) -- Directory not found
        Font.print(fnt22, setting_x, setting_y1, "...", white)--Back



        -- MENU 10 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
                -- Check for input
                pad = Controls.read()
                if Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP) then

                    if menuY == 0 then
                        oldpad = pad
                        showMenu = 9
                        menuY = selected_partition_menuY
                    end

                elseif Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP) then
                    oldpad = pad
                    showMenu = 9
                    menuY = selected_partition_menuY
                elseif Controls.check(pad, SCE_CTRL_UP) and not Controls.check(oldpad, SCE_CTRL_UP) then
                    if menuY > 0 then
                        menuY = menuY - 1
                        else
                        menuY=menuItems
                    end
                elseif Controls.check(pad, SCE_CTRL_DOWN) and not Controls.check(oldpad, SCE_CTRL_DOWN) then
                    if menuY < menuItems then
                        menuY = menuY + 1
                        else
                        menuY=0
                    end
                elseif Controls.check(pad, SCE_CTRL_TRIANGLE) then
                    oldpad = pad
                    showMenu = 9
                    menuY = selected_partition_menuY
                end

        end

-- MENU 11 - ROM BROWSER
    elseif showMenu == 11 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Back)--Back
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select
        label3 = Font.getTextWidth(fnt20, lang_lines.Close)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)--dark background

        Font.print(fnt22, setting_x, setting_yh, filebrowser_heading, white)--Game heading from menu 8
        Graphics.fillRect(60, 900, 78, 81, white)

        -- Graphics.fillRect(60, 900, 150 + (menuY * 46), 200 + (menuY * 46), themeCol)-- selection
        Graphics.fillRect(60, 900, 82 + (menuY * 47 +47), 129 + (menuY * 47 +47), themeCol)-- selection

        -- START ROM BROWSER

            -- Reset y axis for menu blending
            local y = setting_y1
            
            Font.print(fnt20, setting_x, setting_y0 + 2, cur_dir_fm, grey_dir)

            -- Write visible menu entries
            for j, file in pairs(scripts) do
                x = 20
                if j >= i and y < 450 then
                    if i == j then
                        color = white
                        x = 20
                    else
                        color = white
                    end

                    -- No Icon - ...
                    if file.directory == true and file.previous_directory == true then
                        Font.print(fnt22, setting_x, y, file.name, color)

                    -- Icon - Folder Open -- Use this directory
                    elseif file.directory == true and file.save == true then
                        Font.print(fnt22, setting_x_icon_offset, y, file.name, color)
                        Graphics.drawImage(setting_x, y, file_browser_folder_open)

                    -- Icon - Folder Closed
                    elseif file.directory == true and file.save == false and file.previous_directory == false then
                        Font.print(fnt22, setting_x_icon_offset, y, file.name, color)
                        Graphics.drawImage(setting_x, y, file_browser_folder_closed)

                    -- Icon - File
                    elseif file.directory == false then
                        Font.print(fnt22, setting_x_icon_offset, y, file.name, color)
                        Graphics.drawImage(setting_x, y, file_browser_file)

                    else
                    end

                    y = y + 47
                end
            end

        -- END ROM BROWSER


        -- Draw footer ontop of dynamic list
        Graphics.fillRect(0, 960, 496, 544, themeCol)-- footer bottom

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Back, white)--Back

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines.Close, white)--Close


        menuItems = 0


        -- MENU 11 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            -- START ROM BROWSER

                -- Check for input
                pad = Controls.read()
                if Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP) then

                    if scripts[i].directory == true then

                        
                        if scripts[i].previous_directory == true then
                            -- Action = Move to previous directory
                                if string.len(cur_dir_fm) > string.len(selected_partition) then -- Excluding partition name eg: ux0:/
                                    j=-2
                                    while string.sub(cur_dir_fm,j,j) ~= "/" do
                                        j=j-1
                                    end
                                    cur_dir_fm = string.sub(cur_dir_fm,1,j)

                                    scripts = System.listDirectory(cur_dir_fm)
                                    for k, v in pairs(scripts) do
                                        v.previous_directory = false
                                        v.save = false
                                    end
                                    
                                    -- Add level up
                                    level_up = {}
                                    level_up.name = "..."
                                    level_up.directory = true
                                    level_up.previous_directory = true
                                    level_up.save = false
                                    table.insert(scripts, 1, level_up) -- ...

                                    scripts_sort_by_folder_first()


                                    if string.len(cur_dir_fm) > string.len(selected_partition) then
                                        selection = {}
                                        selection.name = lang_lines.Use_this_directory -- Use_this_directory
                                        selection.directory = true
                                        selection.previous_directory = false
                                        selection.save = true
                                        table.insert(scripts, 2, selection)
                                    end

                                    i = 1
                                end

                                if string.len(cur_dir_fm) == string.len(selected_partition) then
                                    oldpad = pad
                                    showMenu = 9
                                    menuY = selected_partition_menuY
                                end

                        else

                            
                            if scripts[i].save == true then     
                                -- Action = Save directory
                                    cur_dir_fm = string.sub(cur_dir_fm, 1, -2)
                                    if getRomDir == 1 then romUserDir.Amiga = cur_dir_fm
                                    elseif getRomDir == 2 then romUserDir.Atari_2600 = cur_dir_fm
                                    elseif getRomDir == 3 then romUserDir.Atari_5200 = cur_dir_fm
                                    elseif getRomDir == 4 then romUserDir.Atari_7800 = cur_dir_fm
                                    elseif getRomDir == 5 then romUserDir.Atari_Lynx = cur_dir_fm
                                    elseif getRomDir == 6 then romUserDir.ColecoVision = cur_dir_fm
                                    elseif getRomDir == 7 then romUserDir.Commodore_64 = cur_dir_fm
                                    elseif getRomDir == 8 then romUserDir.FBA_2012 = cur_dir_fm
                                    elseif getRomDir == 9 then romUserDir.Game_Boy_Advance = cur_dir_fm
                                    elseif getRomDir == 10 then romUserDir.Game_Boy_Color = cur_dir_fm
                                    elseif getRomDir == 11 then romUserDir.Game_Boy = cur_dir_fm
                                    elseif getRomDir == 12 then romUserDir.MAME_2000 = cur_dir_fm
                                    elseif getRomDir == 13 then romUserDir.MAME_2003Plus = cur_dir_fm
                                    elseif getRomDir == 14 then romUserDir.MSX = cur_dir_fm
                                    elseif getRomDir == 15 then romUserDir.MSX2 = cur_dir_fm
                                    elseif getRomDir == 16 then romUserDir.Neo_Geo_Pocket_Color = cur_dir_fm
                                    elseif getRomDir == 17 then romUserDir.Neo_Geo = cur_dir_fm
                                    elseif getRomDir == 18 then romUserDir.Nintendo_64 = cur_dir_fm
                                    elseif getRomDir == 19 then romUserDir.Nintendo_Entertainment_System = cur_dir_fm
                                    elseif getRomDir == 20 then romUserDir.PC_Engine_CD = cur_dir_fm
                                    elseif getRomDir == 21 then romUserDir.PC_Engine = cur_dir_fm
                                    elseif getRomDir == 22 then romUserDir.PlayStation = cur_dir_fm
                                    elseif getRomDir == 23 then romUserDir.Sega_32X = cur_dir_fm
                                    elseif getRomDir == 24 then romUserDir.Sega_CD = cur_dir_fm
                                    elseif getRomDir == 25 then romUserDir.Sega_Dreamcast = cur_dir_fm
                                    elseif getRomDir == 26 then romUserDir.Sega_Game_Gear = cur_dir_fm
                                    elseif getRomDir == 27 then romUserDir.Sega_Master_System = cur_dir_fm
                                    elseif getRomDir == 28 then romUserDir.Sega_Mega_Drive = cur_dir_fm
                                    elseif getRomDir == 29 then romUserDir.Super_Nintendo = cur_dir_fm
                                    elseif getRomDir == 30 then romUserDir.TurboGrafx_16 = cur_dir_fm
                                    elseif getRomDir == 31 then romUserDir.TurboGrafx_CD = cur_dir_fm
                                    elseif getRomDir == 32 then romUserDir.Vectrex = cur_dir_fm
                                    elseif getRomDir == 33 then romUserDir.WonderSwan_Color = cur_dir_fm
                                    elseif getRomDir == 34 then romUserDir.WonderSwan = cur_dir_fm
                                    elseif getRomDir == 35 then romUserDir.ZX_Spectrum = cur_dir_fm
                                    end

                                    print_table_rom_dirs(romUserDir)

                                    
                                    showMenu = 8
                                    menuY = 2
                                    scripts = System.listDirectory(selected_partition)
                                    scripts_sort_by_folder_first()
                                    for k, v in pairs(scripts) do
                                        v.previous_directory = false
                                        v.save = false
                                    end

                                    cur_dir_fm = selected_partition

                            else
                                -- Action = List the directory
                                    cur_dir_fm = cur_dir_fm .. scripts[i].name .. "/"
                                    scripts = System.listDirectory(cur_dir_fm)
                                    for k, v in pairs(scripts) do
                                        v.previous_directory = false
                                        v.save = false
                                    end

                                    scripts_sort_by_folder_first()

                                    level_up = {}
                                    level_up.name = "..."
                                    level_up.directory = true
                                    level_up.previous_directory = true
                                    level_up.save = false
                                    
                                    table.insert(scripts, 1, level_up) -- ...

                                    selection = {}
                                    selection.name = lang_lines.Use_this_directory -- Use_this_directory
                                    selection.directory = true
                                    selection.previous_directory = false
                                    selection.save = true
                                    table.insert(scripts, 2, selection)


                                    i = 1

                            end

                        end


                    end

                elseif Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP) then
                    
                    local _, dir_level_count = string.gsub(cur_dir_fm, "/", "")
                    if dir_level_count == 1 then
                        oldpad = pad
                        showMenu = 9
                        menuY = selected_partition_menuY
                        scripts = System.listDirectory(selected_partition)
                        scripts_sort_by_folder_first()
                        for k, v in pairs(scripts) do
                            v.previous_directory = false
                            v.save = false
                        end
                        cur_dir_fm = selected_partition
                    else


                        if string.len(cur_dir_fm) > string.len(selected_partition) then -- Excluding partition name eg: ux0:/
                            j=-2
                            while string.sub(cur_dir_fm,j,j) ~= "/" do
                                j=j-1
                            end
                            cur_dir_fm = string.sub(cur_dir_fm,1,j)
                            scripts = System.listDirectory(cur_dir_fm)
                            for k, v in pairs(scripts) do
                                v.previous_directory = false
                                v.save = false
                            end

                            -- Add level up
                            level_up = {}
                            level_up.name = "..."
                            level_up.directory = true
                            level_up.previous_directory = true
                            level_up.save = false
                            table.insert(scripts, 1, level_up) -- ...

                            scripts_sort_by_folder_first()
                           
                            if string.len(cur_dir_fm) > string.len(selected_partition) then -- Excluding partition name eg: ux0:/
                                selection = {}
                                selection.name = lang_lines.Use_this_directory -- Use_this_directory
                                selection.directory = true
                                selection.previous_directory = false
                                selection.save = true
                                table.insert(scripts, 2, selection)
                            end
 
                            i = 1
                        else
                        end

                    end
                elseif Controls.check(pad, SCE_CTRL_UP) and not Controls.check(oldpad, SCE_CTRL_UP) then
                    i = i - 1
                elseif Controls.check(pad, SCE_CTRL_DOWN) and not Controls.check(oldpad, SCE_CTRL_DOWN) then
                    i = i + 1
                elseif Controls.check(pad, SCE_CTRL_TRIANGLE) then
                    -- break
                    showMenu = 8
                    menuY = 2
                    scripts = System.listDirectory(selected_partition)
                    scripts_sort_by_folder_first()
                    for k, v in pairs(scripts) do
                        v.previous_directory = false
                        v.save = false
                    end
                    cur_dir_fm = selected_partition
                end

            -- END ROM BROWSER 

        end

-- MENU 12 - AUDIO
    elseif showMenu == 12 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Audio, white)--Audio
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        -- Hide skip track if no music or only 1 song
        if #music_sequential > 1 then
            menuItems = 4
        else
            menuItems = 3
        end

        -- MENU 12 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back

        -- MENU 12 / #1 SOUNDS
        Font.print(fnt22, setting_x, setting_y1, lang_lines.Sounds_colon, white)--SOUNDS
        if setSounds == 1 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Off, white)--OFF
        end

        -- MENU 12 / #2 MUSIC
        Font.print(fnt22, setting_x, setting_y2, lang_lines.Music_colon, white)--MUSIC
        if setMusic == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.Off, white)--OFF
        end

        -- MENU 12 / #3 SHUFFLE MUSIC
        Font.print(fnt22, setting_x, setting_y3, lang_lines.Shuffle_music_colon, white)--SHUFFLE MUSIC
        if setMusicShuffle == 1 then
            Font.print(fnt22, setting_x_offset, setting_y3, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y3, lang_lines.Off, white)--OFF
        end

        -- MENU 12 / #4 SKIP TRACK
        if #music_sequential > 1 then
            Font.print(fnt22, setting_x, setting_y4, lang_lines.Skip_track, white)--SKIP TRACK
        else
        end

        -- MENU 12 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
    
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then
                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 3 -- Audio 
                elseif menuY == 1 then -- #1 Sounds
                    if setSounds == 1 then
                        setSounds = 0
                    else
                        setSounds = 1
                    end            
                elseif menuY == 2 then -- #2 Music
                    if setMusic == 1 then
                        setMusic = 0
                        if Sound.isPlaying(sndMusic) then
                            Sound.close(sndMusic)
                        end
                    else
                        setMusic = 1
                        if setMusicShuffle == 1 then
                            Shuffle(music_sequential)
                            track = 1
                            PlayMusic()
                        else
                            track = 1
                            PlayMusic()
                        end
                    end  
                elseif menuY == 3 then -- #3 Shuffle music
                    if setMusicShuffle == 1 then
                        setMusicShuffle = 0
                        if setMusic == 1 then
                            if Sound.isPlaying(sndMusic) then
                                Sound.close(sndMusic)
                                track = 1
                                PlayMusic()
                            end
                        else
                        end
                    else
                        setMusicShuffle = 1
                        if setMusic == 1 then
                            if Sound.isPlaying(sndMusic) then
                                Sound.close(sndMusic)
                                Shuffle(music_sequential)
                                track = 1
                                PlayMusic()
                            end
                        else
                        end
                    end
                elseif menuY == 4 then -- #4 Skip track
                    if setMusic == 1 then
                        if Sound.isPlaying(sndMusic) then
                            Sound.close(sndMusic)
                            track = track + 1 
                            PlayMusic()
                        end
                    else
                    end           
                end

                --Save settings
                SaveSettings()
                
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            end
        end

-- MENU 13 - GUIDE 1
    elseif showMenu == 13 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.guide_1_heading, white)-- Guide 1 Heading
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 1
        
        -- MENU 13 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 13 / #1 Content
        if setLanguage == 8 or setLanguage == 9 or setLanguage == 10 or setLanguage == 17 or setLanguage == 18 or setLanguage == 19 then
            -- Manual text wrapping for non latin alphabets
            Font.print(fnt22, setting_x, setting_y1, lang_lines.guide_1_content, white)-- Guide 1 Content
        else
            Font.print(fnt22, setting_x, setting_y1, wraptextlength(lang_lines.guide_1_content, 75), white)-- Guide 1 Content
        end
        
        -- MENU 13 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 13 / #0 Back
                if menuY == 0 then -- #0 Back
                    showMenu = 7 -- About
                    menuY = 1 -- Guide 1
                end

            end
        end

-- MENU 14 - GUIDE 2
    elseif showMenu == 14 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.guide_2_heading, white)-- Guide 2 Heading
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 1
        
        -- MENU 14 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 14 / #1 Content
        if setLanguage == 8 or setLanguage == 9 or setLanguage == 10 or setLanguage == 17 or setLanguage == 18 or setLanguage == 19 then
            -- Manual text wrapping for non latin alphabets
            Font.print(fnt22, setting_x, setting_y1, lang_lines.guide_2_content, white)-- Guide 2 Content
        else
            Font.print(fnt22, setting_x, setting_y1, wraptextlength(lang_lines.guide_2_content, 75), white)-- Guide 2 Content
        end
        
        -- MENU 14 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 14 / #0 Back
                if menuY == 0 then -- #0 Back
                    showMenu = 7 -- About
                    menuY = 2 -- Guide 2
                end

            end
        end

-- MENU 15 - GUIDE 3
    elseif showMenu == 15 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.guide_3_heading, white)-- Guide 3 Heading
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 1
        
        -- MENU 15 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 15 / #1 Content
        if setLanguage == 8 or setLanguage == 9 or setLanguage == 10 or setLanguage == 17 or setLanguage == 18 or setLanguage == 19 then
            -- Manual text wrapping for non latin alphabets
            Font.print(fnt22, setting_x, setting_y1, lang_lines.guide_3_content, white)-- Guide 3 Content
        else
            Font.print(fnt22, setting_x, setting_y1, wraptextlength(lang_lines.guide_3_content, 75), white)-- Guide 3 Content
        end

        
        -- MENU 15 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 15 / #0 Back
                if menuY == 0 then -- #0 Back
                    showMenu = 7 -- About
                    menuY = 3 -- Guide 3
                end

            end
        end

-- MENU 16 - GUIDE 4
    elseif showMenu == 16 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.guide_4_heading, white)-- Guide 4 Heading
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 1
        
        -- MENU 16 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 16 / #1 Content
        if setLanguage == 8 or setLanguage == 9 or setLanguage == 10 or setLanguage == 17 or setLanguage == 18 or setLanguage == 19 then
            -- Manual text wrapping for non latin alphabets
            Font.print(fnt22, setting_x, setting_y1, lang_lines.guide_4_content, white)-- Guide 4 Content
        else
            Font.print(fnt22, setting_x, setting_y1, wraptextlength(lang_lines.guide_4_content, 75), white)-- Guide 4 Content
        end

        
        -- MENU 16 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 16 / #0 Back
                if menuY == 0 then -- #0 Back
                    showMenu = 7 -- About
                    menuY = 4 -- Guide 4
                end

            end
        end

-- MENU 17 - GUIDE 5
    elseif showMenu == 17 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.guide_5_heading, white)-- Guide 5 Heading
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 1
        
        -- MENU 17 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 17 / #1 Content
        if setLanguage == 8 or setLanguage == 9 or setLanguage == 10 or setLanguage == 17 or setLanguage == 18 or setLanguage == 19 then
            -- Manual text wrapping for non latin alphabets
            Font.print(fnt22, setting_x, setting_y1, lang_lines.guide_5_content, white)-- Guide 5 Content
        else
            Font.print(fnt22, setting_x, setting_y1, wraptextlength(lang_lines.guide_5_content, 75), white)-- Guide 5 Content
        end
        
        -- MENU 17 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 17 / #0 Back
                if menuY == 0 then -- #0 Back
                    showMenu = 7 -- About
                    menuY = 5 -- Guide 5
                end

            end
        end

-- MENU 18 - GUIDE 6
    elseif showMenu == 18 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.guide_6_heading, white)-- Guide 6 Heading
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection

        menuItems = 1
        
        -- MENU 18 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back
        
        -- MENU 18 / #1 Content
        Font.print(fnt22, setting_x, setting_y1, "RetroFlow version " .. appversion, white)-- Guide 6 Content
        
        if setLanguage == 8 or setLanguage == 9 or setLanguage == 10 or setLanguage == 17 or setLanguage == 18 or setLanguage == 19 then
            -- Manual text wrapping for non latin alphabets
            Font.print(fnt22, setting_x, setting_y2, lang_lines.guide_6_content, white)-- Guide 6 Content
        else
            Font.print(fnt22, setting_x, setting_y2, wraptextlength(lang_lines.guide_6_content, 75), white)-- Guide 6 Content
        end

        -- MENU 18 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 18 / #0 Back
                if menuY == 0 then -- #0 Back
                    showMenu = 7 -- About
                    menuY = 6 -- Guide 6
                end

            end
        end

-- MENU 19 - OTHER SETTINGS
    elseif showMenu == 19 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select

        Graphics.fillRect(60, 900, 34, 460, darkalpha)

        Font.print(fnt22, setting_x, setting_yh, lang_lines.Other_Settings, white)--Other Settings
        Graphics.fillRect(60, 900, 78, 81, white)

        Graphics.fillRect(60, 900, 82 + (menuY * 47), 129 + (menuY * 47), themeCol)-- selection


        menuItems = 2

        -- MENU 19 / #0 Back
        Font.print(fnt22, setting_x, setting_y0, lang_lines.Back_Chevron, white)--Back

        -- MENU 19 / #4 Remap X and O buttons
        Font.print(fnt22, setting_x, setting_y1,  lang_lines.Swap_X_and_O_buttons_colon, white)
        if setSwap_X_O_buttons == 1 then
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.On, white)--ON
        else
            Font.print(fnt22, setting_x_offset, setting_y1, lang_lines.Off, white)--OFF
        end

        -- MENU 19 / #5 Adrenaline PS Button
        Font.print(fnt22, setting_x, setting_y2, lang_lines.Adrenaline_PS_button_colon, white)--Adrenaline PS Button
        if setAdrPSButton == 0 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.Menu, white)--Menu
        elseif setAdrPSButton == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.LiveArea, white)--LiveArea
        elseif setAdrPSButton == 2 then
            Font.print(fnt22, setting_x_offset, setting_y2, lang_lines.Standard, white)--Standard
        end


        -- MENU 19 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
    
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then
                if menuY == 0 then -- #0 Back
                    showMenu = 2
                    menuY = 6 -- Other Settings

                elseif menuY == 1 then -- #1 Remap X and O buttons
                    if setSwap_X_O_buttons == 1 then
                        setSwap_X_O_buttons = 0
                    else
                        setSwap_X_O_buttons = 1
                    end
                    Swap_X_O_buttons()
                    oldpad = pad
                    showMenu = 19
                    menuY = 1

                elseif menuY == 2 then -- #2 Adrenaline PS Button
                    if setAdrPSButton < 2 then
                        setAdrPSButton = setAdrPSButton + 1
                    else
                        setAdrPSButton = 0
                    end
                end

                --Save settings
                SaveSettings()

            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            end
            
        end


-- MENU 20 - GAME OPTIONS
    elseif showMenu == 20 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select


        -- GET MENU ITEM COUNT (Some menus app type specific)
            
            menuItems = 2
            
            -- Check for dynamic menu item
            local adrenaline_flag = false
            if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                if string.match (xCatLookup(showCat)[p].game_path, "pspemu") and not System.doesFileExist(xCatLookup(showCat)[p].game_path .. "/EBOOT.PBP") then
                    
                    adrenaline_flag = true
                    menuItems = menuItems + 1
                else
                    adrenaline_flag = false
                    menuItems = menuItems
                end
            end

            -- Add extra for remove from recent
            local recent_cat_flag = false
            if showCat == 41 then
                recent_cat_flag = true
                menuItems = menuItems + 1
            else
                if #recently_played_table ~= nil then
                    local key = find_game_table_pos_key(recently_played_table, app_titleid)
                    if key ~= nil then
                        recent_cat_flag = true
                        menuItems = menuItems + 1
                    else
                        recent_cat_flag = false
                    end
                end
            end

            -- Calculate vertical centre
            vertically_centre_mini_menu(menuItems)

        -- GRAPHIC SETUP
        
            -- Apply mini menu margins
            local setting_x = setting_x + mini_menu_x_margin

            -- Draw black overlay
            Graphics.fillRect(0, 960, 0, 540, blackalpha)

            -- Draw footer
            Graphics.fillRect(0, 960, 496, 544, themeCol)

            Graphics.drawImage(900-label1, 510, btnO)
            Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

            Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
            Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select
            
            -- Draw dark overlay
            Graphics.fillRect(60 + mini_menu_x_margin, 900 - mini_menu_x_margin, y_centre_top_margin, y_centre_top_margin + y_centre_box_height, dark)

            -- Draw white line
            Graphics.fillRect(60 + mini_menu_x_margin, 900 - mini_menu_x_margin, y_centre_white_line_start, y_centre_white_line_start + 3, white)
            
            -- Draw selection
            Graphics.fillRect(60 + mini_menu_x_margin, 900 - mini_menu_x_margin, y_centre_selection_start + (menuY * 47), y_centre_selection_end + (menuY * 47), themeCol)-- selection


        -- MENU 20 / Heading
        GetInfoSelected() -- Get game info for heading
        Font.print(fnt22, setting_x, setting_yh + y_centre_text_offset, app_title, white)--Game Options

        -- MENU 20 / #0 Favorites
        if favourite_flag == true then
            Font.print(fnt22, setting_x, setting_y0 + y_centre_text_offset, lang_lines.Remove_from_favorites, white)--Remove from favourites
        else
            Font.print(fnt22, setting_x, setting_y0 + y_centre_text_offset, lang_lines.Add_to_favorites, white)--Add to favourites
        end

        -- MENU 20 / #1 Rename
        Font.print(fnt22, setting_x, setting_y1 + y_centre_text_offset, lang_lines.Rename, white)--Rename

        -- MENU 20 / #2 Hide Game
        if hide_game_flag == true then
            Font.print(fnt22, setting_x, setting_y2 + y_centre_text_offset, lang_lines.Unhide_game, white)--Unhide game
        else
            Font.print(fnt22, setting_x, setting_y2 + y_centre_text_offset, lang_lines.Hide_game, white)--Hide game
        end
        
        -- -- MENU 20 / #3 Adrenaline options
        -- if adrenaline_flag == true then
        --     Font.print(fnt22, setting_x, setting_y3 + y_centre_text_offset, lang_lines.Adrenaline_options, white)--Adrenaline options
        -- else
        -- end

        -- MENU 20 / #3 / #4 - Dynamic based on Recent Category and Adrenaline options
        if recent_cat_flag == true then
            if adrenaline_flag == true then
                Font.print(fnt22, setting_x, setting_y3 + y_centre_text_offset, lang_lines.Adrenaline_options, white)--Adrenaline options
                Font.print(fnt22, setting_x, setting_y4 + y_centre_text_offset, lang_lines.Remove_from_recently_played, white)--Remove from recently played
            else
                Font.print(fnt22, setting_x, setting_y3 + y_centre_text_offset, lang_lines.Remove_from_recently_played, white)--Remove from recently played
            end
        else
            if adrenaline_flag == true then
                Font.print(fnt22, setting_x, setting_y3 + y_centre_text_offset, lang_lines.Adrenaline_options, white)--Adrenaline options
            end
        end
        
        
        
        -- MENU 20 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 20
                if menuY == 0 then -- #0 Favorites
                    -- Favourites
                    AddOrRemoveFavorite()

                    -- Update text
                    if favourite_flag == true then
                        favourite_flag = false
                    else
                        favourite_flag = true
                    end

                    -- If on favorite category, go to main screen, otherwise the next fav game is shown
                    if showCat == 40 then
                        GetInfoSelected()
                        oldpad = pad -- Prevents it from launching next game accidentally. Credit BlackSheepBoy69
                        showMenu = 0
                        Render.useTexture(modBackground, imgCustomBack)
                    end
                    
                elseif menuY == 1 then -- #1 Rename
                    -- Rename
                    if hasTyped==false then
                        Keyboard.start(tostring(lang_lines.Rename), app_title:gsub("\n",""), 512, TYPE_LATIN, MODE_TEXT)
                        hasTyped=true
                        rename_keyboard=true
                    end
                    
                elseif menuY == 2 then -- #2 Hide Game
                    
                    GetInfoSelected()

                    -- Update text
                    if hide_game_flag == true then
                        hide_game_flag = false
                    else
                        hide_game_flag = true
                    end

                    -- Update hidden games lua file

                    -- Update other tables in realtime
                    AddOrRemoveHidden(hide_game_flag)

                        -- Check if the hidden game table is empty
                        if #hidden_games_table ~= nil then -- Is not empty

                            -- Check if game is already in the list
                            local key = find_game_table_pos_key(hidden_games_table, app_titleid)
                            if key ~= nil then
                                -- Game found - If set to unhide, then remove from table
                                hidden_games_table[key].hidden = hide_game_flag
                            else
                                -- Game not found, it's new, add it to the hidden list

                                -- Find game in app table, update and add to hidden
                                local key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                                if key ~= nil then
                                    table.insert(hidden_games_table, xAppNumTableLookup(apptype)[key])
                                else
                                end

                            end

                        else -- Is empty, add first game to hide 
                            -- Find game in app table, update and add to hidden
                            local key = find_game_table_pos_key(xAppNumTableLookup(apptype), app_titleid)
                            if key ~= nil then
                                table.insert(hidden_games_table, xAppNumTableLookup(apptype)[key])
                            else
                            end
                        end

                        -- Save the hidden game table for importing on restart
                        update_cached_table_hidden_games()

                    FreeIcons()
                    count_cache_and_reload()
                    GetInfoSelected()

                    if showHidden == 0 then
                        oldpad = pad -- Prevents it from launching next game accidentally. Credit BlackSheepBoy69
                        showMenu = 0
                        Render.useTexture(modBackground, imgCustomBack)
                        GetNameAndAppTypeSelected()
                    else
                        GetInfoSelected()
                        -- Instant cover update - Credit BlackSheepBoy69
                        Threads.addTask(xCatLookup(showCat)[p], {
                        Type = "ImageLoad",
                        Path = xCatLookup(showCat)[p].icon_path,
                        Table = xCatLookup(showCat)[p],
                        Index = "ricon"
                        })
                    end

                elseif menuY == 3 then -- #3 - Dynamic based on Recent Category and Adrenaline options
                    if adrenaline_flag == true then
                        
                        game_adr_bin_driver = 0
                        game_adr_exec_bin = 0

                        -- Get existing settings
                        local key = find_game_table_pos_key(launch_overrides_table, app_titleid)
                        if key ~= nil then
                            -- Yes - it's already in the launch override list, update it.
                            game_adr_bin_driver = launch_overrides_table[key].driver
                            game_adr_exec_bin = launch_overrides_table[key].bin
                        end

                        showMenu = 21
                        menuY = 0
                    else
                        if recent_cat_flag == true then

                            -- remove recent
                            if #recently_played_table ~= nil then
                                if showCat == 41 then
                                    -- We are in the recent category, remove the game and save cache
                                    table.remove(recently_played_table, p)
                                    update_cached_table_recently_played()
                                    oldpad = pad -- Prevents it from launching next game accidentally
                                    showMenu = 0
                                    Render.useTexture(modBackground, imgCustomBack)
                                    check_for_out_of_bounds()
                                else
                                    -- We are NOT the recent category, Find game in recent table and remove, then save cache
                                    key = find_game_table_pos_key(recently_played_table, app_titleid)
                                    if key ~= nil then
                                        table.remove(recently_played_table, key)
                                        update_cached_table_recently_played()
                                        GetInfoSelected()
                                        menuY = 0
                                    else
                                    end
                                end
                            end

                        else
                        end
                    end
                elseif menuY == 4 then -- #4 Remove from recent
                    if recent_cat_flag == true then

                        -- remove recent
                        if #recently_played_table ~= nil then
                            if showCat == 41 then
                                -- We are in the recent category, remove the game and save cache
                                table.remove(recently_played_table, p)
                                update_cached_table_recently_played()
                                oldpad = pad -- Prevents it from launching next game accidentally
                                showMenu = 0
                                Render.useTexture(modBackground, imgCustomBack)
                                check_for_out_of_bounds()
                            else
                                -- We are NOT the recent category, Find game in recent table and remove, then save cache
                                key = find_game_table_pos_key(recently_played_table, app_titleid)
                                if key ~= nil then
                                    table.remove(recently_played_table, key)
                                    update_cached_table_recently_played()
                                    GetInfoSelected()
                                    menuY = 0
                                else
                                end
                            end
                        end

                    else
                    end
                end


            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            elseif Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP) then
                oldpad = pad
                GetInfoSelected()
                showMenu = 1
                menuY=0
            end
        end



-- MENU 21 - GAME OPTIONS
    elseif showMenu == 21 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        label1 = Font.getTextWidth(fnt20, lang_lines.Close)--Close
        label2 = Font.getTextWidth(fnt20, lang_lines.Select)--Select


        -- GET MENU ITEM COUNT
            
            menuItems = 3
            
        -- Calculate vertical centre
            vertically_centre_mini_menu(menuItems)

        -- GRAPHIC SETUP
        
            -- Apply mini menu margins
            local setting_x = setting_x + mini_menu_x_margin

            -- Draw black overlay
            Graphics.fillRect(0, 960, 0, 540, blackalpha)

            -- Draw footer
            Graphics.fillRect(0, 960, 496, 544, themeCol)

            Graphics.drawImage(900-label1, 510, btnO)
            Font.print(fnt20, 900+28-label1, 508, lang_lines.Close, white)--Close

            Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
            Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines.Select, white)--Select
            
            -- Draw dark overlay
            Graphics.fillRect(60 + mini_menu_x_margin, 900 - mini_menu_x_margin, y_centre_top_margin, y_centre_top_margin + y_centre_box_height, dark)

            -- Draw white line
            Graphics.fillRect(60 + mini_menu_x_margin, 900 - mini_menu_x_margin, y_centre_white_line_start, y_centre_white_line_start + 3, white)
            
            -- Draw selection
            Graphics.fillRect(60 + mini_menu_x_margin, 900 - mini_menu_x_margin, y_centre_selection_start + (menuY * 47), y_centre_selection_end + (menuY * 47), themeCol)-- selection


        -- MENU 21 / Heading
        Font.print(fnt22, setting_x, setting_yh + y_centre_text_offset, lang_lines.Adrenaline_options, white)--Adrenaline options

        -- MENU 21 / #0 Back
        Font.print(fnt22, setting_x, setting_y0 + y_centre_text_offset, lang_lines.Back_Chevron, white)--Back

        -- MENU 21 / #1 Driver
        Font.print(fnt22, setting_x, setting_y1 + y_centre_text_offset, lang_lines.Driver_colon, white)--Driver

        

        -- Menu
        if game_adr_bin_driver == 1 then
            Font.print(fnt22, setting_x_offset, setting_y1 + y_centre_text_offset, "<  " .. "INFERNO" .. "  >", white)
        elseif game_adr_bin_driver == 2 then
            Font.print(fnt22, setting_x_offset, setting_y1 + y_centre_text_offset, "<  " .. "MARCH33" .. "  >", white)
        elseif game_adr_bin_driver == 3 then
            Font.print(fnt22, setting_x_offset, setting_y1 + y_centre_text_offset, "<  " .. "NP9660" .."  >", white)
        elseif setLanguage == 11 then
            -- Use alternate translation for Polish
            Font.print(fnt22, setting_x_offset, setting_y1 + y_centre_text_offset, "<  " .. lang_lines.Default_alt_translation_1 .. "  >", white)
        else
            Font.print(fnt22, setting_x_offset, setting_y1 + y_centre_text_offset, "<  " .. lang_lines.Default .. "  >", white)
        end

        -- MENU 21 / #2 Execute bin
        Font.print(fnt22, setting_x, setting_y2 + y_centre_text_offset, lang_lines.Execute_colon, white)--Execute

        if game_adr_exec_bin == 1 then
            Font.print(fnt22, setting_x_offset, setting_y2 + y_centre_text_offset, "<  " .. "EBOOT.BIN" .. "  >", white)
        elseif game_adr_exec_bin == 2 then
            Font.print(fnt22, setting_x_offset, setting_y2 + y_centre_text_offset, "<  " .. "EBOOT.OLD" .. "  >", white)
        elseif game_adr_exec_bin == 3 then
            Font.print(fnt22, setting_x_offset, setting_y2 + y_centre_text_offset, "<  " .. "BOOT.BIN" .."  >", white)
        elseif setLanguage == 11 then
            -- Use alternate translation for Polish
            Font.print(fnt22, setting_x_offset, setting_y2 + y_centre_text_offset, "<  " .. lang_lines.Default_alt_translation_2 .. "  >", white)
        else
            Font.print(fnt22, setting_x_offset, setting_y2 + y_centre_text_offset, "<  " .. lang_lines.Default .. "  >", white)
        end


        -- MENU 21 / #3 Save
        Font.print(fnt22, setting_x, setting_y3 + y_centre_text_offset, lang_lines.Save, white)--Save

        
        -- MENU 21 - FUNCTIONS
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then

                -- MENU 21
                if menuY == 0 then -- #0 Back
                    showMenu = 20
                    menuY=3

                elseif menuY == 3 then -- #3 Save the setting
                    
                    if #launch_overrides_table ~= nil then
                        local key = find_game_table_pos_key(launch_overrides_table, app_titleid)
                        if key ~= nil then
                            -- Yes - it's already in the launch override list, update it.
                            launch_overrides_table[key].driver = game_adr_bin_driver
                            launch_overrides_table[key].bin = game_adr_exec_bin
                        else
                            -- No, it's new, add it to the launch override list
                            launch_overrides_temp = {}
                            table.insert(launch_overrides_temp, {name = app_titleid, driver = game_adr_bin_driver, bin = game_adr_exec_bin, apptitle = app_title, app_type = apptype})

                            for i, file in ipairs(launch_overrides_temp) do
                                table.insert(launch_overrides_table, file)
                            end
                        end
                        -- Save the renamed table for importing on restart
                        update_cached_table_launch_overrides()
                        showMenu = 20
                        menuY=3
                    else
                    end

                    -- Save the setting
                else
                end
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                if menuY > 0 then
                    menuY = menuY - 1
                    else
                    menuY=menuItems
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                if menuY < menuItems then
                    menuY = menuY + 1
                    else
                    menuY=0
                end
            elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
                if menuY == 1 then -- #1 Driver
                    if game_adr_bin_driver > 0 then
                        game_adr_bin_driver = game_adr_bin_driver - 1
                    else
                        game_adr_bin_driver = 3
                    end
                elseif menuY == 2 then -- #2 Execute bin
                    if game_adr_exec_bin > 0 then
                        game_adr_exec_bin = game_adr_exec_bin - 1
                    else
                        game_adr_exec_bin = 3
                    end
                else
                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                if menuY == 1 then -- #1 Driver
                    if game_adr_bin_driver < 3 then
                        game_adr_bin_driver = game_adr_bin_driver + 1
                    else
                        game_adr_bin_driver = 0
                    end

                elseif menuY == 2 then -- #2 Execute bin
                    if game_adr_exec_bin < 3 then
                        game_adr_exec_bin = game_adr_exec_bin + 1
                    else
                        game_adr_exec_bin = 0
                    end
                else
                end


            elseif Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP) then
                oldpad = pad
                GetInfoSelected()
                showMenu = 20
                menuY=3
            end
        end


-- END OF MENUS
    end

    
    -- Terminating rendering phase
    Graphics.termBlend()
    if showMenu == 1 then
        --Left Analog rotate preview box
        if mx < 64 then
            if prvRotY>-0.5 then
                prvRotY=prvRotY-0.02
            end
        elseif mx > 180 then
            if prvRotY<0.6 then
                prvRotY=prvRotY+0.02
            end
        end
    end
    if showMenu == 11 then
        --Scroll through ROM Browser
        if my < 64 then
            if delayButton < 0.5 then
                delayButton = 1
                i = i - 1
            end
        elseif my > 180 then
            if delayButton < 0.5 then
                delayButton = 1
                i = i + 1
            end
        end

    end
    --Controls Start
    if showMenu == 0 then
        --Navigation Left Analog
        if mx < 64 then
            if delayButton < 0.5 then
                delayButton = 1
                if setSounds == 1 then
                    Sound.play(click, NO_LOOP)
                end
                p = p - 1
                
                if p > 0 then
                    GetNameAndAppTypeSelected()
                end
                
                if (p <= master_index) then
                    master_index = p
                end
            end
        elseif mx > 180 then
            if delayButton < 0.5 then
                delayButton = 1
                if setSounds == 1 then
                    Sound.play(click, NO_LOOP)
                end
                p = p + 1
                
                if p <= curTotal then
                    GetNameAndAppTypeSelected()
                end
                
                if (p >= master_index) then
                    master_index = p
                end
            end
        end
        
        -- Navigation Buttons
        if (Controls.check(pad, SCE_CTRL_CROSS_MAP) and not Controls.check(oldpad, SCE_CTRL_CROSS_MAP)) then
            state = Keyboard.getState()
            messagestate = System.getMessageState() -- Check if message active - RetroFlow Adrenaline Launcher needs to be installed

            if state ~= RUNNING and messagestate ~= RUNNING then
                if gettingCovers == false and app_title~="-" then
                    FreeMemory()

                    -- Add to recently played if game is not hidden
                    -- if xCatLookup(showCat)[p].hidden == false then
                    --     AddtoRecentlyPlayed()
                    --     update_cached_table_recently_played_pre_launch()
                    -- end

                    -- Add to recently played
                    AddtoRecentlyPlayed()
                    update_cached_table_recently_played_pre_launch()

                    if showCat == 1 then
                        if string.match (games_table[p].game_path, "pspemu") then
                            -- Launch adrenaline
                            rom_location = tostring(games_table[p].game_path)
                            rom_title_id = tostring(games_table[p].name)
                            rom_filename = tostring(games_table[p].filename)
                            launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                        else
                            if games_table[p].app_type_default == 3 then
                                -- Launch PS1 retroarch
                                rom_location = (games_table[p].game_path) launch_retroarch(core.PS1)
                            else
                                -- Vita app
                                System.launchApp(games_table[p].name)
                            end
                        end

                    elseif showCat == 2 then
                        if string.match (homebrews_table[p].game_path, "pspemu") then
                            -- Launch adrenaline
                            rom_location = tostring(homebrews_table[p].game_path)
                            rom_title_id = tostring(homebrews_table[p].name)
                            rom_filename = tostring(homebrews_table[p].filename)
                            launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                        else
                            if homebrews_table[p].app_type_default == 3 then
                                -- Launch PS1 retroarch
                                rom_location = (homebrews_table[p].game_path) launch_retroarch(core.PS1)
                            else
                                -- Vita app
                                System.launchApp(homebrews_table[p].name)
                            end
                        end

                    elseif showCat == 3 then
                        if string.match (psp_table[p].game_path, "pspemu") then
                            -- Launch adrenaline
                            rom_location = tostring(psp_table[p].game_path)
                            rom_title_id = tostring(psp_table[p].name)
                            rom_filename = tostring(psp_table[p].filename)
                            launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                        else
                            if psp_table[p].app_type_default == 3 then
                                -- Launch PS1 retroarch
                                rom_location = (psp_table[p].game_path) launch_retroarch(core.PS1)
                            else
                                -- Vita app
                                System.launchApp(psp_table[p].name)
                            end
                        end

                    -- PS1 - Launch adrenaline or retroarch
                    elseif showCat == 4 then
                        if string.match (psx_table[p].game_path, "pspemu") then
                            -- Launch adrenaline
                            rom_location = tostring(psx_table[p].game_path)
                            rom_title_id = tostring(psx_table[p].name)
                            rom_filename = tostring(psx_table[p].filename)
                            launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                        else
                            if psx_table[p].app_type_default == 3 then
                                -- Launch PS1 retroarch
                                rom_location = (psx_table[p].game_path) launch_retroarch(core.PS1)
                            else
                                -- Vita app
                                System.launchApp(psx_table[p].name)
                            end
                        end

                    -- Start Retro    
                    elseif showCat == 5 then rom_location = (n64_table[p].game_path) launch_DaedalusX64()
                    elseif showCat == 6 then rom_location = (snes_table[p].game_path) launch_retroarch(core.SNES)
                    elseif showCat == 7 then rom_location = (nes_table[p].game_path) launch_retroarch(core.NES)
                    elseif showCat == 8 then rom_location = (gba_table[p].game_path) launch_retroarch(core.GBA)
                    elseif showCat == 9 then rom_location = (gbc_table[p].game_path) launch_retroarch(core.GBC)
                    elseif showCat == 10 then rom_location = (gb_table[p].game_path) launch_retroarch(core.GB)
                    elseif showCat == 11 then rom_location = (dreamcast_table[p].game_path) launch_Flycast()
                    elseif showCat == 12 then rom_location = (sega_cd_table[p].game_path) launch_retroarch(core.SEGA_CD) 
                    elseif showCat == 13 then rom_location = (s32x_table[p].game_path) launch_retroarch(core.s32X) 
                    elseif showCat == 14 then rom_location = (md_table[p].game_path) launch_retroarch(core.MD)
                    elseif showCat == 15 then rom_location = (sms_table[p].game_path) launch_retroarch(core.SMS)
                    elseif showCat == 16 then rom_location = (gg_table[p].game_path) launch_retroarch(core.GG)
                    elseif showCat == 17 then rom_location = (tg16_table[p].game_path) launch_retroarch(core.TG16)
                    elseif showCat == 18 then rom_location = (tgcd_table[p].game_path) launch_retroarch(core.TGCD)
                    elseif showCat == 19 then rom_location = (pce_table[p].game_path) launch_retroarch(core.PCE)
                    elseif showCat == 20 then rom_location = (pcecd_table[p].game_path) launch_retroarch(core.PCECD)
                    elseif showCat == 21 then rom_location = (amiga_table[p].game_path) launch_retroarch(core.AMIGA)
                    elseif showCat == 22 then rom_location = (c64_table[p].game_path) launch_retroarch(core.C64)
                    elseif showCat == 23 then rom_location = (wswan_col_table[p].game_path) launch_retroarch(core.WSWAN_COL)
                    elseif showCat == 24 then rom_location = (wswan_table[p].game_path) launch_retroarch(core.WSWAN)
                    elseif showCat == 25 then rom_location = (msx2_table[p].game_path) launch_retroarch(core.MSX2)
                    elseif showCat == 26 then rom_location = (msx1_table[p].game_path) launch_retroarch(core.MSX1)
                    elseif showCat == 27 then rom_location = (zxs_table[p].game_path) launch_retroarch(core.ZXS)
                    elseif showCat == 28 then rom_location = (atari_7800_table[p].game_path) launch_retroarch(core.ATARI_7800)
                    elseif showCat == 29 then rom_location = (atari_5200_table[p].game_path) launch_retroarch(core.ATARI_5200)
                    elseif showCat == 30 then rom_location = (atari_2600_table[p].game_path) launch_retroarch(core.ATARI_2600)
                    elseif showCat == 31 then rom_location = (atari_lynx_table[p].game_path) launch_retroarch(core.ATARI_LYNX)
                    elseif showCat == 32 then rom_location = (colecovision_table[p].game_path) launch_retroarch(core.COLECOVISION)
                    elseif showCat == 33 then rom_location = (vectrex_table[p].game_path) launch_retroarch(core.VECTREX)
                    elseif showCat == 34 then rom_location = (fba_table[p].game_path) launch_retroarch(core.FBA)
                    elseif showCat == 35 then rom_location = (mame_2003_plus_table[p].game_path) launch_retroarch(core.MAME_2003_PLUS)
                    elseif showCat == 36 then rom_location = (mame_2000_table[p].game_path) launch_retroarch(core.MAME_2000)
                    elseif showCat == 37 then rom_location = (neogeo_table[p].game_path) launch_retroarch(core.NEOGEO)
                    elseif showCat == 38 then rom_location = (ngpc_table[p].game_path) launch_retroarch(core.NGPC)
                    elseif showCat == 39 then rom_title_id = tostring(psm_table[p].name) launch_psmobile(rom_title_id)

                    elseif showCat == 40 then
                        if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                            if string.match (fav_count[p].game_path, "pspemu") then
                                -- Launch adrenaline
                                rom_location = tostring(fav_count[p].game_path)
                                rom_title_id = tostring(fav_count[p].name)
                                rom_filename = tostring(fav_count[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                if fav_count[p].app_type_default == 3 then
                                    -- Launch PS1 retroarch
                                    rom_location = (fav_count[p].game_path) launch_retroarch(core.PS1)
                                else
                                    -- Vita app
                                    System.launchApp(fav_count[p].name)
                                end
                            end

                        -- Start Retro    
                        elseif apptype == 5 then rom_location = (fav_count[p].game_path) launch_DaedalusX64()
                        elseif apptype == 6 then rom_location = (fav_count[p].game_path) launch_retroarch(core.SNES)
                        elseif apptype == 7 then rom_location = (fav_count[p].game_path) launch_retroarch(core.NES)
                        elseif apptype == 8 then rom_location = (fav_count[p].game_path) launch_retroarch(core.GBA)
                        elseif apptype == 9 then rom_location = (fav_count[p].game_path) launch_retroarch(core.GBC)
                        elseif apptype == 10 then rom_location = (fav_count[p].game_path) launch_retroarch(core.GB)
                        elseif apptype == 11 then rom_location = (fav_count[p].game_path) launch_Flycast()
                        elseif apptype == 12 then rom_location = (fav_count[p].game_path) launch_retroarch(core.SEGA_CD) 
                        elseif apptype == 13 then rom_location = (fav_count[p].game_path) launch_retroarch(core.s32X) 
                        elseif apptype == 14 then rom_location = (fav_count[p].game_path) launch_retroarch(core.MD)
                        elseif apptype == 15 then rom_location = (fav_count[p].game_path) launch_retroarch(core.SMS)
                        elseif apptype == 16 then rom_location = (fav_count[p].game_path) launch_retroarch(core.GG)
                        elseif apptype == 17 then rom_location = (fav_count[p].game_path) launch_retroarch(core.TG16)
                        elseif apptype == 18 then rom_location = (fav_count[p].game_path) launch_retroarch(core.TGCD)
                        elseif apptype == 19 then rom_location = (fav_count[p].game_path) launch_retroarch(core.PCE)
                        elseif apptype == 20 then rom_location = (fav_count[p].game_path) launch_retroarch(core.PCECD)
                        elseif apptype == 21 then rom_location = (fav_count[p].game_path) launch_retroarch(core.AMIGA)
                        elseif apptype == 22 then rom_location = (fav_count[p].game_path) launch_retroarch(core.C64)
                        elseif apptype == 23 then rom_location = (fav_count[p].game_path) launch_retroarch(core.WSWAN_COL)
                        elseif apptype == 24 then rom_location = (fav_count[p].game_path) launch_retroarch(core.WSWAN)
                        elseif apptype == 25 then rom_location = (fav_count[p].game_path) launch_retroarch(core.MSX2)
                        elseif apptype == 26 then rom_location = (fav_count[p].game_path) launch_retroarch(core.MSX1)
                        elseif apptype == 27 then rom_location = (fav_count[p].game_path) launch_retroarch(core.ZXS)
                        elseif apptype == 28 then rom_location = (fav_count[p].game_path) launch_retroarch(core.ATARI_7800)
                        elseif apptype == 29 then rom_location = (fav_count[p].game_path) launch_retroarch(core.ATARI_5200)
                        elseif apptype == 30 then rom_location = (fav_count[p].game_path) launch_retroarch(core.ATARI_2600)
                        elseif apptype == 31 then rom_location = (fav_count[p].game_path) launch_retroarch(core.ATARI_LYNX)
                        elseif apptype == 32 then rom_location = (fav_count[p].game_path) launch_retroarch(core.COLECOVISION)
                        elseif apptype == 33 then rom_location = (fav_count[p].game_path) launch_retroarch(core.VECTREX)
                        elseif apptype == 34 then rom_location = (fav_count[p].game_path) launch_retroarch(core.FBA)
                        elseif apptype == 35 then rom_location = (fav_count[p].game_path) launch_retroarch(core.MAME_2003_PLUS)
                        elseif apptype == 36 then rom_location = (fav_count[p].game_path) launch_retroarch(core.MAME_2000)
                        elseif apptype == 37 then rom_location = (fav_count[p].game_path) launch_retroarch(core.NEOGEO)
                        elseif apptype == 38 then rom_location = (fav_count[p].game_path) launch_retroarch(core.NGPC)
                        elseif apptype == 39 then rom_title_id = tostring(fav_count[p].name) launch_psmobile(rom_title_id)
                        else
                            -- Homebrew
                            if string.match (fav_count[p].game_path, "pspemu") then
                                rom_location = (fav_count[p].game_path)
                                rom_title_id = (fav_count[p].name)
                                rom_filename = (fav_count[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                System.launchApp(fav_count[p].name)
                            end

                            appdir=working_dir .. "/" .. fav_count[p].name
                        end

                    elseif showCat == 41 then
                        if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                            if string.match (recently_played_table[p].game_path, "pspemu") then
                                 -- Launch adrenaline
                                rom_location = tostring(recently_played_table[p].game_path)
                                rom_title_id = tostring(recently_played_table[p].name)
                                rom_filename = tostring(recently_played_table[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                if recently_played_table[p].app_type_default == 3 then
                                    -- Launch PS1 retroarch
                                    rom_location = (recently_played_table[p].game_path) launch_retroarch(core.PS1)
                                else
                                    -- Vita app
                                    System.launchApp(recently_played_table[p].name)
                                end
                            end

                        -- Start Retro    
                        elseif apptype == 5 then rom_location = (recently_played_table[p].game_path) launch_DaedalusX64()
                        elseif apptype == 6 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.SNES)
                        elseif apptype == 7 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.NES)
                        elseif apptype == 8 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.GBA)
                        elseif apptype == 9 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.GBC)
                        elseif apptype == 10 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.GB)
                        elseif apptype == 11 then rom_location = (recently_played_table[p].game_path) launch_Flycast()
                        elseif apptype == 12 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.SEGA_CD) 
                        elseif apptype == 13 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.s32X) 
                        elseif apptype == 14 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.MD)
                        elseif apptype == 15 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.SMS)
                        elseif apptype == 16 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.GG)
                        elseif apptype == 17 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.TG16)
                        elseif apptype == 18 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.TGCD)
                        elseif apptype == 19 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.PCE)
                        elseif apptype == 20 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.PCECD)
                        elseif apptype == 21 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.AMIGA)
                        elseif apptype == 22 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.C64)
                        elseif apptype == 23 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.WSWAN_COL)
                        elseif apptype == 24 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.WSWAN)
                        elseif apptype == 25 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.MSX2)
                        elseif apptype == 26 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.MSX1)
                        elseif apptype == 27 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.ZXS)
                        elseif apptype == 28 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.ATARI_7800)
                        elseif apptype == 29 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.ATARI_5200)
                        elseif apptype == 30 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.ATARI_2600)
                        elseif apptype == 31 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.ATARI_LYNX)
                        elseif apptype == 32 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.COLECOVISION)
                        elseif apptype == 33 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.VECTREX)
                        elseif apptype == 34 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.FBA)
                        elseif apptype == 35 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.MAME_2003_PLUS)
                        elseif apptype == 36 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.MAME_2000)
                        elseif apptype == 37 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.NEOGEO)
                        elseif apptype == 38 then rom_location = (recently_played_table[p].game_path) launch_retroarch(core.NGPC)
                        elseif apptype == 39 then rom_title_id = tostring(recently_played_table[p].name) launch_psmobile(rom_title_id)
                        else
                            -- Homebrew
                            if string.match (recently_played_table[p].game_path, "pspemu") then
                                rom_location = (recently_played_table[p].game_path)
                                rom_title_id = (recently_played_table[p].name)
                                rom_filename = (recently_played_table[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                System.launchApp(recently_played_table[p].name)
                            end

                            appdir=working_dir .. "/" .. recently_played_table[p].name
                        end

                    
                    elseif showCat == 42 then
                        if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                            if string.match (search_results_table[p].game_path, "pspemu") then
                                 -- Launch adrenaline
                                rom_location = tostring(search_results_table[p].game_path)
                                rom_title_id = tostring(search_results_table[p].name)
                                rom_filename = tostring(search_results_table[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                if search_results_table[p].app_type_default == 3 then
                                    -- Launch PS1 retroarch
                                    rom_location = (search_results_table[p].game_path) launch_retroarch(core.PS1)
                                else
                                    -- Vita app
                                    System.launchApp(search_results_table[p].name)
                                end
                            end

                        -- Start Retro    
                        elseif apptype == 5 then rom_location = (search_results_table[p].game_path) launch_DaedalusX64()
                        elseif apptype == 6 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.SNES)
                        elseif apptype == 7 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.NES)
                        elseif apptype == 8 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.GBA)
                        elseif apptype == 9 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.GBC)
                        elseif apptype == 10 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.GB)
                        elseif apptype == 11 then rom_location = (search_results_table[p].game_path) launch_Flycast()
                        elseif apptype == 12 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.SEGA_CD) 
                        elseif apptype == 13 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.s32X) 
                        elseif apptype == 14 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.MD)
                        elseif apptype == 15 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.SMS)
                        elseif apptype == 16 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.GG)
                        elseif apptype == 17 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.TG16)
                        elseif apptype == 18 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.TGCD)
                        elseif apptype == 19 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.PCE)
                        elseif apptype == 20 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.PCECD)
                        elseif apptype == 21 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.AMIGA)
                        elseif apptype == 22 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.C64)
                        elseif apptype == 23 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.WSWAN_COL)
                        elseif apptype == 24 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.WSWAN)
                        elseif apptype == 25 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.MSX2)
                        elseif apptype == 26 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.MSX1)
                        elseif apptype == 27 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.ZXS)
                        elseif apptype == 28 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.ATARI_7800)
                        elseif apptype == 29 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.ATARI_5200)
                        elseif apptype == 30 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.ATARI_2600)
                        elseif apptype == 31 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.ATARI_LYNX)
                        elseif apptype == 32 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.COLECOVISION)
                        elseif apptype == 33 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.VECTREX)
                        elseif apptype == 34 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.FBA)
                        elseif apptype == 35 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.MAME_2003_PLUS)
                        elseif apptype == 36 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.MAME_2000)
                        elseif apptype == 37 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.NEOGEO)
                        elseif apptype == 38 then rom_location = (search_results_table[p].game_path) launch_retroarch(core.NGPC)
                        elseif apptype == 39 then rom_title_id = tostring(search_results_table[p].name) launch_psmobile(rom_title_id)
                        else
                            -- Homebrew
                            if string.match (search_results_table[p].game_path, "pspemu") then
                                rom_location = (search_results_table[p].game_path)
                                rom_title_id = (search_results_table[p].name)
                                rom_filename = (search_results_table[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                System.launchApp(search_results_table[p].name)
                            end

                            appdir=working_dir .. "/" .. search_results_table[p].name
                        end

                    -- End Retro 
                    else

                        if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                            if string.match (files_table[p].game_path, "pspemu") then
                                 -- Launch adrenaline
                                rom_location = tostring(files_table[p].game_path)
                                rom_title_id = tostring(files_table[p].name)
                                rom_filename = tostring(files_table[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                if files_table[p].app_type_default == 3 then
                                    -- Launch PS1 retroarch
                                    rom_location = (files_table[p].game_path) launch_retroarch(core.PS1)
                                else
                                    -- Vita app
                                    System.launchApp(files_table[p].name)
                                end
                            end

                        -- Start Retro    
                        elseif apptype == 5 then rom_location = (files_table[p].game_path) launch_DaedalusX64()
                        elseif apptype == 6 then rom_location = (files_table[p].game_path) launch_retroarch(core.SNES)
                        elseif apptype == 7 then rom_location = (files_table[p].game_path) launch_retroarch(core.NES)
                        elseif apptype == 8 then rom_location = (files_table[p].game_path) launch_retroarch(core.GBA)
                        elseif apptype == 9 then rom_location = (files_table[p].game_path) launch_retroarch(core.GBC)
                        elseif apptype == 10 then rom_location = (files_table[p].game_path) launch_retroarch(core.GB)
                        elseif apptype == 11 then rom_location = (files_table[p].game_path) launch_Flycast()
                        elseif apptype == 12 then rom_location = (files_table[p].game_path) launch_retroarch(core.SEGA_CD) 
                        elseif apptype == 13 then rom_location = (files_table[p].game_path) launch_retroarch(core.s32X) 
                        elseif apptype == 14 then rom_location = (files_table[p].game_path) launch_retroarch(core.MD)
                        elseif apptype == 15 then rom_location = (files_table[p].game_path) launch_retroarch(core.SMS)
                        elseif apptype == 16 then rom_location = (files_table[p].game_path) launch_retroarch(core.GG)
                        elseif apptype == 17 then rom_location = (files_table[p].game_path) launch_retroarch(core.TG16)
                        elseif apptype == 18 then rom_location = (files_table[p].game_path) launch_retroarch(core.TGCD)
                        elseif apptype == 19 then rom_location = (files_table[p].game_path) launch_retroarch(core.PCE)
                        elseif apptype == 20 then rom_location = (files_table[p].game_path) launch_retroarch(core.PCECD)
                        elseif apptype == 21 then rom_location = (files_table[p].game_path) launch_retroarch(core.AMIGA)
                        elseif apptype == 22 then rom_location = (files_table[p].game_path) launch_retroarch(core.C64)
                        elseif apptype == 23 then rom_location = (files_table[p].game_path) launch_retroarch(core.WSWAN_COL)
                        elseif apptype == 24 then rom_location = (files_table[p].game_path) launch_retroarch(core.WSWAN)
                        elseif apptype == 25 then rom_location = (files_table[p].game_path) launch_retroarch(core.MSX2)
                        elseif apptype == 26 then rom_location = (files_table[p].game_path) launch_retroarch(core.MSX1)
                        elseif apptype == 27 then rom_location = (files_table[p].game_path) launch_retroarch(core.ZXS)
                        elseif apptype == 28 then rom_location = (files_table[p].game_path) launch_retroarch(core.ATARI_7800)
                        elseif apptype == 29 then rom_location = (files_table[p].game_path) launch_retroarch(core.ATARI_5200)
                        elseif apptype == 30 then rom_location = (files_table[p].game_path) launch_retroarch(core.ATARI_2600)
                        elseif apptype == 31 then rom_location = (files_table[p].game_path) launch_retroarch(core.ATARI_LYNX)
                        elseif apptype == 32 then rom_location = (files_table[p].game_path) launch_retroarch(core.COLECOVISION)
                        elseif apptype == 33 then rom_location = (files_table[p].game_path) launch_retroarch(core.VECTREX)
                        elseif apptype == 34 then rom_location = (files_table[p].game_path) launch_retroarch(core.FBA)
                        elseif apptype == 35 then rom_location = (files_table[p].game_path) launch_retroarch(core.MAME_2003_PLUS)
                        elseif apptype == 36 then rom_location = (files_table[p].game_path) launch_retroarch(core.MAME_2000)
                        elseif apptype == 37 then rom_location = (files_table[p].game_path) launch_retroarch(core.NEOGEO)
                        elseif apptype == 38 then rom_location = (files_table[p].game_path) launch_retroarch(core.NGPC)
                        elseif apptype == 39 then rom_title_id = tostring(files_table[p].name) launch_psmobile(rom_title_id)
                        else
                            -- Homebrew
                            if string.match (files_table[p].game_path, "pspemu") then
                                rom_location = (files_table[p].game_path)
                                rom_title_id = (files_table[p].name)
                                rom_filename = (files_table[p].filename)
                                launch_Adrenaline(rom_location, rom_title_id, rom_filename)
                            else
                                System.launchApp(files_table[p].name)
                            end

                            appdir=working_dir .. "/" .. files_table[p].name
                        end
                    end
                    System.exit()
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                if showMenu == 0 and app_title~="-" then
                    prvRotY = 0
                    GetInfoSelected() -- Credit to BlackSheepBoy69 - get all info when triangle pressed
                    showMenu = 1
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                if showMenu == 0 then
                    showMenu = 2
                    menuY = 0
                end
            else
            end
        -- Select button - Games screen
        elseif (Controls.check(pad, SCE_CTRL_SELECT) and not Controls.check(oldpad, SCE_CTRL_SELECT)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                -- Search
                if hasTyped==false then
                    Keyboard.start(tostring(lang_lines.Search), "", 512, TYPE_LATIN, MODE_TEXT)
                    hasTyped=true
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_SQUARE) and not Controls.check(oldpad, SCE_CTRL_SQUARE)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                
                
                if (Controls.check(pad, SCE_CTRL_DOWN)) then

                   -- CATEGORY - Move Backwards

                    if showCat >= 1 then
                        showCat = showCat - 1
                    elseif showCat == 0 then
                        showCat = count_of_categories
                    end

                    -- Start skip empty categories

                    if showCat == 42 then
                        curTotal = #search_results_table   
                        if #search_results_table == 0 then 
                            showCat = 41
                        end
                    end

                    if showCat == 41 then 
                        curTotal = #recently_played_table
                        if #recently_played_table == 0 then 
                            showCat = 40
                        end
                    end

                    if showCat == 40 then
                        -- count favorites
                        create_fav_count_table(files_table)

                        curTotal = #fav_count
                        if #fav_count == 0 then showCat = 39
                        end
                    end

                    if showCat == 39 then curTotal =    #psm_table              if #psm_table == 0 then             showCat = 38 end end
                    if showCat == 38 then curTotal =    #ngpc_table             if #ngpc_table == 0 then            showCat = 37 end end
                    if showCat == 37 then curTotal =    #neogeo_table           if #neogeo_table == 0 then          showCat = 36 end end
                    if showCat == 36 then curTotal =    #mame_2000_table        if #mame_2000_table == 0 then       showCat = 35 end end
                    if showCat == 35 then curTotal =    #mame_2003_plus_table   if #mame_2003_plus_table == 0 then  showCat = 34 end end
                    if showCat == 34 then curTotal =    #fba_table              if #fba_table == 0 then             showCat = 33 end end
                    if showCat == 33 then curTotal =    #vectrex_table          if #vectrex_table == 0 then         showCat = 32 end end
                    if showCat == 32 then curTotal =    #colecovision_table     if #colecovision_table == 0 then    showCat = 31 end end
                    if showCat == 31 then curTotal =    #atari_lynx_table       if #atari_lynx_table == 0 then      showCat = 30 end end
                    if showCat == 30 then curTotal =    #atari_2600_table       if #atari_2600_table == 0 then      showCat = 29 end end
                    if showCat == 29 then curTotal =    #atari_5200_table       if #atari_5200_table == 0 then      showCat = 28 end end
                    if showCat == 28 then curTotal =    #atari_7800_table       if #atari_7800_table == 0 then      showCat = 27 end end
                    if showCat == 27 then curTotal =    #zxs_table              if #zxs_table == 0 then             showCat = 26 end end
                    if showCat == 26 then curTotal =    #msx1_table             if #msx1_table == 0 then            showCat = 25 end end
                    if showCat == 25 then curTotal =    #msx2_table             if #msx2_table == 0 then            showCat = 24 end end
                    if showCat == 24 then curTotal =    #wswan_table            if #wswan_table == 0 then           showCat = 23 end end
                    if showCat == 23 then curTotal =    #wswan_col_table        if #wswan_col_table == 0 then       showCat = 22 end end
                    if showCat == 22 then curTotal =    #c64_table              if #c64_table == 0 then             showCat = 21 end end
                    if showCat == 21 then curTotal =    #amiga_table            if #amiga_table == 0 then           showCat = 20 end end
                    if showCat == 20 then curTotal =    #pcecd_table            if #pcecd_table == 0 then           showCat = 19 end end
                    if showCat == 19 then curTotal =    #pce_table              if #pce_table == 0 then             showCat = 18 end end
                    if showCat == 18 then curTotal =    #tgcd_table             if #tgcd_table == 0 then            showCat = 17 end end
                    if showCat == 17 then curTotal =    #tg16_table             if #tg16_table == 0 then            showCat = 16 end end
                    if showCat == 16 then curTotal =    #gg_table               if #gg_table == 0 then              showCat = 15 end end
                    if showCat == 15 then curTotal =    #sms_table              if #sms_table == 0 then             showCat = 14 end end
                    if showCat == 14 then curTotal =    #md_table               if #md_table == 0 then              showCat = 13 end end
                    if showCat == 13 then curTotal =    #s32x_table             if #s32x_table == 0 then            showCat = 12 end end
                    if showCat == 12 then curTotal =    #sega_cd_table          if #sega_cd_table == 0 then         showCat = 11 end end
                    if showCat == 11 then curTotal =    #dreamcast_table        if #dreamcast_table == 0 then       showCat = 10 end end
                    if showCat == 10 then curTotal =    #gb_table               if #gb_table == 0 then              showCat = 9 end end
                    if showCat == 9 then curTotal =     #gbc_table              if #gbc_table == 0 then             showCat = 8 end end
                    if showCat == 8 then curTotal =     #gba_table              if #gba_table == 0 then             showCat = 7 end end
                    if showCat == 7 then curTotal =     #nes_table              if #nes_table == 0 then             showCat = 6 end end
                    if showCat == 6 then curTotal =     #snes_table             if #snes_table == 0 then            showCat = 5 end end
                    if showCat == 5 then curTotal =     #n64_table              if #n64_table == 0 then             showCat = 4 end end
                    if showCat == 4 then curTotal =     #psx_table              if #psx_table == 0 then             showCat = 3 end end
                    if showCat == 3 then curTotal =     #psp_table              if #psp_table == 0 then             showCat = 2 end end

                    
                    -- Skip Homebrew category if disabled
                    if showCat == 2 and showHomebrews==0 then -- HB is off
                        showCat = 1
                    end

                    -- Skip All category if disabled
                    if showCat == 0 and showAll==0 then -- All is off

                        -- Skip Recent category if disabled
                        if showRecentlyPlayed == 0 then
                            showCat = 40
                        else
                            showCat = 41
                        end

                    end

                    hideBoxes = 0.8 -- used to be 8
                    p = 1
                    master_index = p
                    startCovers = false
                    GetInfoSelected()
                    FreeIcons()


                else

                    -- CATEGORY - Move Forwards

                    if showCat < count_of_categories then
                        -- Skip All category if disabled
                        if showCat==0 and showAll==0 then 
                            showCat = 1
                        -- Skip Homebrews category if disabled
                        elseif showCat==1 and showHomebrews==0 then
                            showCat = 3
                        else
                            showCat = showCat + 1
                        end

                    -- Commented out as all category skipping wasn't being honored after searching 
                    -- else
                    --     showCat = 0 
                    end

                    -- Start skip empty categories
                    if showCat == 3 then curTotal =     #psp_table              if #psp_table == 0 then             showCat = 4 end end
                    if showCat == 4 then curTotal =     #psx_table              if #psx_table == 0 then             showCat = 5 end end
                    if showCat == 5 then curTotal =     #n64_table              if #n64_table == 0 then             showCat = 6 end end
                    if showCat == 6 then curTotal =     #snes_table             if #snes_table == 0 then            showCat = 7 end end
                    if showCat == 7 then curTotal =     #nes_table              if #nes_table == 0 then             showCat = 8 end end
                    if showCat == 8 then curTotal =     #gba_table              if #gba_table == 0 then             showCat = 9 end end
                    if showCat == 9 then curTotal =     #gbc_table              if #gbc_table == 0 then             showCat = 10 end end
                    if showCat == 10 then curTotal =    #gb_table               if #gb_table == 0 then              showCat = 11 end end
                    if showCat == 11 then curTotal =    #dreamcast_table        if #dreamcast_table == 0 then       showCat = 12 end end
                    if showCat == 12 then curTotal =    #sega_cd_table          if #sega_cd_table == 0 then         showCat = 13 end end
                    if showCat == 13 then curTotal =    #s32x_table             if #s32x_table == 0 then            showCat = 14 end end
                    if showCat == 14 then curTotal =    #md_table               if #md_table == 0 then              showCat = 15 end end
                    if showCat == 15 then curTotal =    #sms_table              if #sms_table == 0 then             showCat = 16 end end
                    if showCat == 16 then curTotal =    #gg_table               if #gg_table == 0 then              showCat = 17 end end
                    if showCat == 17 then curTotal =    #tg16_table             if #tg16_table == 0 then            showCat = 18 end end
                    if showCat == 18 then curTotal =    #tgcd_table             if #tgcd_table == 0 then            showCat = 19 end end
                    if showCat == 19 then curTotal =    #pce_table              if #pce_table == 0 then             showCat = 20 end end
                    if showCat == 20 then curTotal =    #pcecd_table            if #pcecd_table == 0 then           showCat = 21 end end
                    if showCat == 21 then curTotal =    #amiga_table            if #amiga_table == 0 then           showCat = 22 end end
                    if showCat == 22 then curTotal =    #c64_table              if #c64_table == 0 then             showCat = 23 end end
                    if showCat == 23 then curTotal =    #wswan_col_table        if #wswan_col_table == 0 then       showCat = 24 end end
                    if showCat == 24 then curTotal =    #wswan_table            if #wswan_table == 0 then           showCat = 25 end end
                    if showCat == 25 then curTotal =    #msx2_table             if #msx2_table == 0 then            showCat = 26 end end
                    if showCat == 26 then curTotal =    #msx1_table             if #msx1_table == 0 then            showCat = 27 end end
                    if showCat == 27 then curTotal =    #zxs_table              if #zxs_table == 0 then             showCat = 28 end end
                    if showCat == 28 then curTotal =    #atari_7800_table       if #atari_7800_table == 0 then      showCat = 29 end end
                    if showCat == 29 then curTotal =    #atari_5200_table       if #atari_5200_table == 0 then      showCat = 30 end end
                    if showCat == 30 then curTotal =    #atari_2600_table       if #atari_2600_table == 0 then      showCat = 31 end end
                    if showCat == 31 then curTotal =    #atari_lynx_table       if #atari_lynx_table == 0 then      showCat = 32 end end
                    if showCat == 32 then curTotal =    #colecovision_table     if #colecovision_table == 0 then    showCat = 33 end end
                    if showCat == 33 then curTotal =    #vectrex_table          if #vectrex_table == 0 then         showCat = 34 end end
                    if showCat == 34 then curTotal =    #fba_table              if #fba_table == 0 then             showCat = 35 end end
                    if showCat == 35 then curTotal =    #mame_2003_plus_table   if #mame_2003_plus_table == 0 then  showCat = 36 end end
                    if showCat == 36 then curTotal =    #mame_2000_table        if #mame_2000_table == 0 then       showCat = 37 end end
                    if showCat == 37 then curTotal =    #neogeo_table           if #neogeo_table == 0 then          showCat = 38 end end
                    if showCat == 38 then curTotal =    #ngpc_table             if #ngpc_table == 0 then            showCat = 39 end end
                    if showCat == 39 then curTotal =    #psm_table              if #psm_table == 0 then             showCat = 40 end end
                    if showCat == 40 then
                        -- count favorites
                        create_fav_count_table(files_table)

                        curTotal = #fav_count
                        if #fav_count == 0 then showCat = 41
                        end
                    end
                    if showCat == 41 then 
                        curTotal = #recently_played_table
                        if #recently_played_table == 0 then showCat = 42
                        end
                    end
                    
                    if showCat == 42 then
                        curTotal = #search_results_table   
                        if #search_results_table == 0 and showAll==1 then 
                            showCat = 0
                        elseif #search_results_table == 0 and showAll==0 then
                            showCat = 1
                        elseif #search_results_table > 0 and showAll==1 then
                            showCat = 0
                        elseif #search_results_table > 0 and showAll==0 then
                            showCat = 1
                        else
                            showCat = 0
                        end
                    end

                    hideBoxes = 0.8 -- used to be 8
                    p = 1
                    master_index = p
                    startCovers = false
                    GetInfoSelected()
                    FreeIcons()
                end


            else
            end
        elseif (Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP)) then
            -- VIEW
            
            state = Keyboard.getState()
            if state ~= RUNNING then
                -- don't change view if cancel search
                if showView < 4 then
                    showView = showView + 1
                else
                    showView = 0
                end
                menuY = 0
                startCovers = false

                --Save settings
                SaveSettings()
            else
            end

        elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                if setSounds == 1 then
                    Sound.play(click, NO_LOOP)
                end
                p = p - 1
                
                if p > 0 then
                    GetNameAndAppTypeSelected()
                end
                
                if (p <= master_index) then
                    master_index = p
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                if setSounds == 1 then
                    Sound.play(click, NO_LOOP)
                end
                p = p + 1
                
                if p <= curTotal then
                    GetNameAndAppTypeSelected()
                end
                
                if (p >= master_index) then
                    master_index = p
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_LTRIGGER)) and not (Controls.check(oldpad, SCE_CTRL_LTRIGGER)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                if setSounds == 1 then
                    Sound.play(click, NO_LOOP)
                end


                    -- Alphabet skip - Backwards: While holding right
                    if (Controls.check(pad, SCE_CTRL_DOWN)) then   
                        
                        -- Original game - Get first character
                        start_letter_backwards = string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1))
                        
                        -- If less than 5 and not on the first game, move to first position
                        -- if p <= 5 then
                        --     p = 1
                        -- end

                        -- Keep moving until the first letter no longer matches the first letter of the Original game
                        while string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1)) == start_letter_backwards do
                            
                            -- If we're on the first game, move to the last
                            if p == 1 then
                                p = #xCatLookup(showCat)
                                master_index = p
                            else
                                p = p - 1
                            end

                        end

                        -- We are now at the last game in the character set eg, "Azz", we need to move futher back again to the first
                        last_game_in_char_set = string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1))

                        -- Keep moving backwards until the first letter no longer matches the last game in the character set, then move forward 1 to reach the first in the character set
                        while string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1)) == last_game_in_char_set and p >= 2 do
                            p = p - 1
                        end

                        -- If it's a number, go to the first game, otherwise move forwards one to get to the first game in the character set 
                        if string.match (last_game_in_char_set, "%d") then
                            p = 1
                            master_index = p
                        else
                            if p ~= 1 then
                                p = p + 1
                            end
                        end

                    else
                        p = p - 5
                    end

                if p > 0 then
                    GetNameAndAppTypeSelected()
                end
                
                if (p <= master_index) then
                    master_index = p
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_RTRIGGER)) and not (Controls.check(oldpad, SCE_CTRL_RTRIGGER)) then
            state = Keyboard.getState()
            if state ~= RUNNING then
                if setSounds == 1 then
                    Sound.play(click, NO_LOOP)
                end

                    -- Alphabet skip - Forwards: While holding right
                    if (Controls.check(pad, SCE_CTRL_DOWN)) then

                        -- Original game - Get first character
                        start_letter_forward = string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1))

                        if string.match(start_letter_forward, "%d") then
                            
                            -- If first character is a number - Move to first letter
                            while string.match(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1), "%d") do
                                p = p + 1
                            end

                        else
                            
                            -- If first character is a letter - Keep moving until the first letter no longer matches the first letter of the Original game
                            if string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1)) ~= nil then
                                while string.upper(string.sub(xCatLookup(showCat)[p].apptitle, 1, 1)) == start_letter_forward and p < #xCatLookup(showCat) do
                                    p = p + 1
                                end
                            end

                        end

                        -- If reached then end - Loop back to first game
                        if p == #xCatLookup(showCat) then
                            p = 1
                            master_index = p
                        end

                    else
                    p = p + 5
                    end
                
                if p <= curTotal then
                    GetNameAndAppTypeSelected()
                end
                
                if (p >= master_index) then
                    master_index = p
                end
            else
            end
        elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
            state = Keyboard.getState()
            if state ~= RUNNING then

                -- Press Up to skip to favourites

                -- Check if there are favourites first
                create_fav_count_table(files_table)

                -- Favourites found
                if #fav_count > 0 then
                    -- Skip to favorites
                    if showCat == 40 then
                    else
                        showCat = 40
                        p = 1
                        master_index = p
                        GetNameAndAppTypeSelected()
                    end
                else
                -- No favourites, do nothing
                end

            else
            end
        end
        
        -- Touch Input
        if x1 ~= nil then
            if touchdown == 0 and delayTouch < 0.5 then
                touchdown = 1
                xstart = x1
                delayTouch = 5
            end
            if touchdown > 0 and delayTouch > 0.5 then
                if x1 > xstart + 60 then
                    touchdown = 2
                    xstart = x1
                    p = p - 1
                    if p > 0 then
                        GetNameAndAppTypeSelected()
                    end
                    if (p <= master_index) then
                        master_index = p
                    end
                elseif x1 < xstart - 60 then
                    touchdown = 2
                    xstart = x1
                    p = p + 1
                    if p <= curTotal then
                        GetNameAndAppTypeSelected()
                    end
                    if (p >= master_index) then
                        master_index = p
                    end
                
                end
            end
        end
    elseif showMenu > 0 then
        if (Controls.check(pad, SCE_CTRL_CIRCLE_MAP) and not Controls.check(oldpad, SCE_CTRL_CIRCLE_MAP)) then
            status = System.getMessageState()
            if status ~= RUNNING then

                if showMenu == 3 then -- Categories
                    showMenu = 2
                    menuY = 1
                elseif showMenu == 4 then -- Theme
                    showMenu = 2
                    menuY = 2
                elseif showMenu == 5 then -- Artwork
                    showMenu = 2
                    menuY = 4
                elseif showMenu == 6 then -- Scan Settings
                    showMenu = 2
                    menuY = 5
                elseif showMenu == 7 then -- About
                    showMenu = 2
                    menuY = 0
                elseif showMenu == 8 then -- Game directories
                    showMenu = 6 -- Scan Settings
                    menuY = 1
                elseif showMenu == 9 then -- Rom browser partitions
                    showMenu = 8 -- Game directories
                    menuY = 2
                elseif showMenu == 10 then -- Rom browser partitions not found
                    showMenu = 8 -- Game directories
                    menuY = 2
                elseif showMenu == 11 then -- Rom Browser
                    -- Do nothing
                elseif showMenu == 12 then -- Audio
                    showMenu = 2
                    menuY = 3
                elseif showMenu == 13 then -- About - Guide 1
                    showMenu = 7
                    menuY = 1 -- Guide 1
                elseif showMenu == 14 then -- About - Guide 2
                    showMenu = 7
                    menuY = 2 -- Guide 2
                elseif showMenu == 15 then -- About - Guide 3
                    showMenu = 7
                    menuY = 3 -- Guide 3
                elseif showMenu == 16 then -- About - Guide 4
                    showMenu = 7
                    menuY = 4 -- Guide 4
                elseif showMenu == 17 then -- About - Guide 5
                    showMenu = 7
                    menuY = 5 -- Guide 5
                elseif showMenu == 18 then -- About - Guide 6
                    showMenu = 7
                    menuY = 6 -- Guide 6
                elseif showMenu == 19 then -- Other Settings
                    showMenu = 2
                    menuY = 6 -- Other Settings
                elseif showMenu == 20 then -- Game Options
                    showMenu = 1
                    menuY=0
                elseif showMenu == 21 then -- Game Options Adrenaline
                    showMenu = 20
                    menuY=0
                    
                elseif showMenu == 2 then
                    -- If search cancelled with circle, return to settings menu
                    state = Keyboard.getState()
                    if state == RUNNING then
                        showMenu = 2
                        menuY = 0
                    else
                        showMenu = 0
                        menuY = 0
                    end
                else
                    showMenu = 0
                end

                prvRotY = 0
                if setBackground >= 1 then
                    Render.useTexture(modBackground, imgCustomBack)
                end
            end
        end

        -- Triangle button - Game info screen
        if (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) and showMenu == 1 then
            -- Game Options
            showMenu = 20
            menuY = 0
        end

    end
    
    if delayTouch > 0 then
        delayTouch = delayTouch - 0.1
    else
        delayTouch = 0
        touchdown = 0
    end
    -- End Touch
    -- End Controls
    if showCat == 1 then
        curTotal = #games_table
        if #games_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 2 then curTotal = #homebrews_table        if #homebrews_table == 0        then p = 0 master_index = p end
    elseif showCat == 3 then curTotal = #psp_table              if #psp_table == 0              then p = 0 master_index = p end
    elseif showCat == 4 then curTotal = #psx_table              if #psx_table == 0              then p = 0 master_index = p end
    elseif showCat == 5 then curTotal = #n64_table              if #n64_table == 0              then p = 0 master_index = p end
    elseif showCat == 6 then curTotal = #snes_table             if #snes_table == 0             then p = 0 master_index = p end
    elseif showCat == 7 then curTotal = #nes_table              if #nes_table == 0              then p = 0 master_index = p end
    elseif showCat == 8 then curTotal = #gba_table              if #gba_table == 0              then p = 0 master_index = p end
    elseif showCat == 9 then curTotal = #gbc_table              if #gbc_table == 0              then p = 0 master_index = p end
    elseif showCat == 10 then curTotal = #gb_table              if #gb_table == 0               then p = 0 master_index = p end
    elseif showCat == 11 then curTotal = #dreamcast_table       if #dreamcast_table == 0        then p = 0 master_index = p end
    elseif showCat == 12 then curTotal = #sega_cd_table         if #sega_cd_table == 0          then p = 0 master_index = p end
    elseif showCat == 13 then curTotal = #s32x_table            if #s32x_table == 0             then p = 0 master_index = p end
    elseif showCat == 14 then curTotal = #md_table              if #md_table == 0               then p = 0 master_index = p end
    elseif showCat == 15 then curTotal = #sms_table             if #sms_table == 0              then p = 0 master_index = p end
    elseif showCat == 16 then curTotal = #gg_table              if #gg_table == 0               then p = 0 master_index = p end
    elseif showCat == 17 then curTotal = #tg16_table            if #tg16_table == 0             then p = 0 master_index = p end
    elseif showCat == 18 then curTotal = #tgcd_table            if #tgcd_table == 0             then p = 0 master_index = p end
    elseif showCat == 19 then curTotal = #pce_table             if #pce_table == 0              then p = 0 master_index = p end
    elseif showCat == 20 then curTotal = #pcecd_table           if #pcecd_table == 0            then p = 0 master_index = p end
    elseif showCat == 21 then curTotal = #amiga_table           if #amiga_table == 0            then p = 0 master_index = p end
    elseif showCat == 22 then curTotal = #c64_table             if #c64_table == 0              then p = 0 master_index = p end
    elseif showCat == 23 then curTotal = #wswan_col_table       if #wswan_col_table == 0        then p = 0 master_index = p end
    elseif showCat == 24 then curTotal = #wswan_table           if #wswan_table == 0            then p = 0 master_index = p end
    elseif showCat == 25 then curTotal = #msx2_table            if #msx2_table == 0             then p = 0 master_index = p end
    elseif showCat == 26 then curTotal = #msx1_table            if #msx1_table == 0             then p = 0 master_index = p end
    elseif showCat == 27 then curTotal = #zxs_table             if #zxs_table == 0              then p = 0 master_index = p end
    elseif showCat == 28 then curTotal = #atari_7800_table      if #atari_7800_table == 0       then p = 0 master_index = p end
    elseif showCat == 29 then curTotal = #atari_5200_table      if #atari_5200_table == 0       then p = 0 master_index = p end
    elseif showCat == 30 then curTotal = #atari_2600_table      if #atari_2600_table == 0       then p = 0 master_index = p end
    elseif showCat == 31 then curTotal = #atari_lynx_table      if #atari_lynx_table == 0       then p = 0 master_index = p end
    elseif showCat == 32 then curTotal = #colecovision_table    if #colecovision_table == 0     then p = 0 master_index = p end
    elseif showCat == 33 then curTotal = #vectrex_table         if #vectrex_table == 0          then p = 0 master_index = p end
    elseif showCat == 34 then curTotal = #fba_table             if #fba_table == 0              then p = 0 master_index = p end
    elseif showCat == 35 then curTotal = #mame_2003_plus_table  if #mame_2003_plus_table == 0   then p = 0 master_index = p end
    elseif showCat == 36 then curTotal = #mame_2000_table       if #mame_2000_table == 0        then p = 0 master_index = p end
    elseif showCat == 37 then curTotal = #neogeo_table          if #neogeo_table == 0           then p = 0 master_index = p end
    elseif showCat == 38 then curTotal = #ngpc_table            if #ngpc_table == 0             then p = 0 master_index = p end 
    elseif showCat == 39 then curTotal = #psm_table             if #psm_table == 0              then p = 0 master_index = p end    
    elseif showCat == 40 then
        -- count favorites
        create_fav_count_table(files_table)
        
        curTotal = #fav_count
        if #fav_count == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 41 then
        curTotal = #recently_played_table
        if #recently_played_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 42 then
        curTotal = #search_results_table
        if #search_results_table == 0 then
            p = 0
            master_index = p
        end

    else
        curTotal = #files_table
        if #files_table == 0 then
            p = 0
            master_index = p
        end
    end
    
    -- Check for out of bounds in menu 
    if p < 1 then
        p = curTotal
        if p >= 1 then
            master_index = p -- 0
        end
        startCovers = false
        GetInfoSelected()
    elseif p > curTotal then
        p = 1
        master_index = p
        startCovers = false
        GetInfoSelected()
    end

    -- Check for out of bounds in menu - ROM Browser
    if i > #scripts then
        i = 1
    elseif i < 1 then
        i = #scripts
    end
    
    -- Refreshing screen and oldpad
    Screen.waitVblankStart()
    Screen.flip()
    oldpad = pad

    if oneLoopTimer then -- if the timer is running then...
        oneLoopTime = Timer.getTime(oneLoopTimer) -- save the time
        Timer.destroy(oneLoopTimer)
        oneLoopTimer = nil -- clear timer value
    end 
end
