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
end)