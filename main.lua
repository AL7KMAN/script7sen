repeat task.wait() until game:IsLoaded()

local lp = game:GetService("Players").LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local vu = game:GetService("VirtualUser")
local nc = game:GetService("NetworkClient")
local l = game:GetService("Lighting")
local t = workspace:FindFirstChildOfClass("Terrain")

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        return nil
    end
    return old(self, ...)
end)
setreadonly(mt, true)

if pgui:FindFirstChild("HusseinMenu") then pgui.HusseinMenu:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "HusseinMenu"
sg.ResetOnSpawn = false

local darkLayer = Instance.new("Frame", sg)
darkLayer.Size = UDim2.new(1.5, 0, 1.5, 0)
darkLayer.Position = UDim2.new(-0.25, 0, -0.25, 0)
darkLayer.BackgroundColor3 = Color3.new(0, 0, 0) 
darkLayer.Visible = false 
darkLayer.ZIndex = 0

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 220, 0, 240)
main.Position = UDim2.new(0.5, -110, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.Active = true
main.Draggable = true 
local uiCorner = Instance.new("UICorner", main)
uiCorner.CornerRadius = UDim.new(0, 12)

local function makeButton(txt, pos, cmd)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0.18, 0)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.TextScaled = true
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cmd(b) end)
    return b
end

local isLow = false
local function fixGraphic(v, on)
    if v:IsA("BasePart") then
        v.CastShadow = not on
        if on then v.Material = Enum.Material.SmoothPlastic end
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Explosion") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = not on
    end
end

makeButton("تحسين الشبكة [X]", UDim2.new(0.05, 0, 0.05, 0), function(btn)
    _G.net = not _G.net
    btn.Text = _G.net and "تحسين الشبكة [✓]" or "تحسين الشبكة [X]"
    btn.BackgroundColor3 = _G.net and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(55, 55, 55)
    settings().Network.IncomingReplicationLag = _G.net and 1.5 or 0
    nc:SetSimulatedCore(_G.net and Enum.NetworkSimulatedCore.Slow or Enum.NetworkSimulatedCore.Normal)
end)

makeButton("شاشة سوداء [X]", UDim2.new(0.05, 0, 0.28, 0), function(btn)
    _G.dark = not _G.dark
    darkLayer.Visible = _G.dark
    btn.Text = _G.dark and "شاشة سوداء [✓]" or "شاشة سوداء [X]"
    btn.BackgroundColor3 = _G.dark and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(55, 55, 55)
end)

makeButton("إزالة الضغط [X]", UDim2.new(0.05, 0, 0.51, 0), function(btn)
    isLow = not isLow
    btn.Text = isLow and "إزالة الضغط [✓]" or "إزالة الضغط [X]"
    btn.BackgroundColor3 = isLow and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(55, 55, 55)
    l.GlobalShadows = not isLow
    l.Brightness = isLow and 1 or 2
    l.FogEnd = isLow and 999999 or 1000
    if t then
        t.WaterWaveSize = isLow and 0 or 0.15
        t.WaterWaveSpeed = isLow and 0 or 10
    end
    for _,v in pairs(workspace:GetDescendants()) do
        fixGraphic(v, isLow)
    end
end)

workspace.DescendantAdded:Connect(function(v)
    if isLow then
        task.wait()
        fixGraphic(v, true)
    end
end)

local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.9, 0, 0.5, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
openBtn.Text = "فتح"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true 
Instance.new("UICorner", openBtn)

makeButton("إخفاء الواجهة", UDim2.new(0.05, 0, 0.75, 0), function()
    main.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    openBtn.Visible = false
end)

lp.Idled:Connect(function() 
    vu:CaptureController() 
    vu:ClickButton2(Vector2.new()) 
end)

task.spawn(function() 
    while task.wait(60) do 
        collectgarbage("collect")
    end 
end)
