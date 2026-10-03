-- Costumes construits par code : couleurs, silhouette et accessoires soudés au personnage.
-- Rien à importer : tout est fait avec des pièces Roblox de base.
local Costumes = {}

local CLOTHING = { "Accessory", "Shirt", "Pants", "ShirtGraphic", "CharacterMesh" }

local function isClothing(instance)
	for _, className in ipairs(CLOTHING) do
		if instance:IsA(className) then
			return true
		end
	end
	return false
end

-- Retire l'avatar Roblox du joueur (accessoires, vêtements) pour garder un look de combattant
local function clearAppearance(model)
	for _, child in ipairs(model:GetChildren()) do
		if isClothing(child) then
			child:Destroy()
		end
	end
	local connection = model.ChildAdded:Connect(function(child)
		if isClothing(child) then
			task.defer(function()
				child:Destroy()
			end)
		end
	end)
	task.delay(5, function()
		connection:Disconnect()
	end)
end

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

local function ellipsoid(name, size, color, material)
	local p = newPart(name, size, color, material)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Parent = p
	return p
end

-- Cylindre dont l'axe suit l'axe Y de la pièce à laquelle on le soude
local function cylinder(name, length, diameter, color, material)
	local p = newPart(name, Vector3.new(length, diameter, diameter), color, material)
	p.Shape = Enum.PartType.Cylinder
	return p
end
local ALONG_Y = CFrame.Angles(0, 0, math.rad(90))
local FACING_FRONT = CFrame.Angles(0, math.rad(90), 0)

local function attach(parent, part, to, offset)
	part.CFrame = to.CFrame * offset
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = to
	weld.Part1 = part
	weld.Parent = part
	part.Parent = parent
	return part
end

-- Objet caché par défaut, que le client fait apparaître pendant un coup
local function hidden(part)
	part:SetAttribute("BaseTransparency", part.Transparency)
	part.Transparency = 1
	return part
end

