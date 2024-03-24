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
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
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
-- Custom class to handle attack selection and priority
local AttackSelector = {}
AttackSelector.__index = AttackSelector

function AttackSelector.new(attacks)
    local self = setmetatable({}, AttackSelector)
    self.attacks = attacks
    self.selectedAttacks = {} -- Store selected attack indices
    return self
end
function AttackSelector:AddAttack(attackIndex)
    -- Add an attack to the selection and assign priority
    table.insert(self.selectedAttacks, attackIndex)
end

function AttackSelector:RemoveAttack(attackIndex)
    -- Remove an attack from the selection and adjust priorities
    for i = #self.selectedAttacks, 1, -1 do
        if self.selectedAttacks[i] == attackIndex then
            table.remove(self.selectedAttacks, i)
            break
        end
    end
end

function AttackSelector:GetSelectedAttacks()
    return self.selectedAttacks
end

local AttackSelectorInstance = AttackSelector.new(Attacks)

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.AutoDodge and Toggles.AutoDodge.Value then
            local args = {[1] = {[1] = true,[2] = true},[2] = "DodgeMinigame"}
            pcall(function()
                ReplicatedStorage.Remotes.Information.RemoteFunction:FireServer(unpack(args))
            end)
        end
    end
end))
task.spawn(LPH_JIT_MAX(function()
    while task.wait(2.5) do
        if Toggles.AutoHeal and Toggles.AutoHeal.Value then
            if not player.Character:FindFirstChild('FightInProgress') then
                if player.Character.Humanoid.Health ~= player.Character.Humanoid.MaxHealth then
                    doctorHeal()
                end
            end
        end
    end
end))

player.PlayerGui.Combat.Block:GetPropertyChangedSignal('Visible'):Connect(LPH_JIT_MAX(function()
    if Toggles.AutoDodgeLegit and Toggles.AutoDodgeLegit.Value then
        local waitTime = math.random(Options.DodgeLegitMin.Value, Options.DodgeLegitMax.Value)
        task.wait(waitTime)
        for i = 1, 5 do
            local args = {[1] = {[1] = true,[2] = true},[2] = "DodgeMinigame"}
            pcall(function()
                ReplicatedStorage.Remotes.Information.RemoteFunction:FireServer(unpack(args))
            end)
        end
    end
end))

for _,qwxqrf in pairs({ "Fist", "Spear", "Magic", "Dagger", "Sword", "Thorian"}) do
    if player.PlayerGui.Combat:FindFirstChild(qwxqrf .. 'QTE') then
        player.PlayerGui.Combat:FindFirstChild(qwxqrf .. 'QTE'):GetPropertyChangedSignal('Visible'):Connect(LPH_JIT_MAX(function()
            if Toggles.AutoQTELegit.Value then
                local waitTime = math.random(Options.LegitMin.Value, Options.LegitMax.Value)
                Library:Notify('Auto QTE Legit: Waiting ' .. tostring(waitTime) .. " seconds..")
                task.wait(waitTime)
                local args = {[1] = true,[2] = qwxqrf .. "QTE"}
                for i = 1, 5 do
                    pcall(function()
                        ReplicatedStorage.Remotes.Information.RemoteFunction:FireServer(unpack(args))
                    end)
                    task.wait()
                end
            end
        end))
    end
end

function doQTE()
    if Toggles.AutoQTE.Value then
        local weapons = { "Fist", "Spear", "Magic", "Dagger", "Sword", "Thorian"}
        for _,v in pairs(weapons) do
            local args = {[1] = true,[2] = v .. "QTE"}
            pcall(function()
                player.PlayerGui.Combat:FindFirstChild(v .. "QTE").Visible = false
                ReplicatedStorage.Remotes.Information.RemoteFunction:FireServer(unpack(args))
            end)
        end
    end
end

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        doQTE()
    end
end))

function findTarget(fightID, targetOption)
    local targetList = {}

    -- Collect valid targets in targetList
    for _, entity in pairs(workspace.Living:GetChildren()) do
        if (entity:FindFirstChild('FightInProgress') and tostring(entity.FightInProgress.Value) == tostring(fightID)) then
            local isPlayer = false
            if entity:FindFirstChild('NoTrip') then
                isPlayer = true
            end
            for _,v in pairs(ReplicatedStorage.Fights:FindFirstChild(fightID):WaitForChild('Team2'):GetChildren()) do
                if v.Value == entity.Name then
                    isPlayer = true
                end
            end
            if entity.Name ~= player.Name and not isPlayer then
                table.insert(targetList, entity)
            end  
        end    
    end

    -- Target weakest (lowest health)
    if targetOption == "weakest" then
        local target = nil
        local lowestHealth = math.huge
        for _, entity in ipairs(targetList) do
            local currentHealth = entity.Humanoid.Health or 0
            if currentHealth < lowestHealth then
                lowestHealth = currentHealth
                target = entity
            end
        end
        return target
    end

    -- Target strongest (highest health)
    if targetOption == "strongest" then
        local target = nil
        local highestHealth = 0
        for _, entity in ipairs(targetList) do
            local currentHealth = entity.Humanoid.MaxHealth or 0
            if currentHealth > highestHealth then
                highestHealth = currentHealth
                target = entity
            end
        end
        return target
    end

    -- Target random target
    if targetOption == "random" then
        local numTargets = #targetList
        if numTargets > 0 then
            local randomIndex = math.random(1, numTargets)
            return targetList[randomIndex]
        end
    end

    -- Target one target at a time until they are dead
    if targetOption == "one_at_a_time" then
        for _, entity in ipairs(targetList) do
            if entity.Humanoid.Health and entity.Humanoid.Health > 0 then
                return entity
            end
        end
    end

    -- If no valid target is found or invalid targetOption is provided, return nil
    return nil
