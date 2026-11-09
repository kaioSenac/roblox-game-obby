local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TextService = game:GetService("TextService")
local IService = require(ReplicatedStorage.shared.IService)
local Commands = ServerScriptService.modules.commands

local TextChatCommands = {}
TextChatCommands.__index = TextChatCommands

setmetatable(TextChatCommands, IService)
local service = IService.new("TextChatCommands")
setmetatable(service, TextChatCommands)

function TextChatCommands.Start(self)
    self:InitializeService()

    local incorporedCommands = self:IncorporeCommands(Commands)

    self:TransformCommandsInTextCommandInstance(incorporedCommands)
end

function TextChatCommands.TransformCommandsInTextCommandInstance(self, commandTable)
    if not commandTable then
        return
    end

    for key, value in commandTable do
        local instance = Instance.new("TextChatCommand")
        instance.Name = value.name
        instance.PrimaryAlias = "/" .. value.name
        instance.Triggered:Connect(value.run)
        instance.Parent = TextService
    end
end

function TextChatCommands.IncorporeCommands(self, folder): { any }
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