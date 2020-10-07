local tool = script.Parent
local initializeTime = os.clock()

local ancestryConnection = tool.AncestryChanged:Connect(function(_, parent)
	print("[" .. initializeTime .. "]", tool.Name, "ancestry changed:", parent)
end)

while ancestryConnection.Connected do
	print("[" .. initializeTime .. "]", tool.Name, "connection alive")
	wait(1)
end