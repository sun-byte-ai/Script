-- ==========================================================
-- ROBLOX ULTRA AUDIO BOOSTER PRO V4 (UNCAPPED & ULTRA-COMPACT)
-- ==========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui") or CoreGui

-- Xóa GUI cũ nếu có để tránh trùng lặp
for _, guiName in ipairs({"AudioBoosterUI"}) do
    if player.PlayerGui:FindFirstChild(guiName) then
        player.PlayerGui[guiName]:Destroy()
    end
    if CoreGui:FindFirstChild(guiName) then
        CoreGui[guiName]:Destroy()
    end
end

-- 1. Tạo Master SoundGroup và hệ thống lọc âm chống rè
local masterGroup = Instance.new("SoundGroup")
masterGroup.Name = "UniversalAudioBoosterV4"
masterGroup.Volume = 5 -- Mặc định ban đầu (x5)
masterGroup.Parent = SoundService

-- Bộ nén thông minh triệt tiêu tiếng ồn và méo tiếng
local compressor = Instance.new("CompressorSoundEffect")
compressor.Name = "CleanCompressor"
compressor.Threshold = -18
compressor.Ratio = 3
compressor.Attack = 0.003
compressor.Release = 0.08
compressor.GainMakeup = 3
compressor.Parent = masterGroup

-- Bộ lọc âm thanh giúp âm trầm ấm, âm cao trong trẻo
local equalizer = Instance.new("EqualizerSoundEffect")
equalizer.Name = "ClearEqualizer"
equalizer.HighGain = 1.5
equalizer.MidGain = 1.0
equalizer.LowGain = 2.0
equalizer.Parent = masterGroup

-- 2. Hàm gom và tối ưu âm thanh tự động
local function applyBooster(sound)
    if sound and sound:IsA("Sound") then
        if sound.SoundGroup ~= masterGroup then
            sound.SoundGroup = masterGroup
        end
        if sound.Volume < 0.1 and sound.Volume > 0 then
            sound.Volume = 0.5 
        end
    end
end

local function deepScan()
    local servicesToScan = {workspace, game:GetService("ReplicatedStorage"), Players, SoundService}
    for _, service in ipairs(servicesToScan) do
        task.spawn(function()
            for _, descendant in ipairs(service:GetDescendants()) do
                applyBooster(descendant)
            end
        end)
    end
end

deepScan()

workspace.DescendantAdded:Connect(function(descendant)
    applyBooster(descendant)
end)

local function monitorCharacter(char)
    char.DescendantAdded:Connect(function(descendant)
        applyBooster(descendant)
    end)
    for _, descendant in ipairs(char:GetDescendants()) do
        applyBooster(descendant)
    end
end

if player.Character then
    monitorCharacter(player.Character)
end
player.CharacterAdded:Connect(monitorCharacter)

-- 3. Giao diện (GUI) Siêu Gọn & Hiện Đại
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AudioBoosterUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0.5, -110, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 120)
stroke.Thickness = 1.2
stroke.Parent = mainFrame

-- Thanh tiêu đề
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -55, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔊 Audio Booster Pro"
titleLabel.TextColor3 = Color3.fromRGB(230, 230, 245)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Nút Thu Nhỏ (-)
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 20, 0, 20)
minButton.Position = UDim2.new(1, -46, 0, 5)
minButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
minButton.Text = "-"
minButton.TextColor3 = Color3.fromRGB(200, 200, 220)
minButton.TextSize = 13
minButton.Font = Enum.Font.GothamBold
minButton.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minButton

-- Nút Đóng (×)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -22, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Khung nội dung
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -36)
contentFrame.Position = UDim2.new(0, 10, 0, 32)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Ô nhập liệu (Không giới hạn giá trị)
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 32)
inputBox.Position = UDim2.new(0, 0, 0, 2)
inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
inputBox.Text = "1"
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.GothamBold
inputBox.ClearTextOnFocus = false
inputBox.PlaceholderText = "Nhập mức âm lượng..."
inputBox.Parent = contentFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = inputBox

local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(60, 60, 95)
boxStroke.Parent = inputBox

-- Dòng trạng thái hiển thị trực quan
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Mức 1 (x5)"
statusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- Nút thu gọn siêu nhỏ (Icon nổi khi ẩn GUI)
local ultraCompactBtn = Instance.new("TextButton")
ultraCompactBtn.Name = "UltraCompactButton"
ultraCompactBtn.Size = UDim2.new(0, 36, 0, 36)
ultraCompactBtn.Position = UDim2.new(0, 20, 0, 20)
ultraCompactBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
ultraCompactBtn.Text = "🔊"
ultraCompactBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ultraCompactBtn.TextSize = 14
ultraCompactBtn.Font = Enum.Font.GothamBold
ultraCompactBtn.Visible = false
ultraCompactBtn.Parent = screenGui

local ucCorner = Instance.new("UICorner")
ucCorner.CornerRadius = UDim.new(1, 0)
ucCorner.Parent = ultraCompactBtn

local ucStroke = Instance.new("UIStroke")
ucStroke.Color = Color3.fromRGB(100, 120, 255)
ucStroke.Thickness = 1.5
ucStroke.Parent = ultraCompactBtn

-- Tính năng kéo thả mượt mà (Hỗ trợ cả chuột và cảm ứng điện thoại)
local function makeDraggable(frame, dragTarget)
    dragTarget = dragTarget or frame
    local dragging = false
    local dragStart, startPos

    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainFrame, titleBar)
makeDraggable(ultraCompactBtn)

minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    ultraCompactBtn.Position = mainFrame.Position
    ultraCompactBtn.Visible = true
end)

ultraCompactBtn.MouseButton1Click:Connect(function()
    mainFrame.Position = ultraCompactBtn.Position
    ultraCompactBtn.Visible = false
    mainFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Xử lý logic nhập giá trị KHÔNG GIỚI HẠN
inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = inputBox.Text
    if text == "" then
        statusLabel.Text = "Trạng thái: Đang trống..."
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
        return
    end
    
    local val = tonumber(text)
    if val then
        -- Cho phép mọi giá trị người dùng nhập mà không bị chặn kẹt ở mức 10
        local actualVolume = val * 5 
        masterGroup.Volume = actualVolume
        statusLabel.Text = "Trạng thái: Mức " .. val .. " (x" .. actualVolume .. ")"
        statusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
    else
        statusLabel.Text = "Trạng thái: Vui lòng chỉ nhập số!"
        statusLabel.TextColor3 = Color3.fromRGB(220, 100, 100)
    end
end)

print("🚀 Super Audio Booster V4 đã khởi chạy thành công!")
