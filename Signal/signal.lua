--[[
	Author      : Lopapon
	Module      : Signal
	Description : Classe Signal (Connect, Fire, Disconnect, DisconnectAll, Wait)
]]

local Signal = {}
Signal.__index = Signal

export type Connection = {
	Disconnect: (self: Connection) -> (),
	_callback: (...any) -> (),
	_signal: Signal,
}

export type Signal = {
	_connections: { Connection },
	new: () -> Signal,
	Connect: (self: Signal, callback: (...any) -> ()) -> Connection,
	Fire: (self: Signal, ...any) -> (),
	DisconnectAll: (self: Signal) -> (),
	Wait: (self: Signal) -> ...any,
}

function	Signal.new()
	local self = setmetatable({}, Signal)
	self._connections = {}
	return self
end

function	Signal:Connect(callback: (...any) -> ()): Connection
	local connection = {}
	connection._callback = callback
	connection._signal = self

	function	connection:Disconnect()
		local connections = self._signal._connections
		local index = table.find(connections, self)
		if index then
			table.remove(connections, index)
		end
	end

	table.insert(self._connections, connection)
	return connection
end

function	Signal:Fire(...: any)
	for _, connection in ipairs(self._connections) do
		connection._callback(...)
	end
end

function	Signal:DisconnectAll()
	self._connections = {}
end

function	Signal:Wait(): ...any
	local thread = coroutine.running() --Detourne la fonction coroutine pour pouvoir simuler le comportement d'un thread version miniature
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		coroutine.resume(thread, ...)
	end)
	return coroutine.yield()
end

return Signal
