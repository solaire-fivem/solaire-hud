--- @description Command to toggle the minimap
RegisterCommand('toggleminimap', function()
    Config.ShowMinimapAlways = not Config.ShowMinimapAlways
    DisplayMinimap(Config.ShowMinimapAlways)
end, false)

--- @description Command to update the player's mugshot
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
end, false)


RegisterCommand('charactersheet', function()
    if CharacterSheetOpen then
        CloseCharacterSheet()
        CharacterSheetOpen = false
    else
        DisplayCharacterSheet()
        CharacterSheetOpen = true
    end
end, false)

RegisterKeyMapping('charactersheet', 'Open/Close Character Sheet', 'keyboard', Config.OpenCharacterSheet)