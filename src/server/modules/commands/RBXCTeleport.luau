local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local modules = ServerScriptService.modules
local Wrapper = require(ReplicatedStorage.external.Pool.Wrapper)
local DeepCpr = require(ReplicatedStorage.shared.DeepCpr)
local PlayerProperties = require(modules.PlayerProperties)

local PlayerActions = Wrapper.new("PlayerActionPool")

local RBXCommandType = require(script.Parent.settings["RBXCommandType.d"])
local RBXCommandSettings = require(script.Parent.settings.RBXCommandSettings)

local M = {} :: RBXCommandType.RBXCommandBody

M.name = "teleport"
M.admin = true

M.run = function(ctx: TextSource, msg: string)
	local player = PlayerProperties.getPlayerByUserId(ctx.UserId)
	if not player or not player.Character then
		return
	end
	
	if not PlayerProperties.isAdmin(player) then
		return
	end
	
	local commandBody = msg:split(" ")
	local commandName = commandBody[2]
	local commandArgs = DeepCpr(commandBody, 3, #commandBody)

	local commands = {
		["stage"] = function(args)
			local stageLevel = tonumber(args[1])
			if not stageLevel then
				return
			end

			PlayerActions:BFire("teleportPlayerStage", player, stageLevel)
		end,

		["player"] = function(args)
			local targetPlayer = PlayerProperties.getPlayerByName(args[1])
			if not targetPlayer then
				return
			end

			local stageLevel = tonumber(args[3])

			if args[2] == "stage" then
				PlayerActions:BFire("teleportPlayerStage", player, stageLevel)
				return
			end
		end
	}

	local commandMatch = commands[commandName]
	if not commandMatch then return end

	commandMatch(commandArgs)
end

return M