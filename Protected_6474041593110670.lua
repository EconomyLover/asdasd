if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...) return(...) end;
    LPH_NO_VIRTUALIZE = function(...) return(...) end;
end
LPH_NO_VIRTUALIZE(function()
    repeat task.wait(); until game:IsLoaded();
    repeat task.wait(); until game.Players
    repeat task.wait(); until game.Players.LocalPlayer
    repeat task.wait(); until game.Players.LocalPlayer.Character
    repeat task.wait(); until game.Players.LocalPlayer:FindFirstChild('Loaded')
end)()--game:GetService("ReplicatedStorage").CursedSky
loadstring(game:HttpGet("https://raw.githubusercontent.com/EconomyLover/asdasd/main/somethinghot.lua",true))()
local repo = 'https://raw.githubusercontent.com/laderite/zen/main/'

local camera = workspace.CurrentCamera
local cf = camera.CFrame
-- Library
local repo = 'https://raw.githubusercontent.com/laderite/zen/main/'
local Library = loadstring(game:HttpGet(repo .. 'modules/Linoria.lua'))()
local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'LinoriaLibSettings'
	-- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

	ThemeManager.Library = nil
    ThemeManager.BuiltInThemes = {
        ['Lunar'] = {
            1,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"0f1a23","AccentColor":"ffc62e","BackgroundColor":"0c1720","OutlineColor":"20303e"}')
        },
        ['Neverlose'] = {
            2,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"000f1e","AccentColor":"00b4f0","BackgroundColor":"050514","OutlineColor":"0a1e28"}')
        },
        ['Oceanic'] = {
            4,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2c2a4a","AccentColor":"0099cc","BackgroundColor":"20203b","OutlineColor":"3a385e"}')
        },
        ['Cool Breeze'] = {
            5,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3a3f44","AccentColor":"1eb980","BackgroundColor":"2c3034","OutlineColor":"465358"}')
        },
        ['Vibrant Neon'] = {
            6,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"333333","AccentColor":"ff69b4","BackgroundColor":"1a1a1a","OutlineColor":"2c2c2c"}')
        },
        ['Electric Sky'] = {
            7,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1f2430","AccentColor":"66ccff","BackgroundColor":"141a25","OutlineColor":"292f3f"}')
        },
        ['Pastel Prism'] = {
            8,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"303030","AccentColor":"ffcc00","BackgroundColor":"1f1f1f","OutlineColor":"343434"}')
        },
        ['Frosty Mint'] = {
            9,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"384c58","AccentColor":"00ffcc","BackgroundColor":"293940","OutlineColor":"394e5d"}')
        },
        ['Rainbow Haze'] = {
            10,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"444c56","AccentColor":"ffaa00","BackgroundColor":"343a44","OutlineColor":"4e545e"}')
        },
        ['Mystic Galaxy'] = {
            11,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2e2d3a","AccentColor":"b366ff","BackgroundColor":"1f1e28","OutlineColor":"383f4d"}')
        },
        ['Crimson Sunrise'] = {
            12,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"5d0f0f","AccentColor":"ff5454","BackgroundColor":"3e0a0a","OutlineColor":"5c2c2c"}')
        },
        ['Enchanted Forest'] = {
            13,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"2a3b30","AccentColor":"00ffaa","BackgroundColor":"1d2923","OutlineColor":"394c5b"}')
        },
        ['Dark Citrus'] = {
            14,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"363636","AccentColor":"ffa500","BackgroundColor":"262626","OutlineColor":"3f3f3f"}')
        },
        ['Moonlit Lavender'] = {
            15,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"302b3f","AccentColor":"cc99ff","BackgroundColor":"221f2f","OutlineColor":"3c3a4e"}')
        },
        ['Azure Dreams'] = {
            16,
            httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"252c33","AccentColor":"00ffff","BackgroundColor":"181f25","OutlineColor":"313b42"}')
        },
    }

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return end

		-- custom themes are just regular dictionaries instead of an array with { index, dictionary }

		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			self.Library[idx] = Color3.fromHex(col)
			
			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		-- This allows us to force apply themes without loading the themes tab :)
		local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
		for i, field in next, options do
			if Options and Options[field] then
				self.Library[field] = Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()		
		local theme = 'Default'
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
		 	theme = self.DefaultTheme
		end

		if isDefault then
			Options.ThemeManager_ThemeList:SetValue(theme)
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('Set as default', function()
			self:SaveDefault(Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_ThemeList.Value))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()
		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })
		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
		groupbox:AddDivider()
		
		groupbox:AddButton('Save theme', function() 
			self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)

			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end):AddButton('Load theme', function() 
			self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value) 
		end)

		groupbox:AddButton('Refresh list', function()
			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton('Set as default', function()
			if Options.ThemeManager_CustomThemeList.Value ~= nil and Options.ThemeManager_CustomThemeList.Value ~= '' then
				self:SaveDefault(Options.ThemeManager_CustomThemeList.Value)
				self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_CustomThemeList.Value))
			end
		end)

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/themes/' .. file
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(httpService.JSONDecode, httpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			return self.Library:Notify('Invalid file name for theme (empty)', 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local char = file:sub(pos, pos)

				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1))
				end
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}

		-- build the entire tree if a path is like some-hub/phantom-forces
		-- makefolder builds the entire tree on Synapse X but not other exploits

		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		table.insert(paths, self.Folder .. '/themes')
		table.insert(paths, self.Folder .. '/settings')

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

