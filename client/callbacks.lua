RegisterNUICallback('savePositions', function(data, cb)
  SaveHudPositions(data)
  cb('ok')
end)

RegisterNUICallback('closeEditMode', function(data, cb)
  ToggleHudEditMode()
  cb('ok')
end)

RegisterNUICallback('resetPositions', function(data, cb)
  ResetHudPositions()
  cb('ok')
end)