local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Bus = require(ReplicatedStorage.external.Bus)
local Garbage = require(ReplicatedStorage.external.Garbage)

local Inputs = {}
Inputs.__index = Inputs

function Inputs.new()
    local self = setmetatable({}, Inputs)

    local garbage = Garbage.new()
    self._inputIn = garbage:Add(Bus.new())
    self._inputOut = garbage:Add(Bus.new())
    self._garbage = garbage

    self:_Configure()
    return self
end

function Inputs:_Configure()
    self._garbage(UserInputService.InputBegan:Connect(function(key, gameProcesedEvent)
        if not gameProcesedEvent then return end
        self._inputIn:Fire("KeyboardInputIn", key.KeyCode)
    end))

    self._garbage(UserInputService.InputEnded:Connect(function(key, gameProcessedEvent)
        if not gameProcessedEvent then return end
        self._inputOut:Fire("KeyboardInputOut", key.KeyCode)
    end))
end

function Inputs:JoinInputIn(callback)
    self._inputIn:Add("KeyboardInputIn", function(...)
        callback(...)
    end)
end

function Inputs:JoinInputOut(callback)
    self._inputOut:Add("KeyboardInputOut", function(...)
        callback(...)
    end)
end

function Inputs:Destroy()
    self._garbage:Collector()
end

return Inputs