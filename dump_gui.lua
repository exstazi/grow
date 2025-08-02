-- dump_gui.lua med felsökning och fallback
local token = "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"
local filename = "grow_a_garden_dump.lua"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Skapa GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DumpGui"

-- Dump-knapp
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 220, 0, 50)
button.Position = UDim2.new(0.5, -110, 0, 20)
button.Text = "DUMPA KOMMANDON"
button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Status-rad
local status = Instance.new("TextLabel", gui)
status.Size = UDim2.new(0, 350, 0, 30)
status.Position = UDim2.new(0.5, -175, 0, 80)
status.Text = "Redo"
status.TextScaled = true
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)

-- Resultatbox (syns bara vid fail)
local resultBox = Instance.new("TextBox", gui)
resultBox.Size = UDim2.new(0.9, 0, 0.6, 0)
resultBox.Position = UDim2.new(0.05, 0, 0.2, 0)
resultBox.Visible = false
resultBox.TextWrapped = true
resultBox.ClearTextOnFocus = false
resultBox.TextXAlignment = Enum.TextXAlignment.Left
resultBox.TextYAlignment = Enum.TextYAlignment.Top
resultBox.TextColor3 = Color3.new(1, 1, 1)
resultBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
resultBox.Font = Enum.Font.Code
resultBox.TextScaled = false
resultBox.TextSize = 16

-- Dump-funktion
local function doDump()
    button.Text = "DUMPAR..."
    button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    status.Text = "Samlar data..."

    local output = {}
    local added = {}

    -- 1. getgc konstansdump
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

    status.Text = "Samlar RemoteEvents & GUI..."

    -- 2. RemoteEvents, Buttons, Modules
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(output, "📡 " .. obj:GetFullName())
        elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
            table.insert(output, "🖱️ " .. obj:GetFullName())
        elseif obj:IsA("ModuleScript") then
            table.insert(output, "📚 " .. obj:GetFullName())
        end
    end

    local content = table.concat(output, "\n")

    status.Text = "Laddar upp till GitHub..."

    local data = {
        description = "Grow a Garden Dump med GUI",
        public = false,
        files = {
            [filename] = { content = content }
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

    if res and res.StatusCode == 201 then
        local link = HttpService:JSONDecode(res.Body).html_url
        button.Text = "KLAR! ✔"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        status.Text = "Gist skapad!"
        print("✅ Gist: " .. link)

        -- visa länk i en TextLabel
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(0.9, 0, 0, 30)
        label.Position = UDim2.new(0.05, 0, 0.85, 0)
        label.Text = link
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true
        label.BackgroundTransparency = 1
    else
        button.Text = "FEL!"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        status.Text = "Upload misslyckades – visar dump"

        resultBox.Visible = true
        resultBox.Text = content:sub(1, 10000) .. "\n\n[OBS: Gist-fail, detta är local dump]"
    end
end

button.MouseButton1Click:Connect(doDump)
