-- Effets visuels et sonores côté client (légers : priorité aux téléphones d'entrée de gamme).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Net = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Net"))

local CameraRig = require(script.Parent.CameraRig)
local Animator = require(script.Parent.Animator)

local Fx = {}
Fx.onBanner = nil :: ((text: string, color: Color3?, dur: number?) -> ())?
Fx.onBlackout = nil :: ((dur: number) -> ())?

local SOUNDS = {
	hit = "rbxasset://sounds/swordslash.wav",
	heavy = "rbxasset://sounds/swordlunge.wav",
	ko = "rbxasset://sounds/uuhhh.mp3",
	ping = "rbxasset://sounds/electronicpingshort.wav",
}

local function play(name: string, volume: number?)
	local id = SOUNDS[name]
	if not id then
		return
	end
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = volume or 0.5
	s.PlaybackSpeed = 0.9 + math.random() * 0.25
	s.Parent = SoundService
	s:Play()
	s.Ended:Once(function()
		s:Destroy()
	end)
	task.delay(4, function()
		if s.Parent then
			s:Destroy()
		end
	end)
end

local function folder(): Instance
	return workspace:FindFirstChild("Fx") or workspace
end

local function blob(pos: Vector3, size: number, color: Color3, dur: number, grow: number, shape: Enum.PartType?)
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
	p.Shape = shape or Enum.PartType.Ball
	p.Material = Enum.Material.Neon
	p.Color = color
	p.Size = Vector3.one * size
	p.CFrame = CFrame.new(pos)
	p.Transparency = 0.15
	p.Parent = folder()
	local tw = TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.one * size * grow,
		Transparency = 1,
	})
	tw:Play()
	tw.Completed:Once(function()
		p:Destroy()
	end)
	return p
end

local function ring(pos: Vector3, radius: number, color: Color3, dur: number)
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
	p.Shape = Enum.PartType.Cylinder
	p.Material = Enum.Material.Neon
	p.Color = color
	p.Size = Vector3.new(0.3, 1, 1)
	p.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(90), 0)
	p.Transparency = 0.35
	p.Parent = folder()
	local tw = TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(0.3, radius * 2, radius * 2),
		Transparency = 1,
	})
	tw:Play()
	tw.Completed:Once(function()
		p:Destroy()
	end)
end

local function bubble(pos: Vector3, text: string, color: Color3)
	local a = Instance.new("Part")
	a.Anchored, a.CanCollide, a.CanQuery, a.CanTouch, a.Transparency = true, false, false, false, 1
	a.Size = Vector3.one
	a.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
	a.Parent = folder()
	local g = Instance.new("BillboardGui")
	g.Size = UDim2.fromOffset(220, 60)
	g.AlwaysOnTop = true
	g.Adornee = a
	local t = Instance.new("TextLabel")
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.FredokaOne
	t.TextScaled = true
	t.TextColor3 = color
	t.TextStrokeTransparency = 0
	t.Text = text
	t.Parent = g
	g.Parent = a
	TweenService:Create(a, TweenInfo.new(0.8), { CFrame = a.CFrame + Vector3.new(0, 3, 0) }):Play()
	TweenService:Create(t, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	task.delay(0.85, function()
		a:Destroy()
	end)
end

local crowdBase: { [BasePart]: CFrame } = {}
local cheerUntil = 0

local function crowd(dt: number)
	local arena = workspace:FindFirstChild("Arena")
	local c = arena and arena:FindFirstChild("Decor") and arena.Decor:FindFirstChild("Crowd")
	if not c then
		return
	end
	local t = os.clock()
	local amp = if t < cheerUntil then 1.4 else 0.25
	for _, p in c:GetChildren() do
		if p:IsA("BasePart") then
			local base = crowdBase[p]
			if not base then
				base = p.CFrame
				crowdBase[p] = base
			end
			local ph = p:GetAttribute("CrowdPhase") or 0
			p.CFrame = base + Vector3.new(0, math.abs(math.sin(t * (if t < cheerUntil then 9 else 3) + ph)) * amp, 0)
		end
	end
	local _ = dt
end

function Fx.start()
	local ToClient = Net.get("ToClient")
	ToClient.OnClientEvent:Connect(function(kind, a, b, c, d, e)
		if kind == "Move" then
			if a and a.Parent then
				Animator.play(a, b)
			end
		elseif kind == "Victory" then
			if a then
				Animator.victory(a)
			end
			cheerUntil = os.clock() + 6
		elseif kind == "Fx" then
			local what = a
			if what == "hit" then
				local pos, force, heavy, col = b, c or 10, d, e
				local color = if col then Color3.fromHex(col) else Color3.new(1, 1, 1)
				blob(pos, 1.5 + force / 45, Color3.new(1, 1, 1):Lerp(color, 0.4), 0.22, 2.2)
				if heavy then
					ring(pos, 3 + force / 25, color, 0.35)
					CameraRig.shake(math.clamp(force / 60, 0.3, 2.2))
					play("heavy", 0.6)
				else
					play("hit", 0.35)
				end
			elseif what == "aura" then
				local pos, radius, col = b, c or 5, d
				ring(pos, radius, if col then Color3.fromHex(col) else Color3.new(1, 1, 1), 0.4)
			elseif what == "ko" then
				local pos, col, name = b, c, d
				local color = if col then Color3.fromHex(col) else Color3.new(1, 1, 1)
				blob(pos, 8, color, 0.6, 5)
				ring(pos, 30, Color3.new(1, 1, 1), 0.7)
				CameraRig.shake(3)
				cheerUntil = os.clock() + 2.5
				play("ko", 0.8)
				if Fx.onBanner then
					Fx.onBanner("KO ! " .. tostring(name or ""), color, 1.6)
				end
			elseif what == "warn" then
				local text, pos = b, c
				play("ping", 0.6)
				if Fx.onBanner then
					Fx.onBanner("⚠ " .. tostring(text), Color3.fromRGB(255, 200, 40), 2)
				end
				if typeof(pos) == "Vector3" then
					bubble(pos + Vector3.new(0, 2, 0), "⚠", Color3.fromRGB(255, 200, 40))
				end
			elseif what == "counter" then
				ring(b, 6, Color3.new(1, 1, 1), 0.3)
				bubble(b, "CONTRE !", Color3.new(1, 1, 1))
			elseif what == "counterReady" then
				blob(b, 4, Color3.fromRGB(230, 240, 255), 0.5, 1.4)
			elseif what == "absorb" then
				ring(b, 4, Color3.fromRGB(40, 60, 80), 0.3)
			elseif what == "sneeze" then
				bubble(b, "ATCHOUM !", Color3.fromRGB(160, 230, 160))
			elseif what == "pickup" then
				blob(b, 3, Color3.fromRGB(255, 214, 10), 0.4, 2.5)
				bubble(b, "ARME !", Color3.fromRGB(255, 214, 10))
				play("ping", 0.5)
			elseif what == "vacuum" then
				local m = b
				local hrp = m and m:FindFirstChild("HumanoidRootPart")
				if hrp then
					ring(hrp.Position, 9, Color3.fromRGB(30, 40, 60), c or 0.6)
				end
			elseif what == "blackout" then
				if Fx.onBlackout then
					Fx.onBlackout(b or 1)
				end
			end
		end
	end)
	RunService.Heartbeat:Connect(crowd)
end

return Fx
