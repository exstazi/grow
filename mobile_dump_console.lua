local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MobilDumpConsole"
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
dumpBox.Text = "[📲] Klar. Tryck på DUMPA ALLT."

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

-- Dumpfunktion
dumpButton.MouseButton1Click:Connect(function()
    dumpButton.Text = "DUMPAR..."
    dumpBox.Text = "[⏳] Startar dump...\n\n"
    task.wait(0.1)

    local count = 0

    local function log(txt)
        dumpBox.Text ..= txt.."\n"
        count += 1
        task.wait(0.001)
    end

    -- Remotes
    dumpBox.Text ..= "[📡] Remotes:\n"
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            log(obj.ClassName.." ➜ "..obj:GetFullName())
        end
    end

    -- Knappar
    dumpBox.Text ..= "\n[🖱️] GUI-knappar:\n"
    for _, btn in pairs(game:GetDescendants()) do
        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
            log(btn.ClassName.." ➜ "..btn:GetFullName())
        end
    end

    -- Moduler
    dumpBox.Text ..= "\n[📚] ModuleScripts:\n"
    for _, mod in pairs(game:GetDescendants()) do
        if mod:IsA("ModuleScript") then
            log("Module ➜ "..mod:GetFullName())
        end
    end

    -- Extra (ProximityPrompt, ClickDetector, Tools, Scripts)
    dumpBox.Text ..= "\n[🧲] Proximity/Tools/etc:\n"
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("Tool") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") or obj:IsA("LocalScript") or obj:IsA("Script") then
            log(obj.ClassName.." ➜ "..obj:GetFullName())
        end
    end

    dumpBox.Text ..= "\n[✅] KLAR – "..count.." objekt dumpade."
    dumpButton.Text = "KLAR ✔️"
    dumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end)
