--[[
	Author      : Lopapon
	Module      : Signal
	Description : Classe Signal (Connect, Fire, Disconnect, DisconnectAll)
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
}

function Signal.new(): Signal
	local self = setmetatable({}, Signal) :: Signal
	self._connections = {} -- Liste vide où on vient stocker les callbacks connectés
	return self
end

function Signal:Connect(callback: (...any) -> ()): Connection
	local connection = {} :: Connection
	connection._callback = callback
	connection._signal = self

	function connection:Disconnect()
		local connections = self._signal._connections
		local index = table.find(connections, self)
		if index then
			table.remove(connections, index)
		end
	end

	table.insert(self._connections, connection) -- On ajoute le callback à la liste
	return connection
end

function Signal:Fire(...: any) -- Varargs permet un nombre de valeurs reçues théoriquement infini
	for _, connection in ipairs(self._connections) do
		connection._callback(...) -- Appelle chaque callback connecté avec les arguments envoyés
	end
end

function Signal:DisconnectAll()
	self._connections = {} -- Vide tous les abonnés d'un coup (utile au cleanup d'une run par ex)
end

return Signal