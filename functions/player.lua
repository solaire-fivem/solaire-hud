--- @return number
--- @description Calculates oxygen percentage while the player is underwater
local function CalculateUnderwaterOxygen()
  local underwaterTime = GetPlayerUnderwaterTimeRemaining(PlayerId())
  if underwaterTime < 0 then return 0 end

  local maxUnderwaterTime = 10.0
  return math.floor((underwaterTime / maxUnderwaterTime) * 100)
end

--- @return nil
--- @description Updates the player's stats and sends them to the NUI frame
function UpdatePlayerStatus()
    if Bridge.Framework.GetIsPlayerDead() then SendNUIMessage({'setPlayerDead', true}) return end

    SendNUIMessage({'setPlayerDead', false})
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped) - 100
    local armor = GetPedArmour(ped)
    local stamina = math.floor(GetPlayerStamina(PlayerId()))
    local stress = Bridge.Framework.GetPlayerMetaData('stress') or 0
    local oxygenPercent = 100

    if IsPedSwimmingUnderWater(ped) then oxygenPercent = CalculateUnderwaterOxygen() end

    if Config.ShowMinimapAlways then -- If the player has enabled the minimap we want to show it and update it every frame
        DisplayMinimap(true)
    else -- Otherwise we want it hidden and not update every frame
        DisplayMinimap(false)
    end

    --- @type table
    --- @description Table containing the player's current status
    local playerStatus = {
      health = health,
      armor = armor,
      stamina = stamina,
      stress = stress,
      oxygen = oxygenPercent,
    }

    SendNUIMessage({ action = 'updatePlayerStats', data = playerStatus })
end