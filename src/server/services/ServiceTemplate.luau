local ServerScriptService = game:GetService("ServerScriptService")
local IService = require(ServerScriptService.modules.IService)

local ServiceTemplate = {}
ServiceTemplate.__index = ServiceTemplate
setmetatable(ServiceTemplate, IService)

local Service = IService.new("ServiceTemplate")
setmetatable(Service, ServiceTemplate)

type ServiceTemplate = typeof(ServiceTemplate) & {}

function ServiceTemplate.Start(self: ServiceTemplate): ()
    self:InitializeService()
    self:ConfigureExternalAccess(self, {})
end

return Service :: ServiceTemplate