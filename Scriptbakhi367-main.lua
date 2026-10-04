-- Script Troll Tra Tấn Cực Hạn (Fixed Text 8s + 34 Audios + Kick + Hard Freeze)
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Dọn dẹp GUI cũ
if PlayerGui:FindFirstChild("UltimateHorrorAlienFixed") then
    PlayerGui.UltimateHorrorAlienFixed:Destroy()
end

-- Khởi tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateHorrorAlienFixed"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999 -- Đưa lên trên cùng
screenGui.Parent = PlayerGui

-- Tác động hiệu ứng môi trường Lighting
local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
local blur = Instance.new("BlurEffect", Lighting)
local bloom = Instance.new("BloomEffect", Lighting)

-- ----------------------------------------------------
-- KHO 34 ÂM THANH DỊ BIỆT (KINH DỊ / TÂM LINH / ALIEN)
-- ----------------------------------------------------
local soundIds = {
    "rbxassetid://9114223177", "rbxassetid://9114221327", "rbxassetid://138081509",
    "rbxassetid://130833677",  "rbxassetid://270960010",  "rbxassetid://152605333",
    "rbxassetid://1848354536", "rbxassetid://138248843",  "rbxassetid://1837854612",
    "rbxassetid://138122929",  "rbxassetid://1843404508", "rbxassetid://9069609268",
    "rbxassetid://9120386436", "rbxassetid://9068087968", "rbxassetid://1847682914",
    "rbxassetid://1837854268", "rbxassetid://9069502938", "rbxassetid://142416994",
    "rbxassetid://2107839239", "rbxassetid://1086053073", "rbxassetid://5852504936",
    "rbxassetid://625348842",  "rbxassetid://2709600100", "rbxassetid://181822368",
    "rbxassetid://642738722",  "rbxassetid://10384728",   "rbxassetid://147986927",
    "rbxassetid://1206129815", "rbxassetid://258285521",  "rbxassetid://156823180",
    "rbxassetid://484388481",  "rbxassetid://215708806",  "rbxassetid://101111663",
    "rbxassetid://169436798"
}

local sounds = {}
for _, id in ipairs(soundIds) do
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 10
    s.Looped = true
    s.Parent = screenGui
    table.insert(sounds, s)
end

-- ----------------------------------------------------
-- PHASE 1: NỬA MÀN HÌNH ĐEN & BỘ ĐẾM 8 GIÂY KINHI DỊ
-- ----------------------------------------------------
local halfBlackFrame = Instance.new("Frame")
halfBlackFrame.Size = UDim2.new(0.5, 0, 1, 0)
halfBlackFrame.Position = UDim2.new(0, 0, 0, 0)
halfBlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
halfBlackFrame.BorderSizePixel = 3
halfBlackFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
halfBlackFrame.ZIndex = 50
halfBlackFrame.Parent = screenGui

local creepyTimerText = Instance.new("TextLabel")
creepyTimerText.Size = UDim2.new(1, -20, 1, -20)
creepyTimerText.Position = UDim2.new(0, 10, 0, 10)
creepyTimerText.BackgroundTransparency = 1
creepyTimerText.TextColor3 = Color3.fromRGB(255, 30, 30)
creepyTimerText.TextSize = 22
creepyTimerText.Font = Enum.Font.Code
creepyTimerText.TextWrapped = true
creepyTimerText.ZIndex = 51
creepyTimerText.Parent = halfBlackFrame

local creepyMessages = {
    "☠️ THEY ARE WATCHING YOU FROM THE SHADOWS...",
    "👁️ DO NOT LOOK BEHIND YOU... IT IS THERE.",
    "👽 UNKNOWN ALIEN ENTITY CONVERGING...",
    "🩸 SYSTEM BLOOD INJECTION: CORRUPTING HARDWARE...",
    "☣️ PARANORMAL SPIRIT HOST TAKEOVER...",
    "☠️ 0x0000666_SOUL_EXTRACTION_IN_PROGRESS...",
    "👽 THEY ARE BREATHING ON YOUR NECK...",
    "🩸 YOUR DEVICE NO LONGER BELONGS TO YOU."
}

local alienSymbols = {"⎍", "⎎", "⍜", "⏃", "⌰", "⟟", "⟒", "⋏", "⌇", "⊬", "⏁", "Ⓔ", "⎑", "☞", "👽", "☠", "☣", "█", "▓", "▒", "░", "⌿", "⍀"}

