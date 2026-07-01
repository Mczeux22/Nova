--[[
	Author      : Lopapon
	Module      : Table/Copy
	Description : Fonctions de copie de tables
]]

local Copy = {}

-- Copie superficielle : copie uniquement le premier niveau de la table
-- Les sous-tables sont partagées par référence (pas dupliquées)
-- Usage : dupliquer une liste simple d'ennemis, copier des stats sans sous-tables

function	Copy.shallowCopy(t: { [any]: any }): { [any]: any }
	local copy = {}
	for key, value in pairs(t) do
		copy[key] = value
	end
	return copy
end

-- Copie profonde : copie récursivement toute la structure, y compris les sous-tables
-- Usage : dupliquer un template d'ennemi depuis WaveConfig sans modifier l'original

function	Copy.deepCopy(t: { [any]: any }): { [any]: any }
	local copy = {}
	for key, value in pairs(t) do
		if type(value) == "table" then
			copy[key] = Copy.deepCopy(value) -- copie récursive des sous-tables
		else
			copy[key] = value
		end
	end
	return copy
end

return Copy
