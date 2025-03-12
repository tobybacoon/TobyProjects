AddStateBagChangeHandler('vehicleData', nil, function(bagName, key, value, _reserved, replicated)
    if not value then return end
    local veh = GetEntityFromStateBagName(bagName)
    SetNetworkIdCanMigrate(veh, true)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleEngineHealth(veh, value.engine + 0.0)
    SetVehicleBodyHealth(veh, value.body + 0.0)
    SetVehicleNumberPlateText(veh, value.plate)
    SetVehicleColours(veh, value.color[1], value.color[2])
    Wait(100)
    if value.debug then
        local enginehealth = GetVehicleEngineHealth(veh)
        local bodyhealth = GetVehicleBodyHealth(veh)
        print('Engine Health: ' .. enginehealth)
        print('Body Health: ' .. bodyhealth)
        print(json.encode(value, {indent = true}))
    end
end)