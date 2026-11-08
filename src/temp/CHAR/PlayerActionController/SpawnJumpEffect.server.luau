local PlayerRemoteEvent = script.Parent:WaitForChild("PlayerRemoteEvent") :: RemoteEvent
local PlayerActionConfig = require(script.Parent:WaitForChild("PlayerActionConfig"))

PlayerRemoteEvent.OnServerEvent:Connect(function(player, event, ...)
    if event == PlayerActionConfig.STATE_JUMP then
        -- TODO: fazer algo ao pular
    elseif event == PlayerActionConfig.STATE_FALL then
        -- TODO: fazer algo ao cair
    end
end)