local player = game.Players.LocalPlayer

-- Skapa mobil-konsol GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MobilDumpConsole"

local dumpBox = Instance.new("TextBox", gui)
dumpBox.Size = UDim2.new(0.95, 0, 0.75, 0)
dumpBox.Position = UDim2.new(0.025, 0, 0.15, 0)
dumpBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
dumpBox.TextColor3 = Color3.new(1,1,1)
dumpBox.Font = Enum.Font.Code
dumpBox.TextSize = 14
dumpBox.ClearTextOnFocus = false
dumpBox.MultiLine = true
dumpBox.TextWrapped = true
dumpBox.TextEditable = false
dumpBox.TextYAlignment = Enum.TextYAlignment.Top
dumpBox.Text = "[🟢] Mobil dump-konsol redo. Klicka på DUMPA."

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0.5, 0, 0.08, 0)
button.Position = UDim2.new(0.25, 0, 0.05, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
button.TextColor3 = Color3.new(1,1,1)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Text = "DUMPA ALLT"

-- Mobil dump-funktion utan riskabla getgc()
local function dumpAll()
	button.Text = "DUMPAR..."
	button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	dumpBox.Text = "[⏳] Dump startad...\n\n"

	local count = 0

	-- RemoteEvents & RemoteFunctions
	dumpBox.Text ..= "[📡] Remotes:\n"
	for _, obj in pairs(game:GetDescendants()) do
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			dumpBox.Text ..= obj.ClassName.." ➜ "..obj:GetFullName().."\n"
			count += 1
		end
	end

	-- GUI-knappar
	dumpBox.Text ..= "\n[🖱️] Knappar:\n"
	for _, btn in pairs(game:GetDescendants()) do
		if btn:IsA("TextButton") or btn:IsA("ImageButton") then
			dumpBox.Text ..= btn.ClassName.." ➜ "..btn:GetFullName().."\n"
			count += 1
		end
	end

	-- ModuleScripts
	dumpBox.Text ..= "\n[📚] Moduler:\n"
	for _, mod in pairs(game:GetDescendants()) do
		if mod:IsA("ModuleScript") then
			dumpBox.Text ..= "Module ➜ "..mod:GetFullName().."\n"
			count += 1
		end
	end

	dumpBox.Text ..= "\n[✅] KLAR – "..count.." objekt dumpade."
	button.Text = "KLAR ✔️"
	button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

button.MouseButton1Click:Connect(dumpAll)
