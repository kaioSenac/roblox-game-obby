local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CheckpointComponent = require(script.Parent.CheckpointComponent)

local checkpoints = {
	workspace.Map.Checkpoints.Spawnpoint_1,
	workspace.Map.Checkpoints.Spawnpoint_2,
}

local componentsContext = {}

local function putComponentWithContext(context, instance)
	if not componentsContext[context] then
		componentsContext[context] = {}
	end
	
	table.insert(componentsContext[context], instance)
end

local function getComponentContextPack(context): { [Instance]: any }
	return componentsContext[context]
end

local function main()
	for checkpointIndex = 1, #checkpoints do
		local checkpoint = checkpoints[checkpointIndex]
		
		local checkpointComponent = CheckpointComponent.new(checkpoint, checkpointIndex)
		
		putComponentWithContext("Checkpoint", checkpointComponent)
	end
end

main()