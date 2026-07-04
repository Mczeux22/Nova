--[[
	Author      : Lopapon
	Module      : DevTools/Movement/Fly
	Description : Fonctions de fly - CLIENT UNIQUEMENT
	              Pas d'etat interne au module : l'etat "en vol ou pas" est lu
	              directement depuis la presence des instances BodyVelocity/BodyGyro
	              sur le HumanoidRootPart. Ca permet d'appeler ces fonctions depuis
	              n'importe quel script sans se soucier de partager une variable d'etat.
]]

local Fly = {}

local VELOCITY_NAME = "DevToolsFlyVelocity"
local GYRO_NAME = "DevToolsFlyGyro"

function Fly.start(character: Model)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not humanoid or not rootPart then return end
	if Fly.isFlying(character) then return end

	humanoid.PlatformStand = true

	local velocity = Instance.new("BodyVelocity")
	velocity.Name = VELOCITY_NAME
	velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	velocity.Velocity = Vector3.new(0, 0, 0)
	velocity.Parent = rootPart

	local gyro = Instance.new("BodyGyro")
	gyro.Name = GYRO_NAME
	gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	gyro.CFrame = rootPart.CFrame
	gyro.Parent = rootPart
end

function Fly.stop(character: Model)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if rootPart then
		local velocity = rootPart:FindFirstChild(VELOCITY_NAME)
		local gyro = rootPart:FindFirstChild(GYRO_NAME)
		if velocity then velocity:Destroy() end
		if gyro then gyro:Destroy() end
	end
	if humanoid then humanoid.PlatformStand = false end
end

function Fly.toggle(character: Model)
	if Fly.isFlying(character) then
		Fly.stop(character)
	else
		Fly.start(character)
	end
end

function Fly.isFlying(character: Model): boolean
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return false end
	return rootPart:FindFirstChild(VELOCITY_NAME) ~= nil
end

function Fly.updateVelocity(character: Model, direction: Vector3, camCFrame: CFrame, speed: number)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local velocity = rootPart:FindFirstChild(VELOCITY_NAME) :: BodyVelocity?
	local gyro = rootPart:FindFirstChild(GYRO_NAME) :: BodyGyro?
	if not velocity or not gyro then return end

	local moveVector = direction
	if moveVector.Magnitude > 0 then
		moveVector = moveVector.Unit * speed
	end
	velocity.Velocity = moveVector
	gyro.CFrame = camCFrame
end

return Fly
