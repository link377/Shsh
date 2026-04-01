-- GIAO DIỆN & LOGIC SCRIPT BỞI GEMINI
local player = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

-- Cài đặt mặc định
local _KEY = "linhpro" -- BẠN CÓ THỂ ĐỔI KEY Ở ĐÂY
local auraEnabled = false
local auraRadius = 15
local pushForce = 1500

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LinhDepTraiMenu"
ScreenGui.Parent = coreGui or player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true -- Hỗ trợ kéo thả mượt

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "✨ linh đẹptrai ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- MENU NHẬP KEY
local KeyMenu = Instance.new("Frame")
KeyMenu.Size = UDim2.new(1, 0, 1, -30)
KeyMenu.Position = UDim2.new(0, 0, 0, 30)
KeyMenu.BackgroundTransparency = 1
KeyMenu.Parent = MainFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.Position = UDim2.new(0.1, 0, 0.2, 0)
KeyInput.PlaceholderText = "Nhập Key vào đây..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.fromRGB(255,255,255)
KeyInput.Parent = KeyMenu

local CheckBox = Instance.new("TextButton")
CheckBox.Size = UDim2.new(0.5, 0, 0, 35)
CheckBox.Position = UDim2.new(0.25, 0, 0.6, 0)
CheckBox.Text = "XÁC NHẬN"
CheckBox.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CheckBox.TextColor3 = Color3.fromRGB(255,255,255)
CheckBox.Font = Enum.Font.GothamBold
CheckBox.Parent = KeyMenu

-- MENU CHÍNH (Ẩn lúc đầu)
local ContentMenu = Instance.new("Frame")
ContentMenu.Size = UDim2.new(1, 0, 1, -30)
ContentMenu.Position = UDim2.new(0, 0, 0, 30)
ContentMenu.BackgroundTransparency = 1
ContentMenu.Visible = false
ContentMenu.Parent = MainFrame

local ToggleAura = Instance.new("TextButton")
ToggleAura.Size = UDim2.new(0.8, 0, 0, 35)
ToggleAura.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleAura.Text = "BẬT VÒNG ĐẨY ZOMBIE: TẮT"
ToggleAura.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleAura.TextColor3 = Color3.fromRGB(255,255,255)
ToggleAura.Font = Enum.Font.GothamBold
ToggleAura.Parent = ContentMenu

local SizeInput = Instance.new("TextBox")
SizeInput.Size = UDim2.new(0.8, 0, 0, 25)
SizeInput.Position = UDim2.new(0.1, 0, 0.45, 0)
SizeInput.PlaceholderText = "Độ rộng vòng (Mặc định: 15)"
SizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SizeInput.TextColor3 = Color3.fromRGB(255,255,255)
SizeInput.Parent = ContentMenu

local ForceInput = Instance.new("TextBox")
ForceInput.Size = UDim2.new(0.8, 0, 0, 25)
ForceInput.Position = UDim2.new(0.1, 0, 0.7, 0)
ForceInput.PlaceholderText = "Lực đẩy (Mặc định: 1500)"
ForceInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ForceInput.TextColor3 = Color3.fromRGB(255,255,255)
ForceInput.Parent = ContentMenu

-- XỬ LÝ NHẬP KEY
CheckBox.MouseButton1Click:Connect(function()
    if KeyInput.Text == _KEY then
        KeyMenu.Visible = false
        ContentMenu.Visible = true
    else
        KeyInput.Text = "Sai Key!"
        wait(1)
        KeyInput.Text = ""
    end
end)

-- VÒNG HITBOX (VISUAL)
local circle = Instance.new("Part")
circle.Shape = Enum.PartType.Cylinder
circle.Orientation = Vector3.new(0, 0, 90)
circle.Transparency = 0.6
circle.BrickColor = BrickColor.new("Really red")
circle.Material = Enum.Material.ForceField
circle.CanCollide = false
circle.Anchored = true
circle.Parent = workspace

-- XỬ LÝ MENU
ToggleAura.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    if auraEnabled then
        ToggleAura.Text = "BẬT VÒNG ĐẨY ZOMBIE: BẬT"
        ToggleAura.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ToggleAura.Text = "BẬT VÒNG ĐẨY ZOMBIE: TẮT"
        ToggleAura.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        circle.Position = Vector3.new(0, -1000, 0) -- Giấu vòng đi
    end
end)

SizeInput.FocusLost:Connect(function()
    local val = tonumber(SizeInput.Text)
    if val then auraRadius = val end
end)

ForceInput.FocusLost:Connect(function()
    local val = tonumber(ForceInput.Text)
    if val then pushForce = val end
end)

-- LOGIC ĐẨY ZOMBIE 💀
rs.Heartbeat:Connect(function()
    if not auraEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = player.Character.HumanoidRootPart
    
    -- Cập nhật vị trí vòng
    circle.Size = Vector3.new(1, auraRadius * 2, auraRadius * 2)
    circle.Position = root.Position - Vector3.new(0, 2.5, 0)

    -- Quét tất cả quái/zombie xung quanh
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= player.Character then
            local enemyHumanoid = obj:FindFirstChildOfClass("Humanoid")
            local enemyRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            
            -- Đảm bảo đây là NPC (không phải Player khác) và còn sống
            if enemyHumanoid and enemyRoot and enemyHumanoid.Health > 0 and not game.Players:GetPlayerFromCharacter(obj) then
                local dist = (enemyRoot.Position - root.Position).Magnitude
                
                -- Nếu lọt vào vòng tròn
                if dist <= auraRadius then
                    -- Tính toán hướng đẩy và ném văng lên trời + ra xa
                    local direction = (enemyRoot.Position - root.Position).Unit
                    enemyRoot.AssemblyLinearVelocity = (direction * pushForce) + Vector3.new(0, pushForce * 0.5, 0)
                    
                    -- Cướp quyền đứng vững của Zombie
                    enemyHumanoid.PlatformStand = true
                    task.delay(1, function()
                        if enemyHumanoid then enemyHumanoid.PlatformStand = false end
                    end)
                end
            end
        end
    end
end)