end
local function getAttacks()
    local Attacks = {}
    for _,v in pairs(player.PlayerGui.Combat.ActionBG.AttacksPage.ScrollingFrame:GetChildren()) do
        if v:IsA('TextButton') then
            table.insert(Attacks, v.Name)
        end
    end
    return Attacks
end
task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.InfEnergy.Value then
            if tonumber(player.Character.Status.Energy.Value) ~= 6 then
                player.PlayerGui.Combat.CombatHandle.Meditate:FireServer()
            end
        end
    end
end))

local skillConstants = require(ReplicatedStorage.Constants)
function IsSelfTargetSkill(skillName)
    local skillData = skillConstants.Skills[skillName]
    if (skillData and skillData.SelfTarget) then
        return true
    end

    return false
end

local Attacks = getAttacks()
local function attackEntity(initTarget)
    pcall(function()
        local selectedAttacks = AttackSelectorInstance:GetSelectedAttacks()
        local selectedAttacksTable = {}

        for _, attackIndex in ipairs(selectedAttacks) do
            local attackName = Attacks[attackIndex]
            table.insert(selectedAttacksTable, { Name = attackName, Index = attackIndex })
        end
        --[[local concatenatedAttacks = table.concat(selectedAttacksTable, ", ")
        Library:Notify("Selected Attacks: " .. concatenatedAttacks)]]
        task.wait(1)

        for _, attackInfo in ipairs(selectedAttacksTable) do

            local attackTarget = initTarget
            if player.PlayerGui.Combat.ActionBG.AttacksPage.ScrollingFrame:FindFirstChild(attackInfo.Name) then
                if (player.PlayerGui.Combat.ActionBG.AttacksPage.ScrollingFrame[attackInfo.Name]:FindFirstChild('CD')
                and not player.PlayerGui.Combat.ActionBG.AttacksPage.ScrollingFrame[attackInfo.Name]:FindFirstChild('CD').Visible) then
                    debug(attackInfo.Name .. " is not on cooldown")
                    if IsSelfTargetSkill(attackInfo.Name) then
                        attackTarget = player.Character
                        debug(attackInfo.Name .. " is a self-target attack")
                    else
                        debug(attackInfo.Name .. " isn't a self-target attack")
                    end
                    pcall(function()
                        player.PlayerGui.Combat.CombatHandle.RemoteFunction:InvokeServer(
                            "Attack", attackInfo.Name, { ["Attacking"] = attackTarget }
                        )
                    end)
                else
                    debug(attackInfo.Name .. " CD not found")
                end
            end
        end
    end)
end
function attack()
    pcall(function()
        local fightID = (player.Character:FindFirstChild('FightInProgress') and tostring(player.Character:FindFirstChild('FightInProgress').Value))
        if fightID then
            local fightFolder = ReplicatedStorage.Fights:FindFirstChild(fightID)
            if fightFolder then
                local currentTurn = fightFolder:FindFirstChild('CurrentTurn')
                if (currentTurn and tostring(currentTurn.Value) == player.Name) then
                    local target = findTarget(fightID, Options.AttackMethod.Value)
                    if target then
                        debug("Attacking " .. target.Name)
                        attackEntity(target)
                    else
                        debug('No target found!')
                    end
                end
            end
        end
    end)
end

task.spawn(LPH_JIT_MAX(function()
    while task.wait(0.05) do
        if Toggles.AutoEscape.Value then
            pcall(function()
                player.PlayerGui.Combat.CombatHandle.Escape:FireServer()
            end)
        end
        if Toggles.AutoAttack.Value then
            attack()
        end
    end
end))

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.Alluring.Value then
            if not player.Character.Effects:FindFirstChild('AttractOn') then
                if player.Backpack.Tools:FindFirstChild('Alluring Elixir') and not player.Character:FindFirstChild('FightInProgress') then
                    debug'Using alluring elixir..'
                    local args = {
                        [1] = "Use",
                        [2] = "Alluring Elixir"
                    }
                    
                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Information"):WaitForChild("InventoryManage"):FireServer(unpack(args))
                    debug'Waiting for alluring elixir to pop.. (5s timeout)'
                    local timeout = 5
                    local startTime = tick() 

                    repeat
                        task.wait()
                    until player.Character.Effects:FindFirstChild('AttractOn') or tick() - startTime >= timeout
                    if player.Character.Effects:FindFirstChild('AttractOn') then
                        debug'Alluring effect applied!'
                    else
                        debug'Timeout reached. Alluring effect not applied within 5 seconds.'
                    end
                end
            end
        end
    end
end))

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.lcdi.Value then
            collectDroppedItems()
        end
    end
end))

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.lcdinear.Value then
            collectDroppedItemsNear()
        end
    end
end))

task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.AutoMineOre.Value then
            local ore
            local selectedMines = Options.SelectMine:GetActiveValues()
            for _, selectedMine in ipairs(selectedMines) do
                if selectedMine == "Aestic" then
                    for _,v in pairs(workspace.Ores:GetChildren()) do
                        if tostring(v:GetAttributes()['Durability']) ~= "0" and v.Name == "Aestic" then
                            ore = v
                            break
                        end
                    end
                elseif selectedMine == "Ferrus" then
                    for _,v in pairs(workspace.Ores:GetChildren()) do
                        if tostring(v:GetAttributes()['Durability']) ~= "0" and v.Name == "Ferrus" then
                            ore = v
                            break
                        end
                    end
                elseif selectedMine == "Laneus" then
                    for _,v in pairs(workspace.Ores:GetChildren()) do
                        if tostring(v:GetAttributes()['Durability']) ~= "0" and v.Name == "Laneus" then
                            ore = v
                            break
                        end
                    end
                end
            end
            if ore then
                repeat task.wait()
                    player.Character.HumanoidRootPart.CFrame = ore.Ore.CFrame + Vector3.new(0,-5,0)
                    local args = {
                        [1] = "Use",
                        [2] = "Pickaxe"
                    }

                    ReplicatedStorage.Remotes.Information.InventoryManage:FireServer(unpack(args))
                until tostring(ore:GetAttributes()['Durability']) == "0" or not Toggles.AutoMineOre.Value
            end
        end
    end
