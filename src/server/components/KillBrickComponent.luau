local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local KillBrickComponentSettings = require(ServerScriptService.components.componentSettings.KillBrickComponentSettings)
local PlayerService = require(ServerScriptService.services.PlayerService)
local TouchedService = require(ServerScriptService.services.TouchedService)
local IComponent = require(ReplicatedStorage.shared.IComponent)

local KillBrickComponent = {}
KillBrickComponent.__index = KillBrickComponent
setmetatable(KillBrickComponent, IComponent)

local Component = IComponent.new({
    name = "KillBrickComponent",
    tag = "KillBrick"
})
setmetatable(Component, KillBrickComponent)

type KillBrickComponent = typeof(KillBrickComponent) & {}

function KillBrickComponent.Start(self: KillBrickComponent): ()
    self:JoinIntoInstaceAddedEvent(function(object: Instance)
        self:Constructor(object)
    end)

    self:FireInitialize()
end

function KillBrickComponent.Constructor(self: KillBrickComponent, object: Instance): ()
    local part = object :: BasePart
    TouchedService:RegisterBrickDamageInstance(part)

    part.Touched:Connect(function (otherPart)
        local character = otherPart:FindFirstAncestorOfClass("Model")
        if character then
            local player = PlayerService:GetPlayerFromCharacter(character)
            TouchedService:DemageBrickTakeDamageFromPlayerWithCooldown(player, part, KillBrickComponentSettings.BRICK_DAMAGE)
        end
    end)
end

return Component :: KillBrickComponent