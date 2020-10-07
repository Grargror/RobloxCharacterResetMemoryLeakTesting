------------------------
-- Test Outline
------------------------
--[[
Steps to show memory leak:
1) In the TestInitializer, set the boolean for this module to 'true'
2) Play in Studio
3) Open the console
4) Note the starting memory usage
5) Reset your character
6) Repeat steps 4 and 5 several times

Result:
* You should see that memory usage increases every time the player's character is reset

Fix:
* Disabling the "ResetOnSpawn" option for a ScreenGui seems to solve this issue
--]]


------------------------
-- Settings
------------------------
local fixEnabledBoolean

------------------------
-- Game Services
------------------------
local StarterGui = game:GetService("StarterGui")

------------------------
-- Variables
------------------------
local screenGuiName = "TestScreenGui"
local framesToCreate = 10000

------------------------
-- API
------------------------
local module = {}

function module.onPlayerAdded(player)	
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = screenGuiName

    if fixEnabledBoolean then
        screenGui.ResetOnSpawn = false
    end

    for _ = 1, framesToCreate do
        local frame = Instance.new("Frame")
        frame.Parent = screenGui
    end

    screenGui.Parent = StarterGui
end

function module.setFixEnabledBoolean(boolVal)
	assert(typeof(boolVal) == "boolean", "BoolVal not a boolean!")

	fixEnabledBoolean = boolVal
end

return module