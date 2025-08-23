DisplayRadar(false)

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  CreateThread(function()
    while true do
      Wait(500) -- Update every 500ms, feel free to configure this just be mindful lower numbers will decrease performance
      UpdatePlayerStatus()
      UpdateVehicleHud()
    end
  end)
end)