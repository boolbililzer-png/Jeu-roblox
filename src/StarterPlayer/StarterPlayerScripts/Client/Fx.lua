-- Effets visuels et sonores, tous calculés sur le client :
-- traînées, onomatopées façon BD, impacts, projectiles, objets qui apparaissent, statuts, flash de Super,
-- recharge d'énergie (aura + petits effets propres à chaque perso).
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("Config"))
local CharacterList = require(Shared:WaitForChild("CharacterList"))
local Items = require(Shared:WaitForChild("Items"))
local Animator = require(script.Parent:WaitForChild("Animator"))
local CameraRig = require(script.Parent:WaitForChild("CameraRig"))

local Fx = {}

local TEX_SPARK = "rbxasset://textures/particles/sparkles_main.dds"
local TEX_FIRE = "rbxasset://textures/particles/fire_main.dds"
local TEX_SMOKE = "rbxasset://textures/particles/smoke_main.dds"
local SOUND_SWOOSH = "rbxasset://sounds/swoosh.wav"
local SOUND_HIT = "rbxasset://sounds/action_jump_land.mp3"
local SOUND_SPLASH = "rbxasset://sounds/impact_water.mp3"

local SODA = Color3.fromRGB(170, 230, 60)
local YELLOW = Color3.fromRGB(255, 225, 60)
local ENERGY = Color3.fromRGB(110, 210, 255)

local folder = Instance.new("Folder")
folder.Name = "EffetsLocaux"
folder.Parent = workspace

local screenGui -- flash et bandeau des Supers

------------------------------------------------------------------------ Outils
local function tween(instance, duration, props, style, direction)
	local t = TweenService:Create(instance, TweenInfo.new(duration, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function cleanup(instance, delay)
	task.delay(delay, function()
		if instance then
			instance:Destroy()
		end
	end)
end

local function part(props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Material = Enum.Material.Neon
	for k, v in pairs(props) do
		p[k] = v
	end
	p.Parent = folder
	return p
end

local function playSound(id, parent, volume, pitch)
	if not Config.SOUNDS then
		return
	end
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = volume or 0.5
	s.PlaybackSpeed = pitch or 1
	s.Parent = parent or folder
	s:Play()
	cleanup(s, 3)
end

local function facingOf(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	return (root and root.CFrame.LookVector.X < 0) and -1 or 1
end

-- Quand l'animation est en miroir (perso tourné vers la gauche), la main « droite » de l'animation est
-- la main gauche du modèle, et les objets sont ceux de l'exemplaire « _M »
local function partOf(model, name)
	if Animator.isMirrored(model) then
		if string.find(name, "Right") then
			name = (string.gsub(name, "Right", "Left"))
		elseif string.find(name, "Left") then
			name = (string.gsub(name, "Left", "Right"))
		elseif string.sub(name, 1, 4) == "Prop" then
			name ..= "_M"
		end
	end
	return model:FindFirstChild(name, true)
end

-- Onomatopée façon bande dessinée qui jaillit puis s'efface
function Fx.popText(position, text, color, scale, duration)
	if not text or text == "" then
		return
	end
	scale = scale or 1
	duration = duration or 0.8
	local anchor = part({ Size = Vector3.new(0.1, 0.1, 0.1), Transparency = 1, Position = position })
	local gui = Instance.new("BillboardGui")
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	gui.Size = UDim2.fromScale(1.5 * scale, 0.6 * scale)
	gui.Parent = anchor
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.LuckiestGuy
	label.TextColor3 = color or YELLOW
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.Rotation = math.random(-12, 12)
	label.Parent = gui
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Color = Color3.new(0, 0, 0)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	stroke.Parent = label
	local width = math.clamp(#text * 1.1, 4, 14) * scale
	tween(gui, 0.15, { Size = UDim2.fromScale(width, 2.6 * scale) }, Enum.EasingStyle.Back)
	tween(anchor, duration, { Position = position + Vector3.new(0, 2.5, 0) })
	task.delay(duration * 0.6, function()
		tween(label, duration * 0.4, { TextTransparency = 1, TextStrokeTransparency = 1 })
		tween(stroke, duration * 0.4, { Transparency = 1 })
	end)
	cleanup(anchor, duration + 0.1)
end

-- Éclat d'impact : boule lumineuse qui gonfle + éclats en étoile
function Fx.burst(position, color, size)
	size = size or 2
	local ball = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(0.5, 0.5, 0.5), Color = color, Position = position, Transparency = 0.1 })
	tween(ball, 0.2, { Size = Vector3.new(size, size, size), Transparency = 1 })
	cleanup(ball, 0.25)
	for i = 1, 6 do
		local angle = (i / 6) * math.pi * 2 + math.random()
		local dir = Vector3.new(math.cos(angle), math.sin(angle), 0)
		local shard = part({ Size = Vector3.new(0.25, 0.25, size * 0.5), Color = YELLOW, CFrame = CFrame.lookAt(position, position + dir) })
		tween(shard, 0.22, { CFrame = CFrame.lookAt(position + dir * size * 1.4, position + dir * size * 3), Size = Vector3.new(0.05, 0.05, 0.1) })
		cleanup(shard, 0.25)
	end
end

-- Onde de choc : disque face caméra qui s'agrandit
function Fx.ring(position, color, radius, duration)
	local disc = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.1, 0.5, 0.5), Color = color, Transparency = 0.3, CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), 0) })
	tween(disc, duration or 0.35, { Size = Vector3.new(0.1, radius * 2, radius * 2), Transparency = 1 })
	cleanup(disc, (duration or 0.35) + 0.05)
end

function Fx.flash(model)
	local h = Instance.new("Highlight")
	h.FillColor = Color3.new(1, 1, 1)
	h.FillTransparency = 0.2
	h.OutlineTransparency = 1
	h.DepthMode = Enum.HighlightDepthMode.Occluded
	h.Parent = model
	cleanup(h, 0.09)
end

-- Traînée lumineuse derrière une partie du corps ou un objet
-- Arc de frappe (« smear » façon Brawlhalla) : un ruban blanc, épais et lumineux, qui suit le membre ou l'arme
-- pendant la frappe puis s'efface très vite. tip = 2e pièce optionnelle (ex. la main au bout de l'avant-bras) :
-- le ruban va alors du haut de target jusqu'au bout de tip.
local function trailOn(target, color, duration, a0, a1, tip)
	if not target then
		return
	end
	local att0 = a0
	local att1 = a1
	if not att0 then
		att0 = Instance.new("Attachment")
		att0.Position = Vector3.new(0, target.Size.Y * 0.5, 0)
		att0.Parent = target
		att1 = Instance.new("Attachment")
		if tip then
			att1.Position = Vector3.new(0, -tip.Size.Y * 0.6, 0)
			att1.Parent = tip
		else
			att1.Position = Vector3.new(0, -target.Size.Y * 0.5, 0)
			att1.Parent = target
		end
		cleanup(att0, duration + 0.4)
		cleanup(att1, duration + 0.4)
	end
	local trail = Instance.new("Trail")
	trail.Attachment0 = att0
	trail.Attachment1 = att1
	trail.Lifetime = 0.16
	trail.MinLength = 0
	trail.Color = ColorSequence.new(Color3.new(1, 1, 1), color)
	trail.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.05),
		NumberSequenceKeypoint.new(0.5, 0.45),
		NumberSequenceKeypoint.new(1, 1),
	})
	trail.WidthScale = NumberSequence.new(1, 0.35)
	trail.LightEmission = 1
	trail.LightInfluence = 0
	trail.FaceCamera = true
	trail.Parent = target
	task.delay(duration, function()
		trail.Enabled = false
	end)
	cleanup(trail, duration + 0.3)
end

function Fx.trail(model, kind, duration)
	local color = Color3.new(1, 1, 1)
	if kind == "bottle" then
		local body = partOf(model, "PropBottle")
		body = body and body:FindFirstChild("Corps")
		if body then
			trailOn(body, SODA, duration, body:FindFirstChild("TrailA"), body:FindFirstChild("TrailB"))
		end
	elseif kind == "rightFoot" then
		trailOn(partOf(model, "RightLowerLeg"), color, duration, nil, nil, partOf(model, "RightFoot"))
	elseif kind == "leftFoot" then
		trailOn(partOf(model, "LeftLowerLeg"), color, duration, nil, nil, partOf(model, "LeftFoot"))
	elseif kind == "bothFeet" then
		trailOn(partOf(model, "RightLowerLeg"), color, duration, nil, nil, partOf(model, "RightFoot"))
		trailOn(partOf(model, "LeftLowerLeg"), color, duration, nil, nil, partOf(model, "LeftFoot"))
	elseif kind == "leftHand" then
		trailOn(partOf(model, "LeftLowerArm"), color, duration, nil, nil, partOf(model, "LeftHand"))
	elseif kind == "rightLeg" then
		trailOn(partOf(model, "RightUpperLeg"), color, duration)
	elseif kind == "body" then
		trailOn(partOf(model, "UpperTorso"), SODA, duration)
	elseif kind == "prop" then
		-- l'objet que le perso tient en permanence (canne, tampon, ventouse…), côté caméra
		local costume = model:FindFirstChild("Costume")
		for _, prop in ipairs(costume and costume:GetChildren() or {}) do
			local wanted = Animator.isMirrored(model) == (string.sub(prop.Name, -2) == "_M")
			if prop:IsA("Model") and wanted and prop.PrimaryPart and string.sub(prop.Name, 1, 4) == "Prop" and prop.PrimaryPart.Transparency < 1 then
				trailOn(prop.PrimaryPart, Color3.new(1, 1, 1), duration, prop.PrimaryPart:FindFirstChild("TrailA"), prop.PrimaryPart:FindFirstChild("TrailB"))
			end
		end
	elseif kind == "rightHand" then
		trailOn(partOf(model, "RightLowerArm"), color, duration, nil, nil, partOf(model, "RightHand"))
	elseif kind == "bothHands" then
		trailOn(partOf(model, "RightLowerArm"), color, duration, nil, nil, partOf(model, "RightHand"))
		trailOn(partOf(model, "LeftLowerArm"), color, duration, nil, nil, partOf(model, "LeftHand"))
	elseif kind == "head" then
		trailOn(partOf(model, "Head"), color, duration)
	elseif kind == "weapon" then
		-- l'arme tenue, dans la main visible (côté caméra)
		local held = model:FindFirstChild("Tenu")
		local prop = held and (held:FindFirstChild(Animator.isMirrored(model) and "Prop_M" or "Prop"))
		local info = Items.LIST[model:GetAttribute("Held") or ""]
		local longest = nil
		for _, p in ipairs(prop and prop:GetDescendants() or {}) do
			if p:IsA("BasePart") and p.Name ~= "Prise" and (not longest or p.Size.Magnitude > longest.Size.Magnitude) then
				longest = p
			end
		end
		if longest then
			trailOn(longest, info and info.color or color, duration)
		end
	end
end

-- Objets cachés (briquet, micro) ou à cacher (bouteille lancée), uniquement sur ce client
local function setPropVisible(model, propName, visible, duration)
	local prop = partOf(model, propName)
	if not prop then
		return
	end
	local parts = prop:IsA("BasePart") and { prop } or prop:GetDescendants()
	for _, p in ipairs(parts) do
		if p:IsA("BasePart") then
			-- changement local : le serveur et les autres joueurs ne sont pas touchés
			p.Transparency = visible and (p:GetAttribute("BaseTransparency") or 0) or 1
		end
	end
	if duration then
		task.delay(duration, function()
			setPropVisible(model, propName, not visible)
		end)
	end
end

local PROP_NAMES = { lighter = "PropLighter", mic = "PropMic", bottle = "PropBottle" }
-- Objet d'un autre perso : prop = "canne" -> pièce « PropCanne » de son costume (voir server/Costumes.lua)
local function propName(name)
	return PROP_NAMES[name] or ("Prop" .. string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2))
end

local function emitterAt(parentPart, cframeOffset, props, duration)
	local anchor = part({ Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1 })
	local emitter = Instance.new("ParticleEmitter")
	for k, v in pairs(props) do
		emitter[k] = v
	end
	emitter.Parent = anchor
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if parentPart and parentPart.Parent then
			anchor.CFrame = parentPart.CFrame * cframeOffset
		end
	end)
	task.delay(duration, function()
		emitter.Enabled = false
		connection:Disconnect()
	end)
	cleanup(anchor, duration + 1.5)
	return emitter
end

local function bubbles(parentPart, offset, duration, rate)
	return emitterAt(parentPart, offset or CFrame.new(), {
		Texture = TEX_SMOKE,
		Color = ColorSequence.new(Color3.fromRGB(220, 255, 180)),
		Size = NumberSequence.new(0.35, 0.1),
		Transparency = NumberSequence.new(0.2, 1),
		Lifetime = NumberRange.new(0.5, 0.9),
		Speed = NumberRange.new(3, 6),
		SpreadAngle = Vector2.new(35, 35),
		Rate = rate or 40,
		LightEmission = 0.5,
		Acceleration = Vector3.new(0, 6, 0),
	}, duration)
