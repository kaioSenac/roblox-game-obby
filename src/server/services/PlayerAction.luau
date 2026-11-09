local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Pool = require(ReplicatedStorage.external.Pool)
local Wrapper = require(ReplicatedStorage.external.Pool.Wrapper)
local Animations = require(ReplicatedStorage.shared.Animations)

local PlayerAction = {}

type PlayerAction = typeof(PlayerAction) & {
    initialized: boolean,
    pools: {
        PlayerActionPool: Pool.Pool,
        CheckpointPool: Wrapper.EventWrapper
    }
}

function PlayerAction.Start(self: PlayerAction)
    assert(not self.initialized, 'ja foi inicializado')

    self.initialized = true

    self.pools = {
        PlayerActionPool = Pool.new("PlayerActionPool"),
        CheckpointPool = Wrapper.new("CheckpointPool")
    }

    local myServicePool = self.pools.PlayerActionPool

    local availableMethods = {
        ["overrideDefaultPlayerAnimations"] = self.OverrideDefaultPlayerAnimations,
        ["grantPlayerHumanoidHabilities"] = self.GrantPlayerHumanoidHabilities,
        ["teleportPlayerCurrentStage"] = self.TeleportPlayerCurrentStage,
        ["teleportPlayerStage"] = self.TeleportPlayerStage
    }

    local function validateRemotes(player, event, ...)
        local fn = availableMethods[event]
        if not fn then return end
        return fn(self, player, ...)
    end

    local function validateBindables(event, ...)
        local fn = availableMethods[event]
        if not fn then return end
        return fn(self, ...)
    end

    myServicePool:BindRemoteEvent(validateRemotes)
    myServicePool:BindRemoteFunction(validateRemotes)
    myServicePool:BindBindableEvent(validateBindables)
    myServicePool:BindBindableFunction(validateBindables)
end

function PlayerAction.OverrideDefaultPlayerAnimations(self: PlayerAction, player: Player): ()
    local character = player.Character
    if not character then
        return
    end

    local animate = character:FindFirstChild("HumanoidRootPart")
    if not animate then
        return
    end

    animate.walk.WalkAnim.AnimationId = Animations.DEFAULT_WALK
    animate.jump.JumpAnim.AnimationId = Animations.DEFAULT_JUMP
    animate.fall.FallAnim.AnimationId = Animations.DEFAULT_FALL
    animate.idle.Animation1.AnimationId = Animations.DEFAULT_IDLE1
    animate.idle.Animation2.AnimationId = Animations.DEFAULT_IDLE2
end

function PlayerAction.TeleportPlayerCurrentStage(self: PlayerAction, player: Player): ()
    local CheckpointPool = self.pools.CheckpointPool
    CheckpointPool:BFire("TeleportPlayerStage", player, player:GetAttribute("Stage") or 1)
end

function PlayerAction.TeleportPlayerStage(self: PlayerAction, player: Player, stage: number): ()
    local CheckpointPool = self.pools.CheckpointPool
    CheckpointPool:BFire("TeleportPlayerStage", player, stage)
end

function PlayerAction.GrantPlayerHumanoidHabilities(self: PlayerAction, player: Player, character: Model): ()
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    if not humanoid then return end

    humanoid.WalkSpeed = 30
    humanoid.JumpPower = 80
end

return PlayerAction :: PlayerAction