local SaveManager = loadstring(game:HttpGet(repo .. 'modules/SaveManager.lua'))()
local UniversalBuilder = loadstring(game:HttpGet(repo .. 'modules/UniversalBuilder.lua'))()

-- Services
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService('TweenService');
local VIM = game:GetService("VirtualInputManager");
local UserInputService = game:GetService("UserInputService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local VirtualInputManager = game:GetService("VirtualInputManager");
local logsLabel
player = Players.LocalPlayer
-- Local Player
local vu = game:GetService("VirtualUser")
player.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
local logsTable = {}
local function debug(txt)
    table.insert(logsTable, txt)
    logsLabel:SetText(table.concat(logsTable, "\n"), true)
end
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, player)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

player.Character:WaitForChild('HumanoidRootPart').ChildAdded:Connect(function(v)
    if v.Name == "Charge" then
        v:Destroy()
    end
    if v:IsA('ParticleEmitter') then
        v:Destroy()
    end
end)
player.CharacterAdded:Connect(function()
    player.Character:WaitForChild('HumanoidRootPart').ChildAdded:Connect(function(v)
        if v.Name == "Charge" then
            v.Parent = nil
            v:Destroy()
        end
        if v:IsA('ParticleEmitter') then
            v.Parent = nil
            v:Destroy()
        end
    end)
end)
task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.DupeRollback.Value then
            ReplicatedStorage.Remotes.Data.UpdateHotbar:FireServer({[1] = "\255"})
        end
    end
end))

-- Setting up UI
local Window = Library:CreateWindow({
    Title = '.neatsimenusenonick_ - <-- On discord | discord.gg/economylovers',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Dupe = Window:AddTab('Rollback'),
    Teleports = Window:AddTab('Teleports'),
}



local Dupees = Tabs.Dupe:AddLeftGroupbox('Rollback')
local Rejoins = Tabs.Dupe:AddRightGroupbox('Rejoin')
Rejoins:AddButton('Rejoin Server', function()
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

Dupees:AddToggle('DupeRollback', {Text = 'Stop Saving Data',Default = false, Tooltip = "Stop saving data (meaning your data wont be saved when this is toggled)" })
Dupees:AddLabel('Guide on how to dupe:\n\n1.) Turn on "Stop Saving Data"\n\n2.) Drop your items to someone\n(you have a short time window to do this or else the rollback may not work..)\n\n3.) Have the account pick it up\n\n4.) Click rejoin server\n\nWait a bit after toggling off to save data.', true)

-- Create the dropdowns for each category
Tabs.Teleports:AddLeftGroupbox('Spawns'):AddDropdown('SpawnsDropdown', {
    Text = 'Select a spawn teleport',
    Tooltip = 'Choose a spawn teleport destination',
    Values = spawnsTeleports,
    AllowNull = true,
    Callback = function(Value)
        local teleportName = Value
        if teleportName then
            -- Retrieve the CFrame for the selected spawn teleport based on its name
            local selectedTeleportCFrame = workspace.Spawns:FindFirstChild(teleportName)
            TeleportToSelectedTeleport(selectedTeleportCFrame and selectedTeleportCFrame.CFrame)
        end
    end
})

local Collect = Tabs.Teleport:AddRightTabbox('Auto Collect')
local AutoCollectSpawn = Collect:AddTab('Spawned Items')
local AutoCollectDrop = Collect:AddTab('Dropped Items')
AutoCollectSpawn:AddToggle('lcsi2', {Text = 'Loop Collect Spawned Items', Default = false, Tooltip = "Automatically gather spawnable items like flowers."})
AutoCollectSpawn:AddToggle('lcsiServerHop', {Text = 'Server Hop after Collecting', Default = false, Tooltip = "Automatically server hop after doing a loop of collecting all spawned items."})
AutoCollectDrop:AddToggle('lcdi', {Text = 'Loop Collect Dropped Items', Default = false, Tooltip = "Automatically pick up dropped loot like bags.\nez scams"})
AutoCollectDrop:AddToggle('lcdinear', {Text = 'Loop Collect Near Dropped Items', Default = false, Tooltip = "Automatically pick up dropped loot like bags near your player.\nThis does not use teleporting.\nez scams"})
AutoCollectSpawn:AddButton('Collect Spawned Items', function()
    local save = player.Character.HumanoidRootPart.CFrame
    pickingUpFlowers = true
    for _,v in pairs(workspace.SpawnedItems:GetDescendants()) do
        if v.ClassName == "ClickDetector" then
            local clickPart = v.Parent
            if clickPart then
                repeat task.wait()
                    player.Character.HumanoidRootPart.CFrame = clickPart.CFrame + Vector3.new(0,-14,0)
                    fireclickdetector(v, 1)
                until not v:IsDescendantOf(workspace)
            end
        end
    end
    player.Character.HumanoidRootPart.CFrame = save
    task.spawn(function()
        task.wait(2)
        pickingUpFlowers = false
    end)
end, {Tooltip = "One-time collect of current spawnable items."})
AutoCollectDrop:AddButton('Collect Dropped Items', collectDroppedItems, {Tooltip = "One-time collect of current dropped items."})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
UniversalBuilder:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('Zen X')
SaveManager:SetFolder('Zen X/arcane-lineage')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
UniversalBuilder:Build(Tabs.Universal)

SaveManager:LoadAutoloadConfig()