end

------------------------------------------------------------------------ Effets nommés dans les données des persos
local named = {}

named.hiccup = function(model)
	local head = partOf(model, "Head")
	if head then
		Fx.ring(head.Position + Vector3.new(0, 1.5, 0), SODA, 4, 0.3)
		bubbles(head, CFrame.new(0, 0.5, -0.6), 0.25, 80)
	end
end

named.slipper = function(model)
	local foot = partOf(model, "RightFoot")
	if not foot then
		return
	end
	local dir = facingOf(model)
	local start = foot.Position
	local slipper = part({ Size = Vector3.new(1.1, 0.15, 0.5), Color = Color3.fromRGB(60, 160, 230), Material = Enum.Material.SmoothPlastic, Position = start })
	local t0 = os.clock()
	local connection
	connection = RunService.RenderStepped:Connect(function()
		local t = os.clock() - t0
		local pos = start + Vector3.new(dir * 22 * t, 18 * t - 40 * t * t, 0)
		slipper.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, -dir * t * 25)
		if t > 0.9 then
			connection:Disconnect()
			slipper:Destroy()
		end
	end)
end

named.puddle = function(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local pos = root.Position + Vector3.new(facingOf(model) * 2, -2.95, 0)
	local puddle = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.1, 1, 1), Color = SODA, Transparency = 0.3, CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)) })
	tween(puddle, 0.25, { Size = Vector3.new(0.1, 9, 4) })
	task.delay(1, function()
		tween(puddle, 0.5, { Transparency = 1 })
	end)
	cleanup(puddle, 1.6)
	playSound(SOUND_SPLASH, root, 0.4, 1.2)
	for i = 1, 6 do
		local drop = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(0.4, 0.4, 0.4), Color = SODA, Position = pos })
		local dir = Vector3.new((math.random() - 0.5) * 6, 3 + math.random() * 3, 0)
		tween(drop, 0.4, { Position = pos + dir, Transparency = 1 })
		cleanup(drop, 0.45)
	end
end

named.headStar = function(model)
	local head = partOf(model, "Head")
	if head then
		local pos = head.Position + Vector3.new(facingOf(model) * 0.5, 1.5, 1)
		Fx.popText(pos, "★", YELLOW, 1.4, 0.6)
		Fx.ring(pos, YELLOW, 3, 0.25)
	end
end

named.sodaShake = function(model, move)
	local hand = partOf(model, "RightHand")
	if hand then
		bubbles(hand, CFrame.new(0, 0.4, 0), move.startup, 90)
	end
end

named.burp = function(model)
	local head = partOf(model, "Head")
	if not head then
		return
	end
	local dir = facingOf(model)
	for i = 0, 2 do
		task.delay(i * 0.07, function()
			Fx.ring(head.Position + Vector3.new(dir * (2 + i * 2.5), -0.3, 0.5), Color3.fromRGB(180, 230, 120), 2 + i, 0.35)
		end)
	end
end

-- Gerbe de soda : jet en éventail devant la bouteille
named.spray = function(model, move)
	local hand = partOf(model, "RightHand")
	local root = model:FindFirstChild("HumanoidRootPart")
	if not hand or not root then
		return
	end
	local dir = facingOf(model)
	local duration = math.max(move.active, 0.15) + (move.hold or 0)
	emitterAt(hand, CFrame.new(), {
		Texture = TEX_SMOKE,
		Color = ColorSequence.new(SODA, Color3.fromRGB(230, 255, 200)),
		Size = NumberSequence.new(0.7, 0.2),
		Transparency = NumberSequence.new(0.1, 1),
		Lifetime = NumberRange.new(0.25, 0.45),
		Speed = NumberRange.new(28, 40),
		SpreadAngle = Vector2.new(25, 25),
		Rate = 160,
		EmissionDirection = Enum.NormalId.Bottom,
		Acceleration = Vector3.new(0, -30, 0),
	}, duration)
	for i = 0, 4 do
		task.delay(i * duration / 5, function()
			local base = root.Position + Vector3.new(dir * (2 + i * 0.6), 0.6 - i * 0.3, 0.6)
			local drop = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(0.9, 0.9, 0.9), Color = SODA, Transparency = 0.15, Position = base })
			tween(drop, 0.3, { Position = base + Vector3.new(dir * 4.5, math.random(-10, 10) / 10, 0), Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1 })
			cleanup(drop, 0.35)
		end)
	end
	playSound(SOUND_SPLASH, root, 0.4, 1.3)
end

-- Recharge de Gégé : grandes gorgées
named.chug = function(model, charge)
	local head = partOf(model, "Head")
	if head then
		bubbles(head, CFrame.new(0, 0.6, 0), 0.9, 50)
		Fx.popText(head.Position + Vector3.new(facingOf(model) * 1.5, 1.2, 1), "GLOU GLOU", ENERGY, 0.75, 0.9)
	end
end

named.sip = function(model, move)
	local head = partOf(model, "Head")
	if head then
		bubbles(head, CFrame.new(0, 0.6, 0), (move.hold or 0.3) + 0.2, 60)
	end
end

named.lamp = function(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local base = root.Position + Vector3.new(0, -3, -1.2)
	local pole = part({ Size = Vector3.new(0.5, 0.2, 0.5), Color = Color3.fromRGB(50, 55, 60), Material = Enum.Material.Metal, Position = base })
	local lamp = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(1.4, 1.4, 1.4), Color = Color3.fromRGB(255, 240, 150), Position = base })
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 230, 140)
	light.Range = 14
	light.Brightness = 3
	light.Parent = lamp
	tween(pole, 0.25, { Size = Vector3.new(0.5, 14, 0.5), Position = base + Vector3.new(0, 7, 0) })
	tween(lamp, 0.25, { Position = base + Vector3.new(0, 14.4, 0) })
	-- étincelles de lampadaire qui grésille
	emitterAt(lamp, CFrame.new(), {
		Texture = TEX_SPARK,
		Color = ColorSequence.new(Color3.fromRGB(255, 240, 160)),
		Size = NumberSequence.new(0.6, 0),
		Lifetime = NumberRange.new(0.3, 0.6),
		Speed = NumberRange.new(6, 12),
		SpreadAngle = Vector2.new(180, 180),
		Rate = 60,
		LightEmission = 1,
		Acceleration = Vector3.new(0, -30, 0),
	}, 0.8)
	task.delay(1, function()
		tween(pole, 0.4, { Transparency = 1 })
		tween(lamp, 0.4, { Transparency = 1 })
		tween(light, 0.4, { Brightness = 0 })
	end)
	cleanup(pole, 1.5)
	cleanup(lamp, 1.5)
end

named.fire = function(model, move)
	local hand = partOf(model, "LeftHand")
	local head = partOf(model, "Head")
	if not hand or not head then
		return
	end
	local dir = facingOf(model)
	emitterAt(head, CFrame.new(0, -0.3, -0.7), {
		Texture = TEX_FIRE,
		Color = ColorSequence.new(Color3.fromRGB(255, 220, 80), Color3.fromRGB(255, 80, 20)),
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 2.8) }),
		Transparency = NumberSequence.new(0.1, 1),
		Lifetime = NumberRange.new(0.25, 0.35),
		Speed = NumberRange.new(28, 34),
		SpreadAngle = Vector2.new(12, 12),
		Rate = 140,
		LightEmission = 1,
		EmissionDirection = Enum.NormalId.Front,
	}, math.max(move.active, 0.2))
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 140, 40)
	light.Range = 16
	light.Brightness = 4
	light.Parent = head
	cleanup(light, move.active + 0.1)
	local _ = dir
end

named.dust = function(model, move)
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then
		emitterAt(root, CFrame.new(0, -2.8, 0), {
			Texture = TEX_SMOKE,
			Color = ColorSequence.new(Color3.fromRGB(200, 190, 170)),
			Size = NumberSequence.new(0.8, 2),
			Transparency = NumberSequence.new(0.4, 1),
			Lifetime = NumberRange.new(0.4, 0.6),
			Speed = NumberRange.new(1, 3),
			SpreadAngle = Vector2.new(60, 60),
			Rate = 50,
		}, move.active)
	end
end

