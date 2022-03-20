local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService('RunService')

local maxRetries = 8


local function coreCall(method, ...)
    local result = {}
    for _ = 1, maxRetries do
        result = {
            pcall(StarterGui[method], StarterGui, ...)
        }

        if result[1] then
            break
        end
        
        RunService.Stepped:Wait()
    end
    return unpack(result)
end

coreCall('SetCore', 'ResetButtonCallback', false)
