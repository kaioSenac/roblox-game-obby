local ServerScriptService = game:GetService("ServerScriptService")
local IService = require(ServerScriptService.modules.IService)

local CheckpointService = {}
CheckpointService.__index = CheckpointService
setmetatable(CheckpointService, IService)

local Service = IService.new("CheckpointService")
setmetatable(Service, CheckpointService)

type CheckpointService = typeof(CheckpointService) & {
    checkpointPositionsPool: { [string]: Vector3 },
}

function CheckpointService.Start(self: CheckpointService): ()
    self.checkpointPositionsPool = {}
    
    self:ConfigureExternalAccess(self, {
        self.RegisterACheckpointPositionByStageLevel
    })
end

function CheckpointService.RegisterACheckpointPositionByStageLevel(
    self: CheckpointService, 
    stage: number, 
    pos: Vector3
): ()
    if self.checkpointPositionsPool[tostring(stage)] then return end
    self.checkpointPositionsPool[tostring(stage)] = pos
end

function CheckpointService.GetPostionByStage(self: CheckpointService, stage: number): Vector3?
    if not stage then return nil end

    local pos = self.checkpointPositionsPool[tostring(stage)]
    return pos + Vector3.new(0, 3, 0)
end

return Service :: CheckpointService