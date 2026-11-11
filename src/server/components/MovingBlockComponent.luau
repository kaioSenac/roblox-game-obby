local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local IComponent = require(ReplicatedStorage.shared.IComponent)
local fhMHS = require(ReplicatedStorage.shared.math.fhMHS)

local MovingBlockComponent = {}
MovingBlockComponent.__index = MovingBlockComponent
setmetatable(MovingBlockComponent, IComponent)

local Component = IComponent.new({
    name = "MovingBlockComponent",
    tag = "Moving"
})
setmetatable(Component, MovingBlockComponent)

type MovingBlockComponent = typeof(MovingBlockComponent) & {}

function MovingBlockComponent.Start(self)
    self:JoinIntoInstaceAddedEvent(function(object: Instance)
        self:Constructor(object)
    end)

    self:FireInitialize()
end

function MovingBlockComponent.Constructor(self : MovingBlockComponent, object: Instance): ()
    local axis: string
    
    axis = object:GetAttribute("Axis") :: string
    if not axis  then
        axis = "x"
    end

    if axis and axis ~= "x" and axis ~= "y" then
        axis = "x"
    end

    self:SenoidalMoviment(object, axis)

    -- self:LissajousMoviment(object)
end

function MovingBlockComponent.LissajousMoviment(self: MovingBlockComponent, object: Instance): ()
    local part = object :: BasePart
    local center = part.Position
    local amplitude = 25
    local omega = 1

    local t = 0

    task.spawn(function()
        RunService.Heartbeat:Connect(function(delta)
            t = t + delta
            part.Position = center + Vector3.new(
                amplitude * math.sin(omega * t),
                amplitude * math.cos(omega * t),
                0
            )
        end)
    end)
end
 
function MovingBlockComponent.SenoidalMoviment(self: MovingBlockComponent, object: Instance, axis: "x" | "y" | string): ()
    local part = object :: BasePart
    local center = part.Position
    local amplitude = 25
    local omega = 1

    local t = 0

    task.spawn(function()
        RunService.Heartbeat:Connect(function(delta)
            t = t + delta
            local pos 

            if axis == "x" then
                pos = center + Vector3.new(fhMHS(amplitude, omega, t, 0), 0, 0)
            elseif axis == "y" then
                pos = center + Vector3.new(0, fhMHS(amplitude, omega, t, 0), 0)
            end

            part.Position = pos
        end)
    end)
end

return Component :: MovingBlockComponent