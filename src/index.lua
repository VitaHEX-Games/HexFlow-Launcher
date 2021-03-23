-- HexFlow Launcher  version 0.5 by VitaHEX
-- https://www.patreon.com/vitahex

dofile("app0:addons/threads.lua")
local working_dir = "ux0:/app"
local appversion = "0.5"
function System.currentDirectory(dir)
    if dir == nil then
        return working_dir
    else
        working_dir = dir
    end
end

Network.init()
local onlineCovers = "https://raw.githubusercontent.com/andiweli/hexflow-covers/main/Covers/PSVita/"
local onlineCoversPSP = "https://raw.githubusercontent.com/andiweli/hexflow-covers/main/Covers/PSP/"
local onlineCoversPSX = "https://raw.githubusercontent.com/andiweli/hexflow-covers/main/Covers/PS1/"

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
Graphics.setImageFilters(imgFloor, FILTER_LINEAR, FILTER_LINEAR)

local cur_dir = "ux0:/data/HexFlow/"
local covers_psv = "ux0:/data/HexFlow/COVERS/PSVITA/"
local covers_psp = "ux0:/data/HexFlow/COVERS/PSP/"
local covers_psx = "ux0:/data/HexFlow/COVERS/PSX/"

-- Create directories
System.createDirectory("ux0:/data/HexFlow/")
System.createDirectory("ux0:/data/HexFlow/COVERS/")
System.createDirectory(covers_psv)
System.createDirectory(covers_psp)
System.createDirectory(covers_psx)

if not System.doesFileExist(cur_dir .. "/overrides.dat") then
	local file_over = System.openFile(cur_dir .. "/overrides.dat", FCREATE)
    System.writeFile(file_over, " ", 1)
    System.closeFile(file_over)
end

-- load textures
local imgBox = Graphics.loadImage("app0:/DATA/vita_cover.png")
local imgBoxPSP = Graphics.loadImage("app0:/DATA/psp_cover.png")
local imgBoxPSX = Graphics.loadImage("app0:/DATA/psx_cover.png")

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


local menuX = 0
local menuY = 0
local showMenu = 0
local showCat = 1 -- Category: 0 = all, 1 = games, 2 = homebrews, 3 = psp, 4 = psx
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
local getCovers = 0--0 PSV, 1 PSP, 2 PS1
local tmpappcat = 0

local prevX = 0
local prevZ = 0
local prevRot = 0

local total_all = 0
local total_games = 0
local total_homebrews = 0
local curTotal = 1

-- Settings
local startCategory = 1
local setReflections = 1
local setSounds = 1
local themeColor = 0 -- 0 blue, 1 red, 2 yellow, 3 green, 4 grey, 5 black, 6 purple, 7 orange
local menuItems = 3
local setBackground = 1
local setLanguage = 0
local showHomebrews = 0

if System.doesFileExist(cur_dir .. "/config.dat") then
    local file_config = System.openFile(cur_dir .. "/config.dat", FREAD)
    local filesize = System.sizeFile(file_config)
    local str = System.readFile(file_config, filesize)
    System.closeFile(file_config)
    
    local getCategory = tonumber(string.sub(str, 1, 1)); if getCategory ~= nil then startCategory = getCategory end
    local getReflections = tonumber(string.sub(str, 2, 2)); if getReflections ~= nil then setReflections = getReflections end
    local getSounds = tonumber(string.sub(str, 3, 3)); if getSounds ~= nil then setSounds = getSounds end
    local getthemeColor = tonumber(string.sub(str, 4, 4)); if getthemeColor ~= nil then themeColor = getthemeColor end
    local getBackground = tonumber(string.sub(str, 5, 5)); if getBackground ~= nil then setBackground = getBackground end
    local getLanguage = tonumber(string.sub(str, 6, 6)); if getLanguage ~= nil then setLanguage = getLanguage end
    local getView = tonumber(string.sub(str, 7, 7)); if getView ~= nil then showView = getView end
    local getHomebrews = tonumber(string.sub(str, 8, 8)); if getHomebrews ~= nil then showHomebrews = getHomebrews end
else
    local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
    System.writeFile(file_config, startCategory .. setReflections .. setSounds .. themeColor .. setBackground .. setLanguage .. showView .. showHomebrews, 8)
    System.closeFile(file_config)
end
showCat = startCategory

-- Custom Background
local imgCustomBack = imgBack
if System.doesFileExist("ux0:/data/HexFlow/Background.png") then
    imgCustomBack = Graphics.loadImage("ux0:/data/HexFlow/Background.png")
    Graphics.setImageFilters(imgCustomBack, FILTER_LINEAR, FILTER_LINEAR)
    Render.useTexture(modBackground, imgCustomBack)
