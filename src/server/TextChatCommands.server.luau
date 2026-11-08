local TextChatService = game:GetService("TextChatService")

local ServerScriptService = game:GetService("ServerScriptService")

local Commands = ServerScriptService:WaitForChild("commands")

local CommandsType = require(Commands.settings["RBXCommandType.d"])

local RBXCommandSettings = require(Commands.settings.RBXCommandSettings)

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
	
	for key, value: CommandsType.RBXCommandBody in commandsTable do
		local instance = Instance.new("TextChatCommand")
		instance.Name = value.name
		instance.PrimaryAlias = "/" .. value.name
		
		instance.Triggered:Connect(value.run)
		
		instance.Parent = RBXCommandSettings.container
	end
end

transformCommandsInTextCommandInstance(CommandsLoadedTable)