-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-----------------------------------------------------
-- CẤU HÌNH 7 NẤC TỐC ĐỘ (RÚT NGẮN THỜI GIAN & BẢO TOÀN HP)
-----------------------------------------------------
local SPEED_TIERS = {
    {
        Name = "SPEED GỐC",
        MinTime = 0,
        WalkSpeed = 16,
        ExtraCFrame = 0,
        Color = Color3.fromRGB(200, 200, 200),
        DamagePerSec = 0,
        FOV = 70,
        AuraOutline = Color3.fromRGB(150, 150, 150)
    },
    {
        Name = "KHÁ NHANH",
        MinTime = 1.5,
        WalkSpeed = 45,
        ExtraCFrame = 0,
        Color = Color3.fromRGB(0, 200, 255),
        DamagePerSec = 0,
        FOV = 78,
        AuraOutline = Color3.fromRGB(0, 150, 255)
    },
    {
        Name = "NHANH",
        MinTime = 3.5,
        WalkSpeed = 95,
        ExtraCFrame = 0,
        Color = Color3.fromRGB(255, 215, 0),
        DamagePerSec = 0, -- Có tỷ lệ ngẫu nhiên trừ máu nhẹ
        FOV = 88,
        AuraOutline = Color3.fromRGB(255, 180, 0)
    },
    {
        Name = "GẦN SIÊU NHANH",
        MinTime = 6.0,
        WalkSpeed = 190,
        ExtraCFrame = 0,
        Color = Color3.fromRGB(255, 120, 0),
        DamagePerSec = 2, -- Bắt đầu trừ máu nhẹ
        FOV = 98,
        AuraOutline = Color3.fromRGB(255, 80, 0)
    },
    {
        Name = "⚡ SIÊU NHANH ⚡",
        MinTime = 9.5,
        WalkSpeed = 380,
        ExtraCFrame = 120,
        Color = Color3.fromRGB(255, 30, 30),
        DamagePerSec = 5,
        FOV = 108,
        AuraOutline = Color3.fromRGB(200, 0, 0)
    },
    {
        Name = "🔥 CỰC NHANH 🔥",
        MinTime = 13.5,
        WalkSpeed = 500,
        ExtraCFrame = 550,
        Color = Color3.fromRGB(180, 0, 255),
        DamagePerSec = 9,
        FOV = 116,
        AuraOutline = Color3.fromRGB(120, 0, 200)
    },
    {
        Name = "💥 TỐC ĐỘ ÂM THANH 💥",
        MinTime = 18.0,
        WalkSpeed = 500,
        ExtraCFrame = 2400, -- Mach Speed
        Color = Color3.fromRGB(255, 255, 255),
        DamagePerSec = 14, -- Cho ~3-4s trải nghiệm đỉnh cao trước khi chạm giới hạn
        FOV = 125,
        AuraOutline = Color3.fromRGB(0, 255, 255)
    }
}

-----------------------------------------------------
-- HUD HIỂN THỊ CẤP ĐỘ
-----------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CinematicSpeedHUD"
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local HUDFrame = Instance.new("Frame")
HUDFrame.Size = UDim2.new(0, 360, 0, 55)
HUDFrame.Position = UDim2.new(0.5, -180, 0.84, 0)
HUDFrame.BackgroundTransparency = 1
HUDFrame.Parent = ScreenGui

local TierLabel = Instance.new("TextLabel")
TierLabel.Size = UDim2.new(1, 0, 0, 28)
TierLabel.Position = UDim2.new(0, 0, 0, 0)
TierLabel.BackgroundTransparency = 1
TierLabel.Text = "CẤP ĐỘ: SPEED GỐC"
TierLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TierLabel.TextSize = 16
TierLabel.Font = Enum.Font.GothamBold
TierLabel.Parent = HUDFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 26)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Trạng thái: An toàn"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = HUDFrame

-----------------------------------------------------
-- BIẾN TRẠNG THÁI & HỆ THỐNG
-----------------------------------------------------
local continuousRunTime = 0
local currentTierIndex = 1
local isRagdolled = false
local isTransitioning = false -- Khóa trạng thái khi đang Slow-mo Bùng nổ

local transitionTriggered = {
    [4] = false, -- Chuyển từ 3 -> 4 (Gần siêu nhanh)
    [7] = false  -- Chuyển từ 6 -> 7 (Tốc độ âm thanh)
}

