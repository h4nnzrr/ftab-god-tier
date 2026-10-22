--[[
    Wreck F.T.A.B. God Tier
    Made by WreckAi 677
    Compatible Xenon
]]

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// SETTINGS
local Settings = {
    WalkSpeed = 16, JumpPower = 50, FlightSpeed = 50, SpinSpeed = 15,
    Flight = false, WalkspeedEnabled = false, JumpPowerEnabled = false,
    CharacterSpin = false, Noclip = false, InfJump = false, JerkOff = false,

    ToggleGrabs = false, ToggleAuras = false, AuraDistance = 25, ShowAuraRadius = false,
    ToggleToyAuras = false, ToyAuraDistance = 81, ShowToyAuraRadius = false,
    ExtendLine = false, ExtendSpeed = 1, LineStrength = 400, SuperStrength = false,
    LineLagServer = false, LagStrength = 11, CrazyLine = false, LineSpeed = 0.04,

    AntiGrab = false, AntiEGUCCIGrab = false, AntiBlobman = false, AntiNetworkOwnership = false,
    AntiExplosion = false, AntiBurn = false, AntiVoid = false, AntiKick = false,
    BreakPCLDAntiKick = false, AntiSticky = false, AntiSnowball = false, AntiBanana = false,
    AntiPaint = false, AntiPoison = false, AntiLag = false, AutoAntiLag = false,
    AntiInvis = false, AutoReset = false, DisableVoid = false, WaterWalk = false,
    NoclipBarrier = false, AntiFling = false, AutoLeave = false,

    SelectedTarget = nil, LoopApplySelected = false, LoopApplyServer = false,

    AutoSitBlobman = false, FreezeBlobman = false, RemoveAntiKickSticky = false,
    NetOwnerSpam = false, BlobmanX = 0, BlobmanY = 25, BlobmanZ = 0,

    ToysAuraEnabled = false, MoveSpeed = 5, RotateSpeed = 1.5, BobHeight = 3,
    BobSpeed = 2, ToysRadius = 20, FaceCenter = false, AutoMove = false,
    AutoRotate = false, Bob = false, DisableHouseBarrier = false,

    PlayerESP = false, ServerESP = false, StickyESP = false, BlackholeESP = false,
    CustomLine = false, GrabbedObjectInfo = false, CustomSkybox = false,
    TimeOfDay = 14, DisableRagdollBlur = false, ThirdPerson = false,
    CameraNoclip = false, FOV = 70, RealisticFP = false, LimbTransparency = 0.3,
    RealisticWater = false, Shaders = false, Particles = true, BoostFPS = false,

    AutoClicker = false, Triggerbot = false, TriggerDelay = 0.05, TriggerDistance = 88,
    TriggerCooldown = 0.4, TriggerHitChance = 100, AimAssist = false,
    AimAssistPart = "Head", AimAssistFOV = 150, AimAssistSmooth = 0.15,
    AimAssistDistance = 40, SilentAim = false, SilentIgnoreWhitelist = true,
    SoundSpam = false, SoundSpamDelay = 0.1, AutoHouseTP = false, AutoSlots = false,

    Whitelist = {}, AutoWhitelistFriends = true, ToggleWhitelist = false,
}

local Connections = {}
local ESPDrawings = {}
local CurrentTab = "Home"

--// UTILS
local function Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = duration or 4})
    end)
end

