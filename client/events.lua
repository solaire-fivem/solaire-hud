--- @type boolean Flag used to detect if we have created the cache already
local cacheCreated = false

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
  Debug("Using framework:", Bridge.Framework.GetFrameworkName())
  CreateMinimap()
  GetPlayerName()
  SendIconConfigs()
  SendSavedPositions()
  TakePlayerMugshot()
  SendNUIMessage({ action = 'setVisible', data = true })

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
  SendNUIMessage({ action = 'setVisible', data = false })
  DisplayMinimap(false)
end)

-- Framework events to listen for hunger and thirst for the big 3 frameworks
-- ESX
RegisterNetEvent('esx_status:onTick', function(statuses)
  for _, status in pairs(statuses) do
    if status.name == 'hunger' then
      HUNGER = status.percent
    elseif status.name == 'thirst' then
      THIRST = status.percent
    end
  end

  Debug("'esx_status:onTick' Returned: Hunger:", HUNGER, "Thirst:", THIRST)
  SendNUIMessage({ action = 'updateNeeds', data = { hunger = HUNGER, thirst = THIRST } })
end)

-- QBCore / QBox
RegisterNetEvent('hud:client:UpdateNeeds', function(hunger, thirst)
  Debug("'hud:client:UpdateNeeds' Needs updated called: Hunger:", hunger, "Thirst:", thirst)
  HUNGER = hunger
  THIRST = thirst

  -- Hunger goes all the way to 120 in qb-core so we need to cap it at 100
  if HUNGER > 100 then HUNGER = 100 end
  if THIRST > 100 then THIRST = 100 end

  SendNUIMessage({ action = 'updateNeeds', data = { hunger = HUNGER, thirst = THIRST } })
end)