local characterHighlight = nil
local speedParticles = nil

-----------------------------------------------------
-- TẠO VỆT AURA & TIA CHỚP
-----------------------------------------------------
local function setupVFX(character)
    if characterHighlight then characterHighlight:Destroy() end
    if speedParticles then speedParticles:Destroy() end

    characterHighlight = Instance.new("Highlight")
    characterHighlight.Name = "SpeedAura"
    characterHighlight.FillTransparency = 0.6
    characterHighlight.OutlineTransparency = 0.1
    characterHighlight.Parent = character

    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        speedParticles = Instance.new("ParticleEmitter")
        speedParticles.Name = "SpeedTrail"
        speedParticles.Texture = "rbxassetid://242202316"
        speedParticles.Rate = 0
        speedParticles.Speed = NumberRange.new(8, 20)
        speedParticles.Lifetime = NumberRange.new(0.15, 0.4)
        speedParticles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.2), NumberSequenceKeypoint.new(1, 0)})
        speedParticles.Parent = hrp
    end
end

-----------------------------------------------------
-- HIỆU ỨNG CINEMATIC SLOW-MO & BÙNG NỔ (BOOM EFFECT)
-----------------------------------------------------
local function playCinematicTransition(character, humanoid, targetTier)
    isTransitioning = true

    -- 1. PHASE SLOW-MO (Khựng thời gian & Miễn nhiễm sát thương)
    humanoid.WalkSpeed = 8
    StatusLabel.Text = "✨ ĐANG TÍCH TỤ NĂNG LƯỢNG..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)

    -- Thu hẹp Camera (Zoom-in)
    TweenService:Create(Camera, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = 55}):Play()
    
    if characterHighlight then
        characterHighlight.FillColor = Color3.fromRGB(255, 255, 255)
        characterHighlight.FillTransparency = 0.1
    end

    task.wait(0.35) -- Thời gian khựng slow-mo đẹp mắt

    -- 2. PHASE BÙNG NỔ (BOOM)
    humanoid.WalkSpeed = targetTier.WalkSpeed
    
    -- Pop FOV & Rung Màn Hình
    Camera.FieldOfView = targetTier.FOV + 15
    TweenService:Create(Camera, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {FieldOfView = targetTier.FOV}):Play()

    if characterHighlight then
        characterHighlight.FillTransparency = 0.5
    end

    -- Flash hiệu ứng nổ
    for i = 1, 6 do
        Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(math.random(-2, 2)), math.rad(math.random(-2, 2)), 0)
        task.wait(0.01)
    end

    isTransitioning = false
end

-----------------------------------------------------
-- RAGDOLL KHI NGỪNG CHẠY Ở TỐC ĐỘ CAO
-----------------------------------------------------
local function triggerRagdollInertia(character, humanoid, hrp, tierIndex)
    isRagdolled = true
    humanoid.PlatformStand = true

    local forwardDir = hrp.CFrame.LookVector
    local pushForce = math.clamp(tierIndex * 40, 90, 280)
    hrp.AssemblyVelocity = forwardDir * pushForce + Vector3.new(0, 18, 0)

    for i = 1, 8 do
        Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(math.random(-3, 3)), math.rad(math.random(-3, 3)), 0)
        task.wait(0.02)
    end

    local recoveryTime = 1.2 + (tierIndex * 0.35)
    StatusLabel.Text = "⚠️ BỊ MẤT ĐÀ! ĐANG ĐỨNG DẬY (" .. string.format("%.1f", recoveryTime) .. "s)"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)

    task.wait(recoveryTime)

    humanoid.PlatformStand = false
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    isRagdolled = false
end