end))

function collectDroppedItems()
    for _,v in pairs(workspace.Dropped:GetDescendants()) do
        pickingUpFlowers = true
        if v.ClassName == "TouchTransmitter" then
            local startTime = os.clock()
            local initPos = player.Character.HumanoidRootPart.CFrame
            repeat task.wait()
                pcall(function()
                    player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame + Vector3.new(0,-10,0)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                end)
            until not v:IsDescendantOf(workspace) or os.clock() - startTime >= 1 or not Toggles.lcdi.Value
            player.Character.HumanoidRootPart.CFrame = initPos
        end
    end
    pickingUpFlowers = false
end

function collectDroppedItemsNear()
    for _,v in pairs(workspace.Dropped:GetDescendants()) do
        if v.ClassName == "TouchTransmitter" then
            firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
            firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
        end
    end
end

local function getAttackPriority(attackIndex)
    local selectedAttacks = AttackSelectorInstance:GetSelectedAttacks()
    for priority, index in ipairs(selectedAttacks) do
        if index == attackIndex then
            return priority
        end
    end
    return nil
end

local doctorNPC = workspace.NPCs:FindFirstChild('Doctor')

local function getOptionFromDialogue(text)
    local button
    for _,v in pairs(player.PlayerGui.NPCDialogue.BG.Options:GetChildren()) do
        if v:IsA('TextButton') and (v.Text == text or v.Text:match(text)) then
            button = v
            break
        end
    end
    return button
end

local function selectOptionFromDialogue(text)
    local button
    for _,v in pairs(player.PlayerGui.NPCDialogue.BG.Options:GetChildren()) do
        if v:IsA('TextButton') and (v.Text == text or v.Text:match(text)) then
            button = v
            break
        end
    end
    player.PlayerGui.NPCDialogue.RemoteEvent:FireServer(button)
end
local function isOptionFromDialogue(text)
    local button
    for _, v in pairs(player.PlayerGui.NPCDialogue.BG.Options:GetChildren()) do
        if v:IsA('TextButton') and (v.Text == text or v.Text:match(text)) then
            button = v
            break
        end
    end

    if button then
        return true
    end
    return false
end
doctorHealing  = false
startingStats = false
function doctorHeal()
    if not doctorHealing and not startingStats then
        doctorHealing = true
        local savedCFrame = player.Character.HumanoidRootPart.CFrame
        repeat task.wait()
            camera.CFrame = CFrame.new(cf.Position, cf.Position + Vector3.new(0, 1, 0))
            player.Character.HumanoidRootPart.CFrame = doctorNPC.HumanoidRootPart.CFrame + Vector3.new(0,-9,0)
            fireproximityprompt(doctorNPC.Head.ProximityPrompt)
        until player.PlayerGui:FindFirstChild('NPCDialogue')

        selectOptionFromDialogue('Yes please!')

        task.wait()
        player.Character.HumanoidRootPart.CFrame = savedCFrame
        doctorHealing = false
    end
end


workspace.DescendantAdded:Connect(function(v)
    if v.Name == "TouchInterest" then
        if Toggles.KillBrick.Value then
            local parent = v.Parent
            if parent.Name == "Void" or parent.Name == "Fireball"
            or parent.Name == "Faller" or parent.Name == "Geyser" then
            game:GetService("Debris"):AddItem(v,0)
            end
        end
    end
end)

function extractEssenceAmountFromText(text)
    local essenceAmount = text:match("%((%d+)%)")
    return tonumber(essenceAmount)
end

function hasEnoughEssence(requiredEssenceText)
    local essenceValueText = player.PlayerGui.HUD.Holder.Essence.Text
    local requiredEssence = extractEssenceAmountFromText(requiredEssenceText)
    local currentEssence = tonumber(essenceValueText)

    if requiredEssence and currentEssence then
        return currentEssence >= requiredEssence
    end
    return false
end

local function checkAttributeTotal()
    local total = 0
    -- Physical
    local physicalValue = Options.physicalSelector.Value
    total = total + physicalValue
    -- Arcane
    local arcaneValue = Options.arcaneSelector.Value
    total = total + arcaneValue
    -- Endurance
    local enduranceValue = Options.enduranceSelector.Value
    total = total + enduranceValue
    -- Speed
    local speedValue = Options.speedSelector.Value
    total = total + speedValue
    -- Luck
    local luckValue = Options.luckSelector.Value
    total = total + luckValue

    return total
end

