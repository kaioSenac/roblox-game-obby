local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local modules = ServerScriptService.modules
local PlayerService = require(ServerScriptService.services.PlayerService)
local ICommand = require(ReplicatedStorage.shared.ICommand)
local TableCopyRange = require(ReplicatedStorage.shared.TableCopyRange)
local PlayerProperties = require(modules.PlayerProperties)

local RBXCTeleport = {}
RBXCTeleport.__index = RBXCTeleport

setmetatable(RBXCTeleport, ICommand)

local Command = ICommand.new({
	name = "teleport",
	desc = "Teleport commands",
	restricted = true
})
setmetatable(Command, RBXCTeleport)

type RBXCTeleportType = typeof(RBXCTeleport) & {}

function RBXCTeleport.Runnable(self: RBXCTeleportType, context: TextSource, message: string): ()
	local player = PlayerProperties.getPlayerByUserId(context.UserId)
	if not player or not player.Character then
		return
	end

	if not PlayerProperties.isAdmin(player) then
		return
	end

	local commandBody = message:split(" ")
	local commandName = commandBody[2]
	local commandArgs = TableCopyRange(commandBody, 3, #commandBody)

	local commands = {
		["stage"] = function(args)
			local levelStage = tonumber(args[1])
			if not levelStage then return end

			PlayerService:CheckpointTeleport(player, levelStage)
		end,

		["player"] = function(args)
			local targetPlayer = PlayerProperties.getPlayerByName(args[1])
			if not targetPlayer then return end

			local levelStage = tonumber(args[3])
			if args[2] == "stage" then
				-- PlayerAction:TeleportPlayerStage(targetPlayer, levelStage)
				PlayerService:CheckpointTeleport(player, levelStage)
			end
		end
	}

	local commandMatch = commands[commandName]
	if not commandMatch then return end

	commandMatch(commandArgs)
end

return Command