-----------------------------------------------------
-- VÒNG LẶP XỬ LÝ CHÍNH (HEARTBEAT)
-----------------------------------------------------
RunService.Heartbeat:Connect(function(deltaTime)
    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not humanoid or not hrp or humanoid.Health <= 0 then
        continuousRunTime = 0
        return
    end

    if not char:FindFirstChild("SpeedAura") then
        setupVFX(char)
    end

    local isMoving = humanoid.MoveDirection.Magnitude > 0 and not isRagdolled

    if isMoving then
        continuousRunTime = continuousRunTime + deltaTime

        -- Xác định Tier
        local activeTier = SPEED_TIERS[1]
        local activeIndex = 1

        for i = #SPEED_TIERS, 1, -1 do
            if continuousRunTime >= SPEED_TIERS[i].MinTime then
                activeTier = SPEED_TIERS[i]
                activeIndex = i
                break
            end
        end

        currentTierIndex = activeIndex

        -- KIỂM TRA PUSH TĂNG CẤP SLOW-MO BÙNG NỔ (Nấc 4 và Nấc 7)
        if (activeIndex == 4 and not transitionTriggered[4]) or (activeIndex == 7 and not transitionTriggered[7]) then
            transitionTriggered[activeIndex] = true
            task.spawn(function()
                playCinematicTransition(char, humanoid, activeTier)
            end)
        end

        -- Nếu đang trong hiệu ứng Slow-mo transition thì tạm bỏ qua các tính toán khác
        if isTransitioning then return end

        -- 1. Di chuyển WalkSpeed & CFrame
        humanoid.WalkSpeed = activeTier.WalkSpeed
        if activeTier.ExtraCFrame > 0 then
            local moveStep = humanoid.MoveDirection * (activeTier.ExtraCFrame * deltaTime)
            hrp.CFrame = hrp.CFrame + moveStep
        end

        -- 2. Xử lý Ma sát Trừ Máu (Cân bằng cho 100 HP)
        if activeTier.DamagePerSec > 0 then
            -- Mất máu cố định từ Nấc 4 trở lên
            humanoid:TakeDamage(activeTier.DamagePerSec * deltaTime)
            StatusLabel.Text = "⚠️ MA SÁT CAO - MẤT MÁU (" .. math.floor(humanoid.Health) .. " HP)"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        elseif activeIndex == 3 then
            -- Nấc 3 (Nhanh): Tỷ lệ ngẫu nhiên rất thấp (5% mỗi giây) bị trừ 1 HP
            if math.random(1, 100) <= 5 then
                humanoid:TakeDamage(1)
            end
            StatusLabel.Text = "Trạng thái: An toàn (Ma sát nhẹ)"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
        else
            StatusLabel.Text = "Trạng thái: An toàn"
            StatusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        end

        -- 3. Cập nhật Visual (Aura, Particles, Camera FOV)
        if characterHighlight then
            characterHighlight.FillColor = activeTier.Color
            characterHighlight.OutlineColor = activeTier.AuraOutline
        end

        if speedParticles then
            speedParticles.Rate = activeIndex * 18
            speedParticles.Color = ColorSequence.new(activeTier.Color)
        end

        TweenService:Create(Camera, TweenInfo.new(0.3), {FieldOfView = activeTier.FOV}):Play()

        -- 4. Cập nhật HUD
        TierLabel.Text = "CẤP ĐỘ: " .. activeTier.Name
        TierLabel.TextColor3 = activeTier.Color

    else
        -- KHI DỪNG CHẠY
        if continuousRunTime > 0 then
            -- Dừng từ Nấc 4 (Gần siêu nhanh) trở lên -> Ragdoll mất đà
            if currentTierIndex >= 4 and not isRagdolled and not isTransitioning then
                triggerRagdollInertia(char, humanoid, hrp, currentTierIndex)
            end

            -- Reset toàn bộ trạng thái
            continuousRunTime = 0
            currentTierIndex = 1
            transitionTriggered[4] = false
            transitionTriggered[7] = false

            humanoid.WalkSpeed = SPEED_TIERS[1].WalkSpeed

            if characterHighlight then
                characterHighlight.FillColor = SPEED_TIERS[1].Color
                characterHighlight.OutlineColor = SPEED_TIERS[1].AuraOutline
            end

            if speedParticles then speedParticles.Rate = 0 end
            TweenService:Create(Camera, TweenInfo.new(0.4), {FieldOfView = 70}):Play()

            TierLabel.Text = "CẤP ĐỘ: SPEED GỐC"
            TierLabel.TextColor3 = SPEED_TIERS[1].Color
            StatusLabel.Text = "Trạng thái: An toàn"
            StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
end)

-- Reset trạng thái khi chết hoặc Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    continuousRunTime = 0
    currentTierIndex = 1
    isRagdolled = false
    isTransitioning = false
    transitionTriggered[4] = false
    transitionTriggered[7] = false
    task.wait(0.5)
    setupVFX(char)
end)
