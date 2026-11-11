local ServerScriptService = game:GetService("ServerScriptService")
local CheckpointComponent = require(ServerScriptService.components.CheckpointComponent)
local KillBrickComponent = require(ServerScriptService.components.KillBrickComponent)
local MovingBlockComponent = require(ServerScriptService.components.MovingBlockComponent)
local RotationComponent = require(ServerScriptService.components.RotationComponent)
local IService = require(ServerScriptService.modules.IService)

local WorldComponentService = {}
WorldComponentService.__index = WorldComponentService
setmetatable(WorldComponentService, IService)

local service = IService.new("WorldComponentService")
setmetatable(service, WorldComponentService)

type WorldComponentService = typeof(WorldComponentService)

function WorldComponentService.Start(self: WorldComponentService)
    self:InitializeService()

    CheckpointComponent:Start()
    MovingBlockComponent:Start()
    KillBrickComponent:Start()
    RotationComponent:Start()
end


return service :: WorldComponentService