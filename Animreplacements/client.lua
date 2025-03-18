local Framework = nil
local hasChecked = false

CreateThread(function()
    Wait(1000)

    if GetResourceState("es_extended") == "started" then
        Framework = "ESX"
        ESX = exports["es_extended"]:getSharedObject()
    elseif GetResourceState("qb-core") == "started" then
        Framework = "QB"
        QBCore = exports["qb-core"]:GetCoreObject()
    else
        Framework = "CUSTOM" 

    end
end)


function IsPlayerCop()
    if Framework == "ESX" then
        local xPlayer = ESX.GetPlayerData()
        if xPlayer and xPlayer.job then
            print("[DEBUG] ESX Job: " .. xPlayer.job.name)
            return xPlayer.job.name == "police"
        end

    elseif Framework == "QB" then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData and PlayerData.job then
            return PlayerData.job.name == "police"
        end

    elseif Framework == "CUSTOM" then
        

    end

    return false
end


function CheckAndApplyAnimation()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        if IsPlayerCop() then
            SetWeaponAnimationOverride(playerPed, "customanim")
            TriggerServerEvent("syncWeaponAnimation", "customanim")
        else
            SetWeaponAnimationOverride(playerPed, nil)
            TriggerServerEvent("syncWeaponAnimation", nil)
        end
    end
end

CreateThread(function()
    while true do
        Wait(60000) 
        CheckAndApplyAnimation()
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        local playerPed = PlayerPedId()
        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            print("[DEBUG] Player ped detected, running initial check.")
            CheckAndApplyAnimation()
            break
        else
            print("[DEBUG] Waiting for player ped to load...")
        end
    end
end)

RegisterNetEvent("playerSpawned")
AddEventHandler("playerSpawned", function()
    print("[DEBUG] Player spawned, running animation check.")
    CheckAndApplyAnimation()
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    print("[DEBUG] QB-Core player loaded, running animation check.")
    CheckAndApplyAnimation()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    print("[DEBUG] ESX player loaded, running animation check.")
    CheckAndApplyAnimation()
end)

RegisterNetEvent("applyWeaponAnimation")
AddEventHandler("applyWeaponAnimation", function(targetPlayer, animStyle)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayer))
    if targetPed and DoesEntityExist(targetPed) then

        SetWeaponAnimationOverride(targetPed, animStyle)
    end
end)
