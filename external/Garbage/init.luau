
local Garbage = {}
Garbage.__index = Garbage

function Garbage.new()
    return setmetatable({
        stock = {}
    }, Garbage)
end

function Garbage:Add(instance)
    table.insert(self.stock, instance)
    return instance
end

function Garbage:Collector()
    if not self.stock then
        return
    end

    for _, element in self.stock do
        if element.Destroy then
            element:Destroy()
        elseif element.Disconnect then
            element:Disconnect()
        end
    end
end

return Garbage