-- Peint directement chaque partie du corps (sans HumanoidDescription : ApplyDescription peut échouer
-- sans prévenir et change les proportions, alors que l'animation est calculée pour le corps R15 standard).
-- colors = { NomDeLaPartie = couleur }. La tête devient un cube comme dans l'aperçu 3D.
local function paintBody(model, colors, options)
	options = options or {}
	local bodyColors = model:FindFirstChildOfClass("BodyColors")
	if bodyColors then
		bodyColors:Destroy() -- sinon Roblox remet ses couleurs par-dessus les nôtres
	end
	for _, child in ipairs(model:GetChildren()) do
		if child:IsA("BasePart") and colors[child.Name] then
			child.Color = colors[child.Name]
			child.Material = Enum.Material.SmoothPlastic
			child.Transparency = 0
		end
	end
	local head = model:FindFirstChild("Head")
	if head then
		if options.noFace then
			for _, d in ipairs(head:GetChildren()) do
				if d:IsA("Decal") then
					d:Destroy()
				end
			end
		end
		local mesh = head:FindFirstChildOfClass("SpecialMesh")
		if mesh and options.cubeHead then
			mesh.MeshType = Enum.MeshType.Brick
			mesh.Scale = Vector3.new(options.cubeHead / head.Size.X, options.cubeHead / head.Size.Y, options.cubeHead / head.Size.Z)
		end
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
end

local function limbs(skinArms, legs, feet, upper, lower, head)
	local colors = { Head = head, UpperTorso = upper, LowerTorso = lower }
	for _, side in ipairs({ "Left", "Right" }) do
		colors[side .. "UpperArm"] = skinArms
		colors[side .. "LowerArm"] = skinArms
		colors[side .. "Hand"] = skinArms
		colors[side .. "UpperLeg"] = legs
		colors[side .. "LowerLeg"] = legs
		colors[side .. "Foot"] = feet
	end
	return colors
end

local builders = {}

-- Bouteille tenue par le goulot : le corps pend sous le poing, dans le prolongement de l'avant-bras
local function buildBottle(folder, hand, name, mirrorCopy)
	local bottle = Instance.new("Model")
	bottle.Name = name
	bottle.Parent = folder
	local glass = Color3.fromRGB(30, 135, 60)
	local function piece(part, offsetY)
		part.Reflectance = 0.15
		attach(bottle, part, hand, CFrame.new(0, offsetY, -0.05) * ALONG_Y)
		if mirrorCopy then
			hidden(part)
		end
		return part
	end
	local body = piece(cylinder("Corps", 1.7, 0.72, glass, Enum.Material.SmoothPlastic), -1.3)
	piece(cylinder("Epaule", 0.35, 0.55, glass, Enum.Material.SmoothPlastic), -0.35)
	piece(cylinder("Goulot", 0.75, 0.3, glass, Enum.Material.SmoothPlastic), -0.05)
	piece(cylinder("Etiquette", 0.75, 0.75, Color3.fromRGB(250, 150, 30), Enum.Material.SmoothPlastic), -1.3).Reflectance = 0
	piece(cylinder("Bande", 0.18, 0.76, Color3.fromRGB(230, 40, 40), Enum.Material.SmoothPlastic), -1.05).Reflectance = 0
	piece(cylinder("Capsule", 0.14, 0.36, Color3.fromRGB(210, 40, 40), Enum.Material.Metal), 0.38)
	bottle.PrimaryPart = body
	-- Points d'accroche pour la traînée des coups de bouteille et les bulles
	for attachmentName, x in pairs({ TrailA = 0.85, TrailB = -0.85 }) do
		local a = Instance.new("Attachment")
		a.Name = attachmentName
		a.Position = Vector3.new(x, 0, 0)
		a.Parent = body
	end
	if not hand:FindFirstChild("BottleTop") then
		local top = Instance.new("Attachment")
		top.Name = "BottleTop"
		top.Position = Vector3.new(0, 0.45, 0)
		top.Parent = hand
	end
end

local function buildLighter(folder, hand, name)
	attach(folder, hidden(newPart(name, Vector3.new(0.25, 0.45, 0.14), Color3.fromRGB(220, 40, 40))), hand, CFrame.new(0, -0.3, -0.1))
end

local function buildMic(folder, hand, name)
	local mic = Instance.new("Model")
	mic.Name = name
	mic.Parent = folder
	attach(mic, hidden(cylinder("Manche", 0.9, 0.22, Color3.fromRGB(30, 30, 30))), hand, CFrame.new(0, -0.35, 0) * ALONG_Y)
	attach(mic, hidden(ellipsoid("Grille", Vector3.new(0.45, 0.45, 0.45), Color3.fromRGB(180, 180, 190), Enum.Material.DiamondPlate)), hand, CFrame.new(0, -0.9, 0))
end

-- Gégé : bonnet de travers, nez rouge qui clignote, marcel taché, bedaine, jean, godillots, bouteille.
-- Cotes reprises de l'aperçu 3D (outils/apercu-animations) : tête cube de 1,25, bedaine, yeux, sourcils.
builders.Gege = function(model, folder)
	local skin = Color3.fromRGB(232, 182, 140)
	local tankTop = Color3.fromRGB(245, 245, 235)
	local jeans = Color3.fromRGB(55, 75, 125)
	local shoe = Color3.fromRGB(58, 42, 34)
	local dark = Color3.fromRGB(60, 45, 40)
	paintBody(model, limbs(skin, jeans, shoe, tankTop, jeans, skin), { noFace = true, cubeHead = 1.25 })

	local head = model:WaitForChild("Head", 5)
	local upper = model:WaitForChild("UpperTorso", 5)
	local hand = model:WaitForChild("RightHand", 5)
	local leftHand = model:WaitForChild("LeftHand", 5)
	local front = -0.63 -- face avant de la tête (cube de 1,25)

	-- Bonnet de travers avec pompon
	attach(folder, ellipsoid("Bonnet", Vector3.new(1.38, 0.8, 1.38), Color3.fromRGB(160, 30, 45), Enum.Material.Fabric), head, CFrame.new(0, 0.43, 0.02) * CFrame.Angles(0, 0, math.rad(12)))
	attach(folder, ellipsoid("Pompon", Vector3.new(0.5, 0.5, 0.5), Color3.fromRGB(240, 220, 220), Enum.Material.Fabric), head, CFrame.new(-0.2, 0.83, 0))

	-- Nez rouge lumineux
	local nose = attach(folder, ellipsoid("NezRouge", Vector3.new(0.42, 0.38, 0.42), Color3.fromRGB(235, 40, 40), Enum.Material.Neon), head, CFrame.new(0, -0.05, front - 0.03))
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 60, 60)
	light.Range = 4
	light.Brightness = 1
	light.Parent = nose

	-- Yeux et sourcils broussailleux
	attach(folder, newPart("OeilDroit", Vector3.new(0.18, 0.18, 0.05), dark), head, CFrame.new(0.26, 0.1, front))
	attach(folder, newPart("OeilGauche", Vector3.new(0.18, 0.18, 0.05), dark), head, CFrame.new(-0.26, 0.1, front))
	attach(folder, newPart("SourcilDroit", Vector3.new(0.38, 0.1, 0.1), dark), head, CFrame.new(0.24, 0.24, front) * CFrame.Angles(0, 0, math.rad(-10)))
	attach(folder, newPart("SourcilGauche", Vector3.new(0.38, 0.1, 0.1), dark), head, CFrame.new(-0.24, 0.24, front) * CFrame.Angles(0, 0, math.rad(10)))

	-- Bedaine sous le marcel, avec une tache
	attach(folder, ellipsoid("Bedaine", Vector3.new(1.75, 1.05, 1.0), tankTop), upper, CFrame.new(0, -0.3, -0.33))
	attach(folder, cylinder("Tache", 0.04, 0.55, Color3.fromRGB(190, 150, 60)), upper, CFrame.new(0.28, -0.25, -0.83) * FACING_FRONT)

	-- Godillots qui dépassent devant
	for _, side in ipairs({ "Left", "Right" }) do
		local foot = model:FindFirstChild(side .. "Foot")
		if foot then
			attach(folder, newPart("Godillot" .. side, Vector3.new(0.95, 0.25, 1.25), shoe), foot, CFrame.new(0, -0.03, -0.15))
		end
	end

	-- Bouteille de soda douteux tenue par le goulot, briquet (Haleine-briquet) et micro (Karaoké).
	-- Chaque objet existe en deux exemplaires, un par main : quand Gégé regarde à gauche, l'animation
	-- passe en miroir et c'est l'exemplaire « _M » de l'autre main qui s'affiche, pour que la bouteille
	-- reste toujours du côté de la caméra.
	buildBottle(folder, hand, "PropBottle", false)
	buildBottle(folder, leftHand, "PropBottle_M", true)
	buildLighter(folder, leftHand, "PropLighter")
	buildLighter(folder, hand, "PropLighter_M")
	buildMic(folder, leftHand, "PropMic")
	buildMic(folder, hand, "PropMic_M")
