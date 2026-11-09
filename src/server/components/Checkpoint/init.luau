local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Pool = require(ReplicatedStorage.external.Pool)
local ComponentTags = require(ReplicatedStorage.shared.ComponentTags)


local CheckpointAutoComponent = {}

type CheckpointAutoComponent = typeof(CheckpointAutoComponent) & {
	initialized: boolean,
	tag: string,
	pool: Pool.Pool,
	registeredPositions: { [number]: Vector3 }
}

--[[ 
	Inicializa o component de Checkpoints
]]
function CheckpointAutoComponent.Init(self: CheckpointAutoComponent): ()
	assert(not self.initialized, "CheckpointComponent is already!")

	self.registeredPositions = {}
	self.tag = ComponentTags.checkpointTag
	self.pool = Pool.new("CheckpointPool")

	CollectionService:GetInstanceAddedSignal(self.tag):Connect(function(instance)
		self:RegisterInstanceComponent(instance)
	end)

	CollectionService:GetInstanceRemovedSignal(self.tag):Connect(function(instance)
		self:UnregistInstanceComponent(instance)
	end)

	for _, instance in CollectionService:GetTagged(self.tag) do
		self:RegisterInstanceComponent(instance)
	end
end

--[[
	funcao utilizada pelo self:Init() - nao utilize de maneira externa
]]
function CheckpointAutoComponent.RegisterInstanceComponent(self: CheckpointAutoComponent, instance: Instance): ()
	local captureInstance = instance :: BasePart
	local captureInstanceStage = captureInstance:GetAttribute("Stage")

	if not self.registeredPositions[captureInstanceStage] then
		self.registeredPositions[captureInstanceStage] = captureInstance.Position
	end

	captureInstance.Touched:Connect(function(otherPart)
		local character = otherPart:FindFirstAncestorOfClass("Model")
		if not character then
			return
		end

		local player = Players:GetPlayerFromCharacter(character)
		local playerStage = player:GetAttribute("Stage")
		local checkpointTouchedStage = captureInstance:GetAttribute("Stage")

		if playerStage and checkpointTouchedStage and playerStage == checkpointTouchedStage then
			return
		end

		player:SetAttribute("Stage", checkpointTouchedStage)

		self.pool:FireClient(player, captureInstance)
	end)

	self.pool:BindBindableEvent(function(event, ...)
		if event == "TeleportPlayerStage" then
			local args = {...}
			local player = args[1]
			local stage = args[2]
			self:Teleport(player, stage)
		end
	end)
end

--[[ funcao utilizada pelo self:Init() - nao utilize externamente ]]
function CheckpointAutoComponent.UnregistInstanceComponent(self: CheckpointAutoComponent, instance: Instance): () end

--[[
	pegar a posicao do Checkpoint por stage level
	
	@param stage: number - Checkpoint stage
]]
function CheckpointAutoComponent.GetTeleportPositionByStage(self: CheckpointAutoComponent, stage: number): Vector3?
	return self.registeredPositions[stage] or nil
end

--[[
	Teleporta o player para algum checkpoint stage 

	@param player: Player - o player que sera teletransportado
	@param stage: number - o stagio para o onde o player ira
]]
function CheckpointAutoComponent.Teleport(self: CheckpointAutoComponent, player: Player, stage): ()
	local character = player.Character
	if not character then
		return
	end

	local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
	local destination = self:GetTeleportPositionByStage(stage)

	humanoidRootPart.CFrame = CFrame.new(destination + Vector3.new(0, 3, 0))
end

return CheckpointAutoComponent :: CheckpointAutoComponent