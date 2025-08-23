--- @type boolean Flag used to detect if we have created the cache already
local cacheCreated = false

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  CreateMinimap()
  GetPlayerName()
  SendIconConfigs()
  SendSavedPositions()
  SendReactMessage('setVisible', true)
  TakePlayerMugshot()

  if cacheCreated then
    return
  end

  cacheCreated = true

  Bridge.Cache.Create("playerAppearance", function()
    return Bridge.Clothing.GetAppearance(PlayerPedId())
  end, 10000) -- Check every 10 seconds for a change in player appearance
  
  Bridge.Cache.OnChange('playerAppearance', function() -- When we detect a change update the mugshot take the player mugshot again
    TakePlayerMugshot()
  end)

end)

RegisterNUICallback('savePositions', function(data, cb)
  SaveHudPositions(data)
  cb('ok')
end)

RegisterNUICallback('closeEditMode', function(data, cb)
  ToggleHudEditMode()
  cb('ok')
end)

RegisterNUICallback('resetPositions', function(data, cb)
  ResetHudPositions()
  cb('ok')
end)