-- Retour en jeu : atterrissage qui soulève la poussière
named.thud = function(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then
		Fx.ring(root.Position + Vector3.new(0, -2.7, 0), Color3.fromRGB(220, 210, 190), 4, 0.35)
		emitterAt(root, CFrame.new(0, -2.8, 0), {
			Texture = TEX_SMOKE,
			Color = ColorSequence.new(Color3.fromRGB(210, 200, 180)),
			Size = NumberSequence.new(0.8, 2.2),
			Transparency = NumberSequence.new(0.3, 1),
			Lifetime = NumberRange.new(0.4, 0.7),
			Speed = NumberRange.new(3, 6),
			SpreadAngle = Vector2.new(80, 10),
			Rate = 120,
		}, 0.15)
		playSound(SOUND_HIT, root, 0.5, 0.7)
	end
end

-- Retour de Gégé : il trinque avec le public
named.toast = function(model)
	local head = partOf(model, "Head")
	if head then
		Fx.popText(head.Position + Vector3.new(0, 2, 1), "À LA VÔTRE !", SODA, 1.1, 1.1)
		bubbles(head, CFrame.new(facingOf(model) * 0.8, 1.6, 0), 0.6, 40)
	end
end

named.hug = function(model)
	local head = partOf(model, "Head")
	if head then
		for i = 1, 3 do
			task.delay(i * 0.08, function()
				Fx.popText(head.Position + Vector3.new((math.random() - 0.5) * 3, 1, 1), "♥", Color3.fromRGB(255, 90, 140), 0.8, 0.7)
			end)
		end
	end
end

named.karaoke = function(model, move)
	local head = partOf(model, "Head")
	if not head then
		return
	end
	local notes = { "♪", "♫", "♬" }
	for i = 0, 9 do
		task.delay(i * 0.05, function()
			local angle = math.random() * math.pi * 2
			local pos = head.Position + Vector3.new(math.cos(angle) * 4, math.sin(angle) * 3, 1)
			Fx.popText(pos, notes[i % 3 + 1], Color3.fromRGB(120, 220, 255), 0.9, 0.9)
		end)
	end
	for i = 0, 3 do
		task.delay(i * 0.12, function()
			Fx.ring(head.Position, Color3.fromRGB(120, 220, 255), 10 + i * 8, 0.45)
		end)
	end
	CameraRig.shake(0.6, 0.6)
	local _ = move
end

-- Super : flash d'écran, zoom sur le perso et bandeau avec le nom du coup
named.super = function(model, move)
	if screenGui then
		local flash = Instance.new("Frame")
		flash.Size = UDim2.fromScale(1, 1)
		flash.BackgroundColor3 = Color3.new(1, 1, 1)
		flash.BackgroundTransparency = 0.2
		flash.BorderSizePixel = 0
		flash.Parent = screenGui
		tween(flash, 0.35, { BackgroundTransparency = 1 })
		cleanup(flash, 0.4)
		local banner = Instance.new("TextLabel")
		banner.AnchorPoint = Vector2.new(0.5, 0.5)
		banner.Position = UDim2.fromScale(0.5, 0.62)
		banner.Size = UDim2.fromScale(0, 0.12)
		banner.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
		banner.BackgroundTransparency = 0.15
		banner.Text = move.text or move.label
		banner.TextScaled = true
		banner.Font = Enum.Font.LuckiestGuy
		banner.TextColor3 = YELLOW
		banner.Parent = screenGui
		tween(banner, 0.2, { Size = UDim2.fromScale(0.8, 0.12) }, Enum.EasingStyle.Back)
		task.delay(0.9, function()
			tween(banner, 0.25, { Size = UDim2.fromScale(0.8, 0), TextTransparency = 1 })
		end)
		cleanup(banner, 1.3)
	end
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then
		CameraRig.punch(root.Position, 0.55, move.startup + 0.3)
		Fx.ring(root.Position, YELLOW, 8, 0.4)
	end
end


------------------------------------------------------------------------ Effets décrits en données
-- Dans les fiches des persos, fx / windupFx / beats acceptent un nom d'effet ci-dessus ("dust", "headStar"…)
-- ou une petite table qui décrit l'effet, par exemple :
--   { "ring", color = C, radius = 5, at = "front" }          onde de choc
--   { "burst", color = C, size = 3, at = "hand" }            éclat
--   { "text", text = "PSCHHH", color = C, at = "head" }      onomatopée
--   { "particles", color = C, tex = "smoke"/"spark"/"fire", at = "hand", time = 0.4, rate = 60, speed = 10, size = 0.6, dir = "front"/"up"/"all" }
--   { "pillar", color = C, height = 12, width = 2, at = "front", time = 0.8 }   colonne qui sort du sol
--   { "puddle", color = C, width = 8 }                       flaque devant
--   { "toss", color = C, shape = "ball"/"block"/"cyl", size = 1, count = 1, speed = 22, lift = 18 }   objet lancé en cloche
--   { "rain", color = C, shape = "ball", size = 0.6, count = 10, radius = 6 }   pluie d'objets autour
--   { "swarm", color = C, size = 1, count = 5 }              petites bêtes qui traversent devant
--   { "symbols", symbols = { "♪", "♫" }, color = C, count = 6, radius = 4 }    symboles qui jaillissent
--   { "beam", color = C, length = 10, width = 2, at = "head" }               jet horizontal (flamme, rayon…)
--   { "screen", color = C, alpha = 0.3 }                     flash d'écran
--   { "shake", amount = 0.5 }                                tremblement de caméra
-- at : "root", "front" (devant le perso), "head", "above", "hand" (main de l'objet), "lhand", "feet"
local generic = {}

local TEXTURES = { smoke = TEX_SMOKE, spark = TEX_SPARK, fire = TEX_FIRE }

local function anchorOf(model, at)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil, CFrame.new()
	end
	local dir = facingOf(model)
	if at == "head" then
		return partOf(model, "Head") or root, CFrame.new()
	elseif at == "above" then
		return partOf(model, "Head") or root, CFrame.new(0, 2, 0)
	elseif at == "hand" then
		return partOf(model, "RightHand") or root, CFrame.new(0, -0.6, 0)
	elseif at == "lhand" then
		return partOf(model, "LeftHand") or root, CFrame.new(0, -0.6, 0)
	elseif at == "feet" then
		return root, CFrame.new(0, -2.8, 0)
	elseif at == "front" then
		return root, CFrame.new(0, 0, -3) -- l'avant du perso (le HumanoidRootPart regarde vers lui)
	end
	return root, CFrame.new()
end

local function positionOf(model, at)
	local p, offset = anchorOf(model, at)
	if not p then
		return nil
	end
	return (p.CFrame * offset).Position
end

generic.ring = function(model, spec)
	local pos = positionOf(model, spec.at or "root")
	if pos then
		Fx.ring(pos + Vector3.new(0, 0, 0.5), spec.color or YELLOW, spec.radius or 4, spec.time or 0.35)
	end
end

generic.burst = function(model, spec)
	local pos = positionOf(model, spec.at or "front")
	if pos then
		Fx.burst(pos, spec.color or YELLOW, spec.size or 2.5)
	end
end

generic.text = function(model, spec)
	local pos = positionOf(model, spec.at or "head")
	if pos then
		Fx.popText(pos + Vector3.new(facingOf(model) * 1.5, 1.5, 1), spec.text, spec.color or Color3.new(1, 1, 1), spec.scale or 0.9, spec.time or 0.9)
	end
end

generic.particles = function(model, spec, move)
	local p, offset = anchorOf(model, spec.at or "hand")
	if not p then
		return
	end
	local dir = facingOf(model)
	local emitDirection = Enum.NormalId.Top
	local cf = offset
	if spec.dir == "front" then
		-- l'émetteur pointe vers l'avant du perso (le haut de l'ancre est tourné vers lui)
		cf = CFrame.new(offset.Position) * CFrame.Angles(0, 0, -dir * math.rad(90))
	elseif spec.dir == "down" then
		emitDirection = Enum.NormalId.Bottom
	end
	local duration = spec.time or math.max(move and move.active or 0.2, 0.2)
	local anchor = part({ Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1 })
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = TEXTURES[spec.tex or "smoke"] or TEX_SMOKE
	emitter.Color = ColorSequence.new(spec.color or Color3.new(1, 1, 1), (spec.color or Color3.new(1, 1, 1)):Lerp(Color3.new(1, 1, 1), 0.5))
	emitter.Size = NumberSequence.new(spec.size or 0.6, (spec.size or 0.6) * (spec.grow or 0.3))
	emitter.Transparency = NumberSequence.new(0.1, 1)
	emitter.Lifetime = NumberRange.new(spec.life or 0.4, (spec.life or 0.4) * 1.5)
	emitter.Speed = NumberRange.new((spec.speed or 8) * 0.7, spec.speed or 8)
	emitter.SpreadAngle = spec.dir == "all" and Vector2.new(180, 180) or Vector2.new(spec.spread or 25, spec.spread or 25)
	emitter.Rate = spec.rate or 60
	emitter.LightEmission = spec.tex == "smoke" and 0.2 or 0.8
	emitter.EmissionDirection = emitDirection
	if spec.gravity then
		emitter.Acceleration = Vector3.new(0, -spec.gravity, 0)
	end
	emitter.Parent = anchor
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if p.Parent then
			anchor.CFrame = p.CFrame * cf
		end
	end)
	task.delay(duration, function()
		emitter.Enabled = false
		connection:Disconnect()
	end)
	cleanup(anchor, duration + 1.5)
end

generic.pillar = function(model, spec)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local dir = facingOf(model)
	local x = (spec.at == "front" and dir * 3 or 0)
	local base = root.Position + Vector3.new(x, -3, -0.6)
	local height = spec.height or 12
	local width = spec.width or 2
	local column = part({ Size = Vector3.new(width, 0.2, width), Color = spec.color or YELLOW, Material = spec.neon == false and Enum.Material.SmoothPlastic or Enum.Material.Neon, Transparency = spec.transparency or 0.2, Position = base })
	tween(column, 0.2, { Size = Vector3.new(width, height, width), Position = base + Vector3.new(0, height / 2, 0) }, Enum.EasingStyle.Back)
	local time = spec.time or 0.8
	task.delay(time, function()
		tween(column, 0.35, { Transparency = 1, Size = Vector3.new(width * 0.3, height, width * 0.3) })
	end)
	cleanup(column, time + 0.5)
end

generic.puddle = function(model, spec)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local pos = root.Position + Vector3.new(facingOf(model) * 2.5, -2.95, 0)
	local puddle = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.1, 1, 1), Color = spec.color or SODA, Transparency = 0.3, CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)) })
	tween(puddle, 0.25, { Size = Vector3.new(0.1, spec.width or 8, 4) })
	task.delay(spec.time or 1.2, function()
		tween(puddle, 0.5, { Transparency = 1 })
	end)
	cleanup(puddle, (spec.time or 1.2) + 0.6)
	playSound(SOUND_SPLASH, root, 0.35, 1.2)
end

local function shapeProps(spec, size)
	local props = { Size = Vector3.new(size, size, size), Color = spec.color or YELLOW, Material = spec.material and Enum.Material[spec.material] or Enum.Material.SmoothPlastic }
	if spec.shape == "ball" or spec.shape == nil then
		props.Shape = Enum.PartType.Ball
	elseif spec.shape == "cyl" then
		props.Shape = Enum.PartType.Cylinder
		props.Size = Vector3.new(size * 0.3, size, size)
	elseif spec.shape == "flat" then
		props.Size = Vector3.new(size, size * 0.2, size)
	end
	return props
end

generic.toss = function(model, spec)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local dir = facingOf(model)
	for i = 1, spec.count or 1 do
		task.delay((i - 1) * 0.05, function()
			local start = root.Position + Vector3.new(dir * 1.5, 1, 0.5)
			local p = part(shapeProps(spec, spec.size or 1))
			p.Position = start
			local speed = (spec.speed or 22) * (0.85 + math.random() * 0.3)
			local lift = (spec.lift or 18) * (0.8 + math.random() * 0.4)
			local t0 = os.clock()
			local connection
			connection = RunService.RenderStepped:Connect(function()
				local t = os.clock() - t0
				p.CFrame = CFrame.new(start + Vector3.new(dir * speed * t, lift * t - 40 * t * t, 0)) * CFrame.Angles(0, 0, -dir * t * 20)
				if t > (spec.time or 0.9) then
					connection:Disconnect()
					p:Destroy()
				end
			end)
		end)
	end
end

