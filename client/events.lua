local cacheCreated = false

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
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