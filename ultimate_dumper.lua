local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SuperDumpGUI"
gui.ResetOnSpawn = false

local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.95, 0, 0.5, 0)
box.Position = UDim2.new(0.025, 0, 0.25, 0)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextEditable = false
box.TextYAlignment = Enum.TextYAlignment.Top
box.Text = "[🚀] SUPERDUMP laddad – redo..."
box.Visible = true
box.ZIndex = 2

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0.08, 0, 0.05, 0)
toggleBtn.Position = UDim2.new(0.91, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Text = "🔽"
toggleBtn.ZIndex = 3

local dumpBtn = Instance.new("TextButton", gui)
dumpBtn.Size = UDim2.new(0.3, 0, 0.06, 0)
dumpBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
dumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dumpBtn.TextColor3 = Color3.new(1, 1, 1)
dumpBtn.TextScaled = true
dumpBtn.Font = Enum.Font.SourceSansBold
dumpBtn.Text = "📦 Dumpa"
dumpBtn.ZIndex = 2

local saveBtn = Instance.new("TextButton", gui)
saveBtn.Size = UDim2.new(0.3, 0, 0.06, 0)
saveBtn.Position = UDim2.new(0.36, 0, 0.05, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.Text = "💾 Spara"
saveBtn.ZIndex = 2

-- Logg
local log = {}
local visible = true

local function add(txt)
    table.insert(log, txt)
    local view = log[#log - 250] and table.concat(log, "\n", #log - 250) or table.concat(log, "\n")
    box.Text = view
end

toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    box.Visible = visible
    toggleBtn.Text = visible and "🔽" or "🔼"
end)

saveBtn.MouseButton1Click:Connect(function()
    if writefile then
        pcall(function()
            writefile("superdump.txt", table.concat(log, "\n"))
            add("[💾] Sparad till superdump.txt")
        end)
    else
        add("[❌] writefile saknas i executor")
    end
end)

dumpBtn.MouseButton1Click:Connect(function()
    dumpBtn.Text = "⏳..."
    add("[🔍] Börjar getgc + objekt-dump...")

    -- game:GetDescendants
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableFunction") or obj:IsA("BindableEvent") or obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            add("📦 " .. obj.ClassName .. " ➜ " .. obj:GetFullName())
        end
    end

    -- getgc
    local count = 0
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and not isexecutorclosure(f) then
            local ok, consts = pcall(getconstants, f)
            if ok then
                for _, c in pairs(consts) do
                    if typeof(c) == "string" and #c < 200 then
                        add("🧠 " .. c)
                        count += 1
                        if count % 50 == 0 then
                            add("🔄 "..count.." konstanter...")
                            task.wait(0.01)
                        end
                    end
                end
            end
        end
    end

    add("[✅] SUPERDUMP KLAR – Totalt: "..count.." konstanter")
    dumpBtn.Text = "KLAR ✔"
end)
