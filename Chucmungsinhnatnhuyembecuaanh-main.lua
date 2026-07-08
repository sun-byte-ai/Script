-- B birthday Script cho Bé Như Ý (Chạy trên Delta)
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Tạo ScreenGui trong CoreGui để đè lên toàn màn hình
local sgui = Instance.new("ScreenGui")
sgui.Name = "BdaySurprise"
sgui.ResetOnSpawn = false
sgui.Parent = CoreGui

-- Khung nền chính (Đen)
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bg.BorderSizePixel = 0
bg.Parent = sgui

-- Tạo Rèm Trái và Rèm Phải
local curtainLeft = Instance.new("Frame")
curtainLeft.Size = UDim2.new(0.5, 0, 1, 0)
curtainLeft.Position = UDim2.new(0, 0, 0, 0)
curtainLeft.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
curtainLeft.BorderSizePixel = 0
curtainLeft.ZIndex = 10
curtainLeft.Parent = bg

local curtainRight = Instance.new("Frame")
curtainRight.Size = UDim2.new(0.5, 0, 1, 0)
curtainRight.Position = UDim2.new(0.5, 0, 0, 0)
curtainRight.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
curtainRight.BorderSizePixel = 0
curtainRight.ZIndex = 10
curtainRight.Parent = bg

-- Viền vàng cho rèm thêm sang trọng
local borderL = Instance.new("Frame")
borderL.Size = UDim2.new(0, 5, 1, 0)
borderL.Position = UDim2.new(1, -5, 0, 0)
borderL.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
borderL.BorderSizePixel = 0
borderL.Parent = curtainLeft

local borderR = Instance.new("Frame")
borderR.Size = UDim2.new(0, 5, 1, 0)
borderR.Position = UDim2.new(0, 0, 0, 0)
borderR.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
borderR.BorderSizePixel = 0
borderR.Parent = curtainRight

-- Khung chứa bánh kem (ẩn lúc đầu)
local cakeZone = Instance.new("Frame")
cakeZone.Size = UDim2.new(1, 0, 1, 0)
cakeZone.BackgroundTransparency = 1
cakeZone.Parent = bg

-- Tên tiêu đề bánh kem
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 100)
title.Position = UDim2.new(0, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "Chúc mừng sinh nhật\nbé Như Ý của anh"
title.Font = Enum.Font.FredokaOne -- Font chữ cute
title.TextColor3 = Color3.fromRGB(255, 105, 180)
title.TextSize = 35
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(255, 20, 147)
title.TextTransparency = 1
title.Parent = cakeZone

-- Vẽ bánh sinh nhật 3 tầng bằng các Frame xếp chồng
local cakeContainer = Instance.new("Frame")
cakeContainer.Size = UDim2.new(0, 300, 0, 200)
cakeContainer.Position = UDim2.new(0.5, -150, 0.45, 0)
cakeContainer.BackgroundTransparency = 1
cakeContainer.Parent = cakeZone

local t1 = Instance.new("Frame") -- Tầng 1 (Dưới cùng)
t1.Size = UDim2.new(0, 240, 0, 60)
t1.Position = UDim2.new(0.5, -120, 1, -60)
t1.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
t1.BackgroundTransparency = 1
t1.Parent = cakeContainer

local t2 = Instance.new("Frame") -- Tầng 2
t2.Size = UDim2.new(0, 180, 0, 50)
t2.Position = UDim2.new(0.5, -90, 1, -110)
t2.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
t2.BackgroundTransparency = 1
t2.Parent = cakeContainer

local t3 = Instance.new("Frame") -- Tầng 3
t3.Size = UDim2.new(0, 120, 0, 40)
t3.Position = UDim2.new(0.5, -60, 1, -150)
t3.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
t3.BackgroundTransparency = 1
t3.Parent = cakeContainer

-- Cây nến và ngọn lửa
local candle = Instance.new("Frame")
candle.Size = UDim2.new(0, 10, 0, 35)
candle.Position = UDim2.new(0.5, -5, 1, -185)
candle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
candle.BackgroundTransparency = 1
candle.Parent = cakeContainer

local flame = Instance.new("Frame")
flame.Size = UDim2.new(0, 14, 0, 20)
flame.Position = UDim2.new(0.5, -7, 0, -22)
flame.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
flame.BackgroundTransparency = 1
flame.Parent = candle

-- Bo góc cho các tầng bánh nhìn cho cute
local function addCorners(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = obj
end
addCorners(t1) addCorners(t2) addCorners(t3)
local flameCorner = Instance.new("UICorner") flameCorner.CornerRadius = UDim.new(1, 0) flameCorner.Parent = flame

-- Dòng chữ chạy siêu cute công phu
local scrollText = Instance.new("TextLabel")
scrollText.Size = UDim2.new(0.8, 0, 0, 150)
scrollText.Position = UDim2.new(0.1, 0, 1, 10)
scrollText.BackgroundTransparency = 1
scrollText.Text = "chúc em bé một ngày sinh nhật vui vẻ và nhiều hạnh phúc nhé,\nnhớ ăn ngon mặc ấm nha muốn gì bảo anh nhé\nanh sẽ làm tất cả vì bà xã của anh,\nyêu em rất là nhiều 💞🔥🍰"
scrollText.Font = Enum.Font.FredokaOne
scrollText.TextColor3 = Color3.fromRGB(255, 255, 255)
scrollText.TextSize = 22
scrollText.RichText = true -- Hỗ trợ Emoji hiển thị đẹp
scrollText.TextWrapped = true
scrollText.TextStrokeTransparency = 0
scrollText.TextStrokeColor3 = Color3.fromRGB(255, 20, 147)
scrollText.Parent = bg

-- Dòng chữ cuối cùng cảm động
local finalText = Instance.new("TextLabel")
finalText.Size = UDim2.new(1, 0, 0, 100)
finalText.Position = UDim2.new(0, 0, 0.45, -50)
finalText.BackgroundTransparency = 1
finalText.Text = "8/7 vui vẻ nha vợ iêu 🍰🔥"
finalText.Font = Enum.Font.FredokaOne
finalText.TextColor3 = Color3.fromRGB(255, 235, 59)
finalText.TextSize = 40
finalText.RichText = true
finalText.TextTransparency = 1
finalText.TextStrokeTransparency = 1
finalText.TextStrokeColor3 = Color3.fromRGB(255, 69, 0)
finalText.Parent = bg

-- Âm thanh vỗ tay hoành tráng từ thư viện Roblox công cộng
local applause = Instance.new("Sound")
applause.SoundId = "rbxassetid://9069609268" -- ID âm thanh cheering/applause hoành tráng
applause.Volume = 1
applause.Parent = bg

-- Hàm tạo pháo hoa/confetti rơi tự do siêu cute
local function spawnConfetti(amount)
    task.spawn(function()
        for i = 1, amount do
            task.spawn(function()
                local p = Instance.new("Frame")
                p.Size = UDim2.new(0, math.random(8, 14), 0, math.random(8, 14))
                p.Position = UDim2.new(math.random(0, 100)/100, 0, -0.05, 0)
                p.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1) -- Đủ loại màu sắc sắc sỡ
                p.BorderSizePixel = 0
                p.Parent = bg
                addCorners(p)
                
                -- Tạo chuyển động rơi lắc lư ngẫu nhiên
                local targetX = p.Position.X.Scale + (math.random(-15, 15)/100)
                local duration = math.random(2, 4)
                
                TweenService:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, 1.05, 0)}):Play()
                TweenService:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Linear), {BackgroundTransparency = 1}):Play()
                
                task.wait(duration)
                p:Destroy()
            end)
            if i % 5 == 0 then task.wait(0.05) end
        end
    end)
