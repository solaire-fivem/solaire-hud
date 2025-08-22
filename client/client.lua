DisplayRadar(false)

CreateThread(function()
    while not PlayerLoaded do
        Wait(500)
    end

    while true do
        UpdatePlayerStatus()
        UpdateVehicleHud()
        Wait(500) 
    end
end)