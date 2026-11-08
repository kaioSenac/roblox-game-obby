local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local M = {}

M.Map = Workspace:FindFirstChild("Map") :: Folder
M.MAP_CHECKPOINTS_FOLDER = M.Map:FindFirstChild("Checkpoints") :: Folder
M.MAP_ENVIRONMENT_FOLDER = M.Map:FindFirstChild("Environment") :: Folder
M.MAP_PLATFORMS = M.Map:FindFirstChild("Platforms") :: Folder
M.MAP_MOVING_PLATFORMS = M.MAP_PLATFORMS:FindFirstChild("moving") :: Folder
M.MAP_TANSLUCE_PLATFORMS = M.MAP_PLATFORMS:FindFirstChild("transluce") :: Folder
M.MAP_OBSTACLES = M.Map:FindFirstChild("Obstacles") :: Folder

M.ASSETS = ReplicatedStorage:FindFirstChild("Assets") :: Folder

return M