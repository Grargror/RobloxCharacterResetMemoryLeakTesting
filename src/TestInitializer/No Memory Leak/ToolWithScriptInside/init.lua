------------------------
-- Test Outline
------------------------
--[[
NOTE: This script shows that a tool located inside the backpack IS cleaned up properly.

Test:
1) In the TestInitializer, set the boolean for this module to 'true'
2) Play in Studio
3) Reset your character

Result:
* You will see that the first connection created HAS been disconnected

Notes:
* This result suggests that the player's backpack and it's children ARE being cleaned up properly.

Fix:
* No fix needed.
--]]

------------------------
-- Settings
------------------------

------------------------
-- Variables
------------------------
local toolToClone = Instance.new("Tool")
toolToClone.Name = "TestTool"
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Parent = toolToClone

local toolScriptToClone = script:FindFirstChild("ToolScript")
toolScriptToClone.Disabled = true

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
			
			local toolScript = toolScriptToClone:Clone()
			toolScript.Parent = tool

			-- Parenting to a descendant also disconnects properly
			-- toolScript.Parent = tool.Handle 

			toolScript.Disabled = false
		end
	end)
end

return module