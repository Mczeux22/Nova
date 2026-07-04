--[[
	Author      : Lopapon
	Module      : DevTools/Movement/Sprint
	Description : Fonctions de sprint - CLIENT UNIQUEMENT (agit sur un Humanoid local)
]]

local Sprint = {}

function Sprint.enable(humanoid: Humanoid, normalSpeed: number)
	humanoid.WalkSpeed = normalSpeed
end

function Sprint.setSprinting(humanoid: Humanoid, isSprinting: boolean, normalSpeed: number, sprintSpeed: number)
	humanoid.WalkSpeed = isSprinting and sprintSpeed or normalSpeed
end

return Sprint

