--[[
	Author      : Lopapon
	Module      : Math/Random
	Description : Fonctions de génération aléatoire
]]

local _rng = Random.new() -- ← capturé ici, AVANT que la table locale "Random" existe

local Random = {}

-- Nombre aléatoire décimal entre min et max
function Random.randomFloat(min: number, max: number): number
	return _rng:NextNumber(min, max)
end

-- Nombre entier aléatoire entre min et max (inclus)
function Random.randomInt(min: number, max: number): number
	return _rng:NextInteger(min, max)
end

-- Retourne aléatoirement 1 ou -1
function Random.randomSign(): number
	return _rng:NextInteger(0, 1) == 0 and -1 or 1
end

-- Retourne true avec une probabilité donnée (entre 0 et 1)
-- Usage : chance de drop (0.25 = 25%), coup critique (0.15 = 15%)
function Random.chance(probability: number): boolean
	return _rng:NextNumber() < probability
end

-- Angle aléatoire en radians (entre 0 et 2π)
-- Usage : direction de spawn d'ennemi autour du joueur
function Random.randomAngle(): number
	return _rng:NextNumber(0, math.pi * 2)
end

return Random