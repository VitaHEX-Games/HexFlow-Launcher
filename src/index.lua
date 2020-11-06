-- HexFlow Launcher  version 0.3 by VitaHEX
-- https://www.patreon.com/vitahex
dofile("app0:addons/threads.lua")
local working_dir = "ux0:/app"
local appversion = "0.3"
function System.currentDirectory(dir)
    if dir == nil then
        return working_dir
    else
        working_dir = dir
    end
end

Network.init()
local onlineCovers = "https://raw.githubusercontent.com/andiweli/hexflow-covers/main/Covers/PSVita/"

Sound.init()
local click = Sound.open("app0:/DATA/click2.wav")
local imgCoverTmp = Graphics.loadImage("app0:/DATA/noimg.png")
local backTmp = Graphics.loadImage("app0:/DATA/noimg.png")
local btnX = Graphics.loadImage("app0:/DATA/x.png")
local btnT = Graphics.loadImage("app0:/DATA/t.png")
local btnS = Graphics.loadImage("app0:/DATA/s.png")
local btnO = Graphics.loadImage("app0:/DATA/o.png")
local imgWifi = Graphics.loadImage("app0:/DATA/wifi.png")
local imgBattery = Graphics.loadImage("app0:/DATA/bat.png")
local imgBack = Graphics.loadImage("app0:/DATA/back_01.jpg")


local cur_dir = "ux0:/data/HexFlow/"
local covers_psv = "ux0:/data/HexFlow/COVERS/PSVITA/"
local covers_psp = "ux0:/data/HexFlow/COVERS/PSP/"

-- Create directories
System.createDirectory("ux0:/data/HexFlow/")
System.createDirectory("ux0:/data/HexFlow/COVERS/")
System.createDirectory(covers_psv)
System.createDirectory(covers_psp)

-- load textures
local imgBox = Graphics.loadImage("app0:/DATA/vita_cover.png")
local imgBoxPSP = Graphics.loadImage("app0:/DATA/psp_cover.png")

-- Load models
local modBox = Render.loadObject("app0:/DATA/box.obj", imgBox)
local modCover = Render.loadObject("app0:/DATA/cover.obj", imgCoverTmp)
local modBoxNoref = Render.loadObject("app0:/DATA/box_noreflx.obj", imgBox)
local modCoverNoref = Render.loadObject("app0:/DATA/cover_noreflx.obj", imgCoverTmp)

local modBoxPSP = Render.loadObject("app0:/DATA/boxpsp.obj", imgBoxPSP)
local modCoverPSP = Render.loadObject("app0:/DATA/coverpsp.obj", imgCoverTmp)
local modBoxPSPNoref = Render.loadObject("app0:/DATA/boxpsp_noreflx.obj", imgBoxPSP)
local modCoverPSPNoref = Render.loadObject("app0:/DATA/coverpsp_noreflx.obj", imgCoverTmp)

local modCoverHbr = Render.loadObject("app0:/DATA/cover_square.obj", imgCoverTmp)
local modCoverHbrNoref = Render.loadObject("app0:/DATA/cover_square_noreflx.obj", imgCoverTmp)
local modBackground = Render.loadObject("app0:/DATA/planebg.obj", imgBack)
local modDefaultBackground = Render.loadObject("app0:/DATA/planebg.obj", imgBack)

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
local showCat = 1 -- Category: 0 = all, 1 = games, 2 = homebrews, 3 = psp
local showView = 0

local info = System.extractSfo("app0:/sce_sys/param.sfo")
local app_version = info.version
local app_title = info.title
local app_category = info.category
local app_titleid = info.titleid

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
local bg = Color.new(153, 217, 234)
local themeCol = Color.new(2, 72, 158)

local targetX = 0
local xstart = 0
local ystart = 0
local space = 1
local touchdown = 0
local startCovers = false
local inPreview = false

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
local themeColor = 0 -- 0 blue, 1 red, 2 yellow, 3 green, 4 grey, 5 black
local menuItems = 3
local setBackground = 1

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
else
    local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
    System.writeFile(file_config, startCategory .. setReflections .. setSounds .. themeColor .. setBackground, 5)
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