generic.rain = function(model, spec)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local radius = spec.radius or 6
	for i = 1, spec.count or 10 do
		task.delay(math.random() * 0.4, function()
			local start = root.Position + Vector3.new((math.random() - 0.5) * 2 * radius, 6 + math.random() * 4, 0.5)
			local p = part(shapeProps(spec, spec.size or 0.6))
			p.Position = start
			tween(p, 0.5, { Position = start - Vector3.new(0, 9 + math.random() * 2, 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			task.delay(0.5, function()
				tween(p, 0.2, { Transparency = 1 })
			end)
			cleanup(p, 0.75)
		end)
	end
end

generic.swarm = function(model, spec)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local dir = facingOf(model)
	for i = 1, spec.count or 5 do
		task.delay(i * 0.06, function()
			local start = root.Position + Vector3.new(dir * 1, -2.2 + (spec.height or 0) + math.random() * (spec.spreadY or 0.5), 0.5 + math.random())
			local p = part(shapeProps(spec, spec.size or 1))
			p.Position = start
			tween(p, spec.time or 0.6, { Position = start + Vector3.new(dir * (spec.distance or 16), math.random() * 2, 0) }, Enum.EasingStyle.Linear)
			task.delay((spec.time or 0.6) - 0.1, function()
				tween(p, 0.1, { Transparency = 1 })
			end)
			cleanup(p, (spec.time or 0.6) + 0.1)
		end)
	end
end

generic.symbols = function(model, spec)
	local pos = positionOf(model, spec.at or "head")
	if not pos then
		return
	end
	local symbols = spec.symbols or { "♪", "♫" }
	for i = 0, (spec.count or 6) - 1 do
		task.delay(i * 0.05, function()
			local angle = math.random() * math.pi * 2
			local r = spec.radius or 4
			Fx.popText(pos + Vector3.new(math.cos(angle) * r, math.sin(angle) * r * 0.7, 1), symbols[i % #symbols + 1], spec.color or YELLOW, spec.scale or 0.8, 0.8)
		end)
	end
end

generic.beam = function(model, spec, move)
	local p = anchorOf(model, spec.at or "head")
	if not p then
		return
	end
	local dir = facingOf(model)
	local length = spec.length or 10
	local width = spec.width or 1.6
	local beam = part({ Size = Vector3.new(0.5, width, width), Color = spec.color or YELLOW, Transparency = 0.25 })
	local duration = spec.time or math.max(move and move.active or 0.2, 0.2)
	local t0 = os.clock()
	local connection
	connection = RunService.RenderStepped:Connect(function()
		local k = math.clamp((os.clock() - t0) / 0.1, 0, 1)
		local len = length * k
		if p.Parent then
			beam.CFrame = CFrame.new(p.Position + Vector3.new(dir * (len / 2 + 0.6), -0.2, 0.3))
			beam.Size = Vector3.new(math.max(len, 0.5), width, width)
		end
	end)
	task.delay(duration, function()
		connection:Disconnect()
		tween(beam, 0.2, { Transparency = 1 })
	end)
	cleanup(beam, duration + 0.3)
end

generic.screen = function(model, spec)
	if not screenGui then
		return
	end
	local flash = Instance.new("Frame")
	flash.Size = UDim2.fromScale(1, 1)
	flash.BackgroundColor3 = spec.color or Color3.new(1, 1, 1)
	flash.BackgroundTransparency = 1 - (spec.alpha or 0.35)
	flash.BorderSizePixel = 0
	flash.Parent = screenGui
	tween(flash, spec.time or 0.4, { BackgroundTransparency = 1 })
	cleanup(flash, (spec.time or 0.4) + 0.05)
end

generic.shake = function(model, spec)
	CameraRig.shake(spec.amount or 0.5, spec.time or 0.3)
end

-- Lance un effet nommé (chaîne) ou décrit (table) ; utilisé pour les coups, la recharge et les retours
function Fx.runNamed(model, name, move)
	if typeof(name) == "table" then
		local f = generic[name[1]]
		if f then
			local ok, err = pcall(f, model, name, move)
			if not ok then
				warn("[Fx] " .. tostring(name[1]) .. " : " .. tostring(err))
			end
		end
	elseif named[name] then
		named[name](model, move)
	end
end

------------------------------------------------------------------------ Coups
-- Membre qui frappe vraiment (celui qui bouge le plus entre l'élan et la frappe) : sert à dessiner l'arc de frappe
-- des coups qui n'en précisent pas
local LIMBS = {
	{ "rightHand", { "RS", "RE" } }, { "leftHand", { "LS", "LE" } },
	{ "rightFoot", { "RH", "RK" } }, { "leftFoot", { "LH", "LK" } },
}
local function strikingLimb(model, move)
	local from, to = move.windup or {}, move.strike or {}
	local best, bestAmount = nil, 25
	for _, limb in ipairs(LIMBS) do
		local amount = 0
		for _, joint in ipairs(limb[2]) do
			local a, b = from[joint], to[joint]
			if b then
				a = a or { 0, 0, 0 }
				amount += math.abs(b[1] - a[1]) + math.abs(b[2] - a[2]) + math.abs(b[3] - a[3])
			end
		end
		if amount > bestAmount then
			best, bestAmount = limb[1], amount
		end
	end
	-- la main droite tient l'arme quand la Caisse Bizarre est ouverte : c'est l'arme qui laisse l'arc
	if best == "rightHand" and model:GetAttribute("Armed") then
		local costume = model:FindFirstChild("Costume")
		for _, prop in ipairs(costume and costume:GetChildren() or {}) do
			if prop:IsA("Model") and prop:GetAttribute("AlwaysShown") then
				return "prop"
			end
		end
		if costume and costume:FindFirstChild("PropBottle") then
			return "bottle"
		end
	end
	return best
end

-- Appelé par l'Animator au lancement de chaque coup, chez tous les joueurs
function Fx.onMoveStart(model, key, move, startClock, power)
	power = power or 0
	local delayToStrike = math.max(0, move.startup - (os.clock() - startClock))
	local strikeDuration = math.max(move.active, 0.1) + (move.hold or 0)
	local total = move.startup + strikeDuration + move.recovery

	if move.prop then
		setPropVisible(model, propName(move.prop), true, total)
	end
	-- signature (L) ou Super : le perso s'entoure d'un contour lumineux pendant l'élan (on voit venir le gros coup)
	local isSignature = string.find(key, "S_", 1, true) ~= nil or string.find(key, "SUPER", 1, true) ~= nil
	if isSignature and move.startup >= 0.08 then
		local glow = Instance.new("Highlight")
		local super = string.find(key, "SUPER", 1, true) ~= nil
		glow.FillColor = super and Color3.fromRGB(255, 200, 40) or Color3.fromRGB(255, 255, 255)
		glow.OutlineColor = super and Color3.fromRGB(255, 120, 20) or Color3.fromRGB(120, 200, 255)
		glow.FillTransparency = 0.8
		glow.OutlineTransparency = 0.05
		glow.DepthMode = Enum.HighlightDepthMode.Occluded
		glow.Parent = model
		task.delay(delayToStrike + 0.05, function()
			tween(glow, 0.12, { FillTransparency = 1, OutlineTransparency = 1 })
		end)
		cleanup(glow, delayToStrike + 0.25)
	end
	for _, name in ipairs(move.windupFx or {}) do
		Fx.runNamed(model, name, move)
	end

	task.delay(delayToStrike, function()
		if not model.Parent then
			return
		end
		local root = model:FindFirstChild("HumanoidRootPart")
		local kind = move.kind or "melee"
		local trailKind = move.trail
		if not trailKind and (kind == "melee" or kind == "absorb" or kind == "counter" or kind == "wall") and move.hitbox then
			trailKind = strikingLimb(model, move)
		end
		if trailKind then
			Fx.trail(model, trailKind, strikeDuration)
		end
		-- coup qui part en avant au sol : poussière sous les pieds
		if root and move.selfVelocity and math.abs(move.selfVelocity.X) >= 20 and move.selfVelocity.Y <= 0 then
			Fx.dust(model, 0.6)
		end
		if move.hideProp then
			setPropVisible(model, propName(move.hideProp), false, strikeDuration + move.recovery)
		end
		for _, name in ipairs(move.fx or {}) do
			Fx.runNamed(model, name, move)
		end
		if power > 0.3 and root then
			-- frappe chargée façon Smash : plus c'est chargé, plus c'est gros
			local front = root.Position + Vector3.new(facingOf(model) * 2.5, 0.5, 1)
			Fx.ring(front, Color3.fromRGB(255, 160, 40), 3 + 4 * power, 0.3)
			Fx.popText(front + Vector3.new(0, 2.5, 0), "SMASH !", Color3.fromRGB(255, 120, 30), 1 + 0.5 * power, 0.9)
			CameraRig.shake(0.2 + 0.3 * power, 0.2)
		elseif move.text and root then
			Fx.popText(root.Position + Vector3.new(facingOf(model) * 2, 3.5, 1), move.text, Color3.new(1, 1, 1), 0.9, 0.9)
		end
		if root then
			playSound(SOUND_SWOOSH, root, 0.35, 0.9 + math.random() * 0.3)
		end
	end)
end

------------------------------------------------------------------------ Impacts
-- Étincelle d'impact façon Brawlhalla : éclair blanc, rayons en étoile étirés dans le sens de l'éjection,
-- et anneau coloré pour les gros coups. power = vitesse d'éjection, dir = +1 / -1 (sens du coup)
function Fx.hitSpark(position, power, dir, color)
	local k = math.clamp(power / 120, 0.4, 1.8)
	color = color or YELLOW
	local core = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(0.6, 0.6, 0.6), Color = Color3.new(1, 1, 1), Material = Enum.Material.Neon, Position = position + Vector3.new(0, 0, 1.2) })
	tween(core, 0.06, { Size = Vector3.new(2.2, 2.2, 2.2) * k })
	task.delay(0.06, function()
		tween(core, 0.12, { Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1 })
	end)
	cleanup(core, 0.2)
	local rays = 7 + math.floor(k * 3)
	for i = 1, rays do
		local angle = (i / rays) * math.pi * 2 + math.random() * 0.4
		local v = Vector3.new(math.cos(angle), math.sin(angle), 0)
		-- les rayons qui partent dans le sens du coup sont plus longs
		local along = math.max(0, v.X * dir)
		local length = (1.2 + along * 2.4) * k * (0.8 + math.random() * 0.4)
		local ray = part({ Size = Vector3.new(0.16, 0.16, length), Color = i % 2 == 0 and color or Color3.new(1, 1, 1), Material = Enum.Material.Neon,
			CFrame = CFrame.lookAt(position + v * 0.6 + Vector3.new(0, 0, 1.2), position + v * 5 + Vector3.new(0, 0, 1.2)) })
		local finish = position + v * (length * 1.3) + Vector3.new(0, 0, 1.2)
		tween(ray, 0.16, { CFrame = CFrame.lookAt(finish, finish + v), Size = Vector3.new(0.04, 0.04, length * 0.3), Transparency = 0.6 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		cleanup(ray, 0.18)
	end
	if power > 80 then
		Fx.ring(position + Vector3.new(0, 0, 1), color, 2.5 * k, 0.22)
	end
	if power > 150 then
		Fx.ring(position + Vector3.new(0, 0, 0.9), Color3.new(1, 1, 1), 4 * k, 0.32)
	end
end

-- Éjection : traînée de fumée derrière le perso qui vole (plus le coup est fort, plus elle dure)
function Fx.launchTrail(model, power)
	local torso = partOf(model, "UpperTorso")
	if not torso or power < 70 then
		return
	end
	local duration = math.clamp(power * 0.006, 0.35, 1.3)
	local a0 = Instance.new("Attachment")
	a0.Position = Vector3.new(0, 0.9, 0)
	a0.Parent = torso
	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(0, -0.9, 0)
	a1.Parent = torso
	local trail = Instance.new("Trail")
	trail.Attachment0, trail.Attachment1 = a0, a1
	trail.Lifetime = 0.35
	trail.MinLength = 0
	trail.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 200))
	trail.Transparency = NumberSequence.new(0.25, 1)
	trail.WidthScale = NumberSequence.new(1, 0.1)
	trail.LightEmission = 0.4
	trail.FaceCamera = true
	trail.Parent = torso
	if power > 130 then
		emitterAt(torso, CFrame.new(), {
			Texture = TEX_SMOKE,
			Color = ColorSequence.new(Color3.fromRGB(235, 235, 240)),
			Size = NumberSequence.new(1.1, 2.4),
			Transparency = NumberSequence.new(0.4, 1),
			Lifetime = NumberRange.new(0.35, 0.6),
			Speed = NumberRange.new(0.5, 1.5),
			Rate = 45,
		}, duration)
	end
	task.delay(duration, function()
		trail.Enabled = false
	end)
	cleanup(trail, duration + 0.4)
	cleanup(a0, duration + 0.4)
	cleanup(a1, duration + 0.4)
end

function Fx.onHit(data)
	local power = data.power or 30
	local strong = power > 110
	local huge = power > 160
	local dir = 1
	local attackerRoot = data.attacker and data.attacker:FindFirstChild("HumanoidRootPart")
	if attackerRoot and data.position then
		dir = data.position.X >= attackerRoot.Position.X and 1 or -1
	end
	local color = huge and Color3.fromRGB(255, 80, 40) or strong and Color3.fromRGB(255, 160, 40) or YELLOW
	Fx.hitSpark(data.position, power, dir, color)
	Fx.popText(data.position + Vector3.new(0, 1.5, 0), data.text or "PAF !", strong and Color3.fromRGB(255, 90, 40) or YELLOW, strong and 1.4 or 1, 0.75)
	-- arrêt sur image : plus long pour les gros coups ; la victime tremble pendant ce temps
	local stop = 0.045 + math.min(power, 220) * 0.0006
	if data.target then
		Fx.flash(data.target)
		Animator.freeze(data.target, stop, 0.12 + math.min(power, 200) * 0.0008)
		Fx.launchTrail(data.target, power)
	end
	if data.attacker then
		Animator.freeze(data.attacker, stop)
	end
	if huge then
		CameraRig.punch(data.position, 0.9, 0.22)
		Fx.cheer(1)
	end
	CameraRig.shake(math.clamp(power / 220, 0.08, 0.9), 0.25)
	playSound(SOUND_HIT, nil, 0.6, strong and 0.8 or 1.3)
end

------------------------------------------------------------------------ Déplacements
-- Poussière sous les pieds (atterrissage, départ en course, coup qui fonce)
function Fx.dust(model, amount)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	amount = amount or 1
	for _, side in ipairs({ -1, 1 }) do
		-- émetteur posé dans le repère du monde : la poussière part à gauche et à droite sur l'écran
		local anchor = part({ Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1, CFrame = CFrame.new(root.Position + Vector3.new(side * 0.8, -2.8, 0.5)) })
		local emitter = Instance.new("ParticleEmitter")
		emitter.Texture = TEX_SMOKE
		emitter.Color = ColorSequence.new(Color3.fromRGB(225, 215, 195))
		emitter.Size = NumberSequence.new(0.6 * amount, 1.6 * amount)
		emitter.Transparency = NumberSequence.new(0.35, 1)
		emitter.Lifetime = NumberRange.new(0.25, 0.45)
		emitter.Speed = NumberRange.new(3 * amount, 6 * amount)
		emitter.SpreadAngle = Vector2.new(25, 10)
		emitter.Acceleration = Vector3.new(0, 2, 0)
		emitter.EmissionDirection = side > 0 and Enum.NormalId.Right or Enum.NormalId.Left
		emitter.Rate = 0
		emitter.Parent = anchor
		emitter:Emit(math.floor(6 * amount + 0.5))
		cleanup(anchor, 0.8)
	end
end

local function onLand(model, impact)
	if impact > 0.45 then
		Fx.dust(model, 0.6 + impact * 0.6)
	end
end

local function onTakeoff(model)
	Fx.dust(model, 0.5)
end

-- Double saut : petit anneau blanc sous les pieds, comme dans Brawlhalla
local function onAirJump(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local position = root.Position + Vector3.new(0, -2.6, 0)
	local ring = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.15, 1, 1), Color = Color3.new(1, 1, 1), Material = Enum.Material.Neon, Transparency = 0.2,
		CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90)) })
	tween(ring, 0.25, { Size = Vector3.new(0.05, 4, 4), Transparency = 1 })
	cleanup(ring, 0.3)
	playSound(SOUND_SWOOSH, root, 0.25, 1.8)
end

------------------------------------------------------------------------ Projectiles
local projectiles = {}

