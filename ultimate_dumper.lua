local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ComboDumperMemorySafe"
gui.ResetOnSpawn = false

local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.95, 0, 0.55, 0)
box.Position = UDim2.new(0.025, 0, 0.25, 0)
box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextEditable = false
box.TextYAlignment = Enum.TextYAlignment.Top
box.Text = "[🚀] Kombo-Dumper (memory safe)..."
box.Visible = false

-- Räknare
local counterLabel = Instance.new("TextLabel", gui)
counterLabel.Size = UDim2.new(0.9, 0, 0.06, 0)
counterLabel.Position = UDim2.new(0.05, 0, 0.83, 0)
counterLabel.BackgroundTransparency = 1
counterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
counterLabel.TextScaled = true
counterLabel.Font = Enum.Font.SourceSansBold
counterLabel.Text = ""
counterLabel.Visible = false

-- Knappar
local dumpBtn = Instance.new("TextButton", gui)
dumpBtn.Size = UDim2.new(0.28, 0, 0.06, 0)
dumpBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
dumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dumpBtn.TextColor3 = Color3.new(1, 1, 1)
dumpBtn.TextScaled = true
dumpBtn.Font = Enum.Font.SourceSansBold
dumpBtn.Text = "📦 Dumpa"

local spyBtn = Instance.new("TextButton", gui)
spyBtn.Size = UDim2.new(0.28, 0, 0.06, 0)
spyBtn.Position = UDim2.new(0.36, 0, 0.05, 0)
spyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spyBtn.TextColor3 = Color3.new(1, 1, 1)
spyBtn.TextScaled = true
spyBtn.Font = Enum.Font.SourceSansBold
spyBtn.Text = "🕵️ Spion"

local saveBtn = Instance.new("TextButton", gui)
saveBtn.Size = UDim2.new(0.28, 0, 0.06, 0)
saveBtn.Position = UDim2.new(0.67, 0, 0.05, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.Text = "💾 Spara"

-- Tillfällig batch-logg
local logBuffer, lineCount, spying = {}, 0, false

local function flushBuffer()
    if writefile and #logBuffer > 0 then
        local chunk = table.concat(logBuffer, "\n") .. "\n"
        appendfile("dump.txt", chunk)
        logBuffer = {}
    end
end

local function add(txt)
    lineCount += 1
    table.insert(logBuffer, txt)
    if #logBuffer >= 300 then
        flushBuffer()
    end
end

saveBtn.MouseButton1Click:Connect(function()
    flushBuffer()
    saveBtn.Text = "✔ Sparad"
    task.delay(2, function() saveBtn.Text = "💾 Spara" end)
end)

-- Dumpknapp med memory-optimering
dumpBtn.MouseButton1Click:Connect(function()
    dumpBtn.Text = "⏳..."
    box.Visible = false
    counterLabel.Visible = true
    counterLabel.Text = "🔄 Startar dump..."

    local count = 0
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and not is_synapse_function and not isexecutorclosure(f) then
            local ok, consts = pcall(getconstants, f)
            if ok then
                local infoOk, info = pcall(debug.getinfo, f)
                if infoOk and info and info.source then
                    add("📄 [" .. (info.short_src or info.source) .. "]")
                end
                for _, c in pairs(consts) do
                    if typeof(c) == "string" and #c < 200 then
                        add("🧠 " .. c)
                    end
                end
            end
            count += 1
            if count % 10 == 0 then
                counterLabel.Text = "🔄 Funktioner: " .. count
                task.wait(0.05)
            end
        end
    end

    -- Extra dump
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("Tool") then
            add("📦 " .. obj.ClassName .. " ➜ " .. obj:GetFullName())
        end
    end

    flushBuffer()
    counterLabel.Text = "✅ Dump klar – " .. count .. " funktioner"
    dumpBtn.Text = "Klar ✔"
end)

-- Spy med GUI-logg
local box = box
local originalNamecall
spyBtn.MouseButton1Click:Connect(function()
    spying = not spying
    spyBtn.Text = spying and "🛑 Stoppa" or "🕵️ Spion"
    box.Visible = spying
    counterLabel.Visible = not spying
    if spying and not originalNamecall then
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if spying and (method == "FireServer" or method == "InvokeServer") then
                local argDump = ""
                for i,v in ipairs(args) do
                    if typeof(v) == "string" then
                        argDump ..= "\""..v.."\""
                    elseif typeof(v) == "Instance" then
                        argDump ..= v:GetFullName()
                    else
                        argDump ..= tostring(v)
                    end
                    if i < #args then argDump ..= ", " end
                end
                local line = "["..method.."] " .. self:GetFullName() .. "(" .. argDump .. ")"
                table.insert(logBuffer, line)
                if spying then
                    box.Text = (box.Text .. "\n" .. line):sub(-4000)
                end
            end
            return originalNamecall(self, ...)
        end)
    end
end)
