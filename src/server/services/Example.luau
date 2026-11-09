local ServiceInterface = require(script.Parent.ServiceInterface)


local Example = {}
Example.__index = Example

setmetatable(Example, ServiceInterface)

local ExampleService = ServiceInterface.new("Example")
setmetatable(ExampleService, Example)

return ExampleService