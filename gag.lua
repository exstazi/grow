-- Göm alla andra GUI först (valfritt)
for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
	if v:IsA("Frame") or v:IsA("ScrollingFrame") or v:IsA("TextLabel") then
		if v.Visible and not v.Name:match("Main") then
			v.Visible = false
		end
	end
end

-- Öppna Seed Shop
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.Seed_Shop.Main.Visible = true
end)

-- Öppna Sell Shop / Prompt
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.SellPrompt.Visible = true
end)

-- Öppna Pet Shop
pcall(function()
	require(game.ReplicatedStorage.Modules.ActivePetsUIController).open()
end)

-- Öppna Fertilizer Shop
pcall(function()
	require(game.ReplicatedStorage.Modules.FertilizerShopController).open()
end)

-- Öppna Tool Shop
pcall(function()
	require(game.ReplicatedStorage.Modules.ToolShopController).open()
end)

-- Öppna Quest GUI
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.QuestUI.Visible = true
end)

-- Öppna Event UI
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.Event_UI.Visible = true
end)

print("[✅] Alla shops och menyer öppnade.")
