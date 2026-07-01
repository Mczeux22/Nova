--[[
	Author      : Lopapon
	Module      : Math/Geometry
	Description : Fonctions géométriques 2D/3D
]]

local Geometry = {}

-- Distance entre deux positions 2D (X et Z, ignore la hauteur Y)
-- Usage : vérifier si un ennemi est dans le rayon d'attaque du joueur
function	Geometry.distance2D(a: Vector3, b: Vector3): number
	local dx = b.X - a.X
	local dz = b.Z - a.Z
	return math.sqrt(dx * dx + dz * dz)
end

-- Distance entre deux positions 3D (prend en compte la hauteur Y)
-- Usage : projectiles, sorts à portée en 3D
function	Geometry.distance3D(a: Vector3, b: Vector3): number
	return (b - a).Magnitude
end

-- Angle en radians entre deux positions 2D (X et Z)
-- Usage : orienter un projectile ou un ennemi vers une cible
function	Geometry.angleBetween(from: Vector3, to: Vector3): number
	local dx = to.X - from.X
	local dz = to.Z - from.Z
	return math.atan2(dz, dx)
end

-- Normalise une direction 2D (X et Z) pour obtenir un vecteur unitaire
-- Usage : donner une direction de déplacement à vitesse constante
function	Geometry.normalize2D(direction: Vector3): Vector3
	local length = math.sqrt(direction.X * direction.X + direction.Z * direction.Z)
	if length == 0 then
		return Vector3.new(0, 0, 0)
	end
	return Vector3.new(direction.X / length, 0, direction.Z / length)
end

-- Vérifie si une position est dans un rayon donné (2D)
-- Usage : détection de portée d'attaque, aggro d'ennemis
function	Geometry.isInRange2D(origin: Vector3, target: Vector3, range: number): boolean
	return Geometry.distance2D(origin, target) <= range
end

return Geometry