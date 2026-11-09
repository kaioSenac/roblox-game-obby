local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local IService = require(ReplicatedStorage.shared.IService)
local Checkpoint = require(ServerScriptService.components.Checkpoint)

local WorldComponent = {}
WorldComponent.__index = WorldComponent

setmetatable(WorldComponent, IService)

local service = IService.new("WorldComponent")
setmetatable(service, WorldComponent)

type WorldComponent = typeof(WorldComponent)

function WorldComponent.Start(self: WorldComponent)
    self:InitializeService()

    Checkpoint:Init()

    self:Bind(function(event, ...)
        if event == "Reload" then
            self:ReloadAllComponents()
        end
    end)
end

function WorldComponent.ReloadAllComponents(self: WorldComponent)
    print("world components will be reload....")
end

return service :: WorldComponent