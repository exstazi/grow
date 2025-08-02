local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ShopGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0.5, -110, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Text = "📦 Shopmeny"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local options = {
	{"🌱 Seed Shop", function()
		pcall(function()
			player.PlayerGui.UI.Seed_Shop.Main.Visible = true
		end)
	end},
	{"💰 Sell", function()
		pcall(function()
			player.PlayerGui.UI.SellPrompt.Visible = true
		end)
	end},
	{"⚒ Tool Shop", function()
		pcall(function()
			require(game.ReplicatedStorage.Modules.ToolShopController).open()
		end)
	end},
	{"🧪 Fertilizer", function()
		pcall(function()
			require(game.ReplicatedStorage.Modules.FertilizerShopController).open()
		end)
	end},
	{"🐾 Pet Shop", function()
		pcall(function()
			require(game.ReplicatedStorage.Modules.ActivePetsUIController).open()
		end)
	end},
	{"📜 Quest", function()
		pcall(function()
			player.PlayerGui.UI.QuestUI.Visible = true
		end)
	end},
	{"🎉 Event", function()
		pcall(function()
			player.PlayerGui.UI.Event_UI.Visible = true
		end)
	end}
}

for i, opt in ipairs(options) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 32)
	btn.Position = UDim2.new(0, 10, 0, 35 + (i - 1) * 38)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.Text = opt[1]
	btn.MouseButton1Click:Connect(opt[2])
end
