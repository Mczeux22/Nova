--[[
	Author      : Lopapon
	Module      : Table/Search
	Description : Fonctions de recherche dans les tables
]]

local Search = {}

-- Retourne le premier élément où predicate retourne true, nil sinon
-- Usage : retrouver un ennemi précis dans une liste par propriété

function	Search.find(t: { any }, predicate: (value: any) -> boolean): any?
	for _, value in ipairs(t) do
		if predicate(value) then
			return value
		end
	end
	return nil
end

-- Retourne tous les éléments où predicate retourne true
-- Usage : trouver tous les ennemis dans un certain rayon

function	Search.findAll(t: { any }, predicate: (value: any) -> boolean): { any }
	local result = {}
	for _, value in ipairs(t) do
		if predicate(value) then
			table.insert(result, value)
		end
	end
	return result
end

-- Vérifie si une valeur est présente dans une table (comparaison directe)
-- Usage : vérifier si un joueur est déjà dans une run

function	Search.contains(t: { any }, target: any): boolean
	for _, value in ipairs(t) do
		if value == target then
			return true
		end
	end
	return false
end

-- Vérifie si une table est vide
-- Usage : vérifier si une vague est terminée (plus d'ennemis vivants)

function	Search.isEmpty(t: { any }): boolean
	return next(t) == nil
end

return Search