function SetThemeColor()
    -- 0 default blue, 1 red, 2 yellow, 3 green, 4 grey, 5 black
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

function PrintCentered(font, x, y, text, color, size)
    Font.print(font, x - ((string.len(text) / 2) * (size / 3)) - string.len(text), y, text, color)
end

function TableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function FreeMemory()
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
    homebrews_table = {}
    
    for i, file in pairs(dir) do
        if file.directory then
            -- get app name to match with custom cover file name
            if System.doesFileExist(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. file.name .. "/sce_sys/param.sfo")
                app_title = info.title
            end
            if string.match(file.name, "PCS") and not string.match(file.name, "PCSI") then
                -- Scan PSVita Games
                table.insert(folders_table, file)
                table.insert(games_table, file)
                custom_path = covers_psv .. app_title .. ".png"
                custom_path_id = covers_psv .. file.name .. ".png"
            elseif string.match(file.name, "PSPEMU") and not string.match(file.name, "PSPEMUCFW") then
                -- Scan PSP Games
                table.insert(folders_table, file)
                table.insert(psp_table, file)
                custom_path = covers_psp .. app_title .. ".png"
                custom_path_id = covers_psp .. file.name .. ".png"
            else
                -- Scan Homebrews
                table.insert(folders_table, file)
                table.insert(homebrews_table, file)
                custom_path = covers_psv .. app_title .. ".png"
                custom_path_id = covers_psv .. file.name .. ".png"
            end
        end
        
		if System.doesFileExist(custom_path) then
			img_path = custom_path --custom cover by app name
		elseif System.doesFileExist(custom_path_id) then
			img_path = custom_path_id --custom cover by app id
		else
			if System.doesFileExist("ur0:/appmeta/" .. file.name .. "/icon0.png") then
				img_path = "ur0:/appmeta/" .. file.name .. "/icon0.png"  --app icon
			else
				img_path = "app0:/DATA/noimg.png" --blank grey
			end
		end
        
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

