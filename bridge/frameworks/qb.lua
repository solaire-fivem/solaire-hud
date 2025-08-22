if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerLoaded = true
    CreateMinimap()
    GetPlayerName()
    SendIconConfigs()
    SendReactMessage('setVisible', true)
    Wait(1000) -- Wait a moment to ensure NUI is fully loaded before taking player mugshot (Avoids an issue where Michael is shown instead of the player)
    TakePlayerMugshot()
    print("QBCore: Player has loaded")
end)

--- @return table 
--- @description Retrieves the player's status using QBCore's functions for hunger, thirst and stress
function RetrievePlayerStatusFromFramework()
    local player = QBCore.Functions.GetPlayerData()
    if player and player.metadata then 
        return {
            hunger = player.metadata.hunger,
            thirst = player.metadata.thirst,
            stress = player.metadata.stress,
        }
    end

    return { hunger = 0, thirst = 0, stress = 0, }
end
