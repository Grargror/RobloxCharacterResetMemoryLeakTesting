# Roblox Character Reset Memory Leak Testing

The tests in this repository are intended to show whether the following cases will leak memory when a player's character is reset.

## Test Results:

### Memory Leak
The following cases appear to leak memory.
* **Player Character Connections** - It appears that connections attached to a player's character will not be properly cleaned up when resetting the player's character.  A developer must disconnected any connections created on the character or its children (e.g. humanoid.Died).  Alternately, the character must be manually destroyed when a player respawns.
* **ScreenGui "ResetOnSpawn" Enabled** - A ScreenGui will not release the memory allcated to it if the "ResetOnSpawn" option is enabled.  Disabling the option fixes the memory leak.
* **Equipped Tool Connections - Non-Descendant Script** - If a tool is equipped and the player resets their character, tool connections will not be disconnected unless those connections are created by a script which is a descendant of the tool.  A developer must disconnect the tool connections or destroy the tool when the tool's AncestryChanged event returns a nil parent.


### No Memory Leak
The following cases appear to properly clean up memory.
* **Player Backpack** - The player backpack appears to be properly cleaned up when a player's character resets.  Connections attached to the backpack are disconnected.  Connections for all tools in the backpack also appear to be disconnected.
* **Equipped Tool Connections - Descendant Script** - If the tool is equipped and the script which created the tool connections is a descendant of a tool, the connections appear to be properly disconnected.