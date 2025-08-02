local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ShopMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0.5, -110, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Text = "📦 Shopmeny"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local function safeCall(fn)
	local s, e = pcall(fn)
	if not s then warn("[⚠️] Misslyckades:", e) end
end

local function shopBtn(label, callback)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, -20, 0, 32)
	b.Position = UDim2.new(0, 10, 0, 35 + #frame:GetChildren() * 36)
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.SourceSans
	b.TextSize = 18
	b.Text = label
	b.MouseButton1Click:Connect(callback)
end

-- Buttons
shopBtn("🌱 Seed Shop", function()
	safeCall(function()
		local ui = player.PlayerGui:WaitForChild("UI")
		local shop = ui:FindFirstChild("Seed_Shop", true)
		if shop then
			shop.Main.Visible = true
		end
	end)
end)

shopBtn("💰 Sell Prompt", function()
	safeCall(function()
		local ui = player.PlayerGui:WaitForChild("UI")
		local sell = ui:FindFirstChild("SellPrompt", true)
		if sell then sell.Visible = true end
	end)
end)

shopBtn("⚒ Tool Shop", function()
	safeCall(function()
		require(game.ReplicatedStorage.Modules:WaitForChild("ToolShopController")).open()
	end)
end)

shopBtn("🧪 Fertilizer Shop", function()
	safeCall(function()
		require(game.ReplicatedStorage.Modules:WaitForChild("FertilizerShopController")).open()
	end)
end)

shopBtn("🐾 Pet Shop", function()
	safeCall(function()
		require(game.ReplicatedStorage.Modules:WaitForChild("ActivePetsUIController")).open()
	end)
end)

shopBtn("📜 Quest", function()
	safeCall(function()
		local ui = player.PlayerGui:WaitForChild("UI")
		local q = ui:FindFirstChild("QuestUI", true)
		if q then q.Visible = true end
	end)
end)

shopBtn("🎉 Event", function()
	safeCall(function()
		local ui = player.PlayerGui:WaitForChild("UI")
		local ev = ui:FindFirstChild("Event_UI", true)
		if ev then ev.Visible = true end
	end)
end)
