local ServerScriptService = game:GetService("ServerScriptService")
local ServiceInterface = require(script.Parent.ServiceInterface)
local Checkpoint = require(ServerScriptService.components.Checkpoint)

local WorldComponent = {}
WorldComponent.__index = WorldComponent

setmetatable(WorldComponent, ServiceInterface)

local service = ServiceInterface.new("WorldComponent")
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