-- Projectile décrit dans la fiche du perso : visual = { shape = "ball"/"block"/"cyl"/"disc", size, color,
-- material, neon, spin, parts = { { forme, taille (Vector3), décalage (Vector3), couleur }, ... }, text = "#" }
local function buildCustomProjectile(visual, color)
	local holder = Instance.new("Model")
	local pieces = {}
	local function add(shape, size, offset, c, mat)
		local props = { Size = size, Color = c or color or YELLOW, Material = mat or (visual.neon and Enum.Material.Neon or Enum.Material.SmoothPlastic), Transparency = visual.transparency or 0 }
		if shape == "ball" then
			props.Shape = Enum.PartType.Ball
		elseif shape == "cyl" or shape == "disc" then
			props.Shape = Enum.PartType.Cylinder
		end
		local p = part(props)
		p.Parent = holder
		table.insert(pieces, { p, offset or Vector3.zero })
		return p
	end
	local size = visual.size or 1.4
	local mat = visual.material and Enum.Material[visual.material] or nil
	if visual.shape == "disc" then
		-- disque vu de face par la caméra (un cylindre Roblox est couché sur X : on le tourne vers Z)
		local disc = add("disc", Vector3.new(0.25, size, size), Vector3.zero, visual.color, mat)
		pieces[#pieces][3] = CFrame.Angles(0, math.rad(90), 0)
		local _ = disc
	elseif visual.shape == "cyl" then
		add("cyl", Vector3.new(size, size * 0.5, size * 0.5), Vector3.zero, visual.color, mat)
	elseif visual.shape == "block" then
		add("block", Vector3.new(size, size, size * 0.6), Vector3.zero, visual.color, mat)
	else
		add("ball", Vector3.new(size, size, size), Vector3.zero, visual.color, mat)
	end
	for _, extra in ipairs(visual.parts or {}) do
		add(extra[1], extra[2], extra[3], extra[4], extra[5] and Enum.Material[extra[5]] or nil)
	end
	if visual.text then
		local gui = Instance.new("BillboardGui")
		gui.Size = UDim2.fromScale(size * 1.6, size * 1.6)
		gui.AlwaysOnTop = true
		gui.LightInfluence = 0
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(1, 1)
		label.Text = visual.text
		label.TextScaled = true
		label.Font = Enum.Font.LuckiestGuy
		label.TextColor3 = visual.textColor or Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0
		label.Parent = gui
		gui.Parent = pieces[1][1]
	end
	if visual.trail ~= false then
		local a0 = Instance.new("Attachment")
		a0.Position = Vector3.new(0, size * 0.3, 0)
		a0.Parent = pieces[1][1]
		local a1 = Instance.new("Attachment")
		a1.Position = Vector3.new(0, -size * 0.3, 0)
		a1.Parent = pieces[1][1]
		local trail = Instance.new("Trail")
		trail.Attachment0, trail.Attachment1 = a0, a1
		trail.Lifetime = 0.15
		trail.Color = ColorSequence.new(visual.color or color or YELLOW)
		trail.Transparency = NumberSequence.new(0.4, 1)
		trail.FaceCamera = true
		trail.Parent = pieces[1][1]
	end
	holder.Parent = folder
	local spinSpeed = visual.spin or 0
	return holder, function(cf)
		local spin = CFrame.Angles(0, 0, -os.clock() * spinSpeed)
		for _, entry in ipairs(pieces) do
			entry[1].CFrame = cf * spin * CFrame.new(entry[2]) * (entry[3] or CFrame.new())
		end
	end
end

local function buildProjectile(visual, color)
	if typeof(visual) == "table" then
		return buildCustomProjectile(visual, color)
	end
	local itemId = string.match(visual or "", "^item:(%a+)$")
	if itemId then
		-- objet lancé (bombe, croustillant, peau de banane, arme…), qui tournoie
		local model = Items.build(itemId)
		for _, p in ipairs(model:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = true
			end
		end
		model.Parent = folder
		return model, function(cf)
			model:PivotTo(cf * CFrame.Angles(0, 0, os.clock() * 14))
		end
	end
	if visual == "cap" then
		-- capsule de bouteille qui file en tournoyant
		local cap = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.25, 1, 1), Color = color or Color3.fromRGB(220, 50, 40), Material = Enum.Material.Metal })
		local holder = Instance.new("Model")
		cap.Parent = holder
		holder.Parent = folder
		return holder, function(cf)
			cap.CFrame = cf * CFrame.Angles(0, 0, math.rad(90)) * CFrame.Angles(os.clock() * 30, 0, 0)
		end
	end
	if visual == "bottle" then
		local model = Instance.new("Model")
		local glass = Color3.fromRGB(40, 150, 70)
		local body = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(1.5, 0.6, 0.6), Color = glass, Material = Enum.Material.Glass, Transparency = 0.15 })
		local neck = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.6, 0.26, 0.26), Color = glass, Material = Enum.Material.Glass })
		local label = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.55, 0.63, 0.63), Color = Color3.fromRGB(240, 140, 40), Material = Enum.Material.SmoothPlastic })
		body.Parent, neck.Parent, label.Parent = model, model, model
		model.Parent = folder
		return model, function(cf)
			body.CFrame = cf
			label.CFrame = cf
			neck.CFrame = cf * CFrame.new(1.05, 0, 0)
		end
	end
	-- jet de soda : grosse goutte + bulles
	local blob = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(1.4, 1.4, 1.4), Color = color or SODA, Transparency = 0.1 })
	local droplets = {}
	for i = 1, 4 do
		droplets[i] = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(1.1 - i * 0.2, 1.1 - i * 0.2, 1.1 - i * 0.2), Color = color or SODA, Transparency = 0.2 + i * 0.12 })
	end
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = TEX_SMOKE
	-- jet de soda (vert) ou d'eau du pistolet (bleu) : les bulles prennent la couleur du jet
	emitter.Color = ColorSequence.new(color and color:Lerp(Color3.new(1, 1, 1), 0.5) or Color3.fromRGB(220, 255, 180))
	emitter.Size = NumberSequence.new(0.4, 0.1)
	emitter.Lifetime = NumberRange.new(0.3, 0.5)
	emitter.Rate = 60
	emitter.Speed = NumberRange.new(1, 2)
	emitter.Parent = blob
	local history = {}
	local holder = Instance.new("Model")
	blob.Parent = holder
	for _, d in ipairs(droplets) do
		d.Parent = holder
	end
	holder.Parent = folder
	return holder, function(cf)
		table.insert(history, 1, cf.Position)
		if #history > 12 then
			table.remove(history)
		end
		blob.CFrame = cf
		for i, d in ipairs(droplets) do
			d.Position = history[math.min(#history, i * 2 + 1)]
		end
	end
end

-- Plus assez d'énergie pour ce spécial (affiché au plus deux fois par seconde)
local lastNoEnergy = 0
function Fx.noEnergy(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root or os.clock() - lastNoEnergy < 0.5 then
		return
	end
	lastNoEnergy = os.clock()
	Fx.popText(root.Position + Vector3.new(0, 4, 1), "PLUS D'ÉNERGIE ! (T)", Color3.fromRGB(150, 160, 190), 0.8, 0.9)
end

function Fx.spawnProjectile(data)
	local model, place = buildProjectile(data.visual, data.color)
	local start = os.clock()
	-- base = trajectoire en cours ; un projectile qui change de cap (tête chercheuse, boomerang) reçoit
	-- des « ProjectileUpdate » du serveur qui remplacent la base
	local entry = { model = model, base = { origin = data.origin, velocity = data.velocity, gravity = data.gravity, start = start } }
	projectiles[data.id] = entry
	entry.connection = RunService.RenderStepped:Connect(function()
		local t = os.clock() - start
		local b = entry.base
		local tb = os.clock() - b.start
		local pos = b.origin + b.velocity * tb + Vector3.new(0, -0.5 * b.gravity * tb * tb, 0)
		local spin = data.visual == "bottle" and CFrame.Angles(0, 0, -t * 18 * math.sign(data.velocity.X)) or CFrame.new()
		if typeof(data.visual) == "string" and string.sub(data.visual, 1, 5) == "item:" then
			spin = CFrame.new() -- l'objet tourne déjà sur lui-même
		end
		place(CFrame.new(pos) * spin)
		entry.position = pos
		if t > data.lifetime + 0.2 then
			Fx.endProjectile({ id = data.id, position = pos })
		end
	end)
	if data.visual == "soda" or data.visual == "water" then
		playSound(SOUND_SPLASH, nil, 0.3, 1.6)
	end
end

function Fx.updateProjectile(data)
	local entry = projectiles[data.id]
	if entry then
		entry.base = { origin = data.position, velocity = data.velocity, gravity = entry.base.gravity, start = os.clock() }
	end
end

function Fx.endProjectile(data)
	local entry = projectiles[data.id]
	if not entry then
		return
	end
	projectiles[data.id] = nil
	entry.connection:Disconnect()
	entry.model:Destroy()
	local pos = data.position or entry.position
	if pos then
		Fx.burst(pos, data.touched and YELLOW or SODA, 1.6)
	end
end

------------------------------------------------------------------------ Objets posés (pièges, murs) et spéciaux
-- Évènements de server/Specials.lua : « Object » / « ObjectEnd », « Grapple », « Counter », « Absorbed »
local objects = {}
local STATUS_LOOK -- défini plus bas (statuts au-dessus de la tête)

local function onObject(data)
	local visual = data.visual
	local holder, place
	if typeof(visual) == "table" then
		holder, place = buildCustomProjectile(table.clone(visual), data.color)
	elseif data.kind == "wall" then
		-- mur invisible (Marcel le Mime) : un contour qui scintille à peine
		holder = Instance.new("Model")
		local size = data.size or Vector3.new(1.2, 8, 6)
		local glass = part({ Size = Vector3.new(size.X, size.Y, 0.2), Color = Color3.fromRGB(220, 235, 255), Material = Enum.Material.Glass, Transparency = 0.85 })
		glass.Parent = holder
		holder.Parent = folder
		place = function(cf)
			glass.CFrame = cf * CFrame.new(0, 0, 1)
		end
	else
		holder, place = buildCustomProjectile({ shape = "disc", size = 2.2, color = data.color or Color3.fromRGB(230, 120, 160), trail = false }, data.color)
	end
	local base = data.kind == "trap" and (data.position + Vector3.new(0, 0.4, 0)) or data.position
	local entry = { model = holder, place = place, position = base, follow = data.follow, offset = data.follow and data.follow:FindFirstChild("HumanoidRootPart") and (base - data.follow.HumanoidRootPart.Position) }
	objects[data.id] = entry
	place(CFrame.new(base))
	Fx.ring(base, data.color or YELLOW, 3, 0.3)
	cleanup(holder, (data.lifetime or 10) + 2)
end

local function onObjectEnd(data)
	local entry = objects[data.id]
	if not entry then
		return
	end
	objects[data.id] = nil
	if entry.model then
		entry.model:Destroy()
	end
	if data.burst and data.position then
		Fx.burst(data.position, data.color or YELLOW, 2.2)
	end
end

local function updateObjects()
	for _, entry in pairs(objects) do
		if entry.follow and entry.offset then
			local root = entry.follow:FindFirstChild("HumanoidRootPart")
			if root then
				entry.place(CFrame.new(root.Position + entry.offset))
			end
		end
	end
end

local function onGrapple(data)
	local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
	if not root or not data.to then
		return
	end
	local from = root.Position
	local rope = part({ Size = Vector3.new(0.2, 0.2, 0.2), Color = Color3.fromRGB(220, 60, 60), Material = Enum.Material.SmoothPlastic })
	local cup = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(1, 1, 1), Color = Color3.fromRGB(230, 40, 40) })
	local t0 = os.clock()
	local connection
	connection = RunService.RenderStepped:Connect(function()
		local t = os.clock() - t0
		local k = math.clamp(t / 0.12, 0, 1)
		local start = root.Parent and root.Position or from
		local tip = start:Lerp(data.to, k)
		rope.Size = Vector3.new(0.2, 0.2, math.max(0.2, (tip - start).Magnitude))
		rope.CFrame = CFrame.lookAt((start + tip) / 2, tip)
		cup.Position = tip
		if t > 0.45 then
			connection:Disconnect()
			rope:Destroy()
			cup:Destroy()
		end
	end)
	playSound(SOUND_SWOOSH, root, 0.4, 0.7)
end

local function onSpecialEvent(kind, data)
	if kind == "Object" then
		onObject(data)
	elseif kind == "ObjectEnd" then
		onObjectEnd(data)
	elseif kind == "Grapple" then
		onGrapple(data)
	elseif kind == "Counter" then
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		if root then
			Fx.ring(root.Position, Color3.fromRGB(120, 220, 255), 5, 0.3)
			Fx.popText(root.Position + Vector3.new(0, 4, 1), data.text or "CONTRE !", Color3.fromRGB(120, 220, 255), 1.2, 0.9)
			CameraRig.shake(0.3, 0.2)
		end
	elseif kind == "Absorbed" then
		if data.position then
			Fx.burst(data.position, Color3.fromRGB(180, 180, 200), 1.6)
		end
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		if root then
			Fx.popText(root.Position + Vector3.new(0, 4, 1), "SLURP !", Color3.fromRGB(200, 200, 230), 0.9, 0.7)
		end
	elseif kind == "Sneeze" then
		local head = data.model and data.model:FindFirstChild("Head")
		if head then
			Fx.popText(head.Position + Vector3.new(0, 2, 1), "ATCHOUM !", Color3.fromRGB(160, 230, 160), 1, 0.7)
			Fx.burst(head.Position + Vector3.new(facingOf(data.model) * 1.2, 0, 0), Color3.fromRGB(200, 240, 200), 1.5)
		end
	elseif kind == "Buff" then
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		local look = STATUS_LOOK[data.name or ""]
		if root and look then
			Fx.ring(root.Position, look[2], 6, 0.45)
			Fx.popText(root.Position + Vector3.new(0, 5, 1), look[1] .. " !", look[2], 1.3, 1.2)
		end
	elseif kind == "Popup" then
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		if root then
			Fx.popText(root.Position + Vector3.new(0, 5, 1), (data.icon or "") .. " " .. (data.text or ""), Color3.new(1, 1, 1), 1, 1)
		end
	elseif kind == "FatalFx" then
		if data.model and data.fx then
			Fx.runNamed(data.model, data.fx)
		end
	end
end

------------------------------------------------------------------------ Pièges d'arène (server/Hazards.lua)
local function overlay(color, alpha, duration, text)
	if not screenGui then
		return
	end
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = 1 - alpha
	frame.BorderSizePixel = 0
	frame.ZIndex = 5
	frame.Parent = screenGui
	if text then
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(1, 0.15)
		label.Position = UDim2.fromScale(0, 0.42)
		label.Text = text
		label.TextScaled = true
		label.Font = Enum.Font.LuckiestGuy
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0
		label.ZIndex = 6
		label.Parent = frame
	end
	task.delay(duration, function()
		tween(frame, 0.25, { BackgroundTransparency = 1 })
		for _, child in ipairs(frame:GetChildren()) do
			if child:IsA("TextLabel") then
				tween(child, 0.25, { TextTransparency = 1, TextStrokeTransparency = 1 })
			end
		end
	end)
	cleanup(frame, duration + 0.4)
end

local function hazardWarn(data)
	if screenGui then
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(0.7, 0.08)
		label.Position = UDim2.fromScale(0.15, 0.2)
		label.Text = (data.icon or "⚠️") .. "  " .. (data.text or "ATTENTION !")
		label.TextScaled = true
		label.Font = Enum.Font.LuckiestGuy
		label.TextColor3 = data.color or YELLOW
		label.TextStrokeTransparency = 0
		label.ZIndex = 7
		label.Parent = screenGui
		task.spawn(function()
			for i = 1, 8 do
				label.Visible = i % 2 == 1
				task.wait(0.22)
			end
			label:Destroy()
		end)
	end
	if data.position and (data.kind == "puddle" or data.kind == "pillar" or data.kind == "launcher" or data.kind == "sand") then
		Fx.ring(data.position + Vector3.new(0, 0.3, 0), data.color or YELLOW, 5, 2)
		Fx.popText(data.position + Vector3.new(0, 4, 0), data.icon or "⚠️", Color3.new(1, 1, 1), 1.4, 2)
	end
	playSound(SOUND_SWOOSH, nil, 0.5, 0.5)
end

local function crossing(fromSign, y, color, duration, size)
	local p = part({ Size = size or Vector3.new(6, 3, 4), Color = color or YELLOW, Material = Enum.Material.SmoothPlastic })
	local startX, endX = fromSign * 50, -fromSign * 50
	p.CFrame = CFrame.new(startX, y + 1.5, 0)
	tween(p, duration, { CFrame = CFrame.new(endX, y + 1.5, 0) }, Enum.EasingStyle.Linear)
	cleanup(p, duration + 0.1)
	return p
end

local function hazardFx(data)
	local kind = data.kind
	if kind == "puddle" or kind == "sand" then
		local puddle = part({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.2, 1, 1), Color = data.color or SODA, Transparency = 0.25,
			Material = kind == "sand" and Enum.Material.Sand or Enum.Material.Glass, CFrame = CFrame.new(data.position) * CFrame.Angles(0, 0, math.rad(90)) })
		tween(puddle, 0.3, { Size = Vector3.new(0.2, 12, 6) })
		task.delay(data.time or 4, function()
			tween(puddle, 0.4, { Transparency = 1 })
		end)
		cleanup(puddle, (data.time or 4) + 0.5)
	elseif kind == "pillar" or kind == "launcher" then
		local column = part({ Size = Vector3.new(6, 1, 6), Color = data.color or YELLOW, Transparency = 0.25, Material = Enum.Material.Neon, CFrame = CFrame.new(data.position) })
		tween(column, 0.2, { Size = Vector3.new(6, 28, 6), CFrame = CFrame.new(data.position + Vector3.new(0, 14, 0)) }, Enum.EasingStyle.Back)
		task.delay(data.time or 0.6, function()
			tween(column, 0.35, { Transparency = 1 })
		end)
		cleanup(column, (data.time or 0.6) + 0.5)
		CameraRig.shake(0.4, 0.3)
	elseif kind == "dive" and data.position then
		local bird = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(2, 2, 2), Color = data.color or YELLOW })
		bird.CFrame = CFrame.new(data.position + Vector3.new(-30, 30, 0))
		tween(bird, 0.35, { CFrame = CFrame.new(data.position) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		cleanup(bird, 0.5)
		Fx.popText(data.position + Vector3.new(0, 5, 0), "COUCOU !", data.color or YELLOW, 1.2, 1)
	elseif kind == "shockwave" then
		local wave = crossing(data.from or 1, 2, data.color, 0.4, Vector3.new(2, 6, 6))
		wave.Material = Enum.Material.Neon
		wave.Transparency = 0.4
		CameraRig.shake(0.3, 0.3)
	elseif kind == "bounce" then
		CameraRig.shake(0.6, 0.6)
		Fx.popText(Vector3.new(0, 8, 0), "BOING BOING !", data.color or YELLOW, 1.6, 1)
	elseif kind == "spotlight" then
		overlay(Color3.new(0, 0, 0), 0.82, data.time or 1.5)
		local root = data.target and data.target:FindFirstChild("HumanoidRootPart")
		if root then
			local light = Instance.new("SpotLight")
			light.Face = Enum.NormalId.Top
			light.Range = 30
			light.Brightness = 6
			light.Parent = root
			task.delay(data.time or 1.5, function()
				light:Destroy()
			end)
		end
	elseif kind == "flock" then
		overlay(Color3.fromRGB(120, 120, 130), 0.6, data.time or 1, "ROUCOULE !")
		for i = 1, 14 do
			task.delay(i * 0.04, function()
				local bird = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(1.4, 1.2, 1.4), Color = Color3.fromRGB(140, 140, 150) })
				local y = 5 + math.random() * 30
				bird.CFrame = CFrame.new(-80, y, 1)
				tween(bird, 1, { CFrame = CFrame.new(80, y + math.random() * 6, 1) }, Enum.EasingStyle.Linear)
				cleanup(bird, 1.1)
			end)
		end
	elseif kind == "ticket" then
		local head = data.target and data.target:FindFirstChild("Head")
		if head then
			Fx.popText(head.Position + Vector3.new(0, 3, 1), "🎫 0047 !", Color3.fromRGB(255, 60, 60), 1.3, 1.2)
		end
	elseif kind == "sweeper" then
		crossing(data.from or 1, data.y or 2, data.color, data.time or 2.4)
	elseif kind == "conveyor" then
		Fx.popText(Vector3.new(0, 6, 0), (data.dir or 1) > 0 and "➡➡➡" or "⬅⬅⬅", data.color or YELLOW, 2, data.time or 4)
	elseif kind == "notifications" then
		if screenGui then
			for i = 1, 7 do
				local note = Instance.new("TextLabel")
				note.Size = UDim2.fromScale(0.28, 0.08)
				note.Position = UDim2.fromScale(math.random() * 0.7, 0.15 + math.random() * 0.6)
				note.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				note.Text = ({ "❤️ +1", "🔔 Nouvel abonné !", "💬 trop fort", "👍 GG", "🔥🔥🔥" })[i % 5 + 1]
				note.TextScaled = true
				note.Font = Enum.Font.FredokaOne
				note.ZIndex = 6
				note.Parent = screenGui
				Instance.new("UICorner", note).CornerRadius = UDim.new(0, 12)
				cleanup(note, data.time or 2)
			end
		end
	elseif kind == "blackout" then
		overlay(Color3.new(0, 0, 0), 0.95, data.time or 1, "⚡ COUPURE ⚡")
	elseif kind == "whistle" then
		Fx.popText(Vector3.new(0, 12, 0), "PRRRRRT !", Color3.fromRGB(255, 60, 60), 2, 1)
		playSound(SOUND_SWOOSH, nil, 0.8, 2)
	elseif kind == "swap" and data.a and data.b then
		Fx.burst(data.a, Color3.fromRGB(255, 220, 100), 4)
		Fx.burst(data.b, Color3.fromRGB(255, 220, 100), 4)
		Fx.popText((data.a + data.b) / 2 + Vector3.new(0, 6, 0), "🎩 ABRACADABRA !", Color3.fromRGB(255, 220, 100), 1.4, 1)
	elseif kind == "sunbeam" then
		overlay(Color3.fromRGB(255, 240, 160), 0.45, 0.6, "☀️")
	end
