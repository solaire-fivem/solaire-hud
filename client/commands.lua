RegisterCommand('toggleminimap', function()
    Config.ShowMinimapAlways = not Config.ShowMinimapAlways
    DisplayMinimap(Config.ShowMinimapAlways)
end, false)