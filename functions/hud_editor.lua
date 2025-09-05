--- @type boolean 
local isEditMode = false

--- @return nil
--- @description Toggles HUD edit mode for repositioning components
function ToggleHudEditMode()
  isEditMode = not isEditMode

  if isEditMode then
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = 'setEditMode', data = { editMode = true } })
  else
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'setEditMode', data = { editMode = false } })
  end
end

--- @return nil
--- @description Saves HUD component positions to KVP
function SaveHudPositions(positions)
  SetResourceKvp('solaire-hud:positions', json.encode(positions))
end

--- @return table|nil
--- @description Loads HUD component positions from KVP
function LoadHudPositions()
  local savedPositions = GetResourceKvpString('solaire-hud:positions')
  if savedPositions then
    return json.decode(savedPositions)
  end
end

--- @return nil
--- @description Sends saved HUD positions to the NUI frame
function SendSavedPositions()
  local positions = LoadHudPositions()
  if positions then
    SendNUIMessage({ action = 'loadPositions', data = positions })
  end
end

--- @return nil
--- @description Resets HUD positions to default and clears KVP storage
function ResetHudPositions()
  DeleteResourceKvp('solaire-hud:positions')
  SendNUIMessage({ action = 'resetToDefaults', data = true })
end