elseif System.doesFileExist("ux0:/data/HexFlow/Background.jpg") then
    imgCustomBack = Graphics.loadImage("ux0:/data/HexFlow/Background.jpg")
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
local lang_default = "PS VITA\nHOMEBREWS\nPSP\nPS1\nALL\nSETTINGS\nLaunch\nDetails\nCategory\nView\nClose\nVersion\nAbout\nStartup Category\nReflection Effect\nSounds\nTheme Color\nCustom Background\nDownload Covers\nReload Covers Database\nLanguage\nON\nOFF\nRed\nYellow\nGreen\nGrey\nBlack\nPurple\nOrange\nBlue\nSelect"
function ChangeLanguage()
if #lang_lines>0 then
	for k in pairs (lang_lines) do
		lang_lines [k] = nil
	end
end

local lang = "EN.ini"
 -- 0 EN, 1 DE, 2 FR, 3 IT, 4 SP
	if setLanguage == 1 then
		lang = "DE.ini"
	elseif setLanguage == 2 then
		lang = "FR.ini"
	elseif setLanguage == 3 then
		lang = "IT.ini"
	elseif setLanguage == 4 then
		lang = "SP.ini"
	elseif setLanguage == 5 then
		lang = "RU.ini"
	elseif setLanguage == 6 then
		lang = "SW.ini"
	elseif setLanguage == 7 then
		lang = "PT.ini"
	else
		lang = "EN.ini"
	end
	
	if System.doesFileExist("app0:/translations/" .. lang) then
		langfile = "app0:/translations/" .. lang
	else
		--create default EN.ini if language is missing
		handle = System.openFile("ux0:/data/HexFlow/EN.ini", FCREATE)
		System.writeFile(handle, "" .. lang_default, string.len(lang_default))
		System.closeFile(handle)
		langfile = "ux0:/data/HexFlow/EN.ini"
		setLanguage=0
	end

    for line in io.lines(langfile) do
        lang_lines[#lang_lines+1] = line
    end
end
ChangeLanguage()

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
end

function listDirectory(dir)
    dir = System.listDirectory(dir)
    folders_table = {}
    files_table = {}
    games_table = {}
    psp_table = {}
    psx_table = {}
    homebrews_table = {}
	-- app_type = 0 -- 0 homebrew, 1 psvita, 2 psp, 3 psx
	local customCategory = 0
	
	local file_over = System.openFile(cur_dir .. "/overrides.dat", FREAD)
	local filesize = System.sizeFile(file_over)
	local str = System.readFile(file_over, filesize)
	System.closeFile(file_over)

    for i, file in pairs(dir) do
	local custom_path, custom_path_id, app_type = nil, nil, nil
        if file.directory then
            -- get app name to match with custom cover file name
            if System.doesFileExist(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo")
                app_title = info.title
            end

            if string.match(file.name, "PCS") and not string.match(file.name, "PCSI") then
                -- Scan PSVita Games
                table.insert(folders_table, file)
                --table.insert(games_table, file)
                custom_path = covers_psv .. app_title .. ".png"
                custom_path_id = covers_psv .. file.name .. ".png"
				file.app_type=1
				
				--CHECK FOR OVERRIDDEN CATEGORY of PSP game
				if System.doesFileExist(cur_dir .. "/overrides.dat") then
					--0 deafault, 1 vita, 2 psp, 3 psx, 4 homebrew
					if string.match(str, file.name .. "=1") then
						table.insert(games_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=1
					elseif string.match(str, file.name .. "=2") then
						table.insert(psp_table, file)
						custom_path = covers_psp .. app_title .. ".png"
						custom_path_id = covers_psp .. file.name .. ".png"
						file.app_type=2
					elseif string.match(str, file.name .. "=3") then
						table.insert(psx_table, file)
						custom_path = covers_psx .. app_title .. ".png"
						custom_path_id = covers_psx .. file.name .. ".png"
						file.app_type=3
					elseif string.match(str, file.name .. "=4") then
						table.insert(homebrews_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=0
					else
						table.insert(games_table, file)--default
					end
				else
					table.insert(games_table, file)
				end
				--END OVERRIDDEN CATEGORY of Vita game
            elseif System.doesFileExist(working_dir .. "/" .. file.name .. "/data/boot.bin") and not System.doesFileExist("ux0:pspemu/PSP/GAME/" .. file.name .. "/EBOOT.PBP") then
                -- Scan PSP Games
                table.insert(folders_table, file)
                --table.insert(psp_table, file)
                custom_path = covers_psp .. app_title .. ".png"
                custom_path_id = covers_psp .. file.name .. ".png"
				file.app_type=2
				
			--CHECK FOR OVERRIDDEN CATEGORY of PSP game
				if System.doesFileExist(cur_dir .. "/overrides.dat") then
					--0 deafault, 1 vita, 2 psp, 3 psx, 4 homebrew
					if string.match(str, file.name .. "=1") then
						table.insert(games_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=1
					elseif string.match(str, file.name .. "=2") then
						table.insert(psp_table, file)
						custom_path = covers_psp .. app_title .. ".png"
						custom_path_id = covers_psp .. file.name .. ".png"
						file.app_type=2
					elseif string.match(str, file.name .. "=3") then
						table.insert(psx_table, file)
						custom_path = covers_psx .. app_title .. ".png"
						custom_path_id = covers_psx .. file.name .. ".png"
						file.app_type=3
					elseif string.match(str, file.name .. "=4") then
						table.insert(homebrews_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=0
					else
						table.insert(psp_table, file)--default
					end
				else
					table.insert(psp_table, file)
				end
				--END OVERRIDDEN CATEGORY of Vita game
            elseif System.doesFileExist(working_dir .. "/" .. file.name .. "/data/boot.bin") and System.doesFileExist("ux0:pspemu/PSP/GAME/" .. file.name .. "/EBOOT.PBP") then
                -- Scan PSX Games
                table.insert(folders_table, file)
                --table.insert(psx_table, file)
                custom_path = covers_psx .. app_title .. ".png"
                custom_path_id = covers_psx .. file.name .. ".png"
				file.app_type=3
				
			--CHECK FOR OVERRIDDEN CATEGORY of PSX game
				if System.doesFileExist(cur_dir .. "/overrides.dat") then
					--0 deafault, 1 vita, 2 psp, 3 psx, 4 homebrew
					if string.match(str, file.name .. "=1") then
						table.insert(games_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=1
					elseif string.match(str, file.name .. "=2") then
						table.insert(psp_table, file)
						custom_path = covers_psp .. app_title .. ".png"
						custom_path_id = covers_psp .. file.name .. ".png"
						file.app_type=2
					elseif string.match(str, file.name .. "=3") then
						table.insert(psx_table, file)
						custom_path = covers_psx .. app_title .. ".png"
						custom_path_id = covers_psx .. file.name .. ".png"
						file.app_type=3
					elseif string.match(str, file.name .. "=4") then
						table.insert(homebrews_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=0
					else
						table.insert(psx_table, file)--default
					end
				else
					table.insert(psx_table, file)
				end
				--END OVERRIDDEN CATEGORY of PSX game
            else
                -- Scan Homebrews
                table.insert(folders_table, file)
                --table.insert(homebrews_table, file)
                custom_path = covers_psv .. app_title .. ".png"
                custom_path_id = covers_psv .. file.name .. ".png"
				file.app_type=0
				
			--CHECK FOR OVERRIDDEN CATEGORY of homebrew
				if System.doesFileExist(cur_dir .. "/overrides.dat") then
					--0 deafault, 1 vita, 2 psp, 3 psx, 4 homebrew
					if string.match(str, file.name .. "=1") then
						table.insert(games_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=1
					elseif string.match(str, file.name .. "=2") then
						table.insert(psp_table, file)
						custom_path = covers_psp .. app_title .. ".png"
						custom_path_id = covers_psp .. file.name .. ".png"
						file.app_type=2
					elseif string.match(str, file.name .. "=3") then
						table.insert(psx_table, file)
						custom_path = covers_psx .. app_title .. ".png"
						custom_path_id = covers_psx .. file.name .. ".png"
						file.app_type=3
					elseif string.match(str, file.name .. "=4") then
						table.insert(homebrews_table, file)
						custom_path = covers_psv .. app_title .. ".png"
						custom_path_id = covers_psv .. file.name .. ".png"
						file.app_type=0
					else
						table.insert(homebrews_table, file)--default
					end
				else
					table.insert(homebrews_table, file)
				end
				--END OVERRIDDEN CATEGORY of homebrew
            end

        end
        
		if custom_path and System.doesFileExist(custom_path) then
			img_path = custom_path --custom cover by app name
		elseif custom_path_id and System.doesFileExist(custom_path_id) then
			img_path = custom_path_id --custom cover by app id
		else
			if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
				img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
			else
				img_path = "app0:/DATA/noimg.png" --blank grey
			end
		end
        
        table.insert(files_table, 4, file.app_type)
		
		
        --add blank icon to all
        file.icon = imgCoverTmp
        file.icon_path = img_path
		
        table.insert(files_table, 4, file.icon)
        
        file.apptitle = app_title
        table.insert(files_table, 4, file.apptitle)
        
    end
    table.sort(files_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(folders_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    
    table.sort(games_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(homebrews_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psp_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    table.sort(psx_table, function(a, b) return (a.apptitle:lower() < b.apptitle:lower()) end)
    
    return_table = TableConcat(folders_table, files_table)
    
    total_all = #files_table
    total_games = #games_table
    total_homebrews = #homebrews_table
    
    return return_table
end

function loadImage(img_path)
    imgTmp = Graphics.loadImage(img_path)
end

files_table = listDirectory(System.currentDirectory())

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

function GetInfoSelected()
    if showCat == 1 then
        if #games_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. games_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. games_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. games_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. games_table[p].name .. "/pic0.png"
				app_title = tostring(info.title)
				apptype = games_table[p].app_type
				appdir=working_dir .. "/" .. games_table[p].name
            end
		else
			app_title = "-"
        end
    elseif showCat == 2 then
        if #homebrews_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. homebrews_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. homebrews_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. homebrews_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. homebrews_table[p].name .. "/pic0.png"
				app_title = tostring(info.title)
				apptype = homebrews_table[p].app_type
				appdir=working_dir .. "/" .. homebrews_table[p].name
            end
		else
			app_title = "-"
        end
    elseif showCat == 3 then
        if #psp_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. psp_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. psp_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. psp_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. psp_table[p].name .. "/pic0.png"
				app_title = tostring(info.title)
				apptype = psp_table[p].app_type
				appdir=working_dir .. "/" .. psp_table[p].name
            end
		else
			app_title = "-"
        end
    elseif showCat == 4 then
        if #psx_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. psx_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. psx_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. psx_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. psx_table[p].name .. "/pic0.png"
				app_title = tostring(info.title)
				apptype = psx_table[p].app_type
				appdir="ux0:pspemu/PSP/GAME/" .. psx_table[p].name
            end
		else
			app_title = "-"
        end
    else
        if #files_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. files_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. files_table[p].name .. "/pic0.png"
				app_title = tostring(info.title)
				apptype = files_table[p].app_type
				--appdir=working_dir .. "/" .. files_table[p].name
				if apptype==1 then
					appdir=working_dir .. "/" .. files_table[p].name
				elseif apptype==2 then
					appdir=working_dir .. "/" .. files_table[p].name
				elseif apptype==3 then
					appdir="ux0:pspemu/PSP/GAME/" .. files_table[p].name
				else
					appdir=working_dir .. "/" .. files_table[p].name
				end
            end
		else
			app_title = "-"
        end
    end

    app_titleid = tostring(info.titleid)
    app_version = tostring(info.version)
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
		file = io.open(cur_dir .. "/overrides.dat", "w")
		file:write(lines)
		file:close()
		
		--Reload
		FreeIcons()
		FreeMemory()
		Network.term()
		dofile("app0:index.lua")
	end
end

function DownloadCovers()
    local txt = "Downloading covers..."
    local old_txt = txt
    local percent = 0
    local old_percent = 0
    local cvrfound = 0
    
    local app_idx = 1
    local running = false
	status = System.getMessageState()
    
    if Network.isWifiEnabled() then
		-- scan PSVITA
        if getCovers==0 and #games_table > 0 then
			if status ~= RUNNING then
				if scanComplete == false then
					System.setMessage("Downloading covers...", true)
					System.setMessageProgMsg(txt)
					
					while app_idx <= #games_table do
						if System.getAsyncState() ~= 0 then
							Network.downloadFileAsync(onlineCovers .. games_table[app_idx].name .. ".png", "ux0:/data/HexFlow/" .. games_table[app_idx].name .. ".png")
							running = true
						end
						if System.getAsyncState() == 1 then
							Graphics.initBlend()
							Graphics.termBlend()
							Screen.flip()
							running = false
						end
						if running == false then
							if System.doesFileExist("ux0:/data/HexFlow/" .. games_table[app_idx].name .. ".png") then
								tmpfile = System.openFile("ux0:/data/HexFlow/" .. games_table[app_idx].name .. ".png", FREAD)
								size = System.sizeFile(tmpfile)
								if size < 1024 then
									System.deleteFile("ux0:/data/HexFlow/" .. games_table[app_idx].name .. ".png")
								else
									System.rename("ux0:/data/HexFlow/" .. games_table[app_idx].name .. ".png", covers_psv .. games_table[app_idx].name .. ".png")
									cvrfound = cvrfound + 1
								end
								System.closeFile(tmpfile)
								
								percent = (app_idx / #games_table) * 100
								txt = "Downloading PS Vita covers...\nCover " .. games_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #games_table
								
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
					FreeIcons()
					FreeMemory()
					Network.term()
					dofile("app0:index.lua")
				end
			end
        end
		-- scan PSP
        if  getCovers==1 and #psp_table > 0 then
			if status ~= RUNNING then
				if scanComplete == false then
					System.setMessage("Downloading covers...", true)
					System.setMessageProgMsg(txt)
					
					while app_idx <= #psp_table do
						if System.getAsyncState() ~= 0 then
							Network.downloadFileAsync(onlineCoversPSP .. psp_table[app_idx].name .. ".png", "ux0:/data/HexFlow/" .. psp_table[app_idx].name .. ".png")
							running = true
						end
						if System.getAsyncState() == 1 then
							Graphics.initBlend()
							Graphics.termBlend()
							Screen.flip()
							running = false
						end
						if running == false then
							if System.doesFileExist("ux0:/data/HexFlow/" .. psp_table[app_idx].name .. ".png") then
								tmpfile = System.openFile("ux0:/data/HexFlow/" .. psp_table[app_idx].name .. ".png", FREAD)
								size = System.sizeFile(tmpfile)
								if size < 1024 then
									System.deleteFile("ux0:/data/HexFlow/" .. psp_table[app_idx].name .. ".png")
								else
									System.rename("ux0:/data/HexFlow/" .. psp_table[app_idx].name .. ".png", covers_psp .. psp_table[app_idx].name .. ".png")
									cvrfound = cvrfound + 1
								end
								System.closeFile(tmpfile)
								
								percent = (app_idx / #psp_table) * 100
								txt = "Downloading PSP covers...\nCover " .. psp_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #psp_table
								
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
					FreeIcons()
					FreeMemory()
					Network.term()
					dofile("app0:index.lua")
				end
			end
        end
		
		-- scan PS1
        if  getCovers==2 and #psx_table > 0 then
			if status ~= RUNNING then
				if scanComplete == false then
					System.setMessage("Downloading covers...", true)
					System.setMessageProgMsg(txt)
					
					while app_idx <= #psx_table do
						if System.getAsyncState() ~= 0 then
							Network.downloadFileAsync(onlineCoversPSX .. psx_table[app_idx].name .. ".png", "ux0:/data/HexFlow/" .. psx_table[app_idx].name .. ".png")
							running = true
						end
						if System.getAsyncState() == 1 then
							Graphics.initBlend()
							Graphics.termBlend()
							Screen.flip()
							running = false
						end
						if running == false then
							if System.doesFileExist("ux0:/data/HexFlow/" .. psx_table[app_idx].name .. ".png") then
								tmpfile = System.openFile("ux0:/data/HexFlow/" .. psx_table[app_idx].name .. ".png", FREAD)
								size = System.sizeFile(tmpfile)
								if size < 1024 then
									System.deleteFile("ux0:/data/HexFlow/" .. psx_table[app_idx].name .. ".png")
								else
									System.rename("ux0:/data/HexFlow/" .. psx_table[app_idx].name .. ".png", covers_psx .. psx_table[app_idx].name .. ".png")
									cvrfound = cvrfound + 1
								end
								System.closeFile(tmpfile)
								
								percent = (app_idx / #psx_table) * 100
								txt = "Downloading PS1 covers...\nCover " .. psx_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #psx_table
								
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
					FreeIcons()
					FreeMemory()
					Network.term()
					dofile("app0:index.lua")
				end
			end
        end
	else
		if status ~= RUNNING then
			System.setMessage("Internet Connection Required", false, BUTTON_OK)
		end
		
    end
    gettingCovers = false
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
			coverspath = covers_psv
			onlineCoverspath = onlineCovers
		elseif apptype == 2 then
			coverspath = covers_psp
			onlineCoverspath = onlineCoversPSP
		elseif apptype == 3 then
			coverspath = covers_psx
			onlineCoverspath = onlineCoversPSX
		else
			coverspath = covers_psv
			onlineCoverspath = onlineCovers
		end
	
		Network.downloadFile(onlineCoverspath .. app_titleid .. ".png", "ux0:/data/HexFlow/" .. app_titleid .. ".png")
		
		if System.doesFileExist("ux0:/data/HexFlow/" .. app_titleid .. ".png") then
			tmpfile = System.openFile("ux0:/data/HexFlow/" .. app_titleid .. ".png", FREAD)
			size = System.sizeFile(tmpfile)
			if size < 1024 then
				System.deleteFile("ux0:/data/HexFlow/" .. app_titleid .. ".png")
			else
				System.rename("ux0:/data/HexFlow/" .. app_titleid .. ".png", coverspath .. app_titleid .. ".png")
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
				end
				if psx_table[app_idx].ricon then
					psx_table[app_idx].ricon = nil
				end
			else
				--"files_table"
				files_table[app_idx].icon_path=coverspath .. app_titleid .. ".png"
				if FileLoad[files_table[app_idx]] == true then
					FileLoad[files_table[app_idx]] = nil
					Threads.remove(files_table[app_idx])
				end
				if files_table[app_idx].ricon then
					files_table[app_idx].ricon = nil
				end
			end
			if status ~= RUNNING then
				System.setMessage("Cover " .. app_titleid .. " found!", false, BUTTON_OK)
			end
		else
			if status ~= RUNNING then
				System.setMessage("Cover not found", false, BUTTON_OK)
			end
		end
		
	else
		if status ~= RUNNING then
			System.setMessage("Internet Connection Required", false, BUTTON_OK)
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
		if setLanguage==5 then
		--Russian language fix positions
			Graphics.drawImage(824, 510, btnX)
			Font.print(fnt20, 824+28, 508, lang_lines[7], white)--Launch
			Graphics.drawImage(710, 510, btnT)
			Font.print(fnt20, 710+28, 508, lang_lines[8], white)--Details
			Graphics.drawImage(570, 510, btnS)
			Font.print(fnt20, 570+28, 508, lang_lines[9], white)--Category
			Graphics.drawImage(480, 510, btnO)
			Font.print(fnt20, 480+28, 508, lang_lines[10], white)--View
		else
			Graphics.drawImage(904-(string.len(lang_lines[7])*10), 510, btnX)
			Font.print(fnt20, 904+28-(string.len(lang_lines[7])*10), 508, lang_lines[7], white)--Launch
			Graphics.drawImage(790-(string.len(lang_lines[8])*10), 510, btnT)
			Font.print(fnt20, 790+28-(string.len(lang_lines[8])*10), 508, lang_lines[8], white)--Details
			Graphics.drawImage(670-(string.len(lang_lines[9])*10), 510, btnS)
			Font.print(fnt20, 670+28-(string.len(lang_lines[9])*10), 508, lang_lines[9], white)--Category
			Graphics.drawImage(520-(string.len(lang_lines[10])*10), 510, btnO)
			Font.print(fnt20, 520+28-(string.len(lang_lines[10])*10), 508, lang_lines[10], white)--View
		end
		
        if showCat == 1 then
            Font.print(fnt22, 32, 34, lang_lines[1], white)--GAMES
        elseif showCat == 2 then
            Font.print(fnt22, 32, 34, lang_lines[2], white)--HOMEBREWS
        elseif showCat == 3 then
            Font.print(fnt22, 32, 34, lang_lines[3], white)--PSP
        elseif showCat == 4 then
            Font.print(fnt22, 32, 34, lang_lines[4], white)--PSX
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
                PrintCentered(fnt20, 480, 462, p .. " of " .. #games_table, white, 20)-- Draw total items
            end

        elseif showCat == 2 then
            --HOMEBREWS
            for l, file in pairs(homebrews_table) do
                if (l >= master_index) then
                    base_x = base_x + space
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
                PrintCentered(fnt20, 480, 462, p .. " of " .. #homebrews_table, white, 20)-- Draw total items
            end
        elseif showCat == 3 then
            --PSP
            for l, file in pairs(psp_table) do
                if (l >= master_index) then
                    base_x = base_x + space
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
                PrintCentered(fnt20, 480, 462, p .. " of " .. #psp_table, white, 20)-- Draw total items
            end
        elseif showCat == 4 then
            --PSX
            for l, file in pairs(psx_table) do
                if (l >= master_index) then
                    base_x = base_x + space
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
                PrintCentered(fnt20, 480, 462, p .. " of " .. #psx_table, white, 20)-- Draw total items
            end
        else
            --ALL
            for l, file in pairs(files_table) do
                if (l >= master_index) then
                    base_x = base_x + space
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
                PrintCentered(fnt20, 480, 462, p .. " of " .. #files_table, white, 20)-- Draw total items
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
        Graphics.drawImage(900-(string.len(lang_lines[11])*10), 510, btnO)
        Font.print(fnt20, 900+28-(string.len(lang_lines[11])*10), 508, lang_lines[11], white)--Close
        Graphics.drawImage(750-(string.len(lang_lines[32])*10), 510, btnX)
        Font.print(fnt20, 750+28-(string.len(lang_lines[32])*10), 508, lang_lines[32], white)--Select
        
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
			
			app_size = getAppSize(appdir)/1024/1024
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
        
        Graphics.drawImage(50, 50, iconTmp)-- icon
        
        txtname = string.sub(app_title, 1, 32) .. "\n" .. string.sub(app_title, 33)
        
        -- Set cover image
        if showCat == 1 then
            --Graphics.setImageFilters(games_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if games_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, games_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, games_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, games_table[p].ricon)
				Render.useTexture(modCoverPSXNoref, games_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, games_table[p].icon)
				Render.useTexture(modCoverHbrNoref, games_table[p].icon)
				Render.useTexture(modCoverPSPNoref, games_table[p].icon)
				Render.useTexture(modCoverPSXNoref, games_table[p].icon)
			end
        elseif showCat == 2 then
            --Graphics.setImageFilters(homebrews_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if homebrews_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, homebrews_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, homebrews_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, homebrews_table[p].ricon)
				Render.useTexture(modCoverPSXNoref, homebrews_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, homebrews_table[p].icon)
				Render.useTexture(modCoverHbrNoref, homebrews_table[p].icon)
				Render.useTexture(modCoverPSPNoref, homebrews_table[p].icon)
				Render.useTexture(modCoverPSXNoref, homebrews_table[p].icon)
			end
        elseif showCat == 3 then
            --Graphics.setImageFilters(psp_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if psp_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, psp_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, psp_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, psp_table[p].ricon)
				Render.useTexture(modCoverPSXNoref, psp_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, psp_table[p].icon)
				Render.useTexture(modCoverHbrNoref, psp_table[p].icon)
				Render.useTexture(modCoverPSPNoref, psp_table[p].icon)
				Render.useTexture(modCoverPSXNoref, psp_table[p].icon)
			end
        elseif showCat == 4 then
            --Graphics.setImageFilters(psx_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if psx_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, psx_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, psx_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, psx_table[p].ricon)
				Render.useTexture(modCoverPSXNoref, psx_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, psx_table[p].icon)
				Render.useTexture(modCoverHbrNoref, psx_table[p].icon)
				Render.useTexture(modCoverPSPNoref, psx_table[p].icon)
				Render.useTexture(modCoverPSXNoref, psx_table[p].icon)
			end
        else
            --Graphics.setImageFilters(files_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if files_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, files_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, files_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, files_table[p].ricon)
				Render.useTexture(modCoverPSXNoref, files_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, files_table[p].icon)
				Render.useTexture(modCoverHbrNoref, files_table[p].icon)
				Render.useTexture(modCoverPSPNoref, files_table[p].icon)
				Render.useTexture(modCoverPSXNoref, files_table[p].icon)
			end
        end
		
        local tmpapptype=""
		local tmpcatText=""
        -- Draw box
        if apptype==1 then
            Render.drawModel(modCoverNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
			tmpapptype = "PS Vita Game"
        elseif apptype==2 then
            Render.drawModel(modCoverPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
			tmpapptype = "PSP Game"
        elseif apptype==3 then
            Render.drawModel(modCoverPSXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSXNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
			tmpapptype = "PS1 Game"
        else
            Render.drawModel(modCoverHbrNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
			tmpapptype = "Homebrew"
        end
    
        Font.print(fnt22, 50, 190, txtname, white)-- app name
        Font.print(fnt22, 50, 240, tmpapptype .. "\nApp ID: " .. app_titleid .. "\nVersion: " .. app_version .. "\nSize: " .. string.format("%02d", app_size) .. "Mb", white)-- Draw info
		
		if tmpappcat==1 then
			tmpcatText = "PS Vita"
		elseif tmpappcat==2 then
			tmpcatText = "PSP"
		elseif tmpappcat==3 then
			tmpcatText = "PS1"
		elseif tmpappcat==4 then
			tmpcatText = "Homebrew"
		else
			tmpcatText = "Default"
		end

		menuItems = 1
		if menuY==1 then
			Graphics.fillRect(24, 470, 350 + (menuY * 40), 430 + (menuY * 40), themeCol)-- selection two lines
		else
			Graphics.fillRect(24, 470, 350 + (menuY * 40), 390 + (menuY * 40), themeCol)-- selection
		end
		Font.print(fnt22, 50, 352, "Download Cover", white)
		Font.print(fnt22, 50, 352+40, "Override Category: < " .. tmpcatText .. " >\n(Press X to apply Category)", white)
		

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
					if tmpappcat > 0 then
						tmpappcat = tmpappcat - 1
					else
						tmpappcat=4
					end
				end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
				if menuY==1 then
					if tmpappcat < 4 then
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
        Graphics.drawImage(900-(string.len(lang_lines[11])*10), 510, btnO)
        Font.print(fnt20, 900+28-(string.len(lang_lines[11])*10), 508, lang_lines[11], white)--Close
        Graphics.drawImage(750-(string.len(lang_lines[32])*10), 510, btnX)
        Font.print(fnt20, 750+28-(string.len(lang_lines[32])*10), 508, lang_lines[32], white)--Select
        Graphics.fillRect(60, 900, 24, 470, darkalpha)
        Font.print(fnt22, 84, 42, lang_lines[6], white)--SETTINGS
        Graphics.drawLine(60, 900, 74, 74, white)
        Graphics.fillRect(60, 900, 110 + (menuY * 40), 150 + (menuY * 40), themeCol)-- selection
        
        menuItems = 8
        
        Font.print(fnt22, 84, 112, lang_lines[14] .. ": ", white)--Startup Category
        if startCategory == 0 then
            Font.print(fnt22, 84 + 260, 112, lang_lines[5], white)--ALL
        elseif startCategory == 1 then
            Font.print(fnt22, 84 + 260, 112, lang_lines[1], white)--GAMES
        elseif startCategory == 2 then
            Font.print(fnt22, 84 + 260, 112, lang_lines[2], white)--HOMEBREWS
        elseif startCategory == 3 then
            Font.print(fnt22, 84 + 260, 112, lang_lines[3], white)--PSP
        elseif startCategory == 4 then
            Font.print(fnt22, 84 + 260, 112, lang_lines[4], white)--PSX
        end
        
        Font.print(fnt22, 84, 112 + 40, lang_lines[15] .. ": ", white)
        if setReflections == 1 then
            Font.print(fnt22, 84 + 260, 112 + 40, lang_lines[22], white)--ON
        else
            Font.print(fnt22, 84 + 260, 112 + 40, lang_lines[23], white)--OFF
        end
        
        Font.print(fnt22, 84, 112 + 80, lang_lines[16] .. ": ", white)--SOUNDS
        if setSounds == 1 then
            Font.print(fnt22, 84 + 260, 112 + 80, lang_lines[22], white)--ON
        else
            Font.print(fnt22, 84 + 260, 112 + 80, lang_lines[23], white)--OFF
        end
        
        Font.print(fnt22, 84, 112 + 120,  lang_lines[17] .. ": ", white)
        if themeColor == 1 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[24], white)--Red
        elseif themeColor == 2 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[25], white)--Yellow
        elseif themeColor == 3 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[26], white)--Green
        elseif themeColor == 4 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[27], white)--Grey
        elseif themeColor == 5 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[28], white)--Black
        elseif themeColor == 6 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[29], white)--Purple
        elseif themeColor == 7 then
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[30], white)--Orange
        else
            Font.print(fnt22, 84 + 260, 112 + 120, lang_lines[31], white)--Blue
        end
        
        Font.print(fnt22, 84, 112 + 160,  lang_lines[18] .. ": ", white)
        if setBackground == 1 then
            Font.print(fnt22, 84 + 260, 112 + 160, lang_lines[22], white)--ON
        else
            Font.print(fnt22, 84 + 260, 112 + 160, lang_lines[23], white)--OFF
        end
        
		if scanComplete == false then
			if getCovers == 1 then
				Font.print(fnt22, 84, 112 + 200, lang_lines[19] .. ":   <  PSP  >", white)--Download Covers
			elseif getCovers == 2 then
				Font.print(fnt22, 84, 112 + 200, lang_lines[19] .. ":   <  PS1  >", white)--Download Covers
			else
				Font.print(fnt22, 84, 112 + 200, lang_lines[19] .. ":   <  PS VITA  >", white)--Download Covers
			end
		else
			Font.print(fnt22, 84, 112 + 200,  lang_lines[20], white)--Reload Covers Database
		end
		
        Font.print(fnt22, 84, 112 + 240, lang_lines[21] .. ": ", white)--Language
        if setLanguage == 1 then
            Font.print(fnt22, 84 + 260, 112 + 240, "German", white)
        elseif setLanguage == 2 then
            Font.print(fnt22, 84 + 260, 112 + 240, "French", white)
        elseif setLanguage == 3 then
            Font.print(fnt22, 84 + 260, 112 + 240, "Italian", white)
        elseif setLanguage == 4 then
            Font.print(fnt22, 84 + 260, 112 + 240, "Spanish", white)
        elseif setLanguage == 5 then
            Font.print(fnt22, 84 + 260, 112 + 240, "Russian", white)
        elseif setLanguage == 6 then
            Font.print(fnt22, 84 + 260, 112 + 240, "Swedish", white)
        else
            Font.print(fnt22, 84 + 260, 112 + 240, "English", white)
        end
		
        Font.print(fnt22, 84, 112 + 280, "Homebrews Category:", white)--Show Homebrews
		if showHomebrews == 1 then
            Font.print(fnt22, 84 + 260, 112 + 280, lang_lines[22], white)--ON
        else
            Font.print(fnt22, 84 + 260, 112 + 280, lang_lines[23], white)--OFF
        end
		
        Font.print(fnt22, 84, 112 + 320, lang_lines[13], white)--About
        
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS)) then
                if menuY == 0 then
                    if startCategory < 4 then
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
                    if setLanguage < 6 then
                        setLanguage = setLanguage + 1
                    else
                        setLanguage = 0
                    end
					ChangeLanguage()
                elseif menuY == 7 then
                    if showHomebrews == 1 then
                        showHomebrews = 0
                    else
                        showHomebrews = 1
                    end
                elseif menuY == 8 then
                    showMenu = 3
                    menuY = 0
                end
                
                
                --Save settings
                local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
                System.writeFile(file_config, startCategory .. setReflections .. setSounds .. themeColor .. setBackground .. setLanguage .. showView .. showHomebrews, 8)
                System.closeFile(file_config)
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
						getCovers=2
					end
				end
            elseif (Controls.check(pad, SCE_CTRL_RIGHT)) and not (Controls.check(oldpad, SCE_CTRL_RIGHT)) then
                --covers download selection
				if menuY==5 then
					if getCovers < 2 then
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
        Graphics.drawImage(900-(string.len(lang_lines[11])*10), 510, btnO)
        Font.print(fnt20, 900+28-(string.len(lang_lines[11])*10), 508, lang_lines[11], white)--Close
        
        Graphics.fillRect(30, 930, 24, 496, darkalpha)-- bg
        
        Font.print(fnt20, 54, 42, "HexFlow Launcher - ver." .. appversion .. "\nby VitaHEX Games\nSupport this project on patreon.com/vitahex", white)-- Draw info
        Graphics.drawLine(30, 930, 124, 124, white)
        Graphics.drawLine(30, 930, 284, 284, white)
        Font.print(fnt20, 54, 132, "Custom Covers\nPlace your custom covers in 'ux0:/data/HexFlow/COVERS/PSVITA' or '/PSP' or '/PS1'\nCover images must be in png format and file name must match the App ID or the App Name"
            .. "\n\nCustom Background\nPlace your custom background image in 'ux0:/data/HexFlow/'\nBackground image must be named 'Background.jpg' or 'Background.png' (720p max)"
            .. "\n\nCREDITS\nProgramming/UI by Sakis RG\n\nDeveloped with Lua Player Plus by Rinnegatamante\n\nSpecial Thanks\nCreckeryop, Andreas Stürmer, Roc6d, Badmanwazzy37"
			.. "\n\nTranslations: TheheroGAC, chronoss, stuermerandreas, kodyna91, _novff, Spoxnus86", white)-- Draw info
    
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
                if showCat == 1 then
                    System.launchApp(games_table[p].name)
                elseif showCat == 2 then
                    System.launchApp(homebrews_table[p].name)
                elseif showCat == 3 then
                    System.launchApp(psp_table[p].name)
                elseif showCat == 4 then
                    System.launchApp(psx_table[p].name)
                else
                    System.launchApp(files_table[p].name)
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
            if showCat < 4 then
				if showCat==1 and showHomebrews==0 then
					showCat = 3
				else
					showCat = showCat + 1
				end
            else
                showCat = 0
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
            System.writeFile(file_config, startCategory .. setReflections .. setSounds .. themeColor .. setBackground .. setLanguage .. showView .. showHomebrews, 8)
            System.closeFile(file_config)
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
            p = p - 5
            
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
            p = p + 5
            
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
