--- @return nil
--- @param invisible boolean
--- @description Sets the player's ped invisible or visible with a fade effect
local function setPlayerInvisible(invisible)
    local playerPed = PlayerPedId()
    SetEntityCollision(playerPed, not invisible, not invisible)
    FreezeEntityPosition(playerPed, invisible)
    local step = 15
    local waitTime = 15
    if invisible then
        local alpha = GetEntityAlpha(playerPed)
        while alpha > 0 do
            alpha = math.max(alpha - step, 0)
            SetEntityAlpha(playerPed, alpha, false)
            Wait(waitTime)
        end
        SetEntityVisible(playerPed, false, false)
    else
        SetEntityVisible(playerPed, true, false)
        local alpha = GetEntityAlpha(playerPed)
        while alpha < 255 do
            alpha = math.min(alpha + step, 255)
            SetEntityAlpha(playerPed, alpha, false)
            Wait(waitTime)
        end
        SetEntityAlpha(playerPed, 255, false)
    end
end

--- @return nil
--- @description Pauses the game and display's the player's ped
function DisplayCharacterSheet()
    -- To avoid camera issues let's not allow player's to do this when they are dead
    if Bridge.Framework.GetIsPlayerDead() then return end

    -- Make player invisible and wait for fade to finish
    setPlayerInvisible(true)

    -- Now enable the pause menu and hide all of our HUD components
    SetFrontendActive(true)
    SendReactMessage('characterSheetVisible', true)
    SendReactMessage('updateNeeds', { hunger = HUNGER, thirst = THIRST })

    GetPlayerName()

    -- Blur
    SetTimecycleModifier("hud_def_blur")
    SetTimecycleModifierStrength(1.0)

    local hashMenu = GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND")
    ActivateFrontendMenu(hashMenu, false, -1)
    ReplaceHudColourWithRgba(117, 0, 0, 0, 0)

    local playerPed = PlayerPedId()
    local clonedPed = ClonePed(playerPed, false, false, false)
    local clonedCoords = GetEntityCoords(clonedPed)

    SetEntityCoords(clonedPed, clonedCoords.x, clonedCoords.y, clonedCoords.z - 1, false, false, false, true)
    FreezeEntityPosition(clonedPed, true)
    SetEntityVisible(clonedPed, false, false)
    NetworkSetEntityInvisibleToNetwork(clonedPed, false)

    Wait(100)

    SetPedAsNoLongerNeeded(clonedPed)
    SetEntityAlpha(PlayerPedId(), 0, false) -- This is the best way I have found to do this
    GivePedToPauseMenu(clonedPed, 1)
    SetPauseMenuPedLighting(true)
    SetPauseMenuPedSleepState(true)
end

--- @return nil
--- @description Closes the character sheet, removes blur and shows the hud again
function CloseCharacterSheet()
    setPlayerInvisible(false)
    ReplaceHudColourWithRgba(117, 0, 0, 0, 183)
    SetFrontendActive(false)
    ClearTimecycleModifier()
    SendReactMessage('characterSheetVisible', false)
    TakePlayerMugshot()
    GetPlayerName()
    SendReactMessage('updateNeeds', { hunger = HUNGER, thirst = THIRST })
end