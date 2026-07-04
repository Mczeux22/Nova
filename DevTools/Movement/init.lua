--[[
	Author      : Lopapon
	Module      : DevTools/Movement (init)
	Description : Agrege Sprint et Fly -> Called in DevTools
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Movement = {}

local Sprint = require(ReplicatedStorage.Shared.Nova.DevTools.Movement.sprint)
local Fly    = require(ReplicatedStorage.Shared.Nova.DevTools.Movement.fly)

-- Sprint
Movement.enableSprint  = Sprint.enable
Movement.setSprinting  = Sprint.setSprinting

-- Fly
Movement.startFly      = Fly.start
Movement.stopFly       = Fly.stop
Movement.toggleFly     = Fly.toggle
Movement.isFlying      = Fly.isFlying
Movement.updateVelocity = Fly.updateVelocity

return Movement
