-- SEED SHOP
SeedButton.MouseButton1Click:Connect(function()
	pcall(function()
		game.Players.LocalPlayer.PlayerGui.UI.Seed_Shop.Main.Visible = true
	end)
end)

-- SELL PROMPT
SellButton.MouseButton1Click:Connect(function()
	pcall(function()
		game.Players.LocalPlayer.PlayerGui.UI.SellPrompt.Visible = true
	end)
end)

-- TOOL SHOP
ToolButton.MouseButton1Click:Connect(function()
	pcall(function()
		require(game.ReplicatedStorage.Modules.ToolShopController).open()
	end)
end)

-- FERTILIZER SHOP
FertButton.MouseButton1Click:Connect(function()
	pcall(function()
		require(game.ReplicatedStorage.Modules.FertilizerShopController).open()
	end)
end)

-- PET SHOP
PetButton.MouseButton1Click:Connect(function()
	pcall(function()
		require(game.ReplicatedStorage.Modules.ActivePetsUIController).open()
	end)
end)

-- QUEST
QuestButton.MouseButton1Click:Connect(function()
	pcall(function()
		game.Players.LocalPlayer.PlayerGui.UI.QuestUI.Visible = true
	end)
end)

-- EVENT
EventButton.MouseButton1Click:Connect(function()
	pcall(function()
		game.Players.LocalPlayer.PlayerGui.UI.Event_UI.Visible = true
	end)
end)
