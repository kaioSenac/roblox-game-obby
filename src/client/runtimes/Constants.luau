local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

return {
    PLAYER = Player,
    USERNAME = Player.Name,
    USERID = Player.UserId,
    CAMERA = camera,
}