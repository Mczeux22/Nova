--[[
	Author      : Lopapon
	Module      : Math/Rounding
	Description : Fonctions d'arrondi
]]

local Rounding = {}

-- Arrondi classique au nombre entier le plus proche
-- Usage : affichage des dégâts, calcul XP
function	Rounding.round(value: number): number
	return math.floor(value + 0.5)
end

-- Arrondi au nombre entier inférieur
-- Usage : index de tableau, calcul de vague
function	Rounding.floor(value: number): number
	return math.floor(value)
end

-- Arrondi au nombre entier supérieur
-- Usage : budget d'ennemis (toujours arrondir au-dessus)
function	Rounding.ceil(value: number): number
	return math.ceil(value)
end

-- Arrondi à N décimales
-- Usage : affichage de pourcentages (ex: 87.5%), stats de dégâts précis
function	Rounding.roundTo(value: number, decimals: number): number
	local factor = 10 ^ decimals
	return math.floor(value * factor + 0.5) / factor
end

return Rounding
