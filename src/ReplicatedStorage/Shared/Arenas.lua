-- Les 20 arènes (voir docs/maps-20-arenes.md) : une par perso, son « chez-lui ».
-- La disposition de combat est la même partout (server/Arena.lua : sol principal suspendu, 2 rebords bas,
-- 5 plateformes fines et un plateau qui va et vient) : seuls le décor, la lumière, le public et le piège changent.
--
-- Champs :
--   floor / ledge / soft = { couleur, matière } du sol principal, des rebords et des plateformes fines
--   edge  = couleur du liseré lumineux des plateformes fines
--   wall  = { couleur, matière } du grand mur de fond
--   sky   = { heure, ambiance, ambiance extérieure } (éclairage)
--   signs = { { texte, position, taille, couleur }, ... } enseignes du fond
--   decor = { { nom, forme, taille, position, couleur, matière, options }, ... } décor de fond (jamais touché) ;
--           taille = encombrement (largeur, hauteur, profondeur) ; un cylindre suit options.axis ("y" par défaut)
--   crowd = { couleurs = { ... }, places = { Vector3, ... } } le public (figurants qui bougent en rythme)
--   trap  = { kind, icon, text, ... } le piège, annoncé 2 s avant (server/Hazards.lua), coupé par Pièges OFF
local Arenas = {}

local C = Color3.fromRGB
local V = Vector3.new

-- Public par défaut : deux gradins de figurants au fond, de part et d'autre
local function stands(y, z)
	local list = {}
	for i = 0, 7 do
		table.insert(list, V(-92 + i * 7, y, z))
		table.insert(list, V(43 + i * 7, y, z))
	end
	return list
end

