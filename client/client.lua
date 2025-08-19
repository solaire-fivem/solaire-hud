DisplayRadar(false)

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  CreateThread(function()
    while true do
      Wait(500)
      UpdatePlayerStatus()
      UpdateVehicleHud()
    end
  end)
end)