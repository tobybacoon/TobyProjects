AddStateBagChangeHandler('WeaponAnim', nil, function(bagName, key, value, reserved, replicated)
    local prefix, id = bagName:match("^(.-):(%d+)$")
    if prefix == "player" then
        local playerIdx = GetPlayerFromServerId(tonumber(id) --[[ @as integer ]])
        local playerped = GetPlayerPed(playerIdx)


        --[[ Debug code to show which peds are affected by the override ]]
        -- if value then
        --     CreateThread(function ()
        --         local ti = GetGameTimer() + 1000 * 60
        --         while GetGameTimer() < ti do
        --             local coords = GetEntityCoords(playerped)
        --             DrawMarker(2, coords.x, coords.y, coords.z + 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, -0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)
        --             Wait(0)
        --         end
        --     end)
        -- end

        SetWeaponAnimationOverride(playerped, value and "customanim" or `Default`)
        print(('Updated animation override for ^4%s^7'):format(bagName), value and "customanim" or "Default", playerIdx, id)
    end
end)


print(('Registered client.lua - playerId: %d'):format(GetPlayerServerId(PlayerId())), PlayerId())