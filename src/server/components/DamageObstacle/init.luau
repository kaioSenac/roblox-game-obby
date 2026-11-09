local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IComponent = require(ReplicatedStorage.shared.IComponent)

local DamageObstacle = {}
DamageObstacle.__index = DamageObstacle

setmetatable(DamageObstacle, IComponent)
local Component = IComponent.new({ name = "DamageObstacle", tag = "Damage" })
setmetatable(Component, DamageObstacle)

type DamageObstacle = typeof(DamageObstacle) & {}

function DamageObstacle.Start(self: DamageObstacle): ()
    self:JoinIntoInstaceAddedEvent(function(instance)
        local part = instance :: BasePart
        part.Touched:Connect(function(otherPart)
            local character = otherPart:FindFirstAncestorOfClass("Character")
            if not character then
                return
            end

            local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
            if not humanoid then return end

            local health = humanoid.health
            if health <= 0 then return end

            humanoid.Health -= 100
        end)
    end)
end

return Component