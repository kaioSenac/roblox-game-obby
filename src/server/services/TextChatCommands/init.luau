local ServerScriptService = game:GetService("ServerScriptService")
local RBXCommandSettings = require(ServerScriptService.modules.commands.settings.RBXCommandSettings)
local ServiceInterface = require(script.Parent.ServiceInterface)
local Commands = ServerScriptService.modules.commands

local TextChatCommands = {}
TextChatCommands.__index = TextChatCommands

setmetatable(TextChatCommands, ServiceInterface)

local service = ServiceInterface.new("TextChatCommands")
setmetatable(service, TextChatCommands)

function TextChatCommands.Start(self)
    self:InitializeService()

    local CommandsLoadedTable = {}

    local function loadCommands()
        for _, module in Commands:GetChildren() do
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
    end

    loadCommands()

    local function transformCommandsInTextCommandInstance(commandsTable)
        if not commandsTable then
            return
        end

        for key, value in commandsTable do
            local instance = Instance.new("TextChatCommand")
            instance.Name = value.name
            instance.PrimaryAlias = "/" .. value.name
            
            instance.Triggered:Connect(value.run)
            
            instance.Parent = RBXCommandSettings.container
        end
    end

    transformCommandsInTextCommandInstance(CommandsLoadedTable)
end

return service