local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local checkpointPool = ReplicatedStorage.Events:WaitForChild("Checkpoint")
local player = Players.LocalPlayer

local function createHighlightEffect(instance, color, duration)
	local highlight = Instance.new("Highlight")
	highlight.FillColor = color or Color3.new(1, 1, 1)
	highlight.OutlineColor = Color3.new(1, 1, 1)
	--highlight.FillTransparency = 1
	--highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Enabled = true
	highlight.Parent = instance
	
	task.delay(duration or 1, function()
		highlight:Destroy()
	end)
end

local function changeColor(instance, color, duration)
	if not instance:IsA("BasePart") then
		return
	end
	
	local defaultInstanceColor = instance.Color
	
	instance.Color = color
	
	task.delay(duration or 1, function()
		instance.Color = defaultInstanceColor
	end)
end

local SpawnpointVisualEffect = {}

type SpawnpointVisualEffect = typeof(SpawnpointVisualEffect) & {}

function SpawnpointVisualEffect.Start(self)
	local checkpointRemoteEvent = checkpointPool:FindFirstChild("RemoteEvent")
	if not checkpointRemoteEvent then
		warn("RemoteEvent not found in Checkpoint folder")
		return
	end
	
	checkpointRemoteEvent.OnClientEvent:Connect(function(...)
		self.onCheckpointReached(self, ...)
	end)
end

function SpawnpointVisualEffect.onCheckpointReached(self, instance)
	createHighlightEffect(instance, Color3.new(0.411765, 0.603922, 0.572549), 0.6)
	changeColor(instance, Color3.new(0.411765, 0.603922, 0.572549), 0.6)
	
	if player.Character then
		createHighlightEffect(player.Character, nil, 0.6)
	end
end

return SpawnpointVisualEffect :: SpawnpointVisualEffect