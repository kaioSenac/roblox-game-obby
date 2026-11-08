local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventsChecpointPool = ReplicatedStorage.Events.Checkpoint

local M = {}

function M.teleportPlayerToCheckpoint(player: Player, stage: number): ()
	local remoteEvent = EventsChecpointPool:FindFirstChild("BindableEvent") :: BindableEvent
	remoteEvent:Fire("TELEPORT", player, stage)
end

function M.teleportPlayerToCurrentStage(player: Player): ()
	local currentStage = player:GetAttribute("Stage")
	if not currentStage then
		return
	end
	
	M.teleportPlayerToCheckpoint(player, currentStage)
end

return M