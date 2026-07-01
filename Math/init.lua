local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
	Author      : Lopapon
	Module      : Math (init)
	Description : Point d'entrée du module Math -> Called in Nova
]]

local Math = {}

local Interpolation = require(game/ReplicatedStorage.Shared.Nova.Math.interpolation) --Chemin d'acces fonctionne en mode game/Dossier_rojo.dossier_interne.fonction = permet ensuite les modulescripts
local Clamp         = require(game/ReplicatedStorage.Shared.Nova.Math.clamp)
local Rounding      = require(game/ReplicatedStorage.Shared.Nova.Math.rounding)
local Geometry      = require(game/ReplicatedStorage.Shared.Nova.Math.geometry)
local Random        = require(game/ReplicatedStorage.Shared.Nova.Math.random)

-- Interpolation
Math.lerp        = Interpolation.lerp
Math.smoothLerp  = Interpolation.smoothLerp
Math.easeIn      = Interpolation.easeIn
Math.easeOut     = Interpolation.easeOut
Math.easeInOut   = Interpolation.easeInOut

-- Clamp
Math.clamp       = Clamp.clamp
Math.clampMin    = Clamp.clampMin
Math.clampMax    = Clamp.clampMax

-- Rounding
Math.round       = Rounding.round
Math.floor       = Rounding.floor
Math.ceil        = Rounding.ceil
Math.roundTo     = Rounding.roundTo

-- Geometry
Math.distance2D  = Geometry.distance2D
Math.distance3D  = Geometry.distance3D
Math.angleBetween = Geometry.angleBetween
Math.normalize2D = Geometry.normalize2D
Math.isInRange2D = Geometry.isInRange2D

-- Random
Math.randomFloat = Random.randomFloat
Math.randomInt   = Random.randomInt
Math.randomSign  = Random.randomSign
Math.chance      = Random.chance
Math.randomAngle = Random.randomAngle

return Math
