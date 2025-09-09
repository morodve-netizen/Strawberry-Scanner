-- the commands themselves, the scanner is more important tbh
-- messy code, contributions welcome like always
-- very little documentation/comments so please try to read the code good
-- last updated: 9/8/25

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
		Icon = "phosphor-users-bold"
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
		return Player.Character or Player.CharacterAdded:Wait()
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
				return vplayer.Character
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

		if typeof(Characters) == "table" then -- this means its a table of characters instead of one
			for _, v in ipairs(Characters) do
				if v:FindFirstChild("Head") then
					Delete(v:FindFirstChild("Head")) -- removing the head which kills the player
				end
			end
		else -- if it got to this point its a single character so we do that
			if Characters:FindFirstChild("Head") then
				Delete(Characters:FindFirstChild("Head"))
			end
		end
	end
}

local Paragraph = Tabs.Settings:CreateParagraph("Paragraph", {
	Title = "Adding settings menu soon...",
	Content = "too lazy to add rn, also splitting all the commands in different tabs based on what they do."
})
