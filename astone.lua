local RunService = game:GetService("RunService")

-- Tạo GUI để hiển thị FPS
local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Name = "FPSCounter"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

TextLabel.Parent = ScreenGui
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(1, 1, 1) -- Màu trắng
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 24
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Biến lưu thời gian
local lastTime = os.clock()
local frameCount = 0

-- Hàm cập nhật FPS
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = os.clock()
    if currentTime - lastTime >= 1 then
        local fps = frameCount / (currentTime - lastTime)
        TextLabel.Text = string.format("FPS: %.1f", fps)
        lastTime = currentTime
        frameCount = 0
    end
end)
