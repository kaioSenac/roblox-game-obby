local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = require(script.Parent.PlayerService)
local IService = require(ServerScriptService.modules.IService)
local TouchedServiceSettings = require(ServerScriptService.services.serviceSettings.TouchedServiceSettings)

local TouchedService = {}
TouchedService.__index = TouchedService
setmetatable(TouchedService, IService)

TouchedService.ServiceSettings = TouchedServiceSettings
TouchedService.globalBrickDamageData = {} :: { [Instance] : { Player } }

local Service = IService.new("TouchedService")
setmetatable(Service, TouchedService)

type TouchedService = typeof(TouchedService)

function TouchedService.Start(self: TouchedService): ()
    self:InitializeService()

    self:ConfigureExternalAccess(self, {})
end

function TouchedService.RegisterBrickDamageInstance(self: TouchedService, instance: Instance): ()
    self.globalBrickDamageData[instance] = {}
end

function TouchedService.FindPlayer(self: TouchedService, player: Player, instance: Instance): boolean
    local max = #self.globalBrickDamageData[instance]
    if not max or max == 0 then
        return false
    end

    for i = 1, max do
        local targetPlayer = self.globalBrickDamageData[instance][i]
        if targetPlayer == player then
            return true
        end
    end
    return false
end

function TouchedService.AddPlayer(self: TouchedService, player : Player, instance: Instance): boolean
    -- if not self:FindPlayer(player, instance) then
    --     table.insert(self.globalBrickDamageData[instance], player)
    --     return true
    -- end
    -- return false
    if not self:FindPlayer(player, instance) then
        local max = #self.globalBrickDamageData[instance]

        for i = 1, max + 1 do
            local instanceTablePos = self.globalBrickDamageData[instance][i]
            if instanceTablePos == nil then
                self.globalBrickDamageData[instance][i] = player
                return true
            end
        end
    end
    return false
end

function TouchedService.DelPlayer(self: TouchedService, player: Player, instance : Instance): boolean
    if self:FindPlayer(player, instance) then
        for i = 1, #self.globalBrickDamageData[instance] do
            local targetPlayer = self.globalBrickDamageData[instance][i]
            if targetPlayer == player then
                self.globalBrickDamageData[instance][i] = nil
                return true
            end
        end
    end
    return false
end

function TouchedService.DemageBrickTakeDamageFromPlayerWithCooldown(self: TouchedService, player: Player, instance: Instance, damage: number): ()
    if self:FindPlayer(player, instance) then
        return
    end

    self:AddPlayer(player, instance)

    PlayerService:PlayerHumanoidTakeDemage(player, damage)

    task.delay(self.ServiceSettings.TOUCHED_COOLDOWN, function()
        self:DelPlayer(player, instance)
    end)
end

return Service :: TouchedService