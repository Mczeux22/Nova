--[[
	Author      : Lopapon
	Module      : Math/Clamp
	Description : Fonctions de limitation de valeurs
]]

local Clamp = {}

-- Limite une valeur entre min et max
-- Usage : HP entre 0 et maxHP, vitesse entre vitMin et vitMax
function	Clamp.clamp(value: number, min: number, max: number): number
	return math.max(min, math.min(max, value))
end

-- Limite une valeur à un minimum seulement (pas de maximum)
-- Usage : dégâts ne peuvent pas descendre sous 1, XP ne peut pas être négatif
function	Clamp.clampMin(value: number, min: number): number
	return math.max(min, value)
end

-- Limite une valeur à un maximum seulement (pas de minimum)
-- Usage : stack de buff limité à 10, vitesse max d'un projectile
function	Clamp.clampMax(value: number, max: number): number
	return math.min(max, value)
end

return Clamp
