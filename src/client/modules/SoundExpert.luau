--[[
    @file: SoundExpert.luau
    @description: Um wrapper para o SoundReproduce.luau
    @author: JH1wer
    @created: 2026-11-08
    @updated: 2026-11-08
]]

local SoundReproduce = require(script.Parent.SoundReproduce)

local SoundExpert = {}
SoundExpert.__index = SoundExpert

setmetatable(SoundExpert, SoundReproduce)

--[[
    @function: SoundExpert.new
    @description: Responsavel criar contexto de musicas

    @param context: string - O nome do contexto (folder) onde ficara os sounds
    @param assets: { [string]: string } - Tabela de assets

    @return self
]]
function SoundExpert.new(context, assets)
    local contextFolder = script:FindFirstChild(context)
    if not contextFolder then
        contextFolder = Instance.new("Folder")
        contextFolder.Name = context
        contextFolder.Parent = script
    end

    for name, assetid in assets do
        local soundInstance = Instance.new("Sound")
        soundInstance.Name = name
        soundInstance.SoundId = assetid
        soundInstance.Parent = contextFolder
    end

    local self = setmetatable(SoundReproduce.new(contextFolder), SoundExpert)

    return self
end

return SoundExpert