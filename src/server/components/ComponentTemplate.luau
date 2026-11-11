local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IComponent = require(ReplicatedStorage.shared.IComponent)

local ComponentTemplate = {}
ComponentTemplate.__index = ComponentTemplate
setmetatable(ComponentTemplate, IComponent)

local Component = IComponent.new({
    name = "NAME",
    tag = "TAG"
})
setmetatable(Component, ComponentTemplate)

type ComponentTemplate = typeof(ComponentTemplate) & {}

function ComponentTemplate.Start(self: ComponentTemplate): ()
    self:JoinIntoInstaceAddedEvent(function(object: Instance)
        self:Constructor(object)
    end)

    self:FireInitialize()
end

function ComponentTemplate.Constructor(self: ComponentTemplate, object: Instance): ()

end

return Component :: ComponentTemplate