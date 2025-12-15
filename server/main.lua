
lib.versionCheck("spectrumdevofficial/sd_combatlog")

CombatLog = {
    cache = {},
    instances = {},
}

local SetTimeout = SetTimeout
local GetPlayerPed = GetPlayerPed
local GetEntityCoords = GetEntityCoords
local GetPlayerName = GetPlayerName
local GetGameTimer = GetGameTimer

lib.addCommand(Config.Command, {
    help = locale("command_help"),
}, function(source, args, rawCommand)
    local curTime = GetGameTimer()
    local logsInRange = CombatLog:GetLogsInRange(source, curTime)

    local instance = CombatLog.instances[source]
    CombatLog.instances[source] = not instance and curTime
    if not instance then
        SetTimeout(Config.Display.Duration, function()
            if CombatLog.instances[source] ~= curTime then return end
            CombatLog.instances[source] = nil
        end)
    end

    TriggerClientEvent("sd_combatlog:displayLogs", source, logsInRange)
end)

function CombatLog:GetLogsInRange(source, curTime)
    curTime = curTime or GetGameTimer()

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    local logsInRange = {}
    for _, log in pairs(CombatLog.cache) do
        local distance = #(log.coords - playerCoords)
        if distance <= Config.Cache.Distance then
            logsInRange[log.id] = {
                id = log.id,
                coords = log.coords,
                elapsedTime = curTime - log.startTime,

                name = log.name,
                reason = log.reason,
                time = log.time,
            }
        end
    end

    return logsInRange
end

function CombatLog:AddLog(source, reason, isDebug)
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)

    local playerName = GetPlayerName(source)
    local formattedName = ("[%s] %s"):format(source, playerName)
    local time = CombatLog:_getCurrentFormattedTime()

    local curTime = GetGameTimer()
    local cacheData = {
        id = source,
        coords = coords,
        startTime = curTime,

        name = formattedName,
        reason = reason,
        time = time,
    }

    CombatLog.cache[cacheData.id] = cacheData
    SetTimeout(Config.Cache.Duration, function()
        CombatLog.cache[cacheData.id] = nil
    end)

    if not isDebug and CombatLog.instances[source] then
        CombatLog.instances[source] = nil
    end

    self:UpdateLogs(curTime)
end

function CombatLog:UpdateLogs(curTime)
    curTime = curTime or GetGameTimer()

    for source, _ in pairs(CombatLog.instances) do
        local logsInRange = CombatLog:GetLogsInRange(source, curTime)
        TriggerClientEvent("sd_combatlog:updateLogs", source, logsInRange)
    end
end

AddEventHandler("playerDropped", function(reason)
    local source = source
    CombatLog:AddLog(source, reason)
end)

if Config.Debug then
    RegisterCommand("sd_combatlog:debug", function(source, args, rawCommand)
        CombatLog:AddLog(source, "test", true)
    end)
end
