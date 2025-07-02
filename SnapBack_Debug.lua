local function debugLayoutDump()
    if not (SnapBack and SnapBack.debugEnabled) then
        print("|cffffcc00SnapBack Debug:|r Debug is not enabled.")
        return
    end

    local success, err = pcall(function()
        print("|cffffcc00SnapBack Debug:|r Debug Start")
        local data = C_EditMode.GetLayouts()
        local layouts = data and data.layouts

        if layouts and #layouts > 0 then
            print("|cffffcc00SnapBack Debug:|r Dumping layout data...")
            for i, layout in ipairs(layouts) do
                print(string.format("  [%d] Name: %s | ID: %s", i, layout.layoutName or "nil", tostring(layout.systems)))
            end

            for i, layout in ipairs(layouts) do
                print(string.format("  [%d] Layout entry:", i))
                for key, value in pairs(layout) do
                    print(string.format("    %s = %s", tostring(key), tostring(value)))
                end
            end

        else
            print("|cffffcc00SnapBack Debug:|r No layout data available.")
        end

        print("|cffffcc00SnapBack Debug:|r Debug Finish")
    end)

    if not success then
        print("|cffff0000SnapBack Debug Error:|r", tostring(err))
    end
end

SnapBack = SnapBack or {}
SnapBack.runDebug = debugLayoutDump