function GetInfoSelected()
    if showCat == 1 then
        if #games_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. games_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. games_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. games_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. games_table[p].name .. "/pic0.png"
            end
        end
    elseif showCat == 2 then
        if #homebrews_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. homebrews_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. homebrews_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. homebrews_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. homebrews_table[p].name .. "/pic0.png"
            end
        end
    elseif showCat == 3 then
        if #psp_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. psp_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. psp_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. psp_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. psp_table[p].name .. "/pic0.png"
            end
        end
    else
        if #files_table > 0 then
            if System.doesFileExist(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo") then
                info = System.extractSfo(working_dir .. "/" .. files_table[p].name .. "/sce_sys/param.sfo")
                icon_path = "ur0:/appmeta/" .. files_table[p].name .. "/icon0.png"
                pic_path = "ur0:/appmeta/" .. files_table[p].name .. "/pic0.png"
            end
        end
    end
    
    app_title = tostring(info.title)
    app_titleid = tostring(info.titleid)
    app_version = tostring(info.version)

end

function DownloadCovers()
    local txt = "Downloading covers..."
    local old_txt = txt
    local percent = 0
    local old_percent = 0
    local cvrfound = 0
    
    local app_idx = 1
    local running = false
    
    if Network.isWifiEnabled() and #games_table > 0 then
        
        status = System.getMessageState()
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
                            txt = "Downloading covers...\nCover " .. games_table[app_idx].name .. "\nFound " .. cvrfound .. " of " .. #games_table
                            
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
                --System.setMessage("Please restart the app to import the new covers", false, BUTTON_OK)
				--restart if pressed again
				FreeIcons()
				FreeMemory()
				Network.term()
				dofile("app0:index.lua")
            end
        end
    end
    gettingCovers = false
end


local function DrawCover(x, y, text, icon, sel)
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
        if string.match(text, "PCS") and not string.match(text, "PCSI") then
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
        elseif string.match(text, "PSPEMU") and not string.match(text, "PSPEMUCFW") then
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
    for k, v in pairs(homebrews_table) do
        FileLoad[v] = nil
        Threads.remove(v)
        if v.ricon then
            Graphics.freeImage(v.ricon)
            v.ricon = nil
        end
    end
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
        Graphics.drawImage(850, 510, btnX)
        Font.print(fnt20, 878, 508, "Launch", white)
        Graphics.drawImage(750, 510, btnT)
        Font.print(fnt20, 778, 508, "Details", white)
        Graphics.drawImage(620, 510, btnS)
        Font.print(fnt20, 648, 508, "Category", white)
        Graphics.drawImage(530, 510, btnO)
        Font.print(fnt20, 558, 508, "View", white)
        
        if showCat == 1 then
            Font.print(fnt22, 32, 34, "GAMES", white)
        elseif showCat == 2 then
            Font.print(fnt22, 32, 34, "HOMEBREWS", white)
        elseif showCat == 3 then
            Font.print(fnt22, 32, 34, "PSP", white)
        else
            Font.print(fnt22, 32, 34, "ALL", white)
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
                        DrawCover((targetX + l * space) - (#games_table * space + space), -0.6, file.name, file.ricon, base_x)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#games_table * space + space), -0.6, file.name, file.icon, base_x)--draw visible covers only
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
                        DrawCover((targetX + l * space) - (#homebrews_table * space + space), -0.6, file.name, file.ricon, base_x)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#homebrews_table * space + space), -0.6, file.name, file.icon, base_x)--draw visible covers only
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
                        DrawCover((targetX + l * space) - (#psp_table * space + space), -0.6, file.name, file.ricon, base_x)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#psp_table * space + space), -0.6, file.name, file.icon, base_x)--draw visible covers only
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
                        DrawCover((targetX + l * space) - (#files_table * space + space), -0.6, file.name, file.ricon, base_x)--draw visible covers only
                    else
                        DrawCover((targetX + l * space) - (#files_table * space + space), -0.6, file.name, file.icon, base_x)--draw visible covers only
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
        
        prevX = 0
        prevZ = 0
        prevRot = 0
        inPreview = false
    elseif showMenu == 1 then
        
        -- PREVIEW
        -- Footer buttons and icons
        Graphics.drawImage(850, 510, btnO)
        Font.print(fnt20, 878, 508, "Close", white)
        
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
        
        Font.print(fnt22, 50, 190, txtname, white)-- app name
        Font.print(fnt22, 50, 240, "App ID: " .. app_titleid .. "\nVersion: " .. app_version, white)-- Draw info
        
        -- Set cover image
        if showCat == 1 then
            --Graphics.setImageFilters(games_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if games_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, games_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, games_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, games_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, games_table[p].icon)
				Render.useTexture(modCoverHbrNoref, games_table[p].icon)
				Render.useTexture(modCoverPSPNoref, games_table[p].icon)
			end
        elseif showCat == 2 then
            --Graphics.setImageFilters(homebrews_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if homebrews_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, homebrews_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, homebrews_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, homebrews_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, homebrews_table[p].icon)
				Render.useTexture(modCoverHbrNoref, homebrews_table[p].icon)
				Render.useTexture(modCoverPSPNoref, homebrews_table[p].icon)
			end
        elseif showCat == 3 then
            --Graphics.setImageFilters(psp_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if psp_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, psp_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, psp_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, psp_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, psp_table[p].icon)
				Render.useTexture(modCoverHbrNoref, psp_table[p].icon)
				Render.useTexture(modCoverPSPNoref, psp_table[p].icon)
			end
        else
            --Graphics.setImageFilters(files_table[p].icon, FILTER_LINEAR, FILTER_LINEAR)
			if files_table[p].ricon ~= nil then
				Render.useTexture(modCoverNoref, files_table[p].ricon)
				Render.useTexture(modCoverHbrNoref, files_table[p].ricon)
				Render.useTexture(modCoverPSPNoref, files_table[p].ricon)
			else 
				Render.useTexture(modCoverNoref, files_table[p].icon)
				Render.useTexture(modCoverHbrNoref, files_table[p].icon)
				Render.useTexture(modCoverPSPNoref, files_table[p].icon)
			end
        end
        
        -- Draw box
        if string.match(app_titleid, "PCS") and not string.match(app_titleid, "PCSI") then
            Render.drawModel(modCoverNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
        elseif string.match(app_titleid, "PSPEMU") and not string.match(app_titleid, "PSPEMUCFW") then
            Render.drawModel(modCoverPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
            Render.drawModel(modBoxPSPNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
        else
            Render.drawModel(modCoverHbrNoref, prevX, -1.0, -5 + prevZ, 0, math.deg(prevRot+prvRotY), 0)
        end
    
    elseif showMenu == 2 then
        
        -- SETTINGS
        -- Footer buttons and icons
        Graphics.drawImage(850, 510, btnO)
        Font.print(fnt20, 878, 508, "Close", white)
        Graphics.drawImage(750, 510, btnX)
        Font.print(fnt20, 778, 508, "Select", white)
        Graphics.fillRect(60, 900, 24, 472, darkalpha)
        Font.print(fnt22, 84, 42, "SETTINGS", white)-- Draw info
        
        Graphics.fillRect(60, 900, 150 + (menuY * 40), 190 + (menuY * 40), themeCol)-- selection
        
        menuItems = 6
        
        Font.print(fnt22, 84, 152, "Startup Category: ", white)
        if startCategory == 0 then
            Font.print(fnt22, 84 + 260, 152, "ALL", white)
        elseif startCategory == 1 then
            Font.print(fnt22, 84 + 260, 152, "GAMES", white)
        elseif startCategory == 2 then
            Font.print(fnt22, 84 + 260, 152, "HOMEBREWS", white)
        elseif startCategory == 3 then
            Font.print(fnt22, 84 + 260, 152, "PSP", white)
        end
        
        Font.print(fnt22, 84, 152 + 40, "Reflection Effect: ", white)
        if setReflections == 1 then
            Font.print(fnt22, 84 + 260, 152 + 40, "ON", white)
        else
            Font.print(fnt22, 84 + 260, 152 + 40, "OFF", white)
        end
        
        Font.print(fnt22, 84, 152 + 80, "Sounds: ", white)
        if setSounds == 1 then
            Font.print(fnt22, 84 + 260, 152 + 80, "ON", white)
        else
            Font.print(fnt22, 84 + 260, 152 + 80, "OFF", white)
        end
        
        Font.print(fnt22, 84, 152 + 120, "Theme Color: ", white)
        if themeColor == 1 then
            Font.print(fnt22, 84 + 260, 152 + 120, "Red", white)
        elseif themeColor == 2 then
            Font.print(fnt22, 84 + 260, 152 + 120, "Yellow", white)
        elseif themeColor == 3 then
            Font.print(fnt22, 84 + 260, 152 + 120, "Green", white)
        elseif themeColor == 4 then
            Font.print(fnt22, 84 + 260, 152 + 120, "Grey", white)
        elseif themeColor == 5 then
            Font.print(fnt22, 84 + 260, 152 + 120, "Black", white)
        else
            Font.print(fnt22, 84 + 260, 152 + 120, "Blue", white)
        end
        
        Font.print(fnt22, 84, 152 + 160, "Custom Background: ", white)
        if setBackground == 1 then
            Font.print(fnt22, 84 + 260, 152 + 160, "ON", white)
        else
            Font.print(fnt22, 84 + 260, 152 + 160, "OFF", white)
        end
        
		if scanComplete == false then
			Font.print(fnt22, 84, 152 + 200, "Download Covers", white)
		else
			Font.print(fnt22, 84, 152 + 200, "Reload Covers Database", white)
		end
		
        Font.print(fnt22, 84, 152 + 240, "About", white)
        
        status = System.getMessageState()
        if status ~= RUNNING then
            
            if (Controls.check(pad, SCE_CTRL_CROSS) and not Controls.check(oldpad, SCE_CTRL_CROSS)) then
                if menuY == 0 then
                    if startCategory < 3 then
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
                    else
                        setSounds = 1
                    end
                elseif menuY == 3 then
                    if themeColor < 5 then
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
                    showMenu = 3
                    menuY = 0
                end
                
                
                --Save settings
                local file_config = System.openFile(cur_dir .. "/config.dat", FCREATE)
                System.writeFile(file_config, startCategory .. setReflections .. setSounds .. themeColor .. setBackground, 5)
                System.closeFile(file_config)
            elseif (Controls.check(pad, SCE_CTRL_UP)) and not (Controls.check(oldpad, SCE_CTRL_UP)) then
                --menu
                if setSounds == 1 then
                    --Sound.play(click, NO_LOOP)
                    end
                if menuY > 0 then
                    menuY = menuY - 1
                end
            elseif (Controls.check(pad, SCE_CTRL_DOWN)) and not (Controls.check(oldpad, SCE_CTRL_DOWN)) then
                --menu
                if setSounds == 1 then
                    --Sound.play(click, NO_LOOP)
                    end
                if menuY < menuItems then
                    menuY = menuY + 1
                end
            end
        end
    elseif showMenu == 3 then
        
        -- ABOUT
        -- Footer buttons and icons
        Graphics.drawImage(850, 510, btnO)
        Font.print(fnt22, 878, 508, "Close", white)
        
        Graphics.fillRect(30, 930, 24, 496, darkalpha)-- bg
        
        Font.print(fnt20, 54, 42, "HexFlow Launcher - ver." .. appversion .. "\nby VitaHEX Games\nSupport this project on patreon.com/vitahex", white)-- Draw info
        --Graphics.drawLine(30, 930, 140, 140, white)
        Font.print(fnt20, 54, 132, "Custom Covers\nPlace your custom covers in 'ux0:/data/HexFlow/COVERS/PSVITA/' or '.../PSP/'\nCover images must be in png format and file name must match the App ID or the App Name."
            .. "\n\nCustom Background\nPlace your custom background image in 'ux0:/data/HexFlow/'\nBackground image must be named 'Background.jpg' or 'Background.png' (720p max)"
            .. "\n\nCredits\nProgramming/UI\nSakis RG\n\nDeveloped with Lua Player Plus by Rinnegatamante\n\nSpecial Thanks\nCreckeryop, Andreas Stürmer, Roc6d, Badmanwazzy37", white)-- Draw info
    
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
            if gettingCovers == false then
                FreeMemory()
                if showCat == 1 then
                    System.launchApp(games_table[p].name)
                elseif showCat == 2 then
                    System.launchApp(homebrews_table[p].name)
                elseif showCat == 3 then
                    System.launchApp(psp_table[p].name)
                else
                    System.launchApp(files_table[p].name)
                end
                System.exit()
            end
        elseif (Controls.check(pad, SCE_CTRL_TRIANGLE) and not Controls.check(oldpad, SCE_CTRL_TRIANGLE)) then
            if showMenu == 0 then
				prvRotY = 0
                showMenu = 1
            end
        elseif (Controls.check(pad, SCE_CTRL_START) and not Controls.check(oldpad, SCE_CTRL_START)) then
            if showMenu == 0 then
                showMenu = 2
            end
        elseif (Controls.check(pad, SCE_CTRL_SQUARE) and not Controls.check(oldpad, SCE_CTRL_SQUARE)) then
            -- CATEGORY
            if showCat < 3 then
                showCat = showCat + 1
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
            if showView < 3 then
                showView = showView + 1
            else
                showView = 0
            end
            menuY = 0
            startCovers = false
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
