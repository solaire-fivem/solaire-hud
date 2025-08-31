--- A simple wrapper around SendNUIMessage that you can use to
--- dispatch actions to the React frame.
---
---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

--- @return nil
--- @description Sends the icon configurations from the config to the NUI frame
function SendIconConfigs()
  SendReactMessage('setIcons', {
    healthIcon = Config.HealthBarIcon,
    deadIcon = Config.DeadIcon,
    staminaIcon = Config.StaminaBarIcon,
    foodIcon = Config.FoodBarIcon,
    waterIcon = Config.WaterBarIcon,
    stressIcon = Config.StressBarIcon,
    fuelIcon = Config.FuelIcon,
    seatbeltIcon = Config.SeatbeltIcon
  })
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