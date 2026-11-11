local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local IComponent = require(ReplicatedStorage.shared.IComponent)

local RotationComponent = {}
RotationComponent.__index = RotationComponent
setmetatable(RotationComponent, IComponent)

local Component = IComponent.new({
    name = "RotationComponent",
    tag = "Rotation"
})
setmetatable(Component, RotationComponent)

type RotationComponent = typeof(RotationComponent) & {}

function RotationComponent.Start(self: RotationComponent): ()
    self:JoinIntoInstaceAddedEvent(function(object: Instance)
        self:Constructor(object)
    end)

    self:FireInitialize()
end

function RotationComponent.Constructor(self: RotationComponent, object: Instance): ()
    local rotationType = object:GetAttribute("rotationType")
    if not rotationType then
        self:AxisRotation(object)
        return
    end

    if rotationType == "Orbital" then
        self:OrbitalRotation(object)
    else
        self:AxisRotation(object)
    end
end

function RotationComponent.AxisRotation(self: RotationComponent, object: Instance): ()
    local part = object :: BasePart
    local omega = 0.2 * math.pi

    task.spawn(function()
        RunService.Heartbeat:Connect(function(delta)
            part.CFrame = part.CFrame * CFrame.Angles(0, omega * delta, 0)
        end)
    end)
end

function RotationComponent.OrbitalRotation(self: RotationComponent, object: Instance): ()
    local part = object :: BasePart
    local partCenter = part.Position
    local angle = 0
    local omega = 0.2 * math.pi
    local radius = 20
    local axis = Vector3.new(1, 1, 0).Unit

    task.spawn(function()
        RunService.Heartbeat:Connect(function(delta)
            angle = angle + omega * delta
            part.CFrame = part.CFrame * CFrame.fromAxisAngle(axis, omega * delta)

            part.Position = partCenter + Vector3.new(
                radius * math.cos(angle),
                0,
                radius * math.sin(angle)
            )
        end)
    end)
end

return Component :: RotationComponent