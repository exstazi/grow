-- grow/local_dump_gui_safe.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SafeDumpGui"

-- Knapp
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 220, 0, 50)
button.Position = UDim2.new(0.5, -110, 0, 20)
button.Text = "DUMPA KOMMANDON"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Dump-ruta
local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.9, 0, 0.7, 0)
box.Position = UDim2.new(0.05, 0, 0.2, 0)
box.TextWrapped = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
box.Font = Enum.Font.Code
box.TextScaled = false
box.TextSize = 16
box.Text = "👆 Tryck på knappen för att dumpa kommandon"

-- Dump-funktion
local function doDump()
    button.Text = "DUMPAR..."
    button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    box.Text = "[⏳] Startar dump..."

    local output = {}
    local added = {}

    local success = 0
    local failed = 0

    -- Säkrare getgc
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" and not is_synapse_function(v) then
            local ok, const = pcall(getconstants, v)
            if ok and const then
                for _, c in pairs(const) do
                    if typeof(c) == "string" and not added[c] then
                        table.insert(output, "🧠 " .. c)
                        added[c] = true
                    end
                end
                success += 1
            else
                failed += 1
            end
        end
    end

    table.insert(output, "\n✅ getgc: " .. success .. " lyckades, " .. failed .. " misslyckades.\n")

    -- Remotes, knappar, moduler
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(output, "📡 " .. obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            table.insert(output, "🖱️ " .. obj:GetFullName())
        elseif obj:IsA("ModuleScript") then
            table.insert(output, "📚 " .. obj:GetFullName())
        end
    end

    -- Färdig
    local result = table.concat(output, "\n")
    box.Text = result:sub(1, 20000)
    button.Text = "KLAR ✔"
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

button.MouseButton1Click:Connect(doDump)
