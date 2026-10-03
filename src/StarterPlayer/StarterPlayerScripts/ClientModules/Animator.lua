-- Anime tous les combattants côté client avec les poses procédurales (Motor6D.Transform).
-- Les coups suivent les 4 phases : avant le coup -> élan -> frappe -> retour.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Pose = require(Shared.Pose)
local Fighters = require(Shared.Fighters)
local CharacterBuilder = require(Shared.CharacterBuilder)

local Animator = {}

local STATUS_ICON = {
	invert = "🔄", slow = "🐌", root = "🧶", stun = "💫", blind = "🙈", laugh = "😂",
	dog = "🐶", burn = "🔥", sneeze = "🤧", slip = "💦",
}

type Rec = {
	model: Model,
	motors: { [string]: Motor6D },
	w: number,
	h: number,
	pose: any,
	move: any?,
	moveT0: number,
	victory: boolean,
	runPhase: number,
	tag: BillboardGui?,
	chute: BasePart?,
	predictedUntil: number,
}

local recs: { [Model]: Rec } = {}
local localModel: Model? = nil

local function now(): number
	return workspace:GetServerTimeNow()
end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Include

local function grounded(model: Model, hrp: BasePart, h: number): boolean
	local arena = workspace:FindFirstChild("Arena")
	if not arena then
		return true
	end
	rayParams.FilterDescendantsInstances = { arena:FindFirstChild("Solid"), arena:FindFirstChild("Soft") }
	return workspace:Raycast(hrp.Position, Vector3.new(0, -(1 + 1.8 * h + 0.6), 0), rayParams) ~= nil
end

local function makeTag(model: Model, h: number): BillboardGui
	local gui = Instance.new("BillboardGui")
	gui.Name = "BBTag"
	gui.Size = UDim2.fromOffset(160, 44)
	gui.StudsOffsetWorldSpace = Vector3.new(0, 3.2 * h, 0)
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	local name = Instance.new("TextLabel")
	name.Name = "Name"
	name.Size = UDim2.new(1, 0, 0.5, 0)
	name.BackgroundTransparency = 1
	name.Font = Enum.Font.FredokaOne
	name.TextScaled = true
	name.TextColor3 = Color3.new(1, 1, 1)
	name.TextStrokeTransparency = 0.3
	name.Text = model:GetAttribute("DisplayName") or model.Name
	name.Parent = gui
	local st = Instance.new("TextLabel")
	st.Name = "Status"
	st.Position = UDim2.fromScale(0, 0.5)
	st.Size = UDim2.new(1, 0, 0.5, 0)
	st.BackgroundTransparency = 1
	st.Font = Enum.Font.GothamBold
	st.TextScaled = true
	st.Text = ""
	st.Parent = gui
	gui.Adornee = model:FindFirstChild("Head") :: BasePart
	gui.Parent = model
	return gui
end

local function track(model: Model)
	if recs[model] then
		return
	end
	local w = model:GetAttribute("ScaleW") or 1
	local h = model:GetAttribute("ScaleH") or 1
	local rec: Rec = {
		model = model,
		motors = CharacterBuilder.motors(model),
		w = w,
		h = h,
		pose = Pose.Garde,
		move = nil,
		moveT0 = 0,
		victory = false,
		runPhase = 0,
		tag = nil,
		chute = nil,
		predictedUntil = 0,
	}
	rec.tag = makeTag(model, h)
	recs[model] = rec
end

function Animator.setLocal(model: Model?)
	localModel = model
end

-- Joue un coup (événement serveur « Move » ou prédiction locale)
function Animator.play(model: Model, info, predicted: boolean?)
	local rec = recs[model]
	if not rec then
		track(model)
		rec = recs[model]
	end
	if not predicted and model == localModel and os.clock() < rec.predictedUntil then
		return -- déjà joué en local au moment de l'appui
	end
	rec.move = {
		anim = info.anim, startup = info.s, active = info.a, recovery = info.r, hits = info.hits or 1,
	}
	rec.moveT0 = os.clock()
	if predicted then
		rec.predictedUntil = os.clock() + 0.4
	end
end

function Animator.victory(model: Model)
	local rec = recs[model]
	if rec then
		rec.victory = true
	end
end

