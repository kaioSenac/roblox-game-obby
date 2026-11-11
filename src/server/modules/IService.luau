local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Pool = require(ReplicatedStorage.external.Pool)
local IService = {}
IService.__index = IService

function IService.new(name)
    assert(type(name) == "string", 'Nome invalido para um servico')
    
    local self = setmetatable({
        initialized = false,
        name = name,
        pool = nil,
        internalSignal = Instance.new("BindableEvent")
    }, IService)

    return self
end

function IService:ConfigureExternalAccess(modules, restrictAccess)
    if not modules then return end
    print(`External configuration has been called from {self.name} service`)
    local pool = Pool.new(self:GetServiceNamespace())

    local defaultMethodsBlocked = {
        self.ConfigureExternalAccess,
        self.Start,
        self.Bind,
        self.internalFire,
        self.InitializeService,
        self.IsInitialized,
        self.GetServiceState,
        self.GetServiceNamespace,
        self.AssertInitialized
    }

    for _, method in restrictAccess do
        table.insert(defaultMethodsBlocked, method)
    end

    local function remoteAccesController(player, event, ...)
        if defaultMethodsBlocked[event] then return end

        local fn = modules[event]
        if not fn then return end

        return fn(modules, player, ...)
    end

    local function bindableAccess(event, ...)
        local fn = modules[event]
        if not fn then return end

        return fn(modules, ...)
    end

    pool:BindBindableEvent(bindableAccess)
    pool:BindBindableFunction(bindableAccess)
    pool:BindRemoteEvent(remoteAccesController)
    pool:BindRemoteFunction(remoteAccesController)

    self.pool = pool
end

function IService:Start()
    -- error(`Start() nao foi implementado para {self.name}`, 2)
    warn(`Start() nao foi implementado para o servico {self.name}`)
end

function IService:Bind(callback)
    local bindable = self.internalSignal :: BindableEvent
    bindable.Event:Connect(callback)
end

function IService:internalFire(...)
    self.internalSignal:Fire(...)
end

function IService:InitializeService()
    assert(not self.initialized, `{self.name} ja foi inicializado`)

    self.initialized = true
end

function IService:IsInitialized()
    return self.initialized and true or false
end

function IService:GetServiceState()
    if self:IsInitialized() then
        return "INITIALIZED"
    end
    return "NON_INITIALIZED"
end

function IService:GetServiceNamespace()
    return self.name
end

function IService:AssertInitialized()
    assert(self.initialized, `{self.name} nao foi inicializado`)
end

return IService