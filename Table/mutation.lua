--[[
	Author      : Lopapon
	Module      : Table/Mutation
	Description : Fonctions de transformation de tables
]]

local Mutation = {}

-- Fusionne deux tables dans une nouvelle table (b écrase a en cas de conflit)
-- Usage : fusionner stats de base + bonus d'upgrade au levelup
function	Mutation.merge(a: { [any]: any }, b: { [any]: any }): { [any]: any }
	local result = {}
	for key, value in pairs(a) do
		result[key] = value
	end
	for key, value in pairs(b) do
		result[key] = value -- b écrase a si même clé
	end
	return result
end

-- Retourne une nouvelle table ne contenant que les éléments où predicate retourne true
-- Usage : garder uniquement les ennemis vivants dans une liste

function	Mutation.filter(t: { any }, predicate: (value: any) -> boolean): { any }
	local result = {}
	for _, value in ipairs(t) do
		if predicate(value) then
			table.insert(result, value)
		end
	end
	return result
end

-- Retourne une nouvelle table où chaque élément est transformé par transform
-- Usage : extraire les positions de tous les ennemis, convertir des valeurs

function	Mutation.map(t: { any }, transform: (value: any) -> any): { any }
	local result = {}
	for _, value in ipairs(t) do
		table.insert(result, transform(value))
	end
	return result
end

-- Retourne une nouvelle table avec les éléments dans l'ordre inverse
-- Usage : itérer et supprimer en même temps sans décaler les indices

function	Mutation.reverse(t: { any }): { any }
	local result = {}
	for i = #t, 1, -1 do
		table.insert(result, t[i])
	end
	return result
end

-- Mélange aléatoirement les éléments d'une table (modifie la table en place)
-- Usage : ordre de spawn aléatoire, choix d'upgrades au levelup

function	Mutation.shuffle(t: { any }): { any }
	for i = #t, 2, -1 do
		local j = math.random(1, i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

return Mutation