end

-- Esquive : silhouettes fantômes laissées derrière le perso (comme les « afterimages » de Brawlhalla)
function Fx.afterimage(model, count)
	count = count or 3
	for n = 0, count - 1 do
		task.delay(n * 0.05, function()
			if not model.Parent then
				return
			end
			for _, p in ipairs(model:GetChildren()) do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p.Transparency < 1 then
					local ghost = part({ Size = p.Size, CFrame = p.CFrame, Color = Color3.fromRGB(190, 225, 255), Material = Enum.Material.Neon, Transparency = 0.55 })
					tween(ghost, 0.22, { Transparency = 1 })
					cleanup(ghost, 0.25)
				end
			end
		end)
	end
end

local dodgeSeen = {}
local function updateDodges()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local start = model:GetAttribute("DodgeStart")
		if start and start ~= dodgeSeen[model] then
			if dodgeSeen[model] ~= nil then
				Fx.afterimage(model, 3)
			end
			dodgeSeen[model] = start
		end
	end
	for model in pairs(dodgeSeen) do
		if not model.Parent then
			dodgeSeen[model] = nil
		end
	end
end

-- Public des arènes : les figurants se balancent et sautent de joie aux gros coups
local crowdBase = {}
local cheerUntil = 0
local function updateCrowd()
	local t = os.clock()
	local cheering = t < cheerUntil
	for _, model in ipairs(CollectionService:GetTagged("Public")) do
		local base = crowdBase[model]
		if not base and model.PrimaryPart then
			base = model:GetPivot()
			crowdBase[model] = base
		end
		if base then
			local phase = (model:GetAttribute("Phase") or 0) * math.pi * 2
			local hop = cheering and math.abs(math.sin(t * 12 + phase)) * 1.5 or math.abs(math.sin(t * 2.5 + phase)) * 0.3
			model:PivotTo(base * CFrame.new(0, hop, 0) * CFrame.Angles(0, 0, math.sin(t * 2 + phase) * 0.08))
		end
	end
	for model in pairs(crowdBase) do
		if not model.Parent then
			crowdBase[model] = nil
		end
	end
end

function Fx.cheer(duration)
	cheerUntil = math.max(cheerUntil, os.clock() + (duration or 1.5))
end

------------------------------------------------------------------------ Statuts au-dessus de la tête
local statusGuis = {}

-- Statuts loufoques (3 s max) : texte au-dessus de la tête, couleur, mouvement
STATUS_LOOK = {
	inverted = { "⇄ ?!", SODA, "sway" },
	stunned = { "★★★", YELLOW, "spin" },
	slowed = { "🐌", Color3.fromRGB(200, 170, 120), "sway" },
	rooted = { "🧶 LIGOTÉ", Color3.fromRGB(230, 120, 200), "shake" },
	laughing = { "😂 HA HA", Color3.fromRGB(255, 240, 120), "shake" },
	blinded = { "😵", Color3.new(1, 1, 1), "sway" },
	dog = { "🐶 OUAF", Color3.fromRGB(200, 140, 90), "sway" },
	asleep = { "💤 Zzz", Color3.fromRGB(170, 200, 255), "sway" },
	frozen = { "🧊 GELÉ", Color3.fromRGB(160, 220, 255), "shake" },
	sneezy = { "🤧", Color3.fromRGB(160, 230, 160), "shake" },
	burning = { "🔥", Color3.fromRGB(255, 120, 40), "shake" },
	slippery = { "💦 GLISSE", Color3.fromRGB(120, 200, 255), "sway" },
	waiting = { "📄 EN ATTENTE", Color3.fromRGB(230, 230, 230), "sway" },
	muted = { "🤐", Color3.new(1, 1, 1), "sway" },
	dancing = { "💃 DANSE !", Color3.fromRGB(255, 80, 200), "shake" },
	statue = { "🗿", Color3.fromRGB(180, 180, 170), "sway" },
	turbo = { "⚡ TURBO", Color3.fromRGB(255, 220, 60), "shake" },
	godmode = { "GOD MODE", Color3.fromRGB(120, 255, 120), "shake" },
	armor = { "🛡️", Color3.fromRGB(200, 200, 255), "sway" },
	viral = { "📈 VIRALE", Color3.fromRGB(255, 120, 200), "shake" },
	tilt = { "😡 TILT", Color3.fromRGB(255, 60, 60), "shake" },
	caprice = { "😭 CAPRICE", Color3.fromRGB(150, 200, 255), "shake" },
	wet = { "💧 TREMPÉ", Color3.fromRGB(120, 190, 255), "sway" },
	rap = { "🎤 RAP", Color3.fromRGB(255, 200, 60), "shake" },
	slow = { "💕 SLOW", Color3.fromRGB(255, 150, 190), "sway" },
	techno = { "🎛️ TECHNO", Color3.fromRGB(120, 255, 220), "shake" },
}

