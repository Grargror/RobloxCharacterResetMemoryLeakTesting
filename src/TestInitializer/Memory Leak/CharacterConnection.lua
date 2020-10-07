------------------------
-- Test Outline
------------------------
--[[
Steps to show memory leak:
1) In the TestInitializer, set the boolean for this module to 'true'
2) Play in Studio
3) Reset your character

Result:
* You will see that the first connection created has not been disconnected

Fix:
* Enabling the included "fixEnabledBoolean" section of code seems to solve this problem
--]]


------------------------
-- Settings
------------------------
local fixEnabledBoolean

------------------------
-- Variables
------------------------
local characterIndex = 0
local characterT = {}

------------------------
-- API
------------------------
local module = {}

function module.onPlayerAdded(player)	
	player.CharacterAdded:Connect(function(character)
		if fixEnabledBoolean then
			if characterT[player] then
				characterT[player]:Destroy()
			end
			characterT[player] = character
		end
		
		characterIndex += 1
		local thisCharacterIndex = characterIndex
		
		local ancestryChangedConnection = character.AncestryChanged:Connect(function(_, parent)
			print("Character number", characterIndex, "new parent:", parent)
		end)
		
		while ancestryChangedConnection.Connected do
			print("Character AncestryChanged connection alive for character number:", thisCharacterIndex)
			wait(1)
		end
	end)
end

-- Not needed for this test, but would be if implementing the fix in a real game.
function module.onPlayerRemoving(player)
	if characterT[player] then
		characterT[player] = nil
	end
end

function module.setFixEnabledBoolean(boolVal)
	assert(typeof(boolVal) == "boolean", "BoolVal not a boolean!")
	
	fixEnabledBoolean = boolVal
end

return module