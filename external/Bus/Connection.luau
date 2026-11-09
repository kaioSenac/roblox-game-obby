local Connection = {}
Connection.__index = Connection

export type ConnectionType = typeof(setmetatable({} :: {
    connected: boolean
}, Connection))

function Connection.new(): ConnectionType
    return setmetatable({
        connected = false
    }, Connection)
end

function Connection.Connect(self: ConnectionType): ()
    self.connected = true
end

function Connection.Disconnect(self: ConnectionType): ()
    self.connected = false
end

return Connection