local function statusGui(model)
	local head = model:FindFirstChild("Head")
	if not head then
		return nil
	end
	local gui = statusGuis[model]
	if gui and gui.Parent then
		return gui
	end
	gui = Instance.new("BillboardGui")
	gui.Name = "Statut"
	gui.Size = UDim2.fromScale(4, 1.6)
	gui.StudsOffset = Vector3.new(0, 2.6, 0)
	gui.AlwaysOnTop = true
	gui.Adornee = head
	gui.Parent = folder
	local label = Instance.new("TextLabel")
	label.Name = "Texte"
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.LuckiestGuy
	label.TextStrokeTransparency = 0
	label.Parent = gui
	statusGuis[model] = gui
	return gui
end

local function updateStatuses()
	local now = workspace:GetServerTimeNow()
	local t = os.clock()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local gui = statusGui(model)
		if gui then
			local label = gui.Texte
			local active = (model:GetAttribute("StatusUntil") or 0) > now
			local status = active and model:GetAttribute("Status") or ""
			-- pas de statut : on affiche l'effet positif en cours (Mode Turbo, Virale, Tilt…)
			if status == "" and (model:GetAttribute("BuffUntil") or 0) > now then
				status = model:GetAttribute("Buff") or ""
			end
			local look = STATUS_LOOK[status]
			if look then
				label.Text = look[1]
				label.TextColor3 = look[2]
				local motion = look[3]
				if motion == "spin" then
					label.Rotation = (t * 360) % 360
				elseif motion == "shake" then
					label.Rotation = math.sin(t * 30) * 8
				else
					label.Rotation = math.sin(t * 8) * 15
				end
			else
				label.Text = ""
			end
		end
	end
	for model, gui in pairs(statusGuis) do
		if not model.Parent then
			gui:Destroy()
			statusGuis[model] = nil
		end
	end
end

-- Bulles autour de Gégé selon sa jauge (Petite gorgée)
local bubbleEmitters = {}
local function updateBubbles()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local count = model:GetAttribute("Bulles") or 0
		local emitter = bubbleEmitters[model]
		if count > 0 and not emitter then
			local torso = model:FindFirstChild("UpperTorso")
			if torso then
				emitter = Instance.new("ParticleEmitter")
				emitter.Texture = TEX_SMOKE
				emitter.Color = ColorSequence.new(Color3.fromRGB(220, 255, 180))
				emitter.Size = NumberSequence.new(0.3, 0.1)
				emitter.Transparency = NumberSequence.new(0.3, 1)
				emitter.Lifetime = NumberRange.new(0.8, 1.2)
				emitter.Speed = NumberRange.new(1, 2)
				emitter.Acceleration = Vector3.new(0, 3, 0)
				emitter.SpreadAngle = Vector2.new(180, 180)
				emitter.Parent = torso
				bubbleEmitters[model] = emitter
			end
		end
		if emitter then
			emitter.Rate = count * 6
		end
	end
end

