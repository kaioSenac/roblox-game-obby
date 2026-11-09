local ServerScriptService = game:GetService("ServerScriptService")
local PlayerAction = require(ServerScriptService.services.PlayerAction)
local TextChatCommands = require(ServerScriptService.services.TextChatCommands)
local WorldComponent = require(ServerScriptService.services.WorldComponent)

WorldComponent:Start()
PlayerAction:Start()
TextChatCommands:Start()