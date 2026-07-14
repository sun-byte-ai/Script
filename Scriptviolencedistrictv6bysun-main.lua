-- =========================================================================
-- SURVIVAL ENGINE HUB - PHIÊN BẢN SỬA LỖI TOÀN DIỆN & CUSTOM STUDS
-- =========================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local UndergroundBunker = nil

-- Danh sách đen loại bỏ đồ nội thất sảnh
local FURNITURE_BLACKLIST = {"table", "desk", "chair", "shelf", "cabinet", "wardrobe", "bed", "dresser", "furniture", "prop", "sanh", "lobby", "bookcase"}

-- ==========================================
-- 1. GIAO DIỆN GUI CỔ ĐIỂN & THANH HỖ TRỢ
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClassicSurvivalHub_FixedFinal"
ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 235)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -117)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Kéo thả Frame
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.Width.Scale, startPos.Width.Offset + delta.X, startPos.Height.Scale, startPos.Height.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "  [💀] SURVIVAL HUB - FIXED & UPGRADE"
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local function CreateClassicButton(yPos, text, height)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, height or 40)
    btn.Position = UDim2.new(0.04, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.Code
    btn.TextSize = 12
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    btn.Parent = MainFrame
    return btn
end

local Btn1 = CreateClassicButton(45, "Button 1: Auto Dodge Killer", 35)

-- THANH HỖ TRỢ BUTTON 1: NHẬP SỐ KHOẢNG CÁCH KHỞI CHẠY KHẨN CẤP
local StudsInput = Instance.new("TextBox")
StudsInput.Size = UDim2.new(0.92, 0, 0, 25)
StudsInput.Position = UDim2.new(0.04, 0, 0, 85)
StudsInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StudsInput.TextColor3 = Color3.fromRGB(255, 170, 0)
StudsInput.Text = "" 
StudsInput.PlaceholderText = "nhập số 10-800" 
StudsInput.Font = Enum.Font.Code
StudsInput.TextSize = 12
StudsInput.BorderSizePixel = 1
StudsInput.BorderColor3 = Color3.fromRGB(100, 100, 100)
StudsInput.Parent = MainFrame

local Btn2 = CreateClassicButton(115, "Button 2: ESP Killer & Survive", 35)
local Btn3 = CreateClassicButton(155, "Button 3: ESP Machines (Zone Scan)", 35)

local States = { AutoDodge = false, ESPPlayers = false, ESPMachines = false, DodgeDistance = 48 }

StudsInput.FocusLost:Connect(function(enterPressed)
    local value = tonumber(StudsInput.Text)
    if value then
        value = math.clamp(value, 10, 800)
        States.DodgeDistance = value
        StudsInput.Text = tostring(value)
    else
        StudsInput.Text = ""
    end
end)

local function ToggleButton(btn, stateKey, baseText)
    States[stateKey] = not States[stateKey]
    if States[stateKey] then
        btn.Text = baseText .. " [ON]"
        btn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    else
        btn.Text = baseText .. " [OFF]"
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

-- ==========================================
-- 2. THUẬT TOÁN QUÉT VÀ HIỂN THỊ ĐỘC LẬP
-- ==========================================

local function FindActiveKiller()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            if char:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool") then return p end
            if p:GetAttribute("Role") == "Killer" or p:GetAttribute("Murderer") == true or p:GetAttribute("Beast") == true then return p end
            if p.Team and (string.find(string.lower(p.Team.Name), "killer") or string.find(string.lower(p.Team.Name), "murder")) then return p end
            if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChildOfClass("PointLight") then return p end
        end
    end
    return nil
end

-- Thuật toán quét máy cải tiến hoàn toàn mới
local function ScanMapMachines()
    local foundMachines = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local nameLower = string.lower(obj.Name)
            if string.find(nameLower, "generator") or string.find(nameLower, "may") or string.find(nameLower, "gen") or obj:FindFirstChildOfClass("ProximityPrompt") then
                local isFake = false
                for _, word in pairs(FURNITURE_BLACKLIST) do
                    if string.find(nameLower, word) then isFake = true; break end
                end
                if not isFake then
                    local targetModel = obj:IsA("BasePart") and obj.Parent:IsA("Model") and obj.Parent ~= Workspace and obj.Parent.Name ~= "Map" and obj.Parent or obj
                    if not table.find(foundMachines, targetModel) then
                        table.insert(foundMachines, targetModel)
                    end
                end
            end
        end
    end
    return foundMachines
end

local function DeployEmergencyBunker(currentPos)
    if UndergroundBunker and UndergroundBunker.Parent then UndergroundBunker:Destroy() end
    UndergroundBunker = Instance.new("Part")
    UndergroundBunker.Size = Vector3.new(18, 1, 18)
    UndergroundBunker.Position = currentPos - Vector3.new(0, 11, 0)
    UndergroundBunker.Anchored = true
    UndergroundBunker.Material = Enum.Material.Iron
    UndergroundBunker.Color = Color3.fromRGB(40, 40, 40)
    UndergroundBunker.Name = "Emergency_Bunker"
    UndergroundBunker.Parent = Workspace
    
    local barrier = Instance.new("Part")
    barrier.Size = Vector3.new(18, 5, 1)
    barrier.Position = UndergroundBunker.Position + Vector3.new(0, 2.5, 8.5)
    barrier.Anchored = true; barrier.Transparency = 1; barrier.Parent = UndergroundBunker
end

-- Hệ thống ESP động: Cập nhật dữ liệu thời gian thực thay vì xóa đè bừa bãi
local function ApplyHighlightESP(object, color, labelText, prefix)
    if not object then return end
    local hlName = prefix .. "Highlight"
    local bbName = prefix .. "Billboard"
    
    local highlight = object:FindFirstChild(hlName)
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = hlName
        highlight.Parent = object
    end
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.4
    
    if labelText then
        local billboard = object:FindFirstChild(bbName)
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = bbName
            billboard.Size = UDim2.new(0, 120, 0, 35)
            billboard.StudsOffset = Vector3.new(0, 4, 0)
            billboard.AlwaysOnTop = true
            
            local txt = Instance.new("TextLabel")
            txt.Name = "TextLabel"
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.Font = Enum.Font.Code
            txt.TextSize = 14
            txt.Parent = billboard
            
            billboard.Adornee = object:IsA("Model") and (object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")) or object
            billboard.Parent = object
        end
        billboard.TextLabel.Text = labelText
        billboard.TextLabel.TextColor3 = color
    end
end

local function RemoveHubESP(tagName)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == tagName then v:Destroy() end
    end
end

-- ==========================================
-- 3. XỬ LÝ HÀNH VI VÒNG LẶP HỆ THỐNG
-- ==========================================

-- [BUTTON 1]: AUTO DODGE (ĐÃ FIX PHÍA TRƯỚC MÁY & FILTER KHOẢNG CÁCH)
Btn1.MouseButton1Click:Connect(function()
    ToggleButton(Btn1, "AutoDodge", "Button 1: Auto Dodge Killer")
    task.spawn(function()
        while States.AutoDodge do
            task.wait(0.1)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local killerPlayer = FindActiveKiller()
                if killerPlayer and killerPlayer.Character and killerPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local myHRP = char.HumanoidRootPart
                    local killerHRP = killerPlayer.Character.HumanoidRootPart
                    local currentDistance = (myHRP.Position - killerHRP.Position).Magnitude
                    
                    if currentDistance <= States.DodgeDistance then
                        local allMachines = ScanMapMachines()
                        local targetedMachineCFrame = nil
                        
                        for _, machine in pairs(allMachines) do
                            local machineCFrame = machine:IsA("Model") and machine:GetPivot() or machine.CFrame
                            -- ĐIỀU KIỆN MỚI: Chỉ dịch chuyển tới máy cách Killer trên 110 Studs
                            if (machineCFrame.Position - killerHRP.Position).Magnitude >= 110 then
                                targetedMachineCFrame = machineCFrame
                                break
                            end
                        end
                        
                        if targetedMachineCFrame then
                            -- Dịch chuyển ra TRƯỚC mặt máy thay vì trên đầu để tránh kẹt lỗi hình học
                            myHRP.CFrame = targetedMachineCFrame * CFrame.new(0, 1.5, 4.5)
                            task.wait(0.4) 
                        else
                            DeployEmergencyBunker(myHRP.Position)
                            myHRP.CFrame = CFrame.new(UndergroundBunker.Position + Vector3.new(0, 3, 0))
                            task.wait(2.5)
                        end
                    end
                end
            end
        end
    end)
end)

-- [BUTTON 2]: ESP PLAYERS (ĐÃ FIX LỖI ẨN HIỆN)
Btn2.MouseButton1Click:Connect(function()
    ToggleButton(Btn2, "ESPPlayers", "Button 2: ESP Killer & Survive")
    if not States.ESPPlayers then
        RemoveHubESP("PlayerHighlight")
        RemoveHubESP("PlayerBillboard")
    else
        task.spawn(function()
            while States.ESPPlayers do
                task.wait(0.5)
                local currentKiller = FindActiveKiller()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if player == currentKiller then
                            ApplyHighlightESP(player.Character, Color3.fromRGB(255, 0, 0), "[🎯] KILLER", "Player")
                        else
                            ApplyHighlightESP(player.Character, Color3.fromRGB(0, 255, 100), "SURVIVOR", "Player")
                        end
                    end
                end
            end
        end)
    end
end)

-- [BUTTON 3]: ESP MÁY SỬA (ĐÃ FIX KHÔNG HIỂN THỊ)
Btn3.MouseButton1Click:Connect(function()
    ToggleButton(Btn3, "ESPMachines", "Button 3: ESP Machines (Zone Scan)")
    if not States.ESPMachines then
        RemoveHubESP("MachineHighlight")
        RemoveHubESP("MachineBillboard")
    else
        task.spawn(function()
            while States.ESPMachines do
                RemoveHubESP("MachineHighlight") 
                RemoveHubESP("MachineBillboard")
                
                local currentActiveMachines = ScanMapMachines()
                for _, machine in pairs(currentActiveMachines) do
                    ApplyHighlightESP(machine, Color3.fromRGB(255, 185, 0), "GENERATOR", "Machine")
                end
                task.wait(2.5)
            end
        end)
    end
end)
