if GetResourceState('es_extended') ~= 'started' then return end

local status = {}

RegisterNetEvent("esx:playerLoaded", function()
    PlayerLoaded = true
    CreateMinimap()
    GetPlayerName()
    SendIconConfigs()
    SendReactMessage('setVisible', true)
    Wait(1000) -- Wait a moment to ensure NUI is fully loaded before taking player mugshot (Avoids an issue where Michael is shown instead of the player)
    TakePlayerMugshot()
    print("ESX: Player has loaded in")
end)

--- @return table 
--- @description Retrieves the player's status using ESX's functions for hunger, thirst and stress
RegisterNetEvent("esx_status:onTick",function(data)
    for i = 1, #data do
        if data[i].name == "hunger" then
            status.hunger = math.floor(data[i].percent)
        end

        if data[i].name == "thirst" then
            status.thirst = math.floor(data[i].percent)
        end
    end

    status.stress = 0 -- ESX does not have stress by default so we set it to 0
end)