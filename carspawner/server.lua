RegisterCommand("car", function(source, args, rawCommand)
    local vehiclemodel = args[1]
    if vehiclemodel then
        spawncar(source, vehiclemodel)
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = { "[Server]", "You need to enter a model." }
        })
    end
end, false)


function spawncar(source, vehiclemodel)
    local model = GetHashKey(vehiclemodel)
    local playerPed = GetPlayerPed(source)
    local pos = GetEntityCoords(playerPed)
    local veh = CreateVehicle(model, pos.x, pos.y, pos.z, 0.0, true, false)
    while not DoesEntityExist(veh) do
        Citizen.Wait(50)
    end
    TaskWarpPedIntoVehicle(playerPed, veh, -1)
    local state = Entity(veh).state
    state.vehicleData = {
        id = netId,
        model = model,
        engine = 1000.0,
        body = 1000.0,
        color = {53, 103},
        plate = "ABC1234",
        debug = false
    }
end