function allocateStats()
    local totalValue = checkAttributeTotal()

    if totalValue > 4 then
        Library:Notify("Total Stat Allocation is above 4. Readjust your stat allocation values.\nMake sure you have the race that gives +4 stat points. Make sure u are allocating 3 points if you don't",3)
        task.wait(3)
    elseif totalValue < 3 then
        Library:Notify('Total Stat Allocation is below 3. Readjust your stat allocation values.',3)
        task.wait(3)
    elseif not startingStats then
        debug("Starting stat allocation process.")
        if totalValue >= 4 then
            Library:Notify("Make sure you have the race that gives +4 stat points. Make sure u are allocating 3 points if you don't")
        end
        startingStats = true

        local savedCFrame = player.Character.HumanoidRootPart.CFrame
        local Success = false
        local Aborted = false
        local selectedDialogue = false
        task.spawn(LPH_JIT_MAX(function()
            while not Success and task.wait() do
                if Aborted or Success then
                    break
                end
                player.Character.HumanoidRootPart.CFrame = workspace.NPCs.Aretim.CFrame + Vector3.new(0,0,0)
            end
        end))
        local timeout = 10 -- Timeout in seconds
        local startTime = os.time()
        repeat
            task.wait(1)
            if selectedDialogue then
                Library:Notify('Waiting for Stat Allocation GUI to pop up..')
                repeat task.wait() until player.PlayerGui.HUD.StatAllocate.Visible
                Library:Notify("Stat GUI popped up")
                Success = true
            elseif player.PlayerGui:FindFirstChild('NPCDialogue') and not selectedDialogue then
                if isOptionFromDialogue('Show me his light') then
                    if hasEnoughEssence(getOptionFromDialogue('Show me his light').Text) then
                        selectOptionFromDialogue('Show me his light')
                        selectedDialogue = true
                    else
                        Library:Notify('We do not have the required essence to level up.\n(Auto level up loop is on a 60s timer. If you clicked the button version, dw abt this.)')
                        if isOptionFromDialogue('Not yet') then
                            selectOptionFromDialogue('Not yet')
                        end
                        Aborted = true
                    end
                end
            elseif not player.PlayerGui:FindFirstChild('NPCDialogue') and not selectedDialogue then
                Library:Notify("Dialogue has popped up, selecting dialogue options")
                camera.CFrame = CFrame.new(cf.Position, cf.Position + Vector3.new(0, 1, 0))
                fireproximityprompt(workspace.NPCs.Aretim.ProximityPrompt)
            end

            if os.time() - startTime >= timeout then
                Library:Notify('Timeout reached, exiting the loop.')
                Aborted = true
            end
        until Success or Aborted

        if Success then
            local args = {
                [1] = Options.physicalSelector.Value,
                [2] = Options.arcaneSelector.Value, 
                [3] = Options.enduranceSelector.Value,
                [4] = Options.speedSelector.Value,
                [5] = Options.luckSelector.Value
            }
              
            ReplicatedStorage.Remotes.Information.StatAllocation:FireServer(unpack(args))
              
            local notifyText = "Allocated: "
            for i, value in ipairs(args) do
                notifyText = notifyText.."["..tostring(i).."] "..tostring(value).." " 
            end
              
            Library:Notify(notifyText)
        end
        startingStats = false
        player.PlayerGui.HUD.StatAllocate.Visible = false
        player.Character.HumanoidRootPart.CFrame = savedCFrame
    end

end

local essenceCache = player.PlayerGui.HUD.Holder.Essence.Text
task.spawn(LPH_JIT_MAX(function()
    while task.wait(0.25) do
        if Toggles.AutoStatAllocate.Value then
            if essenceCache ~= player.PlayerGui.HUD.Holder.Essence.Text and tonumber(player.PlayerGui.HUD.Holder.Essence.Text) > tonumber(essenceCache) then
                if not doctorHealing then
                    if player.Character:FindFirstChild('FightInProgress') then
                        Library:Notify('Fight in progress, waiting to auto allocate stats...')
                        repeat task.wait() until not player.Character:FindFirstChild('FightInProgress')
                    end
                    Library:Notify('Allocating stats automatically...')
                    allocateStats()
                    essenceCache = player.PlayerGui.HUD.Holder.Essence.Text
                end
            end
        end
    end
end))



local potionRecipes = {
    ["Small Health Potion"] = {"Everthistle", "Slime Chunk"},
    ["Abhorrent Elixir"] = {"Everthistle", "Everthistle", "Cryastem"},
    ["Minor Empowering Elixir"] = {"Sand Core", "Cryastem", "Carnastool"},
    ["Minor Energy Elixir"] = {"Carnastool", "Everthistle"},
    ["Alluring Elixir"] = {"Everthistle", "Everthistle", "Carnastool"},
    ["Heartsoothing Remedy"] = {"Cryastem", "Everthistle", "Everthistle", "Everthistle"},
    ["Minor Absorbing Potion"] = {"Hightail", "Mushroom Cap"},
    ["Heartbreaking Elixir"] = {"Everthistle", "Everthistle", "Everthistle", "Carnastool"},
    ["Invisibility Potion"] = {"Driproot", "Driproot", "Hightail", "Haze Chunk"},
    ["Ferrus Skin Potion"] = {"Carnastool", "Carnastool", "Sand Core", "Mushroom Cap"}
}

-- Function to count the items in the player's backpack
local function countItems()
    local backpack = player.Backpack
    local tools = backpack.Tools:GetChildren()

    local itemTable = {}

    for _, tool in ipairs(tools) do
        local itemName = tool.Name
        local quantity = 1  -- Assume each item counts as one by default

        -- Update the table or add a new entry for the item
        if itemTable[itemName] then
            itemTable[itemName] = itemTable[itemName] + quantity
        else
            itemTable[itemName] = quantity
        end
    end

    return itemTable
end

-- Function to check if the player has enough ingredients for a specific potion
local function canCraftPotion(potionName)
    local playerItems = countItems()

    local ingredients = potionRecipes[potionName]
    if not ingredients then
        return false -- Potion name not found in the potionRecipes table
    end

    for _, item in ipairs(ingredients) do
        local requiredQuantity = 1 -- Assume each ingredient in the recipe counts as one by default

        -- Check if the item exists in the player's backpack
        if playerItems[item] then
            if playerItems[item] < requiredQuantity then
                return false -- Player doesn't have enough of this ingredient
            end
        else
            return false -- Player doesn't have this ingredient at all
        end
    end

    return true -- Player has all the required ingredients for the potion
