--[[
    Wreck F.T.A.B. Complete Core
    Made by WreckAi 677
    Maximum features - Real remotes
    UI will be added later
]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ===================== REAL REMOTES =====================
local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
local CreateGrabLine = GrabEvents and (GrabEvents:FindFirstChild("CreateGrabLine") or GrabEvents:FindFirstChild("CreateGrabEvent"))
local ExtendGrabLine = GrabEvents and (GrabEvents:FindFirstChild("ExtendGrabLine") or GrabEvents:FindFirstChild("ExtendLineEvent"))
local DestroyGrabLine = GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine")
local SetNetworkOwner = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")

local MenuToys = ReplicatedStorage:FindFirstChild("MenuToys")
local SpawnToy = MenuToys and MenuToys:FindFirstChild("SpawnToyRemoteFunction")

-- ===================== SETTINGS (FULL) =====================
local Settings = {
    -- Player
    Flight = false,
    FlightSpeed = 60,
    Speed = false,
    WalkSpeed = 16,
    JumpPower = false,
    JumpPowerValue = 50,
    Noclip = false,
    InfJump = false,
    CharacterSpin = false,
    SpinSpeed = 15,
    GodMode = false,

    -- Combat / Grabs
    SuperStrength = false,
    StrengthValue = 800,
    ExtendLine = false,
    ExtendMultiplier = 8,
    CrazyLine = false,
    GrabAura = false,
    AuraRange = 35,
    KickAura = false,
    FlingAura = false,
    FlingPower = 600,
    KillAura = false,
    LoopGrab = false,

    -- Defense
    AntiGrab = false,
    AntiEGUCCI = false,
    AntiBlobman = false,
    AntiNetworkOwnership = false,
    AntiExplosion = false,
    AntiBurn = false,
    AntiVoid = false,
    AntiKick = false,
    AntiSticky = false,
    AntiSnowball = false,
    AntiBanana = false,
    AntiPaint = false,
    AntiPoison = false,
    AntiLag = false,
    AntiFling = false,
    AutoReset = false,
    WaterWalk = false,

    -- Blobman
    AutoSitBlobman = false,
    FreezeBlobman = false,
    BlobmanKick = false,
    BlobmanKill = false,
    NetOwnerSpam = false,
    BlobmanX = 0,
    BlobmanY = 25,
    BlobmanZ = 0,

    -- Toys
    ToysAura = false,
    ToysRadius = 25,
    AutoMoveToys = false,
    ToysMoveSpeed = 8,
    BringToys = false,

    -- Visual
    ESP = false,
    ESPName = true,
    ESPDistance = true,
    Tracers = false,
    Fullbright = false,
    FOV = 70,
    NoFog = false,

    -- Target
    SelectedTarget = nil,
    LoopTPToPlayer = false,
    Spectate = false,

    -- Misc
    AntiAFK = true,
    ClickTP = false,
    AutoRejoin = false,
}

local Connections = {}
local BodyVelocity, BodyGyro
local ESPObjects = {}
local Flying = false

-- ===================== UTILS =====================
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Wreck",
            Text = text,
            Duration = 4
        })
    end)
end

local function GetChar()
    return LocalPlayer.Character
end

local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ===================== ANTI AFK =====================
if Settings.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ===================== PLAYER FEATURES =====================
RunService.RenderStepped:Connect(function()
    -- Flight
    if Settings.Flight then
        local hrp = GetHRP()
        if hrp then
            if not BodyVelocity then
                BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                BodyVelocity.Parent = hrp
                BodyGyro = Instance.new("BodyGyro")
                BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                BodyGyro.P = 9e4
                BodyGyro.Parent = hrp
            end
            local dir = Vector3.zero
            local cf = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
            BodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlightSpeed or Vector3.zero
            BodyGyro.CFrame = cf
        end
    else
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    end
end)

