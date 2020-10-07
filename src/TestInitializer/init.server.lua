-- ===================================
-- Roblox Event Memory Leak Testing
-- 
-- Last Updated: 201006
-- ===================================


----------------------
-- Settings
----------------------
-- Set the boolean to 'true" for the connection test script that you would like to run
local testScriptsToRun = {
	["Memory Leak"] = {
		CharacterConnection = false,
		ScreenGuiResetOnSpawn = false,
		ToolConnection = false
	},
	["No Memory Leak"] = {
		PlayerBackpack = false,
		ToolWithScriptInside = true,
		ScreenGuiConnectionTest = false
	}
}

-- Can apply the fix from here or from the script
local fixEnabledT = {
	["Memory Leak"] = {
		CharacterConnection = false,
		ScreenGuiResetOnSpawn = false,
		ToolConnection = false
	}
}


----------------------
-- Game Services
----------------------
local Players = game:GetService("Players")


----------------------
-- Variables
----------------------
local onPlayerAddedFunctionT = {}
local onPlayerRemovingFunctionT = {}

local respawnTime = 0

----------------------
-- Main Code
----------------------
Players.RespawnTime = respawnTime

-- Populate player added functions table
for folderName, runBoolT in pairs(testScriptsToRun) do
	for scriptName, boolVal in pairs(runBoolT) do
		if boolVal then
			local folder = script:FindFirstChild(folderName)
			assert(folder, "No folder by name: " .. folderName)
			
			local module = folder:FindFirstChild(scriptName)
			assert(module, 'No module by name: "' .. scriptName .. '" in folder ' .. folderName)
			
			local moduleAPI = require(module)
			
			local fixEnabledSettingT = fixEnabledT[folderName]
			if fixEnabledSettingT then
				local enabledBool = fixEnabledT[folderName][scriptName]

				if enabledBool ~= nil then
					moduleAPI.setFixEnabledBoolean(enabledBool)
				end
			end
			
			table.insert(onPlayerAddedFunctionT, moduleAPI.onPlayerAdded)

			local playerRemovingFunc = moduleAPI.onPlayerRemoving
			if playerRemovingFunc then
				table.insert(onPlayerRemovingFunctionT, playerRemovingFunc)
			end
		end
	end
end

-- Listen to player added event
Players.PlayerAdded:Connect(function(player)
	for _, func in pairs(onPlayerAddedFunctionT) do
		func(player)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	for _, func in pairs(onPlayerRemovingFunctionT) do
		func(player)
	end
end)