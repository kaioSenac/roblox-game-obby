
local ServerScriptService = game:GetService("ServerScriptService")
local TextChatService = game:GetService("TextChatService")
local IService = require(ServerScriptService.modules.IService)
local Commands = ServerScriptService.modules.commands

local TextChatCommandService = {}
TextChatCommandService.__index = TextChatCommandService
setmetatable(TextChatCommandService, IService)

local service = IService.new("TextChatCommandService")
setmetatable(service, TextChatCommandService)

function TextChatCommandService.Start(self)
    self:InitializeService()

    local incorporedCommands = self:IncorporeCommands(Commands)

    self:TransformCommandsInTextCommandInstance(incorporedCommands)
end

function TextChatCommandService.TransformCommandsInTextCommandInstance(self, commandTable)
    if not commandTable then
        return
    end

    for key, value in commandTable do
        local instance = Instance.new("TextChatCommand")
        instance.Name = value:GetName()
        instance.PrimaryAlias = "/" .. value:GetName()
        instance.Triggered:Connect(function(ctx, msg)
            value:Runnable(ctx, msg)
        end)
        instance.Parent = TextChatService
    end
end

function TextChatCommandService.IncorporeCommands(self, folder): { any }
    local CommandsLoadedTable = {}
    for _, module in folder:GetChildren() do
        if module:IsA("ModuleScript") then
            local success, result = pcall(function()
                return require(module)
            end)

            if success then
                CommandsLoadedTable[module.Name] = result
            else
                warn("Failed to load command module: " .. module.Name .. " - " .. result)
            end
        end
    end
    return CommandsLoadedTable
end

return service