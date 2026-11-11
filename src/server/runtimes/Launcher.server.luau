local ServerScriptService = game:GetService("ServerScriptService")
local CheckpointService = require(ServerScriptService.services.CheckpointService)
local PlayerService = require(ServerScriptService.services.PlayerService)
local TextChatCommandService = require(ServerScriptService.services.TextChatCommandService)
local TouchedService = require(ServerScriptService.services.TouchedService)
local WorldComponentService = require(ServerScriptService.services.WorldComponentService)

TextChatCommandService:Start()
TouchedService:Start()
CheckpointService:Start()
PlayerService:Start()

--// esse tem que ser o ultimo pois trata-se de componentes e esses componentes precisa dos servicos
WorldComponentService:Start()