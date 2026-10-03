-- Accès aux RemoteEvents (créés par le serveur, attendus par le client).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Net = {}

local NAMES = { "ToServer", "ToClient" }

local function folder()
	if RunService:IsServer() then
		local f = ReplicatedStorage:FindFirstChild("Remotes")
		if not f then
			f = Instance.new("Folder")
			f.Name = "Remotes"
			f.Parent = ReplicatedStorage
		end
		for _, n in NAMES do
			if not f:FindFirstChild(n) then
				local r = Instance.new("RemoteEvent")
				r.Name = n
				r.Parent = f
			end
		end
		return f
	end
	return ReplicatedStorage:WaitForChild("Remotes")
end

function Net.get(name: string): RemoteEvent
	return folder():WaitForChild(name) :: RemoteEvent
end

return Net
