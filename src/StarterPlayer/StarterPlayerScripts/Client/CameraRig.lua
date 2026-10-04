-- Caméra de côté centrée sur le perso que l'on contrôle : elle le suit de près, regarde un peu devant lui
-- quand il court, et ne part jamais vers les autres. Spectateur (pas dans la partie, éliminé) : elle cadre
-- tous les combattants encore en jeu.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"))

local CameraRig = {}

local MIN_DISTANCE = 28 -- assez près pour bien voir les coups quand les combattants sont proches
local MAX_DISTANCE = 120
local SMOOTHING = 6

-- Tremblement (impacts) et zoom dramatique (super, coup fatal)
local shakeAmount, shakeUntil, shakeDuration = 0, 0, 1
local punchTarget, punchZoom, punchUntil, punchDuration = nil, 1, 0, 1

function CameraRig.shake(amount, duration)
	if not Config.CAMERA_SHAKE then
		return
	end
	local now = os.clock()
	if now >= shakeUntil or amount >= shakeAmount then
		shakeAmount, shakeDuration = amount, duration
		shakeUntil = now + duration
	end
end

-- Zoom vers un point : zoomFactor < 1 rapproche la caméra
function CameraRig.punch(position, zoomFactor, duration)
	punchTarget, punchZoom, punchDuration = position, zoomFactor, duration
	punchUntil = os.clock() + duration
end

function CameraRig.start()
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = 50
	local focus = Vector3.new(0, 10, 0)
	local distance = 45
	local lookAhead = 0

	RunService:BindToRenderStep("CameraCombat", Enum.RenderPriority.Camera.Value + 1, function(dt)
		camera.CameraType = Enum.CameraType.Scriptable
		local now = os.clock()
		-- notre perso, s'il est en jeu : la caméra ne suit que lui
		local mine = Players.LocalPlayer.Character
		local myRoot = mine and mine:FindFirstChild("HumanoidRootPart")
		local following = myRoot ~= nil and CollectionService:HasTag(mine, "Fighter") and not mine:GetAttribute("Eliminated")
			and not mine:GetAttribute("Parked")
		if following then
			local p = myRoot.Position
			local v = myRoot.AssemblyLinearVelocity
			-- un peu d'avance dans le sens de la course, pour voir où l'on va
			lookAhead += (math.clamp(v.X * 0.12, -Config.CAMERA_LOOKAHEAD, Config.CAMERA_LOOKAHEAD) - lookAhead) * math.min(1, dt * 3)
			local targetFocus = Vector3.new(p.X + lookAhead, p.Y + 2, 0)
			local targetDistance = Config.CAMERA_DISTANCE
			if now < punchUntil then
				-- coup fatal, Super, gros impact : seulement un zoom, la caméra reste sur nous
				local t = 1 - (punchUntil - now) / punchDuration
				local weight = t < 0.15 and t / 0.15 or 1 - math.max(0, (t - 0.7) / 0.3)
				targetDistance *= 1 + (math.max(punchZoom, 0.6) - 1) * weight
			end
			-- suit vite à l'horizontale, plus doucement en hauteur (pas de secousse à chaque saut)
			local ax = math.min(1, dt * Config.CAMERA_FOLLOW)
			local ay = math.min(1, dt * Config.CAMERA_FOLLOW * 0.6)
			focus = Vector3.new(focus.X + (targetFocus.X - focus.X) * ax, focus.Y + (targetFocus.Y - focus.Y) * ay, 0)
			-- s'il s'éloigne d'un coup (éjection, retour sur la plateforme), on le rattrape tout de suite
			if math.abs(targetFocus.X - focus.X) > 40 or math.abs(targetFocus.Y - focus.Y) > 40 then
				focus = targetFocus
			end
			distance += (targetDistance - distance) * math.min(1, dt * 4)
			local cf = CFrame.lookAt(focus + Vector3.new(0, distance * 0.12, distance), focus)
			if now < shakeUntil then
				local k = shakeAmount * (shakeUntil - now) / shakeDuration * 0.6
				local n = now * 40
				cf *= CFrame.new(math.noise(n, 0) * k * 2, math.noise(0, n) * k * 2, 0)
			end
			camera.CFrame = cf
			return
		end
		local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
		for _, model in ipairs(CollectionService:GetTagged("Fighter")) do
			local root = model:FindFirstChild("HumanoidRootPart")
			if root and not model:GetAttribute("Eliminated") and not model:GetAttribute("Away") then
				local p = root.Position
				minX, maxX = math.min(minX, p.X), math.max(maxX, p.X)
				minY, maxY = math.min(minY, p.Y), math.max(maxY, p.Y)
			end
		end
		local targetFocus, targetDistance = Vector3.new(0, 10, 0), 45
		if minX <= maxX then
			targetFocus = Vector3.new((minX + maxX) / 2, (minY + maxY) / 2 + 2, 0)
			targetDistance = math.clamp(math.max((maxX - minX) * 1.15 + 12, (maxY - minY) * 1.8 + 10), MIN_DISTANCE, MAX_DISTANCE)
		end
		if now < punchUntil and punchTarget then
			-- entrée rapide, sortie douce
			local t = 1 - (punchUntil - now) / punchDuration
			local weight = t < 0.15 and t / 0.15 or 1 - math.max(0, (t - 0.7) / 0.3)
			targetFocus = targetFocus:Lerp(punchTarget + Vector3.new(0, 2, 0), weight)
			targetDistance *= 1 + (punchZoom - 1) * weight
		end
		local alpha = math.min(1, dt * SMOOTHING * (now < punchUntil and 2 or 1))
		focus = focus:Lerp(targetFocus, alpha)
		distance += (targetDistance - distance) * alpha
		local cf = CFrame.lookAt(focus + Vector3.new(0, distance * 0.12, distance), focus)
		if now < shakeUntil then
			local k = shakeAmount * (shakeUntil - now) / shakeDuration
			local n = now * 40
			cf *= CFrame.new(math.noise(n, 0) * k * 2, math.noise(0, n) * k * 2, 0) * CFrame.Angles(0, 0, math.noise(n, n) * k * 0.05)
		end
		camera.CFrame = cf
	end)
end

return CameraRig
