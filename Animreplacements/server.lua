if GetResourceState("es_extended") == "started" then
    local ESX = exports["es_extended"]:getSharedObject()
    function GetJob(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return "unemployed" end
        return xPlayer.job.name
    end

    function GetName(source)
        return ESX.GetPlayerFromId(source).name
    end

    AddEventHandler("esx:playerLoaded", function(player, xPlayer, isNew)
        if not xPlayer.job.name then return end

        if xPlayer.job.name == "police" then
            Player(player).state:set('WeaponAnim', true, true)
        end
    end)
else
    function GetJob(source)
        return 'unemployed'
    end
end

CreateThread(function ()
    Wait(200)
    for _, player in pairs(GetPlayers()) do
        local police = GetJob(player) == "police"
        -- Player(player).state:set("WeaponAnim", nil, true) --[[ uncomment for testing as it won't trigger client side if the value doesn't change ]]
        Player(player).state:set("WeaponAnim", police, true)
    end
end)

AddStateBagChangeHandler('WeaponAnim', nil, function(bagName, key, value, reserved, replicated)
    print(("^5WeaponAnim^7 was updated for: ^4%s^7"):format(bagName), key, value, reserved, replicated)
end)