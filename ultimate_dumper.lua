
local player = game.Players.LocalPlayer

-- GUI-setup
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "UltimateDumper"
gui.ResetOnSpawn = false

local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.95, 0, 0.65, 0)
box.Position = UDim2.new(0.025, 0, 0.2, 0)
box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextEditable = false
box.TextYAlignment = Enum.TextYAlignment.Top
box.Text = "[🚀] Ultimate Dumper aktiv..."

local dumpButton = Instance.new("TextButton", gui)
dumpButton.Size = UDim2.new(0.45, 0, 0.08, 0)
dumpButton.Position = UDim2.new(0.05, 0, 0.05, 0)
dumpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dumpButton.TextColor3 = Color3.new(1, 1, 1)
dumpButton.TextScaled = true
dumpButton.Font = Enum.Font.SourceSansBold
dumpButton.Text = "📦 DUMPA ALLT"

local spyButton = Instance.new("TextButton", gui)
spyButton.Size = UDim2.new(0.45, 0, 0.08, 0)
spyButton.Position = UDim2.new(0.5, 0, 0.05, 0)
spyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spyButton.TextColor3 = Color3.new(1, 1, 1)
spyButton.TextScaled = true
spyButton.Font = Enum.Font.SourceSansBold
spyButton.Text = "🕵️ SPION PÅ"

local log = {}
local lineCount = 0
local spying = false

local function add(txt)
    lineCount += 1
    table.insert(log, txt)
    if #log > 300 then table.remove(log, 1) end
    box.Text = table.concat(log, "\n")
    if writefile and lineCount % 100 == 0 then
        pcall(function()
            writefile("dump.txt", table.concat(log, "\n"))
        end)
    end
end

-- getgc + debuginfo + getconstants
dumpButton.MouseButton1Click:Connect(function()
    dumpButton.Text = "DUMPAR..."
    add("[🧠] Startar djupdump med getgc...")

    local count = 0
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and not is_synapse_function and not isexecutorclosure(f) then
            local ok, consts = pcall(getconstants, f)
            if ok then
                local info = pcall(function()
                    local i = debug.getinfo(f)
                    if i and i.source then
                        add("📄 [" .. (i.short_src or i.source) .. "]")
                    end
                end)
                for _, c in pairs(consts) do
                    if typeof(c) == "string" and #c < 200 then
                        add("🧠 " .. c)
                    end
                end
                count += 1
                if count % 100 == 0 then task.wait(0.1) end
            end
        end
    end
    add("[✅] Djupdump klar.")
    dumpButton.Text = "KLAR ✔"
end)

-- namecall hook
local originalNamecall
spyButton.MouseButton1Click:Connect(function()
    spying = not spying
    spyButton.Text = spying and "🛑 STOPPA" or "🕵️ SPION PÅ"
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
                add(line)
            end
            return originalNamecall(self, ...)
        end)
    end
end)
