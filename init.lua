--[[
	Author      : Lopapon
	Module      : Nova (init)
	Description : Point d'entrée principal de la lib Nova
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Nova = {}

Nova.Signal = require(game/ReplicatedStorage.Shared.Nova.Signal)
Nova.Math   = require(game/ReplicatedStorage.Shared.Nova.Math)
Nova.Table  = require(game/ReplicatedStorage.Shared.Nova.Table)

return Nova
