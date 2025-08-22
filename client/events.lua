local cacheCreated = false

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  CreateMinimap()
  GetPlayerName()
  SendIconConfigs()
  SendReactMessage('setVisible', true)
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
    5000 -- Check every 5 seconds
  )

  Bridge.Cache.OnChange('appearance', function() -- When we detect a change update the mugshot
    TakePlayerMugshot()
  end)

end)