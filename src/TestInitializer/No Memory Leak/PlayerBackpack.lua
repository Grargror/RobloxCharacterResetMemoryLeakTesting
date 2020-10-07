------------------------
-- Test Outline
------------------------
--[[
NOTE: This script shows that the backpack IS cleaned up properly.

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

------------------------
-- Variables
------------------------
local backpackIndex = 0

------------------------
-- API
------------------------
local module = {}

function module.onPlayerAdded(player)
	player.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			local backpack = child
			
			backpackIndex += 1
			local thisBackpackIndex = backpackIndex
			
			local backpackAncestryConnection = backpack.AncestryChanged:Connect(function(_, parent)
				print("Backpack", backpackIndex, "new parent:", parent)
			end)
			
			while backpackAncestryConnection.Connected do
				print("AncestryChanged connection alive for backpack number:", thisBackpackIndex)
				wait(1)
			end
		end
	end)
end

return module