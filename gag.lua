local buttons = {
	SeedButton = function()
		game.Players.LocalPlayer.PlayerGui.UI.Seed_Shop.Main.Visible = true
	end,
	SellButton = function()
		game.Players.LocalPlayer.PlayerGui.UI.SellPrompt.Visible = true
	end,
	ToolButton = function()
		require(game.ReplicatedStorage.Modules.ToolShopController).open()
	end,
	FertButton = function()
		require(game.ReplicatedStorage.Modules.FertilizerShopController).open()
	end,
	PetButton = function()
		require(game.ReplicatedStorage.Modules.ActivePetsUIController).open()
	end,
	QuestButton = function()
		game.Players.LocalPlayer.PlayerGui.UI.QuestUI.Visible = true
	end,
	EventButton = function()
		game.Players.LocalPlayer.PlayerGui.UI.Event_UI.Visible = true
	end,
}

for name, action in pairs(buttons) do
	local button = script.Parent:FindFirstChild(name)
	if button then
		button.MouseButton1Click:Connect(function()
			pcall(action)
		end)
	end
end
