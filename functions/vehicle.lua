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

    if not Config.ShowMinimapAlways then -- If they have this off then we want to show the minimap when entering a vehicle
      DisplayMinimap(true)
    end
    SendReactMessage('updateVehicleHud', {
      vehicleFuel = currentFuel,
      seatbelt = seatbeltState,
      vehicleSpeed = vehicleSpeed,
      inVehicle = true,
      speedUnit = speedUnit,
    })
  else
    if not Config.ShowMinimapAlways then -- If they have this off then we want to hide the minimap on vehicle exit
      DisplayMinimap(false)
    end
    SendReactMessage('updateVehicleHud', { inVehicle = false })
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