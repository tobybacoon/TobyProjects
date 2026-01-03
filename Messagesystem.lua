local QBCore = exports['qb-core']:GetCoreObject()


local jobColors = {
    police = {r = 0, g = 0, b = 255},-- Blue
    marshals = {r = 210, g = 180, b = 140}, -- Tan
    ambulance = {r = 255, g = 0, b = 0},-- Red
    medical = {r = 0, g = 128, b = 0}, -- Green
    sacl = {r = 220, g = 20, b = 60},-- Crimson Red
    doj = {r = 255, g = 215, b = 0}-- Gold
}

local allowedJobs = {
    ["police"] = true,
    ["marshals"] = true,
    ["ambulance"] = true,
    ["medical"] = true,
    ["sacl"] = true,
    ["doj"] = true
}

local jobNicknames = {
    ["sasp"] = "police",
    ["marshals"] = "marshals",
    ["safr"] = "ambulance",
    ["saha"] = "medical",
    ["sacl"] = "sacl",
    ["doj"] = "doj"
}

local readableNames = {
    ["police"] = "SASP",
    ["marshals"] = "Marshals",
    ["ambulance"] = "SAFR",
    ["medical"] = "SAHA",
    ["sacl"] = "SACL",
    ["doj"] = "DOJ"
}

local function sendMessage(playerId, message, job)
    TriggerClientEvent('chatMessage', playerId, '', 'mdt_'..job, message)
end


QBCore.Commands.Add("mdt", "Send an MDT message to your colleagues or open the MDT.", {{name="target", help="Callsign, Nickname, Job Name, or 'all'. Leave blank to open MDT"}, {name="message", help="Message to send. Leave blank to open MDT"}}, false, function(source, args, rawCommand)    
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    local job = Player.PlayerData.job.name
    local input = rawCommand:sub(5):gsub("^%s+", "")
    local target, message = input:match("^(%S+)%s*(.*)")
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local callsign = Player.PlayerData.metadata.callsign
    local targetJobName = jobNicknames[target]
    local finalMessage
    local player = exports.qbx_core:GetPlayer(src)
    local playerDutyStatus = player.PlayerData.job.onduty

    if not jobColors[job] then
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "You are not authorized to use this command"})
        return
    end

    if input == "" then
        TriggerClientEvent('mdt:client:Tablet', source)
         return
    end

    
    if input == "" and not playerDutyStatus then
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "You are not on duty!"})
    end

    if targetJobName then
        local readableName = readableNames[targetJobName]

        finalMessage = string.format("DIRECT TO %s | %s.%s (%s) | %s", readableName, firstname:upper():sub(1, 1), lastname:upper(), callsign, message)

        local players = QBCore.Functions.GetPlayers()
        local messageSent = false
        for _, playerId in ipairs(players) do
            local targetPlayer = QBCore.Functions.GetPlayer(playerId)
            local targetJob = targetPlayer.PlayerData.job.name

            if targetJob == targetJobName and playerDutyStatus then
                sendMessage(playerId, finalMessage, job)
                messageSent = true
            end
        end

        sendMessage(src, finalMessage, job)

        if not messageSent then
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "No players with that job found"})
        end
    elseif target == "all" then
        finalMessage = string.format("%s.%s (%s) | %s", firstname:upper():sub(1, 1), lastname:upper(), callsign, message)
        local players = QBCore.Functions.GetPlayers()
        local messageSent = false
        for _, playerId in ipairs(players) do
            local targetPlayer = QBCore.Functions.GetPlayer(playerId)
            local targetJob = targetPlayer.PlayerData.job.name

            if allowedJobs[targetJob] and playerDutyStatus then
                sendMessage(playerId, finalMessage, job)
                messageSent = true
            end
        end
        if not messageSent then
            sendMessage(src, finalMessage, job)
        end
    else
        local players = QBCore.Functions.GetPlayers()
        local found = false
        for _, playerId in ipairs(players) do
            local targetPlayer = QBCore.Functions.GetPlayer(playerId)
            if targetPlayer.PlayerData.metadata.callsign == target and playerDutyStatus then
                finalMessage = string.format("%s.%s (%s) To %s.%s (%s) | %s", firstname:upper():sub(1, 1), lastname:upper(), callsign, targetPlayer.PlayerData.charinfo.firstname:upper():sub(1, 1), targetPlayer.PlayerData.charinfo.lastname:upper(), targetPlayer.PlayerData.metadata.callsign, message)
                sendMessage(playerId, finalMessage, job)
                sendMessage(src, finalMessage, job)
                found = true
                break
            end
        end

        if not found then
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Player with that callsign not found"})
        end
    end
end)
