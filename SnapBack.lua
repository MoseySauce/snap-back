local function listCommand()
	local data = C_EditMode.GetLayouts()
	local layouts = data and data.layouts

	if layouts and #layouts > 0 then
		SnapBack.PrintInfo("Listing available custom layouts:")
		for i, layout in ipairs(layouts) do
			SnapBack.PrintInfo("  [%d] %s (system: %s)", i, layout.layoutName or "Unnamed", tostring(layout.systems))
		end
	else
		SnapBack.PrintError("No layouts found.")
	end
end

local function statusCommand()
	SnapBack.PrintInfo("Debug is %s (SnapBack.debugEnabled), Saved as %s (SnapBackDB.debugEnabled)", tostring(SnapBack.debugEnabled), tostring(SnapBackDB and SnapBackDB.debugEnabled))
	SnapBack.PrintDebug("runDebug is %s", type(SnapBack.runDebug))
end

local function debugCommand(arg)
	arg = arg:lower()
	if arg == "true" then
		SnapBack.debugEnabled = true
		SnapBack.PrintInfo("Debugging enabled.")
	elseif arg == "false" then
		SnapBack.debugEnabled = false
		SnapBack.PrintInfo("Debugging disabled.")
	else
		SnapBack.PrintError("Usage: /snapback debug true|false")
		return
	end
	SnapBackDB.debugEnabled = SnapBack.debugEnabled
end

local function helpCommand()
	SnapBack.PrintInfo("Available commands:")
	SnapBack.PrintInfo("  /snapback debug [true|false] - Enable or disable debugging.")
	SnapBack.PrintInfo("  /snapback list - List available custom layouts.")
	SnapBack.PrintInfo("  /snapback status - Show current status and debug settings.")
	SnapBack.PrintInfo("  /snapback about - Show information about this add-on.")
	SnapBack.PrintInfo("  /snapback help - Show this help message.")
end

local function aboutCommand()
    SnapBack.PrintInfo(SnapBack.Title)
    SnapBack.PrintInfo("Version: %s", SnapBack.Version or "unknown")
    SnapBack.PrintInfo("Author: %s", SnapBack.Author or "unknown")
    SnapBack.PrintInfo("Description: %s", SnapBack.Description or "No description available.")
    SnapBack.PrintInfo("Type '/snapback help' for a list of commands.")
end

local function onAddonLoaded()
	SnapBack.PrintDebug("begin onAddonLoaded")
	SnapBackDB = SnapBackDB or {}
	
	if not SnapBackDB.initialized then
		SnapBackDB.debugEnabled = false
		SnapBack.Title = "SnapBack"
		SnapBack.Version = "1.0.0"
		SnapBack.Author = "Mosey"
		SnapBack.Description = "An addon to manage and restore UI layouts."
		SnapBackDB.initialized = true
	end
	
	SnapBack.debugEnabled = SnapBackDB.debugEnabled or false

	-- Register slash commands after SavedVariables are ready
	SLASH_SNAPBACK1 = "/snapback"
	SlashCmdList["SNAPBACK"] = function(msg)
		local cmd, arg = msg:match("^(%S+)%s*(.*)$")
		cmd = cmd and cmd:lower()

		if cmd == "debug" then
			debugCommand(arg)
		elseif cmd == "list" then
			listCommand()
		elseif cmd == "status" then
			statusCommand()
		elseif cmd == "about" then
			aboutCommand()
		elseif cmd == "help" then
			helpCommand()
		else
			SnapBack.PrintError("Unknown command %s", cmd or "nil")
			SnapBack.PrintError(" Type \'/snapback help\' for a list of commands.")
		end
	end
	SnapBack.PrintDebug("end onAddonLoaded")
end

local function onPlayerEnteringWorld()
	SnapBack.PrintDebug("begin onPLayerEnteringWorld")
	SnapBack.PrintDebug("Debug is %s (SnapBack.debugEnabled), Saved as %s (SnapBackDB.debugEnabled)", tostring(SnapBack.debugEnabled), tostring(SnapBackDB and SnapBackDB.debugEnabled))
	SnapBack.PrintDebug("runDebug is", type(SnapBack.runDebug))

	C_Timer.After(0.05, function()
		EditModeManagerFrame:Show()
		C_Timer.After(0.01, function()
			local ok, err = pcall(function()
					EditModeManagerFrame:Hide()
				end)
			if not ok then
				SnapBack.PrintError(err)
			end
			SnapBack.PrintInfo("Initialize Complete")
		end)
	end)
	SnapBack.PrintDebug("end onPLayerEnteringWorld")
end

local function runCoreLogic()
    local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self, event, arg1)
        if event == "ADDON_LOADED" and arg1 == "SnapBack" then
			onAddonLoaded()
		elseif event == "PLAYER_ENTERING_WORLD" then
			onPlayerEnteringWorld()
		else
		end
    end)
end

local function safeStart()
    local success, err = pcall(runCoreLogic)
    if not success then
        SnapBack.PrintError("safeStart() Error: %s", tostring(err))
    end
    
end

safeStart()