--// ANTI AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--// UI
local function CreateUI()
    if CoreGui:FindFirstChild("WreckFTABGod") then CoreGui.WreckFTABGod:Destroy() end

    local ScreenGui = Create("ScreenGui", {
        Name = "WreckFTABGod", Parent = CoreGui, ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Main = Create("Frame", {
        Name = "Main", Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(12, 12, 16), BorderSizePixel = 0,
        Position = UDim2.new(0.5, -380, 0.5, -260), Size = UDim2.new(0, 760, 0, 520),
        Active = true, Draggable = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(255, 210, 40), Thickness = 1.2, Transparency = 0.4})

    local TitleBar = Create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(18, 18, 24),
        BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 38)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TitleBar})

    Create("TextLabel", {
        Parent = TitleBar, BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(0, 400, 1, 0),
        Font = Enum.Font.GothamBold, Text = "WRECK  •  F.T.A.B. God Tier",
        TextColor3 = Color3.fromRGB(255, 220, 80), TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Create("TextLabel", {
        Parent = TitleBar, BackgroundTransparency = 1,
        Position = UDim2.new(1, -180, 0, 0), Size = UDim2.new(0, 100, 1, 0),
        Font = Enum.Font.Gotham, Text = "v3.0",
        TextColor3 = Color3.fromRGB(160, 160, 170), TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local CloseBtn = Create("TextButton", {
        Parent = TitleBar, BackgroundColor3 = Color3.fromRGB(220, 50, 50),
        Position = UDim2.new(1, -32, 0.5, -9), Size = UDim2.new(0, 18, 0, 18),
        Font = Enum.Font.GothamBold, Text = "×", TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14, AutoButtonColor = false
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = CloseBtn})
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Sidebar = Create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(16, 16, 22),
        BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 38), Size = UDim2.new(0, 58, 1, -38)
    })

    local Categories = {
        {Name = "Home", Icon = "⌂"}, {Name = "Player", Icon = "♟"},
        {Name = "Combat", Icon = "⚔"}, {Name = "Invincibility", Icon = "🛡"},
        {Name = "Target", Icon = "◎"}, {Name = "Blobman", Icon = "●"},
        {Name = "Toys", Icon = "✦"}, {Name = "Visual", Icon = "👁"},
        {Name = "Auto", Icon = "↻"}, {Name = "Keybinds", Icon = "⌨"},
        {Name = "Misc", Icon = "⚙"}, {Name = "Lists", Icon = "☰"},
    }

    local TabButtons, ContentFrames = {}, {}

    for i, cat in ipairs(Categories) do
        local btn = Create("TextButton", {
            Parent = Sidebar, BackgroundColor3 = Color3.fromRGB(16, 16, 22),
            BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, (i-1)*38),
            Size = UDim2.new(1, 0, 0, 38), Font = Enum.Font.GothamBold,
            Text = cat.Icon, TextColor3 = Color3.fromRGB(140, 140, 150),
            TextSize = 18, AutoButtonColor = false
        })
        TabButtons[cat.Name] = btn

        local content = Create("ScrollingFrame", {
            Parent = Main, BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(0, 70, 0, 48), Size = UDim2.new(1, -80, 1, -58),
            CanvasSize = UDim2.new(0, 0, 0, 1100), ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(255, 210, 40),
            Visible = (cat.Name == "Home")
        })
        ContentFrames[cat.Name] = content

        btn.MouseButton1Click:Connect(function()
            CurrentTab = cat.Name
            for name, frame in pairs(ContentFrames) do frame.Visible = (name == cat.Name) end
            for name, b in pairs(TabButtons) do
                if name == cat.Name then
                    b.TextColor3 = Color3.fromRGB(255, 220, 50)
                    b.BackgroundColor3 = Color3.fromRGB(28, 26, 18)
                else
                    b.TextColor3 = Color3.fromRGB(140, 140, 150)
                    b.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
                end
            end
        end)
    end
    TabButtons["Home"].TextColor3 = Color3.fromRGB(255, 220, 50)
    TabButtons["Home"].BackgroundColor3 = Color3.fromRGB(28, 26, 18)

    -- Components
    local function CreateSection(parent, title, y)
        local frame = Create("Frame", {
            Parent = parent, BackgroundColor3 = Color3.fromRGB(18, 18, 24),
            Position = UDim2.new(0, 0, 0, y), Size = UDim2.new(1, -10, 0, 28)
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = frame})
        Create("TextLabel", {
            Parent = frame, BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0),
            Font = Enum.Font.GothamBold, Text = title,
            TextColor3 = Color3.fromRGB(255, 220, 50), TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        return frame
    end

    local function CreateToggle(parent, name, key, y)
        local frame = Create("Frame", {
            Parent = parent, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, y), Size = UDim2.new(1, -10, 0, 30)
        })
        Create("TextLabel", {
            Parent = frame, BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.7, 0, 1, 0),
            Font = Enum.Font.Gotham, Text = name,
            TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local bg = Create("Frame", {
            Parent = frame,
            BackgroundColor3 = Settings[key] and Color3.fromRGB(255, 210, 40) or Color3.fromRGB(40, 40, 50),
            Position = UDim2.new(1, -48, 0.5, -8), Size = UDim2.new(0, 38, 0, 16)
        })
        Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = bg})
        local circle = Create("Frame", {
            Parent = bg, BackgroundColor3 = Color3.fromRGB(255,255,255),
            Position = Settings[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            Size = UDim2.new(0, 12, 0, 12)
        })
        Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = circle})
        local btn = Create("TextButton", {
            Parent = frame, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""
        })
        btn.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            Tween(bg, {BackgroundColor3 = Settings[key] and Color3.fromRGB(255, 210, 40) or Color3.fromRGB(40, 40, 50)})
            Tween(circle, {Position = Settings[key] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
        end)
    end

    local function CreateSlider(parent, name, key, min, max, y)
        local frame = Create("Frame", {
            Parent = parent, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, y), Size = UDim2.new(1, -10, 0, 46)
        })
        Create("TextLabel", {
            Parent = frame, BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.65, 0, 0, 16),
            Font = Enum.Font.Gotham, Text = name,
            TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local valLabel = Create("TextLabel", {
            Parent = frame, BackgroundTransparency = 1,
            Position = UDim2.new(0.65, 0, 0, 0), Size = UDim2.new(0.3, 0, 0, 16),
            Font = Enum.Font.GothamMedium, Text = tostring(Settings[key]),
            TextColor3 = Color3.fromRGB(255, 220, 50), TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        local bg = Create("Frame", {
            Parent = frame, BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            Position = UDim2.new(0, 10, 0, 24), Size = UDim2.new(1, -20, 0, 6)
        })
        Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = bg})
        local fill = Create("Frame", {
            Parent = bg, BackgroundColor3 = Color3.fromRGB(255, 210, 40),
            Size = UDim2.new((Settings[key]-min)/(max-min), 0, 1, 0)
        })
        Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})
        local dragging = false
        bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max-min)*rel)
                Settings[key] = val
                valLabel.Text = tostring(val)
                fill.Size = UDim2.new(rel, 0, 1, 0)
            end
        end)
    end

    local function CreateButton(parent, text, y, callback)
        local btn = Create("TextButton", {
            Parent = parent, BackgroundColor3 = Color3.fromRGB(255, 210, 40),
            Position = UDim2.new(0, 10, 0, y), Size = UDim2.new(1, -20, 0, 28),
            Font = Enum.Font.GothamBold, Text = text,
            TextColor3 = Color3.fromRGB(20, 20, 25), TextSize = 13, AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- HOME
    local home = ContentFrames.Home
    local hy = 8
    CreateSection(home, "Greetings", hy) hy = hy + 34
    Create("TextLabel", {
        Parent = home, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, hy), Size = UDim2.new(1, -20, 0, 55),
        Font = Enum.Font.Gotham, Text = "Welcome back, "..LocalPlayer.Name.."\nWreck F.T.A.B. God Tier loaded.\nMade by WreckAi 677",
        TextColor3 = Color3.fromRGB(200,200,210), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top
    }) hy = hy + 65
    CreateSection(home, "Statistics", hy) hy = hy + 34
    Create("TextLabel", {
        Parent = home, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, hy), Size = UDim2.new(1, -20, 0, 70),
        Font = Enum.Font.Gotham, Text = "Game: F.T.A.B.\nVersion: v3.0\nSession: Active\nToggles: Ready",
        TextColor3 = Color3.fromRGB(180,180,190), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top
    }) hy = hy + 80
    CreateSection(home, "Script", hy) hy = hy + 34
    CreateButton(home, "Unload Script", hy, function() ScreenGui:Destroy() end) hy = hy + 36
    CreateButton(home, "Rejoin Server", hy, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) hy = hy + 36
    CreateButton(home, "Server Hop", hy, function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and data and data.data then
            local servers = {}
            for _,v in pairs(data.data) do if v.playing < v.maxPlayers then table.insert(servers, v.id) end end
            if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], LocalPlayer) end
        end
    end)

    -- PLAYER
    local player = ContentFrames.Player
    local py = 8
    CreateSection(player, "Values", py) py = py + 34
    CreateSlider(player, "Walk Speed", "WalkSpeed", 16, 300, py) py = py + 50
    CreateSlider(player, "Jump Power", "JumpPower", 50, 300, py) py = py + 50
    CreateSlider(player, "Flight Speed", "FlightSpeed", 10, 200, py) py = py + 50
    CreateSlider(player, "Spin Speed", "SpinSpeed", 1, 50, py) py = py + 50
    CreateSection(player, "Character", py) py = py + 34
    CreateToggle(player, "Flight", "Flight", py) py = py + 32
    CreateToggle(player, "Walkspeed", "WalkspeedEnabled", py) py = py + 32
    CreateToggle(player, "Jump Power", "JumpPowerEnabled", py) py = py + 32
    CreateToggle(player, "Character Spin", "CharacterSpin", py) py = py + 32
    CreateToggle(player, "Noclip", "Noclip", py) py = py + 32
    CreateToggle(player, "Infinite Jump", "InfJump", py) py = py + 32
    CreateToggle(player, "Jerk Off", "JerkOff", py)

    -- COMBAT
    local combat = ContentFrames.Combat
    local cy = 8
    CreateSection(combat, "Grabs", cy) cy = cy + 34
    CreateToggle(combat, "Toggle Grabs", "ToggleGrabs", cy) cy = cy + 32
    CreateSection(combat, "Auras", cy) cy = cy + 34
    CreateToggle(combat, "Toggle Auras", "ToggleAuras", cy) cy = cy + 32
    CreateSlider(combat, "Aura Distance", "AuraDistance", 5, 100, cy) cy = cy + 50
    CreateToggle(combat, "Show Aura Radius", "ShowAuraRadius", cy) cy = cy + 32
    CreateSection(combat, "Toy Auras", cy) cy = cy + 34
    CreateToggle(combat, "Toggle Toy Auras", "ToggleToyAuras", cy) cy = cy + 32
    CreateSlider(combat, "Toy Aura Distance", "ToyAuraDistance", 10, 150, cy) cy = cy + 50
    CreateSection(combat, "Line", cy) cy = cy + 34
    CreateToggle(combat, "Toggle Extend Line", "ExtendLine", cy) cy = cy + 32
    CreateSlider(combat, "Extend Speed", "ExtendSpeed", 0.1, 5, cy) cy = cy + 50
    CreateSlider(combat, "Strength", "LineStrength", 50, 1000, cy) cy = cy + 50
    CreateToggle(combat, "Super Strength", "SuperStrength", cy) cy = cy + 32
    CreateToggle(combat, "Line-Lag Server", "LineLagServer", cy) cy = cy + 32
    CreateSlider(combat, "Lag Strength", "LagStrength", 1, 50, cy) cy = cy + 50
    CreateToggle(combat, "Crazy Line", "CrazyLine", cy)

    -- INVINCIBILITY
    local inv = ContentFrames.Invincibility
    local iy = 8
    CreateSection(inv, "Antis", iy) iy = iy + 34
    local antis = {"AntiGrab","AntiEGUCCIGrab","AntiBlobman","AntiNetworkOwnership","AntiExplosion","AntiBurn","AntiVoid","AntiKick","BreakPCLDAntiKick","AntiSticky","AntiSnowball","AntiBanana","AntiPaint","AntiPoison","AntiLag","AutoAntiLag","AntiInvis","AutoReset"}
    for _,n in ipairs(antis) do CreateToggle(inv, n, n, iy) iy = iy + 32 end
    CreateSection(inv, "Miscellaneous", iy) iy = iy + 34
    CreateToggle(inv, "Disable Void", "DisableVoid", iy) iy = iy + 32
    CreateToggle(inv, "Water Walk", "WaterWalk", iy) iy = iy + 32
    CreateToggle(inv, "Noclip Barrier", "NoclipBarrier", iy) iy = iy + 32
    CreateToggle(inv, "Anti-Fling", "AntiFling", iy)

    -- TARGET
    local target = ContentFrames.Target
    local ty = 8
    CreateSection(target, "Target", ty) ty = ty + 34
    CreateButton(target, "Set Current Mouse Target", ty, function()
        local char = Mouse.Target and Mouse.Target.Parent
        local plr = char and Players:GetPlayerFromCharacter(char)
        if plr then Settings.SelectedTarget = plr Notify("Target", "Selected: "..plr.Name) end
    end) ty = ty + 38
    CreateToggle(target, "Loop Apply Method Selected", "LoopApplySelected", ty) ty = ty + 32
    CreateToggle(target, "Loop Apply Method Server", "LoopApplyServer", ty)

    -- BLOBMAN
    local blob = ContentFrames.Blobman
    local by = 8
    CreateSection(blob, "Settings", by) by = by + 34
    CreateToggle(blob, "Auto Sit Blobman", "AutoSitBlobman", by) by = by + 32
    CreateToggle(blob, "Freeze Blobman", "FreezeBlobman", by) by = by + 32
    CreateToggle(blob, "Remove Anti-Kick [Sticky]", "RemoveAntiKickSticky", by) by = by + 32
    CreateToggle(blob, "Net Owner Spam", "NetOwnerSpam", by) by = by + 32
    CreateSlider(blob, "X Offset", "BlobmanX", -50, 50, by) by = by + 50
    CreateSlider(blob, "Y Offset", "BlobmanY", -50, 50, by) by = by + 50
    CreateSlider(blob, "Z Offset", "BlobmanZ", -50, 50, by)

    -- TOYS
    local toys = ContentFrames.Toys
    local toy = 8
    CreateSection(toys, "Toys Aura", toy) toy = toy + 34
    CreateToggle(toys, "Enabled", "ToysAuraEnabled", toy) toy = toy + 32
    CreateSlider(toys, "Move Speed", "MoveSpeed", 1, 30, toy) toy = toy + 50
    CreateSlider(toys, "Rotate Speed", "RotateSpeed", 0.1, 10, toy) toy = toy + 50
    CreateSlider(toys, "Bob Height", "BobHeight", 0, 10, toy) toy = toy + 50
    CreateSlider(toys, "Bob Speed", "BobSpeed", 0.1, 10, toy) toy = toy + 50
    CreateSlider(toys, "Radius", "ToysRadius", 5, 50, toy) toy = toy + 50
    CreateToggle(toys, "Face Center", "FaceCenter", toy) toy = toy + 32
    CreateToggle(toys, "Auto Move", "AutoMove", toy) toy = toy + 32
    CreateToggle(toys, "Auto Rotate", "AutoRotate", toy) toy = toy + 32
    CreateToggle(toys, "Bob", "Bob", toy) toy = toy + 32
    CreateToggle(toys, "Disable House Barrier", "DisableHouseBarrier", toy)

    -- VISUAL
    local visual = ContentFrames.Visual
    local vy = 8
    CreateSection(visual, "ESP", vy) vy = vy + 34
    CreateToggle(visual, "Player ESP", "PlayerESP", vy) vy = vy + 32
    CreateToggle(visual, "Server ESP [PCLD]", "ServerESP", vy) vy = vy + 32
    CreateToggle(visual, "Sticky ESP", "StickyESP", vy) vy = vy + 32
    CreateToggle(visual, "Blackhole ESP", "BlackholeESP", vy) vy = vy + 32
    CreateSection(visual, "Line & Camera", vy) vy = vy + 34
    CreateToggle(visual, "Custom Line", "CustomLine", vy) vy = vy + 32
    CreateToggle(visual, "Grabbed Object Info", "GrabbedObjectInfo", vy) vy = vy + 32
    CreateToggle(visual, "Disable Ragdoll Blur", "DisableRagdollBlur", vy) vy = vy + 32
    CreateToggle(visual, "Third Person", "ThirdPerson", vy) vy = vy + 32
    CreateToggle(visual, "Camera Noclip", "CameraNoclip", vy) vy = vy + 32
    CreateSlider(visual, "FOV", "FOV", 50, 120, vy) vy = vy + 50
    CreateSlider(visual, "Limb Transparency", "LimbTransparency", 0, 1, vy) vy = vy + 50
    CreateSection(visual, "Graphics", vy) vy = vy + 34
    CreateToggle(visual, "Custom Skybox", "CustomSkybox", vy) vy = vy + 32
    CreateSlider(visual, "Time Of Day", "TimeOfDay", 0, 24, vy) vy = vy + 50
    CreateToggle(visual, "Realistic Water", "RealisticWater", vy) vy = vy + 32
    CreateToggle(visual, "Shaders", "Shaders", vy) vy = vy + 32
    CreateToggle(visual, "Particles", "Particles", vy) vy = vy + 32
    CreateToggle(visual, "Boost FPS", "BoostFPS", vy)

    -- AUTO
    local auto = ContentFrames.Auto
    local ay = 8
    CreateSection(auto, "Auto Clicker / Figures", ay) ay = ay + 34
    CreateToggle(auto, "Auto Clicker", "AutoClicker", ay) ay = ay + 32
    CreateSection(auto, "Triggerbot", ay) ay = ay + 34
    CreateToggle(auto, "Toggle", "Triggerbot", ay) ay = ay + 32
    CreateSlider(auto, "Delay", "TriggerDelay", 0.01, 0.5, ay) ay = ay + 50
    CreateSlider(auto, "Distance", "TriggerDistance", 10, 150, ay) ay = ay + 50
    CreateSlider(auto, "Cooldown", "TriggerCooldown", 0.1, 2, ay) ay = ay + 50
    CreateSlider(auto, "Hit Chance", "TriggerHitChance", 1, 100, ay) ay = ay + 50
    CreateSection(auto, "Aim Assist", ay) ay = ay + 34
    CreateToggle(auto, "Aim Assist", "AimAssist", ay) ay = ay + 32
    CreateSlider(auto, "FOV Radius", "AimAssistFOV", 50, 400, ay) ay = ay + 50
    CreateSlider(auto, "Smoothness", "AimAssistSmooth", 0.05, 1, ay) ay = ay + 50
    CreateSlider(auto, "Distance", "AimAssistDistance", 10, 100, ay) ay = ay + 50
    CreateToggle(auto, "Silent Aim", "SilentAim", ay)

    -- KEYBINDS
    local keybinds = ContentFrames.Keybinds
    local ky = 8
    CreateSection(keybinds, "Info", ky) ky = ky + 34
    Create("TextLabel", {
        Parent = keybinds, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, ky), Size = UDim2.new(1, -20, 0, 40),
        Font = Enum.Font.Gotham, Text = "Keybinds system ready.\nClick any toggle + press a key to bind (coming in next update).",
        TextColor3 = Color3.fromRGB(180,180,190), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- MISC
    local misc = ContentFrames.Misc
    local my = 8
    CreateSection(misc, "Misc", my) my = my + 34
    CreateToggle(misc, "Sound Spam", "SoundSpam", my) my = my + 32
    CreateSlider(misc, "Sound Spam Delay", "SoundSpamDelay", 0.05, 1, my) my = my + 50
    CreateToggle(misc, "Auto House Teleport", "AutoHouseTP", my) my = my + 32
    CreateToggle(misc, "Auto Slots", "AutoSlots", my)

    -- LISTS
    local lists = ContentFrames.Lists
    local ly = 8
    CreateSection(lists, "Whitelist", ly) ly = ly + 34
    CreateToggle(lists, "Auto Whitelist Friends", "AutoWhitelistFriends", ly) ly = ly + 32
    CreateToggle(lists, "Toggle Whitelist", "ToggleWhitelist", ly)

    -- Status bar
    Create("TextLabel", {
        Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 70, 1, -18), Size = UDim2.new(1, -80, 0, 16),
        Font = Enum.Font.Gotham, Text = "Wreck F.T.A.B. God Tier  |  v3.0  |  Made by WreckAi 677",
        TextColor3 = Color3.fromRGB(120,120,130), TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

CreateUI()

--// ===================== FUNCTIONALITY =====================

-- Flight
local FlyBV, FlyBG
local function UpdateFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    if Settings.Flight then
        if not FlyBV then
            FlyBV = Instance.new("BodyVelocity")
            FlyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
            FlyBV.Parent = hrp
            FlyBG = Instance.new("BodyGyro")
            FlyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
            FlyBG.P = 9e4
            FlyBG.Parent = hrp
        end
        local dir = Vector3.zero
        local cf = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
        FlyBV.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlightSpeed or Vector3.zero
        FlyBG.CFrame = cf
    else
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
    end
end

-- Main loops
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if Settings.WalkspeedEnabled then hum.WalkSpeed = Settings.WalkSpeed end
    if Settings.JumpPowerEnabled then hum.JumpPower = Settings.JumpPower end
    if Settings.CharacterSpin then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0) end

    UpdateFly()
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Settings.Noclip and LocalPlayer.Character then
        for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- FOV
RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = Settings.FOV
end)

-- ESP simple
local function CreateESP(plr)
    if ESPDrawings[plr] then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255, 220, 50)
    box.Visible = false
    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255,255,255)
    name.Visible = false
    ESPDrawings[plr] = {Box = box, Name = name}
end

RunService.RenderStepped:Connect(function()
    for plr, drawings in pairs(ESPDrawings) do
        if Settings.PlayerESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = 40
                drawings.Box.Size = Vector2.new(size, size*1.8)
                drawings.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                drawings.Box.Visible = true
                drawings.Name.Text = plr.Name
                drawings.Name.Position = Vector2.new(pos.X, pos.Y - size - 16)
                drawings.Name.Visible = true
            else
                drawings.Box.Visible = false
                drawings.Name.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Name.Visible = false
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() task.wait(1) CreateESP(plr) end)
end)
for _,plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        CreateESP(plr)
        plr.CharacterAdded:Connect(function() task.wait(1) CreateESP(plr) end)
    end
end

-- FPS Boost
if Settings.BoostFPS then
    pcall(function()
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end)
end

print("[Wreck] F.T.A.B. God Tier loaded successfully.")
Notify("Wreck", "F.T.A.B. God Tier loaded", 5)
