-- Caméra de côté façon Smash : cadre tous les combattants et zoome selon leur écartement.
-- Placée côté +Z et regardant vers -Z : la droite de l'écran = +X du monde.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local GameData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameData"))

local CameraRig = {}
local focus = Vector3.new(0, 12, 0)
local dist = 70
local shake = 0

function CameraRig.shake(amount: number)
	shake = math.max(shake, amount)
end

local function update(dt: number)
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable
	cam.FieldOfView = 40
	local state = ReplicatedStorage:FindFirstChild("GameState")
	local phase = state and state:GetAttribute("Phase") or "Lobby"
	local B = GameData.Layout.blast

	local wantFocus, wantDist
	if phase == "Lobby" then
		local t = os.clock() * 0.15
		wantFocus = Vector3.new(math.sin(t) * 10, 12, 0)
		wantDist = 95
	else
		local minP, maxP
		local folder = workspace:FindFirstChild("Fighters")
		if folder then
			for _, m in folder:GetChildren() do
				local hrp = m:FindFirstChild("HumanoidRootPart")
				if hrp and math.abs(hrp.Position.Z) < 50 and hrp.Position.Y < 300 then
					local p = hrp.Position
					minP = if minP then minP:Min(p) else p
					maxP = if maxP then maxP:Max(p) else p
				end
			end
		end
		if minP then
			local c = (minP + maxP) / 2
			local spread = math.max(maxP.X - minP.X, (maxP.Y - minP.Y) * 1.7)
			wantFocus = Vector3.new(
				math.clamp(c.X, B.left + 40, B.right - 40),
				math.clamp(c.Y + 4, B.bottom + 30, B.top - 25),
				0
			)
			wantDist = math.clamp(spread * 1.25 + 42, 52, 150)
		else
			wantFocus = Vector3.new(0, 12, 0)
			wantDist = 80
		end
	end
	local k = 1 - math.exp(-4 * dt)
	focus = focus:Lerp(wantFocus, k)
	dist += (wantDist - dist) * k
	local offset = Vector3.zero
	if shake > 0 then
		offset = Vector3.new((math.random() - 0.5) * shake, (math.random() - 0.5) * shake, 0)
		shake = math.max(0, shake - dt * 6)
	end
	local pos = focus + Vector3.new(0, dist * 0.18, dist) + offset
	cam.CFrame = CFrame.lookAt(pos, focus + offset)
end

function CameraRig.start()
	RunService:BindToRenderStep("BBCamera", Enum.RenderPriority.Camera.Value + 1, update)
end

return CameraRig
