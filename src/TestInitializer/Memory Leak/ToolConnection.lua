------------------------
-- Test Outline
------------------------
--[[
Steps to show memory leak:
1) In the TestInitializer, set the boolean for this module to 'true'
2) Play in Studio
3) Equip the Tool
4) Reset your character

Result:
* You will see that the first connection created has not been disconnected

Fix:
* Enabling the included "fixEnabledBoolean" section of code seems to solve this problem

Note:
* The player's backpack seems to be cleaned up properly.  
If the tool is not equipped when the character is reset, 
the tool's connections are properly disconnected. 
--]]

------------------------
-- Settings
------------------------
local fixEnabledBoolean

------------------------
-- Variables
------------------------
local toolToClone = Instance.new("Tool")
toolToClone.Name = "TestTool"

------------------------
-- API
------------------------
local module = {}

function module.onPlayerAdded(player)
	player.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			local backpack = child
			
			local tool = toolToClone:Clone()
			tool.Parent = backpack
			local initializeTime = os.clock()
			
			local ancestryConnection = tool.AncestryChanged:Connect(function(_, parent)
				print("[" .. initializeTime .. "]", tool.Name, "ancestry changed:", parent)
				if fixEnabledBoolean and parent == nil then
					tool:Destroy()
				end
			end)
			
			while ancestryConnection.Connected do
				print("[" .. initializeTime .. "]", tool.Name, "connection alive")
				wait(1)
			end
		end
	end)
end

function module.setFixEnabledBoolean(boolVal)
	assert(typeof(boolVal) == "boolean", "BoolVal not a boolean!")
	
	fixEnabledBoolean = boolVal
end

return module