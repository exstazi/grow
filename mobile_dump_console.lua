local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SafeDumpGui"
gui.ResetOnSpawn = false

local dumpBox = Instance.new("TextBox", gui)
dumpBox.Size = UDim2.new(0.95, 0, 0.65, 0)
dumpBox.Position = UDim2.new(0.025, 0, 0.2, 0)
dumpBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
dumpBox.TextColor3 = Color3.new(1,1,1)
dumpBox.Font = Enum.Font.Code
dumpBox.TextSize = 14
dumpBox.ClearTextOnFocus = false
dumpBox.MultiLine = true
dumpBox.TextWrapped = true
dumpBox.TextEditable = false
dumpBox.TextYAlignment = Enum.TextYAlignment.Top
dumpBox.Text = "[📲] Tryck på DUMPA ALLT."
dumpBox.Visible = true

local dumpButton = Instance.new("TextButton", gui)
dumpButton.Size = UDim2.new(0.6, 0, 0.08, 0)
dumpButton.Position = UDim2.new(0.2, 0, 0.05, 0)
dumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dumpButton.TextColor3 = Color3.new(1,1,1)
dumpButton.TextScaled = true
dumpButton.Font = Enum.Font.SourceSansBold
dumpButton.Text = "DUMPA ALLT"

local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0.15, 0, 0.05, 0)
toggleButton.Position = UDim2.new(0.82, 0, 0.9, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Text = "🔽"

-- Toggle-funktion
local shown = true
toggleButton.MouseButton1Click:Connect(function()
    shown = not shown
    dumpBox.Visible = shown
    toggleButton.Text = shown and "🔽" or "🔼"
end)

-- Dumpfunktion med skrivning till dump.txt
local function logInit()
    writefile("dump.txt", "[📲] Startar dump...\n\n")
end

local lineCount = 0
local logText = ""

local function logLine(text)
    lineCount += 1
    logText ..= text .. "\n"

    -- Skriv till dump.txt varje 100:e rad
    if lineCount % 100 == 0 then
        writefile("dump.txt", logText)
    end

    -- Visa bara senaste 100 rader i GUI
    local lines = string.split(logText, "\n")
    local recent = {}
    for i = math.max(1, #lines - 100), #lines do
        table.insert(recent, lines[i])
    end
    dumpBox.Text = table.concat(recent, "\n")
end

-- Start dump
dumpButton.MouseButton1Click:Connect(function()
    dumpButton.Text = "DUMPAR..."
    dumpBox.Text = "[⏳] Påbörjar dump..."
    logInit()

    local count = 0

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            logLine("📡 "..obj.ClassName.." ➜ "..obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            logLine("🖱️ "..obj.ClassName.." ➜ "..obj:GetFullName())
        elseif obj:IsA("ModuleScript") then
            logLine("📚 Module ➜ "..obj:GetFullName())
        elseif obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("Tool") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") or obj:IsA("LocalScript") or obj:IsA("Script") then
            logLine("🧲 "..obj.ClassName.." ➜ "..obj:GetFullName())
        end
        task.wait(0.001)
        count += 1
    end

    writefile("dump.txt", logText)
    logLine("\n✅ KLAR – "..count.." objekt dumpade.")
    dumpButton.Text = "KLAR ✔️"
    dumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end)
