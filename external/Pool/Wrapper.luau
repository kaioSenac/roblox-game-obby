--[[
    @file: Wrapper.luau
    @description: Abstração para acessar e executar operações de networking,
    permitindo a comunicação entre cliente e servidor através de RemoteEvents,
    RemoteFunctions, BindableEvents e BindableFunctions.

    @author: JH1wer
    @created: 2026-11-08
    @updated: 2026-11-08
]]

local RunService = game:GetService("RunService")

local Events = script.Parent

local EventWrapper = {}
EventWrapper.__index = EventWrapper

export type EventWrapper = typeof(setmetatable({} :: {
    pool: {
        remoteEvent: RemoteEvent?,
        remoteFunction: RemoteFunction?,
        bindableEvent: BindableEvent?,
        bindableFunction: BindableFunction?
    }
}, EventWrapper))

--[[
    @function: EventWrapper.new
    @description: Criar uma instância do Wrapper e localizar os objetos
    de networking associados ao contexto informado.

    @param context: string - Nome da pasta que contém os objetos de networking.

    @return EventWrapper? - Retorna a instância do Wrapper caso o contexto exista,
    ou nil caso a pasta não seja encontrada.
]]
function EventWrapper.new(context: string): EventWrapper?
    local self = setmetatable({}, EventWrapper)

    local pool = {
        remoteFunction = nil,
        remoteEvent = nil,
        bindableEvent = nil,
        bindableFunction = nil
    }

    local selectedPool = Events:FindFirstChild(context)

    if not selectedPool then
        return nil
    end

    for _, events in pairs(selectedPool:GetChildren()) do
        if events:IsA("RemoteFunction") then
            pool.remoteFunction = events
        elseif events:IsA("RemoteEvent") then
            pool.remoteEvent = events
        elseif events:IsA("BindableEvent") then
            pool.bindableEvent = events
        elseif events:IsA("BindableFunction") then
            pool.bindableFunction = events
        end
    end

    self.pool = pool

    return self
end

--[[
    @function: EventWrapper.Fire
    @description: Disparar um RemoteEvent do cliente para o servidor.

    @param ...: any - Argumentos enviados junto com o evento.

    @return void

    @note: Disponível exclusivamente no cliente.
]]
function EventWrapper.Fire(self: EventWrapper, ...): ()
    if self.pool and self.pool.remoteEvent then
        self.pool.remoteEvent:FireServer(...)
    end
end

--[[
    @function: EventWrapper.FireClient
    @description: Disparar um RemoteEvent do servidor para um cliente específico.

    @param player: Player - Jogador que receberá o evento.
    @param ...: any - Argumentos enviados junto com o evento.

    @return void

    @note: Disponível exclusivamente no servidor.
]]
function EventWrapper.FireClient(self: EventWrapper, player: Player, ...): ()
    if RunService:IsClient() then return end

    if self.pool and self.pool.remoteEvent then
        self.pool.remoteEvent:FireClient(player, ...)
    end
end

--[[
    @function: EventWrapper.BFire
    @description: Disparar um BindableEvent para comunicação entre scripts
    executados no mesmo ambiente.

    @param ...: any - Argumentos enviados junto com o evento.

    @return void

    @note: Pode ser utilizado tanto no cliente quanto no servidor.
]]
function EventWrapper.BFire(self: EventWrapper, ...): ()
    if self.pool and self.pool.bindableEvent then
        self.pool.bindableEvent:Fire(...)
    end
end

--[[
    @function: EventWrapper.Fetch
    @description: Invocar um RemoteFunction do cliente para o servidor,
    aguardando e retornando a resposta da função.

    @param ...: any - Argumentos enviados junto com a invocação.

    @return any - Resultado retornado pelo callback do servidor, ou nil
    caso o RemoteFunction não esteja disponível.

    @note: Disponível exclusivamente no cliente.
]]
function EventWrapper.Fetch(self: EventWrapper, ...): any
    if self.pool and self.pool.remoteFunction then
        return self.pool.remoteFunction:InvokeServer(...)
    end

    return nil
end

--[[
    @function: EventWrapper.FetchClient
    @description: Invocar um RemoteFunction no cliente de um jogador específico,
    aguardando e retornando a resposta da função.

    @param player: Player - Jogador cujo cliente receberá a invocação.
    @param ...: any - Argumentos enviados junto com a invocação.

    @return any - Resultado retornado pelo callback do cliente, ou nil
    caso o RemoteFunction não esteja disponível.

    @note: Disponível exclusivamente no servidor.
]]
function EventWrapper.FetchClient(self: EventWrapper, player: Player, ...): any
    if RunService:IsClient() then return nil end

    if self.pool and self.pool.remoteFunction then
        return self.pool.remoteFunction:InvokeClient(player, ...)
    end

    return nil
end

--[[
    @function: EventWrapper.BFetch
    @description: Invocar um BindableFunction e retornar o resultado
    da função associada.

    @param ...: any - Argumentos enviados junto com a invocação.

    @return any - Resultado retornado pelo callback, ou nil
    caso o BindableFunction não esteja disponível.

    @note: Pode ser utilizado tanto no cliente quanto no servidor.
]]
function EventWrapper.BFetch(self: EventWrapper, ...): any
    if self.pool and self.pool.bindableFunction then
        return self.pool.bindableFunction:Invoke(...)
    end

    return nil
end

--[[
    @function: EventWrapper.Wait
    @description: Aguarda até que um contexto de networking esteja disponível.

    @param context: string - Nome da pasta de networking.
    @param timeout: number? - Tempo máximo de espera em segundos.

    @return EventWrapper? - Instância do Wrapper ou nil caso expire o timeout.
]]
function EventWrapper.Wait(context: string, timeout: number?): EventWrapper?
    local selectedPool = Events:FindFirstChild(context)

    if not selectedPool then
        local success, result = pcall(function()
            return Events:WaitForChild(context, timeout)
        end)

        if not success or not result then
            return nil
        end
    end

    return EventWrapper.new(context)
end

return EventWrapper