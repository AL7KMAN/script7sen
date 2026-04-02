repeat task.wait() until game:IsLoaded()

local lp = game:GetService("Players").LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local vu = game:GetService("VirtualUser")
local nc = game:GetService("NetworkClient")

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

if pgui:FindFirstChild("AFK_PRO_STEADY") then pgui.AFK_PRO_STEADY:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "AFK_PRO_STEADY"
sg.ResetOnSpawn = false

local blackScreen = Instance.new("Frame", sg)
blackScreen.Size = UDim2.new(1.5, 0, 1.5, 0)
blackScreen.Position = UDim2.new(-0.25, 0, -0.25, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0) 
blackScreen.Visible = false 
blackScreen.ZIndex = 0

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true 
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1
stroke.Transparency = 0.8

local function createBtn(txt, pos, cmd)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.9, 0, 0.22, 0)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cmd(b) end)
    return b
end

createBtn("NETWORK OPTIMIZATION [X]", UDim2.new(0.05, 0, 0.08, 0), function(btn)
    optActive = not optActive
    if optActive then
        btn.Text = "NETWORK OPTIMIZATION [✓]"
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        settings().Network.IncomingReplicationLag = 1.5 
        nc:SetSimulatedCore(Enum.NetworkSimulatedCore.Slow)
    else
        btn.Text = "NETWORK OPTIMIZATION [X]"
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        settings().Network.IncomingReplicationLag = 0
        nc:SetSimulatedCore(Enum.NetworkSimulatedCore.Normal)
    end
end)

createBtn("BLACK SCREEN [X]", UDim2.new(0.05, 0, 0.38, 0), function(btn)
    bsActive = not bsActive
    blackScreen.Visible = bsActive
    btn.Text = bsActive and "BLACK SCREEN [✓]" or "BLACK SCREEN [X]"
    btn.BackgroundColor3 = bsActive and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(55, 55, 55)
end)

local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.9, 0, 0.5, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
openBtn.Text = "" 
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true 
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", openBtn).Color = Color3.new(1,1,1)

createBtn("HIDE UI / CLOSE", UDim2.new(0.05, 0, 0.68, 0), function()
    frame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
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