end

-- Mannequin d'entraînement en bois avec une cible sur le torse
builders.Dummy = function(model, folder)
	local wood = Color3.fromRGB(205, 165, 115)
	local darkWood = Color3.fromRGB(170, 130, 90)
	paintBody(model, limbs(wood, darkWood, darkWood, wood, darkWood, wood), { noFace = true })
	local upper = model:WaitForChild("UpperTorso", 5)
	local u = upper.Size
	local rings = { { 1.5, Color3.fromRGB(220, 40, 40) }, { 1.05, Color3.new(1, 1, 1) }, { 0.6, Color3.fromRGB(220, 40, 40) } }
	for i, ring in ipairs(rings) do
		attach(folder, cylinder("Cible" .. i, 0.05 + i * 0.02, ring[1], ring[2]), upper, CFrame.new(0, 0.1, -u.Z * 0.5 - 0.03 * i) * FACING_FRONT)
	end
end

------------------------------------------------------------------------ Costumes décrits en données
-- Les persos autres que Gégé décrivent leur costume dans leur fiche (data.look, voir Characters/*.lua) :
--   look.body     = { head, upper, lower, arms, hands, legs, feet } (couleurs) ; look.cubeHead = taille de la tête cube
--   look.parts    = { { nom, partie du corps, forme, taille, position, rotation, couleur, matière, options }, ... }
--   look.props    = { { nom = "PropCanne", main = "Right", visible = true/false, pieces = { ... } }, ... }
-- Formes : "ball" (ellipsoïde), "block", "cyl" (cylindre, axe = options.axis "x" / "y" / "z", "y" par défaut),
-- "wedge". Position et rotation (degrés) sont relatives à la partie du corps. options : neon, transparency,
-- light = { couleur, portée }, reflect.
-- Un objet visible (visible = true, comme la bouteille de Gégé) existe en deux exemplaires : quand le perso
-- regarde à gauche, c'est l'exemplaire « _M » de l'autre main qui s'affiche (voir client/Fx.lua onMirror).
-- Un objet caché (visible = false) n'apparaît que pendant les coups qui le citent (champ prop du coup).
local AXIS = { x = CFrame.new(), y = ALONG_Y, z = FACING_FRONT }

local function buildPiece(spec)
	local name, shape, size, color, material, options = spec[1], spec[3], spec[4], spec[7], spec[8], spec[9] or {}
	local mat = material and Enum.Material[material] or Enum.Material.SmoothPlastic
	if options.neon then
		mat = Enum.Material.Neon
	end
	local part
	if shape == "ball" then
		part = ellipsoid(name, size, color, mat)
	elseif shape == "cyl" then
		part = newPart(name, size, color, mat)
		part.Shape = Enum.PartType.Cylinder
	elseif shape == "wedge" then
		part = Instance.new("WedgePart")
		part.Name = name
		part.Size = size
		part.Color = color
		part.Material = mat
		part.Anchored, part.Massless, part.CanCollide, part.CanQuery, part.CanTouch, part.CastShadow = false, true, false, false, false, false
	else
		part = newPart(name, size, color, mat)
	end
	part.Transparency = options.transparency or 0
	part.Reflectance = options.reflect or 0
	if options.light then
		local light = Instance.new("PointLight")
		light.Color = options.light[1]
		light.Range = options.light[2] or 6
		light.Brightness = options.light[3] or 1
		light.Parent = part
	end
	local position, rotation = spec[5] or Vector3.zero, spec[6] or Vector3.zero
	local orient = shape == "cyl" and (AXIS[options.axis or "y"] or ALONG_Y) or CFrame.new()
	local offset = CFrame.new(position) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z)) * orient
	return part, offset
end

local function buildProp(folder, hand, prop, name, mirrorCopy)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = folder
	for _, spec in ipairs(prop.pieces) do
		local part, offset = buildPiece(spec)
		attach(model, part, hand, offset)
		part:SetAttribute("BaseTransparency", part.Transparency)
		if mirrorCopy or not prop.visible then
			hidden(part)
		end
	end
	if prop.visible then
		model:SetAttribute("AlwaysShown", true)
	end
	-- points d'accroche des traînées (la pièce la plus longue)
	local longest
	for _, d in ipairs(model:GetChildren()) do
		if d:IsA("BasePart") and (not longest or d.Size.Magnitude > longest.Size.Magnitude) then
			longest = d
		end
	end
	if longest then
		model.PrimaryPart = longest
		for attachmentName, x in pairs({ TrailA = 0.5, TrailB = -0.5 }) do
			local a = Instance.new("Attachment")
			a.Name = attachmentName
			local axisLength = math.max(longest.Size.X, longest.Size.Y, longest.Size.Z)
			a.Position = longest.Size.X >= axisLength and Vector3.new(x * axisLength, 0, 0) or Vector3.new(0, x * axisLength, 0)
			a.Parent = longest
		end
	end
end

local function buildFromLook(model, folder, look)
	local b = look.body
	local colors = limbs(b.arms, b.legs, b.feet, b.upper, b.lower, b.head)
	for _, side in ipairs({ "Left", "Right" }) do
		if b.hands then
			colors[side .. "Hand"] = b.hands
		end
		if b.forearms then
			colors[side .. "LowerArm"] = b.forearms
		end
		if b.shins then
			colors[side .. "LowerLeg"] = b.shins
		end
	end
	paintBody(model, colors, { noFace = true, cubeHead = look.cubeHead or 1.25 })
	if look.transparency then
		for _, child in ipairs(model:GetChildren()) do
			if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
				child.Transparency = look.transparency
			end
		end
	end
	if look.material then
		for _, child in ipairs(model:GetChildren()) do
			if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
				child.Material = Enum.Material[look.material]
			end
		end
	end
	for _, spec in ipairs(look.parts or {}) do
		local target = model:WaitForChild(spec[2], 5)
		if target then
			local part, offset = buildPiece(spec)
			attach(folder, part, target, offset)
		end
	end
	for _, prop in ipairs(look.props or {}) do
		local side = prop.hand or "Right"
		local other = side == "Right" and "Left" or "Right"
		local hand = model:WaitForChild(side .. "Hand", 5)
		local otherHand = model:WaitForChild(other .. "Hand", 5)
		if hand and otherHand then
			buildProp(folder, hand, prop, prop.name, false)
			buildProp(folder, otherHand, prop, prop.name .. "_M", true)
		end
	end
end

function Costumes.apply(model, costumeId)
	-- on attend que le perso soit dans le monde (ses parties sont alors toutes créées)
	while not model:IsDescendantOf(workspace) and model.Parent ~= nil do
		model.AncestryChanged:Wait()
	end
	clearAppearance(model)
	local old = model:FindFirstChild("Costume")
	if old then
		old:Destroy()
	end
	local builder = builders[costumeId]
	if not builder then
		-- costume décrit dans la fiche du perso
		local CharacterList = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("CharacterList"))
		local data = CharacterList[costumeId]
		if not data or not data.look then
			return
		end
		builder = function(m, f)
			buildFromLook(m, f, data.look)
		end
	end
	local folder = Instance.new("Folder")
	folder.Name = "Costume"
	folder.Parent = model
	-- un corps inattendu (pas R15) ne doit jamais bloquer l'arrivée du joueur dans le match
	local ok, err = pcall(builder, model, folder)
	if not ok then
		warn("Costume « " .. tostring(costumeId) .. " » incomplet :", err)
	end
	-- un corps d'avatar Roblox (pièces en mesh) n'aurait pas la silhouette prévue : on le signale
	local head = model:FindFirstChild("Head")
	if head and head:IsA("MeshPart") then
		warn("Costume : " .. model.Name .. " a un corps d'avatar Roblox, pas le corps standard du jeu")
	end
end

return Costumes
