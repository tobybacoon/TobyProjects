RegisterNetEvent("syncWeaponAnimation")
AddEventHandler("syncWeaponAnimation", function(animStyle)
    local sourcePlayer = source
    TriggerClientEvent("applyWeaponAnimation", -1, sourcePlayer, animStyle)
end)
