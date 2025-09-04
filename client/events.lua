--- @type boolean Flag used to detect if we have created the cache already
local cacheCreated = false

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  Debug("Using framework:", Bridge.Framework.GetFrameworkName())
  CreateMinimap()
  GetPlayerName()
  SendIconConfigs()
  SendSavedPositions()
  SendReactMessage('setVisible', true)
  TakePlayerMugshot()

  if cacheCreated then return end

  cacheCreated = true

  Bridge.Cache.Create("playerAppearance", function()
    return Bridge.Clothing.GetAppearance(PlayerPedId())
  end, 10000) -- Check every 10 seconds for a change in player appearance

  Bridge.Cache.OnChange('playerAppearance', function() -- When we detect a change update the mugshot take the player mugshot again
    TakePlayerMugshot()
  end)
end)

RegisterNetEvent('community_bridge:Client:OnPlayerUnload', function()
  SendReactMessage('setVisible', false)
  DisplayMinimap(false)
end)

-- Framework events to listen for hunger and thirst for the big 3 frameworks
-- ESX
RegisterNetEvent('esx_status:onTick', function(statuses)
  local hunger, thirst = 0, 0
  for _, status in pairs(statuses) do
    if status.name == 'hunger' then
      hunger = status.percent
    elseif status.name == 'thirst' then
      thirst = status.percent
    end
  end

  Debug("'esx_status:onTick' Returned: Hunger:", hunger, "Thirst:", thirst)
  HUNGER = hunger
  THIRST = thirst
  SendReactMessage('updateNeeds', { hunger = hunger, thirst = thirst })
end)

-- QBCore / QBox
RegisterNetEvent('hud:client:UpdateNeeds', function(hunger, thirst)
  Debug("'hud:client:UpdateNeeds' Returned: Hunger:", hunger, "Thirst:", thirst)
  HUNGER = hunger
  THIRST = thirst
  SendReactMessage('updateNeeds', { hunger = hunger, thirst = thirst })
end)