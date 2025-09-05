---@param vehicle integer
---@return integer
---@description Gets the current speed of the vehicle, change the speed measurement in the config if needed
local function GetVehicleSpeed(vehicle)
  local speed = GetEntitySpeed(vehicle)

  if Config.SpeedMeasurement == 'mph' then
      return math.floor(speed * 2.236936)
  elseif Config.SpeedMeasurement == 'kph' then
      return math.floor(speed * 3.6)
  else
      Debug("Unsupported speed measurement in config.lua, defaulting to mph")
      return math.floor(speed * 2.236936)
  end
end

--- @return boolean
--- @description Gets the current seatbelt state
local function GetSeatbeltState()
  if Bridge.Framework.GetFrameworkName() == "qbx_core" then
      return (LocalPlayer.state.seatbelt or false) or (LocalPlayer.state.harness or false)
  elseif Bridge.Framework.GetFrameworkName() == "es_extended" then
      return exports.esx_cruisecontrol:isSeatbeltOn()
  elseif Bridge.Framework.GetFrameworkName() == "qb-core" then
      return exports["qb-smallresources"]:HasSeatbeltOn() or exports["qb-smallresources"]:HasHarness()
  end

  return LocalPlayer.state.seatbelt or false
end

--- @return nil
--- @description Updates the vehicle HUD with minimap, street name, and current time
function UpdateVehicleHud()
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  local inVehicle = vehicle and vehicle ~= 0
  local speedUnit = (Config.SpeedMeasurement == 'kph' and 'KPH') or 'MPH'

  if inVehicle then
    local currentFuel = Bridge.Fuel.GetFuel(vehicle)
    local seatbeltState = GetSeatbeltState()
    local vehicleSpeed = GetVehicleSpeed(vehicle)

    if not Config.ShowMinimapAlways then -- If they have this off then we want to show the minimap when entering a vehicle
      DisplayMinimap(true)
    end
    SendNUIMessage({ action = 'updateVehicleHud', data = {
      vehicleFuel = currentFuel,
      seatbelt = seatbeltState,
      vehicleSpeed = vehicleSpeed,
      inVehicle = true,
      speedUnit = speedUnit,
    }})
  else
    if not Config.ShowMinimapAlways then -- If they have this off then we want to hide the minimap on vehicle exit
      DisplayMinimap(false)
    end
    SendNUIMessage({ action = 'updateVehicleHud', data = { inVehicle = false } })
  end
end