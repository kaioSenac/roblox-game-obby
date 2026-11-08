local character = script.Parent :: Model
local humanoid = character.Humanoid :: Humanoid

local PlayerRemoteEvent = script:WaitForChild("PlayerRemoteEvent") :: RemoteEvent
local PlayerActionConfig = require(script:WaitForChild("PlayerActionConfig"))

humanoid.StateChanged:Connect(function(a0: Enum.HumanoidStateType, a1: Enum.HumanoidStateType)
    if a1 == Enum.HumanoidStateType.Jumping then
        PlayerRemoteEvent:FireServer(PlayerActionConfig.STATE_JUMP)
    
    elseif a1 == Enum.HumanoidStateType.Freefall then
        PlayerRemoteEvent:FireServer(PlayerActionConfig.STATE_FALL)
        
    end
end)