end

local function getAllPotionNames()
    local potionNames = {}

    for potionName, _ in pairs(potionRecipes) do
        table.insert(potionNames, potionName)
    end

    return potionNames
end

local function getToolByName(toolName)
    local backpack = player.Backpack
    local tools = backpack.Tools:GetChildren()

    for _, tool in ipairs(tools) do
        if tool.Name == toolName then
            return tool
        end
    end

    return nil
end
local function fireproximityprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
    else 
        error("userdata<ProximityPrompt> expected")
    end
end
local function findNearestCauldron(player)
    local targetPosition = player.Character and player.Character.HumanoidRootPart.Position

    if targetPosition then
        local closestCauldron = nil
        local closestDistanceSquared = math.huge

        local cauldrons = workspace.Cauldrons:GetChildren()
        for _, cauldron in ipairs(cauldrons) do
            if cauldron:IsA('Model') then
                local cauldronPosition = cauldron.Water.Position
                local distanceSquared = (cauldronPosition - targetPosition).Magnitude

                if distanceSquared < closestDistanceSquared then
                    closestCauldron = cauldron
                    closestDistanceSquared = distanceSquared
                end
            end
        end

        return closestCauldron
    end
end
local function craftPotion(selectedPotion)
    task.wait(0.1)
    local cauldron = findNearestCauldron(player)
    local ingredients = potionRecipes[selectedPotion]
    local abortttt = false
    local save = player.Character.HumanoidRootPart.CFrame
    task.spawn(LPH_JIT_MAX(function()
        while not abortttt and task.wait() do
            player.Character.HumanoidRootPart.CFrame = cauldron.Water.CFrame
            local camera = workspace.CurrentCamera
            local cf = camera.CFrame
            camera.CFrame = CFrame.new(cf.Position, cf.Position - Vector3.new(0, 1, 0))
        end
    end))
    for _, ingredient in ipairs(ingredients) do
        local tool = player.Backpack.Tools:FindFirstChild(ingredient)
        workspace.Camera.CameraSubject = cauldron.Water.ProximityPrompt
        if tool then
            repeat task.wait()
                local args = {
                    [1] = "Equip",
                    [2] = ingredient
                }
                
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Information"):WaitForChild("InventoryManage"):FireServer(unpack(args))  
            until player.Character:FindFirstChild(ingredient)                  
            repeat task.wait()
                fireproximityprompt(cauldron.Water.ProximityPrompt, 1,true)
            until not player.Character:FindFirstChild(tool)
        end
    end
    for _,v in pairs(cauldron:GetDescendants()) do
        if v.ClassName == "ClickDetector" then
            fireclickdetector(v, 1)
        end
    end
    Library:Notify('Successfully brewed ' .. selectedPotion .. '!')
    abortttt = true
end
task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.AutoBrewPotion.Value then
            if canCraftPotion(Options.SelectPotion.Value) then
                craftPotion(Options.SelectPotion.Value)
            end
        end
    end
end))
function useAbhorrent(brew)
    if not player.Character.Effects:FindFirstChild('RepelOn') then
        if player.Backpack.Tools:FindFirstChild('Abhorrent Elixir') then
            repeat
                player.Character.HumanoidRootPart.CFrame = CFrame.new(-345, 30, -3500)
                local args = {
                    [1] = "Use",
                    [2] = "Abhorrent Elixir"
                }
                
                ReplicatedStorage.Remotes.Information.InventoryManage:FireServer(unpack(args))
                task.wait(5) 
            until player.Character.Effects:FindFirstChild('RepelOn')
        else
            if brew then
                if canCraftPotion('Abhorrent Elixir') then
                    craftPotion('Abhorrent Elixir')
                    task.wait(2)
                    useAbhorrent(true)
                end
            end
        end
    end
end
local Noclipping = nil
Clip = true
function noclip()
	Clip = false
	wait(0.1)
	local function NoclipLoop()
		if Clip == false and player.Character ~= nil then
			for _, child in pairs(player.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end
	end
	Noclipping = RunService.Stepped:Connect(NoclipLoop)
end

function clip()
	if Noclipping then
		Noclipping:Disconnect()
	end
	Clip = true
end
task.spawn(LPH_JIT_MAX(function()
    while task.wait() and Toggles do
        local savePos = player.Character.HumanoidRootPart.CFrame
        if Toggles.lcsi2.Value then
            pickingUpFlowers = true
            debug'ITS ON'
            if Toggles.lcsiUseElixir.Value then
                useAbhorrent(true)
            end
            player.Character.HumanoidRootPart.CFrame = savePos
            for _,v in pairs(workspace.SpawnedItems:GetDescendants()) do
                if not Toggles.lcsi2.Value then player.Character.HumanoidRootPart.CFrame = savePos break end
                if Toggles.lcsiUseElixir.Value then
                    useAbhorrent(true)
                end
                if v.ClassName == "ClickDetector" then
                    local clickPart = v.Parent
                    if clickPart then
                        repeat task.wait()
                            player.Character.HumanoidRootPart.CFrame = clickPart.CFrame + Vector3.new(0,-14,0)
                            fireclickdetector(v, 1)
                        until not v:IsDescendantOf(workspace) or not Toggles.lcsi2.Value
                    end
                end
            end
            player.Character.HumanoidRootPart.CFrame = savePos
            pickingUpFlowers = false
            if Toggles.lcsiServerHop.Value then
                task.wait()
                player.Character.HumanoidRootPart.CFrame = savePos
                Teleport()
            end
        else
            if not workspace.SpawnedItems:FindFirstChildWhichIsA('Model') and Toggles.lcsiServerHop.Value then
                player.Character.HumanoidRootPart.CFrame = savePos
                task.wait(.25)
                player.Character.HumanoidRootPart.CFrame = savePos
                Teleport()
            end
        end
    end
end))
local enviroEffects = ReplicatedStorage.Remotes.Information.EnviroEffects
local old
old = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    local noFallToggle = (Toggles and Toggles.NoFall and Toggles.NoFall.Value) or (pickingUpFlowers) or (startingStats) or (doctorHealing)
    if not checkcaller() and self == enviroEffects and method == "FireServer" and args[2] and type(args[2]) == "number" and args[2] > 0 and (noFallToggle or Toggles.lcsi2.Value) then
        return task.wait(9e9)
    end

    return old(self, ...)
end))

