
CombatLog = {
    showDisplay = false,
    displayLogs = {},
    lastUsed = 0,
}

local GetEntityCoords = GetEntityCoords
local GetGameTimer = GetGameTimer

function CombatLog:DisplayLogs(foundCount)
    self.showDisplay = not self.showDisplay
    if not self.showDisplay then return end

    local curTime = GetGameTimer()
    self.lastUsed = curTime
    SetTimeout(Config.Display.Duration, function()
        if self.lastUsed ~= curTime then return end
        self.showDisplay = false
    end)

    self:_stateNotification(foundCount)

    while self.showDisplay do
        local sleep = 1000
        local curTime

        local coords = GetEntityCoords(cache.ped)
        for _, data in pairs(self.displayLogs) do
            local distance = #(coords - data.coords)
            if distance <= Config.Display.Distance then
                curTime = curTime or GetGameTimer()

                local elapsedTime = (curTime - data.startTime) + data.elapsedTime
                if elapsedTime <= Config.Cache.Duration then
                    local elapsed = elapsedTime // 1000
                    local text = ("%s\n%s"):format(data.info, locale("combatlog_info_elapsed", elapsed))
                    sleep = self:_draw3dText({
                        coords = data.coords,
                        text = text,
                    }, distance) and 0 or sleep
                end
            end
        end

        Wait(sleep)
    end

    self:_stateNotification()
end

function CombatLog:_buildLogs(logsInRange)
    local curTime = GetGameTimer()
    local displayLogs = {}
    for _, data in pairs(logsInRange) do
        data.startTime = curTime
        data.info = ("%s\n%s\n%s"):format(locale("combatlog_info_name", data.name), locale("combatlog_info_reason", data.reason), locale("combatlog_info_time", data.time))
        displayLogs[#displayLogs + 1] = data
    end

    self.displayLogs = displayLogs

    return #displayLogs
end

RegisterNetEvent("sd_combatlog:displayLogs", function(logsInRange)
    local foundCount = CombatLog:_buildLogs(logsInRange)
    CombatLog:DisplayLogs(foundCount)
end)

RegisterNetEvent("sd_combatlog:updateLogs", function(logsInRange)
    CombatLog:_buildLogs(logsInRange)
end)
