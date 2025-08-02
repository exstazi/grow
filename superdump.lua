
local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MobilDumpSecure"
gui.ResetOnSpawn = false

local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.95, 0, 0.6, 0)
box.Position = UDim2.new(0.025, 0, 0.2, 0)
box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextEditable = false
box.TextYAlignment = Enum.TextYAlignment.Top
box.Text = "[📲] Klar. Tryck på en knapp."

local dumpBtn = Instance.new("TextButton", gui)
dumpBtn.Size = UDim2.new(0.45, 0, 0.08, 0)
dumpBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
dumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dumpBtn.TextColor3 = Color3.new(1, 1, 1)
dumpBtn.TextScaled = true
dumpBtn.Font = Enum.Font.SourceSansBold
dumpBtn.Text = "DUMPA SÄKERT"

local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0.45, 0, 0.08, 0)
showBtn.Position = UDim2.new(0.5, 0, 0.05, 0)
showBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
showBtn.TextColor3 = Color3.new(1, 1, 1)
showBtn.TextScaled = true
showBtn.Font = Enum.Font.SourceSansBold
showBtn.Text = "📂 VISA DUMP.TXT"

local log = {}
local lineCount = 0

local function add(text)
    lineCount += 1
    table.insert(log, text)
    if #log > 300 then
        table.remove(log, 1)
    end
    box.Text = table.concat(log, "\n")

    if writefile and lineCount % 200 == 0 then
        pcall(function()
            writefile("dump.txt", table.concat(log, "\n"))
        end)
    end
end

dumpBtn.MouseButton1Click:Connect(function()
    dumpBtn.Text = "DUMPAR..."
    add("[⏳] Startar dump med skydd...")

    local okCount, failCount = 0, 0

    if getgc then
        for _, f in pairs(getgc(true)) do
            if typeof(f) == "function" then
                local ok, constants = pcall(getconstants, f)
                if ok and constants then
                    okCount += 1
                    for _, c in pairs(constants) do
                        if typeof(c) == "string" then
                            add("🧠 "..c)
                        end
                    end
                else
                    failCount += 1
                end
                if okCount % 100 == 0 then task.wait(0.1) end
            end
        end
        add("[✔] getgc klar. Lyckades: "..okCount.." | Misslyckades: "..failCount)
    else
        add("[⚠️] getgc saknas")
    end

    add("[📡] RemoteEvents & RemoteFunctions:")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            add("📡 "..obj:GetFullName())
        end
    end

    add("[🖱️] GUI-knappar:")
    for _, btn in pairs(game:GetDescendants()) do
        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
            add("🖱️ "..btn:GetFullName())
        end
    end

    add("[📚] ModuleScripts, Tools, Prompts:")
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ModuleScript") or obj:IsA("Tool") or obj:IsA("ProximityPrompt") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
            add("📦 "..obj:GetFullName())
        end
    end

    dumpBtn.Text = "KLAR ✔"
    dumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

    if writefile then
        pcall(function()
            writefile("dump.txt", table.concat(log, "\n"))
        end)
        add("[💾] Sparad till dump.txt")
    end
end)

-- VISAR INNEHÅLL FRÅN dump.txt
showBtn.MouseButton1Click:Connect(function()
    if readfile then
        local ok, content = pcall(readfile, "dump.txt")
        if ok and content then
            box.Text = "[📂] Innehåll från dump.txt:\n\n" .. content
        else
            box.Text = "[❌] Kunde inte läsa dump.txt"
        end
    else
        box.Text = "[⚠️] readfile stöds inte i denna executor."
    end
end)
