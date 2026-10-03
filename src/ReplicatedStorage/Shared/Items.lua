-- Objets qui tombent sur l'arène, comme les armes de Brawlhalla : tout le monde peut les ramasser (✋ / U).
--   kind = "crate"     : la Caisse Bizarre. On l'ouvre en la ramassant : le perso sort une de ses 3 armes au hasard et
--                        P, K, S deviennent son moveset unique (Characters/*.lua) au lieu des coups à mains nues
--                        (shared/BareMoves.lua). On la garde jusqu'à sa prochaine éjection (attribut Armed).
--   kind = "throwable" : se lance avec ✋ (flèche ↑ = en cloche vers le haut, ↓ en l'air = vers le bas).
-- weight = chance d'apparaître (plus c'est grand, plus c'est fréquent).
-- build(id) fabrique l'objet en pièces (aucun modèle à importer) : utilisé par le serveur pour l'objet posé
-- et l'objet en main, et par les clients pour l'objet lancé.
local Items = {}

Items.LIST = {
	crate = {
		name = "Caisse Bizarre", kind = "crate", icon = "📦", weight = 8,
		color = Color3.fromRGB(200, 140, 60),
		hint = "Ouvre-la : tu sors TON arme et P, K, S deviennent tes vrais coups (jusqu'à ta prochaine éjection)",
	},
	crousty = {
		name = "Tasty Croustillant", kind = "throwable", icon = "🍗", weight = 3,
		color = Color3.fromRGB(230, 160, 50),
		hint = "Celui qui le prend devient énorme et ne bouge plus pendant 3 s",
	},
	bomb = {
		name = "Bombe", kind = "throwable", icon = "💣", weight = 2,
		color = Color3.fromRGB(30, 30, 35),
		hint = "Touché direct = éjecté ! Elle explose en main au bout de 20 s",
	},
	banana = {
		name = "Peau de banane", kind = "throwable", icon = "🍌", weight = 3,
		color = Color3.fromRGB(250, 220, 60),
		hint = "Reste au sol : celui qui marche dessus glisse",
	},
}

-- Lancer d'un objet tenu : vitesse et angle selon la flèche tenue
Items.THROWS = {
	fwd = { speed = 75, angle = 12 },
	up = { speed = 70, angle = 80 },
	down = { speed = 70, angle = -75 },
	lob = { speed = 55, angle = 40 }, -- la peau de banane part en cloche pour se poser devant
}
Items.GRAVITY = 90

------------------------------------------------------------------------ Fabrication des objets
local function newPart(name, size, color, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = false
	p.Massless = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	return p
end

local function cylinder(name, length, diameter, color, material)
	local p = newPart(name, Vector3.new(length, diameter, diameter), color, material)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function ball(name, diameter, color, material)
	local p = newPart(name, Vector3.new(diameter, diameter, diameter), color, material)
	p.Shape = Enum.PartType.Ball
	return p
end

-- Les objets sont construits autour d'une pièce « Prise » (là où la main tient), objet vers -Y
local ALONG_Y = CFrame.Angles(0, 0, math.rad(90))

local builders = {}

builders.crate = function(add)
	local wood = Color3.fromRGB(190, 130, 60)
	local dark = Color3.fromRGB(120, 75, 35)
	add(newPart("Caisse", Vector3.new(2, 2, 2), wood, Enum.Material.WoodPlanks), CFrame.new(0, -1, 0))
	for i, y in ipairs({ -0.15, -1.85 }) do
		add(newPart("Cercle" .. i, Vector3.new(2.08, 0.22, 2.08), dark, Enum.Material.Wood), CFrame.new(0, y, 0))
	end
	for i, x in ipairs({ -0.95, 0.95 }) do
		add(newPart("Montant" .. i, Vector3.new(0.2, 2.06, 2.06), dark, Enum.Material.Wood), CFrame.new(x, -1, 0))
	end
	local mark = newPart("PointInterrogation", Vector3.new(0.9, 0.9, 0.1), Color3.fromRGB(255, 220, 60), Enum.Material.Neon)
	add(mark, CFrame.new(0, -1, -1.04))
	local back = newPart("PointInterrogation2", Vector3.new(0.9, 0.9, 0.1), Color3.fromRGB(255, 220, 60), Enum.Material.Neon)
	add(back, CFrame.new(0, -1, 1.04))
end

builders.crousty = function(add)
	add(newPart("Seau", Vector3.new(1.3, 1.1, 1.3), Color3.fromRGB(230, 40, 40)), CFrame.new(0, -0.7, 0))
	add(newPart("Bande", Vector3.new(1.32, 0.3, 1.32), Color3.fromRGB(250, 250, 250)), CFrame.new(0, -0.65, 0))
	for i, x in ipairs({ -0.35, 0.05, 0.4 }) do
		add(ball("Pilon" .. i, 0.55, Color3.fromRGB(215, 140, 40)), CFrame.new(x, -0.05, (i - 2) * 0.25))
	end
end

builders.bomb = function(add)
	add(ball("Bombe", 1.5, Color3.fromRGB(30, 30, 35), Enum.Material.SmoothPlastic), CFrame.new(0, -0.9, 0))
	add(cylinder("Col", 0.3, 0.5, Color3.fromRGB(80, 80, 90), Enum.Material.Metal), CFrame.new(0, -0.05, 0) * ALONG_Y)
	add(cylinder("Meche", 0.45, 0.12, Color3.fromRGB(200, 170, 120)), CFrame.new(0, 0.3, 0) * ALONG_Y)
	add(ball("Etincelle", 0.3, Color3.fromRGB(255, 220, 60), Enum.Material.Neon), CFrame.new(0, 0.55, 0))
end

builders.banana = function(add)
	local yellow = Color3.fromRGB(250, 220, 60)
	add(newPart("Centre", Vector3.new(0.5, 0.25, 0.5), yellow), CFrame.new(0, -0.3, 0))
	for i = 0, 2 do
		local a = math.rad(i * 120)
		add(newPart("Pelure" .. i, Vector3.new(0.35, 0.12, 0.9), yellow), CFrame.new(math.sin(a) * 0.45, -0.35, math.cos(a) * 0.45) * CFrame.Angles(0, a, 0))
	end
	add(newPart("Queue", Vector3.new(0.15, 0.35, 0.15), Color3.fromRGB(90, 60, 30)), CFrame.new(0, -0.05, 0))
end

-- Fabrique l'objet : un Model dont la PrimaryPart « Prise » est le point tenu en main
function Items.build(id)
	local model = Instance.new("Model")
	model.Name = id
	local grip = newPart("Prise", Vector3.new(0.2, 0.2, 0.2), Color3.new(), Enum.Material.SmoothPlastic)
	grip.Transparency = 1
	grip.Parent = model
	model.PrimaryPart = grip
	local function add(part, offset)
		part.CFrame = grip.CFrame * offset
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = grip
		weld.Part1 = part
		weld.Parent = part
		part.Parent = model
		return part
	end
	local builder = builders[id]
	if builder then
		builder(add)
	end
	return model
end

-- Tirage au sort d'un objet selon les poids
function Items.random(rng)
	local total = 0
	for _, item in pairs(Items.LIST) do
		total += item.weight
	end
	local roll = (rng and rng:NextNumber() or math.random()) * total
	local ids = {}
	for id in pairs(Items.LIST) do
		table.insert(ids, id)
	end
	table.sort(ids)
	for _, id in ipairs(ids) do
		roll -= Items.LIST[id].weight
		if roll <= 0 then
			return id
		end
	end
	return ids[1]
end

return Items
