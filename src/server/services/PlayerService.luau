local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local CheckpointService = require(script.Parent.CheckpointService)
local IService = require(ServerScriptService.modules.IService)

local PlayerService = {}
PlayerService.__index = PlayerService
setmetatable(PlayerService, IService)

local Service = IService.new("PlayerService")
setmetatable(Service, PlayerService)

type PlayerServiceType = typeof(PlayerService) & {
    playerAttributePool: { [Player]: { [string]: any } }
}

function PlayerService.Start(self: PlayerServiceType): ()
    self:InitializeService()

    self:ConfigureExternalAccess(self, {})

    self.playerAttributePool = {} :: { [Player]: { [string]: any }}

    Players.PlayerAdded:Connect(function(player)
        player:SetAttribute("Stage", 1)

        player.CharacterAdded:Connect(function(char: Model)
            local status = self:CheckpointTeleport(player, player:GetAttribute("Stage"))
            if not status then
                --// force teleporte to
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(player) end)
end

function PlayerService.CheckpointTeleport(self: PlayerServiceType, player: Player, stage: number): boolean
    if not player or not stage then return false end

    local character

    if player.Character then
        character = player.Character
    else
        player.CharacterAdded:Wait()
        character = player.Character
    end

    local pos = CheckpointService:GetPostionByStage(stage)

    if not pos then return false end

    local success, _ = pcall(function()
        character:MoveTo(pos)
    end)

    return success
end

function PlayerService.PlayerHumanoidTakeDemage(self: PlayerServiceType, player: Player, damage: number): ()
    local humanoid

    humanoid = self:GetPlayerHumanoid(player)
    if humanoid and humanoid.Health > 0 then
        humanoid.Health -= damage
    end
end

function PlayerService.GetPlayerHumanoid(self: PlayerServiceType, player: Player, timeout: number?): Humanoid?
    local promisedValue

    local character = player.Character or player.CharacterAdded:Wait()
    if character and character.Humanoid then
        promisedValue = character.Humanoid
    end

    return promisedValue
end

function PlayerService.GetPlayerFromCharacter(self: PlayerServiceType, character: Model): Player
    return Players:GetPlayerFromCharacter(character)
end

function PlayerService.GetPlayerAttribute(self: PlayerServiceType, player:Player,  attribute: string): any
    return player:GetAttribute(attribute)
end

function PlayerService.AttributeChange(self: PlayerServiceType, player: Player, attribute: string, value: any): ()
    player:SetAttribute(attribute, value)
end

function PlayerService.JoinPlayerStageChange(self: PlayerServiceType, callback: (player: Player, attribute: string) -> ()): () end

return Service :: PlayerServiceType