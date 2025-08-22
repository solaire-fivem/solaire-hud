DisplayRadar(false)

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  CreateThread(function()
    while true do
      Wait(650)
      UpdatePlayerStatus()
      UpdateVehicleHud()
    end
  end)
end)