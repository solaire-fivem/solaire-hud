DisplayRadar(false)

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  CreateThread(function()
    while true do
      Wait(600) -- Update every 600ms, feel free to configure this just be mindful lower numbers will decrease performance
      UpdatePlayerStatus()
      UpdateVehicleHud()
    end
  end)
end)