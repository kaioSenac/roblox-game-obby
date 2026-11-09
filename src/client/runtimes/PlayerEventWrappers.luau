local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Workspace = game:GetService("Workspace")
local Bus = require(ReplicatedStorage.external.Bus)

local player = Players.LocalPlayer
-- local camera = Workspace.CurrentCamera
local playerEventBus = Bus.new()
-- local playerInputBus = Bus.new()

local playerEventEnums = {
    CHARACTER_ADDED_CONNECT = 1,
    CHARACTER_APPEARANCE_LOADED_CONNECT = 2
}

local eventWrap = {
    joinCharacterAdded = function(callback: (...any) -> any)
        playerEventBus:Add(playerEventEnums.CHARACTER_ADDED_CONNECT, callback)
    end,

    joinCharacterAppearanceLoaded = function(callback: (...any) -> any)
        playerEventBus:Add(playerEventEnums.CHARACTER_APPEARANCE_LOADED_CONNECT, callback)
    end
}

player.CharacterAdded:Connect(function(character)
    playerEventBus:Fire(playerEventEnums.CHARACTER_ADDED_CONNECT, character)
end)

player.CharacterAppearanceLoaded:Connect(function(character: Model)
    playerEventBus:Fire(playerEventEnums.CHARACTER_APPEARANCE_LOADED_CONNECT, character)
end)


return {
    wrapper = eventWrap
}