end

-- ==================== BẮT ĐẦU KỊCH BẢN CHẠY DIỄN MÀN HÌNH ====================
task.wait(0.5)

-- 1. Bắn pháo hoa chào mừng lúc rèm chuẩn bị mở
spawnConfetti(40)

-- 2. Hiệu ứng Mở Rèm (Kéo sang 2 bên)
TweenService:Create(curtainLeft, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(-0.5, 0, 0, 0)}):Play()
TweenService:Create(curtainRight, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(1, 0, 0, 0)}):Play()
task.wait(3.2)

-- 3. Hiện dần bánh sinh nhật 3 tầng và tiêu đề tên vợ
local fadeInInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
TweenService:Create(title, fadeInInfo, {TextTransparency = 0}):Play()
TweenService:Create(t1, fadeInInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(t2, fadeInInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(t3, fadeInInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(candle, fadeInInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(flame, fadeInInfo, {BackgroundTransparency = 0}):Play()
task.wait(3.5)

-- 4. Chữ chạy chậm chậm từ dưới lên đủ để đọc cảm động
-- Quãng đường chạy lên mất khoảng 13 giây cho lãng mạn
scrollText.Position = UDim2.new(0.1, 0, 1, 10)
local scrollTween = TweenService:Create(scrollText, TweenInfo.new(13, Enum.EasingStyle.Linear), {Position = UDim2.new(0.1, 0, 0.2, -50)})
scrollTween:Play()
scrollTween.Completed:Wait()

-- Đợi thêm 1.5 giây sau khi chữ lên hẳn để đọc nốt chữ cuối
task.wait(1.5)
TweenService:Create(scrollText, TweenInfo.new(1, Enum.EasingStyle.Linear), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()

-- 5. Hiệu ứng TẮT NẾN + TIẾNG VỖ TAY HOÀNH TRÁNG + PHÁO HOA BÙNG NỔ
flame.Visible = false -- Tắt nến
applause:Play() -- Bật tiếng vỗ tay rộn rã
spawnConfetti(120) -- Bắn một trận pháo hoa siêu to khổng lồ

task.wait(1)
-- Làm mờ bánh kem dần đi để nhường chỗ cho dòng chữ cuối
TweenService:Create(title, fadeInInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
TweenService:Create(t1, fadeInInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(t2, fadeInInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(t3, fadeInInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(candle, fadeInInfo, {BackgroundTransparency = 1}):Play()
task.wait(2)

-- 6. Dòng chữ cuối cùng "8/7 vui vẻ nha vợ iêu🍰🔥" dần hiện đầy xúc động
TweenService:Create(finalText, TweenInfo.new(2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0, TextStrokeTransparency = 0, TextSize = 48}):Play()
task.wait(4.5) -- Giữ lại cho vợ ngắm tí

-- Dần tắt...
TweenService:Create(finalText, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
task.wait(1.5)

-- 7. KẾT THÚC: Biến mất toàn bộ siêu nhanh để trả lại màn hình game cũ
local fastFade = TweenInfo.new(0.4, Enum.EasingStyle.Linear) -- Mất nhanh chút theo ý bạn
local finalTween = TweenService:Create(bg, fastFade, {BackgroundTransparency = 1})
finalTween:Play()
finalTween.Completed:Wait()

-- Dọn dẹp bộ nhớ triệt để, xóa sạch Script UI khỏi Roblox
sgui:Destroy()
