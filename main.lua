--[[
    Wreck F.T.A.B. Premium
    UI : NovaUI (provided by user)
    Made by WreckAi 677
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
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Real F.T.A.B. Remotes
local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
local CreateGrabLine = GrabEvents and GrabEvents:FindFirstChild("CreateGrabLine")
local ExtendGrabLine = GrabEvents and GrabEvents:FindFirstChild("ExtendGrabLine")
local DestroyGrabLine = GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine")
local SetNetworkOwner = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")

--// ===================== NOVA UI LIBRARY =====================
local Theme = {
	Bg = Color3.fromRGB(14, 15, 20),
	Panel = Color3.fromRGB(20, 22, 30),
	Item = Color3.fromRGB(28, 31, 42),
	Stroke = Color3.fromRGB(45, 49, 64),
	Text = Color3.fromRGB(235, 237, 245),
	Sub = Color3.fromRGB(140, 146, 165),
	Accent = Color3.fromRGB(110, 120, 255),
	Off = Color3.fromRGB(52, 56, 72),
}

local function new(class, props, children)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	for _, c in ipairs(children or {}) do c.Parent = o end
	return o
end

local function tween(o, props, t)
	TweenService:Create(o, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
local function stroke(c, th)
	return new("UIStroke", {Color = c, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end

local NovaUI = {}
NovaUI.__index = NovaUI

function NovaUI.new(title, toggleKey)
	local self = setmetatable({Tabs = {}, Current = nil}, NovaUI)
	toggleKey = toggleKey or Enum.KeyCode.RightShift

	local gui = new("ScreenGui", {
		Name = "NovaUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = game:GetService("CoreGui"),
	})
	self.Gui = gui

	local main = new("Frame", {
		Size = UDim2.fromOffset(620, 420),
		Position = UDim2.new(0.5, -310, 0.5, -210),
		BackgroundColor3 = Theme.Bg,
		BorderSizePixel = 0,
		Parent = gui,
	}, {corner(14), stroke(Theme.Stroke)})
	self.Main = main

	local scale = new("UIScale", {Scale = 0.9, Parent = main})
	tween(scale, {Scale = 1}, 0.25)

	local bar = new("Frame", {
		Size = UDim2.new(1, 0, 0, 46),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		Parent = main,
	}, {corner(14)})

	new("Frame", {
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 1, -14),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		Parent = bar,
	})

	new("Frame", {
		Size = UDim2.fromOffset(8, 8),
		Position = UDim2.new(0, 16, 0.5, -4),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Parent = bar,
	}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})

	new("TextLabel", {
		Size = UDim2.new(1, -120, 1, 0),
		Position = UDim2.fromOffset(32, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = title or "NovaUI",
		TextColor3 = Theme.Text,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = bar,
	})

	local close = new("TextButton", {
		Size = UDim2.fromOffset(26, 26),
		Position = UDim2.new(1, -38, 0.5, -13),
		BackgroundColor3 = Theme.Item,
		Text = "×",
		Font = Enum.Font.GothamBold,
		TextColor3 = Theme.Sub,
		TextSize = 18,
		AutoButtonColor = false,
		Parent = bar,
	}, {corner(8)})

	close.MouseEnter:Connect(function()
		tween(close, {BackgroundColor3 = Color3.fromRGB(220, 70, 80), TextColor3 = Theme.Text})
	end)
	close.MouseLeave:Connect(function()
		tween(close, {BackgroundColor3 = Theme.Item, TextColor3 = Theme.Sub})
	end)
	close.MouseButton1Click:Connect(function()
		self:SetVisible(false)
	end)

	local dragging, dragStart, startPos
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPos = true, i.Position, main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	self.Sidebar = new("Frame", {
		Size = UDim2.new(0, 150, 1, -46),
		Position = UDim2.fromOffset(0, 46),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		Parent = main,
	}, {
		new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}),
		new("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
	})

	self.Pages = new("Frame", {
		Size = UDim2.new(1, -166, 1, -62),
		Position = UDim2.fromOffset(158, 54),
		BackgroundTransparency = 1,
		Parent = main,
	})

	UserInputService.InputBegan:Connect(function(i, processed)
		if not processed and i.KeyCode == toggleKey then
			self:SetVisible(not main.Visible)
		end
	end)

	self.NotifHolder = new("Frame", {
		Size = UDim2.new(0, 260, 1, -20),
		Position = UDim2.new(1, -270, 0, 10),
		BackgroundTransparency = 1,
		Parent = gui,
	}, {
		new("UIListLayout", {
			Padding = UDim.new(0, 8),
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	})

	return self
end

function NovaUI:SetVisible(v)
	self.Main.Visible = v
end

function NovaUI:Notify(text, duration)
	local n = new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = Theme.Panel,
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextColor3 = Theme.Text,
		TextSize = 13,
		BackgroundTransparency = 1,
		TextTransparency = 1,
		Parent = self.NotifHolder,
	}, {corner(10), stroke(Theme.Accent)})
	tween(n, {BackgroundTransparency = 0, TextTransparency = 0}, 0.25)
	task.delay(duration or 3, function()
		tween(n, {BackgroundTransparency = 1, TextTransparency = 1}, 0.25)
		Debris:AddItem(n, 0.3)
	end)
end

function NovaUI:AddTab(name)
	local tab = {Window = self}
	local btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Theme.Panel,
		Text = "   " .. name,
		Font = Enum.Font.GothamMedium,
		TextColor3 = Theme.Sub,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		LayoutOrder = #self.Tabs + 1,
		Parent = self.Sidebar,
	}, {corner(8)})

	local mark = new("Frame", {
		Size = UDim2.new(0, 3, 0.55, 0),
		Position = UDim2.new(0, 0, 0.225, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Visible = false,
		Parent = btn,
	}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})

	local page = new("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Accent,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		Visible = false,
		Parent = self.Pages,
	}, {
		new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}),
		new("UIPadding", {PaddingRight = UDim.new(0, 8)}),
	})

	tab.Page, tab.Button, tab.Mark = page, btn, mark

	function tab:Select()
		for _, t in ipairs(self.Window.Tabs) do
			local on = (t == self)
			t.Page.Visible = on
			t.Mark.Visible = on
			tween(t.Button, {
				BackgroundColor3 = on and Theme.Item or Theme.Panel,
				TextColor3 = on and Theme.Text or Theme.Sub
			})
		end
	end

	btn.MouseButton1Click:Connect(function() tab:Select() end)
	btn.MouseEnter:Connect(function()
		if not page.Visible then tween(btn, {BackgroundColor3 = Theme.Item}) end
	end)
	btn.MouseLeave:Connect(function()
		if not page.Visible then tween(btn, {BackgroundColor3 = Theme.Panel}) end
	end)

	local order = 0
	local function nextOrder()
		order += 1
		return order
	end

	function tab:AddSection(text)
		new("TextLabel", {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			Text = string.upper(text),
			Font = Enum.Font.GothamBold,
			TextColor3 = Theme.Accent,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = nextOrder(),
			Parent = page,
		})
	end

	function tab:AddLabel(text)
		new("TextLabel", {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = text,
			Font = Enum.Font.Gotham,
			TextColor3 = Theme.Sub,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = nextOrder(),
			Parent = page,
		})
	end

	local function row(h)
		return new("Frame", {
			Size = UDim2.new(1, 0, 0, h),
			BackgroundColor3 = Theme.Item,
			BorderSizePixel = 0,
			LayoutOrder = nextOrder(),
			Parent = page,
		}, {corner(10)})
	end

	function tab:AddToggle(name, default, callback)
		local state = default and true or false
		local r = row(40)
		new("TextLabel", {
			Size = UDim2.new(1, -70, 1, 0),
			Position = UDim2.fromOffset(14, 0),
			BackgroundTransparency = 1,
			Text = name,
			Font = Enum.Font.Gotham,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = r,
		})
		local sw = new("Frame", {
			Size = UDim2.fromOffset(40, 22),
			Position = UDim2.new(1, -54, 0.5, -11),
			BackgroundColor3 = state and Theme.Accent or Theme.Off,
			Parent = r,
		}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})
		local knob = new("Frame", {
			Size = UDim2.fromOffset(16, 16),
			Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = sw,
		}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})
		local hit = new("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			Parent = r
		})
		local obj = {}
		function obj:Set(v, silent)
			state = v
			tween(sw, {BackgroundColor3 = v and Theme.Accent or Theme.Off})
			tween(knob, {Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
			if callback and not silent then task.spawn(callback, v) end
		end
		function obj:Get() return state end
		hit.MouseButton1Click:Connect(function() obj:Set(not state) end)
		return obj
	end

	function tab:AddSlider(name, min, max, default, callback)
		local value = math.clamp(default or min, min, max)
		local r = row(54)
		new("TextLabel", {
			Size = UDim2.new(0.7, 0, 0, 26),
			Position = UDim2.fromOffset(14, 2),
			BackgroundTransparency = 1,
			Text = name,
			Font = Enum.Font.Gotham,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = r,
		})
		local val = new("TextLabel", {
			Size = UDim2.new(0.3, -14, 0, 26),
			Position = UDim2.new(0.7, 0, 0, 2),
			BackgroundTransparency = 1,
			Text = tostring(value),
			Font = Enum.Font.GothamBold,
			TextColor3 = Theme.Accent,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = r,
		})
		local track = new("Frame", {
			Size = UDim2.new(1, -28, 0, 6),
			Position = UDim2.new(0, 14, 0, 36),
			BackgroundColor3 = Theme.Off,
			Parent = r,
		}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})
		local fill = new("Frame", {
			Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
			BackgroundColor3 = Theme.Accent,
			Parent = track,
		}, {new("UICorner", {CornerRadius = UDim.new(1, 0)})})
		local function setFromX(x)
			local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			value = math.floor(min + (max - min) * rel + 0.5)
			val.Text = tostring(value)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			if callback then callback(value) end
		end
		local dragging = false
		track.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromX(i.Position.X)
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				setFromX(i.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		return {Get = function() return value end}
	end

	function tab:AddButton(name, callback)
		local b = new("TextButton", {
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Theme.Accent,
			Text = name,
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 13,
			AutoButtonColor = false,
			LayoutOrder = nextOrder(),
			Parent = page,
		}, {corner(10)})
		b.MouseEnter:Connect(function()
			tween(b, {BackgroundColor3 = Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.15)})
		end)
		b.MouseLeave:Connect(function()
			tween(b, {BackgroundColor3 = Theme.Accent})
		end)
		b.MouseButton1Click:Connect(function()
			if callback then task.spawn(callback) end
		end)
	end

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then tab:Select() end
	return tab
end

--// ===================== SETTINGS & LOGIC =====================
local Settings = {
	Flight = false,
	FlightSpeed = 60,
	SpeedEnabled = false,
	WalkSpeed = 16,
	JumpEnabled = false,
	JumpPower = 50,
	Noclip = false,
	InfJump = false,
	SuperStrength = false,
	StrengthValue = 800,
	ExtendLine = false,
	ExtendMultiplier = 5,
	GrabAura = false,
	AuraRange = 30,
	KickAura = false,
	FlingAura = false,
	FlingPower = 400,
	AntiGrab = false,
	AntiBlobman = false,
	AntiKick = false,
	AntiFling = false,
	AntiVoid = false,
	GodMode = false,
	ESP = false,
	Fullbright = false,
	FOV = 70,
}

local BodyVelocity, BodyGyro
local ESPObjects = {}

-- Anti AFK
LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

--// Create UI
local ui = NovaUI.new("Wreck  •  F.T.A.B. Premium", Enum.KeyCode.RightShift)

-- PLAYER TAB
local playerTab = ui:AddTab("Player")
playerTab:AddSection("Movement")
playerTab:AddToggle("Flight", false, function(v) Settings.Flight = v end)
playerTab:AddSlider("Flight Speed", 20, 150, 60, function(v) Settings.FlightSpeed = v end)
playerTab:AddToggle("Speed", false, function(v) Settings.SpeedEnabled = v end)
playerTab:AddSlider("Walk Speed", 16, 200, 16, function(v) Settings.WalkSpeed = v end)
playerTab:AddToggle("Jump Power", false, function(v) Settings.JumpEnabled = v end)
playerTab:AddSlider("Jump Power Value", 50, 200, 50, function(v) Settings.JumpPower = v end)
playerTab:AddToggle("Noclip", false, function(v) Settings.Noclip = v end)
playerTab:AddToggle("Infinite Jump", false, function(v) Settings.InfJump = v end)

-- COMBAT TAB
local combatTab = ui:AddTab("Combat")
combatTab:AddSection("Strength & Line")
combatTab:AddToggle("Super Strength", false, function(v) Settings.SuperStrength = v end)
combatTab:AddSlider("Strength Value", 100, 2000, 800, function(v) Settings.StrengthValue = v end)
combatTab:AddToggle("Extend Line", false, function(v) Settings.ExtendLine = v end)
combatTab:AddSlider("Extend Multiplier", 1, 20, 5, function(v) Settings.ExtendMultiplier = v end)
combatTab:AddSection("Auras")
combatTab:AddToggle("Grab Aura", false, function(v) Settings.GrabAura = v end)
combatTab:AddSlider("Aura Range", 10, 80, 30, function(v) Settings.AuraRange = v end)
combatTab:AddToggle("Kick Aura", false, function(v) Settings.KickAura = v end)
combatTab:AddToggle("Fling Aura", false, function(v) Settings.FlingAura = v end)
combatTab:AddSlider("Fling Power", 200, 1500, 400, function(v) Settings.FlingPower = v end)

-- DEFENSE TAB
local defenseTab = ui:AddTab("Defense")
defenseTab:AddSection("Protections")
defenseTab:AddToggle("Anti Grab", false, function(v) Settings.AntiGrab = v end)
defenseTab:AddToggle("Anti Blobman", false, function(v) Settings.AntiBlobman = v end)
defenseTab:AddToggle("Anti Kick", false, function(v) Settings.AntiKick = v end)
defenseTab:AddToggle("Anti Fling", false, function(v) Settings.AntiFling = v end)
defenseTab:AddToggle("Anti Void", false, function(v) Settings.AntiVoid = v end)
defenseTab:AddToggle("God Mode", false, function(v) Settings.GodMode = v end)

-- VISUALS TAB
local visualsTab = ui:AddTab("Visuals")
visualsTab:AddSection("ESP & Camera")
visualsTab:AddToggle("Player ESP", false, function(v) Settings.ESP = v end)
visualsTab:AddToggle("Fullbright", false, function(v) Settings.Fullbright = v end)
visualsTab:AddSlider("FOV", 50, 120, 70, function(v)
	Settings.FOV = v
	Camera.FieldOfView = v
end)

-- MISC TAB
local miscTab = ui:AddTab("Misc")
miscTab:AddSection("Server")
miscTab:AddButton("Rejoin Server", function()
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
miscTab:AddButton("Server Hop", function()
	local ok, data = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	end)
	if ok and data and data.data then
		local list = {}
		for _, s in pairs(data.data) do
			if s.playing < s.maxPlayers then
				table.insert(list, s.id)
			end
		end
		if #list > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, list[math.random(1, #list)], LocalPlayer)
		end
	end
end)
miscTab:AddLabel("Toggle UI : RightShift")

ui:Notify("Wreck F.T.A.B. Premium loaded", 4)

--// ===================== WORKING FEATURES =====================

-- Flight
RunService.RenderStepped:Connect(function()
	if Settings.Flight then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
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

-- Speed / Jump / God
RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	if Settings.SpeedEnabled then
		hum.WalkSpeed = Settings.WalkSpeed
	end
	if Settings.JumpEnabled then
		hum.JumpPower = Settings.JumpPower
	end
	if Settings.GodMode then
		hum.Health = hum.MaxHealth
	end
end)

-- Noclip
RunService.Stepped:Connect(function()
	if Settings.Noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
	if Settings.InfJump then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Extend Line (real remote)
task.spawn(function()
	while true do
		if Settings.ExtendLine and ExtendGrabLine then
			pcall(function()
				ExtendGrabLine:FireServer(Settings.ExtendMultiplier * 50)
			end)
		end
		task.wait(0.1)
	end
end)

-- Grab Aura (real remote)
task.spawn(function()
	while true do
		if Settings.GrabAura and CreateGrabLine then
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				for _, plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
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
		task.wait(0.15)
	end
end)

-- Fullbright
RunService.Heartbeat:Connect(function()
	if Settings.Fullbright then
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
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
	ESPObjects[plr] = {Box = box, Name = name}
end

RunService.RenderStepped:Connect(function()
	for plr, drawings in pairs(ESPObjects) do
		if Settings.ESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
			if onScreen then
				local size = 36
				drawings.Box.Size = Vector2.new(size, size * 1.7)
				drawings.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
				drawings.Box.Visible = true
				drawings.Name.Text = plr.Name
				drawings.Name.Position = Vector2.new(pos.X, pos.Y - size - 15)
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

print("[Wreck] F.T.A.B. Premium + NovaUI loaded")
