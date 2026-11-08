local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local CheckpointPool = Events.Checkpoint

local CheckpointComponent = {}
CheckpointComponent.__index = CheckpointComponent

export type CheckpointComponent = typeof(setmetatable({} :: {
	instance: Instance,
	pool: {
		BindableEvent: BindableEvent,
		RemoteEvent: RemoteEvent
	}
}, CheckpointComponent))

function CheckpointComponent.new(instance: Instance, stage: number): CheckpointComponent
	local self = setmetatable({}, CheckpointComponent)
	
	self.instance = instance

	self.pool = {
		BindableEvent = CheckpointPool.BindableEvent,
		RemoteEvent = CheckpointPool.RemoteEvent,
		--RemoteFunction = Instance.new("RemoteFunction")
	}
	
	local touchedConnection
	
	self.instance:SetAttribute("Stage", stage)
	
	if self.instance:IsA("BasePart") then
		touchedConnection = self.instance.Touched:Connect(function(otherPart)
			local character = otherPart:FindFirstAncestorOfClass("Model")
			local player = Players:GetPlayerFromCharacter(character)
			
			if not player then
				return
			end
			
			local stage = player:GetAttribute("Stage")
			local instanceStage = self.instance:GetAttribute("Stage")
			
			if stage and instanceStage and stage == instanceStage then
				return
			end
			
			player:SetAttribute("Stage", instanceStage)
			
			self.pool.RemoteEvent:FireClient(player, self.instance)
		end)
	end
	
	self.pool.BindableEvent.Event:Connect(function(event, ...)
		if event == "BROKE" then
			if touchedConnection then
				touchedConnection:Disconnect()
			end
					
		elseif event == "TELEPORT" then
			local args = {...}
			
			local player = args[1]
			
			local stage = args[2]
			
			if stage == self.instance:GetAttribute("Stage") then
				self:Teleport(player)
			end
		end
	end)
	
	return self
end

function CheckpointComponent.Teleport(self: CheckpointComponent, player: Player): ()
	local character = player.Character
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local instance = self.instance :: BasePart
	
	humanoidRootPart.CFrame = CFrame.new(instance.CFrame.Position + Vector3.new(0,3,0))
end

function CheckpointComponent.Destroy(self: CheckpointComponent): ()
	self.pool.BindableEvent:Fire("BROKE", nil)
end

return CheckpointComponent