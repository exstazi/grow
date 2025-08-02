local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local box = Instance.new("TextBox", gui)
box.Size = UDim2.new(0.95,0,0.7,0)
box.Position = UDim2.new(0.025,0,0.2,0)
box.BackgroundColor3 = Color3.fromRGB(10,10,10)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextEditable = false
box.Text = "[📲] Klar. Tryck på DUMPA ALLT."

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0.6,0,0.08,0)
btn.Position = UDim2.new(0.2,0,0.05,0)
btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Text = "DUMPA ALLT"

btn.MouseButton1Click:Connect(function()
    btn.Text = "DUMPAR..."
    box.Text = "[⏳] Påbörjar dump...\n\n"
    task.wait(0.1)

    local success,failure=0,0
    local added={}

    -- Försök dumpa getgc + constants
    if getgc then
        box.Text ..= "[🧠] Dump av funktioner:\n"
        for _,f in pairs(getgc(true)) do
            if typeof(f)=="function" then
                local ok, const = pcall(getconstants, f)
                if ok and const then
                    success+=1
                    for _,c in pairs(const) do
                        if typeof(c)=="string" and not added[c] then
                            box.Text ..= c.."\n"
                            added[c]=true
                        end
                    end
                else
                    failure+=1
                end
                task.wait(0.001)
            end
        end
        box.Text ..= ("✅ Klart (Lyckades:%d, Misslyckades:%d)\n\n"):format(success,failure)
    else
        box.Text ..="[⚠️] getgc stöds ej i denna executor\n"
    end

    box.Text ..= "[📡] RemoteEvents & RemoteFunctions:\n"
    for _,obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            box.Text ..= obj.ClassName.." ➜ "..obj:GetFullName().."\n"
        end
        task.wait(0.001)
    end

    box.Text ..= "\n[🖱️] GUI-knappar:\n"
    for _,btn in pairs(game:GetDescendants()) do
        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
            box.Text ..= btn.ClassName.." ➜ "..btn:GetFullName().."\n"
        end
        task.wait(0.001)
    end

    box.Text ..="\n[📚] ModuleScripts:\n"
    for _,mod in pairs(game:GetDescendants()) do
        if mod:IsA("ModuleScript") then
            box.Text ..= mod.ClassName.." ➜ "..mod:GetFullName().."\n"
        end
        task.wait(0.001)
    end

    btn.Text = "KLAR ✔️"
end)
