--- @return nil
--- @description Sends the icon configurations from the config to the NUI frame
function SendIconConfigs()
  SendNUIMessage({ 
    action = 'setIcons',
    data = {
      healthIcon = Config.HealthBarIcon,
      deadIcon = Config.DeadIcon,
      staminaIcon = Config.StaminaBarIcon,
      foodIcon = Config.FoodBarIcon,
      waterIcon = Config.WaterBarIcon,
      stressIcon = Config.StressBarIcon,
      fuelIcon = Config.FuelIcon,
      seatbeltIcon = Config.SeatbeltIcon
    }
  })
end

--- @return nil
--- @description Gets the player's full name and sends it to the NUI frame
function GetPlayerName()
  local firstName, lastName = Bridge.Framework.GetPlayerName()
  local playerName = firstName .. " " .. lastName
  if playerName then
    SendNUIMessage({ action = 'setPlayerName', data = playerName })
  else
    Debug("Could not get player name")
  end
end

--- @return nil
--- @description Takes a mugshot of the player and sends it to the NUI frame
function TakePlayerMugshot()
  local mugShot = exports["MugShotBase64"]:GetMugShotBase64(PlayerPedId(), false)

  if mugShot and mugShot ~= "" then
    SendNUIMessage({ action = 'setPlayerMugshot', data = mugShot })
  else
    Debug("Mugshot is empty, not sending to NUI")
  end
end

--- @return nil
--- @description A wrapped for debug messages, only prints if config debug is true
function Debug(...)
    if not Config.Debug then return end
    local msg = '^2[DEBUG]:^0 '
    for i, v in pairs({ ... }) do
        if type(v) == 'table' then
            msg = msg .. json.encode(v) .. '\t'
        else
            msg = msg .. tostring(v) .. '\t'
        end
    end
    msg = msg
    print(msg)
end