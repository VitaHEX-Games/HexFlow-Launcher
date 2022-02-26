-- RetroFlow Launcher - HexFlow Mod version by jimbob4000
-- Based on HexFlow Launcher  version 0.5 by VitaHEX
-- https://www.patreon.com/vitahex

dofile("app0:addons/threads.lua")
local working_dir = "ux0:/app"
local appversion = "3.4"
function System.currentDirectory(dir)
    if dir == nil then
        return working_dir
    else
        working_dir = dir
    end
end


Network.init()

local onlineCoverPathSystem = {
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PSVita/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PSP/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/PS1/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/HOMEBREW/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/N64/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/SNES/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/NES/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GBA/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GBC/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GB/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MD/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/SMS/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/GG/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/MAME/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/AMIGA/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/TG16/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/TG_CD/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/PCE/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/PCE_CD/Covers/",
    "https://raw.githubusercontent.com/jimbob4000/hexflow-covers/main/Covers/Retro/NEOGEO_PC/Covers/",
}

Sound.init()
local click = Sound.open("app0:/DATA/click2.wav")
local sndMusic = click--temp
local imgCoverTmp = Graphics.loadImage("app0:/DATA/noimg.png")
local backTmp = Graphics.loadImage("app0:/DATA/noimg.png")
local btnX = Graphics.loadImage("app0:/DATA/x.png")
local btnT = Graphics.loadImage("app0:/DATA/t.png")
local btnS = Graphics.loadImage("app0:/DATA/s.png")
local btnO = Graphics.loadImage("app0:/DATA/o.png")
local imgWifi = Graphics.loadImage("app0:/DATA/wifi.png")
local imgBattery = Graphics.loadImage("app0:/DATA/bat.png")
local imgBack = Graphics.loadImage("app0:/DATA/back_01.jpg")
local imgFloor = Graphics.loadImage("app0:/DATA/floor.png")
local imgFavorite_small_on = Graphics.loadImage("app0:/DATA/fav-small-on.png")
local imgFavorite_small_off = Graphics.loadImage("app0:/DATA/fav-small-off.png")
local imgFavorite_small_blank = Graphics.loadImage("app0:/DATA/fav-small-blank.png")
local imgFavorite_large_on = Graphics.loadImage("app0:/DATA/fav-large-on.png")
local imgFavorite_large_off = Graphics.loadImage("app0:/DATA/fav-large-off.png")

btnMargin = 32 -- Distance between footer buttons

Graphics.setImageFilters(imgFloor, FILTER_LINEAR, FILTER_LINEAR)


local cur_dir = "ux0:/data/RetroFlow/"

local localCoverPath = {
    "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Vita/",
    "ux0:/data/RetroFlow/COVERS/Sony - PlayStation Portable/",
    "ux0:/data/RetroFlow/COVERS/Sony - PlayStation/",
    "ux0:/data/RetroFlow/COVERS/Homebrew/",
    "ux0:/data/RetroFlow/COVERS/Nintendo - Nintendo 64/",
    "ux0:/data/RetroFlow/COVERS/Nintendo - Super Nintendo Entertainment System/",
    "ux0:/data/RetroFlow/COVERS/Nintendo - Nintendo Entertainment System/",
    "ux0:/data/RetroFlow/COVERS/Nintendo - Game Boy Advance/",
    "ux0:/data/RetroFlow/COVERS/Nintendo - Game Boy Color/",
    "ux0:/data/RetroFlow/COVERS/Nintendo - Game Boy/",
    "ux0:/data/RetroFlow/COVERS/Sega - Mega Drive - Genesis/",
    "ux0:/data/RetroFlow/COVERS/Sega - Master System - Mark III/",
    "ux0:/data/RetroFlow/COVERS/Sega - Game Gear/",
    "ux0:/data/RetroFlow/COVERS/MAME/",
    "ux0:/data/RetroFlow/COVERS/Commodore - Amiga/",
    "ux0:/data/RetroFlow/COVERS/NEC - TurboGrafx 16/",
    "ux0:/data/RetroFlow/COVERS/NEC - TurboGrafx CD/",
    "ux0:/data/RetroFlow/COVERS/NEC - PC Engine/",
    "ux0:/data/RetroFlow/COVERS/NEC - PC Engine CD/",
    "ux0:/data/RetroFlow/COVERS/SNK - Neo Geo Pocket Color/",
}

System.createDirectory("ux0:/data/RetroFlow/")
System.createDirectory("ux0:/data/RetroFlow/COVERS/")

-- Create directories - Covers
for directories = 1, 20 do
   System.createDirectory(localCoverPath[directories])
end

-- Tidy up legacy COVER folder structure to a more standard naming convention
if System.doesDirExist(cur_dir .. "COVERS/PSVITA")  then System.rename(cur_dir .. "COVERS/PSVITA",  cur_dir .. "COVERS/Sony - PlayStation Vita") end
if System.doesDirExist(cur_dir .. "COVERS/PSP")     then System.rename(cur_dir .. "COVERS/PSP",     cur_dir .. "COVERS/Sony - PlayStation Portable") end
if System.doesDirExist(cur_dir .. "COVERS/PSX")     then System.rename(cur_dir .. "COVERS/PSX",     cur_dir .. "COVERS/Sony - PlayStation") end
if System.doesDirExist(cur_dir .. "COVERS/N64")     then System.rename(cur_dir .. "COVERS/N64",     cur_dir .. "COVERS/Nintendo - Nintendo 64") end
if System.doesDirExist(cur_dir .. "COVERS/SNES")    then System.rename(cur_dir .. "COVERS/SNES",    cur_dir .. "COVERS/Nintendo - Super Nintendo Entertainment System") end
if System.doesDirExist(cur_dir .. "COVERS/NES")     then System.rename(cur_dir .. "COVERS/NES",     cur_dir .. "COVERS/Nintendo - Nintendo Entertainment System") end
if System.doesDirExist(cur_dir .. "COVERS/GBA")     then System.rename(cur_dir .. "COVERS/GBA",     cur_dir .. "COVERS/Nintendo - Game Boy Advance") end
if System.doesDirExist(cur_dir .. "COVERS/GBC")     then System.rename(cur_dir .. "COVERS/GBC",     cur_dir .. "COVERS/Nintendo - Game Boy Color") end
if System.doesDirExist(cur_dir .. "COVERS/GB")      then System.rename(cur_dir .. "COVERS/GB",      cur_dir .. "COVERS/Nintendo - Game Boy") end
if System.doesDirExist(cur_dir .. "COVERS/MD")      then System.rename(cur_dir .. "COVERS/MD",      cur_dir .. "COVERS/Sega - Mega Drive - Genesis") end
if System.doesDirExist(cur_dir .. "COVERS/SMS")     then System.rename(cur_dir .. "COVERS/SMS",     cur_dir .. "COVERS/Sega - Master System - Mark III") end
if System.doesDirExist(cur_dir .. "COVERS/GG")      then System.rename(cur_dir .. "COVERS/GG",      cur_dir .. "COVERS/Sega - Game Gear") end


-- ROM Folders
local romFolder = "ux0:/data/RetroFlow/ROMS/"
local romFolder_N64 = romFolder .. "Nintendo - Nintendo 64"
local romFolder_SNES = romFolder .. "Nintendo - Super Nintendo Entertainment System"
local romFolder_NES = romFolder .. "Nintendo - Nintendo Entertainment System"
local romFolder_GBA = romFolder .. "Nintendo - Game Boy Advance"
local romFolder_GBC = romFolder .. "Nintendo - Game Boy Color"
local romFolder_GB = romFolder .. "Nintendo - Game Boy"
local romFolder_MD = romFolder .. "Sega - Mega Drive - Genesis"
local romFolder_SMS = romFolder .. "Sega - Master System - Mark III"
local romFolder_GG = romFolder .. "Sega - Game Gear"
local romFolder_PSP_GAME = "ux0:/pspemu/PSP/GAME"
local romFolder_PSP_ISO = "ux0:/pspemu/ISO"
local romFolder_MAME_2000 = romFolder .. "MAME 2000"
local romFolder_AMIGA = romFolder .. "Commodore - Amiga"
local romFolder_TG16 = romFolder .. "NEC - TurboGrafx 16"
local romFolder_PCE = romFolder .. "NEC - PC Engine"
local romFolder_TGCD = romFolder .. "NEC - TurboGrafx CD"
local romFolder_PCECD = romFolder .. "NEC - PC Engine CD"
local romFolder_NGPC = romFolder .. "SNK - Neo Geo Pocket Color"


-- Tidy up legacy ROM folder structure to a more standard naming convention
if System.doesDirExist(romFolder .. "N64")  then System.rename(romFolder .. "N64",   romFolder .. "Nintendo - Nintendo 64") end
if System.doesDirExist(romFolder .. "SNES") then System.rename(romFolder .. "SNES",  romFolder .. "Nintendo - Super Nintendo Entertainment System") end
if System.doesDirExist(romFolder .. "NES")  then System.rename(romFolder .. "NES",   romFolder .. "Nintendo - Nintendo Entertainment System") end
if System.doesDirExist(romFolder .. "GBA")  then System.rename(romFolder .. "GBA",   romFolder .. "Nintendo - Game Boy Advance") end
if System.doesDirExist(romFolder .. "GBC")  then System.rename(romFolder .. "GBC",   romFolder .. "Nintendo - Game Boy Color") end
if System.doesDirExist(romFolder .. "GB")   then System.rename(romFolder .. "GB",    romFolder .. "Nintendo - Game Boy") end
if System.doesDirExist(romFolder .. "MD")   then System.rename(romFolder .. "MD",    romFolder .. "Sega - Mega Drive - Genesis") end
if System.doesDirExist(romFolder .. "SMS")  then System.rename(romFolder .. "SMS",   romFolder .. "Sega - Master System - Mark III") end
if System.doesDirExist(romFolder .. "GG")   then System.rename(romFolder .. "GG",    romFolder .. "Sega - Game Gear") end

-- Create directories - Rom Folders
System.createDirectory(romFolder)
System.createDirectory(romFolder_N64)
System.createDirectory(romFolder_SNES)
System.createDirectory(romFolder_NES)
System.createDirectory(romFolder_GBA)
System.createDirectory(romFolder_GBC)
System.createDirectory(romFolder_GB)
System.createDirectory(romFolder_MD)
System.createDirectory(romFolder_SMS)
System.createDirectory(romFolder_GG)
System.createDirectory(romFolder_MAME_2000)
System.createDirectory(romFolder_AMIGA)
System.createDirectory(romFolder_TG16)
System.createDirectory(romFolder_TGCD)
System.createDirectory(romFolder_PCE)
System.createDirectory(romFolder_PCECD)
System.createDirectory(romFolder_NGPC)

-- Create directories - User Database
local user_DB_Folder = "ux0:/data/RetroFlow/TITLES/"
System.createDirectory(user_DB_Folder)

-- Create directories - Database Cache
local db_Cache_Folder = "ux0:/data/RetroFlow/CACHE/"
System.createDirectory(db_Cache_Folder)

-- Retroarch Cores
local core_SNES = "app0:/snes9x2005_libretro.self"
local core_NES = "app0:/quicknes_libretro.self"
local core_GBA = "app0:/gpsp_libretro.self"
local core_GBC = "app0:/gambatte_libretro.self"
local core_GB = "app0:/gambatte_libretro.self"
local core_MD = "app0:/genesis_plus_gx_libretro.self"
local core_SMS = "app0:/smsplus_libretro.self"
local core_GG = "app0:/smsplus_libretro.self"
local core_MAME = "app0:/mame2000_libretro.self"
local core_AMIGA = "app0:/puae_libretro.self"
local core_TG16 = "app0:/mednafen_pce_fast_libretro.self"
local core_TGCD = "app0:/mednafen_pce_fast_libretro.self"
local core_PCE = "app0:/mednafen_pce_fast_libretro.self"
local core_PCECD = "app0:/mednafen_pce_fast_libretro.self"
local core_NGPC = "app0:/mednafen_ngp_libretro.self"

-- Launcher App Directory
local launch_dir = "ux0:/rePatch/RETROFDV1/"
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

local modBoxN64 = Render.loadObject("app0:/DATA/boxn64.obj", imgBoxBLANK)
local modCoverN64 = Render.loadObject("app0:/DATA/covern64.obj", imgCoverTmp)
local modBoxN64Noref = Render.loadObject("app0:/DATA/boxn64_noreflx.obj", imgBoxBLANK)
local modCoverN64Noref = Render.loadObject("app0:/DATA/covern64_noreflx.obj", imgCoverTmp)

local modBoxNES = Render.loadObject("app0:/DATA/boxnes.obj", imgBoxBLANK)
local modCoverNES = Render.loadObject("app0:/DATA/covernes.obj", imgCoverTmp)
local modBoxNESNoref = Render.loadObject("app0:/DATA/boxnes_noreflx.obj", imgBoxBLANK)
local modCoverNESNoref = Render.loadObject("app0:/DATA/covernes_noreflx.obj", imgCoverTmp)

local modBoxGB = Render.loadObject("app0:/DATA/boxgb.obj", imgBoxBLANK)
local modCoverGB = Render.loadObject("app0:/DATA/covergb.obj", imgCoverTmp)
local modBoxGBNoref = Render.loadObject("app0:/DATA/boxgb_noreflx.obj", imgBoxBLANK)
local modCoverGBNoref = Render.loadObject("app0:/DATA/covergb_noreflx.obj", imgCoverTmp)

local modBoxMD = Render.loadObject("app0:/DATA/boxmd.obj", imgBoxBLANK)
local modCoverMD = Render.loadObject("app0:/DATA/covermd.obj", imgCoverTmp)
local modBoxMDNoref = Render.loadObject("app0:/DATA/boxmd_noreflx.obj", imgBoxBLANK)
local modCoverMDNoref = Render.loadObject("app0:/DATA/covermd_noreflx.obj", imgCoverTmp)

local modCoverHbr = Render.loadObject("app0:/DATA/cover_square.obj", imgCoverTmp)
local modCoverHbrNoref = Render.loadObject("app0:/DATA/cover_square_noreflx.obj", imgCoverTmp)

local modBackground = Render.loadObject("app0:/DATA/planebg.obj", imgBack)
local modDefaultBackground = Render.loadObject("app0:/DATA/planebg.obj", imgBack)
local modFloor = Render.loadObject("app0:/DATA/planefloor.obj", imgFloor)

local img_path = ""

local fnt = Font.load("app0:/DATA/font.ttf")
local fnt20 = Font.load("app0:/DATA/font.ttf")
local fnt22 = Font.load("app0:/DATA/font.ttf")
local fnt25 = Font.load("app0:/DATA/font.ttf")
local fnt35 = Font.load("app0:/DATA/font.ttf")

Font.setPixelSizes(fnt20, 20)
Font.setPixelSizes(fnt22, 22)
Font.setPixelSizes(fnt25, 25)
Font.setPixelSizes(fnt35, 35)

local cache_file_count_expected = 23

function count_cache_and_reload()
    cache_file_count = System.listDirectory(db_Cache_Folder)
    if #cache_file_count < cache_file_count_expected then -- 23 tables expected
        -- Files missing - rescan
        cache_all_tables()
        files_table = import_cached_DB(System.currentDirectory())
    else
        files_table = import_cached_DB(System.currentDirectory())
    end
end

-- PRINT TABLE FUNCTIONS

function cache_all_tables()
    dofile("app0:addons/printTable.lua")
    print_tables()
end

function update_cached_table_files()
    dofile("app0:addons/printTable.lua")
    print_table_files()
end

function update_cached_table_folders()
    dofile("app0:addons/printTable.lua")
    print_table_folders()
end

function update_cached_table_games()
    dofile("app0:addons/printTable.lua")
    print_table_games()
end

function update_cached_table_homebrews()
    dofile("app0:addons/printTable.lua")
    print_table_homebrews()
end

function update_cached_table_psp()
    dofile("app0:addons/printTable.lua")
    print_table_psp()
end

function update_cached_table_psx()
    dofile("app0:addons/printTable.lua")
    print_table_psx()
end

function update_cached_table_n64()
    dofile("app0:addons/printTable.lua")
    print_table_n64()
end

function update_cached_table_snes()
    dofile("app0:addons/printTable.lua")
    print_table_snes()
end

function update_cached_table_nes()
    dofile("app0:addons/printTable.lua")
    print_table_nes()
end

function update_cached_table_gba()
    dofile("app0:addons/printTable.lua")
    print_table_gba()
end

function update_cached_table_gbc()
    dofile("app0:addons/printTable.lua")
    print_table_gbc()
end

function update_cached_table_gb()
    dofile("app0:addons/printTable.lua")
    print_table_gb()
end

function update_cached_table_md()
    dofile("app0:addons/printTable.lua")
    print_table_md()
end

function update_cached_table_sms()
    dofile("app0:addons/printTable.lua")
    print_table_sms()
end

function update_cached_table_gg()
    dofile("app0:addons/printTable.lua")
    print_table_gg()
end

function update_cached_table_mame()
    dofile("app0:addons/printTable.lua")
    print_table_mame()
end

function update_cached_table_amiga()
    dofile("app0:addons/printTable.lua")
    print_table_amiga()
end

function update_cached_table_tg16()
    dofile("app0:addons/printTable.lua")
    print_table_tg16()
end

function update_cached_table_tgcd()
    dofile("app0:addons/printTable.lua")
    print_table_tgcd()
end

function update_cached_table_pce()
    dofile("app0:addons/printTable.lua")
    print_table_pce()
end

function update_cached_table_pcecd()
    dofile("app0:addons/printTable.lua")
    print_table_pcecd()
end

function update_cached_table_ngpc()
    dofile("app0:addons/printTable.lua")
    print_table_ngpc()
end

function update_cached_table_favorites()
    dofile("app0:addons/printTable.lua")
    print_table_favorites()
end

function update_cached_table_all_games()
    dofile("app0:addons/printTable.lua")
    print_table_all_games()
end

function update_cached_table_recently_played()
    dofile("app0:addons/printTable.lua")
    print_table_recently_played()
end

function update_cached_table_recently_played_pre_launch()
    dofile("app0:addons/printTable.lua")
    print_table_recently_played_pre_launch()
end


local menuX = 0
local menuY = 0
local showMenu = 0
local showCat = 1 -- Category: 0 = all, 1 = games, 2 = homebrews, 3 = psp, 4 = psx, 5 = N64, 6 = SNES, 7 = NES, 8 = GBA, 9 = GBC, 10 = GB, 11 = MD, 12 = SMS, 13 = GG, 14 = MAME, 15 = AMIGA, 16 = TG16, 17 = TG CD, 18 = PCE, 19 = PCE CD, 20 = NGPC, 21 = Favorites
local showView = 0

local info = System.extractSfo("app0:/sce_sys/param.sfo")
local app_version = info.version
local app_title = info.title
local app_category = info.category
local app_titleid = info.titleid
local app_size = 0

local master_index = 1
local p = 1
local oldpad = 0
local delayTouch = 8.0
local delayButton = 8.0
local hideBoxes = 1.0
local prvRotY = 0

local gettingCovers = false
local scanComplete = false

-- Init Colors
local black = Color.new(0, 0, 0)
local grey = Color.new(45, 45, 45)
local darkalpha = Color.new(40, 40, 40, 180)
local lightgrey = Color.new(58, 58, 58)
local white = Color.new(255, 255, 255)
local red = Color.new(190, 0, 0)
local blue = Color.new(2, 72, 158)
local yellow = Color.new(225, 184, 0)
local green = Color.new(79, 152, 37)
local purple = Color.new(151, 0, 185)
local orange = Color.new(220, 120, 0)
local bg = Color.new(153, 217, 234)
local themeCol = Color.new(2, 72, 158)

local targetX = 0
local xstart = 0
local ystart = 0
local space = 1
local touchdown = 0
local startCovers = false
local inPreview = false
local apptype = 0
local appdir = ""
local getCovers = 0 --0 All, 1 PSV, 2 PSP, 3 PS1, 4 N64, 5 SNES, 6 NES, 7 GBA, 8 GBC, 9 GB, 10 MD, 11 SMS, 12 GG, 13 MAME, 14 AMIGA, 15 TG16, 16 TGCD, 17 PCE, 18 PCECD, 19 NGPC
local tmpappcat = 0

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
local themeColor = 0 -- 0 blue, 1 red, 2 yellow, 3 green, 4 grey, 5 black, 6 purple, 7 orange
local menuItems = 3
local setBackground = 1
local setLanguage = 0
local showHomebrews = 1 -- On
local startupScan = 0 -- 0 Off, 1 On
local showRecentlyPlayed = 1 -- On


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

else
    local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
    settings = {}
    local settings = "Reflections=" .. setReflections .. " " .. "\nSounds=" .. setSounds .. " " .. "\nColor=" .. themeColor .. " " .. "\nBackground=" .. setBackground .. " " .. "\nLanguage=" .. setLanguage .. " " .. "\nView=" .. showView .. " " .. "\nHomebrews=" .. showHomebrews .. " " .. "\nScan=" .. startupScan .. " " .. "\nCategory=" .. startCategory .. " " .. "\nRecent=" .. showRecentlyPlayed
    file_settings = io.open(cur_dir .. "/config.dat", "w")
    file_settings:write(settings)
    file_settings:close()

end
showCat = startCategory

-- Custom Background
local imgCustomBack = imgBack
if System.doesFileExist("ux0:/data/RetroFlow/Background.png") then
    imgCustomBack = Graphics.loadImage("ux0:/data/RetroFlow/Background.png")
    Graphics.setImageFilters(imgCustomBack, FILTER_LINEAR, FILTER_LINEAR)
    Render.useTexture(modBackground, imgCustomBack)
elseif System.doesFileExist("ux0:/data/RetroFlow/Background.jpg") then
    imgCustomBack = Graphics.loadImage("ux0:/data/RetroFlow/Background.jpg")
    Graphics.setImageFilters(imgCustomBack, FILTER_LINEAR, FILTER_LINEAR)
    Render.useTexture(modBackground, imgCustomBack)
end

-- Custom Music
if System.doesFileExist(cur_dir .. "/Music.mp3") then
    sndMusic = Sound.open(cur_dir .. "/Music.mp3")
    if setSounds == 1 then
        Sound.play(sndMusic, LOOP)
    end
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
        themeCol = orange
    else
        themeCol = blue -- default blue
    end
end
SetThemeColor()

-- Speed related settings
local cpu_speed = 333
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
local lang_default = "PS Vita\nHomebrews\nPSP\nPlayStation\nAll\nSettings\nLaunch\nDetails\nCategory\nView\nClose\nVersion:\nAbout\nStartup Category:\nReflection Effect:\nSounds:\nTheme Color:\nCustom Background:\nDownload Covers:\nReload Covers Database\nLanguage:\nOn\nOff\nRed\nYellow\nGreen\nGrey\nBlack\nPurple\nOrange\nBlue\nSelect\nNintendo 64\nSuper Nintendo\nNintendo Entertainment System\nGame Boy Advance\nGame Boy Color\nGame Boy\nSega Mega Drive\nSega Master System\nSega Game Gear\nMAME\nAmiga\nTurboGrafx-16\nTurboGrafx-CD\nPC Engine\nPC Engine CD\nNeo Geo Pocket Color\nHomebrews Category:\nStartup scan:\nPlease install RetroFlow Adrenaline Launcher.\nThe VPK is saved here\nInternet Connection Required\nDefault\nApp ID:\nSize:\nDownload Cover\nOverride Category:\nPress X to apply Category\nCover\nFound\nfound!\nCover not found\nof\nDownloading covers\nDownloading all covers\nDownloading PS Vita covers\nDownloading PSP covers\nDownloading PS1 covers\nDownloading N64 covers\nDownloading SNES covers\nDownloading NES covers\nDownloading GBA covers\nDownloading GBC covers\nDownloading GB covers\nDownloading MD covers\nDownloading SMS covers\nDownloading GG covers\nDownloading MAME covers\nDownloading AMIGA covers\nDownloading TG-16 covers\nDownloading TG-CD covers\nDownloading PCE covers\nDownloading PCE-CD covers\nDownloading NG-PC covers\nPS Vita Game\nPSP Game\nPS1 Game\nN64 Game\nSNES Game\nNES Game\nGBA Game\nGBC Game\nGB Game\nMD Game\nSMS Game\nGG Game\nMAME Game\nAmiga Game\nTurboGrafx-16 Game\nTurboGrafx-CD Game\nPC Engine Game\nPC Engine CD Game\nNeo Geo Pocket Color Game\nHomebrew\nCover\nFavorites\nFavorite\nRecently Played\nRecently Played:"
function ChangeLanguage()
if #lang_lines>0 then
    for k in pairs (lang_lines) do
        lang_lines [k] = nil
    end
end

