-- ==========================================
-- SUPER LAG FIX & FPS BOOSTER (SAFE & POWERFUL)
-- Hỗ trợ giảm lag mạnh mẽ, không gây lỗi game
-- ==========================================

local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

-- 1. Tối ưu hóa Lighting & Giảm tải đổ bóng (Shadows)
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9 -- Xóa sương mù để giảm khoảng cách render nặng
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("DepthOfFieldEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") then
            effect.Enabled = false -- Tắt các hiệu ứng làm mờ/lấp lánh nặng máy
        end
    end
end)

-- 2. Tối ưu hóa Địa hình (Terrain)
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
end

-- 3. Ép cấu hình render của Roblox về mức thấp nhất
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- 4. Hàm xử lý tối ưu hóa chi tiết từng Object
local function optimizeObject(obj)
    -- Chuyển chất liệu các khối về SmoothPlastic để giảm tải cho GPU (VRAM)
    if obj:IsA("Part") or obj:IsA("CornerWedgePart") or obj:IsA("TrussPart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
    -- Tối ưu hóa các chi tiết Mesh (vật thể dựng sẵn)
    elseif obj:IsA("MeshPart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
        obj.TextureID = "" -- Xóa vân bề mặt Mesh nặng
    elseif obj:IsA("SpecialMesh") then
        obj.TextureId = ""
    -- Vô hiệu hóa Decal/Vân dán tường (nguyên nhân gây lag hàng đầu khi load map)
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy() -- Hoặc đổi thành obj.Transparency = 1 nếu không muốn xóa hẳn
    -- Vô hiệu hóa hiệu ứng hạt (lửa, khói, lấp lánh bụi)
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj.Enabled = false
    elseif obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        obj.Enabled = false
    end
end

-- Quét và tối ưu hóa toàn bộ thế giới game hiện tại
for _, obj in ipairs(workspace:GetDescendants()) do
    optimizeObject(obj)
end

-- Tự động tối ưu hóa các vật thể mới xuất hiện (quái vật mới spawn, chiêu thức của người chơi khác...)
workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1) -- Đợi một chút để tránh xung đột hệ thống khi vật thể vừa tạo
    optimizeObject(obj)
end)

print("--- [FIX LAG SUCCESSFUL] Script đã kích hoạt mượt mà! ---")