local function chute(rec: Rec, on: boolean)
	if on and not rec.chute then
		local head = rec.model:FindFirstChild("Head") :: BasePart
		if not head then
			return
		end
		local p = Instance.new("Part")
		p.Name = "Parachute"
		p.Shape = Enum.PartType.Ball
		p.Size = Vector3.new(7, 7, 7) * rec.w
		p.Color = Color3.fromRGB(255, 120, 40)
		p.Material = Enum.Material.Fabric
		p.CanCollide, p.CanQuery, p.CanTouch, p.Massless = false, false, false, true
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Sphere
		mesh.Scale = Vector3.new(1, 0.45, 1)
		mesh.Parent = p
		p.CFrame = head.CFrame * CFrame.new(0, 5 * rec.h, 0)
		local wc = Instance.new("WeldConstraint")
		wc.Part0, wc.Part1 = head, p
		wc.Parent = p
		p.Parent = rec.model
		rec.chute = p
	elseif not on and rec.chute then
		rec.chute:Destroy()
		rec.chute = nil
	end
end

local function setFlicker(model: Model, alpha: number)
	for _, d in model:GetChildren() do
		if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
			d.LocalTransparencyModifier = alpha
		end
	end
end

local statusTimer = 0

local function update(dt: number)
	local t = now()
	statusTimer -= dt
	local refreshStatus = statusTimer <= 0
	if refreshStatus then
		statusTimer = 0.2
	end
	local folder = workspace:FindFirstChild("Fighters")
	if folder then
		for _, m in folder:GetChildren() do
			if m:IsA("Model") and not recs[m] and m:FindFirstChild("HumanoidRootPart") then
				track(m)
			end
		end
	end
	for model, rec in recs do
		if not model.Parent then
			recs[model] = nil
			continue
		end
		local hrp = model:FindFirstChild("HumanoidRootPart") :: BasePart
		if not hrp then
			continue
		end
		local key = model:GetAttribute("Fighter")
		local target
		local direct = false
		local grabbedUntil = model:GetAttribute("Grabbed") or 0
		local hurtUntil = model:GetAttribute("HurtUntil") or 0
		local dodgeUntil = model:GetAttribute("DodgeUntil") or 0
		local charging = model:GetAttribute("Charging")

		if rec.victory then
			target = Pose.state("victory")
		elseif grabbedUntil > t then
			target = Pose.state("grabbed")
		elseif hurtUntil > t then
			target = Pose.state("hurt")
			rec.move = nil
		elseif rec.move then
			local el = os.clock() - rec.moveT0
			local m = rec.move
			if el < m.startup + m.active + m.recovery then
				target = Pose.sampleMove(m, el)
				direct = true
			else
				rec.move = nil
			end
		end
		if not target then
			if charging then
				local mv = Fighters.move(key, model:GetAttribute("Armed") == true, charging)
				target = Pose.charge(mv)
			elseif dodgeUntil > t then
				target = Pose.state("dodge")
			else
				local v = hrp.AssemblyLinearVelocity
				if not grounded(model, hrp, rec.h) then
					target = Pose.state(if v.Y > 2 then "jump" else "fall")
				elseif math.abs(v.X) > 3 then
					rec.runPhase += math.abs(v.X) * dt / (7 * rec.h)
					target = Pose.run(rec.runPhase)
				else
					target = table.clone(Pose.Garde)
					local b = math.sin(os.clock() * 2.4) * 0.05
					local rp = Pose.Garde.RootPos
					target.RootPos = { rp[1], rp[2] + b, rp[3] }
				end
			end
		end
		if direct then
			rec.pose = target
		else
			rec.pose = Pose.lerp(rec.pose, target, 1 - math.exp(-18 * dt))
		end
		Pose.apply(rec.motors, rec.pose, rec.w, rec.h)

		-- Retour 🪂, invulnérabilité, esquive
		chute(rec, (model:GetAttribute("Parachute") or 0) > t)
		local inv = (model:GetAttribute("Invuln") or 0) > t
		if dodgeUntil > t then
			setFlicker(model, 0.55)
		elseif inv then
			setFlicker(model, if math.floor(os.clock() * 12) % 2 == 0 then 0.5 else 0)
		else
			setFlicker(model, 0)
		end

		if refreshStatus and rec.tag then
			local icons = {}
			for name, icon in STATUS_ICON do
				local until_ = model:GetAttribute("St_" .. name)
				if until_ and until_ > t then
					table.insert(icons, icon)
				end
			end
			if (model:GetAttribute("Frozen") or 0) > t then
				table.insert(icons, "🧊")
			end
			local forms = model:GetAttribute("Forms") or 0
			if forms > 0 then
				table.insert(icons, string.rep("📄", forms))
			end
			local status = rec.tag:FindFirstChild("Status") :: TextLabel
			status.Text = table.concat(icons, " ")
			local nameL = rec.tag:FindFirstChild("Name") :: TextLabel
			nameL.Text = (model:GetAttribute("DisplayName") or model.Name)
			rec.tag.Enabled = true
		end
	end
end

function Animator.start()
	RunService:BindToRenderStep("BBAnimator", Enum.RenderPriority.Character.Value + 1, update)
end

return Animator
