-- Öppna fröshop
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.Seed_Shop.Main.Visible = true
end)

-- Öppna säljshop
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.SellPrompt.Visible = true
end)

-- Öppna questfönster
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.QuestUI.Visible = true
end)

-- Öppna event-GUI
pcall(function()
	game:GetService("Players").LocalPlayer.PlayerGui.UI.Event_UI.Visible = true
end)

-- Öppna Pet-shop (via modul)
pcall(function()
	require(game.ReplicatedStorage.Modules.ActivePetsUIController).open()
end)

-- Öppna Fertilizer-shop
pcall(function()
	require(game.ReplicatedStorage.Modules.FertilizerShopController).open()
end)

-- Öppna Tool-shop
pcall(function()
	require(game.ReplicatedStorage.Modules.ToolShopController).open()
end)

print("[✅] Alla shops och menyer är nu synliga.")
