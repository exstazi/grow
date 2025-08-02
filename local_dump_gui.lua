-- Enkel GUI-dump utan GitHub
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LocalDumpGui"

-- Dump-knapp
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 220, 0, 50)
button.Position = UDim2.new(0.5, -110, 0, 20)
button.Text = "DUMPA KOMMANDON"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Resultatbox
local resultBox = Instance.new("TextBox", gui)
resultBox.Size = UDim2.new(0.9, 0, 0.75, 0)
resultBox.Position = UDim2.new(0.05, 0, 0.15, 0)
resultBox.TextWrapped = true
resultBox.ClearTextOnFocus = false
resultBox.TextXAlignment = Enum.TextXAlignment.Left
resultBox.TextYAlignment = Enum.TextYAlignment.Top
resultBox.TextColor3 = Color3.new(1, 1, 1)
resultBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
resultBox.Font = Enum.Font.Code
resultBox.TextScaled = false
resultBox.TextSize = 16
resultBox.Text = "👆 Tryck på knappen för att dumpa kommandon"

-- Dump-funktion
local function doDump()
    button.Text = "DUMPAR..."
    button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    local output = {}
    local added = {}

    -- Konstanter från funktioner
    for _, f in pairs(getgc(true)) do
        if typeof(f) == "function" and not is_synapse_function(f) then
            local ok, const = pcall(getconstants, f)
            if ok then
                for _, c in pairs(const) do
                    if typeof(c) == "string" and not added[c] then
                        table.insert(output, "🧠 " .. c)
                        added[c] = true
                    end
                end
            end
        end
    end

    -- RemoteEvents, knappar, moduler
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(output, "📡 " .. obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            table.insert(output, "🖱️ " .. obj:GetFullName())
        elseif obj:IsA("ModuleScript") then
            table.insert(output, "📚 " .. obj:GetFullName())
        end
    end

    local result = table.concat(output, "\n")
    resultBox.Text = result:sub(1, 20000) -- Visa max 20 000 tecken
    button.Text = "KLAR ✔"
    button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

button.MouseButton1Click:Connect(doDump)
