--- @description Command to toggle the minimap
RegisterCommand('toggleminimap', function()
    Config.ShowMinimapAlways = not Config.ShowMinimapAlways
    DisplayMinimap(Config.ShowMinimapAlways)
end, false)

RegisterCommand('updatemugshot', function()
    TakePlayerMugshot()
end, false)

--- @description Command to enter HUD edit mode
RegisterCommand('editmode', function()
    ToggleHudEditMode()
end, false)

--- @description Command to reset HUD positions
RegisterCommand('resethud', function()
    ResetHudPositions()
    print("HUD Positions have now been reset to defaults!")
end, false)