RunService.Heartbeat:Connect(function()
    local hum = GetHum()
    local hrp = GetHRP()
    if not hum or not hrp then return end

    if Settings.Speed then
        hum.WalkSpeed = Settings.WalkSpeed
    end
    if Settings.JumpPower then
        hum.JumpPower = Settings.JumpPowerValue
    end
    if Settings.GodMode then
        hum.Health = hum.MaxHealth
    end
    if Settings.CharacterSpin then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        local char = GetChar()
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump then
        local hum = GetHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ===================== COMBAT / GRABS =====================
-- Extend Line
task.spawn(function()
    while true do
        if Settings.ExtendLine and ExtendGrabLine then
            pcall(function()
                ExtendGrabLine:FireServer(Settings.ExtendMultiplier * 40)
            end)
        end
        task.wait(0.08)
    end
end)

-- Crazy Line (grab everything nearby)
task.spawn(function()
    while true do
        if Settings.CrazyLine and CreateGrabLine then
            local hrp = GetHRP()
            if hrp then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local head = plr.Character:FindFirstChild("Head")
                        if head then
                            pcall(function()
                                CreateGrabLine:FireServer(head, head.CFrame)
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.12)
    end
end)

-- Grab Aura
task.spawn(function()
    while true do
        if Settings.GrabAura and CreateGrabLine then
            local hrp = GetHRP()
            if hrp then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= Settings.AuraRange then
                            local head = plr.Character:FindFirstChild("Head")
                            if head then
                                pcall(function()
                                    CreateGrabLine:FireServer(head, head.CFrame)
                                end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Fling Aura
task.spawn(function()
    while true do
        if Settings.FlingAura then
            local hrp = GetHRP()
            if hrp then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = plr.Character.HumanoidRootPart
                        local dist = (hrp.Position - targetHRP.Position).Magnitude
                        if dist <= Settings.AuraRange then
                            pcall(function()
                                if SetNetworkOwner then
                                    SetNetworkOwner:FireServer(targetHRP, hrp.CFrame)
                                end
                                targetHRP.AssemblyLinearVelocity = Vector3.new(0, Settings.FlingPower, 0)
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.15)
    end
end)

-- ===================== DEFENSE =====================
-- Basic Anti-Grab / Anti-Fling protection
RunService.Heartbeat:Connect(function()
    if Settings.AntiGrab or Settings.AntiFling then
        local char = GetChar()
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce") then
                    if v.Name ~= "WreckFly" then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

-- Anti Void
RunService.Heartbeat:Connect(function()
    if Settings.AntiVoid then
        local hrp = GetHRP()
        if hrp and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
        end
    end
end)

-- ===================== VISUALS =====================
RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = Settings.FOV
end)

RunService.Heartbeat:Connect(function()
    if Settings.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    end
end)

-- ESP
local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(110, 120, 255)
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Visible = false

    local dist = Drawing.new("Text")
    dist.Size = 12
    dist.Center = true
    dist.Outline = true
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Visible = false

    ESPObjects[plr] = {Box = box, Name = name, Dist = dist}
end

RunService.RenderStepped:Connect(function()
    for plr, d in pairs(ESPObjects) do
        if Settings.ESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = 38
                d.Box.Size = Vector2.new(size, size * 1.7)
                d.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                d.Box.Visible = true

                if Settings.ESPName then
                    d.Name.Text = plr.Name
                    d.Name.Position = Vector2.new(pos.X, pos.Y - size - 16)
                    d.Name.Visible = true
                else
                    d.Name.Visible = false
                end

                if Settings.ESPDistance then
                    local distance = math.floor((plr.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
                    d.Dist.Text = distance .. "m"
                    d.Dist.Position = Vector2.new(pos.X, pos.Y + size + 4)
                    d.Dist.Visible = true
                else
                    d.Dist.Visible = false
                end
            else
                d.Box.Visible = false
                d.Name.Visible = false
                d.Dist.Visible = false
            end
        else
            d.Box.Visible = false
            d.Name.Visible = false
            d.Dist.Visible = false
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        CreateESP(plr)
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        CreateESP(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            CreateESP(plr)
        end)
    end
end

-- ===================== TARGET =====================
task.spawn(function()
    while true do
        if Settings.LoopTPToPlayer and Settings.SelectedTarget and Settings.SelectedTarget.Character then
            local targetHRP = Settings.SelectedTarget.Character:FindFirstChild("HumanoidRootPart")
            local hrp = GetHRP()
            if targetHRP and hrp then
                hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
            end
        end
        task.wait(0.1)
    end
end)

-- ===================== MISC =====================
-- Click TP
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Settings.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local hrp = GetHRP()
        if hrp and Mouse.Hit then
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

print("[Wreck] F.T.A.B. Complete Core loaded")
Notify("Wreck", "Complete Core loaded - waiting for UI")
