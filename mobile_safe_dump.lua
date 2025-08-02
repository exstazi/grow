local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SafeMobileDump"

-- Knapp
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 220, 0, 50)
button.Position = UDim2.new(0.5, -110, 0, 20)
button.Text = "DUMPA TILL SKÄRM"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Dumpbox
local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.9, 0, 0.7, 0)
box.Position = UDim2.new(0.05, 0, 0.2, 0)
box.TextWrapped = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
box.Font = Enum.Font.Code
box.TextScaled = false
box.TextSize = 16
box.Text = "📲 Mobilkompatibel dump redo..."

box.TextEditable = false
box.MultiLine = true
box.RichText = false

-- Dumpfunktion utan getgc
local function log(text)
	box.Text = box.Text .. text .. "\n"
end

local function doDump()
	button.Text = "DUMPAR..."
	button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	box.Text = "[⏳] Startar enkel mobil-dump...\n"

	local count = 0

	for _, obj in pairs(game:GetDescendants()) do
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			count += 1
			log("📡 Remote: " .. obj:GetFullName())
		elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
			count += 1
			log("🖱️ Knapp: " .. obj:GetFullName())
		elseif obj:IsA("ModuleScript") then
			count += 1
			log("📚 Modul: " .. obj:GetFullName())
		end
		task.wait(0.002)
	end

	log("\n✅ KLART – " .. count .. " objekt hittade.")
	button.Text = "KLAR ✔"
	button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

button.MouseButton1Click:Connect(doDump)