-- Helper function to teleport the player to the selected teleport
local function TeleportToSelectedTeleport(teleportCFrame)
    if teleportCFrame then
        player.Character.HumanoidRootPart.CFrame = teleportCFrame
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
-- Define the teleports for each category in separate tables
local spawnsTeleports = {}
local buyablesTeleports = {}
local npcTeleports = {}
local questNPCTeleports = {}

for _, v in pairs(workspace.Spawns:GetChildren()) do
    table.insert(spawnsTeleports, v.Name)
end

for _, v in pairs(workspace.Buyables:GetChildren()) do
    table.insert(buyablesTeleports, v.Name)
end

for _, v in pairs(workspace.NPCs:GetChildren()) do
    if v:IsA('Model') or v:IsA('Part') then
        table.insert(npcTeleports, v.Name)
    end
end

for _,v in pairs(workspace.NPCs.Quest:GetChildren()) do
    table.insert(questNPCTeleports, v.Name)
end

-- Setting up UI
local Window = Library:CreateWindow({
    Title = '.neatsimenusenonick_ | ARCANE LINEAGE',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Dupe = Window:AddTab('Rollback'),
}

local LogsBox = Tabs.Logs:AddLeftGroupbox('Logs')
local LogsBoxC = Tabs.Logs:AddRightGroupbox('Logs Control')
logsLabel = LogsBox:AddLabel('', true)
LogsBoxC:AddButton('Reset Logs', function()
    logsTable = {}
    debug('Reset logs!')
end)

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

Tabs.Teleports:AddRightGroupbox('Buyables'):AddDropdown('BuyablesDropdown', {
    Text = 'Select a buyable teleport',
    Tooltip = 'Choose a buyable teleport destination',
    Values = buyablesTeleports,
    AllowNull = true,
    Callback = function(Value)
        local teleportName = Value
        if teleportName then
            -- Retrieve the CFrame for the selected buyable teleport based on its name
            local selectedTeleportCFrame = workspace.Buyables:FindFirstChild(teleportName)
            TeleportToSelectedTeleport(selectedTeleportCFrame and selectedTeleportCFrame:GetPivot())
        end
    end
})

Tabs.Teleports:AddRightGroupbox('NPCs'):AddDropdown('NPCDropdown', {
    Text = 'Select an npc teleport',
    Tooltip = 'Choose an npc teleport destination',
    Values = npcTeleports,
    AllowNull = true,
    Callback = function(Value)
        local teleportName = Value
        if teleportName then
        -- Retrieve the CFrame for the selected encounter teleport based on its name
        local selectedTeleportCFrame = workspace.NPCs:FindFirstChild(teleportName)
        TeleportToSelectedTeleport(selectedTeleportCFrame and selectedTeleportCFrame:GetPivot())
        end
    end
})

Tabs.Teleports:AddLeftGroupbox('Quest NPCs'):AddDropdown('QuestNPCDropdown', {
    Text = 'Select an quest npc teleport',
    Tooltip = 'Choose an quest npc teleport destination',
    Values = questNPCTeleports,
    AllowNull = true,
    Callback = function(Value)
        local teleportName = Value
        -- Retrieve the CFrame for the selected encounter teleport based on its name
        if teleportName then
        local selectedTeleportCFrame = workspace.NPCs.Quest:FindFirstChild(teleportName)
        TeleportToSelectedTeleport(selectedTeleportCFrame and selectedTeleportCFrame:GetPivot())
        end
    end
})

OtherTP:AddButton('Meditate', function()
    player.Character.HumanoidRootPart.CFrame = CFrame.new(-246.974853515625, 42.98745346069336, -3351.39501953125)
end)
OtherTP:AddButton('Shard Shop', function()
    player.Character.HumanoidRootPart.CFrame = CFrame.new(-384.1550598144531, 43.49483108520508, -3389.0068359375)
end)

OtherTP:AddButton('Yarthul Gate', function()
    player.Character.HumanoidRootPart.CFrame = CFrame.new(-5043.93310546875, 51.526851654052734, -3129.505859375)
end)



local AutoAttack = Tabs.Main:AddLeftTabbox('Encounters')
local EFeatures = AutoAttack:AddTab('Encounters')
local SelectSkills = AutoAttack:AddTab('Select Skills')
EFeatures:AddToggle('AutoAttack', {Text = 'Auto Attack',Default = false, Tooltip = "Automatically attack (using skills) in encounters.\nSelect skills in the 'Select Skills' tab." })
EFeatures:AddDropdown('AttackMethod', {Values = {"weakest", "strongest", "random", "one_at_a_time"}, Multi = false, AllowNull = false, Default = 1, Text = 'Select attack target priority'})
EFeatures:AddToggle('AutoEscape', {Text = 'Auto Escape',Default = false, Tooltip = "Automatically tries to escape in encounters."})
--EFeatures:AddToggle('InfMeditate', {Text = 'Infinite Energy',Default = false, Tooltip = "Get 6 full energy bars almost instantly before attacking.\nTHIS DOES LOWER YOUR GUARD BY ALOT AND MAY GET U 1 SHOTTED!"})
local attackLabels = {} -- Store labels for each attack

for i, attack in ipairs(Attacks) do
    local label
    local is_self_target = IsSelfTargetSkill(attack)
    local toggle = SelectSkills:AddToggle('AutoAttack' .. i, {
        Text = (is_self_target and (attack .. " [self]") or attack),
        Default = false,
        Tooltip = (is_self_target and "This will be casted on yourself." or "This will be casted on enemies."),
        Callback = function(value)
            -- Update the AttackSelectorInstance when a toggle is clicked
            if value then
                AttackSelectorInstance:AddAttack(i)
            else
                AttackSelectorInstance:RemoveAttack(i)
            end

            -- Update the label display to show or hide the priority number
            local priority = getAttackPriority(i)
            label:SetText(value and ('[Priority %d] %s'):format(priority, attack) or "no priority..")
        end
    })
    label = SelectSkills:AddLabel('')
    -- Set initial label text
    local priority = getAttackPriority(i)
    label:SetText(toggle.Value and ('[Priority %d] %s'):format(priority, attack) or "no priority..")

    table.insert(attackLabels, label)
end

local Level = Tabs.Main:AddLeftGroupbox('Auto Level')
Level:AddToggle('AutoStatAllocate', {Text = 'Auto Level Up after Fight', Default = false, Tooltip = "Attempt to auto lvl up and allocate stats after you finish a fight\nand collect the essence."})
Level:AddButton('Level Up', function() 
    allocateStats()
end)
Level:AddSlider('physicalSelector', {Text = 'Stat Allocation: Physical', Default = 0, Min = 0, Max = 3, Rounding = 0, Compact = true})
Level:AddSlider('arcaneSelector', {Text = 'Stat Allocation: Arcane', Default = 0, Min = 0, Max = 3, Rounding = 0, Compact = true})
Level:AddSlider('enduranceSelector', {Text = 'Stat Allocation: Endurance', Default = 0, Min = 0, Max = 3, Rounding = 0, Compact = true})
Level:AddSlider('speedSelector', {Text = 'Stat Allocation: Speed', Default = 0, Min = 0, Max = 3, Rounding = 0, Compact = true})
Level:AddSlider('luckSelector', {Text = 'Stat Allocation: Luck', Default = 0, Min = 0, Max = 3, Rounding = 0, Compact = true})

local QTE = Tabs.Main:AddLeftTabbox('Auto Dodge')
local QTE1 = QTE:AddTab('Auto Dodge')
QTE1:AddToggle('AutoDodge', {Text = 'Auto Instant Dodge', Default = false, Tooltip = "Automatically and instantly perform Dodges."})
QTE1:AddToggle('AutoDodgeLegit', {Text = 'Auto Legit Dodge', Default = false, Tooltip = "Automatically perform delayed Dodges."})
QTE1:AddSlider('DodgeLegitMin', {Text = 'Legit Dodge: Min Delay', Default = 0.4, Min = 0.1, Max = 1, Rounding = 1, Compact = false})
QTE1:AddSlider('DodgeLegitMax', {Text = 'Legit Dodge: Max Delay', Default = 0.7, Min = 0.1, Max = 1, Rounding = 1, Compact = false})

local QTE2 = QTE:AddTab('Auto QTE')
QTE2:AddToggle('AutoQTE', {Text = 'Auto Instant QTE (minigame)', Default = false, Tooltip = "Automatically and instantly perform Quick Time Events (QTEs)."})
QTE2:AddToggle('AutoQTELegit', {Text = 'Auto Legit QTE (minigame)', Default = false, Tooltip = "Automatically perform delayed Quick Time Events (QTEs)."})
QTE2:AddSlider('LegitMin', {Text = 'Legit QTE: Min Delay (seconds)', Default = 4, Min = 1, Max = 10, Rounding = 0, Compact = false})
QTE2:AddSlider('LegitMax', {Text = 'Legit QTE: Max Delay (seconds)', Default = 6, Min = 1, Max = 10, Rounding = 0, Compact = false})

local Misc = Tabs.Main:AddLeftGroupbox('Misc Features')
Misc:AddToggle('NoFall', {Text = 'No Fall', Default = false, Tooltip = "Prevent falling damage."})
Misc:AddToggle('InfEnergy', {Text = 'Spam Meditate', Default = false, Tooltip = "THIS DOES LOWER UR GUARD AND MAY GET U 1 SHOTTED!\nTHIS DOES LOWER UR GUARD AND MAY GET U 1 SHOTTED!\nTHIS DOES LOWER UR GUARD AND MAY GET U 1 SHOTTED!\nTHIS DOES LOWER UR GUARD AND MAY GET U 1 SHOTTED!\nTHIS DOES LOWER UR GUARD AND MAY GET U 1 SHOTTED!\nTHIS DOES LOWER UR GUARD AND MAY GET U 1 SHOTTED!\n"})
--Misc:AddToggle('InfGuard', {Text = 'Infinite Guard', Default = false})
Misc:AddToggle('AutoHeal', {Text = 'Auto Heal (doctor)', Default = false, Tooltip = "Auto Heal using the doctor."})
Misc:AddToggle('KillBrick', {Text = 'No Kill Bricks', Default = false, Tooltip = "You won't die to void, geysers, fireballs, fallers\nYou can still die to fires in the blacksmithes", Callback = function(v)
    if v then
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") then
                local parentName = obj.Parent.Name
                if parentName == "Void" or parentName == "Fireball" 
                or parentName == "Faller" or parentName == "Geyser" then

                    obj:Destroy()
                elseif (obj.Parent and obj.Parent.BrickColor and (obj.Parent.BrickColor == BrickColor.new("Really black") or obj.Parent.BrickColor == BrickColor.new("Bright red"))) then 
                    obj:Destroy()
                end
            end
        end
    end
end})
Misc:AddButton('Doctor Heal', function()
doctorHeal()
end)

local Collect = Tabs.Main:AddRightTabbox('Auto Collect')
local AutoCollectSpawn = Collect:AddTab('Spawned Items')
local AutoCollectDrop = Collect:AddTab('Dropped Items')
AutoCollectSpawn:AddToggle('lcsi2', {Text = 'Loop Collect Spawned Items', Default = false, Tooltip = "Automatically gather spawnable items like flowers."})
AutoCollectSpawn:AddToggle('lcsiUseElixir', {Text = 'Auto Abhorrent Elixir', Default = false, Tooltip = "Automatically use Abhorrent Elixir.\n(it will also craft an Abhorrent Elixir if you don't have one)"})
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



local Potion = Tabs.Main:AddRightTabbox('Auto Potion')
local Craft = Potion:AddTab('Auto Craft')
local Use = Potion:AddTab('Auto Use')
Craft:AddToggle('AutoBrewPotion', {Text = 'Auto Brew Potions', Default = false, Tooltip = "Automatically brew potions."})
Craft:AddDropdown('SelectPotion', {Values = getAllPotionNames(), Multi = false, AllowNull = false, Default = 1, Text = 'Select Potion to Brew'})

Use:AddToggle('Alluring', {Text = 'Auto Use Alluring', Default = false})
Use:AddLabel("more coming soon..")

local Merchant = Tabs.Main:AddRightGroupbox('Auto Merchant')
Merchant:AddToggle('MerchantNotifier', {Text = 'Mysterious Merchant Notifier', Default = false, Tooltip = "Get notified when the mysterious merchant spawns."})
Merchant:AddToggle('MerchantHopper', {Text = 'Server Hop Until Merchant', Default = false, Tooltip = "Server Hops until there is a merchant in your lobby."})
Merchant:AddButton('Teleport to Merchant', function()
    local merchant = workspace.NPCs:FindFirstChild('Mysterious Merchant')
    
    if merchant then
      local lookVec = merchant.HumanoidRootPart.CFrame.LookVector
      local newPos = merchant.HumanoidRootPart.Position + (lookVec * 5) 
      newPos = Vector3.new(newPos.X, merchant.HumanoidRootPart.Position.Y, newPos.Z)
      
      player.Character.HumanoidRootPart.CFrame = CFrame.new(newPos)
    end
end)
local merchantLabel = Merchant:AddLabel("Merchant Status: Not Spawned ! .neatsimenusenonick_")
task.spawn(LPH_JIT_MAX(function()
    while task.wait(2.5) do
        if workspace.NPCs:FindFirstChild('Mysterious Merchant') then
            merchantLabel:SetText('Merchant Status: Spawned')
            if Toggles.MerchantNotifier.Value then
                Library:Notify('The Mysterious Merchant is currently spawned!')
            end
        else
            merchantLabel:SetText('Merchant Status: Not Spawned')
        end
    end
end))
task.spawn(LPH_JIT_MAX(function()
    task.wait(3)
    if not workspace.NPCs:FindFirstChild('Mysterious Merchant') then
        if Toggles.MerchantHopper.Value then
            Teleport()
        end
    end
end))
local function GetUniqueToolNames()
    local uniqueToolNames = {}
    local toolsFolder = player.Backpack:FindFirstChild("Tools")

    for _, tool in ipairs(toolsFolder:GetChildren()) do
        if not table.find(uniqueToolNames, tool.Name) then
            table.insert(uniqueToolNames, tool.Name)
        end
    end

    return uniqueToolNames
end
local Drop = Tabs.Main:AddRightGroupbox('Auto Drop')
Drop:AddToggle('AutoDrop', {Text = 'Auto Drop Item', Default = false, Tooltip = "Automatically drops selected item from your inventory."})
local dropdd = Drop:AddDropdown('DropItem', {Values = GetUniqueToolNames(), Multi = false, AllowNull = true, Text = 'Select Item to Drop'})
Drop:AddButton('Refresh Item List', function()
    dropdd:SetValues(GetUniqueToolNames())
end)
task.spawn(LPH_JIT_MAX(function()
    while task.wait() do
        if Toggles.AutoDrop.Value then
            ReplicatedStorage.Remotes.Information.InventoryManage:FireServer("Drop", Options.DropItem.Value)
        end
    end
end))
local Mine = Tabs.Main:AddRightGroupbox('Mines')
Mine:AddToggle('AutoMineOre', {Text = 'Auto Mine Ore', Default = false, Tooltip = "Automatically mine ores in the game.\nYou must have a pickaxe in your inventory!"})
Mine:AddDropdown('SelectMine', {Values = {"Aestic", "Ferrus", "Laneus"}, Multi = true, AllowNull = false, Default = 1, Text = 'Select Ore to Mine'})
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddToggle('KeybindUI', {Text = 'Show Keybind UI', Default = false, Callback = function(v) Library.KeybindFrame.Visible = v end})
Library.ToggleKeybind = Options.MenuKeybind
Library.KeybindFrame.Visible = false

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
