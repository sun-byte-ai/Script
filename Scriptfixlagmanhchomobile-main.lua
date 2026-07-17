-- ==================================================
-- ANTI-LAG SCRIPT: Cân bằng Đồ họa & Hiệu năng
-- ==================================================

local Lighting = game:GetService("Lighting")
local Terrain = workspace:WaitForChild("Terrain")

-- 1. Tối ưu hóa Ánh sáng (Tắt hiệu ứng điện ảnh nặng, giữ lại màu sắc)
Lighting.GlobalShadows = false -- Tắt bóng đổ toàn cầu (Nguyên nhân gây lag số 1)
Lighting.FogEnd = 9e9 -- Xóa sương mù để giảm tải render xa

-- Tắt các hiệu ứng làm mờ và lóa mắt
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

-- 2. Tối ưu hóa Nước & Địa hình (Giữ nước trong nhưng không tính toán gợn sóng)
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0.5 -- Nước vẫn nhìn xuyên thấu nhẹ
end

-- 3. Tối ưu hóa Vật thể và Hạt (Particles)
for _, v in pairs(workspace:GetDescendants()) do
    -- Xử lý các khối block
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.CastShadow = false -- Tắt bóng đổ của từng vật thể
        -- LƯU Ý: Không đổi v.Material thành SmoothPlastic để giữ đồ họa đẹp
        
    -- Xử lý Mesh (Các vật thể 3D phức tạp)
    elseif v:IsA("MeshPart") then
        v.CastShadow = false
        v.RenderFidelity = Enum.RenderFidelity.Performance -- Tự động giảm chi tiết khi ở xa
        
    -- Xử lý hiệu ứng Hạt (Lửa, Khói, Phép thuật)
    elseif v:IsA("ParticleEmitter") then
        -- Giảm 50% số lượng hạt thay vì xóa hoàn toàn để game vẫn có hiệu ứng kỹ năng
        v.Rate = v.Rate / 2
    elseif v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        v.Enabled = false -- Tắt các hiệu ứng cháy nổ thừa thãi
    end
end

-- Xóa các Decal/Texture rác không cần thiết nếu bộ nhớ đầy (Tùy chọn, hiện đang ẩn)
-- for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end end

-- 4. Thông báo hoàn tất
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Anti-Lag Kích Hoạt";
    Text = "Đồ họa Trung Bình - FPS Ổn định!";
    Duration = 5;
})

print("✅ Anti-lag đã chạy thành công!")
