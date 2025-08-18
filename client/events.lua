local Bridge = exports['community_bridge']:Bridge()
local cacheCreated = false

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  ToggleMinimap()

  if Config.ShowMinimapAlways then
    SendReactMessage('displayMinimap', true)
    DisplayRadar(true)
  else
    SendReactMessage('displayMinimap', false)
    DisplayRadar(false)
  end

  GetPlayerName()
  SendReactMessage('setVisible', true)
  SendIconConfigs()
  Wait(1000) -- Wait a moment to ensure NUI is fully loaded before taking player mugshot (Avoids an issue where Michael is shown instead of the player)
  TakePlayerMugshot()

  if cacheCreated then
    return
  end

  cacheCreated = true

  Bridge.Cache.Create( -- Create the cache for the player appearance
    "appearance",
    function()
      return Bridge.Clothing.GetAppearance(PlayerPedId())
    end,
    2000 -- Check every 2 seconds
  )

  Bridge.Cache.OnChange('appearance', function() -- When we detect a change update the mugshot
    TakePlayerMugshot()
  end)

end)
