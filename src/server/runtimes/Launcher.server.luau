local ServerScriptService = game:GetService("ServerScriptService")
local Example = require(ServerScriptService.services.Example)
local PlayerAction = require(ServerScriptService.services.PlayerAction)
local TextChatCommands = require(ServerScriptService.services.TextChatCommands)
local WorldComponent = require(ServerScriptService.services.WorldComponent)

WorldComponent:Start()
PlayerAction:Start()
TextChatCommands:Start()
Example:Start()

WorldComponent:internalFire("Reload")