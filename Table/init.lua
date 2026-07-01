--[[
	Author      : Lopapon
	Module      : Table (init)
	Description : Point d'entrée du module Table -> Called in Nova
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Table = {}

local Copy     = require(game/ReplicatedStorage.Shared.Nova.Table.copy)
local Mutation = require(game/ReplicatedStorage.Shared.Nova.Table.mutation)
local Search   = require(game/ReplicatedStorage.Shared.Nova.Table.search)

-- Copy
Table.shallowCopy = Copy.shallowCopy
Table.deepCopy    = Copy.deepCopy

-- Mutation
Table.merge   = Mutation.merge
Table.filter  = Mutation.filter
Table.map     = Mutation.map
Table.reverse = Mutation.reverse
Table.shuffle = Mutation.shuffle

-- Search
Table.find     = Search.find
Table.findAll  = Search.findAll
Table.contains = Search.contains
Table.isEmpty  = Search.isEmpty

return Table
