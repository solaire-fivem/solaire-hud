local hunger = 0
local thirst = 0
local stress = 0

--- @return table
--- @description Retrieves the player's hunger, thirst and stress
local function RetrieveFrameworkValues()
    if ESX then
      TriggerEvent("esx_status:getStatus", 'hunger', function(status) hunger = (status.val / 1000000) * 100 end)
      TriggerEvent("esx_status:getStatus", 'thirst', function(status) thirst = (status.val / 1000000) * 100 end)
      return { hunger = hunger, thirst = thirst, stress = 0 }
    else
      hunger = Bridge.Framework.GetPlayerMetaData('hunger')
      thirst = Bridge.Framework.GetPlayerMetaData('thirst')
      stress = Bridge.Framework.GetPlayerMetaData('stress')
      return { hunger = hunger, thirst = thirst, stress = stress}
    end
end

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
    if Bridge.Framework.GetIsPlayerDead() then SendReactMessage('setPlayerDead', true) return end
      
    SendReactMessage('setPlayerDead', false)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped) - 100
    local armor = GetPedArmour(ped)
    local stamina = math.floor(GetPlayerStamina(PlayerId()))
    local frameworkValues = RetrieveFrameworkValues()

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
      hunger = frameworkValues.hunger,
      thirst = frameworkValues.thirst,
      stress = frameworkValues.stress,
      oxygen = oxygenPercent,
    }

    SendReactMessage('updatePlayerStats', playerStatus)
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