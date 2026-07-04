--[[
	Author      : Lopapon
	Module      : DevTools (init)
	Description : Point d'entree des outils de dev - CLIENT UNIQUEMENT
	              Ne pas require() depuis un Script serveur (UserInputService n'existe pas cote serveur)
	Emplacement : ReplicatedStorage/DevTools (frere de Nova, pas dedans)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevTools = {}

DevTools.Movement = require(ReplicatedStorage.Shared.Nova.DevTools.Movement)

return DevTools
