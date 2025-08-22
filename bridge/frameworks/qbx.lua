if GetResourceState('qbx_core') ~= 'started' then return end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerLoaded = true
    CreateMinimap()
    GetPlayerName()
    SendIconConfigs()
    SendReactMessage('setVisible', true)
    Wait(1000) -- Wait a moment to ensure NUI is fully loaded before taking player mugshot (Avoids an issue where Michael is shown instead of the player)
    TakePlayerMugshot()
    print("QBOX: Player has loaded in")
end)

--- @return table 
--- @description Retrieves the player's status using QBX's export for hunger, thirst and stress
function RetrievePlayerStatusFromFramework()
    local playerData = exports.qbx_core:GetPlayerData()

    if playerData then
        return {
            hunger = playerData.metadata.hunger,
            thirst = playerData.metadata.thirst,
            stress = playerData.metadata.stress,
        }
    end

    return { hunger = 0, thirst = 0, stress = 0, }
end
