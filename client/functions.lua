local Bridge = exports['community_bridge']:Bridge()

--- @return nil
--- @description Updates the player's stats and sends them to the NUI frame
function UpdatePlayerStatus()
    if Bridge.Framework.GetIsPlayerDead() then
      SendReactMessage('setPlayerDead', true)
    else
      -- Undo death state if the player is not dead
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
      local maxUnderwaterTime = 10.0
      local underwaterTime = GetPlayerUnderwaterTimeRemaining(PlayerId())
      if underwaterTime > 0 then
        oxygenPercent = math.floor((underwaterTime / maxUnderwaterTime) * 100)
      else
        oxygenPercent = 0
      end
    else
      oxygenPercent = 100
    end

    if Config.ShowMinimapAlways then
        ToggleMinimapVisibility('show')
    end

    local playerStats = {
      health = health,
      armor = armor,
      stamina = stamina,
      hunger = hunger,
      thirst = thirst,
      stress = stress,
      oxygen = oxygenPercent,
    }

    SendReactMessage('updatePlayerStats', playerStats)
end

--- @return nil
--- @description Updates the vehicle HUD with minimap, street name, and current time
function UpdateVehicleHud()
  local ped = PlayerPedId()
  local veh = GetVehiclePedIsIn(ped, false)
  local inVehicle = veh and veh ~= 0
  local speedUnit = (Config.SpeedMeasurement == 'kph' and 'KPH') or 'MPH'

  if inVehicle then
    local currentFuel = GetFuel()
    local seatbeltState = GetSeatbeltState()
    local vehicleSpeed = GetVehicleSpeed(veh)

    if not Config.ShowMinimapAlways then
      ToggleMinimapVisibility('show')
    end
    SendReactMessage('updateVehicleHud', {
      vehicleFuel = currentFuel,
      seatbelt = seatbeltState,
      vehicleSpeed = vehicleSpeed,
      inVehicle = true,
      speedUnit = speedUnit,
    })
  else
    if not Config.ShowMinimapAlways then
      ToggleMinimapVisibility('hide')
    end
    SendReactMessage('updateVehicleHud', { inVehicle = false })
  end
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

--- @return string
--- @description Gets the street name at the player's current coordinates
function GetStreetName()
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  local streetCoords = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
  local streetName = GetStreetNameFromHashKey(streetCoords)

  return streetName
end

--- @return string
--- @description Gets the current time in HH:MM formatted with AM/PM
function GetCurrentTime()
  local hours = GetClockHours()
  local minutes = GetClockMinutes()

  -- Format hours to 12-hour format with AM/PM
  local ampm = "AM"
  if hours >= 12 then
    ampm = "PM"
    if hours > 12 then
      hours = hours - 12
    end
  end
  
  -- Handle midnight (0 hours)
  if hours == 0 then
    hours = 12
  end
  
  return string.format("%d:%02d %s", hours, minutes, ampm)
end

--- @return nil
--- @description Toggles the minimap with a custom texture and makes it circular
function ToggleMinimap()
    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0

    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    RequestStreamedTextureDict("circlemap", false)

    while not HasStreamedTextureDictLoaded("circlemap") do
        Wait(100)
    end

    SetMinimapClipType(0)
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")

    SetMinimapComponentPosition('minimap', 'L', 'B', -0.0100 + minimapOffset, -0.030, 0.180, 0.258)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.200 + minimapOffset, 0.0, 0.065, 0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.00 + minimapOffset, 0.015, 0.252, 0.338)

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetBigmapActive(true, false)
    SetMinimapClipType(1)

    local timeout = 0
    while true do
        SetBigmapActive(false, false)
        if timeout >= 1000 then
            break
        else
            timeout = timeout + 500
        end
        Wait(100)
    end
end

--- @return nil
--- @description Takes a mugshot of the player and sends it to the NUI frame
function TakePlayerMugshot()
  local mugShot = exports["MugShotBase64"]:GetMugShotBase64(PlayerPedId(), true)

  if mugShot and mugShot ~= "" then
    SendReactMessage('setPlayerMugshot', mugShot)
  else
    print("Mugshot is empty, not sending to NUI")
  end
end

---@param vehicle integer
---@return integer
---@description Gets the current speed of the vehicle, change the speed measurement in the config if needed
function GetVehicleSpeed(vehicle)
  local speed = GetEntitySpeed(vehicle)
  if Config.SpeedMeasurement == 'mph' then
      return math.floor(speed * 2.236936)
  elseif Config.SpeedMeasurement == 'kph' then
      return math.floor(speed * 3.6)
  else
      print("Unsupported speed measurement in config.lua, defaulting to mph")
      return math.floor(speed * 2.236936)
  end
end

--- @param action string ('show' or 'hide')
--- @description Shows or hides the minimap and clears street/time if hiding
function ToggleMinimapVisibility(action)
  if action == 'show' then
    local streetName = GetStreetName()
    local currentTime = GetCurrentTime()
    DisplayRadar(true)
    SendReactMessage('displayMinimap', { displayMinimap=true, streetName=streetName, currentTime=currentTime })
  elseif action == 'hide' then
    DisplayRadar(false)
    SendReactMessage('displayMinimap', { displayMinimap=false, streetName="", currentTime="" })
  end
end

--- @return number|nil
--- @description Gets the fuel level of the vehicle you are currently in
function GetFuel()
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if vehicle ~= 0 then
      local fuelLevel = math.floor(Bridge.Fuel.GetFuel(vehicle) + 0.5)
      return fuelLevel
  end
end

--- @description Toggles the seatbelt state
function ToggleSeatBelt()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        return
    elseif Bridge.Framework.GetFrameworkName() == "qbx_core" then
        return
    elseif Bridge.Framework.GetFrameworkName() == "es_extended" then
        return
    elseif Bridge.Framework.GetFrameworkName() == "qb-core" then
        return
    else
        print("Unsupported framework for seatbelt functionality")
    end
    
    local currentBelt = LocalPlayer.state.seatbelt or false
    local newBelt = not currentBelt

    LocalPlayer.state.seatbelt = newBelt

    if not newBelt then
        SetFlyThroughWindscreenParams(35.0, 40.0, 17.0, 2000.0)
        SetPedConfigFlag(PlayerPedId(), 32, true)
    else
        SetPedConfigFlag(PlayerPedId(), 32, false)
    end

    -- Play seatbelt sound
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, newBelt and "carbuckle" or "carunbuckle", 0.25)

    return newBelt
end

--- @return boolean
--- @description Gets the current seatbelt state
function GetSeatbeltState()
  if Bridge.Framework.GetFrameworkName() == "qbx_core" then
      return (LocalPlayer.state.seatbelt or false) or (LocalPlayer.state.harness or false)
  elseif Bridge.Framework.GetFrameworkName() == "es_extended" then
      return exports["esx_cruisecontrol"]:isSeatbeltOn()
  elseif Bridge.Framework.GetFrameworkName() == "qb-core" then
      return exports["qb-smallresources"]:HasSeatbeltOn() or exports["qb-smallresources"]:HasHarness()
  end

  return LocalPlayer.state.seatbelt or false
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