--- @return string
--- @description Gets the street name at the player's current coordinates
local function GetStreetName()
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  local streetCoords = GetStreetNameAtCoord(coords.x, coords.y, coords.z)

  return GetStreetNameFromHashKey(streetCoords)
end

--- @return string
--- @description Gets the current time in HH:MM formatted with AM/PM
local function GetCurrentTime()
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
function CreateMinimap()
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

--- @param display boolean true or false
--- @description Shows or hides the minimap and clears street/time if hiding
function DisplayMinimap(display)
  if display then
    DisplayRadar(true)
    SendReactMessage('displayMinimap', { displayMinimap=true, streetName=GetStreetName(), currentTime=GetCurrentTime() })
  else
    DisplayRadar(false)
    SendReactMessage('displayMinimap', { displayMinimap=false, streetName="", currentTime="" })
  end
end