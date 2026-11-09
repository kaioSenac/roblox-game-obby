local ServiceInterface = {}
ServiceInterface.__index = ServiceInterface

function ServiceInterface.new(name)
    assert(type(name) == "string", 'Nome invalido para um servico')
    
    local self = setmetatable({
        initialized = false,
        name = name,
        internalSignal = Instance.new("BindableEvent")
    }, ServiceInterface)

    return self
end

function ServiceInterface:Start()
    -- error(`Start() nao foi implementado para {self.name}`, 2)
    warn(`Start() nao foi implementado para o servico {self.name}`)
end

function ServiceInterface:Bind(callback)
    local bindable = self.internalSignal :: BindableEvent
    bindable.Event:Connect(callback)
end

function ServiceInterface:internalFire(...)
    self.internalSignal:Fire(...)
end

function ServiceInterface:InitializeService()
    assert(not self.initialized, `{self.name} ja foi inicializado`)

    self.initialized = true
end

function ServiceInterface:IsInitialized()
    return self.initialized and true or false
end

function ServiceInterface:GetServiceState()
    if self:IsInitialized() then
        return "INITIALIZED"
    end
    return "NON_INITIALIZED"
end

function ServiceInterface:GetServiceNamespace()
    return self.name
end

function ServiceInterface:AssertInitialized()
    assert(self.initialized, `{self.name} nao foi inicializado`)
end

return ServiceInterface