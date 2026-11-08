local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local MovementBasepartComponent = {}
local MovementAnimationState = {} :: { [Instance]: number }
local MovementStandards = { } :: { [Instance]: Vector3 }

type MovementBasepartComponent = typeof(MovementBasepartComponent) & {
    initialized: boolean,
    constructed: { [Instance]: boolean },
    tag: string,
}

MovementBasepartComponent.tag = "MovementBasepart"

function MovementBasepartComponent.Init(self: MovementBasepartComponent): ()
    assert(not self.initialized, "Voce ja iniciou esse bucetao")

    self.initialized = true
    self.constructed = {}

    CollectionService.GetInstanceAddedSignal(self.tag):Connect(self.onTaggedConnected, self)

    CollectionService.GetInstanceRemovedSignal(self.tag):Connect(self.onTaggedDisconnected, self)

    for _, instance in CollectionService:GetTagged(self.tag) do
        self:onTaggedConnected(instance)
    end
end

function MovementBasepartComponent.onTaggedConnected(self: MovementBasepartComponent, instance: Instance)
    if self.constructed[instance] then
        return
    end
    
    --////.....
end

function MovementBasepartComponent.onTaggedDisconnected(self: MovementBasepartComponent, instance: Instance) end

return MovementBasepartComponent :: MovementBasepartComponent