local function getAlienMsg(len)
    local str = ""
    for i = 1, len do
        str = str .. alienSymbols[math.random(1, #alienSymbols)]
    end
    return str
end

-- ----------------------------------------------------
-- CÁC LỚP BỀ MẶT PHỦ MÀN HÌNH PHASE 2
-- ----------------------------------------------------
local flashOverlay = Instance.new("Frame")
flashOverlay.Size = UDim2.new(1, 0, 1, 0)
flashOverlay.Visible = false
flashOverlay.ZIndex = 1
flashOverlay.Parent = screenGui

-- 10 Frame Hình Ảnh To Phủ 4 Vùng Độc Lập
local imageLabels = {}
for i = 1, 10 do
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Fit
    img.Visible = false
    img.ZIndex = 3
    img.Parent = screenGui
    table.insert(imageLabels, img)
end

-- 6 Text Label Khổng Lồ
local bigTextLabels = {}
for i = 1, 6 do
    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.Font = Enum.Font.Code
    txt.TextColor3 = Color3.fromRGB(0, 255, 100)
    txt.Visible = false
    txt.ZIndex = 5
    txt.Parent = screenGui
    table.insert(bigTextLabels, txt)
end

-- Kho 25 ID Hình Ảnh Kinh Dị / Alien
local images = {
    "rbxassetid://13110031853", "rbxassetid://6071596383", "rbxassetid://2107839239",
    "rbxassetid://1086053073",  "rbxassetid://5852504936", "rbxassetid://152605333",
    "rbxassetid://625348842",   "rbxassetid://2709600100", "rbxassetid://181822368",
    "rbxassetid://642738722",   "rbxassetid://10384728",   "rbxassetid://147986927",
    "rbxassetid://1206129815",  "rbxassetid://142416994",  "rbxassetid://258285521",
    "rbxassetid://156823180",   "rbxassetid://484388481",  "rbxassetid://215708806",
    "rbxassetid://101111663",   "rbxassetid://169436798",  "rbxassetid://138081509",
    "rbxassetid://261051098",   "rbxassetid://276722880",  "rbxassetid://178492089",
    "rbxassetid://258285433"
}

local gridPositions = {
    UDim2.new(0.02, 0, 0.02, 0),
    UDim2.new(0.52, 0, 0.02, 0),
    UDim2.new(0.02, 0, 0.52, 0),
    UDim2.new(0.52, 0, 0.52, 0)
}

-- ----------------------------------------------------
-- LUỒNG THỰC THI CHÍNH
-- ----------------------------------------------------
task.spawn(function()
    -- Bật 3 âm thanh nhiễu sóng nhẹ trong Phase 1
    sounds[1]:Play()
    sounds[2]:Play()
    sounds[3]:Play()

    -- BỘ ĐẾM 8 GIÂY KINHI DỊ HIỂN THỊ RÕ RÀNG
    for i = 8, 1, -1 do
        local msg = creepyMessages[math.random(1, #creepyMessages)]
        creepyTimerText.Text = string.format(
            "⚠️ ALIEN OVERLOAD INITIATED ⚠️\n\n%s\n\n[ %d ] SECONDS REMAINING\n\n%s", 
            msg, i, getAlienMsg(24)
        )
        
        -- Chớp màu đỏ chói
        creepyTimerText.TextColor3 = (i % 2 == 0) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 120, 120)
        task.wait(1)
    end

    -- Xóa nửa màn hình đen
    halfBlackFrame:Destroy()

    -- ----------------------------------------------------
    -- PHASE 2: BÙNG NỔ 34 ÂM THANH + TRA TẤN 6 GIÂY
    -- ----------------------------------------------------
    flashOverlay.Visible = true
    
    -- Phát đồng loạt 34 âm thanh
    for _, s in ipairs(sounds) do
        if not s.IsPlaying then s:Play() end
    end

    local duration = 6
    local startTime = os.clock()

    while os.clock() - startTime < duration do
        -- 1. Flashing background
        flashOverlay.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        flashOverlay.BackgroundTransparency = math.random(0, 2) / 10

        -- 2. Tản 10 Ảnh Kích Thước To Ngẫu Nhiên Không Bị Dính Đè
        for idx, img in ipairs(imageLabels) do
            img.Image = images[math.random(1, #images)]
            local posBase = gridPositions[((idx - 1) % 4) + 1]
            img.Position = UDim2.new(posBase.X.Scale + math.random(-5, 5)/100, 0, posBase.Y.Scale + math.random(-5, 5)/100, 0)
            img.Size = UDim2.new(math.random(50, 85) / 100, 0, math.random(50, 85) / 100, 0)
            img.Rotation = math.random(-50, 50)
            img.Visible = (math.random(1, 3) ~= 1)
        end

        -- 3. Chữ Alien Khổng Lồ Nhảy Loạn Màn Hình
        for _, txt in ipairs(bigTextLabels) do
            txt.Text = getAlienMsg(math.random(15, 35))
            txt.Size = UDim2.new(math.random(65, 95) / 100, 0, math.random(15, 30) / 100, 0)
            txt.Position = UDim2.new(math.random(0, 10) / 100, 0, math.random(0, 70) / 100, 0)
            txt.TextColor3 = Color3.fromRGB(math.random(100, 255), math.random(0, 255), math.random(0, 255))
            txt.Rotation = math.random(-25, 25)
            txt.Visible = true
        end

        -- 4. Biến đổi pitch/tốc độ 34 âm thanh
        for _, s in ipairs(sounds) do
            s.PlaybackSpeed = math.random(3, 40) / 10
        end

        -- 5. Bóp méo hiệu ứng môi trường & Camera
        colorCorrection.Brightness = math.random(-10, 10) / 10
        colorCorrection.Contrast = math.random(3, 10)
        colorCorrection.Saturation = math.random(-10, 10)
        colorCorrection.TintColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        blur.Size = math.random(10, 50)
        bloom.Size = math.random(30, 80)
        bloom.Intensity = math.random(3, 8)

        if Camera then
            Camera.FieldOfView = math.random(10, 150)
            Camera.CFrame = Camera.CFrame * CFrame.Angles(
                math.rad(math.random(-40, 40)),
                math.rad(math.random(-40, 40)),
                math.rad(math.random(-35, 35))
            )
        end

        task.wait(0.015)
    end

    -- ----------------------------------------------------
    -- PHASE 3: KICK ALIEN & LÀM ĐƠ MÀN HÌNH VĨNH VIỄN
    -- ----------------------------------------------------
    for _, img in ipairs(imageLabels) do img:Destroy() end
    for _, txt in ipairs(bigTextLabels) do txt:Destroy() end
    flashOverlay:Destroy()

    local kickFrame = Instance.new("Frame")
    kickFrame.Size = UDim2.new(0, 520, 0, 280)
    kickFrame.Position = UDim2.new(0.5, -260, 0.5, -140)
    kickFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    kickFrame.BorderSizePixel = 3
    kickFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    kickFrame.ZIndex = 100
    kickFrame.Parent = screenGui

    local kickTitle = Instance.new("TextLabel")
    kickTitle.Size = UDim2.new(1, 0, 0, 50)
    kickTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    kickTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    kickTitle.TextSize = 20
    kickTitle.Font = Enum.Font.Code
    kickTitle.Text = "⚠️ DISCONNECTED BY ALIEN PAYLOAD"
    kickTitle.Parent = kickFrame

    local kickBody = Instance.new("TextLabel")
    kickBody.Size = UDim2.new(1, -20, 1, -60)
    kickBody.Position = UDim2.new(0, 10, 0, 55)
    kickBody.BackgroundTransparency = 1
    kickBody.TextColor3 = Color3.fromRGB(0, 255, 100)
    kickBody.TextSize = 16
    kickBody.Font = Enum.Font.Code
    kickBody.TextWrapped = true
    kickBody.Text = "You were disconnected from the experience.\n\n" ..
                    "Reason: 👽 " .. getAlienMsg(50) .. "\n" ..
                    "0x80070002_FATAL_SYSTEM_CORRUPTION\n\n" ..
                    "CLIENT_HARD_LOCKED_PERMANENTLY."
    kickBody.Parent = kickFrame

    -- Kích hoạt lệnh Kick
    pcall(function()
        LocalPlayer:Kick("\n\n👽 " .. getAlienMsg(60) .. " 👽\n\nReason: ALIEN_VIRUS_HARD_LOCK")
    end)

    RunService.RenderStepped:Wait()
    task.wait(0.05)

    -- Đóng băng Client vĩnh viễn (Đơ màn hình)
    while true do
        -- Khóa ứng dụng
    end
end)
