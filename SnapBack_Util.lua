SnapBack = SnapBack or {}

function SnapBack.PrintInfo(msg, ...)
    print("|cff66ccff[SnapBack]:|r " .. string.format(msg, ...))
end

function SnapBack.PrintDebug(msg, ...)
    if not SnapBack then
        print("|cffffcc00[SnapBack Debug]:|r SnapBack is not initialized.")
        return
    end

    if SnapBack.debugEnabled then
        print("|cffffcc00[SnapBack Debug]:|r " .. string.format(msg, ...))
    end
end

function SnapBack.PrintError(msg, ...)
    print("|cffff0000[SnapBack Error]:|r " .. string.format(msg, ...))
end