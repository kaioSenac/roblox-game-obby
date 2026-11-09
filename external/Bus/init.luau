local Connection = require(script.Connection)

local Bus = {}
Bus.__index = Bus

setmetatable(Bus, Connection)

type CallbackFunction = (...any) -> any

export type BusType = typeof(setmetatable({} :: {
    busPool: { [string | number]: { CallbackFunction } }
}, Bus))

function Bus.new(): BusType
    local self = Connection.new()

    setmetatable(self, Bus)

    self.busPool = {}

    return self
end

function Bus.Add(self: BusType, event: string| number, callback: CallbackFunction): ()
    assert(self.connected == true, "Nao pode registrar eventos pois ja foi finlizado")

    self.busPool[event] = self.busPool[event] or {} :: any
    table.insert(self.busPool[event], callback)
end

function Bus.Fire(self: BusType, event: string | number, ...): ()
    assert(self.connected == true, "Nao pode registrar eventos pois ja foi finlizado")

    for _, connection in self.busPool[event] do
        connection(...)
    end
end

return Bus