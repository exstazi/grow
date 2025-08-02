local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "RotatingDumpGui"
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
box.Text = "[🚀] Rotations-dumper redo..."
box.Visible = true

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

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0.1, 0, 0.05, 0)
toggleBtn.Position = UDim2.new(0.9, 0, 0.87, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.Text = "🔽"

-- Logik
local guiLog, fullLog, lineCount, visible = {}, {}, 0, true
local fileIndex = 1

local function flushToNewFile()
    local fileName = "dump_" .. fileIndex .. ".txt"
    local content = table.concat(fullLog, "\n") .. "\n"
    if writefile then
        pcall(function() writefile(fileName, content) end)
        table.insert(guiLog, "[💾] Sparade: " .. fileName)
        if #guiLog > 300 then table.remove(guiLog, 1) end
        box.Text = table.concat(guiLog, "\n")
    end
    fullLog = {}
    fileIndex += 1
end

local function add(txt)
    lineCount += 1
    table.insert(fullLog, txt)
    table.insert(guiLog, txt)
    if #guiLog > 300 then table.remove(guiLog, 1) end
    box.Text = table.concat(guiLog, "\n")
    if lineCount % 1000 == 0 then flushToNewFile() end
end

toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    box.Visible = visible
    toggleBtn.Text = visible and "🔽" or "🔼"
end)

-- Dump
dumpBtn.MouseButton1Click:Connect(function()
    dumpBtn.Text = "⏳ Dumpar..."
    add("[🧠] Startar getgc-dump...")

    local count = 0
    local dumped = {}

    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and not is_synapse_function(f) then
            local ok, consts = pcall(getconstants, f)
            if ok then
                local infoOk, info = pcall(debug.getinfo, f)
                if infoOk and info and info.source then
                    add("📄 [" .. (info.short_src or info.source) .. "]")
                end
                for _, c in pairs(consts) do
                    if typeof(c) == "string" and not dumped[c] then
                        dumped[c] = true
                        add("🧠 " .. c)
                        count += 1
                        if count % 50 == 0 then
                            add("🔄 Antal: " .. count)
                            task.wait(0.01)
                        end
                    end
                end
            end
        end
    end

    add("[✅] Klar – totalt " .. count .. " rader")
    flushToNewFile()
    dumpBtn.Text = "KLAR ✔"
end)

-- RemoteSpy
local originalNamecall
spyBtn.MouseButton1Click:Connect(function()
    local spying = false
    spying = not spying
    spyBtn.Text = spying and "🛑 Stoppa" or "🕵️ Spion"
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
                add("["..method.."] " .. self:GetFullName() .. "(" .. argDump .. ")")
            end
            return originalNamecall(self, ...)
        end)
    end
end)
