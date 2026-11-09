--[[
    @file: Pool.luau
    @description: Cria pools, ou seja, criar instancias de networking para ser acessadas pelo cliente
    @author: JH1wer
    @created: 2026-11-08
    @updated: 2026-11-08
]]

local RunService = game:GetService("RunService")
local Wrapper = require(script.Wrapper)
local Events = script

local Pool = {}
Pool.__index = Pool

setmetatable(Pool, Wrapper)

export type Pool = typeof(setmetatable({} :: {}, Pool))

--[[
    @function: Pool.new
    @description: Criar a instancia pool

    @param context: string - context ou o nome da pasta onde ira ficar os eventos
    @return Pool - retorna a instancia
]]
function Pool.new(context: string): Pool

    local pool = Events:FindFirstChild(context)
    if not pool and RunService:IsServer() then
        pool = Instance.new("Folder")
        pool.Name = context
        pool.Parent = Events

        Instance.new("RemoteFunction", pool)
        Instance.new("RemoteEvent", pool)
        Instance.new("BindableFunction", pool)
        Instance.new("BindableEvent", pool)
    end

    if not pool then
        return {} :: any
    end

    local self = Wrapper.new(context)
    
    setmetatable(self, Pool)

    return self
end

--[[
    @function: Pool.BindRemoteFunction
    @description: Associar o RemoteFunction a uma funcao

    @param self: Pool - a propria instancia
    @param callback: Function - Funcao associativa

    @return void
]]
function Pool.BindRemoteFunction(self, callback): ()
    if self.pool and self.pool.remoteFunction then
        local event = self.pool.remoteFunction :: RemoteFunction

        if RunService:IsServer() then
            event.OnServerInvoke = callback
        else
            event.OnClientInvoke = callback
        end
    end
end

--[[
    @function: Pool.BindRemoteEvent
    @description: Associar o RemoteEvent a uma funcao

    @param self: Pool - a propria instancia
    @param callback: Function - Funcao associativa

    @return void
]]
function Pool.BindRemoteEvent(self, callback): ()
    if self.pool and self.pool.remoteEvent then
        local event = self.pool.remoteEvent :: RemoteEvent
        
        if RunService:IsServer() then
            event.OnServerEvent:Connect(callback)
        else
            event.OnClientEvent:Connect(callback)
        end
    end
end

--[[
    @function: Pool.BindBindableEvent
    @description: Associar o BindableEvent a uma funcao

    @param self: Pool - a propria instancia
    @param callback: Function - Funcao associativa

    @return void
]]
function Pool.BindBindableEvent(self, callback): ()
    if self.pool and self.pool.bindableEvent then
        local event = self.pool.bindableEvent :: BindableEvent
        event.Event:Connect(callback)
    end
end

--[[
    @function: Pool.BindBindableFunction
    @description: Associar o BindableFunction a uma funcao

    @param self: Pool - a propria instancia
    @param callback: Function - Funcao associativa

    @return void
]]
function Pool.BindBindableFunction(self, callback): ()
    if self.pool and self.pool.bindableFunction then
        local event = self.pool.bindableFunction :: BindableFunction
        event.OnInvoke = callback
    end
end

return Pool