-- Recharge d'énergie : aura qui monte autour du perso, et les effets propres au perso (beats de sa charge)
local charges = {} -- model -> { emitter, start, lastBeatLoop }
local function updateCharges()
	local now = os.clock()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local entry = charges[model]
		local on = Animator.isCharging(model)
		if on and not entry then
			local root = model:FindFirstChild("HumanoidRootPart")
			local data = CharacterList[model:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
			local charge = data and data.charge
			local color = charge and charge.color or ENERGY
			if root then
				local emitter = Instance.new("ParticleEmitter")
				emitter.Texture = TEX_SPARK
				emitter.Color = ColorSequence.new(color, Color3.new(1, 1, 1))
				emitter.Size = NumberSequence.new(0.6, 0.1)
				emitter.Transparency = NumberSequence.new(0.1, 1)
				emitter.Lifetime = NumberRange.new(0.5, 0.8)
				emitter.Speed = NumberRange.new(4, 7)
				emitter.EmissionDirection = Enum.NormalId.Top
				emitter.SpreadAngle = Vector2.new(15, 15)
				emitter.Rate = 45
				emitter.LightEmission = 0.8
				emitter.Shape = Enum.ParticleEmitterShape.Cylinder
				emitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
				emitter.Parent = root
				Fx.ring(root.Position + Vector3.new(0, -2.5, 0), color, 3.5, 0.4)
				entry = { emitter = emitter, start = now, beatsDone = {}, charge = charge }
				charges[model] = entry
			end
		elseif not on and entry then
			entry.emitter.Enabled = false
			cleanup(entry.emitter, 1)
			charges[model] = nil
			local root = model:FindFirstChild("HumanoidRootPart")
			if root and (model:GetAttribute("Energy") or 0) >= Config.ENERGY_MAX - 0.5 then
				Fx.popText(root.Position + Vector3.new(0, 4, 1), "À BLOC !", ENERGY, 1, 0.9)
			end
		end
		if entry and entry.charge and entry.charge.beats then
			-- chaque beat part une fois par boucle de l'animation de recharge
			local charge = entry.charge
			local elapsed = now - entry.start
			local loopIndex = math.floor(elapsed / charge.loop)
			local t = elapsed % charge.loop
			for i, beat in ipairs(charge.beats) do
				local id = loopIndex * 100 + i
				if t >= beat[1] and not entry.beatsDone[id] then
					entry.beatsDone[id] = true
					entry.beatsDone[id - 100] = nil
					Fx.runNamed(model, beat[2], charge)
				end
			end
		end
	end
	for model, entry in pairs(charges) do
		if not model.Parent then
			entry.emitter:Destroy()
			charges[model] = nil
		end
	end
end

------------------------------------------------------------------------ Dash
function Fx.dash(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	if root then
		local back = -(root.CFrame.LookVector.X >= 0 and 1 or -1)
		Fx.ring(root.Position + Vector3.new(back * 1.5, -2.6, 0), Color3.fromRGB(230, 220, 200), 2.5, 0.25)
		emitterAt(root, CFrame.new(0, -2.8, 0), {
			Texture = TEX_SMOKE,
			Color = ColorSequence.new(Color3.fromRGB(220, 210, 190)),
			Size = NumberSequence.new(0.7, 1.8),
			Transparency = NumberSequence.new(0.35, 1),
			Lifetime = NumberRange.new(0.3, 0.5),
			Speed = NumberRange.new(2, 4),
			SpreadAngle = Vector2.new(40, 10),
			Rate = 90,
		}, 0.18)
		playSound(SOUND_SWOOSH, root, 0.3, 1.4)
	end
end

------------------------------------------------------------------------ Objets à ramasser
local function itemInfo(id)
	return Items.LIST[id or ""]
end

local function onItemEvent(kind, data)
	if kind == "ItemSpawn" then
		local info = itemInfo(data.id)
		Fx.ring(data.position, info and info.color or YELLOW, 4, 0.5)
		Fx.popText(data.position + Vector3.new(0, 3, 0), info and info.icon or "?", Color3.new(1, 1, 1), 0.9, 1)
	elseif kind == "ItemTaken" then
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		local info = itemInfo(data.id)
		if root and info then
			Fx.popText(root.Position + Vector3.new(0, 4.5, 1), info.icon .. " " .. string.upper(info.name), info.color, 0.8, 1.1)
			playSound(SOUND_SWOOSH, root, 0.4, 1.8)
		end
		if data.model then
			task.defer(Fx.onMirror, data.model, Animator.isMirrored(data.model))
		end
	elseif kind == "CrateOpened" then
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		if root then
			local position = root.Position
			Fx.burst(position + Vector3.new(0, 1, 0), Color3.fromRGB(200, 140, 60), 4)
			Fx.ring(position, Color3.fromRGB(255, 220, 60), 6, 0.5)
			Fx.popText(position + Vector3.new(0, 4.5, 1), "📦 ARME SORTIE !", Color3.fromRGB(255, 220, 60), 0.9, 1.2)
			playSound(SOUND_SWOOSH, root, 0.5, 1.4)
		end
		if data.model then
			task.defer(Fx.onMirror, data.model, Animator.isMirrored(data.model))
		end
	elseif kind == "ItemBroken" then
		if data.position then
			Fx.burst(data.position, Color3.fromRGB(230, 200, 140), 3)
			Fx.popText(data.position + Vector3.new(0, 3.5, 1), "CASSÉ !", Color3.fromRGB(230, 200, 140), 1, 0.9)
		end
	elseif kind == "Explosion" then
		local p = data.position
		Fx.burst(p, Color3.fromRGB(255, 120, 30), data.radius * 1.4)
		Fx.ring(p, Color3.fromRGB(255, 220, 80), data.radius * 1.2, 0.45)
		Fx.popText(p + Vector3.new(0, 3, 0), "KABOUM !", Color3.fromRGB(255, 90, 30), 2, 1.1)
		local smoke = part({ Size = Vector3.new(0.2, 0.2, 0.2), Transparency = 1, Position = p })
		local emitter = Instance.new("ParticleEmitter")
		emitter.Texture = TEX_SMOKE
		emitter.Color = ColorSequence.new(Color3.fromRGB(90, 80, 80))
		emitter.Size = NumberSequence.new(3, 7)
		emitter.Transparency = NumberSequence.new(0.2, 1)
		emitter.Lifetime = NumberRange.new(0.8, 1.3)
		emitter.Speed = NumberRange.new(6, 12)
		emitter.SpreadAngle = Vector2.new(180, 180)
		emitter.Parent = smoke
		emitter:Emit(30)
		cleanup(smoke, 2)
		CameraRig.shake(0.8, 0.4)
		playSound(SOUND_HIT, nil, 1, 0.5)
	elseif kind == "Obese" then
		local root = data.model and data.model:FindFirstChild("HumanoidRootPart")
		if root then
			Fx.popText(root.Position + Vector3.new(0, 4, 1), "MIAM MIAM !", Color3.fromRGB(240, 170, 60), 1.4, 1.2)
		end
	elseif kind == "Splat" then
		Fx.burst(data.position, Color3.fromRGB(230, 160, 50), 2.5)
		Fx.popText(data.position + Vector3.new(0, 2, 0), "SPLATCH", Color3.fromRGB(230, 160, 50), 0.8, 0.7)
	elseif kind == "Grab" then
		if data.position then
			Fx.popText(data.position + Vector3.new(0, 3.5, 1), "CHOPÉ !", Color3.fromRGB(200, 140, 255), 1, 0.8)
		end
	elseif kind == "TooHeavy" then
		local root = data.target and data.target:FindFirstChild("HumanoidRootPart")
		if root then
			Fx.popText(root.Position + Vector3.new(0, 4, 1), "TROP LOURD !", Color3.fromRGB(240, 170, 60), 1, 0.9)
		end
	elseif kind == "GeyserWarn" then
		emitterAt(workspace.Terrain, CFrame.new(data.position), {
			Texture = TEX_SMOKE,
			Color = ColorSequence.new(SODA),
			Size = NumberSequence.new(0.5, 0.2),
			Transparency = NumberSequence.new(0.2, 1),
			Lifetime = NumberRange.new(0.4, 0.8),
			Speed = NumberRange.new(4, 8),
			SpreadAngle = Vector2.new(20, 20),
			Rate = 70,
		}, 1.3)
		Fx.popText(data.position + Vector3.new(0, 2, 0), "BLOUB BLOUB…", SODA, 0.8, 1.2)
	elseif kind == "Geyser" then
		local column = part({ Size = Vector3.new(4, 1, 4), Color = SODA, Transparency = 0.25, Material = Enum.Material.Neon, CFrame = CFrame.new(data.position) })
		tween(column, 0.25, { Size = Vector3.new(4, 30, 4), CFrame = CFrame.new(data.position + Vector3.new(0, 15, 0)) }, Enum.EasingStyle.Back)
		task.delay(1, function()
			tween(column, 0.4, { Transparency = 1, Size = Vector3.new(1, 30, 1) })
		end)
		cleanup(column, 1.5)
		Fx.popText(data.position + Vector3.new(0, 8, 0), "PSCHHHT !", SODA, 1.5, 1)
		playSound(SOUND_SPLASH, nil, 0.7, 0.8)
	end
end

-- Bombe en main : elle rougit de plus en plus et clignote de plus en plus vite avant d'exploser.
-- Gavé de croustillant : un énorme ventre (posé sur ce client seulement).
local bellies = {}
local function updateHeldEffects()
	local serverNow = workspace:GetServerTimeNow()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		if model:GetAttribute("Held") == "bomb" then
			local held = model:FindFirstChild("Tenu")
			local t = math.clamp((serverNow - (model:GetAttribute("HeldSince") or serverNow)) / Config.BOMB_FUSE, 0, 1)
			local blink = math.sin(os.clock() * (4 + 26 * t)) > 0
			local color = Color3.fromRGB(30, 30, 35):Lerp(Color3.fromRGB(255, 40, 20), t)
			if blink and t > 0.5 then
				color = color:Lerp(Color3.new(1, 1, 1), 0.35)
			end
			for _, p in ipairs(held and held:GetDescendants() or {}) do
				if p:IsA("BasePart") and p.Name == "Bombe" then
					p.Color = color
					p.Material = t > 0.6 and Enum.Material.Neon or Enum.Material.SmoothPlastic
				end
			end
		end
		local obese = (model:GetAttribute("ObeseUntil") or 0) > serverNow
		local belly = bellies[model]
		if obese and not belly then
			local torso = model:FindFirstChild("UpperTorso")
			if torso then
				belly = part({ Shape = Enum.PartType.Ball, Size = Vector3.new(1, 1, 1), Color = torso.Color, Material = Enum.Material.SmoothPlastic, Anchored = false, Massless = true, CanCollide = false, CanQuery = false })
				belly.CFrame = torso.CFrame * CFrame.new(0, -0.6, -0.8)
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = torso
				weld.Part1 = belly
				weld.Parent = belly
				belly.Parent = model
				tween(belly, 0.35, { Size = Vector3.new(4.2, 3.6, 3.6) }, Enum.EasingStyle.Back)
				bellies[model] = belly
			end
		elseif not obese and belly then
			bellies[model] = nil
			tween(belly, 0.2, { Size = Vector3.new(0.5, 0.5, 0.5) })
			cleanup(belly, 0.25)
			local root = model:FindFirstChild("HumanoidRootPart")
			if root and model.Parent then
				Fx.popText(root.Position + Vector3.new(0, 4, 1), "PFFFFT…", Color3.fromRGB(240, 170, 60), 1, 0.9)
			end
		end
	end
end

------------------------------------------------------------------------ Éjections (KO)
function Fx.onKO(data)
	Fx.cheer(2) -- le public exulte
	-- l'explosion part du bord de l'écran le plus proche, pour rester visible
	local p = data.position or Vector3.zero
	local b = Config.BLAST
	local position = Vector3.new(math.clamp(p.X, b.left + 12, b.right - 12), math.clamp(p.Y, b.bottom + 10, b.top - 10), 0)
	Fx.burst(position, Color3.fromRGB(255, 90, 40), 9)
	Fx.ring(position, Color3.fromRGB(255, 220, 80), 12, 0.5)
	Fx.popText(position + Vector3.new(0, 3, 0), "KO !", Color3.fromRGB(255, 70, 40), 2.2, 1.2)
	CameraRig.shake(0.9, 0.45)
	playSound(SOUND_HIT, nil, 0.9, 0.6)
	local attackerRoot = data.attacker and data.attacker:FindFirstChild("HumanoidRootPart")
	if attackerRoot and workspace:GetAttribute("MatchMode") == "time" then
		Fx.popText(attackerRoot.Position + Vector3.new(0, 4.5, 1), "+1", Color3.fromRGB(120, 255, 120), 1.3, 1.1)
	end
end

------------------------------------------------------------------------ Frappe chargée, protection, retour
-- Lueur jaune → orange pendant qu'on maintient J/K, clignotement blanc tant qu'on est protégé
local glows = {} -- model -> { highlight, sparkle }
local function updateGlows()
	local serverNow = workspace:GetServerTimeNow()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local entry = glows[model]
		local charge = Animator.holdCharge(model)
		local protected = model:GetAttribute("Protected") or (model:GetAttribute("ProtectedUntil") or 0) > serverNow
		local away = model:GetAttribute("Away")
		if (charge or protected) and not away then
			if not entry then
				local h = Instance.new("Highlight")
				h.DepthMode = Enum.HighlightDepthMode.Occluded
				h.Parent = model
				entry = { highlight = h }
				glows[model] = entry
			end
			local h = entry.highlight
			if charge then
				h.FillColor = Color3.fromRGB(255, 230, 60):Lerp(Color3.fromRGB(255, 100, 20), charge)
				h.OutlineColor = h.FillColor
				h.FillTransparency = 0.75 - 0.35 * charge + 0.1 * math.sin(os.clock() * (10 + 20 * charge))
				h.OutlineTransparency = 0.2
				local hand = partOf(model, "RightHand")
				if hand and not entry.sparkle then
					entry.sparkle = Instance.new("ParticleEmitter")
					entry.sparkle.Texture = TEX_SPARK
					entry.sparkle.Color = ColorSequence.new(Color3.fromRGB(255, 220, 80), Color3.fromRGB(255, 120, 30))
					entry.sparkle.Size = NumberSequence.new(0.5, 0)
					entry.sparkle.Lifetime = NumberRange.new(0.2, 0.4)
					entry.sparkle.Speed = NumberRange.new(3, 6)
					entry.sparkle.SpreadAngle = Vector2.new(180, 180)
					entry.sparkle.LightEmission = 1
					entry.sparkle.Parent = hand
				end
				if entry.sparkle then
					entry.sparkle.Rate = 20 + 80 * charge
				end
			else
				-- protégé : on clignote, comme dans Smash
				h.FillColor = Color3.new(1, 1, 1)
				h.OutlineColor = Color3.fromRGB(150, 230, 255)
				local blink = math.sin(os.clock() * 18) > 0
				h.FillTransparency = blink and 0.45 or 0.9
				h.OutlineTransparency = 0.1
				if entry.sparkle then
					entry.sparkle:Destroy()
					entry.sparkle = nil
				end
			end
		elseif entry then
			entry.highlight:Destroy()
			if entry.sparkle then
				entry.sparkle:Destroy()
			end
			glows[model] = nil
		end
	end
	for model, entry in pairs(glows) do
		if not model.Parent then
			entry.highlight:Destroy()
			glows[model] = nil
		end
	end
end

-- Animation de retour propre à chaque perso : on rejoue ses « beats » (effets) au bon moment
local respawns = {} -- model -> { start, done }
local function updateRespawns()
	local serverNow = workspace:GetServerTimeNow()
	for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
		local start = model:GetAttribute("RespawnStart")
		local data = CharacterList[model:GetAttribute("Character") or Config.DEFAULT_CHARACTER]
		local respawn = data and data.respawn
		if start and respawn and respawn.beats and serverNow - start <= respawn.duration + 0.5 then
			local entry = respawns[model]
			if not entry or entry.start ~= start then
				entry = { start = start, done = {} }
				respawns[model] = entry
			end
			local elapsed = serverNow - start
			for i, beat in ipairs(respawn.beats) do
				if elapsed >= beat[1] and not entry.done[i] then
					entry.done[i] = true
					-- un beat raté de plus d'une demi-seconde (arrivée en cours de route) est sauté
					if elapsed - beat[1] < 0.5 then
						Fx.runNamed(model, beat[2], respawn)
					end
				end
			end
		end
	end
	for model in pairs(respawns) do
		if not model.Parent then
			respawns[model] = nil
		end
	end
end

-- Le perso se retourne : son arme passe dans l'autre main (celle du côté de la caméra).
-- L'arme (bouteille de Gégé, canne de Mamie…) n'apparaît qu'une fois la Caisse Bizarre ouverte (attribut Armed) ;
-- avec un objet à lancer en main, l'arme disparaît et c'est l'objet qui passe d'une main à l'autre.
function Fx.onMirror(model, mirrored)
	local costume = model:FindFirstChild("Costume")
	local held = model:FindFirstChild("Tenu")
	local holding = (model:GetAttribute("Held") or "") ~= "" or model:GetAttribute("Armed") ~= true
	local pairsToSet = {}
	if costume then
		table.insert(pairsToSet, { costume:FindFirstChild("PropBottle"), not holding and not mirrored })
		table.insert(pairsToSet, { costume:FindFirstChild("PropBottle_M"), not holding and mirrored })
		-- objets toujours en main des autres persos (canne, tampon, poêle…) : même principe que la bouteille
		for _, prop in ipairs(costume:GetChildren()) do
			if prop:IsA("Model") and prop.Name ~= "PropBottle" and string.sub(prop.Name, 1, 4) == "Prop" then
				local isMirror = string.sub(prop.Name, -2) == "_M"
				local base = isMirror and costume:FindFirstChild(string.sub(prop.Name, 1, -3)) or prop
				if base and base:GetAttribute("AlwaysShown") then
					table.insert(pairsToSet, { prop, not holding and (isMirror == mirrored) })
				end
			end
		end
	end
	if held then
		table.insert(pairsToSet, { held:FindFirstChild("Prop"), not mirrored })
		table.insert(pairsToSet, { held:FindFirstChild("Prop_M"), mirrored })
	end
	for _, pair in ipairs(pairsToSet) do
		local prop, visible = pair[1], pair[2]
		if prop then
			for _, p in ipairs(prop:GetDescendants()) do
				if p:IsA("BasePart") then
					p.Transparency = visible and (p:GetAttribute("BaseTransparency") or 0) or 1
				end
			end
		end
	end
end

------------------------------------------------------------------------ Démarrage
function Fx.start()
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EffetsEcran"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 5
	screenGui.Parent = playerGui

	Animator.onMoveStart = Fx.onMoveStart
	Animator.onDash = Fx.dash
	Animator.onMirror = Fx.onMirror
	Animator.onLand = onLand
	Animator.onTakeoff = onTakeoff
	Animator.onAirJump = onAirJump
	-- Diagnostic des animations : vert si les 15 articulations sont trouvées, rouge sinon
	Animator.onReport = function(model, text, ok)
		if not Config.ANIM_DEBUG or (ok and model ~= Players.LocalPlayer.Character) then
			return
		end
		local label = Instance.new("TextLabel")
		label.AnchorPoint = Vector2.new(0.5, 0)
		label.Position = UDim2.new(0.5, 0, 0, ok and 8 or 40)
		label.Size = UDim2.fromOffset(620, 28)
		label.BackgroundColor3 = ok and Color3.fromRGB(30, 110, 50) or Color3.fromRGB(160, 30, 30)
		label.BackgroundTransparency = 0.15
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextWrapped = true
		label.Text = text
		label.Parent = screenGui
		task.delay(ok and 8 or 30, function()
			label:Destroy()
		end)
	end

	local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Fx")
	remote.OnClientEvent:Connect(function(kind, data)
		if kind == "Hit" then
			Fx.onHit(data)
		elseif kind == "KO" then
			Fx.onKO(data)
		elseif kind == "Projectile" then
			Fx.spawnProjectile(data)
		elseif kind == "ProjectileEnd" then
			Fx.endProjectile(data)
		elseif kind == "ProjectileUpdate" then
			Fx.updateProjectile(data)
		elseif kind == "ItemSpawn" or kind == "ItemTaken" or kind == "ItemBroken" or kind == "Explosion" or kind == "Obese"
			or kind == "Splat" or kind == "Grab" or kind == "TooHeavy" or kind == "GeyserWarn" or kind == "Geyser" then
			onItemEvent(kind, data)
		elseif kind == "Object" or kind == "ObjectEnd" or kind == "Grapple" or kind == "Counter" or kind == "Absorbed"
			or kind == "Sneeze" or kind == "Buff" or kind == "Popup" or kind == "FatalFx" then
			onSpecialEvent(kind, data)
		elseif kind == "HazardWarn" then
			hazardWarn(data)
		elseif kind == "HazardFx" then
			hazardFx(data)
		elseif kind == "Fatal" then
			Fx.cheer(4)
			local root = data.target and data.target:FindFirstChild("HumanoidRootPart")
			if root then
				CameraRig.punch(root.Position, 0.45, 3)
			end
		end
	end)

	RunService.RenderStepped:Connect(function()
		updateStatuses()
		updateBubbles()
		updateCharges()
		updateGlows()
		updateRespawns()
		updateHeldEffects()
		updateObjects()
		updateCrowd()
		updateDodges()
	end)
end

return Fx
