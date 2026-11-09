local IService = {}
IService.__index = IService

function IService.new(name)
    assert(type(name) == "string", 'Nome invalido para um servico')
    
    local self = setmetatable({
        initialized = false,
        name = name,
        internalSignal = Instance.new("BindableEvent")
    }, IService)

    return self
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