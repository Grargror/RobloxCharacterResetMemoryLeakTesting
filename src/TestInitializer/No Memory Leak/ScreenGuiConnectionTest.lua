------------------------
-- Test Outline
------------------------
--[[
NOTE: This script shows that connections attached to the ScreenGui ARE cleaned up properly.

Test:
1) In the TestInitializer, set the boolean for this module to 'true'
2) Play in Studio
3) Reset your character

Result:
* You will see that the first connection created HAS been disconnected

Fix:
* No fix needed.
--]]

------------------------
-- Settings
------------------------
local fixEnabledBoolean

------------------------
-- Variables
------------------------
local screenGuiName = "ConnectionTestScreenGui"
local screenGuiToClone = Instance.new("ScreenGui")
screenGuiToClone.Name = "screenGuiName"

------------------------
-- Connections
------------------------
local module = {}

function module.onPlayerAdded(player)
	local playerGui = player.PlayerGui
	
	playerGui.ChildAdded:Connect(function(child)
		if child:IsA("ScreenGui") and child.Name == screenGuiName then
			local initializeTime = os.clock()
			local screenGui = child
			
			local ancestryConnection = screenGui.AncestryChanged:Connect(function(_, parent)
				print("[" .. initializeTime .. "]", screenGui.Name, "ancestry changed:", parent)
				if fixEnabledBoolean and parent == nil then
					screenGui:Destroy()
				end
			end)
			
			while ancestryConnection.Connected do
				print("[" .. initializeTime .. "]", screenGui.Name, "connection alive")
				wait(1)
			end
		end
	end)
	
	local screenGui = screenGuiToClone:Clone()
	screenGui.Parent = playerGui
end

function module.setFixEnabledBoolean(boolVal)
	assert(typeof(boolVal) == "boolean", "BoolVal not a boolean!")
	
	fixEnabledBoolean = boolVal
end

return module