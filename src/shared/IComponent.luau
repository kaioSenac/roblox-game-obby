local CollectionService = game:GetService("CollectionService")

local IComponent = {}
IComponent.__index = IComponent

type IComponent = typeof(setmetatable({} :: {
    tag: string,
    name: string,
    initialized: boolean,
    instanceAdded: BindableEvent
}, IComponent))

function IComponent.new(opts)
    local self = setmetatable({
        tag = opts.tag,
        name = opts.name,
        initialized = false,
        instanceAdded = Instance.new("BindableEvent")
    }, IComponent)

    local function instanceAddedConnection(instance)
        self.instanceAdded:Fire("ADDED", instance)
    end

    local function instanceRemovedConnection(instance)
        self.instanceAdded:Fire("REMOVED", instance)
    end

    CollectionService:GetInstanceAddedSignal(self.tag):Connect(instanceAddedConnection)

    CollectionService:GetInstanceRemovedSignal(self.tag):Connect(instanceRemovedConnection)

    for _, instance in CollectionService:GetTagged(self.tag) do
        instanceAddedConnection(instance)
    end

    return self
end

--// overridable function
function IComponent.Start(self: IComponent): ()
    warn(`Start() Non has start method from this component {self.name}`)
end

function IComponent.JoinIntoInstaceAddedEvent(self: IComponent, callback: (...any) -> ()): ()
    self.instanceAdded.Event:Connect(function(event, instance)
        if event == "ADDED" then
            callback(instance)
        end
    end)
end

function IComponent.GetName(self: IComponent): string
    return self.name
end

function IComponent.GetTag(self: IComponent): string
    return self.tag
end

function IComponent.Initialize(self: IComponent): ()
    self.initialized = true
end

function IComponent.HasInitialized(self: IComponent): boolean
    return self.initialized
end

return IComponent