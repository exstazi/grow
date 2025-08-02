local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MobileConsoleDump"

-- Knapp
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 220, 0, 50)
button.Position = UDim2.new(0.5, -110, 0, 20)
button.Text = "DUMPA TILL SKÄRM"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Ingame konsol (TextBox med scroll)
local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.9, 0, 0.7, 0)
box.Position = UDim2.new(0.05, 0, 0.2, 0)
box.TextWrapped = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextColor3 = Color3.new(1, 1, 1)
box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
box.Font = Enum.Font.Code
box.TextScaled = false
box.TextSize = 16
box.Text = "📲 Ingame-konsol redo...\n"

box.TextEditable = false
box.MultiLine = true
box.RichText = false

-- Dump-funktion
local function log(text)
	box.Text = box.Text .. text .. "\n"
end

local function doDump()
    button.Text = "DUMPAR..."
    button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    box.Text = "[⏳] Startar dump...\n"

    local added = {}
    local found = 0
    local failed = 0

    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and not is_synapse_function(f) then
            local ok, const = pcall(getconstants, f)
            if ok and const then
                for _, c in pairs(const) do
                    if typeof(c) == "string" and not added[c] then
                        found += 1
                        added[c] = true
                        log("🧠 " .. c)
                        task.wait(0.005) -- så det ritar ut gradvis
                    end
                end
            else
                failed += 1
            end
        end
    end

    log("\n✅ getgc klar: " .. found .. " strängar, " .. failed .. " funktioner misslyckades.\n")
    log("📡 Hittar RemoteEvents, knappar och moduler...\n")

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            log("📡 " .. obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            log("🖱️ " .. obj:GetFullName())
        elseif obj:IsA("ModuleScript") then
            log("📚 " .. obj:GetFullName())
        end
        task.wait(0.002)
    end

    log("\n🎉 Dumpen är klar! Du kan nu scrolla och kopiera i mobilen.")
    button.Text = "KLAR ✔"
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

button.MouseButton1Click:Connect(doDump)
