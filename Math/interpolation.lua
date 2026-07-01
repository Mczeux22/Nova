--[[
	Author      : Lopapon
	Module      : Math/Interpolation
	Description : Fonctions d'interpolation
]]

local Interpolation = {}

-- Interpolation linéaire entre a et b selon t (0 = a, 1 = b)
-- Usage : smooth des barres de vie, transitions UI
function	Interpolation.lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

-- Interpolation lissée (ease in + ease out) — courbe en S
-- Plus naturel que lerp pour les mouvements de caméra ou d'UI
function	Interpolation.smoothLerp(a: number, b: number, t: number): number
	t = t * t * (3 - 2 * t) -- formule smoothstep
	return a + (b - a) * t
end

-- Accélération progressive (démarre lentement, finit vite)
-- Usage : projectile qui accélère, ennemi qui charge
function	Interpolation.easeIn(a: number, b: number, t: number): number
	return a + (b - a) * (t * t)
end

-- Décélération progressive (démarre vite, finit lentement)
-- Usage : UI qui glisse et s'arrête, knockback d'ennemi
function	Interpolation.easeOut(a: number, b: number, t: number): number
	return a + (b - a) * (1 - (1 - t) * (1 - t))
end

-- Accélération puis décélération (courbe en S plus prononcée que smoothLerp)
-- Usage : transitions de caméra, animations de levelup
function	Interpolation.easeInOut(a: number, b: number, t: number): number
	if t < 0.5 then
		return a + (b - a) * (2 * t * t)
	else
		return a + (b - a) * (1 - (-2 * t + 2) * (-2 * t + 2) / 2)
	end
end

return Interpolation
