
local ICommand = {}
ICommand.__index = ICommand

type ICommandType = typeof(setmetatable({} :: {
    commandName: string,
    commandDesc: string,
    commandRestricted: boolean
}, ICommand))

type ICommandOptions = {
    name: string,
    desc: string,
    restricted: boolean
}

function ICommand.new(options: ICommandOptions): ICommandType
    return setmetatable({
        commandName = options.name,
        commandDesc = options.desc,
        commandRestricted = options.restricted
    }, ICommand)
end

function ICommand.Runnable(self: ICommandType, context: TextSource, message: string): ()
    warn(`Runnable() nao existe no comando {self.commandName}`)
end

function ICommand.GetName(self: ICommandType): string 
    return self.commandName
end

function ICommand.GetDesc(self: ICommandType): string
    return self.commandDesc
end

return ICommand