Arenas.LIST = {
	{
		id = "bar", owner = "Gege", name = "Le Bar-Tabac « Chez Gégé »",
		floor = { C(120, 80, 50), "WoodPlanks" }, ledge = { C(85, 55, 35), "WoodPlanks" }, soft = { C(170, 175, 180), "Metal" },
		edge = C(255, 120, 200), wall = { C(150, 60, 50), "Brick" }, sky = { 20, C(120, 90, 110), C(140, 110, 130) },
		signs = { { "CHEZ GÉGÉ", V(0, 66, -28.5), V(50, 10, 1), C(255, 120, 200) }, { "HAPPY HOUR", V(-62, 44, -28.5), V(28, 6, 1), C(170, 220, 60) } },
		decor = {
			{ "Comptoir", "block", V(50, 8, 6), V(-10, -6, -22), C(170, 175, 180), "DiamondPlate" },
			{ "JukeBox", "block", V(8, 14, 4), V(30, -3, -24), C(255, 120, 200), "Neon" },
			{ "DistributeurDeSoda", "block", V(7, 16, 4), V(-40, -2, -24), C(170, 220, 60), "SmoothPlastic" },
			{ "Flipper", "wedge", V(6, 6, 10), V(48, -7, -24), C(60, 120, 230), "SmoothPlastic" },
		},
		crowd = { colors = { C(240, 240, 230), C(60, 80, 130), C(150, 60, 50) }, places = stands(-6, -20) },
		trap = { kind = "puddle", icon = "🫧", text = "LE DISTRIBUTEUR S'EMBALLE !", color = C(170, 220, 60) },
	},
	{
		id = "salon", owner = "Mamie", name = "Le Salon de Mamie",
		floor = { C(150, 90, 70), "Fabric" }, ledge = { C(120, 70, 55), "Wood" }, soft = { C(235, 225, 210), "Fabric" },
		edge = C(255, 170, 200), wall = { C(240, 200, 210), "Fabric" }, sky = { 15, C(170, 140, 140), C(200, 170, 170) },
		signs = { { "QUESTIONS POUR UN MAMIE", V(40, 50, -28.5), V(36, 6, 1), C(255, 230, 120) } },
		decor = {
			{ "Horloge", "block", V(6, 18, 3), V(-50, 20, -27), C(110, 70, 40), "Wood" },
			{ "Cadran", "cyl", V(4.5, 4.5, 0.4), V(-50, 26, -25.4), C(250, 245, 230), "SmoothPlastic", { axis = "z" } },
			{ "Television", "block", V(16, 11, 6), V(40, 34, -26), C(40, 40, 45), "SmoothPlastic" },
			{ "Canape", "block", V(36, 7, 8), V(0, -6, -24), C(200, 120, 140), "Fabric" },
			{ "Napperon", "cyl", V(6, 6, 0.2), V(-20, 4, -26), C(255, 255, 255), "Fabric", { axis = "z" } },
		},
		crowd = { colors = { C(200, 200, 210), C(220, 160, 180), C(170, 150, 210) }, places = stands(-4, -20) },
		trap = { kind = "dive", icon = "🐦", text = "COUCOU !", color = C(240, 220, 120) },
	},
	{
		id = "parking", owner = "Dylan", name = "Le Parking du Fast-Food",
		floor = { C(70, 70, 75), "Asphalt" }, ledge = { C(90, 90, 95), "Concrete" }, soft = { C(230, 60, 50), "Metal" },
		edge = C(255, 220, 60), wall = { C(30, 30, 45), "Concrete" }, sky = { 22, C(80, 80, 120), C(90, 90, 140) },
		signs = { { "MÉGA BURGER", V(0, 66, -28.5), V(46, 12, 1), C(255, 220, 60) }, { "DRIVE ➜", V(60, 40, -28.5), V(20, 6, 1), C(255, 255, 255) } },
		decor = {
			{ "BorneDrive", "block", V(5, 12, 4), V(-45, -4, -24), C(230, 60, 50), "SmoothPlastic" },
			{ "Scooter1", "block", V(8, 4, 3), V(20, -8, -22), C(40, 160, 220), "SmoothPlastic" },
			{ "Scooter2", "block", V(8, 4, 3), V(32, -8, -22), C(250, 160, 30), "SmoothPlastic" },
			{ "Lampadaire", "block", V(1.2, 40, 1.2), V(-70, 10, -24), C(60, 60, 70), "Metal" },
		},
		crowd = { colors = { C(40, 160, 220), C(250, 160, 30), C(70, 200, 110) }, places = stands(-8, -20) },
		trap = { kind = "shockwave", icon = "🚗", text = "TÛÛÛT ! UNE VOITURE AU DRIVE", color = C(255, 220, 60) },
	},
	{
		id = "dojo", owner = "Sumo", name = "Le Dôjô Dessert",
		floor = { C(230, 180, 110), "SmoothPlastic" }, ledge = { C(210, 150, 90), "SmoothPlastic" }, soft = { C(255, 150, 190), "SmoothPlastic" },
		edge = C(255, 240, 120), wall = { C(250, 230, 200), "Wood" }, sky = { 14, C(190, 160, 150), C(220, 190, 180) },
		signs = { { "相撲 DESSERT", V(0, 64, -28.5), V(40, 10, 1), C(220, 60, 80) } },
		decor = {
			{ "PilierSucreOrge1", "cyl", V(4, 70, 4), V(-40, 20, -26), C(255, 120, 120), "SmoothPlastic" },
			{ "PilierSucreOrge2", "cyl", V(4, 70, 4), V(40, 20, -26), C(255, 120, 120), "SmoothPlastic" },
			{ "Lanterne1", "ball", V(5, 6, 5), V(-20, 46, -25), C(120, 255, 160), "Neon" },
			{ "Lanterne2", "ball", V(5, 6, 5), V(20, 46, -25), C(255, 200, 80), "Neon" },
		},
		crowd = { colors = { C(255, 240, 245), C(255, 210, 230), C(240, 250, 255) }, places = stands(-6, -20) },
		trap = { kind = "bounce", icon = "🍮", text = "LE SOL TREMBLOTE !", color = C(255, 150, 190) },
	},
	{
		id = "theatre", owner = "Marcel", name = "Le Théâtre Muet",
		floor = { C(60, 60, 60), "Wood" }, ledge = { C(40, 40, 40), "Wood" }, soft = { C(200, 200, 200), "Wood" },
		edge = C(255, 255, 255), wall = { C(25, 25, 25), "Fabric" }, sky = { 0, C(90, 90, 90), C(100, 100, 100) },
		signs = { { "CE SOIR : SILENCE", V(0, 66, -28.5), V(40, 8, 1), C(240, 240, 240) } },
		decor = {
			{ "RideauGauche", "block", V(30, 90, 2), V(-85, 20, -26), C(180, 20, 30), "Fabric" },
			{ "RideauDroit", "block", V(30, 90, 2), V(85, 20, -26), C(180, 20, 30), "Fabric" },
			{ "Piano", "block", V(14, 8, 6), V(-30, -6, -22), C(15, 15, 15), "SmoothPlastic" },
			{ "Projecteur", "cyl", V(3, 6, 3), V(60, 60, -20), C(200, 200, 200), "Metal" },
		},
		crowd = { colors = { C(80, 80, 80), C(150, 150, 150), C(210, 210, 210) }, places = stands(-6, -20) },
		trap = { kind = "spotlight", icon = "🔦", text = "LE PROJECTEUR !", color = C(255, 255, 220) },
	},
	{
		id = "place", owner = "Pigeon", name = "La Place aux Pigeons",
		floor = { C(160, 155, 150), "Cobblestone" }, ledge = { C(130, 125, 120), "Cobblestone" }, soft = { C(90, 120, 90), "Wood" },
		edge = C(255, 230, 150), wall = { C(150, 190, 230), "SmoothPlastic" }, sky = { 13, C(170, 170, 170), C(200, 200, 200) },
		signs = { { "PLACE DU ROI", V(0, 64, -28.5), V(36, 8, 1), C(255, 230, 150) } },
		decor = {
			{ "Fontaine", "cyl", V(20, 4, 20), V(0, -8, -24), C(180, 180, 190), "Marble", { axis = "y" } },
			{ "Statue", "block", V(6, 18, 6), V(0, 2, -24), C(120, 140, 120), "Slate" },
			{ "Kiosque", "wedge", V(18, 10, 10), V(-55, 30, -26), C(90, 120, 90), "Wood" },
			{ "Banc", "block", V(12, 2, 3), V(45, -8, -22), C(110, 80, 50), "Wood" },
		},
		crowd = { colors = { C(230, 200, 150), C(120, 160, 220), C(200, 120, 120) }, places = stands(-6, -20) },
		trap = { kind = "flock", icon = "🐦", text = "LA NUÉE SAUVAGE !", color = C(150, 150, 160) },
	},
	{
		id = "mairie", owner = "Bernard", name = "Le Guichet de la Mairie",
		floor = { C(150, 150, 150), "Slate" }, ledge = { C(120, 120, 120), "Slate" }, soft = { C(200, 200, 190), "SmoothPlastic" },
		edge = C(220, 240, 255), wall = { C(170, 170, 165), "SmoothPlastic" }, sky = { 12, C(150, 150, 150), C(170, 170, 170) },
		signs = { { "NUMÉRO 0047", V(0, 64, -28.5), V(34, 8, 1), C(255, 60, 60) }, { "PATIENTEZ", V(-55, 44, -28.5), V(24, 6, 1), C(220, 240, 255) } },
		decor = {
			{ "Guichet", "block", V(40, 10, 6), V(0, -5, -22), C(200, 200, 190), "SmoothPlastic" },
			{ "PlanteEnPlastique", "ball", V(5, 7, 5), V(-45, -3, -22), C(60, 150, 70), "SmoothPlastic" },
			{ "DistributeurTickets", "block", V(3, 8, 3), V(45, -5, -22), C(230, 60, 60), "Metal" },
		},
		crowd = { colors = { C(120, 120, 130), C(150, 140, 120), C(100, 110, 130) }, places = stands(-6, -20) },
		trap = { kind = "ticket", icon = "🎫", text = "NUMÉRO 0047 ?", color = C(255, 60, 60) },
	},
	{
		id = "cuisine", owner = "Chef", name = "Les Cuisines du Palace",
		floor = { C(230, 230, 230), "Marble" }, ledge = { C(190, 190, 195), "DiamondPlate" }, soft = { C(180, 185, 190), "Metal" },
		edge = C(255, 140, 40), wall = { C(240, 235, 225), "SmoothPlastic" }, sky = { 18, C(170, 150, 130), C(200, 180, 160) },
		signs = { { "COUP DE FEU !", V(0, 64, -28.5), V(36, 8, 1), C(255, 120, 40) } },
		decor = {
			{ "Fourneau", "block", V(40, 10, 6), V(0, -5, -22), C(60, 60, 65), "Metal" },
			{ "Casserole1", "cyl", V(6, 4, 6), V(-12, 2, -22), C(190, 190, 195), "Metal" },
			{ "Casserole2", "cyl", V(5, 5, 5), V(12, 2, -22), C(200, 120, 60), "Metal" },
			{ "Hotte", "wedge", V(50, 10, 10), V(0, 55, -26), C(170, 175, 180), "Metal" },
		},
		crowd = { colors = { C(250, 250, 250), C(30, 30, 30), C(220, 60, 60) }, places = stands(-6, -20) },
		trap = { kind = "pillar", icon = "🔥", text = "LA POÊLE FLAMBE !", color = C(255, 120, 40) },
	},
	{
		id = "creche", owner = "Bebe", name = "La Crèche Géante",
		floor = { C(120, 200, 255), "SmoothPlastic" }, ledge = { C(255, 200, 80), "SmoothPlastic" }, soft = { C(255, 120, 120), "SmoothPlastic" },
		edge = C(255, 255, 255), wall = { C(255, 240, 200), "SmoothPlastic" }, sky = { 13, C(200, 200, 190), C(230, 230, 220) },
		signs = { { "DODO !", V(0, 64, -28.5), V(24, 8, 1), C(120, 160, 255) } },
		decor = {
			{ "CubeA", "block", V(10, 10, 10), V(-50, -4, -24), C(255, 90, 90), "SmoothPlastic" },
			{ "CubeB", "block", V(10, 10, 10), V(-40, 6, -26), C(90, 200, 120), "SmoothPlastic" },
			{ "Berceau", "block", V(26, 12, 10), V(40, -2, -25), C(250, 250, 250), "Wood" },
			{ "Nounours", "ball", V(10, 12, 8), V(70, 0, -22), C(190, 130, 80), "Fabric" },
		},
		crowd = { colors = { C(190, 130, 80), C(255, 200, 220), C(180, 220, 255) }, places = stands(-6, -20) },
		trap = { kind = "sweeper", icon = "🚙", text = "VOITURE TÉLÉCOMMANDÉE !", color = C(255, 90, 90) },
	},
	{
		id = "fitness", owner = "Gloria", name = "La Salle de Fitness Fluo",
		floor = { C(60, 50, 80), "Rubber" }, ledge = { C(80, 60, 110), "Rubber" }, soft = { C(255, 100, 200), "Neon" },
		edge = C(100, 255, 230), wall = { C(40, 30, 60), "SmoothPlastic" }, sky = { 21, C(140, 90, 160), C(160, 110, 180) },
		signs = { { "ALLEZ, ON BOUGE !", V(0, 64, -28.5), V(40, 8, 1), C(255, 100, 200) } },
		decor = {
			{ "Miroir", "block", V(80, 30, 1), V(0, 20, -28), C(200, 220, 240), "Glass", { reflect = 0.4 } },
			{ "Enceinte1", "block", V(10, 18, 8), V(-60, 0, -24), C(20, 20, 25), "SmoothPlastic" },
			{ "Enceinte2", "block", V(10, 18, 8), V(60, 0, -24), C(20, 20, 25), "SmoothPlastic" },
		},
		crowd = { colors = { C(255, 100, 200), C(100, 255, 230), C(255, 240, 100) }, places = stands(-6, -20) },
		trap = { kind = "conveyor", icon = "🏃", text = "LE TAPIS DE COURSE S'ALLUME !", color = C(100, 255, 230) },
	},
	{
		id = "studio", owner = "Lola", name = "Le Studio de Lola",
		floor = { C(255, 200, 220), "SmoothPlastic" }, ledge = { C(240, 170, 200), "SmoothPlastic" }, soft = { C(255, 255, 255), "SmoothPlastic" },
		edge = C(255, 100, 180), wall = { C(255, 180, 210), "SmoothPlastic" }, sky = { 16, C(200, 170, 190), C(230, 200, 220) },
		signs = { { "❤️ 999 998 ABONNÉS", V(0, 64, -28.5), V(46, 8, 1), C(255, 60, 140) } },
		decor = {
			{ "RingLight1", "cyl", V(12, 12, 1), V(-45, 30, -24), C(255, 255, 255), "Neon", { axis = "z" } },
			{ "RingLight2", "cyl", V(12, 12, 1), V(45, 30, -24), C(255, 255, 255), "Neon", { axis = "z" } },
			{ "Lit", "block", V(30, 6, 12), V(0, -7, -24), C(255, 150, 190), "Fabric" },
		},
		crowd = { colors = { C(255, 150, 190), C(200, 160, 255), C(160, 220, 255) }, places = stands(-6, -20) },
		trap = { kind = "notifications", icon = "🔔", text = "LE COMPTEUR BUGUE !", color = C(255, 60, 140) },
	},
	{
		id = "chambre", owner = "Jordan", name = "La Chambre du Gamer",
		floor = { C(40, 40, 50), "Fabric" }, ledge = { C(30, 30, 40), "SmoothPlastic" }, soft = { C(60, 60, 75), "SmoothPlastic" },
		edge = C(80, 255, 120), wall = { C(25, 25, 35), "SmoothPlastic" }, sky = { 23, C(60, 60, 110), C(70, 70, 120) },
		signs = { { "GG EZ", V(0, 64, -28.5), V(24, 8, 1), C(80, 255, 120) } },
		decor = {
			{ "Ecran1", "block", V(20, 12, 1), V(-24, 36, -27), C(60, 120, 255), "Neon" },
			{ "Ecran2", "block", V(20, 12, 1), V(0, 38, -27), C(255, 60, 200), "Neon" },
			{ "Ecran3", "block", V(20, 12, 1), V(24, 36, -27), C(60, 255, 160), "Neon" },
			{ "ChaiseGaming", "block", V(10, 18, 8), V(55, 0, -24), C(220, 30, 40), "SmoothPlastic" },
		},
		crowd = { colors = { C(80, 255, 120), C(255, 60, 200), C(60, 120, 255) }, places = stands(-6, -20) },
		trap = { kind = "blackout", icon = "🔌", text = "COUPURE DE COURANT !", color = C(30, 30, 30) },
	},
	{
		id = "cabinet", owner = "Fraise", name = "Le Cabinet Dentaire",
		floor = { C(245, 250, 255), "Marble" }, ledge = { C(220, 230, 240), "Marble" }, soft = { C(150, 220, 230), "SmoothPlastic" },
		edge = C(120, 230, 255), wall = { C(240, 248, 255), "SmoothPlastic" }, sky = { 12, C(200, 210, 220), C(230, 240, 250) },
		signs = { { "SOURIEZ !", V(0, 64, -28.5), V(28, 8, 1), C(255, 100, 140) } },
		decor = {
			{ "Fauteuil", "wedge", V(12, 8, 8), V(-40, -4, -22), C(120, 210, 230), "SmoothPlastic" },
			{ "Aquarium", "block", V(18, 10, 6), V(40, -3, -24), C(120, 200, 255), "Glass", { transparency = 0.4 } },
			{ "DentGeante", "ball", V(8, 10, 6), V(0, 40, -26), C(255, 255, 255), "SmoothPlastic" },
		},
		crowd = { colors = { C(255, 220, 200), C(200, 230, 255), C(255, 255, 255) }, places = stands(-6, -20) },
		trap = { kind = "launcher", icon = "🦷", text = "FAUTEUIL ÉJECTABLE !", color = C(120, 210, 230) },
	},
	{
		id = "piscine", owner = "Canard", name = "La Piscine Municipale",
		floor = { C(230, 240, 250), "Marble" }, ledge = { C(200, 230, 245), "Marble" }, soft = { C(90, 180, 255), "SmoothPlastic" },
		edge = C(255, 240, 80), wall = { C(140, 210, 245), "Marble" }, sky = { 14, C(180, 200, 220), C(210, 230, 250) },
		signs = { { "ON NE COURT PAS !", V(0, 64, -28.5), V(40, 8, 1), C(255, 60, 60) } },
		decor = {
			{ "Bassin", "block", V(120, 2, 16), V(0, -12, -24), C(60, 160, 255), "Glass", { transparency = 0.3 } },
			{ "Plongeoir", "block", V(14, 1.5, 3), V(-55, 30, -22), C(255, 255, 255), "SmoothPlastic" },
			{ "Toboggan", "wedge", V(10, 30, 10), V(60, 5, -26), C(255, 200, 40), "SmoothPlastic" },
		},
		crowd = { colors = { C(255, 200, 40), C(255, 100, 100), C(100, 200, 255) }, places = stands(-6, -20) },
		trap = { kind = "whistle", icon = "📣", text = "PRRRRT ! ON NE COURT PAS !", color = C(255, 60, 60) },
	},
	{
		id = "tombeau", owner = "Ramses", name = "Le Tombeau en Travaux",
		floor = { C(220, 190, 130), "Sandstone" }, ledge = { C(200, 170, 110), "Sandstone" }, soft = { C(150, 110, 70), "Wood" },
		edge = C(255, 210, 90), wall = { C(200, 165, 110), "Sandstone" }, sky = { 17, C(190, 150, 100), C(220, 180, 130) },
		signs = { { "PHARMACIE ➕", V(0, 64, -28.5), V(32, 8, 1), C(60, 220, 100) } },
		decor = {
			{ "Sarcophage1", "block", V(6, 16, 4), V(-45, 0, -24), C(230, 190, 60), "SmoothPlastic" },
			{ "Sarcophage2", "block", V(6, 16, 4), V(45, 0, -24), C(230, 190, 60), "SmoothPlastic" },
			{ "Echafaudage", "block", V(30, 50, 2), V(-70, 20, -27), C(120, 120, 120), "Metal", { transparency = 0.3 } },
		},
		crowd = { colors = { C(240, 235, 220), C(230, 220, 200), C(220, 210, 190) }, places = stands(-6, -20) },
		trap = { kind = "sand", icon = "⏳", text = "TRAPPE À SABLE !", color = C(220, 190, 130) },
	},
	{
		id = "cabaret", owner = "Gaston", name = "Le Cabaret Magique",
		floor = { C(110, 20, 30), "Wood" }, ledge = { C(80, 15, 25), "Wood" }, soft = { C(220, 180, 60), "Metal" },
		edge = C(255, 220, 100), wall = { C(70, 10, 20), "Fabric" }, sky = { 21, C(150, 80, 80), C(170, 100, 100) },
		signs = { { "LE MAGNIFIQUE", V(0, 64, -28.5), V(36, 8, 1), C(255, 220, 100) } },
		decor = {
			{ "Malle", "block", V(10, 7, 6), V(-40, -5, -22), C(90, 50, 30), "Wood" },
			{ "Cage", "block", V(8, 10, 8), V(40, -3, -22), C(220, 180, 60), "Metal", { transparency = 0.5 } },
			{ "ChapeauGeant", "cyl", V(10, 12, 10), V(0, 44, -26), C(20, 20, 20), "SmoothPlastic" },
		},
		crowd = { colors = { C(20, 20, 20), C(250, 250, 250), C(150, 20, 30) }, places = stands(-6, -20) },
		trap = { kind = "swap", icon = "🎩", text = "LA MALLE MAGIQUE !", color = C(255, 220, 100) },
	},
	{
		id = "plage", owner = "Bob", name = "La Plage du Yéti",
		floor = { C(240, 220, 160), "Sand" }, ledge = { C(220, 200, 140), "Sand" }, soft = { C(230, 245, 255), "Ice" },
		edge = C(150, 230, 255), wall = { C(120, 200, 255), "SmoothPlastic" }, sky = { 14, C(190, 210, 230), C(220, 235, 250) },
		signs = { { "BUVETTE IGLOO", V(40, 50, -28.5), V(30, 6, 1), C(255, 150, 60) } },
		decor = {
			{ "Palmier1", "cyl", V(2, 40, 2), V(-60, 10, -24), C(130, 90, 50), "Wood" },
			{ "Palmes1", "ball", V(16, 4, 10), V(-60, 31, -24), C(240, 250, 255), "Ice" },
			{ "Igloo", "ball", V(24, 16, 14), V(45, -2, -26), C(240, 250, 255), "Ice" },
			{ "Transat", "wedge", V(8, 4, 4), V(-20, -8, -22), C(255, 120, 60), "Fabric" },
		},
		crowd = { colors = { C(30, 30, 40), C(250, 250, 250), C(255, 160, 40) }, places = stands(-6, -20) },
		trap = { kind = "sunbeam", icon = "☀️", text = "COUP DE SOLEIL GÉANT !", color = C(255, 220, 80) },
	},
	{
		id = "appartement", owner = "Robo", name = "L'Appartement Connecté",
		floor = { C(220, 220, 225), "SmoothPlastic" }, ledge = { C(190, 190, 200), "SmoothPlastic" }, soft = { C(80, 90, 110), "Metal" },
		edge = C(80, 200, 255), wall = { C(235, 235, 240), "SmoothPlastic" }, sky = { 19, C(160, 170, 190), C(190, 200, 220) },
		signs = { { "« JE N'AI PAS COMPRIS »", V(0, 64, -28.5), V(46, 8, 1), C(80, 200, 255) } },
		decor = {
			{ "Frigo", "block", V(10, 22, 8), V(-55, 2, -24), C(240, 240, 245), "Metal" },
			{ "EcranFrigo", "block", V(5, 7, 0.4), V(-55, 6, -19.8), C(80, 200, 255), "Neon" },
			{ "Enceinte", "cyl", V(4, 8, 4), V(30, -6, -22), C(30, 30, 35), "SmoothPlastic" },
		},
		crowd = { colors = { C(200, 200, 210), C(80, 90, 110), C(80, 200, 255) }, places = stands(-6, -20) },
		trap = { kind = "sweeper", icon = "🤖", text = "« J'AI LANCÉ LA TONDEUSE »", color = C(80, 200, 255) },
	},
	{
		id = "village", owner = "Papi", name = "La Fête au Village",
		floor = { C(140, 100, 70), "WoodPlanks" }, ledge = { C(110, 80, 55), "WoodPlanks" }, soft = { C(200, 60, 60), "Fabric" },
		edge = C(255, 230, 100), wall = { C(30, 30, 70), "SmoothPlastic" }, sky = { 21, C(110, 100, 130), C(130, 120, 150) },
		signs = { { "BAL DU 14", V(0, 64, -28.5), V(28, 8, 1), C(255, 230, 100) } },
		decor = {
			{ "Guirlande", "block", V(160, 0.6, 0.6), V(0, 52, -24), C(255, 230, 100), "Neon" },
			{ "ChambouleTout", "block", V(14, 10, 6), V(-50, -4, -22), C(200, 60, 60), "Wood" },
			{ "AutoTamponneuse", "block", V(10, 5, 7), V(50, -8, -22), C(60, 120, 230), "SmoothPlastic" },
		},
		crowd = { colors = { C(200, 200, 210), C(230, 150, 120), C(120, 160, 230) }, places = stands(-6, -20) },
		trap = { kind = "sweeper", icon = "🚗", text = "UNE AUTO-TAMPONNEUSE S'ÉCHAPPE !", color = C(60, 120, 230) },
	},
	{
		id = "egouts", owner = "Ventouse", name = "Les Égouts Arc-en-ciel",
		floor = { C(80, 160, 180), "Metal" }, ledge = { C(255, 140, 60), "Metal" }, soft = { C(255, 210, 60), "Metal" },
		edge = C(255, 100, 200), wall = { C(50, 120, 140), "Concrete" }, sky = { 20, C(100, 140, 150), C(120, 160, 170) },
		signs = { { "VANNE N°7", V(-50, 50, -28.5), V(24, 6, 1), C(255, 210, 60) } },
		decor = {
			{ "Tuyau1", "cyl", V(120, 8, 8), V(0, 50, -26), C(255, 80, 80), "Metal", { axis = "x" } },
			{ "Tuyau2", "cyl", V(8, 60, 8), V(-60, 10, -26), C(80, 200, 120), "Metal" },
			{ "Tuyau3", "cyl", V(8, 60, 8), V(60, 10, -26), C(120, 120, 255), "Metal" },
			{ "Crocodile", "block", V(14, 3, 5), V(20, -10, -22), C(70, 200, 90), "SmoothPlastic" },
		},
		crowd = { colors = { C(150, 150, 160), C(70, 120, 200), C(255, 140, 60) }, places = stands(-6, -20) },
		trap = { kind = "geyser", icon = "💦", text = "UNE VANNE LÂCHE !", color = C(120, 200, 255) },
	},
}

Arenas.BY_ID = {}
for index, arena in ipairs(Arenas.LIST) do
	arena.index = index
	Arenas.BY_ID[arena.id] = arena
end

Arenas.DEFAULT = "bar"

return Arenas