local lang = "EN.ini"
 -- 0 EN, 1 EN USA, 2 DE, 3 FR, 4 IT, 5 SP, 6 PT, 7 SW, 8 RU, 9 JA, 10 CN, 11 PL
    if setLanguage == 1 then
        lang = "EN_USA.ini"
    elseif setLanguage == 2 then
        lang = "DE.ini"
    elseif setLanguage == 3 then
        lang = "FR.ini"
    elseif setLanguage == 4 then
        lang = "IT.ini"
    elseif setLanguage == 5 then
        lang = "SP.ini"
    elseif setLanguage == 6 then
        lang = "PT.ini"
    elseif setLanguage == 7 then
        lang = "SW.ini"
    elseif setLanguage == 8 then
        lang = "RU.ini"
    elseif setLanguage == 9 then
        lang = "JA.ini"
    elseif setLanguage == 10 then
        lang = "CN.ini"
    elseif setLanguage == 11 then
        lang = "PL.ini"
    else
        lang = "EN.ini"
    end
    
    if System.doesFileExist("app0:/translations/" .. lang) then
        langfile = "app0:/translations/" .. lang
    else
        --create default EN.ini if language is missing
        handle = System.openFile("ux0:/data/RetroFlow/EN.ini", FCREATE)
        System.writeFile(handle, "" .. lang_default, string.len(lang_default))
        System.closeFile(handle)
        langfile = "ux0:/data/RetroFlow/EN.ini"
        setLanguage=0
    end

    for line in io.lines(langfile) do
        lang_lines[#lang_lines+1] = line
    end
end
ChangeLanguage()


-- Message - Check if RetroFlow Adrenaline Launcher needs to be installed
    if not System.doesAppExist("RETROLNCR") then
        if System.doesDirExist("ux0:/pspemu") then
            System.setMessage(lang_lines[51] .. "\n" .. lang_lines[52] .. "\n\nux0:/app/RETROFLOW/payloads/\nRetroFlow Adrenaline Launcher.vpk", false, BUTTON_OK)
            --                Please install RetroFlow Adrenaline Launcher.     The VPK is saved here:
        else
        end
    end


function PrintCentered(font, x, y, text, color, size)
    text = text:gsub("\n","")
    local width = Font.getTextWidth(font,text)
    Font.print(font, x - width / 2, y, text, color)
end

function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function FreeMemory()
    if System.doesFileExist(cur_dir .. "/Music.mp3") then
        Sound.close(sndMusic)
    end
    Graphics.freeImage(imgCoverTmp)
    Graphics.freeImage(btnX)
    Graphics.freeImage(btnT)
    Graphics.freeImage(btnS)
    Graphics.freeImage(btnO)
    Graphics.freeImage(imgWifi)
    Graphics.freeImage(imgBattery)
    Graphics.freeImage(imgBack)
    Graphics.freeImage(imgBox)
    Graphics.freeImage(imgFavorite_small_on)
    Graphics.freeImage(imgFavorite_small_off)
    Graphics.freeImage(imgFavorite_small_blank)
    Graphics.freeImage(imgFavorite_large_on)
    Graphics.freeImage(imgFavorite_large_off)
end


-- Manipulate Rom Name - remove region code and url encode spaces for image download
function cleanRomNames()
    -- file.name = {}
    -- romname_withExtension = file.name
    romname_noExtension = {}
    romname_noExtension = romname_withExtension:match("(.+)%..+$")

    -- remove space before parenthesis " (" then letters and numbers "(.*)"
    romname_noRegion_noExtension = {}
    romname_noRegion_noExtension = romname_noExtension:gsub(" %(", "%("):gsub('%b()', '')

    romname_url_encoded = {}
    romname_url_encoded = romname_noExtension:gsub("%s+", '%%%%20')

    -- Check if name contains parenthesis, if yes strip out to show as version
    if string.find(romname_noExtension, "%(") then
        -- Remove all text except for within "()"
        romname_region_initial = {}
        romname_region_initial = romname_noExtension:match("%((.+)%)")

        -- Tidy up remainder when more than one set of parenthesis used, replace  ") (" with ", "
        romname_region = {}
        romname_region = romname_region_initial:gsub("%) %(", ', ')
    -- If no parenthesis, then add blank to prevent nil error
    else
        -- romname_region = " "
        romname_region = " "
    end
end


-- Manipulate Rom Name - remove region code and url encode spaces for image download
function cleanRomNamesPSP()
    -- file.name = {}
    -- romname_withExtension = file.name
    romname_noExtension = {}
    romname_noExtension = romname_withExtension:match("(.+)%..+$")

    romname_noExtension_notitleid = {}
    romname_noExtension_notitleid = romname_noExtension:gsub(' %b[]', '')

    -- remove space before parenthesis " (" then letters and numbers "(.*)"
    romname_noRegion_noExtension = {}
    romname_noRegion_noExtension = romname_noExtension:gsub(" %(", "%("):gsub('%b()', '')

    romname_noRegion_noExtension_notitleid = {}
    romname_noRegion_noExtension_notitleid = romname_noRegion_noExtension:gsub(" %[", "%["):gsub('%b[]', '') -- game without [ULUS-0000]

    titleID_withHyphen = {}
    titleID_withHyphen = romname_noExtension:match("%[(.+)%]") -- game id without brackets, with hypen ULUS-0000

    titleID_noHyphen = {}
    titleID_noHyphen = tostring(titleID_withHyphen):gsub("%-", '') -- game id without brackets, with hypen ULUS-0000

    romname_url_encoded = {}
    romname_url_encoded = tostring(titleID_noHyphen)

    -- Check if name contains parenthesis, if yes strip out to show as version
    if string.find(romname_noExtension, "%(") then
        -- Remove all text except for within "()"
        romname_region_initial = {}
        romname_region_initial = romname_noExtension:match("%((.+)%)")

        -- Tidy up remainder when more than one set of parenthesis used, replace  ") (" with ", "
        romname_region = {}
        romname_region = romname_region_initial:gsub("%) %(", ', ')
    -- If no parenthesis, then add blank to prevent nil error
    else
        -- romname_region = " "
        romname_region = " "
    end

    if string.match(titleID_noHyphen, "nil") then
        titleID_noHyphen = romname_noExtension
    end

end


function launch_Adrenaline()

    -- Delete the old Adrenaline inf file
    if  System.doesFileExist(launch_dir_adr .. "data/boot.inf") then
        System.deleteFile(launch_dir_adr .. "data/boot.inf")
    end

    -- Delete the old Adrenaline bin file
    if  System.doesFileExist(launch_dir_adr .. "data/boot.bin") then
        System.deleteFile(launch_dir_adr .. "data/boot.bin")
    end

    -- Create Boot.inf
    local file_boot = System.openFile("ux0:/app/RETROLNCR/data/boot.inf", FCREATE)
    System.closeFile(file_boot)

    file = io.open("ux0:/app/RETROLNCR/data/boot.inf", "w")
    file:write(rom_location)
    file:close()

    System.launchApp("RETROLNCR")

end


function clean_launch_dir()
    
    -- Load repatch    
    plug_repatch_ex = System.loadKernelPlugin("ux0:/app/RETROFLOW/modules/repatch_ex.skprx")

    -- Create rePatch directory if doesn't exist
    if not System.doesDirExist("ux0:/rePatch") then
        System.createDirectory("ux0:/rePatch")
    end

    -- Create launch directory if doesn't exist
    if not System.doesDirExist(launch_dir) then
        System.createDirectory(launch_dir)
    end

    -- Delete the old rom file
    if  System.doesFileExist(launch_dir .. "rom.txt") then
        System.deleteFile(launch_dir .. "rom.txt")
    end

    -- Delete the old core file
    if  System.doesFileExist(launch_dir .. "core.txt") then
        System.deleteFile(launch_dir .. "core.txt")
    end

    -- Delete the old N64 args file
    if  System.doesFileExist(launch_dir .. "args.txt") then
        System.deleteFile(launch_dir .. "args.txt")
    end
end


function launch_retroarch()

    -- Create rom.txt
    local file_over = System.openFile(launch_dir .. "rom.txt", FCREATE)
    System.closeFile(file_over)

    rom_txt_file = io.open(launch_dir .. "rom.txt", "w")
    rom_txt_file:write(rom_location)
    rom_txt_file:close()

    -- Create core.txt
    local file_over = System.openFile(launch_dir .. "core.txt", FCREATE)
    System.closeFile(file_over)

    core_txt_file = io.open(launch_dir .. "core.txt", "w")
    core_txt_file:write(core_name)
    core_txt_file:close()

    System.launchEboot("app0:/launch_retroarch.bin")
end


function launch_DaedalusX64()

    -- Create args.txt
    local file_over = System.openFile(launch_dir .. "args.txt", FCREATE)
    System.closeFile(file_over)

    args_txt_file = io.open(launch_dir .. "args.txt", "w")
    args_txt_file:write(rom_location)
    args_txt_file:close()

    System.launchEboot("app0:/launch_n64.bin")
end


function CreateUserTitleTable_PSP_game()

    table.sort(psp_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    local file_over = System.openFile(user_DB_Folder .. "psp_game.lua", FCREATE)
    System.closeFile(file_over)

    file = io.open(user_DB_Folder .. "psp_game.lua", "w")
    file:write('return {' .. "\n")
    for k, v in pairs(psp_table) do

        if v.directory == true then
            file:write('["' .. v.name .. '"] = {name = "' .. v.name_title_search .. '"},' .. "\n")
        end
    end
    file:write('}')
    file:close()

end

function CreateUserTitleTable_PSP_iso()

    table.sort(psp_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    local file_over = System.openFile(user_DB_Folder .. "psp_iso.lua", FCREATE)
    System.closeFile(file_over)

    file = io.open(user_DB_Folder .. "psp_iso.lua", "w")
    file:write('return {' .. "\n")
    for k, v in pairs(psp_table) do

        if v.directory == false then
            file:write('["' .. v.name .. '"] = {name = "' .. v.name_title_search .. '"},' .. "\n")
        end
    end
    file:write('}')
    file:close()

end


function CreateUserTitleTable_PSX()

    table.sort(psx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    local file_over = System.openFile(user_DB_Folder .. "psx.lua", FCREATE)
    System.closeFile(file_over)

    file = io.open(user_DB_Folder .. "psx.lua", "w")
    file:write('return {' .. "\n")
    for k, v in pairs(psx_table) do

        if v.directory == true then
            file:write('["' .. v.name .. '"] = {name = "' .. v.name_title_search .. '"},' .. "\n")
        end
    end
    file:write('}')
    file:close()
    
end

function CreateUserTitleTable_MAME()

    local UserGameDB = "mame.lua"
    local TableToScan = mame_table

    table.sort(TableToScan, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)

    local file_over = System.openFile(user_DB_Folder .. UserGameDB, FCREATE)
    System.closeFile(file_over)

    file = io.open(user_DB_Folder .. UserGameDB, "w")
    file:write('return {' .. "\n")
    for k, v in pairs(TableToScan) do

        if v.directory == false then
            file:write('["' .. v.title .. '"] = {name = "' .. v.name_title_search .. '"},' .. "\n")
        end
    end
    file:write('}')
    file:close()

end


function listDirectory(dir)
    dir = System.listDirectory(dir)
    folders_table = {}
    files_table = {}
    games_table = {}
    psp_table = {}
    psx_table = {}
    n64_table = {}
    snes_table = {}
    nes_table = {}
    gba_table = {}
    gbc_table = {}
    gb_table = {}
    md_table = {}
    sms_table = {}
    gg_table = {}
    mame_table = {}
    amiga_table = {}
    tg16_table = {}
    tgcd_table = {}
    pce_table = {}
    pcecd_table = {}
    ngpc_table = {}
    homebrews_table = {}
    all_games_table = {}
    recently_played_table = {}

    psxdbfull = {}
    pspdbfull = {}
    mamedbfull = {}

    -- app_type = 0 -- 0 homebrew, 1 psvita, 2 psp, 3 psx, 5 n64, 6 snes, 7 nes, 8 gba, 9 gbc, 10 gb, 11 md, 12 sms, 13 gg, 14 mame, 15 amiga, 16 tg16, 17 tgcd, 18 pce, 19 pcecd, 20 ngcp
    local customCategory = 0
    
    local file_over = System.openFile(cur_dir .. "/overrides.dat", FREAD)
    local filesize = System.sizeFile(file_over)
    local str = System.readFile(file_over, filesize)
    System.closeFile(file_over)

    local fileFav_over = System.openFile(cur_dir .. "/favorites.dat", FREAD)
    local fileFavsize = System.sizeFile(fileFav_over)
    local strFav = System.readFile(fileFav_over, fileFavsize)
    System.closeFile(fileFav_over)

    for i, file in pairs(dir) do
    local custom_path, custom_path_id, app_type = nil, nil, nil


        if file.directory
            and not string.match(file.name, "RETROFLOW") -- Don't index Retroflow
            and not string.match(file.name, "RETROLNCR") -- Don't index Retroflow Adrenaline Launcher
            and not string.match(file.name, "ADRLANCHR") -- Don't index Adrenaline Launcher
            and not System.doesFileExist(working_dir .. "/" .. file.name .. "/data/boot.bin") -- Don't scan PSP and PSX Bubbles
            then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            -- get app name to match with custom cover file name
            if System.doesFileExist(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo")
                app_title = info.title
                file.titleid = tostring(info.titleid)
                file.version = tostring(info.version)
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

            local custom_path = {
                localCoverPath[1] .. app_title .. ".png",
                localCoverPath[2] .. app_title .. ".png",
                localCoverPath[3] .. app_title .. ".png",
                localCoverPath[4] .. app_title .. ".png"
            }
            local custom_path_id = {
                localCoverPath[1] .. file.name .. ".png",
                localCoverPath[2] .. file.name .. ".png",
                localCoverPath[3] .. file.name .. ".png",
                localCoverPath[4] .. file.name .. ".png"
            }

            if string.match(file.name, "PCS") and not string.match(file.name, "PCSI") then
                
                
                --CHECK FOR OVERRIDDEN CATEGORY of VITA game
                if System.doesFileExist(cur_dir .. "/overrides.dat") then
                    
                    --0 default, 1 vita, 2 psp, 3 psx, 4 homebrew

                    -- VITA
                    if string.match(str, file.name .. "=1") then
                        table.insert(games_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=1

                        file.cover_path_online = onlineCoverPathSystem[1]
                        file.cover_path_local = localCoverPath[1]

                        if custom_path[1] and System.doesFileExist(custom_path[1]) then
                            img_path = custom_path[1] --custom cover by app name
                        elseif custom_path_id[1] and System.doesFileExist(custom_path_id[1]) then
                            img_path = custom_path_id[1] --custom cover by app id
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
                        table.insert(all_games_table, 1, file)
                        file.app_type=2

                        file.cover_path_online = onlineCoverPathSystem[2]
                        file.cover_path_local = localCoverPath[2]

                        if custom_path[2] and System.doesFileExist(custom_path[2]) then
                            img_path = custom_path[2] --custom cover by app name
                        elseif custom_path_id[2] and System.doesFileExist(custom_path_id[2]) then
                            img_path = custom_path_id[2] --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- PSX
                    elseif string.match(str, file.name .. "=3") then
                        table.insert(psx_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=3

                        file.cover_path_online = onlineCoverPathSystem[3]
                        file.cover_path_local = localCoverPath[3]

                        if custom_path[3] and System.doesFileExist(custom_path[3]) then
                            img_path = custom_path[3] --custom cover by app name
                        elseif custom_path_id[3] and System.doesFileExist(custom_path_id[3]) then
                            img_path = custom_path_id[3] --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end

                    -- HOMEBREW
                    elseif string.match(str, file.name .. "=4") then
                        -- Homebrew
                        table.insert(homebrews_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=0

                        file.cover_path_online = onlineCoverPathSystem[4]
                        file.cover_path_local = localCoverPath[4]

                        if custom_path[4] and System.doesFileExist(custom_path[4]) then
                            img_path = custom_path[4] --custom cover by app name
                        elseif custom_path_id[4] and System.doesFileExist(custom_path_id[4]) then
                            img_path = custom_path_id[4] --custom cover by app id
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
                        table.insert(all_games_table, 1, file)
                        file.app_type=1

                        file.cover_path_local = localCoverPath[1]
                        file.cover_path_online = onlineCoverPathSystem[1]

                        if custom_path[1] and System.doesFileExist(custom_path[1]) then
                            img_path = custom_path[1] --custom cover by app name
                        elseif custom_path_id[1] and System.doesFileExist(custom_path_id[1]) then
                            img_path = custom_path_id[1] --custom cover by app id
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
                    table.insert(all_games_table, 1, file)
                    file.app_type=1

                    file.cover_path_online = onlineCoverPathSystem[1]
                    file.cover_path_local = localCoverPath[1]

                    if custom_path[1] and System.doesFileExist(custom_path[1]) then
                        img_path = custom_path[1] --custom cover by app name
                    elseif custom_path_id[1] and System.doesFileExist(custom_path_id[1]) then
                        img_path = custom_path_id[1] --custom cover by app id
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

                -- Commented out to avoid duplicating homebrew
                -- -- Scan Homebrews 
                --     -- Hide homebrews from All Category
                --     if showHomebrews == 0 then -- If show Homebrews is OFF

                --         -- Commented out to avoid duplicating homebrew
                --         -- table.insert(folders_table, file)
                --         -- file.app_type=0

                --     else -- If show Homebrews is ON
                --         --Check for Vita override and include those games
                --         if System.doesFileExist(cur_dir .. "/overrides.dat") then
                --             --0 default, 1 vita, 2 psp, 3 psx, 4 homebrew
                --             if string.match(str, file.name .. "=1") then
                --                 table.insert(folders_table, file)
                --                 table.insert(all_games_table, 1, file)
                --                 file.app_type=0

                --                 file.cover_path_online = onlineCover
                --                 file.cover_path_local = localCoverPath[1]

                --                 if custom_path[4] and System.doesFileExist(custom_path[4]) then
                --                     img_path = custom_path[4] --custom cover by app name
                --                 elseif custom_path_id[4] and System.doesFileExist(custom_path_id[4]) then
                --                     img_path = custom_path_id[4] --custom cover by app id
                --                 else
                --                     if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                --                         img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                --                     else
                --                         img_path = "app0:/DATA/noimg.png" --blank grey
                --                     end
                --                 end

                --             end
                --         end
                --     end
                
                
            --CHECK FOR OVERRIDDEN CATEGORY of HOMEBREW game
                if System.doesFileExist(cur_dir .. "/overrides.dat") then
                    --0 default, 1 vita, 2 psp, 3 psx, 4 homebrew

                    -- VITA
                    if string.match(str, file.name .. "=1") then
                        table.insert(games_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=1

                        file.cover_path_online = onlineCoverPathSystem[1]
                        file.cover_path_local = localCoverPath[1]

                        if custom_path[1] and System.doesFileExist(custom_path[1]) then
                            img_path = custom_path[1] --custom cover by app name
                        elseif custom_path_id[1] and System.doesFileExist(custom_path_id[1]) then
                            img_path = custom_path_id[1] --custom cover by app id
                        else
                            if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
                                img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
                            else
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psv.png" --blank grey
                            end
                        end

                    -- PSP
                    elseif string.match(str, file.name .. "=2") then
                        table.insert(psp_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=2

                        file.cover_path_online = onlineCoverPathSystem[2]
                        file.cover_path_local = localCoverPath[2]

                        if custom_path[2] and System.doesFileExist(custom_path[2]) then
                            img_path = custom_path[2] --custom cover by app name
                        elseif custom_path_id[2] and System.doesFileExist(custom_path_id[2]) then
                            img_path = custom_path_id[2] --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                    
                    -- PSX
                    elseif string.match(str, file.name .. "=3") then
                        table.insert(psx_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=3

                        file.cover_path_online = onlineCoverPathSystem[3]
                        file.cover_path_local = localCoverPath[3]

                        if custom_path[3] and System.doesFileExist(custom_path[3]) then
                            img_path = custom_path[3] --custom cover by app name
                        elseif custom_path_id[3] and System.doesFileExist(custom_path_id[3]) then
                            img_path = custom_path_id[3] --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end


                    -- HOMEBREW
                    elseif string.match(str, file.name .. "=4") then
                        table.insert(homebrews_table, file)

                        table.insert(folders_table, file)
                        table.insert(all_games_table, 1, file)
                        file.app_type=0

                        file.cover_path_online = onlineCoverPathSystem[4]
                        file.cover_path_local = localCoverPath[4]

                        if custom_path[4] and System.doesFileExist(custom_path[4]) then
                            img_path = custom_path[4] --custom cover by app name
                        elseif custom_path_id[4] and System.doesFileExist(custom_path_id[4]) then
                            img_path = custom_path_id[4] --custom cover by app id
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
                        table.insert(all_games_table, 1, file)
                        file.app_type=0

                        file.cover_path_online = onlineCoverPathSystem[4]
                        file.cover_path_local = localCoverPath[4]

                        if custom_path[4] and System.doesFileExist(custom_path[4]) then
                            img_path = custom_path[4] --custom cover by app name
                        elseif custom_path_id[4] and System.doesFileExist(custom_path_id[4]) then
                            img_path = custom_path_id[4] --custom cover by app id
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
                    table.insert(all_games_table, 1, file)
                    file.app_type=0

                    file.cover_path_online = onlineCoverPathSystem[4]
                    file.cover_path_local = localCoverPath[4]

                    if custom_path[4] and System.doesFileExist(custom_path[4]) then
                        img_path = custom_path[4] --custom cover by app name
                    elseif custom_path_id[4] and System.doesFileExist(custom_path_id[4]) then
                        img_path = custom_path_id[4] --custom cover by app id
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
        
    
        
        table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
        
        --add blank icon to all
        file.icon = imgCoverTmp
        file.icon_path = img_path
        
        table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
        
        file.apptitle = app_title
        table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)
        
    end


    -- SCAN ROMS


    -- SCAN PSP - ISO FOLDER
    if  System.doesDirExist(romFolder_PSP_ISO) then

        files_PSP = System.listDirectory(romFolder_PSP_ISO)

        -- LOOKUP TITLE ID: Load saved table of previously macthes titleID's for faster name lookup

        if System.doesFileExist(user_DB_Folder .. "psp_iso.lua") then
            database_rename_PSP = user_DB_Folder .. "psp_iso.lua"
        else
            database_rename_PSP = "app0:addons/psp.lua"
        end

        for i, file in pairs(files_PSP) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
            if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

                    -- check if game is in the favorites list
                    if System.doesFileExist(cur_dir .. "/favorites.dat") then
                        if string.find(strFav, file.name,1,true) ~= nil then
                            file.favourite = true
                        else
                            file.favourite = false
                        end
                    end

                    file.launch_argument = ("PATH=ms0:/ISO/" .. file.name)
                    file.game_path = (romFolder_PSP_ISO .. "/" .. file.name)
                    file.date_played = 0

                    romname_withExtension = file.name

                    -- Check file naming, are there any spaces?

                    if string.match(romname_withExtension, "%s") then
                    -- Spaces found, cleanup the filename
                        
                        cleanRomNamesPSP()

                        info = romname_noRegion_noExtension
                        app_title = romname_noRegion_noExtension_notitleid
                        

                        file.filename = file.name
                        file.name = titleID_noHyphen
                        file.title = romname_noRegion_noExtension_notitleid
                        file.name_online = titleID_noHyphen
                        file.version = romname_region
                        file.name_title_search = romname_noExtension_notitleid
                        file.apptitle = romname_noRegion_noExtension_notitleid

                        custom_path = localCoverPath[2] .. romname_noRegion_noExtension_notitleid .. ".png"
                        custom_path_id = localCoverPath[2] .. titleID_noHyphen .. ".png"

                    else
                    -- No spaces, it's probably a title ID, so scan the database
                        romname_noExtension = {}
                        romname_noExtension = tostring(file.name:match("(.+)%..+$"))

                            -- LOOKUP TITLE ID: Get game name based on titleID, search saved table of data, or full table of data if titleID not found

                            -- Load previous matches
                            pspdb = dofile(database_rename_PSP)

                            -- Check if scanned titleID is a saved match
                            psp_search = pspdb[romname_noExtension]

                            -- If no
                            if psp_search == nil then

                                -- Load the full database to find the new titleID
                                if next(pspdbfull) == nil then
                                    pspdbfull = dofile("app0:addons/psp.lua")
                                else
                                end
                                psp_search_full = pspdbfull[romname_noExtension]

                                -- If not found; use the folder name without adding a game name
                                if psp_search_full == nil then
                                    title = romname_noExtension

                                -- If found; use the game name from the full database 
                                else
                                    title = pspdbfull[romname_noExtension].name
                                end

                            -- If found; use the game name from the saved match
                            else
                                title = pspdb[romname_noExtension].name
                            end

                        romname_noRegion_noExtension = {}
                        romname_noRegion_noExtension = title:gsub(" %(", "%("):gsub('%b()', '')

                        -- Check if name contains parenthesis, if yes strip out to show as version
                        if string.find(title, "%(") then
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

                        info = romname_noRegion_noExtension
                        app_title = romname_noRegion_noExtension

                        file.filename = file.name
                        file.name = romname_noExtension
                        file.title = romname_noRegion_noExtension
                        file.name_online = file.name
                        file.version = romname_region
                        file.name_title_search = title
                        file.apptitle = romname_noRegion_noExtension

                    end
                    --end of database lookup

                    -- OVERRIDES START

                    local custom_path = {
                        localCoverPath[1] .. app_title .. ".png",
                        localCoverPath[2] .. app_title .. ".png",
                        localCoverPath[3] .. app_title .. ".png",
                        localCoverPath[4] .. app_title .. ".png"
                    }
                    local custom_path_id = {
                        localCoverPath[1] .. file.name .. ".png",
                        localCoverPath[2] .. file.name .. ".png",
                        localCoverPath[3] .. file.name .. ".png",
                        localCoverPath[4] .. file.name .. ".png"
                    }

                    if System.doesFileExist(cur_dir .. "/overrides.dat") then
                        --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                        --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                        -- VITA
                        if string.match(str, file.name .. "=1") then
                            table.insert(games_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=1

                            custom_path = localCoverPath[1] .. app_title .. ".png"
                            custom_path_id = localCoverPath[1] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[1]
                            file.cover_path_local = localCoverPath[1]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psv.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psv.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- PSP
                        elseif string.match(str, file.name .. "=2") then
                            table.insert(psp_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=2

                            custom_path = localCoverPath[2] .. app_title .. ".png"
                            custom_path_id = localCoverPath[2] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[2]
                            file.cover_path_local = localCoverPath[2]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end
                        
                        -- PSX
                        elseif string.match(str, file.name .. "=3") then
                            table.insert(psx_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=3

                            custom_path = localCoverPath[3] .. app_title .. ".png"
                            custom_path_id = localCoverPath[3] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[3]
                            file.cover_path_local = localCoverPath[3]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- HOMEBREW
                        elseif string.match(str, file.name .. "=4") then
                            table.insert(homebrews_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=0

                            custom_path = "ux0:/data/RetroFlow/COVERS/Homebrew/" .. app_title .. ".png"
                            custom_path_id = localCoverPath[4] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[4]
                            file.cover_path_local = localCoverPath[4]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/icon_homebrew.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/icon_homebrew.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- DEFAULT - PSP
                        else
                            table.insert(psp_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=2

                            custom_path = localCoverPath[2] .. app_title .. ".png"
                            custom_path_id = localCoverPath[2] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[2]
                            file.cover_path_local = localCoverPath[2]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
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
                        table.insert(all_games_table, 2, file)
                        file.app_type=2

                        custom_path = localCoverPath[2] .. app_title .. ".png"
                        custom_path_id = localCoverPath[2] .. file.name .. ".png"

                        file.cover_path_online = onlineCoverPathSystem[2]
                        file.cover_path_local = localCoverPath[2]

                        if custom_path and System.doesFileExist(custom_path) then
                            img_path = custom_path --custom cover by app name
                        elseif custom_path_id and System.doesFileExist(custom_path_id) then
                            img_path = custom_path_id --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                    end

                    table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
                    table.insert(files_table, 20, file.name)
                    table.insert(files_table, 20, file.title)
                    table.insert(files_table, 20, file.name_online)
                    table.insert(files_table, 20, file.version)
                    table.insert(files_table, 20, file.name_title_search)

                    --add blank icon to all
                    file.icon = imgCoverTmp
                    file.icon_path = img_path
                    
                    table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)                    
                    table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

                else
                
            end
        end

        -- LOOKUP TITLE ID: Delete old file and save new list of matches

        if not System.doesFileExist(user_DB_Folder .. "psp_iso.lua") then
            CreateUserTitleTable_PSP_iso()
        else
            System.deleteFile(user_DB_Folder .. "psp_iso.lua")
            CreateUserTitleTable_PSP_iso()
        end

    end

    
    -- SCAN PSP - GAME FOLDER
    if  System.doesDirExist(romFolder_PSP_GAME) then

        files_PSP = System.listDirectory(romFolder_PSP_GAME)

        -- LOOKUP TITLE ID: Load saved table of previously macthes titleID's for faster name lookup

        if System.doesFileExist(user_DB_Folder .. "psp_game.lua") then
            database_rename_PSP = user_DB_Folder .. "psp_game.lua"
        else
            database_rename_PSP = "app0:addons/psp.lua"
        end

        for i, file in pairs(files_PSP) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
            if file.directory and System.doesFileExist(romFolder_PSP_GAME .. "/" .. file.name .. "/EBOOT.PBP") then

                -- check if game is in the favorites list
                if System.doesFileExist(cur_dir .. "/favorites.dat") then
                    if string.find(strFav, file.name,1,true) ~= nil then
                        file.favourite = true
                    else
                        file.favourite = false
                    end
                end

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

                    file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. file.name .. "/EBOOT.PBP")
                    file.game_path = (romFolder_PSP_GAME .. "/" .. file.name)

                    romname_withExtension = file.name

                    romname_noExtension = {}
                    romname_noExtension = file.name

                        -- LOOKUP TITLE ID: Get game name based on titleID, search saved table of data, or full table of data if titleID not found

                        -- Load previous matches
                        pspdb = dofile(database_rename_PSP)

                        -- Check if scanned titleID is a saved match
                        psp_search = pspdb[romname_noExtension]

                        -- If no
                        if psp_search == nil then

                            -- Load the full database to find the new titleID
                            if next(pspdbfull) == nil then
                                pspdbfull = dofile("app0:addons/psp.lua")
                            else
                            end
                            psp_search_full = pspdbfull[romname_noExtension]

                            -- If not found; use the folder name without adding a game name
                            if psp_search_full == nil then
                                title = romname_noExtension

                            -- If found; use the game name from the full database 
                            else
                                title = pspdbfull[romname_noExtension].name
                            end

                        -- If found; use the game name from the saved match
                        else
                            title = pspdb[romname_noExtension].name
                        end

                    romname_noRegion_noExtension = {}
                    romname_noRegion_noExtension = title:gsub(" %(", "%("):gsub('%b()', '')

                    -- Check if name contains parenthesis, if yes strip out to show as version
                    if string.find(title, "%(") then
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

                    info = romname_noRegion_noExtension
                    app_title = romname_noRegion_noExtension

                    file.filename = file.name
                    file.name = romname_noExtension
                    file.title = romname_noRegion_noExtension
                    file.name_online = tostring(file.name)
                    file.version = romname_region
                    file.name_title_search = title
                    file.apptitle = romname_noRegion_noExtension
                    file.date_played = 0

                    -- OVERRIDES START

                    if System.doesFileExist(cur_dir .. "/overrides.dat") then
                        --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                        --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                        -- VITA
                        if string.match(str, file.name .. "=1") then
                            table.insert(games_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=1

                            custom_path = localCoverPath[1] .. app_title .. ".png"
                            custom_path_id = localCoverPath[1] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[1]
                            file.cover_path_local = localCoverPath[1]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psv.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psv.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- PSP
                        elseif string.match(str, file.name .. "=2") then
                            table.insert(psp_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=2

                            custom_path = localCoverPath[2] .. app_title .. ".png"
                            custom_path_id = localCoverPath[2] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[2]
                            file.cover_path_local = localCoverPath[2]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end
                        
                        -- PSX
                        elseif string.match(str, file.name .. "=3") then
                            table.insert(psx_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=3

                            custom_path = localCoverPath[3] .. app_title .. ".png"
                            custom_path_id = localCoverPath[3] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[3]
                            file.cover_path_local = localCoverPath[3]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- HOMEBREW
                        elseif string.match(str, file.name .. "=4") then
                            table.insert(homebrews_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=0

                            custom_path = localCoverPath[4] .. app_title .. ".png"
                            custom_path_id = localCoverPath[4] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[4]
                            file.cover_path_local = localCoverPath[4]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/icon_homebrew.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/icon_homebrew.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- DEFAULT - PSP
                        else
                            table.insert(psp_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 2, file)
                            file.app_type=2

                            custom_path = localCoverPath[2] .. app_title .. ".png"
                            custom_path_id = localCoverPath[2] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[2]
                            file.cover_path_local = localCoverPath[2]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
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
                        table.insert(all_games_table, 2, file)
                        file.app_type=2

                        custom_path = localCoverPath[2] .. app_title .. ".png"
                        custom_path_id = localCoverPath[2] .. file.name .. ".png"

                        file.cover_path_online = onlineCoverPathSystem[2]
                        file.cover_path_local = localCoverPath[2]

                        if custom_path and System.doesFileExist(custom_path) then
                            img_path = custom_path --custom cover by app name
                        elseif custom_path_id and System.doesFileExist(custom_path_id) then
                            img_path = custom_path_id --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                    end

                    table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
                    table.insert(files_table, 20, file.name)
                    table.insert(files_table, 20, file.title)
                    table.insert(files_table, 20, file.name_online)
                    table.insert(files_table, 20, file.version)
                    table.insert(files_table, 20, file.name_title_search)

                    --add blank icon to all
                    file.icon = imgCoverTmp
                    file.icon_path = img_path
                    
                    table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)                    
                    table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

                else
                end
                
            end
        end

        -- LOOKUP TITLE ID: Delete old file and save new list of matches

        if not System.doesFileExist(user_DB_Folder .. "psp_game.lua") then
            CreateUserTitleTable_PSP_game()
        else
            System.deleteFile(user_DB_Folder .. "psp_game.lua")
            CreateUserTitleTable_PSP_game()
        end

    end


    -- SCAN PS1 - GAME FOLDER
    if  System.doesDirExist(romFolder_PSP_GAME) then

        files_PSX = System.listDirectory(romFolder_PSP_GAME)

        -- LOOKUP TITLE ID: Load saved table of previously macthes titleID's for faster name lookup

        if System.doesFileExist(user_DB_Folder .. "psx.lua") then
            database_rename_PSX = user_DB_Folder .. "psx.lua"
        else
            database_rename_PSX = "app0:addons/psx.lua"
        end

        for i, file in pairs(files_PSX) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
            if file.directory and System.doesFileExist(romFolder_PSP_GAME .. "/" .. file.name .. "/EBOOT.PBP") then

                -- check if game is in the favorites list
                if System.doesFileExist(cur_dir .. "/favorites.dat") then
                    if string.find(strFav, file.name,1,true) ~= nil then
                        file.favourite = true
                    else
                        file.favourite = false
                    end
                end

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

                    file.launch_argument = ("PATH=ms0:/PSP/GAME/" .. file.name .. "/EBOOT.PBP")
                    file.game_path = (romFolder_PSP_GAME .. "/" .. file.name)

                    romname_withExtension = file.name

                    romname_noExtension = {}
                    romname_noExtension = file.name

                        -- LOOKUP TITLE ID: Get game name based on titleID, search saved table of data, or full table of data if titleID not found

                        -- Load previous matches
                        psxdb = dofile(database_rename_PSX)

                        -- Check if scanned titleID is a saved match
                        psx_search = psxdb[romname_noExtension]

                        -- If no
                        if psx_search == nil then

                            -- Load the full database to find the new titleID
                            if next(psxdbfull) == nil then
                                psxdbfull = dofile("app0:addons/psx.lua")
                            else
                            end
                            psx_search_full = psxdbfull[romname_noExtension]

                            -- If not found; use the folder name without adding a game name
                            if psx_search_full == nil then
                                title = romname_noExtension

                            -- If found; use the game name from the full database 
                            else
                                title = psxdbfull[romname_noExtension].name
                            end

                        -- If found; use the game name from the saved match
                        else
                            title = psxdb[romname_noExtension].name
                        end

                    romname_noRegion_noExtension = {}
                    romname_noRegion_noExtension = title:gsub(" %(", "%("):gsub('%b()', ''):gsub(" %[", "%["):gsub('%b[]', '')

                    -- Check if name contains parenthesis, if yes strip out to show as version
                    if string.find(title, "%(") then
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

                    info = romname_noRegion_noExtension
                    app_title = romname_noRegion_noExtension
                    
                    file.filename = file.name
                    file.name = romname_noExtension
                    file.title = romname_noRegion_noExtension
                    file.name_online = tostring(file.name)
                    file.version = romname_region
                    file.name_title_search = title
                    file.apptitle = romname_noRegion_noExtension
                    file.date_played = 0

                    -- OVERRIDES START

                    if System.doesFileExist(cur_dir .. "/overrides.dat") then
                        --String:   1 vita, 2 psp, 3 psx, 4 homebrew
                        --App_type: 1 vita, 2 psp, 3 psx, 0 homebrew                         

                        -- VITA
                        if string.match(str, file.name .. "=1") then
                            table.insert(games_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 3, file)
                            file.app_type=1

                            custom_path = localCoverPath[1] .. app_title .. ".png"
                            custom_path_id = localCoverPath[1] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[1]
                            file.cover_path_local = localCoverPath[1]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psv.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psv.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- PSP
                        elseif string.match(str, file.name .. "=2") then
                            table.insert(psp_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 3, file)
                            file.app_type=2

                            custom_path = localCoverPath[2] .. app_title .. ".png"
                            custom_path_id = localCoverPath[2] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[2]
                            file.cover_path_local = localCoverPath[2]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end
                        
                        -- PSX
                        elseif string.match(str, file.name .. "=3") then
                            table.insert(psx_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 3, file)
                            file.app_type=3

                            custom_path = localCoverPath[3] .. app_title .. ".png"
                            custom_path_id = localCoverPath[3] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[3]
                            file.cover_path_local = localCoverPath[3]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- HOMEBREW
                        elseif string.match(str, file.name .. "=4") then
                            table.insert(homebrews_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 3, file)
                            file.app_type=0

                            custom_path = localCoverPath[4] .. app_title .. ".png"
                            custom_path_id = localCoverPath[4] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[4]
                            file.cover_path_local = localCoverPath[4]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/icon_homebrew.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/icon_homebrew.png"  --app icon
                                else
                                    img_path = "app0:/DATA/noimg.png" --blank grey
                                end
                            end

                        -- DEFAULT - PSX
                        else
                            table.insert(psx_table, file)

                            table.insert(folders_table, file)
                            table.insert(all_games_table, 3, file)
                            file.app_type=3

                            custom_path = localCoverPath[3] .. app_title .. ".png"
                            custom_path_id = localCoverPath[3] .. file.name .. ".png"

                            file.cover_path_online = onlineCoverPathSystem[3]
                            file.cover_path_local = localCoverPath[3]

                            if custom_path and System.doesFileExist(custom_path) then
                                img_path = custom_path --custom cover by app name
                            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                                img_path = custom_path_id --custom cover by app id
                            else
                                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
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
                        table.insert(all_games_table, 3, file)
                        file.app_type=3

                        custom_path = localCoverPath[3] .. app_title .. ".png"
                        custom_path_id = localCoverPath[3] .. file.name .. ".png"

                        file.cover_path_online = onlineCoverPathSystem[3]
                        file.cover_path_local = localCoverPath[3]
                        
                        if custom_path and System.doesFileExist(custom_path) then
                            img_path = localCoverPath[3] .. file.name .. ".png" --custom cover by app name
                        elseif custom_path_id and System.doesFileExist(custom_path_id) then
                            img_path = localCoverPath[3] .. file.name .. ".png" --custom cover by app id
                        else
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
                            else
                                img_path = "app0:/DATA/noimg.png" --blank grey
                            end
                        end
                    end

                    table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
                    table.insert(files_table, 20, file.name)
                    table.insert(files_table, 20, file.title)
                    table.insert(files_table, 20, file.name_online)
                    table.insert(files_table, 20, file.version)
                    table.insert(files_table, 20, file.name_title_search)

                    --add blank icon to all
                    file.icon = imgCoverTmp
                    file.icon_path = img_path
                    
                    table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)                    
                    table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view

                else
                end

                
            end
        end

        -- LOOKUP TITLE ID: Delete old file and save new list of matches
        if not System.doesFileExist(user_DB_Folder .. "psx.lua") then
            CreateUserTitleTable_PSX()
        else
            System.deleteFile(user_DB_Folder .. "psx.lua")
            CreateUserTitleTable_PSX()
        end

    end


    -- SCAN N64
    files_N64 = System.listDirectory(romFolder_N64)
    for i, file in pairs(files_N64) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_N64 .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[5] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[5] .. romname_noExtension .. ".png"
            file.app_type=5

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(n64_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[5] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[5] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_n64.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_n64.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 4, file)
            file.app_type=5
            file.cover_path_online = onlineCoverPathSystem[5]
            file.cover_path_local = localCoverPath[5]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end



    -- SCAN SNES
    files_SNES = System.listDirectory(romFolder_SNES)
    for i, file in pairs(files_SNES) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_SNES .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[6] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[6] .. romname_noExtension .. ".png"
            file.app_type=6

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(snes_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[6] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[6] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_snes.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_snes.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 5, file)
            file.app_type=6
            file.cover_path_online = onlineCoverPathSystem[6]
            file.cover_path_local = localCoverPath[6]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end


    -- SCAN NES
    files_NES = System.listDirectory(romFolder_NES)
    for i, file in pairs(files_NES) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_NES .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[7] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[7] .. romname_noExtension .. ".png"
            file.app_type=7

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(nes_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[7] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[7] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_nes.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_nes.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 6, file)
            file.app_type=7
            file.cover_path_online = onlineCoverPathSystem[7]
            file.cover_path_local = localCoverPath[7]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN GBA
    files_GBA = System.listDirectory(romFolder_GBA)
    for i, file in pairs(files_GBA) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_GBA .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[8] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[8] .. romname_noExtension .. ".png"
            file.app_type=8

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(gba_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[8] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[8] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_gba.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_gba.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 7, file)
            file.app_type=8
            file.cover_path_online = onlineCoverPathSystem[8]
            file.cover_path_local = localCoverPath[8]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN GBC
    files_GBC = System.listDirectory(romFolder_GBC)
    for i, file in pairs(files_GBC) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_GBC .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[9] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[9] .. romname_noExtension .. ".png"
            file.app_type=9

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(gbc_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[9] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[9] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_gbc.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_gbc.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 8, file)
            file.app_type=9
            file.cover_path_online = onlineCoverPathSystem[9]
            file.cover_path_local = localCoverPath[9]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN GB
    files_GB = System.listDirectory(romFolder_GB)
    for i, file in pairs(files_GB) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_GB .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[10] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[10] .. romname_noExtension .. ".png"
            file.app_type=10

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(gb_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[10] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[10] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_gb.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_gb.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 9, file)
            file.app_type=10
            file.cover_path_online = onlineCoverPathSystem[10]
            file.cover_path_local = localCoverPath[10]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN MD
    files_MD = System.listDirectory(romFolder_MD)
    for i, file in pairs(files_MD) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_MD .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[11] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[11] .. romname_noExtension .. ".png"
            file.app_type=11

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(md_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[11] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[11] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if setLanguage == 1 then
                    if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_md_usa.png") then
                        img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_md_usa.png"  --app icon
                    else
                        img_path = "app0:/DATA/noimg.png" --blank grey
                    end
                else
                    if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_md.png") then
                        img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_md.png"  --app icon
                    else
                        img_path = "app0:/DATA/noimg.png" --blank grey
                    end
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 10, file)
            file.app_type=11
            file.cover_path_online = onlineCoverPathSystem[11]
            file.cover_path_local = localCoverPath[11]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN SMS
    files_SMS = System.listDirectory(romFolder_SMS)
    for i, file in pairs(files_SMS) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_SMS .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[12] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[12] .. romname_noExtension .. ".png"
            file.app_type=12

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(sms_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[12] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[12] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_sms.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_sms.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 11, file)
            file.app_type=12
            file.cover_path_online = onlineCoverPathSystem[12]
            file.cover_path_local = localCoverPath[12]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN GG
    files_GG = System.listDirectory(romFolder_GG)
    for i, file in pairs(files_GG) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_GG .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[13] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[13] .. romname_noExtension .. ".png"
            file.app_type=13

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(gg_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[13] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[13] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_gg.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_gg.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 12, file)
            file.app_type=13
            file.cover_path_online = onlineCoverPathSystem[13]
            file.cover_path_local = localCoverPath[13]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN MAME
    if  System.doesDirExist(romFolder_MAME_2000) then

        files_MAME = System.listDirectory(romFolder_MAME_2000)

        -- LOOKUP TITLE ID: Load saved table of previously macthes titleID's for faster name lookup

        if System.doesFileExist(user_DB_Folder .. "mame.lua") then
            database_rename_MAME = user_DB_Folder .. "mame.lua"
        else
            database_rename_MAME = "app0:addons/mame.lua"
        end

        for i, file in pairs(files_MAME) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version, name_title_search = nil, nil, nil, nil, nil, nil, nil, nil
            -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

                -- check if game is in the favorites list
                if System.doesFileExist(cur_dir .. "/favorites.dat") then
                    if string.find(strFav, file.name,1,true) ~= nil then
                        file.favourite = true
                    else
                        file.favourite = false
                    end
                end

                file.game_path = (romFolder_MAME_2000 .. "/" .. file.name)

                romname_withExtension = file.name
                romname_noExtension = {}
                romname_noExtension = romname_withExtension:match("(.+)%..+$")

                    -- LOOKUP TITLE ID: Get game name based on titleID, search saved table of data, or full table of data if titleID not found

                    -- Load previous matches
                    mamedb = dofile(database_rename_MAME)

                    -- Check if scanned titleID is a saved match
                    mame_search = mamedb[romname_noExtension]

                    -- If no
                    if mame_search == nil then

                        -- Load the full database to find the new titleID
                        if next(mamedbfull) == nil then
                            mamedbfull = dofile("app0:addons/mame.lua")
                        else
                        end
                        mame_search_full = mamedbfull[romname_noExtension]

                        -- If not found; use the folder name without adding a game name
                        if mame_search_full == nil then
                            title = romname_noExtension

                        -- If found; use the game name from the full database 
                        else
                            title = mamedbfull[romname_noExtension].name
                        end

                    -- If found; use the game name from the saved match
                    else
                        title = mamedb[romname_noExtension].name
                    end

                romname_noRegion_noExtension = {}
                romname_noRegion_noExtension = title:gsub('%b()', '')

                -- Check if name contains parenthesis, if yes strip out to show as version
                if string.find(title, "%(") then
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
                
                table.insert(folders_table, file)
                --table.insert(games_table, file)
                custom_path = localCoverPath[14] .. romname_noExtension .. ".png"
                custom_path_id = localCoverPath[14] .. romname_noExtension .. ".png"
                file.app_type=14

                -- file.filename = file.name
                file.filename = romname_withExtension
                file.name = romname_noExtension
                file.title = romname_noRegion_noExtension
                file.name_online = romname_noExtension
                file.version = romname_region
                file.name_title_search = title
                file.date_played = 0

                table.insert(mame_table, file)

                if custom_path and System.doesFileExist(custom_path) then
                    img_path = localCoverPath[14] .. romname_noExtension .. ".png" --custom cover by app name
                elseif custom_path_id and System.doesFileExist(custom_path_id) then
                    img_path = localCoverPath[14] .. romname_noExtension .. ".png" --custom cover by app id
                else
                    if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_mame.png") then
                        img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_mame.png"  --app icon
                    else
                        img_path = "app0:/DATA/noimg.png" --blank grey
                    end
                end

                table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
                table.insert(files_table, 20, file.name)
                table.insert(files_table, 20, file.title)
                table.insert(files_table, 20, file.name_online)
                table.insert(files_table, 20, file.version)
                table.insert(files_table, 20, file.name_title_search)

                -- all games table
                table.insert(all_games_table, 13, file)
                file.app_type=14

                -- file.filename = file.name
                file.filename = romname_withExtension
                file.name = romname_noExtension
                file.cover_path_online = onlineCoverPathSystem[14]
                file.cover_path_local = localCoverPath[14]

                --add blank icon to all
                file.icon = imgCoverTmp
                file.icon_path = img_path
                
                table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
                
                file.apptitle = romname_noRegion_noExtension
                table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

            end
        end

        -- LOOKUP TITLE ID: Delete old file and save new list of matches
        if not System.doesFileExist(user_DB_Folder .. "mame.lua") then
            CreateUserTitleTable_MAME()
        else
            System.deleteFile(user_DB_Folder .. "mame.lua")
            CreateUserTitleTable_MAME()
        end

    end

    -- SCAN AMIGA
    files_AMIGA = System.listDirectory(romFolder_AMIGA)
    for i, file in pairs(files_AMIGA) do
    local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_AMIGA .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[15] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[15] .. romname_noExtension .. ".png"
            file.app_type=15

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(amiga_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[15] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[15] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_amiga.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_amiga.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 14, file)
            file.app_type=15
            file.cover_path_online = onlineCoverPathSystem[15]
            file.cover_path_local = localCoverPath[15]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN TG16
    files_TG16 = System.listDirectory(romFolder_TG16)
    for i, file in pairs(files_TG16) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_TG16 .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[16] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[16] .. romname_noExtension .. ".png"
            file.app_type=16

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(tg16_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[16] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[16] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_tg16.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_tg16.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 15, file)
            file.app_type=16
            file.cover_path_online = onlineCoverPathSystem[16]
            file.cover_path_local = localCoverPath[16]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN TGCD
    files_TGCD = System.listDirectory(romFolder_TGCD)
    for i, file in pairs(files_TGCD) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and string.match(file.name, ".cue") and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_TGCD .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[17] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[17] .. romname_noExtension .. ".png"
            file.app_type=17

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(tgcd_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[17] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[17] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_tgcd.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_tgcd.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 16, file)
            file.app_type=17
            file.cover_path_online = onlineCoverPathSystem[17]
            file.cover_path_local = localCoverPath[17]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN PCE
    files_PCE = System.listDirectory(romFolder_PCE)
    for i, file in pairs(files_PCE) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_PCE .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[18] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[18] .. romname_noExtension .. ".png"
            file.app_type=18

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(pce_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[18] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[18] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_pce.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_pce.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 17, file)
            file.app_type=18
            file.cover_path_online = onlineCoverPathSystem[18]
            file.cover_path_local = localCoverPath[18]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN PCECD
    files_PCECD = System.listDirectory(romFolder_PCECD)
    for i, file in pairs(files_PCECD) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and string.match(file.name, ".cue") and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_PCECD .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[19] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[19] .. romname_noExtension .. ".png"
            file.app_type=19

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(pcecd_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[19] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[19] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_pcecd.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_pcecd.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 18, file)
            file.app_type=19
            file.cover_path_online = onlineCoverPathSystem[19]
            file.cover_path_local = localCoverPath[19]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- SCAN NGPC
    files_NGPC = System.listDirectory(romFolder_NGPC)
    for i, file in pairs(files_NGPC) do
        local custom_path, custom_path_id, app_type, name, title, name_online, version = nil, nil, nil, nil, nil, nil, nil
        -- Scan files only, ignore temporary files, Windows = "Thumbs.db", Mac = "DS_Store", and "._name" 
        if not file.directory and not string.match(file.name, "Thumbs%.db") and not string.match(file.name, "DS_Store") and not string.match(file.name, "%._") then

            -- check if game is in the favorites list
            if System.doesFileExist(cur_dir .. "/favorites.dat") then
                if string.find(strFav, file.name,1,true) ~= nil then
                    file.favourite = true
                else
                    file.favourite = false
                end
            end

            file.game_path = (romFolder_NGPC .. "/" .. file.name)

            romname_withExtension = file.name
            cleanRomNames()
            info = romname_noRegion_noExtension
            app_title = romname_noExtension
            
            table.insert(folders_table, file)
            --table.insert(games_table, file)
            custom_path = localCoverPath[20] .. romname_noExtension .. ".png"
            custom_path_id = localCoverPath[20] .. romname_noExtension .. ".png"
            file.app_type=20

            file.filename = file.name
            file.name = romname_noExtension
            file.title = romname_noRegion_noExtension
            file.name_online = romname_url_encoded
            file.version = romname_region
            file.date_played = 0

            table.insert(ngpc_table, file)

            if custom_path and System.doesFileExist(custom_path) then
                img_path = localCoverPath[20] .. romname_noExtension .. ".png" --custom cover by app name
            elseif custom_path_id and System.doesFileExist(custom_path_id) then
                img_path = localCoverPath[20] .. romname_noExtension .. ".png" --custom cover by app id
            else
                if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_ngpc.png") then
                    img_path = "ux0:/app/RETROFLOW/DATA/missing_cover_ngpc.png"  --app icon
                else
                    img_path = "app0:/DATA/noimg.png" --blank grey
                end
            end

            table.insert(files_table, 20, file.app_type) -- Increased for Retro (All systems + 1 for all view)
            table.insert(files_table, 20, file.name)
            table.insert(files_table, 20, file.title)
            table.insert(files_table, 20, file.name_online)
            table.insert(files_table, 20, file.version)

            -- all games table
            table.insert(all_games_table, 19, file)
            file.app_type=20
            file.cover_path_online = onlineCoverPathSystem[20]
            file.cover_path_local = localCoverPath[20]

            --add blank icon to all
            file.icon = imgCoverTmp
            file.icon_path = img_path
            
            table.insert(files_table, 20, file.icon) -- Increased for Retro (All systems + 1 for all view)
            
            file.apptitle = romname_noRegion_noExtension
            table.insert(files_table, 20, file.apptitle) -- Increased for Retro (All systems + 1 for all view)

        end
    end

    -- RECENTLY PLAYED
    if System.doesFileExist("ux0:/data/RetroFlow/recently_played.lua") then
        db_Cache_recently_played = "ux0:/data/RetroFlow/recently_played.lua"

        local db_recently_played = {}
        db_recently_played = dofile(db_Cache_recently_played)

        for k, v in ipairs(db_recently_played) do
            -- Check rom exists
            -- If file
            if v.directory == false then
                if System.doesFileExist(v.game_path) then
                    if showHomebrews == 0 then
                         -- ignore homebrew apps
                        if v.app_type > 0 then
                            table.insert(recently_played_table, v)
                            --add blank icon to all
                            v.icon = imgCoverTmp
                            v.icon_path = v.icon_path
                            v.apptitle = v.apptitle
                        else
                        end
                    else
                    -- Import all
                        table.insert(recently_played_table, v)
                        --add blank icon to all
                        v.icon = imgCoverTmp
                        v.icon_path = v.icon_path
                        v.apptitle = v.apptitle
                    end
                else
                end
            else
                -- Not file, is folder
                if System.doesDirExist(v.game_path) then
                    if showHomebrews == 0 then
                         -- ignore homebrew apps
                        if v.app_type > 0 then
                            table.insert(recently_played_table, v)
                            --add blank icon to all
                            v.icon = imgCoverTmp
                            v.icon_path = v.icon_path
                            v.apptitle = v.apptitle
                        else
                        end
                    else
                    -- Import all
                        table.insert(recently_played_table, v)
                        --add blank icon to all
                        v.icon = imgCoverTmp
                        v.icon_path = v.icon_path
                        v.apptitle = v.apptitle
                    end
                else
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
                        if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                            v.icon_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
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
                        if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                            v.icon_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
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
                end
            end
        end

    end

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
    table.sort(md_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(sms_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gg_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(mame_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(amiga_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tg16_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tgcd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pce_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pcecd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(ngpc_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(recently_played_table, function(a, b) return (tonumber(a.date_played) > tonumber(b.date_played)) end)

    table.sort(all_games_table, function(a, b) return (a.app_type < b.app_type) end)
    
    return_table = TableConcat(folders_table, files_table)
    
    total_all = #files_table
    total_games = #games_table
    total_homebrews = #homebrews_table
    total_recently_played = #recently_played_table

    -- CACHE ALL TABLES - PRINT AND SAVE
    cache_all_tables()

    return return_table
end

function import_cached_DB(dir)
    dir = System.listDirectory(dir)
    folders_table = {}
    files_table = {}
    games_table = {}
    psp_table = {}
    psx_table = {}
    n64_table = {}
    snes_table = {}
    nes_table = {}
    gba_table = {}
    gbc_table = {}
    gb_table = {}
    md_table = {}
    sms_table = {}
    gg_table = {}
    mame_table = {}
    amiga_table = {}
    tg16_table = {}
    tgcd_table = {}
    pce_table = {}
    pcecd_table = {}
    ngpc_table = {}
    homebrews_table = {}
    all_games_table = {}
    recently_played_table = {}

    local file_over = System.openFile(cur_dir .. "/overrides.dat", FREAD)
    local filesize = System.sizeFile(file_over)
    local str = System.readFile(file_over, filesize)
    System.closeFile(file_over)

    -- Import cached DB: games
    if System.doesFileExist(db_Cache_Folder .. "db_games.lua") then
        db_Cache_games = db_Cache_Folder .. "db_games.lua"

        local db_games = {}
        db_games = dofile(db_Cache_games)

        for k, v in ipairs(db_games) do
            table.insert(folders_table, v)
            table.insert(games_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path

            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: homebrew
    if showHomebrews == 1 then
        if System.doesFileExist(db_Cache_Folder .. "db_homebrews.lua") then
            db_Cache_homebrews = db_Cache_Folder .. "db_homebrews.lua"

            db_homebrews = dofile(db_Cache_homebrews)

            for k, v in ipairs(db_homebrews) do
                table.insert(folders_table, v)
                table.insert(homebrews_table, v)
                table.insert(all_games_table, v)

                --add blank icon to all
                v.icon = imgCoverTmp
                v.icon_path = v.icon_path

                v.apptitle = v.apptitle
                table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
            end
        end
    else
    end

    -- Import cached DB: psp
    if System.doesFileExist(db_Cache_Folder .. "db_psp.lua") then
        db_Cache_psp = db_Cache_Folder .. "db_psp.lua"

        db_psp = dofile(db_Cache_psp)

        for k, v in ipairs(db_psp) do
            table.insert(folders_table, v)
            table.insert(psp_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: psx
    if System.doesFileExist(db_Cache_Folder .. "db_psx.lua") then
        db_Cache_psx = db_Cache_Folder .. "db_psx.lua"

        db_psx = dofile(db_Cache_psx)

        for k, v in ipairs(db_psx) do
            table.insert(folders_table, v)
            table.insert(psx_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: N64
    if System.doesFileExist(db_Cache_Folder .. "db_n64.lua") then
        db_Cache_n64 = db_Cache_Folder .. "db_n64.lua"
        
        db_n64 = dofile(db_Cache_n64)

        for k, v in ipairs(db_n64) do
            table.insert(folders_table, v)
            table.insert(n64_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: snes
    if System.doesFileExist(db_Cache_Folder .. "db_snes.lua") then
        db_Cache_snes = db_Cache_Folder .. "db_snes.lua"

        db_snes = dofile(db_Cache_snes)

        for k, v in ipairs(db_snes) do
            table.insert(folders_table, v)
            table.insert(snes_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: nes
    if System.doesFileExist(db_Cache_Folder .. "db_nes.lua") then
        db_Cache_nes = db_Cache_Folder .. "db_nes.lua"

        db_nes = dofile(db_Cache_nes)

        for k, v in ipairs(db_nes) do
            table.insert(folders_table, v)
            table.insert(nes_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: gba
    if System.doesFileExist(db_Cache_Folder .. "db_gba.lua") then
        db_Cache_gba = db_Cache_Folder .. "db_gba.lua"

        db_gba = dofile(db_Cache_gba)

        for k, v in ipairs(db_gba) do
            table.insert(folders_table, v)
            table.insert(gba_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: gbc
    if System.doesFileExist(db_Cache_Folder .. "db_gbc.lua") then
        db_Cache_gbc = db_Cache_Folder .. "db_gbc.lua"

        db_gbc = dofile(db_Cache_gbc)

        for k, v in ipairs(db_gbc) do
            table.insert(folders_table, v)
            table.insert(gbc_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: gb
    if System.doesFileExist(db_Cache_Folder .. "db_gb.lua") then
        db_Cache_gb = db_Cache_Folder .. "db_gb.lua"

        db_gb = dofile(db_Cache_gb)

        for k, v in ipairs(db_gb) do
            table.insert(folders_table, v)
            table.insert(gb_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: md
    if System.doesFileExist(db_Cache_Folder .. "db_md.lua") then
        db_Cache_md = db_Cache_Folder .. "db_md.lua"

        db_md = dofile(db_Cache_md)

        for k, v in ipairs(db_md) do
            table.insert(folders_table, v)
            table.insert(md_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: sms
    if System.doesFileExist(db_Cache_Folder .. "db_sms.lua") then
        db_Cache_sms = db_Cache_Folder .. "db_sms.lua"

        db_sms = dofile(db_Cache_sms)

        for k, v in ipairs(db_sms) do
            table.insert(folders_table, v)
            table.insert(sms_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: gg
    if System.doesFileExist(db_Cache_Folder .. "db_gg.lua") then
        db_Cache_gg = db_Cache_Folder .. "db_gg.lua"

        db_gg = dofile(db_Cache_gg)

        for k, v in ipairs(db_gg) do
            table.insert(folders_table, v)
            table.insert(gg_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: mame
    if System.doesFileExist(db_Cache_Folder .. "db_mame.lua") then
        db_Cache_mame = db_Cache_Folder .. "db_mame.lua"

        db_mame = dofile(db_Cache_mame)

        for k, v in ipairs(db_mame) do
            table.insert(folders_table, v)
            table.insert(mame_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: amiga
    if System.doesFileExist(db_Cache_Folder .. "db_amiga.lua") then
        db_Cache_amiga = db_Cache_Folder .. "db_amiga.lua"

        db_amiga = dofile(db_Cache_amiga)

        for k, v in ipairs(db_amiga) do
            table.insert(folders_table, v)
            table.insert(amiga_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: tg16
    if System.doesFileExist(db_Cache_Folder .. "db_tg16.lua") then
        db_Cache_tg16 = db_Cache_Folder .. "db_tg16.lua"

        db_tg16 = dofile(db_Cache_tg16)

        for k, v in ipairs(db_tg16) do
            table.insert(folders_table, v)
            table.insert(tg16_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: tgcd
    if System.doesFileExist(db_Cache_Folder .. "db_tgcd.lua") then
        db_Cache_tgcd = db_Cache_Folder .. "db_tgcd.lua"

        db_tgcd = dofile(db_Cache_tgcd)

        for k, v in ipairs(db_tgcd) do
            table.insert(folders_table, v)
            table.insert(tgcd_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: pce
    if System.doesFileExist(db_Cache_Folder .. "db_pce.lua") then
        db_Cache_pce = db_Cache_Folder .. "db_pce.lua"

        db_pce = dofile(db_Cache_pce)

        for k, v in ipairs(db_pce) do
            table.insert(folders_table, v)
            table.insert(pce_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: pcecd
    if System.doesFileExist(db_Cache_Folder .. "db_pcecd.lua") then
        db_Cache_pcecd = db_Cache_Folder .. "db_pcecd.lua"

        db_pcecd = dofile(db_Cache_pcecd)

        for k, v in ipairs(db_pcecd) do
            table.insert(folders_table, v)
            table.insert(pcecd_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: ngpc
    if System.doesFileExist(db_Cache_Folder .. "db_ngpc.lua") then
        db_Cache_ngpc = db_Cache_Folder .. "db_ngpc.lua"

        db_ngpc = dofile(db_Cache_ngpc)

        for k, v in ipairs(db_ngpc) do
            table.insert(folders_table, v)
            table.insert(ngpc_table, v)
            table.insert(all_games_table, v)

            --add blank icon to all
            v.icon = imgCoverTmp
            v.icon_path = v.icon_path
                        
            v.apptitle = v.apptitle
            table.insert(files_table, 20, v.apptitle) -- Increased for Retro (All systems + 1 for all view)
        end
    end

    -- Import cached DB: recently played
    if showRecentlyPlayed == 1 then
        if System.doesFileExist("ux0:/data/RetroFlow/recently_played.lua") then
            db_Cache_recently_played = "ux0:/data/RetroFlow/recently_played.lua"

            local db_recently_played = {}
            db_recently_played = dofile(db_Cache_recently_played)

            for k, v in ipairs(db_recently_played) do
                -- Check rom exists
                -- If file
                if v.directory == false then
                    if System.doesFileExist(v.game_path) then
                        if showHomebrews == 0 then
                             -- ignore homebrew apps
                            if v.app_type > 0 then
                                table.insert(recently_played_table, v)
                                --add blank icon to all
                                v.icon = imgCoverTmp
                                v.icon_path = v.icon_path
                                v.apptitle = v.apptitle
                            else
                            end
                        else
                        -- Import all
                            table.insert(recently_played_table, v)
                            --add blank icon to all
                            v.icon = imgCoverTmp
                            v.icon_path = v.icon_path
                            v.apptitle = v.apptitle
                        end
                    else
                    end
                else
                    -- Not file, is folder
                    if System.doesDirExist(v.game_path) then
                        if showHomebrews == 0 then
                             -- ignore homebrew apps
                            if v.app_type > 0 then
                                table.insert(recently_played_table, v)
                                --add blank icon to all
                                v.icon = imgCoverTmp
                                v.icon_path = v.icon_path
                                v.apptitle = v.apptitle
                            else
                            end
                        else
                        -- Import all
                            table.insert(recently_played_table, v)
                            --add blank icon to all
                            v.icon = imgCoverTmp
                            v.icon_path = v.icon_path
                            v.apptitle = v.apptitle
                        end
                    else
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
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psp.png") then
                                v.icon_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psp.png"  --app icon
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
                            if System.doesFileExist("ux0:/app/RETROFLOW/DATA/missing_cover_psx.png") then
                                v.icon_path = "ux0:/app/RETROFLOW/DATA/missing_cover_psx.png"  --app icon
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
                    end
                end
            end


        end
    else
    end

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
    table.sort(md_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(sms_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(gg_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(mame_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(amiga_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tg16_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(tgcd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pce_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(pcecd_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(ngpc_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(recently_played_table, function(a, b) return (tonumber(a.date_played) > tonumber(b.date_played)) end)

    table.sort(all_games_table, function(a, b) return (a.app_type < b.app_type) end)

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
    files_table = listDirectory(System.currentDirectory())
else
    -- Startup scan is OFF

    -- Check cache files before importing, does the folder exist?
    if  System.doesDirExist(db_Cache_Folder) then

        -- Folder exists - Count files
        cache_file_count = System.listDirectory(db_Cache_Folder)
        if #cache_file_count < cache_file_count_expected then -- 23 tables expected
            -- Files missing - rescan
            files_table = listDirectory(System.currentDirectory())
        else
            -- Files all pesent - Import Cached Database
            files_table = import_cached_DB(System.currentDirectory())
        end
    else
        -- Folder missing - rescan
        files_table = listDirectory(System.currentDirectory())
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
end


function GetInfoSelected()
    if showCat == 1 then
        if #games_table > 0 then
            info = games_table[p].name

            if string.match (games_table[p].game_path, "ux0:/pspemu") then
                icon_path = "ux0:/app/RETROFLOW/DATA/icon_psv.png"
            else
                icon_path = "ur0:/appmeta/" .. games_table[p].name .. "/icon0.png"
            end

            pic_path = "ur0:/appmeta/" .. games_table[p].name .. "/pic0.png"
            app_title = games_table[p].title
            apptype = games_table[p].app_type
            appdir = games_table[p].game_path
            folder = games_table[p].directory
            filename = games_table[p].filename
            favourite_flag = games_table[p].favourite

            app_titleid = games_table[p].name
            app_version = games_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 2 then
        if #homebrews_table > 0 then
            info = homebrews_table[p].name
            icon_path = homebrews_table[p].icon_path

            -- if string.match (homebrews_table[p].icon_path, "ux0:/pspemu") then
            --     icon_path = "ux0:/app/RETROFLOW/DATA/icon_homebrew.png"
            -- else
            --     icon_path = homebrews_table[p].icon_path
            -- end

            pic_path = "ur0:/appmeta/" .. homebrews_table[p].name .. "/pic0.png"
            app_title = homebrews_table[p].title
            apptype = homebrews_table[p].app_type
            appdir = homebrews_table[p].game_path
            folder = homebrews_table[p].directory
            filename = homebrews_table[p].filename
            favourite_flag = homebrews_table[p].favourite

            app_titleid = homebrews_table[p].name
            app_version = homebrews_table[p].version
        else
            app_title = "-"
        end

    elseif showCat == 3 then
        if #psp_table > 0 then
            info = psp_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_psp.png"
            pic_path = "-"
            app_title = psp_table[p].title
            apptype = psp_table[p].app_type
            appdir = psp_table[p].game_path
            folder = psp_table[p].directory
            filename = psp_table[p].filename
            favourite_flag = psp_table[p].favourite

            app_titleid = psp_table[p].name
            app_version = psp_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 4 then
        if #psx_table > 0 then
            info = psx_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_psx.png"
            pic_path = "-"
            app_title = psx_table[p].title
            apptype = psx_table[p].app_type
            appdir = psx_table[p].game_path
            folder = psx_table[p].directory
            filename = psx_table[p].filename
            favourite_flag = psx_table[p].favourite

            app_titleid = psx_table[p].name
            app_version = psx_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 5 then
        if #n64_table > 0 then
            info = n64_table[p].name            
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_n64.png"
            pic_path = "-"
            app_title = n64_table[p].title
            apptype = n64_table[p].app_type
            appdir = n64_table[p].game_path
            folder = n64_table[p].directory
            filename = n64_table[p].filename
            favourite_flag = n64_table[p].favourite

            app_titleid = n64_table[p].name
            app_version = n64_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 6 then
        if #snes_table > 0 then
            info = snes_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_snes.png"
            pic_path = "-"
            app_title = snes_table[p].title
            apptype = snes_table[p].app_type
            appdir = snes_table[p].game_path
            folder = snes_table[p].directory
            filename = snes_table[p].filename
            favourite_flag = snes_table[p].favourite

            app_titleid = snes_table[p].name
            app_version = snes_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 7 then
        if #nes_table > 0 then
            info = nes_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_nes.png"
            pic_path = "-"
            app_title = nes_table[p].title
            apptype = nes_table[p].app_type
            appdir = nes_table[p].game_path
            folder = nes_table[p].directory
            filename = nes_table[p].filename
            favourite_flag = nes_table[p].favourite

            app_titleid = nes_table[p].name
            app_version = nes_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 8 then
        if #gba_table > 0 then
            info = gba_table[p].name            
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_gba.png"
            pic_path = "-"
            app_title = gba_table[p].title
            apptype = gba_table[p].app_type
            appdir = gba_table[p].game_path
            folder = gba_table[p].directory
            filename = gba_table[p].filename
            favourite_flag = gba_table[p].favourite

            app_titleid = gba_table[p].name
            app_version = gba_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 9 then
        if #gbc_table > 0 then
            info = gbc_table[p].name            
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_gbc.png"
            pic_path = "-"
            app_title = gbc_table[p].title
            apptype = gbc_table[p].app_type
            appdir = gbc_table[p].game_path
            folder = gbc_table[p].directory
            filename = gbc_table[p].filename
            favourite_flag = gbc_table[p].favourite

            app_titleid = gbc_table[p].name
            app_version = gbc_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 10 then
        if #gb_table > 0 then
            info = gb_table[p].name            
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_gb.png"
            pic_path = "-"
            app_title = gb_table[p].title
            apptype = gb_table[p].app_type
            appdir = gb_table[p].game_path
            folder = gb_table[p].directory
            filename = gb_table[p].filename
            favourite_flag = gb_table[p].favourite

            app_titleid = gb_table[p].name
            app_version = gb_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 11 then
        if #md_table > 0 then
            info = md_table[p].name
            if setLanguage == 1 then
                icon_path = "ux0:/app/RETROFLOW/DATA/icon_md_usa.png"
            else
                icon_path = "ux0:/app/RETROFLOW/DATA/icon_md.png"
            end
            pic_path = "-"
            app_title = md_table[p].title
            apptype = md_table[p].app_type
            appdir = md_table[p].game_path
            folder = md_table[p].directory
            filename = md_table[p].filename
            favourite_flag = md_table[p].favourite

            app_titleid = md_table[p].name
            app_version = md_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 12 then
        if #sms_table > 0 then
            info = sms_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_sms.png"
            pic_path = "-"
            app_title = sms_table[p].title
            apptype = sms_table[p].app_type
            appdir = sms_table[p].game_path
            folder = sms_table[p].directory
            filename = sms_table[p].filename
            favourite_flag = sms_table[p].favourite

            app_titleid = sms_table[p].name
            app_version = sms_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 13 then
        if #gg_table > 0 then
            info = gg_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_gg.png"
            pic_path = "-"
            app_title = gg_table[p].title
            apptype = gg_table[p].app_type
            appdir = gg_table[p].game_path
            folder = gg_table[p].directory
            filename = gg_table[p].filename
            favourite_flag = gg_table[p].favourite

            app_titleid = gg_table[p].name
            app_version = gg_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 14 then
        if #mame_table > 0 then
            info = mame_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_mame.png"
            pic_path = "-"
            app_title = mame_table[p].title
            apptype = mame_table[p].app_type
            appdir = mame_table[p].game_path
            folder = mame_table[p].directory
            filename = mame_table[p].filename
            favourite_flag = mame_table[p].favourite

            app_titleid = mame_table[p].name
            app_version = mame_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 15 then
        if #amiga_table > 0 then
            info = amiga_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_amiga.png"
            pic_path = "-"
            app_title = amiga_table[p].title
            apptype = amiga_table[p].app_type
            appdir = amiga_table[p].game_path
            folder = amiga_table[p].directory
            filename = amiga_table[p].filename
            favourite_flag = amiga_table[p].favourite

            app_titleid = amiga_table[p].name
            app_version = amiga_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 16 then
        if #tg16_table > 0 then
            info = tg16_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_tg16.png"
            pic_path = "-"
            app_title = tg16_table[p].title
            apptype = tg16_table[p].app_type
            appdir = tg16_table[p].game_path
            folder = tg16_table[p].directory
            filename = tg16_table[p].filename
            favourite_flag = tg16_table[p].favourite

            app_titleid = tg16_table[p].name
            app_version = tg16_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 17 then
        if #tgcd_table > 0 then
            info = tgcd_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_tgcd.png"
            pic_path = "-"
            app_title = tgcd_table[p].title
            apptype = tgcd_table[p].app_type
            appdir = tgcd_table[p].game_path
            folder = tgcd_table[p].directory
            filename = tgcd_table[p].filename
            favourite_flag = tgcd_table[p].favourite

            app_titleid = tgcd_table[p].name
            app_version = tgcd_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 18 then
        if #pce_table > 0 then
            info = pce_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_pce.png"
            pic_path = "-"
            app_title = pce_table[p].title
            apptype = pce_table[p].app_type
            appdir = pce_table[p].game_path
            folder = pce_table[p].directory
            filename = pce_table[p].filename
            favourite_flag = pce_table[p].favourite

            app_titleid = pce_table[p].name
            app_version = pce_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 19 then
        if #pcecd_table > 0 then
            info = pcecd_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_pcecd.png"
            pic_path = "-"
            app_title = pcecd_table[p].title
            apptype = pcecd_table[p].app_type
            appdir = pcecd_table[p].game_path
            folder = pcecd_table[p].directory
            filename = pcecd_table[p].filename
            favourite_flag = pcecd_table[p].favourite

            app_titleid = pcecd_table[p].name
            app_version = pcecd_table[p].version
        else
            app_title = "-"
        end
    elseif showCat == 20 then
        if #ngpc_table > 0 then
            info = ngpc_table[p].name
            icon_path = "ux0:/app/RETROFLOW/DATA/icon_ngpc.png"
            pic_path = "-"
            app_title = ngpc_table[p].title
            apptype = ngpc_table[p].app_type
            appdir = ngpc_table[p].game_path
            folder = ngpc_table[p].directory
            filename = ngpc_table[p].filename
            favourite_flag = ngpc_table[p].favourite

            app_titleid = ngpc_table[p].name
            app_version = ngpc_table[p].version
        else
            app_title = "-"
        end


    elseif showCat == 21 then

        -- count favorites
        fav_count = {}
        for l, file in pairs(files_table) do
            if file.favourite==true then
                if showHomebrews == 0 then
                    -- ignore homebrew apps
                    if file.app_type > 0 then
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
            end
        end

        if #fav_count > 0 then
            info = fav_count[p].name
            app_title = fav_count[p].title
            apptype = fav_count[p].app_type
            appdir = fav_count[p].game_path
            folder = fav_count[p].directory
            filename = fav_count[p].filename
            favourite_flag = fav_count[p].favourite

            app_titleid = fav_count[p].name
            app_version = fav_count[p].version

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. fav_count[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. fav_count[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. fav_count[p].name .. "/pic0.png"

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. fav_count[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = fav_count[p].icon_path
                pic_path = ""
            else
                pic_path = "-"
                icon_path = fav_count[p].icon_path

                if apptype==1 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gb.png"
                elseif apptype==11 then -- MD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_md.png"
                elseif apptype==12 then -- SMS
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_sms.png"
                elseif apptype==13 then -- GG
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gg.png"
                elseif apptype==14 then -- MAME
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_mame.png"
                elseif apptype==15 then -- AMIGA
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_amiga.png"
                elseif apptype==16 then -- TG16
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_tg16.png"
                elseif apptype==17 then -- TGCD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_tgcd.png"
                elseif apptype==18 then -- PCE
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_pce.png"
                elseif apptype==19 then -- PCECD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_pcecd.png"
                elseif apptype==20 then -- NGPC
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_ngpc.png"
                else
                    icon_path = fav_count[p].icon_path
                end

            end
        else
            -- app_title = "-"
        end

    elseif showCat == 22 then

        if #recently_played_table > 0 then
            info = recently_played_table[p].name
            app_title = recently_played_table[p].title
            apptype = recently_played_table[p].app_type
            appdir = recently_played_table[p].game_path
            folder = recently_played_table[p].directory
            filename = recently_played_table[p].filename
            favourite_flag = recently_played_table[p].favourite

            app_titleid = recently_played_table[p].name
            app_version = recently_played_table[p].version

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. recently_played_table[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. recently_played_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. recently_played_table[p].name .. "/pic0.png"

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. recently_played_table[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = recently_played_table[p].icon_path
                pic_path = ""
            else
                pic_path = "-"
                icon_path = recently_played_table[p].icon_path

                if apptype==1 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gb.png"
                elseif apptype==11 then -- MD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_md.png"
                elseif apptype==12 then -- SMS
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_sms.png"
                elseif apptype==13 then -- GG
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gg.png"
                elseif apptype==14 then -- MAME
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_mame.png"
                elseif apptype==15 then -- AMIGA
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_amiga.png"
                elseif apptype==16 then -- TG16
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_tg16.png"
                elseif apptype==17 then -- TGCD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_tgcd.png"
                elseif apptype==18 then -- PCE
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_pce.png"
                elseif apptype==19 then -- PCECD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_pcecd.png"
                elseif apptype==20 then -- NGPC
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_ngpc.png"
                else
                    icon_path = recently_played_table[p].icon_path
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

            app_titleid = files_table[p].name
            app_version = files_table[p].version

            -- Vita
            if System.doesFileExist(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo") and apptype==1 then
                icon_path = "ur0:/appmeta/" .. files_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. files_table[p].name .. "/pic0.png"

            -- Homebrew 
            elseif System.doesFileExist(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo") and apptype==0 then
                icon_path = files_table[p].icon_path
                pic_path = ""
            else
                pic_path = "-"
                icon_path = files_table[p].icon_path

                if apptype==1 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psv.png"
                elseif apptype==2 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psp.png"
                elseif apptype==3 then
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_psx.png"
                elseif apptype==5 then -- N64
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_n64.png"
                elseif apptype==6 then -- SNES
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_snes.png"
                elseif apptype==7 then -- NES
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_nes.png"
                elseif apptype==8 then -- GBA
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gba.png"
                elseif apptype==9 then -- GBC
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gbc.png"
                elseif apptype==10 then -- GB
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gb.png"
                elseif apptype==11 then -- MD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_md.png"
                elseif apptype==12 then -- SMS
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_sms.png"
                elseif apptype==13 then -- GG
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_gg.png"
                elseif apptype==14 then -- MAME
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_mame.png"
                elseif apptype==15 then -- AMIGA
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_amiga.png"
                elseif apptype==16 then -- TG16
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_tg16.png"
                elseif apptype==17 then -- TGCD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_tgcd.png"
                elseif apptype==18 then -- PCE
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_pce.png"
                elseif apptype==19 then -- PCECD
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_pcecd.png"
                elseif apptype==20 then -- NGPC
                    icon_path = "ux0:/app/RETROFLOW/DATA/icon_ngpc.png"
                else
                    icon_path = files_table[p].icon_path
                end

            end
        else
            -- app_title = "-"
        end
    end
end


function update_recently_played_table_favorite_false()
    for k, v in pairs(recently_played_table) do
        if v.filename==filename then
            v.favourite=false
        end
    end
end

function update_recently_played_table_favorite_true()
    for k, v in pairs(recently_played_table) do
        if v.filename==filename then
            v.favourite=true
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
        if showCat == 1 then 
            if games_table[p].favourite == true then 
                games_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                games_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_games()
        elseif showCat == 2 then 
            if homebrews_table[p].favourite == true then
                homebrews_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                homebrews_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_homebrews()
        elseif showCat == 3 then 
            if psp_table[p].favourite == true then
                psp_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                psp_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_psp()
        elseif showCat == 4 then 
            if psx_table[p].favourite == true then 
                psx_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                psx_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_psx()
        elseif showCat == 5 then 
            if n64_table[p].favourite == true then 
                n64_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                n64_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_n64()
        elseif showCat == 6 then 
            if snes_table[p].favourite == true then 
                snes_table[p].favourite=false 
                update_recently_played_table_favorite_false()
            else
                snes_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_snes()
        elseif showCat == 7 then 
            if nes_table[p].favourite == true then 
                nes_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                nes_table[p].favourite=true 
            end
            update_cached_table_nes()
        elseif showCat == 8 then 
            if gba_table[p].favourite == true then 
                gba_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                gba_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_gba()
        elseif showCat == 9 then 
            if gbc_table[p].favourite == true then 
                gbc_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                gbc_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_gbc()
        elseif showCat == 10 then 
            if gb_table[p].favourite == true then 
                gb_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                gb_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_gb()
        elseif showCat == 11 then 
            if md_table[p].favourite == true then 
                md_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                md_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_md()
        elseif showCat == 12 then 
            if sms_table[p].favourite == true then 
                sms_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                sms_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_sms()
        elseif showCat == 13 then 
            if gg_table[p].favourite == true then 
                gg_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                gg_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_gg()
        elseif showCat == 14 then 
            if mame_table[p].favourite == true then 
                mame_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                mame_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_mame()
        elseif showCat == 15 then 
            if amiga_table[p].favourite == true then 
                amiga_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                amiga_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_amiga()
        elseif showCat == 16 then 
            if tg16_table[p].favourite == true then 
                tg16_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                tg16_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_tg16()
        elseif showCat == 17 then 
            if tgcd_table[p].favourite == true then 
                tgcd_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                tgcd_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_tgcd()
        elseif showCat == 18 then 
            if pce_table[p].favourite == true then 
                pce_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                pce_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_pce()
        elseif showCat == 19 then 
            if pcecd_table[p].favourite == true then 
                pcecd_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                pcecd_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_pcecd()
        elseif showCat == 20 then 
            if ngpc_table[p].favourite == true then 
                ngpc_table[p].favourite=false
                update_recently_played_table_favorite_false()
            else
                ngpc_table[p].favourite=true
                update_recently_played_table_favorite_true()
            end
            update_cached_table_ngpc()

        elseif showCat == 21 then

            -- Find game in other tables and update
            -- VITA
            if apptype == 1 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(games_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(games_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_games()
            -- PSP    
            elseif apptype == 2 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(psp_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(psp_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_psp()
            -- PSX    
            elseif apptype == 3 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(psx_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(psx_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_psx()
            -- HOMEBREW    
            elseif apptype == 4 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(homebrews_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(homebrews_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_homebrews()    
                
            --N64
            elseif apptype == 5 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(n64_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(n64_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_n64()
            --SNES
            elseif apptype == 6 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(snes_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(snes_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_snes()
            --NES
            elseif apptype == 7 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(nes_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(nes_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_nes()
            --GBA
            elseif apptype == 8 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(gba_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(gba_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gba()
            --GBC
            elseif apptype == 9 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(gbc_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(gbc_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_gbc()
            --GB
            elseif apptype == 10 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(gb_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(gb_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_gb()
            --MD
            elseif apptype == 11 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(md_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(md_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_md()
            --SMS
            elseif apptype == 12 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(sms_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(sms_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_sms()
            --GG
            elseif apptype == 13 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(gg_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(gg_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_gg()
            --MAME
            elseif apptype == 14 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(mame_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(mame_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_mame()
            --AMIGA
            elseif apptype == 15 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(amiga_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(amiga_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_amiga()
            --TG16
            elseif apptype == 16 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(tg16_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(tg16_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_tg16()
            --TGCD
            elseif apptype == 17 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(tgcd_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(tgcd_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_tgcd()
            --PCE
            elseif apptype == 18 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(pce_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(pce_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_pce()
            --PCECD
            elseif apptype == 19 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(pcecd_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(pcecd_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_pcecd()
            --NGPC
            elseif apptype == 20 then
                if fav_count[p].favourite == true then
                    fav_count[p].favourite=false
                    for k, v in pairs(ngpc_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                    update_recently_played_table_favorite_false()
                else
                    fav_count[p].favourite=true
                    for k, v in pairs(ngpc_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                    update_recently_played_table_favorite_true()
                end
                update_cached_table_ngpc()
            else    
            end

        elseif showCat == 22 then

            -- Find game in other tables and update
            -- VITA
            if apptype == 1 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(games_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(games_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_games()
            -- PSP    
            elseif apptype == 2 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(psp_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(psp_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_psp()
            -- PSX    
            elseif apptype == 3 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(psx_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(psx_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_psx()
            -- HOMEBREW    
            elseif apptype == 4 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(homebrews_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(homebrews_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_homebrews()    
                
            --N64
            elseif apptype == 5 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(n64_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(n64_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_n64()
            --SNES
            elseif apptype == 6 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(snes_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(snes_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_snes()
            --NES
            elseif apptype == 7 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(nes_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(nes_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_nes()
            --GBA
            elseif apptype == 8 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(gba_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(gba_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gba()
            --GBC
            elseif apptype == 9 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(gbc_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(gbc_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gbc()
            --GB
            elseif apptype == 10 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(gb_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(gb_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gb()
            --MD
            elseif apptype == 11 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(md_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(md_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_md()
            --SMS
            elseif apptype == 12 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(sms_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(sms_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_sms()
            --GG
            elseif apptype == 13 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(gg_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(gg_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gg()
            --MAME
            elseif apptype == 14 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(mame_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(mame_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_mame()
            --AMIGA
            elseif apptype == 15 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(amiga_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(amiga_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_amiga()
            --TG16
            elseif apptype == 16 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(tg16_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(tg16_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_tg16()
            --TGCD
            elseif apptype == 17 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(tgcd_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(tgcd_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_tgcd()
            --PCE
            elseif apptype == 18 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(pce_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(pce_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_pce()
            --PCECD
            elseif apptype == 19 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(pcecd_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(pcecd_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_pcecd()
            --NGPC
            elseif apptype == 20 then
                if recently_played_table[p].favourite == true then
                    recently_played_table[p].favourite=false
                    for k, v in pairs(ngpc_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    recently_played_table[p].favourite=true
                    for k, v in pairs(ngpc_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_ngpc()
            else    
            end

        else
            -- Find game in other tables and update
            -- VITA
            if apptype == 1 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(games_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(games_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_games()
            -- PSP    
            elseif apptype == 2 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(psp_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(psp_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_psp()
            -- PSX    
            elseif apptype == 3 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(psx_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(psx_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_psx()
            -- HOMEBREW    
            elseif apptype == 4 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(homebrews_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(homebrews_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_homebrews()    
                
            --N64
            elseif apptype == 5 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(n64_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(n64_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_n64()
            --SNES
            elseif apptype == 6 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(snes_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(snes_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_snes()
            --NES
            elseif apptype == 7 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(nes_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(nes_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_nes()
            --GBA
            elseif apptype == 8 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(gba_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(gba_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gba()
            --GBC
            elseif apptype == 9 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(gbc_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(gbc_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gbc()
            --GB
            elseif apptype == 10 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(gb_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(gb_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gb()
            --MD
            elseif apptype == 11 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(md_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(md_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_md()
            --SMS
            elseif apptype == 12 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(sms_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(sms_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_sms()
            --GG
            elseif apptype == 13 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(gg_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(gg_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_gg()
            --MAME
            elseif apptype == 14 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(mame_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(mame_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_mame()
            --AMIGA
            elseif apptype == 15 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(amiga_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(amiga_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_amiga()
            --TG16
            elseif apptype == 16 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(tg16_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(tg16_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_tg16()
            --TGCD
            elseif apptype == 17 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(tgcd_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(tgcd_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_tgcd()
            --PCE
            elseif apptype == 18 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(pce_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(pce_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_pce()
            --PCECD
            elseif apptype == 19 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(pcecd_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(pcecd_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_pcecd()
            --NGPC
            elseif apptype == 20 then
                if files_table[p].favourite == true then
                    files_table[p].favourite=false
                    for k, v in pairs(ngpc_table) do
                          if v.filename==filename then
                              v.favourite=false
                          end
                    end
                else
                    files_table[p].favourite=true
                    for k, v in pairs(ngpc_table) do
                          if v.filename==filename then
                              v.favourite=true
                          end
                    end
                end
                update_cached_table_ngpc()
            else    
            end

        end
        update_cached_table_files()
        update_cached_table_recently_played()

        --Reload
        -- FreeIcons()
        -- FreeMemory()
        -- Network.term()
        showMenu = 0
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
    
    -- Find the game in files table and add timestamp
    for k, v in pairs(files_table) do
        if v.filename==filename then
            v.date_played=timestamp
        end
    end
    update_cached_table_files()

    -- Find the games with the timestamp and insert into most table 
    recently_played_new = {}
    for k, v in pairs(files_table) do
        if v.date_played > 0 then
            table.insert(recently_played_new, v)
        end
    end

    for k, v in pairs(recently_played_table) do
        if v.filename==filename then
        else
            table.insert(recently_played_new, v)
        end
    end

    -- Sort played table by date
    table.sort(recently_played_new, function(a, b) return (tonumber(a.date_played) > tonumber(b.date_played)) end)

    -- Select 20 most recent and add to recently played table
    recently_played_pre_launch_table = {}
    for k, v in pairs(recently_played_new) do
        if k < 21 then -- Limit to 20 games
            table.insert(recently_played_pre_launch_table, v)
        end
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
        
        if startupScan == 0 then -- 0 Off, 1 On
            -- Startup scan is OFF
            -- Scan folders and games
            files_table = listDirectory(System.currentDirectory())
            -- Import Cached Database
            files_table = import_cached_DB(System.currentDirectory())
        else
        end

        --Reload
        FreeIcons()
        FreeMemory()
        Network.term()
        dofile("app0:index.lua")
    end

end


function DownloadCovers()
    local txt = lang_lines[65] .. "..."
    --          Downloading covers
    local old_txt = txt
    local percent = 0
    local old_percent = 0
    local cvrfound = 0
    
    local app_idx = 1
    local running = false
    status = System.getMessageState()
    

    -- Portuguese and Japanese language fix for "of" spacing
    local lang_lines_61_fix = {}
    if setLanguage == 6 or setLanguage == 9 then
        lang_lines_61_fix = lang_lines[64]
    else
        lang_lines_61_fix = lang_lines[64] .. " "
    end

    if Network.isWifiEnabled() then

        -- getCovers - 0 All, 1 PSV, 2 PSP, 3 PS1, 4 N64, 5 SNES, 6 NES, 7 GBA, 8 GBC, 9 GB, 10 MD, 11 SMS, 12 GG, 13 MAME, 14 AMIGA, 15 TG16, 16 TGCD, 17 PCE, 18 PCECD, 19 NGPC
        
        -- scan ALL
        if  getCovers==0 and #all_games_table > 0 then -- Check getcover number against sytem

        local app_idx = p

            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage(lang_lines[65] .. "...", true)
                    --                Downloading covers
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #all_games_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(all_games_table[app_idx].cover_path_online .. all_games_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. all_games_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then

                            if System.doesFileExist("ux0:/data/RetroFlow/" .. all_games_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. all_games_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. all_games_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(all_games_table[app_idx].cover_path_local .. all_games_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. all_games_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. all_games_table[app_idx].name .. ".png", all_games_table[app_idx].cover_path_local .. all_games_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                end
                                System.closeFile(tmpfile) --
                                
                                percent = (app_idx / #all_games_table) * 100
                                txt = lang_lines[66] .. "...\n" .. lang_lines[106] .. " " .. all_games_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #all_games_table
                                --    Downloading all covers       Cover                                                             Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #all_games_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end

        -- scan PSVITA
        if getCovers==1 and #games_table > 0 then
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #games_table do
                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[1] .. games_table[app_idx].name .. ".png", "ux0:/data/RetroFlow/" .. games_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. games_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. games_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. games_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[1] .. games_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. games_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. games_table[app_idx].name .. ".png", localCoverPath[1] .. games_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #games_table) * 100
                                
                                txt = lang_lines[67] .. "...\n" .. lang_lines[106] .. " " .. games_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #games_table
                                --    Downloading PS Vita covers   Cover                                                         Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #games_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end

        -- scan PSP
        if  getCovers==2 and #psp_table > 0 then
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #psp_table do
                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[2] .. psp_table[app_idx].name .. ".png", "ux0:/data/RetroFlow/" .. psp_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. psp_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. psp_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. psp_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[2] .. psp_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. psp_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. psp_table[app_idx].name .. ".png", localCoverPath[2] .. psp_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #psp_table) * 100
                                txt = lang_lines[68] .. "...\n" .. lang_lines[106] .. " " .. psp_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #psp_table
                                --    Downloading PSP covers       Cover                                                       Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #psp_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        
        -- scan PS1
        if  getCovers==3 and #psx_table > 0 then
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #psx_table do
                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[3] .. psx_table[app_idx].name .. ".png", "ux0:/data/RetroFlow/" .. psx_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. psx_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. psx_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. psx_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[3] .. psx_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. psx_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. psx_table[app_idx].name .. ".png", localCoverPath[3] .. psx_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #psx_table) * 100
                                txt = lang_lines[69] .. "...\n" .. lang_lines[106] .. " " .. psx_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #psx_table
                                --    Downloading PS1 covers       Cover                                                       Found                                       of


                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #psx_table then
                        System.closeMessage()
                        scanComplete = true

                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end

        --START N64
        -- scan N64
        if  getCovers==4 and #n64_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #n64_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[5] .. n64_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. n64_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. n64_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. n64_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. n64_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[5] .. n64_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. n64_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. n64_table[app_idx].name .. ".png", localCoverPath[5] .. n64_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                    
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #n64_table) * 100
                                txt = lang_lines[70] .. "...\n" .. lang_lines[106] .. " " .. n64_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #n64_table
                                --    Downloading N64 covers       Cover                                                       Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #n64_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END N64


        --START SNES
        -- scan SNES
        if  getCovers==5 and #snes_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #snes_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[6] .. snes_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. snes_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. snes_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. snes_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. snes_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[6] .. snes_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. snes_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. snes_table[app_idx].name .. ".png", localCoverPath[6] .. snes_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #snes_table) * 100
                                txt = lang_lines[71] .. "...\n" .. lang_lines[106] .. " " .. snes_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #snes_table
                                --    Downloading SNES covers      Cover                                                        Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #snes_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END SNES


        --START NES
        -- scan NES
        if  getCovers==6 and #nes_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #nes_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[7] .. nes_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. nes_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. nes_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. nes_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. nes_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[7] .. nes_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. nes_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. nes_table[app_idx].name .. ".png", localCoverPath[7] .. nes_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #nes_table) * 100
                                txt = lang_lines[72] .. "...\n" .. lang_lines[106] .. " " .. nes_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #nes_table
                                --    Downloading NES covers      Cover                                                        Found                                       of
                                
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #nes_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END NES


        --START GBA
        -- scan GBA
        if  getCovers==7 and #gba_table > 0 then -- Check getcover number against sytem
        
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
            
                    while app_idx <= #gba_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[8] .. gba_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. gba_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. gba_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. gba_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gba_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[8] .. gba_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gba_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. gba_table[app_idx].name .. ".png", localCoverPath[8] .. gba_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #gba_table) * 100
                                txt = lang_lines[73] .. "...\n" .. lang_lines[106] .. " " .. gba_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #gba_table
                                --    Downloading GBA covers       Cover                                                       Found                                       of
                                                                
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #gba_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END GBA


        --START GBC
        -- scan GBC
        if  getCovers==8 and #gbc_table > 0 then -- Check getcover number against sytem

            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)

                    while app_idx <= #gbc_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[9] .. gbc_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. gbc_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. gbc_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. gbc_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gbc_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[9] .. gbc_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gbc_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. gbc_table[app_idx].name .. ".png", localCoverPath[9] .. gbc_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #gbc_table) * 100
                                txt = lang_lines[74] .. "...\n" .. lang_lines[106] .. " " .. gbc_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #gbc_table
                                --    Downloading GBC covers       Cover                                                       Found                                       of
                                
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #gbc_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END GBC


        --START GB
        -- scan GB
        if  getCovers==9 and #gb_table > 0 then -- Check getcover number against sytem

            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)

                    while app_idx <= #gb_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[10] .. gb_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. gb_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. gb_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. gb_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gb_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[10] .. gb_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gb_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. gb_table[app_idx].name .. ".png", localCoverPath[10] .. gb_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #gb_table) * 100
                                txt = lang_lines[75] .. "...\n" .. lang_lines[106] .. " " .. gb_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #gb_table
                                --    Downloading GB covers        Cover                                                      Found                                       of
                                
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #gb_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END GB


        --START MD
        -- scan MD
        if  getCovers==10 and #md_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #md_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[11] .. md_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. md_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. md_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. md_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. md_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[11] .. md_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. md_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. md_table[app_idx].name .. ".png", localCoverPath[11] .. md_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #md_table) * 100
                                txt = lang_lines[76] .. "...\n" .. lang_lines[106] .. " " .. md_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #md_table
                                --    Downloading MD covers        Cover                                                      Found                                       of
                                
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #md_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END MD


        --START SMS
        -- scan SMS
        if  getCovers==11 and #sms_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #sms_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[12] .. sms_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. sms_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. sms_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. sms_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. sms_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[12] .. sms_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. sms_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. sms_table[app_idx].name .. ".png", localCoverPath[12] .. sms_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #sms_table) * 100
                                txt = lang_lines[77] .. "...\n" .. lang_lines[106] .. " " .. sms_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #sms_table
                                --    Downloading SMS covers       Cover                                                       Found                                       of
                                
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #sms_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END SMS


        --START GG
        -- scan GG
        if  getCovers==12 and #gg_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #gg_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[13] .. gg_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. gg_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. gg_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. gg_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gg_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[13] .. gg_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. gg_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. gg_table[app_idx].name .. ".png", localCoverPath[13] .. gg_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #gg_table) * 100
                                txt = lang_lines[78] .. "...\n" .. lang_lines[106] .. " " .. gg_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #gg_table
                                --    Downloading GG covers        Cover                                                      Found                                       of
                                 
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #gg_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END GG

        --START MAME
        -- scan MAME
        if  getCovers==13 and #mame_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #mame_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[14] .. mame_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. mame_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. mame_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. mame_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. mame_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[14] .. mame_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. mame_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. mame_table[app_idx].name .. ".png", localCoverPath[14] .. mame_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #mame_table) * 100
                                txt = lang_lines[79] .. "...\n" .. lang_lines[106] .. " " .. mame_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #mame_table
                                --    Downloading MAME covers      Cover                                                        Found                                       of
                                 
                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #mame_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END MAME

        --START AMIGA
        -- scan AMIGA
        if  getCovers==14 and #amiga_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #amiga_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[15] .. amiga_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. amiga_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. amiga_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. amiga_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. amiga_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[15] .. amiga_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. amiga_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. amiga_table[app_idx].name .. ".png", localCoverPath[15] .. amiga_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #amiga_table) * 100
                                txt = lang_lines[80] .. "...\n" .. lang_lines[106] .. " " .. amiga_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #amiga_table
                                --    Downloading AMIGA covers      Cover                                                        Found                                       of
                                 

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #amiga_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END AMIGA

        --START TG16
        -- scan TG16
        if  getCovers==15 and #tg16_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #tg16_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[16] .. tg16_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. tg16_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. tg16_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. tg16_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. tg16_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[16] .. tg16_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. tg16_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. tg16_table[app_idx].name .. ".png", localCoverPath[16] .. tg16_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                               
                                percent = (app_idx / #tg16_table) * 100
                                txt = lang_lines[81] .. "...\n" .. lang_lines[106] .. " " .. tg16_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #tg16_table
                                --    Downloading TG16 covers      Cover                                                        Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #tg16_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END TG16


        --START TGCD
        -- scan TGCD
        if  getCovers==16 and #tgcd_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #tgcd_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[17] .. tgcd_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. tgcd_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. tgcd_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. tgcd_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. tgcd_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[17] .. tgcd_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. tgcd_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. tgcd_table[app_idx].name .. ".png", localCoverPath[17] .. tgcd_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                               
                                percent = (app_idx / #tgcd_table) * 100
                                txt = lang_lines[82] .. "...\n" .. lang_lines[106] .. " " .. tgcd_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #tgcd_table
                                --    Downloading TG-CD covers      Cover                                                        Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #tgcd_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END TGCD

        --START PCE
        -- scan PCE
        if  getCovers==17 and #pce_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #pce_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[18] .. pce_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. pce_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. pce_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. pce_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. pce_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[18] .. pce_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. pce_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. pce_table[app_idx].name .. ".png", localCoverPath[18] .. pce_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #pce_table) * 100
                                txt = "Downloading PCE covers...\nCover " .. pce_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #pce_table
                                
                                percent = (app_idx / #pce_table) * 100
                                txt = lang_lines[83] .. "...\n" .. lang_lines[106] .. " " .. pce_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #pce_table
                                --    Downloading PCE covers       Cover                                                       Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #pce_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END PCE


        --START PCECD
        -- scan PCECD
        if  getCovers==18 and #pcecd_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #pcecd_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[19] .. pcecd_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. pcecd_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. pcecd_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. pcecd_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. pcecd_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[19] .. pcecd_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. pcecd_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. pcecd_table[app_idx].name .. ".png", localCoverPath[19] .. pcecd_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #pcecd_table) * 100
                                txt = "Downloading PCECD covers...\nCover " .. pcecd_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #pcecd_table
                                
                                percent = (app_idx / #pcecd_table) * 100
                                txt = lang_lines[84] .. "...\n" .. lang_lines[106] .. " " .. pcecd_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #pcecd_table
                                --    Downloading PCECD covers       Cover                                                       Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #pcecd_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END PCECD

        --START NGPC
        -- scan NGPC
        if  getCovers==19 and #ngpc_table > 0 then -- Check getcover number against sytem
            if status ~= RUNNING then
                if scanComplete == false then
                    System.setMessage("Downloading covers...", true)
                    System.setMessageProgMsg(txt)
                    
                    while app_idx <= #ngpc_table do

                        if System.getAsyncState() ~= 0 then
                            Network.downloadFileAsync(onlineCoverPathSystem[20] .. ngpc_table[app_idx].name_online .. ".png", "ux0:/data/RetroFlow/" .. ngpc_table[app_idx].name .. ".png")
                            running = true
                        end
                        if System.getAsyncState() == 1 then
                            Graphics.initBlend()
                            Graphics.termBlend()
                            Screen.flip()
                            running = false
                        end
                        if running == false then
                            if System.doesFileExist("ux0:/data/RetroFlow/" .. ngpc_table[app_idx].name .. ".png") then
                                tmpfile = System.openFile("ux0:/data/RetroFlow/" .. ngpc_table[app_idx].name .. ".png", FREAD)
                                size = System.sizeFile(tmpfile)
                                if size < 1024 then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. ngpc_table[app_idx].name .. ".png")

                                -- delete if already exists
                                elseif System.doesFileExist(localCoverPath[20] .. ngpc_table[app_idx].name .. ".png") then
                                    System.deleteFile("ux0:/data/RetroFlow/" .. ngpc_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1

                                else
                                    System.rename("ux0:/data/RetroFlow/" .. ngpc_table[app_idx].name .. ".png", localCoverPath[20] .. ngpc_table[app_idx].name .. ".png")
                                    cvrfound = cvrfound + 1
                                end
                                System.closeFile(tmpfile)
                                
                                percent = (app_idx / #ngpc_table) * 100
                                txt = "Downloading NGPC covers...\nCover " .. ngpc_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #ngpc_table
                                
                                percent = (app_idx / #ngpc_table) * 100
                                txt = lang_lines[85] .. "...\n" .. lang_lines[106] .. " " .. ngpc_table[app_idx].name .. "\n" .. lang_lines[61] .. " " .. cvrfound .. " " .. lang_lines_61_fix .. #ngpc_table
                                --    Downloading NG-PC covers       Cover                                                       Found                                       of

                                Graphics.initBlend()
                                Graphics.termBlend()
                                Screen.flip()
                                app_idx = app_idx + 1
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
                    if app_idx >= #ngpc_table then
                        System.closeMessage()
                        scanComplete = true
                    end
                else

                    if startupScan == 0 then -- 0 Off, 1 On
                        -- Startup scan is OFF
                        -- Scan folders and games
                        files_table = listDirectory(System.currentDirectory())
                        -- Import Cached Database
                        files_table = import_cached_DB(System.currentDirectory())
                    else
                    end

                    FreeIcons()
                    FreeMemory()
                    Network.term()
                    dofile("app0:index.lua")
                end
            end
        end
        -- END NGPC


    else
        if status ~= RUNNING then
            System.setMessage(lang_lines[53], false, BUTTON_OK) -- Internet Connection Required
        end
        
    end
    gettingCovers = false

    -- RESCAN ALL AND UPDATE CACHE

    -- -- Scan folders and games
    -- files_table = listDirectory(System.currentDirectory())
    -- -- Import Cached Database
    -- files_table = import_cached_DB(System.currentDirectory())

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
            -- PSP Boxes
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
            -- PSX Boxes
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
            -- 5 N64 Boxes -- 6 SNES Boxes
            if setReflections == 1 then
                Render.useTexture(modCoverN64, icon)
                Render.drawModel(modCoverN64, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxN64, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverN64Noref, icon)
                Render.drawModel(modCoverN64Noref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxN64Noref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==7 or apptype==14 or apptype==15 or apptype==16 or apptype==17 or apptype==18 or apptype==19 or apptype==20 then
            -- 7 NES Boxes -- 14 MAME Boxes -- 15 AMIGA Boxes -- 16 TG16 Boxes -- 17 TGCD Boxes -- 18 PCE Boxes -- 19 PCECD Boxes -- 20 NGPC Boxes
            if setReflections == 1 then
                Render.useTexture(modCoverNES, icon)
                Render.drawModel(modCoverNES, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxNES, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverNESNoref, icon)
                Render.drawModel(modCoverNESNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxNESNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==8 or apptype==9 or apptype==10 then
            -- 8 GBA Boxes -- 9 GBC Boxes -- 10 GB Boxes
            if setReflections == 1 then
                Render.useTexture(modCoverGB, icon)
                Render.drawModel(modCoverGB, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxGB, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverGBNoref, icon)
                Render.drawModel(modCoverGBNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxGBNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            end
        elseif apptype==11 or apptype==12 or apptype==13 then
            -- 11 MD Boxes -- 12 SMS Boxes -- 13 GG Boxes
            if setReflections == 1 then
                Render.useTexture(modCoverMD, icon)
                Render.drawModel(modCoverMD, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxMD, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
            else
                Render.useTexture(modCoverMDNoref, icon)
                Render.drawModel(modCoverMDNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
                Render.drawModel(modBoxMDNoref, x + extrax, y + extray, -5 - extraz - zoom, 0, math.deg(rot), 0)
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
        hideBoxes = hideBoxes - 0.1
    end
end

local FileLoad = {}

function FreeIcons()
    for k, v in pairs(files_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    for k, v in pairs(games_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    for k, v in pairs(psp_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    for k, v in pairs(psx_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- N64
    for k, v in pairs(n64_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- SNES
    for k, v in pairs(snes_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- NES
    for k, v in pairs(nes_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- GBA
    for k, v in pairs(gba_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- GBC
    for k, v in pairs(gbc_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- GB
    for k, v in pairs(gb_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end 
    -- MD
    for k, v in pairs(md_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- SMS
    for k, v in pairs(sms_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- GG
    for k, v in pairs(gg_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- MAME
    for k, v in pairs(mame_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- AMIGA
    for k, v in pairs(amiga_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- TG16
    for k, v in pairs(tg16_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- TGCD
    for k, v in pairs(tgcd_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- PCE
    for k, v in pairs(pce_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- PCECD
    for k, v in pairs(pcecd_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- NGPC
    for k, v in pairs(ngpc_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- Recently played
    for k, v in pairs(recently_played_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
    -- Homebrew
    for k, v in pairs(homebrews_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end

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
            coverspath = localCoverPath[1]
            onlineCoverspath = onlineCoverPathSystem[1]
        elseif apptype == 2 then
            coverspath = localCoverPath[2]
            onlineCoverspath = onlineCoverPathSystem[2]
        elseif apptype == 3 then
            coverspath = localCoverPath[3]
            onlineCoverspath = onlineCoverPathSystem[3]
        --N64
        elseif apptype == 5 then
            coverspath = localCoverPath[5]
            onlineCoverspath = onlineCoverPathSystem[5]
        --SNES
        elseif apptype == 6 then
            coverspath = localCoverPath[6]
            onlineCoverspath = onlineCoverPathSystem[6]
        --NES
        elseif apptype == 7 then
            coverspath = localCoverPath[7]
            onlineCoverspath = onlineCoverPathSystem[7]
        --GBA
        elseif apptype == 8 then
            coverspath = localCoverPath[8]
            onlineCoverspath = onlineCoverPathSystem[8]
        --GBC
        elseif apptype == 9 then
            coverspath = localCoverPath[9]
            onlineCoverspath = onlineCoverPathSystem[9]
        --GB
        elseif apptype == 10 then
            coverspath = localCoverPath[10]
            onlineCoverspath = onlineCoverPathSystem[10]
        --MD
        elseif apptype == 11 then
            coverspath = localCoverPath[11]
            onlineCoverspath = onlineCoverPathSystem[11]
        --SMS
        elseif apptype == 12 then
            coverspath = localCoverPath[12]
            onlineCoverspath = onlineCoverPathSystem[12]
        --GG
        elseif apptype == 13 then
            coverspath = localCoverPath[13]
            onlineCoverspath = onlineCoverPathSystem[13]
        --MAME
        elseif apptype == 14 then
            coverspath = localCoverPath[14]
            onlineCoverspath = onlineCoverPathSystem[14]
        --AMIGA
        elseif apptype == 15 then
            coverspath = localCoverPath[15]
            onlineCoverspath = onlineCoverPathSystem[15]
        --TG16
        elseif apptype == 16 then
            coverspath = localCoverPath[16]
            onlineCoverspath = onlineCoverPathSystem[16]
        --TGCD
        elseif apptype == 17 then
            coverspath = localCoverPath[17]
            onlineCoverspath = onlineCoverPathSystem[17]
        --PCE
        elseif apptype == 18 then
            coverspath = localCoverPath[18]
            onlineCoverspath = onlineCoverPathSystem[18]
        --PCECD
        elseif apptype == 19 then
            coverspath = localCoverPath[19]
            onlineCoverspath = onlineCoverPathSystem[19]
        --NGPC
        elseif apptype == 20 then
            coverspath = localCoverPath[20]
            onlineCoverspath = onlineCoverPathSystem[20]
        else
            coverspath = localCoverPath[1]
            onlineCoverspath = onlineCoverPathSystem[1]
        end


        Network.downloadFile(onlineCoverspath .. app_titleid:gsub("%s+", '%%20') .. ".png", "ux0:/data/RetroFlow/" .. app_titleid .. ".png")
        
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
        end

        if cvrfound==1 then
            if showCat == 1 then
                --"games_table"
                games_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[games_table[app_idx]] == true then
                    FileLoad[games_table[app_idx]] = nil
                    Threads.remove(games_table[app_idx])
                    update_cached_table_games()
                end
                if games_table[app_idx].ricon then
                    games_table[app_idx].ricon = nil
                end
            elseif showCat == 2 then
                --"homebrews_table"
                    
            elseif showCat == 3 then
                --"psp_table"
                psp_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[psp_table[app_idx]] == true then
                    FileLoad[psp_table[app_idx]] = nil
                    Threads.remove(psp_table[app_idx])
                    update_cached_table_psp()
                end
                if psp_table[app_idx].ricon then
                    psp_table[app_idx].ricon = nil
                end
            elseif showCat == 4 then
                --"psx_table"
                psx_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[psx_table[app_idx]] == true then
                    FileLoad[psx_table[app_idx]] = nil
                    Threads.remove(psx_table[app_idx])
                    update_cached_table_psx()
                end
                if psx_table[app_idx].ricon then
                    psx_table[app_idx].ricon = nil
                end
            -- N64  
            elseif showCat == 5 then
                --"n64_table"
                n64_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[n64_table[app_idx]] == true then
                    FileLoad[n64_table[app_idx]] = nil
                    Threads.remove(n64_table[app_idx])
                    update_cached_table_n64()
                end
                if n64_table[app_idx].ricon then
                    n64_table[app_idx].ricon = nil
                end
            -- SNES 
            elseif showCat == 6 then
                --"snes_table"
                snes_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[snes_table[app_idx]] == true then
                    FileLoad[snes_table[app_idx]] = nil
                    Threads.remove(snes_table[app_idx])
                    update_cached_table_snes()
                end
                if snes_table[app_idx].ricon then
                    snes_table[app_idx].ricon = nil
                end
            -- NES 
            elseif showCat == 7 then
                --"nes_table"
                nes_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[nes_table[app_idx]] == true then
                    FileLoad[nes_table[app_idx]] = nil
                    Threads.remove(nes_table[app_idx])
                    update_cached_table_nes()
                end
                if nes_table[app_idx].ricon then
                    nes_table[app_idx].ricon = nil
                end
            -- GBA   
            elseif showCat == 8 then
                --"gba_table"
                gba_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[gba_table[app_idx]] == true then
                    FileLoad[gba_table[app_idx]] = nil
                    Threads.remove(gba_table[app_idx])
                    update_cached_table_gba()
                end
                if gba_table[app_idx].ricon then
                    gba_table[app_idx].ricon = nil
                end
            -- GBC   
            elseif showCat == 9 then
                --"gbc_table"
                gbc_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[gbc_table[app_idx]] == true then
                    FileLoad[gbc_table[app_idx]] = nil
                    Threads.remove(gbc_table[app_idx])
                    update_cached_table_gbc()
                end
                if gbc_table[app_idx].ricon then
                    gbc_table[app_idx].ricon = nil
                end
            -- GB   
            elseif showCat == 10 then
                --"gb_table"
                gb_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[gb_table[app_idx]] == true then
                    FileLoad[gb_table[app_idx]] = nil
                    Threads.remove(gb_table[app_idx])
                    update_cached_table_gb()
                end
                if gb_table[app_idx].ricon then
                    gb_table[app_idx].ricon = nil
                end
            -- MD 
            elseif showCat == 11 then
                --"md_table"
                md_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[md_table[app_idx]] == true then
                    FileLoad[md_table[app_idx]] = nil
                    Threads.remove(md_table[app_idx])
                    update_cached_table_md()
                end
                if md_table[app_idx].ricon then
                    md_table[app_idx].ricon = nil
                end
            -- SMS 
            elseif showCat == 12 then
                --"sms_table"
                sms_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[sms_table[app_idx]] == true then
                    FileLoad[sms_table[app_idx]] = nil
                    Threads.remove(sms_table[app_idx])
                    update_cached_table_sms()
                end
                if sms_table[app_idx].ricon then
                    sms_table[app_idx].ricon = nil
                end
            -- GG 
            elseif showCat == 13 then
                --"gg_table"
                gg_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[gg_table[app_idx]] == true then
                    FileLoad[gg_table[app_idx]] = nil
                    Threads.remove(gg_table[app_idx])
                    update_cached_table_gg()
                end
                if gg_table[app_idx].ricon then
                    gg_table[app_idx].ricon = nil
                end
            -- MAME
            elseif showCat == 14 then
                --"mame_table"
                mame_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[mame_table[app_idx]] == true then
                    FileLoad[mame_table[app_idx]] = nil
                    Threads.remove(mame_table[app_idx])
                    update_cached_table_mame()
                end
                if mame_table[app_idx].ricon then
                    mame_table[app_idx].ricon = nil
                end
            -- AMIGA
            elseif showCat == 15 then
                --"amiga_table"
                amiga_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[amiga_table[app_idx]] == true then
                    FileLoad[amiga_table[app_idx]] = nil
                    Threads.remove(amiga_table[app_idx])
                    update_cached_table_amiga()
                end
                if amiga_table[app_idx].ricon then
                    amiga_table[app_idx].ricon = nil
                end
            -- TG16
            elseif showCat == 16 then
                --"tg16_table"
                tg16_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[tg16_table[app_idx]] == true then
                    FileLoad[tg16_table[app_idx]] = nil
                    Threads.remove(tg16_table[app_idx])
                    update_cached_table_tg16()
                end
                if tg16_table[app_idx].ricon then
                    tg16_table[app_idx].ricon = nil
                end
            -- TGCD
            elseif showCat == 17 then
                --"tgcd_table"
                tgcd_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[tgcd_table[app_idx]] == true then
                    FileLoad[tgcd_table[app_idx]] = nil
                    Threads.remove(tgcd_table[app_idx])
                    update_cached_table_tg16()
                end
                if tgcd_table[app_idx].ricon then
                    tgcd_table[app_idx].ricon = nil
                end
            -- PCE
            elseif showCat == 18 then
                --"pce_table"
                pce_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[pce_table[app_idx]] == true then
                    FileLoad[pce_table[app_idx]] = nil
                    Threads.remove(pce_table[app_idx])
                    update_cached_table_pce()
                end
                if pce_table[app_idx].ricon then
                    pce_table[app_idx].ricon = nil
                end
            -- PCECD
            elseif showCat == 19 then
                --"pcecd_table"
                pcecd_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[pcecd_table[app_idx]] == true then
                    FileLoad[pcecd_table[app_idx]] = nil
                    Threads.remove(pcecd_table[app_idx])
                    update_cached_table_pce()
                end
                if pcecd_table[app_idx].ricon then
                    pcecd_table[app_idx].ricon = nil
                end
            -- NGPC
            elseif showCat == 20 then
                --"ngpc_table"
                ngpc_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[ngpc_table[app_idx]] == true then
                    FileLoad[ngpc_table[app_idx]] = nil
                    Threads.remove(ngpc_table[app_idx])
                    update_cached_table_pce()
                end
                if ngpc_table[app_idx].ricon then
                    ngpc_table[app_idx].ricon = nil
                end

            --Favorites
            elseif showCat == 21 then
                fav_count[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[fav_count[app_idx]] == true then
                    FileLoad[fav_count[app_idx]] = nil
                    Threads.remove(fav_count[app_idx])
                    update_cached_table_files()
                end
                if fav_count[app_idx].ricon then
                    fav_count[app_idx].ricon = nil
                end

            --Recently played
            elseif showCat == 22 then
                --"recently_played_table"
                recently_played_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[recently_played_table[app_idx]] == true then
                    FileLoad[recently_played_table[app_idx]] = nil
                    Threads.remove(recently_played_table[app_idx])
                    update_cached_table_recently_played()
                end
                if recently_played_table[app_idx].ricon then
                    recently_played_table[app_idx].ricon = nil
                end

            else
                --"files_table"
                files_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
                if FileLoad[files_table[app_idx]] == true then
                    FileLoad[files_table[app_idx]] = nil
                    Threads.remove(files_table[app_idx])
                    update_cached_table_files()
                end
                if files_table[app_idx].ricon then
                    files_table[app_idx].ricon = nil
                end
            end
            if status ~= RUNNING then
                System.setMessage(lang_lines[60] .. " " .. app_titleid .. " " .. lang_lines[62], false, BUTTON_OK)
                --                Cover                                          found!
            end
        else
            if status ~= RUNNING then
                System.setMessage(lang_lines[63], false, BUTTON_OK)
                --                Cover not found
            end
        end
        
    else
        if status ~= RUNNING then
            System.setMessage(lang_lines[53], false, BUTTON_OK)
            --                Internet Connection Required
        end
    end
    
    gettingCovers = false
end

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
    
    -- Graphics
    if setBackground == 1 then
        Render.drawModel(modBackground, 0, 0, -5, 0, 0, 0)-- Draw Background as model
    else
        Render.drawModel(modDefaultBackground, 0, 0, -5, 0, 0, 0)-- Draw Background as model
    end
    
    Graphics.fillRect(0, 960, 496, 544, themeCol)-- footer bottom
    
    if showMenu == 0 then
        -- MAIN VIEW
        -- Header
        h, m, s = System.getTime()
        Font.print(fnt20, 726, 34, string.format("%02d:%02d", h, m), white)-- Draw time
        life = System.getBatteryPercentage()
        Font.print(fnt20, 830, 34, life .. "%", white)-- Draw battery
        Graphics.drawImage(888, 41, imgBattery)
        Graphics.fillRect(891, 891 + (life / 5.2), 45, 53, white)

        -- Footer buttons and icons
        -- Get text widths for positioning
        local label1 = Font.getTextWidth(fnt20, lang_lines[7])--Launch
        local label2 = Font.getTextWidth(fnt20, lang_lines[8])--Details
        local label3 = Font.getTextWidth(fnt20, lang_lines[9])--Category
        local label4 = Font.getTextWidth(fnt20, lang_lines[10])--View

        Graphics.drawImage(900-label1, 510, btnX)
        Font.print(fnt20, 900+28-label1, 508, lang_lines[7], white)--Launch

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines[8], white)--Details

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnS)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines[9], white)--Category

        Graphics.drawImage(900-(btnMargin * 6)-label1-label2-label3-label4, 510, btnO)
        Font.print(fnt20, 900+28-(btnMargin * 6)-label1-label2-label3-label4, 508, lang_lines[10], white)--View
        
        if showCat == 1 then
            Font.print(fnt22, 32, 34, lang_lines[1], white)--GAMES
        elseif showCat == 2 then
            Font.print(fnt22, 32, 34, lang_lines[2], white)--HOMEBREWS
        elseif showCat == 3 then
            Font.print(fnt22, 32, 34, lang_lines[3], white)--PSP
        elseif showCat == 4 then
            Font.print(fnt22, 32, 34, lang_lines[4], white)--PSX
        elseif showCat == 5 then
            Font.print(fnt22, 32, 34, lang_lines[33], white)--N64
        elseif showCat == 6 then
            Font.print(fnt22, 32, 34, lang_lines[34], white)--SNES
        elseif showCat == 7 then
            Font.print(fnt22, 32, 34, lang_lines[35], white)--NES
        elseif showCat == 8 then
            Font.print(fnt22, 32, 34, lang_lines[36], white)--GBA
        elseif showCat == 9 then
            Font.print(fnt22, 32, 34, lang_lines[37], white)--GBC
        elseif showCat == 10 then
            Font.print(fnt22, 32, 34, lang_lines[38], white)--GB
        elseif showCat == 11 then
            Font.print(fnt22, 32, 34, lang_lines[39], white)--MD
        elseif showCat == 12 then
            Font.print(fnt22, 32, 34, lang_lines[40], white)--SMS
        elseif showCat == 13 then
            Font.print(fnt22, 32, 34, lang_lines[41], white)--GG
        elseif showCat == 14 then
            Font.print(fnt22, 32, 34, lang_lines[42], white)--MAME
        elseif showCat == 15 then
            Font.print(fnt22, 32, 34, lang_lines[43], white)--AMIGA
        elseif showCat == 16 then
            Font.print(fnt22, 32, 34, lang_lines[44], white)--TG16
        elseif showCat == 17 then
            Font.print(fnt22, 32, 34, lang_lines[45], white)--TGCD
        elseif showCat == 18 then
            Font.print(fnt22, 32, 34, lang_lines[46], white)--PCE
        elseif showCat == 19 then
            Font.print(fnt22, 32, 34, lang_lines[47], white)--PCECD
        elseif showCat == 20 then
            Font.print(fnt22, 32, 34, lang_lines[48], white)--NGPC
        elseif showCat == 21 then
            Font.print(fnt22, 32, 34, lang_lines[107], white)--Favorites
        elseif showCat == 22 then
            Font.print(fnt22, 32, 34, lang_lines[109], white)--Recently Played
        else
            Font.print(fnt22, 32, 34, lang_lines[5], white)--ALL
        end
        if Network.isWifiEnabled() then
            Graphics.drawImage(800, 38, imgWifi)-- wifi icon
        end
        
        if showView ~= 2 then
            Graphics.fillRect(0, 960, 424, 496, black)-- black footer bottom
            PrintCentered(fnt25, 480, 430, app_title, white, 25)-- Draw title
        else
            Font.print(fnt22, 24, 508, app_title, white)
        end
        
        -- Draw Covers
        base_x = 0
        
        --GAMES
        if showCat == 1 then
            for l, file in pairs(games_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = games_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
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
                        DrawCover((targetX + l * space) - (#games_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#games_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #games_table, white, 20)-- Draw total items
                --                                         of
            end

        --HOMEBREWS
        elseif showCat == 2 then
            for l, file in pairs(homebrews_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = homebrews_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#homebrews_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#homebrews_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #homebrews_table, white, 20)-- Draw total items
                --                                         of
            end

        --PSP
        elseif showCat == 3 then
            for l, file in pairs(psp_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = psp_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#psp_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#psp_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #psp_table, white, 20)-- Draw total items
                --                                         of
            end

        --PSX
        elseif showCat == 4 then
            for l, file in pairs(psx_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = psx_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#psx_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#psx_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #psx_table, white, 20)-- Draw total items
                --                                         of
            end
        -- else

        --N64
        elseif showCat == 5 then

            for l, file in pairs(n64_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = n64_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#n64_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#n64_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #n64_table, white, 20)-- Draw total items
                --                                         of
            end

        --SNES
        elseif showCat == 6 then
            for l, file in pairs(snes_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = snes_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#snes_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#snes_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #snes_table, white, 20)-- Draw total items
                --                                         of
            end

        --NES
        elseif showCat == 7 then
            for l, file in pairs(nes_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = nes_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#nes_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#nes_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #nes_table, white, 20)-- Draw total items
                --                                         of
            end

        --GBA
        elseif showCat == 8 then
            for l, file in pairs(gba_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = gba_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#gba_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#gba_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #gba_table, white, 20)-- Draw total items
                --                                         of
            end

        --GBC
        elseif showCat == 9 then
            for l, file in pairs(gbc_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = gbc_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#gbc_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#gbc_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #gbc_table, white, 20)-- Draw total items
                --                                         of
            end

        --GB
        elseif showCat == 10 then
            for l, file in pairs(gb_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = gb_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#gb_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#gb_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #gb_table, white, 20)-- Draw total items
                --                                         of
            end

        --MD
        elseif showCat == 11 then
            for l, file in pairs(md_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = md_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#md_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#md_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #md_table, white, 20)-- Draw total items
                --                                         of
            end

        --SMS
        elseif showCat == 12 then
            for l, file in pairs(sms_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = sms_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#sms_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#sms_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #sms_table, white, 20)-- Draw total items
                --                                         of
            end

        --GG
        elseif showCat == 13 then
            for l, file in pairs(gg_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = gg_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#gg_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#gg_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #gg_table, white, 20)-- Draw total items
                --                                         of
            end

        --MAME
        elseif showCat == 14 then
            for l, file in pairs(mame_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = mame_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#mame_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#mame_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #mame_table, white, 20)-- Draw total items
                --                                         of
            end

        --AMIGA
        elseif showCat == 15 then
            for l, file in pairs(amiga_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = amiga_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#amiga_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#amiga_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #amiga_table, white, 20)-- Draw total items
                --                                         of
            end

        --TG16
        elseif showCat == 16 then
            for l, file in pairs(tg16_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = tg16_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#tg16_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#tg16_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #tg16_table, white, 20)-- Draw total items
                --                                         of
            end

        --TGCD
        elseif showCat == 17 then
            for l, file in pairs(tgcd_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = tgcd_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#tgcd_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#tgcd_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #tgcd_table, white, 20)-- Draw total items
                --                                         of
            end

        --PCE
        elseif showCat == 18 then
            for l, file in pairs(pce_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = pce_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#pce_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#pce_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #pce_table, white, 20)-- Draw total items
                --                                         of
            end

        --PCECD
        elseif showCat == 19 then
            for l, file in pairs(pcecd_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = pcecd_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#pcecd_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#pcecd_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #pcecd_table, white, 20)-- Draw total items
                --                                         of
            end

        --NGPC
        elseif showCat == 20 then
            for l, file in pairs(ngpc_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = ngpc_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#ngpc_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#ngpc_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #ngpc_table, white, 20)-- Draw total items
                --                                         of
            end

        --Favorites
        elseif showCat == 21 then

            -- count favorites
            fav_count = {}
            for l, file in pairs(files_table) do
                if showHomebrews == 0 then
                    -- ignore homebrew apps
                    if file.app_type > 0 then
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
            end

            for l, file in pairs(fav_count) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = fav_count[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#fav_count * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#fav_count * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #fav_count, white, 20)-- Draw total items
                --                                         of
            end

        --Recently played
        elseif showCat == 22 then
            for l, file in pairs(recently_played_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = recently_played_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#recently_played_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#recently_played_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #recently_played_table, white, 20)-- Draw total items
                --                                         of
            end



        else
            --ALL
            for l, file in pairs(files_table) do
                if (l >= master_index) then
                    base_x = base_x + space
                end

                -- Show fav icon if game if a favourite
                favourite_flag = files_table[p].favourite
                if favourite_flag == true then
                    Graphics.drawImage(685, 36, imgFavorite_small_on)
                else
                    Graphics.drawImage(685, 36, imgFavorite_small_blank)
                end

                if l > p-8 and base_x < 10 then
                    if FileLoad[file] == nil then
                        FileLoad[file] = true
                        Threads.addTask(file, {
                            Type = "ImageLoad",
                            Path = file.icon_path,
                            Table = file,
                            Index = "ricon"
                        })
                    end
                    if file.ricon ~= nil then
                        DrawCover((targetX + l * space) - (#files_table * space + space), -0.6, file.name, file.ricon, base_x, file.app_type)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#files_table * space + space), -0.6, file.name, file.icon, base_x, file.app_type)--draw visible covers only
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
                PrintCentered(fnt20, 480, 462, p .. " " .. lang_lines[64] .. #files_table, white, 20)-- Draw total items
                --                                         of
            end
        end
        
        
        -- Smooth move items horizontally
        if targetX < base_x then
            targetX = targetX + (-(targetX - base_x) * 0.1)
        elseif targetX > base_x then
            targetX = targetX - ((targetX - base_x) * 0.1)
        else
            targetX = base_x
        end
        
        -- Instantly move to selection
        if startCovers == false then
            targetX = base_x
            startCovers = true
            GetInfoSelected()
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
    elseif showMenu == 1 then
        
        -- PREVIEW
        -- Footer buttons and icons
        -- Get text widths for positioning
        local label1 = Font.getTextWidth(fnt20, lang_lines[11])--Close
        local label2 = Font.getTextWidth(fnt20, lang_lines[32])--Select
        local label3 = Font.getTextWidth(fnt20, lang_lines[108])--Favourite

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines[11], white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines[32], white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines[108], white)--Favourite
        
        Graphics.fillRect(24, 470, 24, 470, darkalpha)

        Render.setCamera(0, 0, 0, 0.0, 0.0, 0.0)
        if inPreview == false then
            if not pcall(loadImage, icon_path) then
                iconTmp = imgCoverTmp
            else
                iconTmp = Graphics.loadImage(icon_path)
            end
            -- set pic0 as background
            if System.doesFileExist(pic_path) and setBackground == 1 then
                Graphics.freeImage(backTmp)
                backTmp = Graphics.loadImage(pic_path)
                Graphics.setImageFilters(backTmp, FILTER_LINEAR, FILTER_LINEAR)
                Render.useTexture(modBackground, backTmp)
            else
                Render.useTexture(modBackground, imgCustomBack)
            end
            
            if folder == true then
                app_size = getAppSize(appdir)/1024/1024
                game_size = string.format("%02d", app_size) .. "Mb"
            else
                getRomSize()
            end
            
            menuY=0
            tmpappcat=0
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

        txtname = string.sub(app_title, 1, 32) .. "\n" .. string.sub(app_title, 33)
        
        -- Set cover image
        if showCat == 1 then
            --Graphics.setImageFilters(games_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if games_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, games_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, games_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, games_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, games_table[p].ricon)
                Render.useTexture(modCoverN64Noref, games_table[p].ricon)
                Render.useTexture(modCoverN64Noref, games_table[p].ricon)
                Render.useTexture(modCoverNESNoref, games_table[p].ricon)
                Render.useTexture(modCoverGBNoref, games_table[p].ricon)
                Render.useTexture(modCoverGBNoref, games_table[p].ricon)
                Render.useTexture(modCoverGBNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
                Render.useTexture(modCoverMDNoref, games_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, games_table[p].icon)
                Render.useTexture(modCoverHbrNoref, games_table[p].icon)
                Render.useTexture(modCoverPSPNoref, games_table[p].icon)
                Render.useTexture(modCoverPSXNoref, games_table[p].icon)
                Render.useTexture(modCoverN64Noref, games_table[p].icon)
                Render.useTexture(modCoverN64Noref, games_table[p].icon)
                Render.useTexture(modCoverNESNoref, games_table[p].icon)
                Render.useTexture(modCoverGBNoref, games_table[p].icon)
                Render.useTexture(modCoverGBNoref, games_table[p].icon)
                Render.useTexture(modCoverGBNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
                Render.useTexture(modCoverMDNoref, games_table[p].icon)
            end
        elseif showCat == 2 then
            --Graphics.setImageFilters(homebrews_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if homebrews_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverN64Noref, homebrews_table[p].ricon)
                Render.useTexture(modCoverN64Noref, homebrews_table[p].ricon)
                Render.useTexture(modCoverNESNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverGBNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverGBNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverGBNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverHbrNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverPSPNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverPSXNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverN64Noref, homebrews_table[p].icon)
                Render.useTexture(modCoverN64Noref, homebrews_table[p].icon)
                Render.useTexture(modCoverNESNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverGBNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverGBNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverGBNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
                Render.useTexture(modCoverMDNoref, homebrews_table[p].icon)
            end
        elseif showCat == 3 then
            --Graphics.setImageFilters(psp_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if psp_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, psp_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, psp_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, psp_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, psp_table[p].ricon)
                Render.useTexture(modCoverN64Noref, psp_table[p].ricon)
                Render.useTexture(modCoverN64Noref, psp_table[p].ricon)
                Render.useTexture(modCoverNESNoref, psp_table[p].ricon)
                Render.useTexture(modCoverGBNoref, psp_table[p].ricon)
                Render.useTexture(modCoverGBNoref, psp_table[p].ricon)
                Render.useTexture(modCoverGBNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psp_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, psp_table[p].icon)
                Render.useTexture(modCoverHbrNoref, psp_table[p].icon)
                Render.useTexture(modCoverPSPNoref, psp_table[p].icon)
                Render.useTexture(modCoverPSXNoref, psp_table[p].icon)
                Render.useTexture(modCoverN64Noref, psp_table[p].icon)
                Render.useTexture(modCoverN64Noref, psp_table[p].icon)
                Render.useTexture(modCoverNESNoref, psp_table[p].icon)
                Render.useTexture(modCoverGBNoref, psp_table[p].icon)
                Render.useTexture(modCoverGBNoref, psp_table[p].icon)
                Render.useTexture(modCoverGBNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
                Render.useTexture(modCoverMDNoref, psp_table[p].icon)
            end
        elseif showCat == 4 then
            --Graphics.setImageFilters(psx_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if psx_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, psx_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, psx_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, psx_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, psx_table[p].ricon)
                Render.useTexture(modCoverN64Noref, psx_table[p].ricon)
                Render.useTexture(modCoverN64Noref, psx_table[p].ricon)
                Render.useTexture(modCoverNESNoref, psx_table[p].ricon)
                Render.useTexture(modCoverGBNoref, psx_table[p].ricon)
                Render.useTexture(modCoverGBNoref, psx_table[p].ricon)
                Render.useTexture(modCoverGBNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
                Render.useTexture(modCoverMDNoref, psx_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, psx_table[p].icon)
                Render.useTexture(modCoverHbrNoref, psx_table[p].icon)
                Render.useTexture(modCoverPSPNoref, psx_table[p].icon)
                Render.useTexture(modCoverPSXNoref, psx_table[p].icon)
                Render.useTexture(modCoverN64Noref, psx_table[p].icon)
                Render.useTexture(modCoverN64Noref, psx_table[p].icon)
                Render.useTexture(modCoverNESNoref, psx_table[p].icon)
                Render.useTexture(modCoverGBNoref, psx_table[p].icon)
                Render.useTexture(modCoverGBNoref, psx_table[p].icon)
                Render.useTexture(modCoverGBNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
                Render.useTexture(modCoverMDNoref, psx_table[p].icon)
            end
        --N64
        elseif showCat == 5 then
            --Graphics.setImageFilters(n64_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if n64_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, n64_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, n64_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, n64_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, n64_table[p].ricon)
                Render.useTexture(modCoverN64Noref, n64_table[p].ricon)
                Render.useTexture(modCoverN64Noref, n64_table[p].ricon)
                Render.useTexture(modCoverNESNoref, n64_table[p].ricon)
                Render.useTexture(modCoverGBNoref, n64_table[p].ricon)
                Render.useTexture(modCoverGBNoref, n64_table[p].ricon)
                Render.useTexture(modCoverGBNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
                Render.useTexture(modCoverMDNoref, n64_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, n64_table[p].icon)
                Render.useTexture(modCoverHbrNoref, n64_table[p].icon)
                Render.useTexture(modCoverPSPNoref, n64_table[p].icon)
                Render.useTexture(modCoverPSXNoref, n64_table[p].icon)
                Render.useTexture(modCoverN64Noref, n64_table[p].icon)
                Render.useTexture(modCoverN64Noref, n64_table[p].icon)
                Render.useTexture(modCoverNESNoref, n64_table[p].icon)
                Render.useTexture(modCoverGBNoref, n64_table[p].icon)
                Render.useTexture(modCoverGBNoref, n64_table[p].icon)
                Render.useTexture(modCoverGBNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
                Render.useTexture(modCoverMDNoref, n64_table[p].icon)
            end

        --SNES
        elseif showCat == 6 then
            --Graphics.setImageFilters(snes_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if snes_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, snes_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, snes_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, snes_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, snes_table[p].ricon)
                Render.useTexture(modCoverN64Noref, snes_table[p].ricon)
                Render.useTexture(modCoverN64Noref, snes_table[p].ricon)
                Render.useTexture(modCoverNESNoref, snes_table[p].ricon)
                Render.useTexture(modCoverGBNoref, snes_table[p].ricon)
                Render.useTexture(modCoverGBNoref, snes_table[p].ricon)
                Render.useTexture(modCoverGBNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, snes_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, snes_table[p].icon)
                Render.useTexture(modCoverHbrNoref, snes_table[p].icon)
                Render.useTexture(modCoverPSPNoref, snes_table[p].icon)
                Render.useTexture(modCoverPSXNoref, snes_table[p].icon)
                Render.useTexture(modCoverN64Noref, snes_table[p].icon)
                Render.useTexture(modCoverN64Noref, snes_table[p].icon)
                Render.useTexture(modCoverNESNoref, snes_table[p].icon)
                Render.useTexture(modCoverGBNoref, snes_table[p].icon)
                Render.useTexture(modCoverGBNoref, snes_table[p].icon)
                Render.useTexture(modCoverGBNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
                Render.useTexture(modCoverMDNoref, snes_table[p].icon)
            end
        --NES
        elseif showCat == 7 then
            --Graphics.setImageFilters(nes_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if nes_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, nes_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, nes_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, nes_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, nes_table[p].ricon)
                Render.useTexture(modCoverN64Noref, nes_table[p].ricon)
                Render.useTexture(modCoverN64Noref, nes_table[p].ricon)
                Render.useTexture(modCoverNESNoref, nes_table[p].ricon)
                Render.useTexture(modCoverGBNoref, nes_table[p].ricon)
                Render.useTexture(modCoverGBNoref, nes_table[p].ricon)
                Render.useTexture(modCoverGBNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
                Render.useTexture(modCoverMDNoref, nes_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, nes_table[p].icon)
                Render.useTexture(modCoverHbrNoref, nes_table[p].icon)
                Render.useTexture(modCoverPSPNoref, nes_table[p].icon)
                Render.useTexture(modCoverPSXNoref, nes_table[p].icon)
                Render.useTexture(modCoverN64Noref, nes_table[p].icon)
                Render.useTexture(modCoverN64Noref, nes_table[p].icon)
                Render.useTexture(modCoverNESNoref, nes_table[p].icon)
                Render.useTexture(modCoverGBNoref, nes_table[p].icon)
                Render.useTexture(modCoverGBNoref, nes_table[p].icon)
                Render.useTexture(modCoverGBNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
                Render.useTexture(modCoverMDNoref, nes_table[p].icon)
            end
        --GBA
        elseif showCat == 8 then
            --Graphics.setImageFilters(gba_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if gba_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, gba_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, gba_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, gba_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, gba_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gba_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gba_table[p].ricon)
                Render.useTexture(modCoverNESNoref, gba_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gba_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gba_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gba_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, gba_table[p].icon)
                Render.useTexture(modCoverHbrNoref, gba_table[p].icon)
                Render.useTexture(modCoverPSPNoref, gba_table[p].icon)
                Render.useTexture(modCoverPSXNoref, gba_table[p].icon)
                Render.useTexture(modCoverN64Noref, gba_table[p].icon)
                Render.useTexture(modCoverN64Noref, gba_table[p].icon)
                Render.useTexture(modCoverNESNoref, gba_table[p].icon)
                Render.useTexture(modCoverGBNoref, gba_table[p].icon)
                Render.useTexture(modCoverGBNoref, gba_table[p].icon)
                Render.useTexture(modCoverGBNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
                Render.useTexture(modCoverMDNoref, gba_table[p].icon)
            end
        --GBC
        elseif showCat == 9 then
            --Graphics.setImageFilters(gbc_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if gbc_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gbc_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gbc_table[p].ricon)
                Render.useTexture(modCoverNESNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, gbc_table[p].icon)
                Render.useTexture(modCoverHbrNoref, gbc_table[p].icon)
                Render.useTexture(modCoverPSPNoref, gbc_table[p].icon)
                Render.useTexture(modCoverPSXNoref, gbc_table[p].icon)
                Render.useTexture(modCoverN64Noref, gbc_table[p].icon)
                Render.useTexture(modCoverN64Noref, gbc_table[p].icon)
                Render.useTexture(modCoverNESNoref, gbc_table[p].icon)
                Render.useTexture(modCoverGBNoref, gbc_table[p].icon)
                Render.useTexture(modCoverGBNoref, gbc_table[p].icon)
                Render.useTexture(modCoverGBNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
                Render.useTexture(modCoverMDNoref, gbc_table[p].icon)
            end
        --GB
        elseif showCat == 10 then
            --Graphics.setImageFilters(gb_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if gb_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, gb_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, gb_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, gb_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, gb_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gb_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gb_table[p].ricon)
                Render.useTexture(modCoverNESNoref, gb_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gb_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gb_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gb_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, gb_table[p].icon)
                Render.useTexture(modCoverHbrNoref, gb_table[p].icon)
                Render.useTexture(modCoverPSPNoref, gb_table[p].icon)
                Render.useTexture(modCoverPSXNoref, gb_table[p].icon)
                Render.useTexture(modCoverN64Noref, gb_table[p].icon)
                Render.useTexture(modCoverN64Noref, gb_table[p].icon)
                Render.useTexture(modCoverNESNoref, gb_table[p].icon)
                Render.useTexture(modCoverGBNoref, gb_table[p].icon)
                Render.useTexture(modCoverGBNoref, gb_table[p].icon)
                Render.useTexture(modCoverGBNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
                Render.useTexture(modCoverMDNoref, gb_table[p].icon)
            end
        --MD
        elseif showCat == 11 then
            --Graphics.setImageFilters(md_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if md_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, md_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, md_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, md_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, md_table[p].ricon)
                Render.useTexture(modCoverN64Noref, md_table[p].ricon)
                Render.useTexture(modCoverN64Noref, md_table[p].ricon)
                Render.useTexture(modCoverNESNoref, md_table[p].ricon)
                Render.useTexture(modCoverGBNoref, md_table[p].ricon)
                Render.useTexture(modCoverGBNoref, md_table[p].ricon)
                Render.useTexture(modCoverGBNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
                Render.useTexture(modCoverMDNoref, md_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, md_table[p].icon)
                Render.useTexture(modCoverHbrNoref, md_table[p].icon)
                Render.useTexture(modCoverPSPNoref, md_table[p].icon)
                Render.useTexture(modCoverPSXNoref, md_table[p].icon)
                Render.useTexture(modCoverN64Noref, md_table[p].icon)
                Render.useTexture(modCoverN64Noref, md_table[p].icon)
                Render.useTexture(modCoverNESNoref, md_table[p].icon)
                Render.useTexture(modCoverGBNoref, md_table[p].icon)
                Render.useTexture(modCoverGBNoref, md_table[p].icon)
                Render.useTexture(modCoverGBNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
                Render.useTexture(modCoverMDNoref, md_table[p].icon)
            end
        --SMS
        elseif showCat == 12 then
            --Graphics.setImageFilters(sms_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if sms_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, sms_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, sms_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, sms_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, sms_table[p].ricon)
                Render.useTexture(modCoverN64Noref, sms_table[p].ricon)
                Render.useTexture(modCoverN64Noref, sms_table[p].ricon)
                Render.useTexture(modCoverNESNoref, sms_table[p].ricon)
                Render.useTexture(modCoverGBNoref, sms_table[p].ricon)
                Render.useTexture(modCoverGBNoref, sms_table[p].ricon)
                Render.useTexture(modCoverGBNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
                Render.useTexture(modCoverMDNoref, sms_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, sms_table[p].icon)
                Render.useTexture(modCoverHbrNoref, sms_table[p].icon)
                Render.useTexture(modCoverPSPNoref, sms_table[p].icon)
                Render.useTexture(modCoverPSXNoref, sms_table[p].icon)
                Render.useTexture(modCoverN64Noref, sms_table[p].icon)
                Render.useTexture(modCoverN64Noref, sms_table[p].icon)
                Render.useTexture(modCoverNESNoref, sms_table[p].icon)
                Render.useTexture(modCoverGBNoref, sms_table[p].icon)
                Render.useTexture(modCoverGBNoref, sms_table[p].icon)
                Render.useTexture(modCoverGBNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
                Render.useTexture(modCoverMDNoref, sms_table[p].icon)
            end
        --GG
        elseif showCat == 13 then
            --Graphics.setImageFilters(gg_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if gg_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, gg_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, gg_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, gg_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, gg_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gg_table[p].ricon)
                Render.useTexture(modCoverN64Noref, gg_table[p].ricon)
                Render.useTexture(modCoverNESNoref, gg_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gg_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gg_table[p].ricon)
                Render.useTexture(modCoverGBNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
                Render.useTexture(modCoverMDNoref, gg_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, gg_table[p].icon)
                Render.useTexture(modCoverHbrNoref, gg_table[p].icon)
                Render.useTexture(modCoverPSPNoref, gg_table[p].icon)
                Render.useTexture(modCoverPSXNoref, gg_table[p].icon)
                Render.useTexture(modCoverN64Noref, gg_table[p].icon)
                Render.useTexture(modCoverN64Noref, gg_table[p].icon)
                Render.useTexture(modCoverNESNoref, gg_table[p].icon)
                Render.useTexture(modCoverGBNoref, gg_table[p].icon)
                Render.useTexture(modCoverGBNoref, gg_table[p].icon)
                Render.useTexture(modCoverGBNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
                Render.useTexture(modCoverMDNoref, gg_table[p].icon)
            end
        --MAME
        elseif showCat == 14 then
            --Graphics.setImageFilters(mame_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if mame_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, mame_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, mame_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, mame_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, mame_table[p].ricon)
                Render.useTexture(modCoverN64Noref, mame_table[p].ricon)
                Render.useTexture(modCoverN64Noref, mame_table[p].ricon)
                Render.useTexture(modCoverNESNoref, mame_table[p].ricon)
                Render.useTexture(modCoverGBNoref, mame_table[p].ricon)
                Render.useTexture(modCoverGBNoref, mame_table[p].ricon)
                Render.useTexture(modCoverGBNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
                Render.useTexture(modCoverMDNoref, mame_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, mame_table[p].icon)
                Render.useTexture(modCoverHbrNoref, mame_table[p].icon)
                Render.useTexture(modCoverPSPNoref, mame_table[p].icon)
                Render.useTexture(modCoverPSXNoref, mame_table[p].icon)
                Render.useTexture(modCoverN64Noref, mame_table[p].icon)
                Render.useTexture(modCoverN64Noref, mame_table[p].icon)
                Render.useTexture(modCoverNESNoref, mame_table[p].icon)
                Render.useTexture(modCoverGBNoref, mame_table[p].icon)
                Render.useTexture(modCoverGBNoref, mame_table[p].icon)
                Render.useTexture(modCoverGBNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
                Render.useTexture(modCoverMDNoref, mame_table[p].icon)
            end
        --AMIGA
        elseif showCat == 15 then
            --Graphics.setImageFilters(amiga_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if amiga_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverN64Noref, amiga_table[p].ricon)
                Render.useTexture(modCoverN64Noref, amiga_table[p].ricon)
                Render.useTexture(modCoverNESNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverGBNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverGBNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverGBNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, amiga_table[p].icon)
                Render.useTexture(modCoverHbrNoref, amiga_table[p].icon)
                Render.useTexture(modCoverPSPNoref, amiga_table[p].icon)
                Render.useTexture(modCoverPSXNoref, amiga_table[p].icon)
                Render.useTexture(modCoverN64Noref, amiga_table[p].icon)
                Render.useTexture(modCoverN64Noref, amiga_table[p].icon)
                Render.useTexture(modCoverNESNoref, amiga_table[p].icon)
                Render.useTexture(modCoverGBNoref, amiga_table[p].icon)
                Render.useTexture(modCoverGBNoref, amiga_table[p].icon)
                Render.useTexture(modCoverGBNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
                Render.useTexture(modCoverMDNoref, amiga_table[p].icon)
            end
        --TG16
        elseif showCat == 16 then
            --Graphics.setImageFilters(tg16_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if tg16_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverN64Noref, tg16_table[p].ricon)
                Render.useTexture(modCoverN64Noref, tg16_table[p].ricon)
                Render.useTexture(modCoverNESNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverGBNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverGBNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverGBNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, tg16_table[p].icon)
                Render.useTexture(modCoverHbrNoref, tg16_table[p].icon)
                Render.useTexture(modCoverPSPNoref, tg16_table[p].icon)
                Render.useTexture(modCoverPSXNoref, tg16_table[p].icon)
                Render.useTexture(modCoverN64Noref, tg16_table[p].icon)
                Render.useTexture(modCoverN64Noref, tg16_table[p].icon)
                Render.useTexture(modCoverNESNoref, tg16_table[p].icon)
                Render.useTexture(modCoverGBNoref, tg16_table[p].icon)
                Render.useTexture(modCoverGBNoref, tg16_table[p].icon)
                Render.useTexture(modCoverGBNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
                Render.useTexture(modCoverMDNoref, tg16_table[p].icon)
            end
        --TGCD
        elseif showCat == 17 then
            --Graphics.setImageFilters(tgcd_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if tgcd_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverN64Noref, tgcd_table[p].ricon)
                Render.useTexture(modCoverN64Noref, tgcd_table[p].ricon)
                Render.useTexture(modCoverNESNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverGBNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverGBNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverGBNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverHbrNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverPSPNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverPSXNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverN64Noref, tgcd_table[p].icon)
                Render.useTexture(modCoverN64Noref, tgcd_table[p].icon)
                Render.useTexture(modCoverNESNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverGBNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverGBNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverGBNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
                Render.useTexture(modCoverMDNoref, tgcd_table[p].icon)
            end
        --PCE
        elseif showCat == 18 then
            --Graphics.setImageFilters(pce_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if pce_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, pce_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, pce_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, pce_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, pce_table[p].ricon)
                Render.useTexture(modCoverN64Noref, pce_table[p].ricon)
                Render.useTexture(modCoverN64Noref, pce_table[p].ricon)
                Render.useTexture(modCoverNESNoref, pce_table[p].ricon)
                Render.useTexture(modCoverGBNoref, pce_table[p].ricon)
                Render.useTexture(modCoverGBNoref, pce_table[p].ricon)
                Render.useTexture(modCoverGBNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pce_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, pce_table[p].icon)
                Render.useTexture(modCoverHbrNoref, pce_table[p].icon)
                Render.useTexture(modCoverPSPNoref, pce_table[p].icon)
                Render.useTexture(modCoverPSXNoref, pce_table[p].icon)
                Render.useTexture(modCoverN64Noref, pce_table[p].icon)
                Render.useTexture(modCoverN64Noref, pce_table[p].icon)
                Render.useTexture(modCoverNESNoref, pce_table[p].icon)
                Render.useTexture(modCoverGBNoref, pce_table[p].icon)
                Render.useTexture(modCoverGBNoref, pce_table[p].icon)
                Render.useTexture(modCoverGBNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
                Render.useTexture(modCoverMDNoref, pce_table[p].icon)
            end
        --PCECD
        elseif showCat == 19 then
            --Graphics.setImageFilters(pcecd_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if pcecd_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverN64Noref, pcecd_table[p].ricon)
                Render.useTexture(modCoverN64Noref, pcecd_table[p].ricon)
                Render.useTexture(modCoverNESNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverGBNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverGBNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverGBNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverHbrNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverPSPNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverPSXNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverN64Noref, pcecd_table[p].icon)
                Render.useTexture(modCoverN64Noref, pcecd_table[p].icon)
                Render.useTexture(modCoverNESNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverGBNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverGBNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverGBNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
                Render.useTexture(modCoverMDNoref, pcecd_table[p].icon)
            end
        --NGPC
        elseif showCat == 20 then
            --Graphics.setImageFilters(ngpc_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if ngpc_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverN64Noref, ngpc_table[p].ricon)
                Render.useTexture(modCoverN64Noref, ngpc_table[p].ricon)
                Render.useTexture(modCoverNESNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverGBNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverGBNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverGBNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverHbrNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverPSPNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverPSXNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverN64Noref, ngpc_table[p].icon)
                Render.useTexture(modCoverN64Noref, ngpc_table[p].icon)
                Render.useTexture(modCoverNESNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverGBNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverGBNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverGBNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
                Render.useTexture(modCoverMDNoref, ngpc_table[p].icon)
            end

        --favorites
        elseif showCat == 21 then
            --Graphics.setImageFilters(fav_count[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if fav_count[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, fav_count[p].ricon)
                Render.useTexture(modCoverHbrNoref, fav_count[p].ricon)
                Render.useTexture(modCoverPSPNoref, fav_count[p].ricon)
                Render.useTexture(modCoverPSXNoref, fav_count[p].ricon)
                Render.useTexture(modCoverN64Noref, fav_count[p].ricon)
                Render.useTexture(modCoverN64Noref, fav_count[p].ricon)
                Render.useTexture(modCoverNESNoref, fav_count[p].ricon)
                Render.useTexture(modCoverGBNoref, fav_count[p].ricon)
                Render.useTexture(modCoverGBNoref, fav_count[p].ricon)
                Render.useTexture(modCoverGBNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
                Render.useTexture(modCoverMDNoref, fav_count[p].ricon)
            else 
                Render.useTexture(modCoverNoref, fav_count[p].icon)
                Render.useTexture(modCoverHbrNoref, fav_count[p].icon)
                Render.useTexture(modCoverPSPNoref, fav_count[p].icon)
                Render.useTexture(modCoverPSXNoref, fav_count[p].icon)
                Render.useTexture(modCoverN64Noref, fav_count[p].icon)
                Render.useTexture(modCoverN64Noref, fav_count[p].icon)
                Render.useTexture(modCoverNESNoref, fav_count[p].icon)
                Render.useTexture(modCoverGBNoref, fav_count[p].icon)
                Render.useTexture(modCoverGBNoref, fav_count[p].icon)
                Render.useTexture(modCoverGBNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
                Render.useTexture(modCoverMDNoref, fav_count[p].icon)
            end

        --recently plated
        elseif showCat == 22 then
            --Graphics.setImageFilters(recently_played_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if recently_played_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverN64Noref, recently_played_table[p].ricon)
                Render.useTexture(modCoverN64Noref, recently_played_table[p].ricon)
                Render.useTexture(modCoverNESNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverGBNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverGBNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverGBNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverHbrNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverPSPNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverPSXNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverN64Noref, recently_played_table[p].icon)
                Render.useTexture(modCoverN64Noref, recently_played_table[p].icon)
                Render.useTexture(modCoverNESNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverGBNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverGBNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverGBNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
                Render.useTexture(modCoverMDNoref, recently_played_table[p].icon)
            end

        else
            --Graphics.setImageFilters(files_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
            if files_table[p].ricon ~= nil then
                Render.useTexture(modCoverNoref, files_table[p].ricon)
                Render.useTexture(modCoverHbrNoref, files_table[p].ricon)
                Render.useTexture(modCoverPSPNoref, files_table[p].ricon)
                Render.useTexture(modCoverPSXNoref, files_table[p].ricon)
                Render.useTexture(modCoverN64Noref, files_table[p].ricon)
                Render.useTexture(modCoverN64Noref, files_table[p].ricon)
                Render.useTexture(modCoverNESNoref, files_table[p].ricon)
                Render.useTexture(modCoverGBNoref, files_table[p].ricon)
                Render.useTexture(modCoverGBNoref, files_table[p].ricon)
                Render.useTexture(modCoverGBNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
                Render.useTexture(modCoverMDNoref, files_table[p].ricon)
            else 
                Render.useTexture(modCoverNoref, files_table[p].icon)
                Render.useTexture(modCoverHbrNoref, files_table[p].icon)
                Render.useTexture(modCoverPSPNoref, files_table[p].icon)
                Render.useTexture(modCoverPSXNoref, files_table[p].icon)
                Render.useTexture(modCoverN64Noref, files_table[p].icon)
                Render.useTexture(modCoverN64Noref, files_table[p].icon)
                Render.useTexture(modCoverNESNoref, files_table[p].icon)
                Render.useTexture(modCoverGBNoref, files_table[p].icon)
                Render.useTexture(modCoverGBNoref, files_table[p].icon)
                Render.useTexture(modCoverGBNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
                Render.useTexture(modCoverMDNoref, files_table[p].icon)
            end
        end
        
        local tmpapptype=""
        local tmpcatText=""
        -- Draw box
        if apptype==1 then
            Render.drawModel(modCoverNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[86] -- "PS Vita Game"
        elseif apptype==2 then
            Render.drawModel(modCoverPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[87] -- "PSP Game"
        elseif apptype==3 then
            Render.drawModel(modCoverPSXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[88] -- "PS1 Game"
        elseif apptype==5 then
            Render.drawModel(modCoverN64Noref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxN64Noref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[89] -- "N64 Game"
        elseif apptype==6 then
            Render.drawModel(modCoverN64Noref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxN64Noref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[90] -- "SNES Game"
        elseif apptype==7 then
            Render.drawModel(modCoverNESNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxNESNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[91] -- "NES Game"
        elseif apptype==8 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[92] -- "GBA Game"
        elseif apptype==9 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[93] -- "GBC Game"
        elseif apptype==10 then
            Render.drawModel(modCoverGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxGBNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[94] -- "GB Game"
        elseif apptype==11 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[95] -- "MD Game"
        elseif apptype==12 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[96] -- "SMS Game"
        elseif apptype==13 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[97] -- "GG Game"
        elseif apptype==14 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[98] -- "MAME Game"
        elseif apptype==15 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[99] -- "Amiga Game"
        elseif apptype==16 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[100] -- "TurboGrafx-16 Game"
        elseif apptype==17 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[101] -- "TurboGrafx-16 Game"
        elseif apptype==18 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[102] -- "PC Engine Game"
        elseif apptype==19 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[103] -- "PC Engine CD Game"
        elseif apptype==20 then
            Render.drawModel(modCoverMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxMDNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[104] -- "Neo Geo Pocket Color Game"
        else
            Render.drawModel(modCoverHbrNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            tmpapptype = lang_lines[105] -- "Homebrew"
        end
    
        Font.print(fnt22, 50, 190, txtname, white)-- app name


        -- Show fav icon if game if a favourite
        if favourite_flag == true then
            Graphics.drawImage(420, 50, imgFavorite_large_on)
        else
            Graphics.drawImage(420, 50, imgFavorite_large_off)
        end


        -- 0 Homebrew, 1 vita, 2 psp, 3 psx, 5+ Retro

        if apptype == 0 or apptype == 1 or apptype == 2 or apptype == 3 then
            Font.print(fnt22, 50, 240, tmpapptype .. "\n" .. lang_lines[55] .. app_titleid .. "\n" .. lang_lines[12] .. app_version .. "\n" .. lang_lines[56] .. game_size, white)-- Draw info
            --                                               App ID                                   Version                                  Size
        else
            Font.print(fnt22, 50, 240, tmpapptype .. "\n" .. lang_lines[12] .. app_version .. "\n" .. lang_lines[56] .. game_size, white)-- Draw info
            --                                               Version                                  Size
        end


        if tmpappcat==1 then
            tmpcatText = "PS Vita"
        elseif tmpappcat==2 then
            tmpcatText = "PSP"
        elseif tmpappcat==3 then
            tmpcatText = "PS1"
        elseif tmpappcat==4 then
            tmpcatText = lang_lines[105] -- "Homebrew"
        else
            tmpcatText = lang_lines[54] -- Default
        end

        menuItems = 1


        -- 0 Homebrew, 1 Vita, 2 PSP, 3 PSX, 5+ Retro

        -- Vita and Homebrew
        -- if folder == true then -- start Disable category override for retro
        if apptype == 0 or apptype == 1 or apptype == 2 or apptype == 3 then -- start Disable category override for retro
            if menuY==1 then
                Graphics.fillRect(24, 470, 350 + (menuY * 40), 430 + (menuY * 40), themeCol)-- selection two lines
            else
                Graphics.fillRect(24, 470, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
            end
            Font.print(fnt22, 50, 352, lang_lines[57], white)
            --                         Download Cover

            -- Make box wider for German, French, Russian, Portuguese
            if setLanguage == 2 or setLanguage == 3 or setLanguage == 6 or setLanguage == 8 then
                Font.print(fnt22, 50, 352+40, lang_lines[58].. "\n< " .. tmpcatText .. " >\n( " .. lang_lines[59] .. ")", white)
            --                            Override Category                                        Press X to apply Category
            else
                Font.print(fnt22, 50, 352+40, lang_lines[58].. "< " .. tmpcatText .. " >\n( " .. lang_lines[59] .. ")", white)
            --                            Override Category                                      Press X to apply Category
            end


        -- All other systems
        else
            if menuY==1 then                
            else
                Graphics.fillRect(24, 470, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
            end
            Font.print(fnt22, 50, 352, lang_lines[57], white)
            --                         Download Cover
        end
        

        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS)) then
                if menuY == 0 then
                    if gettingCovers == false then
                        gettingCovers = true
                        DownloadSingleCover()
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
                if menuY==1 then
                    -- Vita and Homebrew override
                    if tmpappcat > 0 then
                        tmpappcat = tmpappcat - 1
                    else
                        tmpappcat=4 -- Limited to 4
                    end
                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
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

            
        elseif showMenu == 2 then
        
        -- SETTINGS
        -- Footer buttons and icons
        -- Get text widths for positioning
        local label1 = Font.getTextWidth(fnt20, lang_lines[11])--Close
        local label2 = Font.getTextWidth(fnt20, lang_lines[32])--Select
        local label3 = Font.getTextWidth(fnt20, lang_lines[13])--About

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines[11], white)--Close

        Graphics.drawImage(900-(btnMargin * 2)-label1-label2, 510, btnX)
        Font.print(fnt20, 900+28-(btnMargin * 2)-label1-label2, 508, lang_lines[32], white)--Select

        Graphics.drawImage(900-(btnMargin * 4)-label1-label2-label3, 510, btnT)
        Font.print(fnt20, 900+28-(btnMargin * 4)-label1-label2-label3, 508, lang_lines[13], white)--About

        Graphics.fillRect(60, 900, 24, 468, darkalpha)

        Font.print(fnt22, 84, 32, lang_lines[6], white)--SETTINGS
        Graphics.drawLine(60, 900, 66, 66, white)

        Graphics.fillRect(60, 900, 66 + (menuY * 40), 106 + (menuY * 40), themeCol)-- selection

        menuItems = 9
        
        -- Chinese language fix
        if setLanguage == 10 then
            Font.print(fnt22, 77, 72, lang_lines[14], white)--Startup Category
        else
            Font.print(fnt22, 84, 72, lang_lines[14], white)--Startup Category
        end
        if startCategory == 0 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[5], white)--ALL
        elseif startCategory == 1 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[1], white)--GAMES
        elseif startCategory == 2 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[2], white)--HOMEBREWS
        elseif startCategory == 3 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[3], white)--PSP
        elseif startCategory == 4 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[4], white)--PSX
        elseif startCategory == 5 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[33], white)--N64
        elseif startCategory == 6 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[34], white)--SNES
        elseif startCategory == 7 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[35], white)--NES
        elseif startCategory == 8 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[36], white)--GBA
        elseif startCategory == 9 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[37], white)--GBC
        elseif startCategory == 10 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[38], white)--GB
        elseif startCategory == 11 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[39], white)--MD
        elseif startCategory == 12 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[40], white)--SMS
        elseif startCategory == 13 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[41], white)--GG
        elseif startCategory == 14 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[42], white)--MAME
        elseif startCategory == 15 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[43], white)--AMIGA
        elseif startCategory == 16 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[44], white)--TG16
        elseif startCategory == 17 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[45], white)--TGCD
        elseif startCategory == 18 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[46], white)--PCE
        elseif startCategory == 19 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[47], white)--PCECD
        elseif startCategory == 20 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[48], white)--NGPC
        elseif startCategory == 21 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[107], white)--Favorite
        elseif startCategory == 22 then
            Font.print(fnt22, 125 + 260, 72, lang_lines[109], white)--Recently Played
        end

        
        Font.print(fnt22, 84, 72 + 40, lang_lines[15], white) -- REFLECTION
        if setReflections == 1 then
            Font.print(fnt22, 125 + 260, 72 + 40, lang_lines[22], white)--ON
        else
            -- Chinese language fix
            if setLanguage == 10 then
                Font.print(fnt22, 117 + 260, 72 + 40, lang_lines[23], white)--OFF
            else
                Font.print(fnt22, 125 + 260, 72 + 40, lang_lines[23], white)--OFF
            end
        end
        
        Font.print(fnt22, 84, 72 + 80, lang_lines[16], white)--SOUNDS
        if setSounds == 1 then
            Font.print(fnt22, 125 + 260, 72 + 80, lang_lines[22], white)--ON
        else
            -- Chinese language fix
            if setLanguage == 10 then
                Font.print(fnt22, 117 + 260, 72 + 80, lang_lines[23], white)--OFF
            else
                Font.print(fnt22, 125 + 260, 72 + 80, lang_lines[23], white)--OFF
            end
        end
        
        Font.print(fnt22, 84, 72 + 120,  lang_lines[17], white)
        if themeColor == 1 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[24], white)--Red
        elseif themeColor == 2 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[25], white)--Yellow
        elseif themeColor == 3 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[26], white)--Green
        elseif themeColor == 4 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[27], white)--Grey
        elseif themeColor == 5 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[28], white)--Black
        elseif themeColor == 6 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[29], white)--Purple
        elseif themeColor == 7 then
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[30], white)--Orange
        else
            Font.print(fnt22, 125 + 260, 72 + 120, lang_lines[31], white)--Blue
        end
        
        Font.print(fnt22, 84, 72 + 160,  lang_lines[18], white)
        if setBackground == 1 then
            Font.print(fnt22, 125 + 260, 72 + 160, lang_lines[22], white)--ON
        else
            -- Chinese language fix
            if setLanguage == 10 then
                Font.print(fnt22, 117 + 260, 72 + 160, lang_lines[23], white)--OFF
            else
                Font.print(fnt22, 125 + 260, 72 + 160, lang_lines[23], white)--OFF
            end
        end
        
        if scanComplete == false then
            if getCovers == 1 then
            Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[1] .. "  >", white)--Download Covers PS VITA
            elseif getCovers == 2 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[3] .. "  >", white)--Download Covers PSP
            elseif getCovers == 3 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[4] .."  >", white)--Download Covers PSX
            elseif getCovers == 4 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[33] .. "  >", white)--Download Covers N64
            elseif getCovers == 5 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[34] .. "  >", white)--Download Covers SNES
            elseif getCovers == 6 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[35] .. "  >", white)--Download Covers NES
            elseif getCovers == 7 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[36] .. "  >", white)--Download Covers GBA
            elseif getCovers == 8 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[37] .. "  >", white)--Download Covers GBC
            elseif getCovers == 9 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[38] .. "  >", white)--Download Covers GB
            elseif getCovers == 10 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[39] .. "  >", white)--Download Covers MD
            elseif getCovers == 11 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[40] .. "  >", white)--Download Covers SMS
            elseif getCovers == 12 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[41] .. "  >", white)--Download Covers GG
            elseif getCovers == 13 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[42] .. "  >", white)--Download Covers MAME
            elseif getCovers == 14 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[43] .. "  >", white)--Download Covers AMIGA
            elseif getCovers == 15 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[44] .. "  >", white)--Download Covers TG16
            elseif getCovers == 16 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[45] .. "  >", white)--Download Covers TGCD
            elseif getCovers == 17 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[46] .. "  >", white)--Download Covers PCE 
            elseif getCovers == 18 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[47] .. "  >", white)--Download Covers PCECD
            elseif getCovers == 19 then
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[48] .. "  >", white)--Download Covers NGPC       
            else
                Font.print(fnt22, 84, 72 + 200, lang_lines[19] .. "  <   " .. lang_lines[5] .. "  >", white)--Download Covers All
            end
        else
            Font.print(fnt22, 84, 72 + 200,  lang_lines[20], white)--Reload Covers Database
        end
        
        Font.print(fnt22, 84, 72 + 240, lang_lines[21], white)--Language
        if setLanguage == 1 then
            Font.print(fnt22, 125 + 260, 72 + 240, "English - American", white) -- English - American
        elseif setLanguage == 2 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Deutsch", white) -- German
        elseif setLanguage == 3 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Français", white) -- French
        elseif setLanguage == 4 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Italiano", white) -- Italian
        elseif setLanguage == 5 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Español", white) -- Spanish
        elseif setLanguage == 6 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Português", white) -- Portuguese
        elseif setLanguage == 7 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Svenska", white) -- Swedish
        elseif setLanguage == 8 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Pусский", white) -- Russian
        elseif setLanguage == 9 then
            Font.print(fnt22, 125 + 260, 72 + 240, "日本語", white) -- Japanese
        elseif setLanguage == 10 then
            Font.print(fnt22, 125 + 260, 72 + 240, "繁體中文", white) -- Japanese
        elseif setLanguage == 11 then
            Font.print(fnt22, 125 + 260, 72 + 240, "Polski", white) -- Polish
        else
            Font.print(fnt22, 125 + 260, 72 + 240, "English", white) -- English
        end
        
        Font.print(fnt22, 84, 72 + 280, lang_lines[49], white)--Show Homebrews
        if showHomebrews == 1 then
            Font.print(fnt22, 125 + 260, 72 + 280, lang_lines[22], white)--ON
        else
            -- Chinese language fix
            if setLanguage == 10 then
                Font.print(fnt22, 117 + 260, 72 + 280, lang_lines[23], white)--OFF
            else
                Font.print(fnt22, 125 + 260, 72 + 280, lang_lines[23], white)--OFF
            end
        end

        Font.print(fnt22, 84, 72 + 320, lang_lines[110], white)--Recently Played
        if showRecentlyPlayed == 1 then
            Font.print(fnt22, 125 + 260, 72 + 320, lang_lines[22], white)--ON
        else
            -- Chinese language fix
            if setLanguage == 10 then
                Font.print(fnt22, 117 + 260, 72 + 320, lang_lines[23], white)--OFF
            else
                Font.print(fnt22, 125 + 260, 72 + 320, lang_lines[23], white)--OFF
            end
        end


        -- Chinese language fix
        if setLanguage == 10 then
            Font.print(fnt22, 77, 72 + 360, lang_lines[50], white)--Scan on startup
        else
            Font.print(fnt22, 84, 72 + 360, lang_lines[50], white)--Scan on startup
        end

        if startupScan == 1 then
            Font.print(fnt22, 125 + 260, 72 + 360, lang_lines[22], white)--ON
        else
            -- Chinese language fix
            if setLanguage == 10 then
                Font.print(fnt22, 117 + 260, 72 + 360, lang_lines[23], white)--OFF
            else
                Font.print(fnt22, 125 + 260, 72 + 360, lang_lines[23], white)--OFF
            end
        end

        
        
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS)) then
                if menuY == 0 then
                    if startCategory < 22 then -- Increase to total count of systems
                        startCategory = startCategory + 1
                    else
                        startCategory = 0
                    end
                elseif menuY == 1 then
                    if setReflections == 1 then
                        setReflections = 0
                    else
                        setReflections = 1
                    end
                elseif menuY == 2 then
                    if setSounds == 1 then
                        setSounds = 0
                        if System.doesFileExist(cur_dir .. "/Music.mp3") then
                            if Sound.isPlaying(sndMusic) then
                                Sound.pause(sndMusic)
                            end
                        end
                    else
                        setSounds = 1
                        if System.doesFileExist(cur_dir .. "/Music.mp3") then
                            if not Sound.isPlaying(sndMusic) then
                                Sound.play(sndMusic, LOOP)
                            end
                        end
                    end
                elseif menuY == 3 then
                    if themeColor < 7 then
                        themeColor = themeColor + 1
                    else
                        themeColor = 0
                    end
                    SetThemeColor()
                elseif menuY == 4 then
                    if setBackground == 1 then
                        setBackground = 0
                    else
                        setBackground = 1
                    end
                elseif menuY == 5 then
                    if gettingCovers == false then
                        gettingCovers = true
                        DownloadCovers()
                    end
                elseif menuY == 6 then
                    if setLanguage < 11 then
                        setLanguage = setLanguage + 1
                    else
                        setLanguage = 0
                    end
                    ChangeLanguage()
                elseif menuY == 7 then
                    if showHomebrews == 1 then
                        showHomebrews = 0
                        -- Import cache to update All games category
                        count_cache_and_reload()

                        -- If currently on homebrew category view, move to Vita category to hide empty homebrew category
                        if showCat == 2 then
                            showCat = 1
                        end

                    else
                        showHomebrews = 1
                        -- Import cache to update All games category
                        count_cache_and_reload()

                    end
                elseif menuY == 8 then
                    if showRecentlyPlayed == 1 then -- 0 Off, 1 On
                        showRecentlyPlayed = 0
                        -- Import cache to update All games category
                        count_cache_and_reload()

                        -- If currently on recent category view, move to Vita category to hide empty recent category
                        if showCat == 22 then
                            curTotal = #recently_played_table
                            if #recently_played_table == 0 then
                                showCat = 1
                            end
                        end

                    else
                        showRecentlyPlayed = 1
                        -- Import cache to update All games category
                        count_cache_and_reload()

                    end
                elseif menuY == 9 then
                    if startupScan == 1 then -- 0 Off, 1 On
                        startupScan = 0
                        -- Print to Cache folder
                        count_cache_and_reload()
                    else
                        startupScan = 1
                        count_cache_and_reload()

                    end
                elseif menuY == 9 then
                    showMenu = 3
                    menuY = 0
                end
                
                
                --Save settings
                local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)

                settings = {}
                local settings = "Reflections=" .. setReflections .. " " .. "\nSounds=" .. setSounds .. " " .. "\nColor=" .. themeColor .. " " .. "\nBackground=" .. setBackground .. " " .. "\nLanguage=" .. setLanguage .. " " .. "\nView=" .. showView .. " " .. "\nHomebrews=" .. showHomebrews .. " " .. "\nScan=" .. startupScan .. " " .. "\nCategory=" .. startCategory .. " " .. "\nRecent=" .. showRecentlyPlayed
                file_settings = io.open(cur_dir .. "/config.dat", "w")
                file_settings:write(settings)
                file_settings:close()

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
                if menuY==5 then
                    if getCovers > 0 then
                        getCovers = getCovers - 1
                    else
                        getCovers=19 -- Check getcover number against sytem
                    end
                end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                --covers download selection
                if menuY==5 then
                    if getCovers < 19 then -- Check getcover number against sytem
                        getCovers = getCovers + 1
                    else
                        getCovers=0
                    end
                end
            end
        end
    elseif showMenu == 3 then
        
        -- ABOUT
        -- Footer buttons and icons
        local label1 = Font.getTextWidth(fnt20, lang_lines[11])--Close

        Graphics.drawImage(900-label1, 510, btnO)
        Font.print(fnt20, 900+28-label1, 508, lang_lines[11], white)--Close
        
        Graphics.fillRect(30, 930, 24, 496, darkalpha)-- bg
        
        Font.print(fnt20, 54, 42, "RetroFlow Launcher - ver." .. appversion 
            .. "\n"
            .. "\nRetroFlow (Hexflow mod) by jimbob4000. Original HexFlow app by VitaHex."
            .. "\nSupport his projects on patreon.com/vitahex", white)-- Draw info

        Font.print(fnt20, 54, 132, "Adding Retro Games:"
            .. "\nPlace your game roms in the pre-made folders here 'ux0:/data/RetroFlow/ROMS'"
            .. "\n"
            .. "\nAdding PSP Games:"
            .. "\nPlease rename ISO files using Leecherman's 'PSP ISO Renamer tool'."
            .. "\nTool Parameters: %NAME% (%REGION%) [%ID%]."
            .. "\nSample: Cars 2 (US) [UCUS-98766].iso"
            .. "\n"
            .. "\nFor updates & more info visit: https://github.com/jimbob4000/RetroFlow-Launcher"
            .. "\n"
            .. "\nCREDITS"
            .. "\n"
            .. "\nOriginal app by VitHex. Programming/UI by Sakis RG. Developed with Lua Player"
            .. "\nPlus by Rinnegatamante. Special Thanks: VitaHex, Creckeryop, Rinnegatamante,"
            .. "\nAndreas Stürmer, Roc6d, Badmanwazzy37, Leecherman. Translations: TheheroGAC,"
            .. "\nchronoss, stuermerandreas, kodyna91, _novff, Spoxnus86, nighto, iGlitch, SK00RUPA.", white)-- Draw info"

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
                    GetInfoSelected()
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
                    GetInfoSelected()
                end
                
                if (p >= master_index) then
                    master_index = p
                end
            end
        end
        
        -- Navigation Buttons
        if (Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS)) then
            if gettingCovers == false and app_title~="-" then
                FreeMemory()
                AddtoRecentlyPlayed()
                update_cached_table_recently_played_pre_launch()

                if showCat == 1 then
                    if string.match (games_table[p].game_path, "ux0:/pspemu") then
                        rom_location = tostring(games_table[p].launch_argument)
                        launch_Adrenaline()
                    else
                        System.launchApp(games_table[p].name)
                    end

                elseif showCat == 2 then
                    if string.match (homebrews_table[p].game_path, "ux0:/pspemu") then
                        rom_location = tostring(homebrews_table[p].launch_argument)
                        launch_Adrenaline()
                    else
                        System.launchApp(homebrews_table[p].name)
                    end

                elseif showCat == 3 then
                    if string.match (psp_table[p].game_path, "ux0:/pspemu") then
                        rom_location = tostring(psp_table[p].launch_argument)
                        launch_Adrenaline()
                    else
                        System.launchApp(psp_table[p].name)
                    end

                elseif showCat == 4 then
                    if string.match (psx_table[p].game_path, "ux0:/pspemu") then
                        rom_location = tostring(psx_table[p].launch_argument)
                        launch_Adrenaline()
                    else
                        System.launchApp(psx_table[p].name)
                    end

                -- Start Retro    
                elseif showCat == 5 then
                    rom_location = (n64_table[p].game_path)
                    clean_launch_dir()
                    launch_DaedalusX64()
                elseif showCat == 6 then
                    rom_location = (snes_table[p].game_path)
                    core_name = core_SNES
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 7 then
                    rom_location = (nes_table[p].game_path)
                    core_name = core_NES
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 8 then
                    rom_location = (gba_table[p].game_path)
                    core_name = core_GBA
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 9 then
                    rom_location = (gbc_table[p].game_path)
                    core_name = core_GBC
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 10 then
                    rom_location = (gb_table[p].game_path)
                    core_name = core_GB
                    clean_launch_dir()
                    launch_retroarch()    
                elseif showCat == 11 then
                    rom_location = (md_table[p].game_path)
                    core_name = core_MD
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 12 then
                    rom_location = (sms_table[p].game_path)
                    core_name = core_SMS
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 13 then
                    rom_location = (gg_table[p].game_path)
                    core_name = core_GG
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 14 then
                    rom_location = (mame_table[p].game_path)
                    core_name = core_MAME
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 15 then
                    rom_location = (amiga_table[p].game_path)
                    core_name = core_AMIGA
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 16 then
                    rom_location = (tg16_table[p].game_path)
                    core_name = core_TG16
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 17 then
                    rom_location = (tgcd_table[p].game_path)
                    core_name = core_TGCD
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 18 then
                    rom_location = (pce_table[p].game_path)
                    core_name = core_PCE
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 19 then
                    rom_location = (pcecd_table[p].game_path)
                    core_name = core_PCECD
                    clean_launch_dir()
                    launch_retroarch()
                elseif showCat == 20 then
                    rom_location = (ngpc_table[p].game_path)
                    core_name = core_NGPC
                    clean_launch_dir()
                    launch_retroarch()

                elseif showCat == 21 then
                    if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                        if string.match (fav_count[p].game_path, "ux0:/pspemu") then
                            rom_location = tostring(fav_count[p].launch_argument)
                            launch_Adrenaline()
                        else
                            System.launchApp(fav_count[p].name)
                        end

                    -- Start Retro    
                    elseif apptype == 5 then
                        rom_location = (fav_count[p].game_path)
                        clean_launch_dir()
                        launch_DaedalusX64()

                    elseif apptype == 6 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_SNES
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 7 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_NES
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 8 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_GBA
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 9 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_GBC
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 10 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_GB
                        clean_launch_dir()
                        launch_retroarch()
                        
                    elseif apptype == 11 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_MD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 12 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_SMS
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 13 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_GG
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 14 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_MAME
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 15 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_AMIGA
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 16 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_TG16
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 17 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_TGCD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 18 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_PCE
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 19 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_PCECD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 20 then
                        rom_location = (fav_count[p].game_path)
                        core_name = core_NGPC
                        clean_launch_dir()
                        launch_retroarch()

                    else
                        -- Homebrew
                        if string.match (fav_count[p].game_path, "ux0:/pspemu") then
                            rom_location = (fav_count[p].launch_argument)
                            launch_Adrenaline()
                        else
                            System.launchApp(fav_count[p].name)
                        end

                        appdir=working_dir .. "/" .. fav_count[p].name
                    end

                elseif showCat == 22 then
                    if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                        if string.match (recently_played_table[p].game_path, "ux0:/pspemu") then
                            rom_location = tostring(recently_played_table[p].launch_argument)
                            launch_Adrenaline()
                        else
                            System.launchApp(recently_played_table[p].name)
                        end

                    -- Start Retro    
                    elseif apptype == 5 then
                        rom_location = (recently_played_table[p].game_path)
                        clean_launch_dir()
                        launch_DaedalusX64()

                    elseif apptype == 6 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_SNES
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 7 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_NES
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 8 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_GBA
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 9 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_GBC
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 10 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_GB
                        clean_launch_dir()
                        launch_retroarch()
                        
                    elseif apptype == 11 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_MD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 12 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_SMS
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 13 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_GG
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 14 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_MAME
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 15 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_AMIGA
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 16 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_TG16
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 17 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_TGCD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 18 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_PCE
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 19 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_PCECD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 20 then
                        rom_location = (recently_played_table[p].game_path)
                        core_name = core_NGPC
                        clean_launch_dir()
                        launch_retroarch()

                    else
                        -- Homebrew
                        if string.match (recently_played_table[p].game_path, "ux0:/pspemu") then
                            rom_location = (recently_played_table[p].launch_argument)
                            launch_Adrenaline()
                        else
                            System.launchApp(recently_played_table[p].name)
                        end

                        appdir=working_dir .. "/" .. recently_played_table[p].name
                    end

                -- End Retro 
                else

                    if apptype == 1 or apptype == 2 or apptype == 3 or apptype == 4 then
                        if string.match (files_table[p].game_path, "ux0:/pspemu") then
                            rom_location = tostring(files_table[p].launch_argument)
                            launch_Adrenaline()
                        else
                            System.launchApp(files_table[p].name)
                        end

                    -- Start Retro    
                    elseif apptype == 5 then
                        rom_location = (files_table[p].game_path)
                        clean_launch_dir()
                        launch_DaedalusX64()

                    elseif apptype == 6 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_SNES
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 7 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_NES
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 8 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_GBA
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 9 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_GBC
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 10 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_GB
                        clean_launch_dir()
                        launch_retroarch()
                        
                    elseif apptype == 11 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_MD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 12 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_SMS
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 13 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_GG
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 14 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_MAME
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 15 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_AMIGA
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 16 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_TG16
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 17 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_TGCD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 18 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_PCE
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 19 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_PCECD
                        clean_launch_dir()
                        launch_retroarch()

                    elseif apptype == 20 then
                        rom_location = (files_table[p].game_path)
                        core_name = core_NGPC
                        clean_launch_dir()
                        launch_retroarch()

                    else
                        -- Homebrew
                        if string.match (files_table[p].game_path, "ux0:/pspemu") then
                            rom_location = (files_table[p].launch_argument)
                            launch_Adrenaline()
                        else
                            System.launchApp(files_table[p].name)
                        end

                        appdir=working_dir .. "/" .. files_table[p].name
                    end
                end
                System.exit()
            end
        elseif (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) then
            if showMenu == 0 and app_title~="-" then
                prvRotY = 0
                showMenu = 1
            end
        elseif (Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START)) then
            if showMenu == 0 then
                showMenu = 2
            end
        elseif (Controls.check(pad, SCE_CTRL_SQUARE) and not Controls.check(oldpad, SCE_CTRL_SQUARE)) then
            -- CATEGORY

            if showCat < 22 then -- Increase to match category count
                if showCat==1 and showHomebrews==0 then
                    showCat = 3
                else
                    showCat = showCat + 1
                end
            else
                showCat = 0
            end

            -- Start skip empty categories
            if showCat == 3 then
                curTotal = #psp_table
                if #psp_table == 0 then
                    showCat = 4
                end
            end
            if showCat == 4 then
                curTotal = #psx_table
                if #psx_table == 0 then
                    showCat = 5
                end
            end
            if showCat == 5 then
                curTotal = #n64_table
                if #n64_table == 0 then
                    showCat = 6
                end
            end
            if showCat == 6 then
                curTotal = #snes_table
                if #snes_table == 0 then
                    showCat = 7
                end
            end
            if showCat == 7 then
                curTotal = #nes_table
                if #nes_table == 0 then
                    showCat = 8
                end
            end
            if showCat == 8 then
                curTotal = #gba_table
                if #gba_table == 0 then
                    showCat = 9
                end
            end
            if showCat == 9 then
                curTotal = #gbc_table
                if #gbc_table == 0 then
                    showCat = 10
                end
            end
            if showCat == 10 then
                curTotal = #gb_table
                if #gb_table == 0 then
                    showCat = 11
                end
            end
            if showCat == 11 then
                curTotal = #md_table
                if #md_table == 0 then
                    showCat = 12
                end
            end
            if showCat == 12 then
                curTotal = #sms_table
                if #sms_table == 0 then
                    showCat = 13
                end
            end
            if showCat == 13 then
                curTotal = #gg_table
                if #gg_table == 0 then
                    showCat = 14
                end
            end
            if showCat == 14 then
                curTotal = #mame_table
                if #mame_table == 0 then
                    showCat = 15
                end
            end
            if showCat == 15 then
                curTotal = #amiga_table
                if #amiga_table == 0 then
                    showCat = 16
                end
            end
            if showCat == 16 then
                curTotal = #tg16_table
                if #tg16_table == 0 then
                    showCat = 17
                end
            end
            if showCat == 17 then
                curTotal = #tgcd_table
                if #tgcd_table == 0 then
                    showCat = 18
                end
            end
            if showCat == 18 then
                curTotal = #pce_table
                if #pce_table == 0 then
                    showCat = 19
                end
            end
            if showCat == 19 then
                curTotal = #pcecd_table
                if #pcecd_table == 0 then
                    showCat = 20
                end
            end
            if showCat == 20 then
                curTotal = #ngpc_table
                if #ngpc_table == 0 then
                    showCat = 21
                end
            end
            if showCat == 21 then
                -- count favorites
                local fav_count = {}
                for l, file in pairs(files_table) do
                    if showHomebrews == 0 then
                        -- ignore homebrew apps
                        if file.app_type > 0 then
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
                end
                curTotal = #fav_count
                if #fav_count == 0 then
                    showCat = 22
                end
            end
            if showCat == 22 then      
                curTotal = #recently_played_table
                if #recently_played_table == 0 then
                    showCat = 0
                end
            end

            hideBoxes = 8
            p = 1
            master_index = p
            startCovers = false
            GetInfoSelected()
            FreeIcons()
        elseif (Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE)) then
            -- VIEW
            if showView < 4 then
                showView = showView + 1
            else
                showView = 0
            end
            menuY = 0
            startCovers = false
            local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
            settings = {}
            local settings = "Reflections=" .. setReflections .. " " .. "\nSounds=" .. setSounds .. " " .. "\nColor=" .. themeColor .. " " .. "\nBackground=" .. setBackground .. " " .. "\nLanguage=" .. setLanguage .. " " .. "\nView=" .. showView .. " " .. "\nHomebrews=" .. showHomebrews .. " " .. "\nScan=" .. startupScan .. " " .. "\nCategory=" .. startCategory
            file_settings = io.open(cur_dir .. "/config.dat", "w")
            file_settings:write(settings)
            file_settings:close()

        elseif (Controls.check(pad, SCE_CTRL_LEFT)) and not (Controls.check(oldpad, SCE_CTRL_LEFT)) then
            if setSounds == 1 then
                Sound.play(click, NO_LOOP)
            end
            p = p - 1
            
            if p > 0 then
                GetInfoSelected()
            end
            
            if (p <= master_index) then
                master_index = p
            end
        elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
            if setSounds == 1 then
                Sound.play(click, NO_LOOP)
            end
            p = p + 1
            
            if p <= curTotal then
                GetInfoSelected()
            end
            
            if (p >= master_index) then
                master_index = p
            end
        elseif (Controls.check(pad, SCE_CTRL_LTRIGGER)) and not (Controls.check(oldpad, SCE_CTRL_LTRIGGER)) then
            if setSounds == 1 then
                Sound.play(click, NO_LOOP)
            end
            p = p - 5 -- Increased to 6 for GB -- IGNORE COMMENT??
            
            if p > 0 then
                GetInfoSelected()
            end
            
            if (p <= master_index) then
                master_index = p
            end
        elseif (Controls.check(pad, SCE_CTRL_RTRIGGER)) and not (Controls.check(oldpad, SCE_CTRL_RTRIGGER)) then
            if setSounds == 1 then
                Sound.play(click, NO_LOOP)
            end
            p = p + 5 -- Increased to 6 for GB -- IGNORE COMMENT??
            
            if p <= curTotal then
                GetInfoSelected()
            end
            
            if (p >= master_index) then
                master_index = p
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
                        GetInfoSelected()
                    end
                    if (p <= master_index) then
                        master_index = p
                    end
                elseif x1 < xstart - 60 then
                    touchdown = 2
                    xstart = x1
                    p = p + 1
                    if p <= curTotal then
                        GetInfoSelected()
                    end
                    if (p >= master_index) then
                        master_index = p
                    end
                
                end
            end
        end
    elseif showMenu > 0 then
        if (Controls.check(pad, SCE_CTRL_CIRCLE) and not Controls.check(oldpad, SCE_CTRL_CIRCLE)) then
            status = System.getMessageState()
            if status ~= RUNNING then
                showMenu = 0
                prvRotY = 0
                if setBackground == 1 then
                    Render.useTexture(modBackground, imgCustomBack)
                end
            end
        end

        -- Triangle button - Game info screen
        if (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) and showMenu == 1 then
            -- Favourites
            AddOrRemoveFavorite()
            status = System.getMessageState()
            if status ~= RUNNING then
                showMenu = 0
                prvRotY = 0
                if setBackground == 1 then
                    Render.useTexture(modBackground, imgCustomBack)
                end
            end
        end

        -- Triangle button - Settings screen
        if (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) and showMenu == 2 then
            status = System.getMessageState()
            if status ~= RUNNING then
                showMenu = 3
            end
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
    elseif showCat == 2 then
        curTotal = #homebrews_table
        if #homebrews_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 3 then
        curTotal = #psp_table
        if #psp_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 4 then
        curTotal = #psx_table
        if #psx_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 5 then
        curTotal = #n64_table
        if #n64_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 6 then
        curTotal = #snes_table
        if #snes_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 7 then
        curTotal = #nes_table
        if #nes_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 8 then
        curTotal = #gba_table
        if #gba_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 9 then
        curTotal = #gbc_table
        if #gbc_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 10 then
        curTotal = #gb_table
        if #gb_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 11 then
        curTotal = #md_table
        if #md_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 12 then
        curTotal = #sms_table
        if #sms_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 13 then
        curTotal = #gg_table
        if #gg_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 14 then
        curTotal = #mame_table
        if #mame_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 15 then
        curTotal = #amiga_table
        if #amiga_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 16 then
        curTotal = #tg16_table
        if #tg16_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 17 then
        curTotal = #tgcd_table
        if #tgcd_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 18 then
        curTotal = #pce_table
        if #pce_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 19 then
        curTotal = #pcecd_table
        if #pcecd_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 20 then
        curTotal = #ngpc_table
        if #ngpc_table == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 21 then

        -- count favorites
        local fav_count_2 = {}
        for l, file in pairs(files_table) do
            if file.favourite==true then
                table.insert(fav_count_2, file)
            end
        end

        curTotal = #fav_count_2
        if #fav_count_2 == 0 then
            p = 0
            master_index = p
        end
    elseif showCat == 22 then
        curTotal = #recently_played_table
        if #recently_played_table == 0 then
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
    
    -- Refreshing screen and oldpad
    Screen.waitVblankStart()
    Screen.flip()
    oldpad = pad
end
