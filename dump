-- grow/dump_gui.lua
local token = "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"
local filename = "grow_a_garden_dump.lua"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Skapa GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DumpGui"

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0, 20)
button.Text = "DUMPA KOMMANDON"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextScaled = true
button.BorderSizePixel = 0
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Dumpfunktion
local function doDump()
    button.Text = "DUMPAR..."
    button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

    local output = {}
    local added = {}

    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" and not is_synapse_function(v) then
            local ok, const = pcall(getconstants, v)
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

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(output, "📡 " .. obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            table.insert(output, "🖱️ " .. obj:GetFullName())
        elseif obj:IsA("ModuleScript") then
            table.insert(output, "📚 " .. obj:GetFullName())
        end
    end

    local data = {
        description = "Grow a Garden Dump via GUI",
        public = false,
        files = {
            [filename] = {
                content = table.concat(output, "\n")
            }
        }
    }

    local res = syn.request({
        Url = "https://api.github.com/gists",
        Method = "POST",
        Headers = {
            ["Authorization"] = "Bearer " .. token,
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })

    if res.StatusCode == 201 then
        local link = HttpService:JSONDecode(res.Body).html_url
        button.Text = "KLAR! ✔"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

        -- Visa länk i en TextLabel
        local label = Instance.new("TextLabel", screenGui)
        label.Size = UDim2.new(0, 350, 0, 30)
        label.Position = UDim2.new(0.5, -175, 0, 80)
        label.Text = "Dump skapad: " .. link
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
    else
        button.Text = "FEL!"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

button.MouseButton1Click:Connect(doDump)
