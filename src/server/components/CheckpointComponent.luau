local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CheckpointService = require(ServerScriptService.services.CheckpointService)
local PlayerService = require(ServerScriptService.services.PlayerService)
local IComponent = require(ReplicatedStorage.shared.IComponent)

local CheckpointComponent = {}
CheckpointComponent.__index = CheckpointComponent
setmetatable(CheckpointComponent, IComponent)

local Component = IComponent.new({ 
    name = "Checkpoint",
    tag = "Checkpoint"
})
setmetatable(Component, CheckpointComponent)

function CheckpointComponent.Start(self)
    self:JoinIntoInstaceAddedEvent(function(instance)
        local part = instance :: BasePart
        local instanceStage = part:GetAttribute("Stage")
        CheckpointService:RegisterACheckpointPositionByStageLevel(instanceStage, part.Position)

        part.Touched:Connect(function(other)
            local character = other:FindFirstAncestorOfClass("Model")
            if not  character then
                return
            end

            local player = PlayerService:GetPlayerFromCharacter(character)
            local playerCurrentStage = PlayerService:GetPlayerAttribute(player, "Stage")
            
            if instanceStage and playerCurrentStage and playerCurrentStage == instanceStage then
                return
            end

            PlayerService:AttributeChange(player, "Stage", instanceStage)
        end)
    end)

    self:FireInitialize()
end

return Component