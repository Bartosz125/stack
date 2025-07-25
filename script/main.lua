-- Main execution script

-- Game ID check to ensure the script runs in the correct game.
assert(game.GameId == 7008097940, "Invalid Game!")

-- Load required modules using a conceptual 'require'
-- The original script used the bundler's `load` function.
local Signal = require("Signal") -- Originally __DARKLUA_BUNDLE_MODULES.load('b') -> 'a'
local UIManager = require("UIManager") -- Originally __DARKLUA_BUNDLE_MODULES.load('g')
local RedLightGreenLight = require("RedLightGreenLight") -- Originally __DARKLUA_BUNDLE_MODULES.load('h')
local Dalgona = require("Dalgona") -- Originally __DARKLUA_BUNDLE_MODULES.load('i')
local TugOfWar = require("TugOfWar") -- Originally __DARKLUA_BUNDLE_MODULES.load('j')
local GlassBridge = require("GlassBridge") -- Originally __DARKLUA_BUNDLE_MODULES.load('k')
local Mingle = require("Mingle") -- Originally __DARKLUA_BUNDLE_MODULES.load('l')
local HideAndSeek = require("HideAndSeek") -- Originally __DARKLUA_BUNDLE_MODULES.load('n')


-- Setup global state for script lifecycle management
if not shared._InkGameScriptState then
	shared._InkGameScriptState = {
		IsScriptExecuted = false,
		IsScriptReady = false,
		ScriptReady = Signal.new(),
		Cleanup = function() end,
	}
end

local GlobalScriptState = shared._InkGameScriptState

-- Handle script re-execution: clean up the old instance first.
if GlobalScriptState.IsScriptExecuted then
	if not GlobalScriptState.IsScriptReady then
		GlobalScriptState.ScriptReady:Wait()
		if GlobalScriptState.IsScriptReady then
			return
		end
	end
	GlobalScriptState.Cleanup()
end

GlobalScriptState.IsScriptExecuted = true

-- Wait for the game to fully load
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Initialize the User Interface
local UI = UIManager.new()

-- References to game state values
local GameState = workspace:WaitForChild("Values")
local CurrentGame = GameState:WaitForChild("CurrentGame")

-- Map game names to their corresponding feature modules
local Features = {
	["RedLightGreenLight"] = RedLightGreenLight,
	["Dalgona"] = Dalgona,
	["TugOfWar"] = TugOfWar,
	["GlassBridge"] = GlassBridge,
	["Mingle"] = Mingle,
	["HideAndSeek"] = HideAndSeek,
}

local CurrentRunningFeature = nil
local GameChangedConnection = nil

-- Function to clean up the currently running feature
local function CleanupCurrentFeature()
	if CurrentRunningFeature then
		CurrentRunningFeature:Destroy()
		CurrentRunningFeature = nil
	end
end

-- Function to handle the change of the current minigame
local function CurrentGameChanged()
	warn("Current game: " .. CurrentGame.Value)
	CleanupCurrentFeature()

	local Feature = Features[CurrentGame.Value]
	if not Feature then
		return
	end

	-- Create and start the new feature
	CurrentRunningFeature = Feature.new(UI)
	CurrentRunningFeature:Start()
end

-- Connect to game changes and run for the first time
GameChangedConnection = CurrentGame:GetPropertyChangedSignal("Value"):Connect(CurrentGameChanged)
CurrentGameChanged()

-- Define the global cleanup function
GlobalScriptState.Cleanup = function()
	CleanupCurrentFeature()
	if GameChangedConnection then
		GameChangedConnection:Disconnect()
		GameChangedConnection = nil
	end
	if not UI.IsDestroyed then
		UI:Destroy()
	end
	GlobalScriptState.IsScriptReady = false
	GlobalScriptState.IsScriptExecuted = false
end

-- Signal that the script is fully ready
GlobalScriptState.IsScriptReady = true
GlobalScriptState.ScriptReady:Fire()

-- Display notifications
UI:Notify("Script executed successfully!", 4)
UI:Notify("Script authored by: Jorsan, enjoy!", 4)
