--- @return nil
--- @description Updates the player's stats and sends them to the NUI frame
function UpdatePlayerStatus()
    if Bridge.Framework.GetIsPlayerDead() then
      SendReactMessage('setPlayerDead', true)
    else
      SendReactMessage('setPlayerDead', false)
    end

    local ped = PlayerPedId()
    local health = GetEntityHealth(ped) - 100
    local armor = GetPedArmour(ped)
    local stamina = math.floor(GetPlayerStamina(PlayerId()))
    local hunger = Bridge.Framework.GetPlayerMetaData('hunger')
    local thirst = Bridge.Framework.GetPlayerMetaData('thirst')
    local stress = Bridge.Framework.GetPlayerMetaData('stress')
    local oxygenPercent = 100

    if IsPedSwimmingUnderWater(ped) then
      oxygenPercent = CalculateUnderwaterOxygen()
    else
      oxygenPercent = 100
    end

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
      hunger = hunger,
      thirst = thirst,
      stress = stress,
      oxygen = oxygenPercent,
    }

    SendReactMessage('updatePlayerStats', playerStatus)
end

--- @return number
--- @description Calculates oxygen percentage while the player is underwater
function CalculateUnderwaterOxygen()
  local maxUnderwaterTime = 10.0
  local underwaterTime = GetPlayerUnderwaterTimeRemaining(PlayerId())
  if underwaterTime > 0 then
    return math.floor((underwaterTime / maxUnderwaterTime) * 100)
  end
  return 0
end

--- @return nil
--- @description Gets the player's full name and sends it to the NUI frame
function GetPlayerName()
  local firstName, lastName = Bridge.Framework.GetPlayerName()
  local playerName = firstName .. " " .. lastName
  if playerName then
    SendReactMessage('setPlayerName', playerName)
  else
    print("Could not get player name")
  end
end

--- @return nil
--- @description Takes a mugshot of the player and sends it to the NUI frame
function TakePlayerMugshot()
  local mugShot = exports["MugShotBase64"]:GetMugShotBase64(PlayerPedId(), false)

  if mugShot and mugShot ~= "" then
    SendReactMessage('setPlayerMugshot', mugShot)
  else
    print("Mugshot is empty, not sending to NUI")
  end
end