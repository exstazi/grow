
local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SuperDumpGui"
gui.ResetOnSpawn = false

local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.95, 0, 0.65, 0)
box.Position = UDim2.new(0.025, 0, 0.2, 0)
box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextEditable = false
box.TextYAlignment = Enum.TextYAlignment.Top
box.Text = "[🧠] Superdump redo – klicka för att börja"

local dumpBtn = Instance.new("TextButton", gui)
dumpBtn.Size = UDim2.new(0.6, 0, 0.08, 0)
dumpBtn.Position = UDim2.new(0.2, 0, 0.05, 0)
dumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dumpBtn.TextColor3 = Color3.new(1,1,1)
dumpBtn.TextScaled = true
dumpBtn.Font = Enum.Font.SourceSansBold
dumpBtn.Text = "SUPERDUMPA"

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0.15, 0, 0.05, 0)
toggle.Position = UDim2.new(0.82, 0, 0.9, 0)
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextScaled = true
toggle.Font = Enum.Font.SourceSans
toggle.Text = "🔽"

-- Toggle dump-ruta
local shown = true
toggle.MouseButton1Click:Connect(function()
    shown = not shown
    box.Visible = shown
    toggle.Text = shown and "🔽" or "🔼"
end)

-- Logg
local log = {}
local logLine = function(str)
    table.insert(log, str)
end

-- dump till GUI
local function updateBox()
    local maxLines = 100
    local view = {}
    for i = math.max(1, #log - maxLines + 1), #log do
        table.insert(view, log[i])
    end
    box.Text = table.concat(view, "\n")
end

-- Superdump
local function superDump()
    dumpBtn.Text = "DUMPAR..."
    logLine("[⏳] Startar superdump...")
    updateBox()
    task.wait(0.1)

    local count = 0
    local dumped = {}

    -- 1. Dumpa spelobjekt
    for _, obj in ipairs(game:GetDescendants()) do
        local c = obj.ClassName
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            logLine("📡 "..c.." ➜ "..obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            logLine("🖱️ "..c.." ➜ "..obj:GetFullName())
        elseif obj:IsA("ModuleScript") or obj:IsA("LocalScript") or obj:IsA("Script") then
            logLine("📚 "..c.." ➜ "..obj:GetFullName())
        elseif obj:IsA("Tool") or obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
            logLine("🧲 "..c.." ➜ "..obj:GetFullName())
        end
        count += 1
        if count % 200 == 0 then
            updateBox()
            task.wait(0.01)
        end
    end

    -- 2. Dumpa getgc-konstanter
    logLine("\n[🧠] getgc + getconstants börjar...")
    updateBox()

    local gcCount = 0
    for _, func in pairs(getgc(true)) do
        if typeof(func) == "function" and not is_synapse_function(func) then
            local ok, consts = pcall(getconstants, func)
            if ok and consts then
                for _, c in pairs(consts) do
                    if typeof(c) == "string" and not dumped[c] then
                        dumped[c] = true
                        logLine("🔎 " .. c)
                        gcCount += 1
                    end
                end
            end
        end
        if gcCount % 200 == 0 then
            updateBox()
            task.wait(0.01)
        end
    end

    logLine("\n✅ KLAR – "..#log.." rader totalt.")
    updateBox()
    writefile("superdump.txt", table.concat(log, "\n"))
    dumpBtn.Text = "KLAR ✔"
    dumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

dumpBtn.MouseButton1Click:Connect(superDump)
