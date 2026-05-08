-- [[ KAIDO XIT V1 | THE MASTER SCRIPT ]]
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = game.Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- 1. زر الصورة الشخصية (Toggle)
local ToggleImage = Instance.new("ImageButton", ScreenGui)
ToggleImage.Size = UDim2.new(0, 60, 0, 60)
ToggleImage.Position = UDim2.new(0, 10, 0.4, 0)
ToggleImage.Image = "rbxassetid://121111539317250"
ToggleImage.BackgroundTransparency = 1
Instance.new("UICorner", ToggleImage).CornerRadius = UDim.new(1, 0)
ToggleImage.Draggable = true

-- 2. القائمة الرئيسية
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- عنوان السكربت في الأعلى
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "KAIDO XIT V1"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- تأثير RGB للإطار
task.spawn(function()
    while task.wait() do
        MainFrame.BorderColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -10, 1, -60)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 6, 0) 
Container.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 5)

ToggleImage.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

function AddBtn(txt, color, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Text = txt
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

function AddSlider(txt, min, max, default, callback)
    local box = Instance.new("TextBox", Container)
    box.Size = UDim2.new(1, -10, 0, 35)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = txt .. ": " .. default
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text:match("%d+")) or default
        val = math.clamp(val, min, max)
        box.Text = txt .. ": " .. val
        callback(val)
    end)
end

--- [[ تفعيل المميزات ]] ---

local flySpeed = 100
AddSlider("Fly Speed", 10, 500, 100, function(v) flySpeed = v end)
AddSlider("Walk Speed", 16, 500, 16, function(v) hum.WalkSpeed = v end)
AddSlider("Jump Power", 50, 500, 50, function(v) hum.JumpPower = v end)

AddBtn("طيران", Color3.fromRGB(0, 120, 255), function()
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                hum.PlatformStand = true
                bv.Velocity = camera.CFrame.LookVector * flySpeed
                bg.CFrame = camera.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
                task.wait()
            end
            if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
            hum.PlatformStand = false
        end)
    end
end)

AddBtn("تكبير هيتبوكس (غيرتها عشانك يا جعفر)", Color3.fromRGB(100, 0, 200), function()
    _G.HB_Enabled = true
    task.spawn(function()
        while _G.HB_Enabled do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                end
            end
            task.wait(1)
        end
    end)
end)

AddBtn("🎯 تتبع الناس", Color3.fromRGB(200, 0, 0), function()
    _G.Aim = not _G.Aim
    task.spawn(function()
        while _G.Aim do
            local target = nil
            local dist = 500
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("Head") then
                    local mag = (v.Character.Head.Position - root.Position).magnitude
                    if mag < dist then dist = mag target = v end
                end
            end
            if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position) end
            task.wait()
        end
    end)
end)

AddBtn("🛡️ كشف ادمن", Color3.fromRGB(255, 150, 0), function()
    game.Players.PlayerAdded:Connect(function(plr)
        game.StarterGui:SetCore("SendNotification", {Title = "Admin Check", Text = plr.Name .. " joined!"})
    end)
end)

AddBtn("🌙 رؤية ليلية", Color3.fromRGB(0, 255, 100), function()
    nv = not nv
    game.Lighting.Brightness = nv and 3 or 1
    game.Lighting.OutdoorAmbient = nv and Color3.new(0, 1, 0) or Color3.new(0.5, 0.5, 0.5)
end)

AddBtn("كشف اماكن (همين غيرتها عشانك)", Color3.fromRGB(0, 150, 255), function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character then
            local h = Instance.new("Highlight", v.Character)
            h.FillTransparency = 0.5; h.OutlineColor = Color3.new(1, 1, 1)
        end
    end
end)

AddBtn("🧱 اختراق جدران", Color3.fromRGB(80, 80, 80), function()
    noclip = not noclip
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end)

AddBtn("🛑 EMERGENCY RESET", Color3.fromRGB(255, 0, 0), function()
    flying = false; _G.HB_Enabled = false; _G.Aim = false; noclip = false
    hum.WalkSpeed = 16; hum.JumpPower = 50; game.Lighting.Brightness = 1
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChildOfClass("Highlight") then v.Character:FindFirstChildOfClass("Highlight"):Destroy() end
    end
end)
