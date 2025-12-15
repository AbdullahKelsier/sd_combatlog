
local SetTimeout = SetTimeout
local World3dToScreen2d = World3dToScreen2d
local SetTextScale = SetTextScale
local SetTextCentre = SetTextCentre
local SetTextDropShadow = SetTextDropShadow
local SetTextColour = SetTextColour
local SetTextOutline = SetTextOutline
local SetTextEntry = SetTextEntry
local AddTextComponentString = AddTextComponentString
local DrawText = DrawText

function CombatLog:_stateNotification(count)
    self:_countNotification(count)

    if not Config.ShowStateNotification then return end

    local stateText = count and locale("combatlog_enabled") or locale("combatlog_disabled")
    local stateType = count and "success" or "error"
    lib.notify({
        title = locale("combatlog_title"),
        description = stateText,
        type = stateType,
        icon = "person",
    })
end

local lastSeconds = Config.Cache.Duration // 1000
function CombatLog:_countNotification(count)
    if not Config.ShowCountNotification then return end
    if not count then return end

    SetTimeout(Config.CountDelay, function()
        local countText = locale("combatlog_found_count", count, Config.Cache.Distance, lastSeconds)
        lib.notify({
            title = locale("combatlog_title"),
            description = countText,
            type = "info",
            icon = "person",
        })
    end)
end

local fontText = ("<font face='%s'>%s</font>"):format(Config.TextStyle.CustomFont.Name, "%s")
local r, g, b, a = table.unpack(Config.TextStyle.Color)
function CombatLog:_draw3dText(data, distance)
    local onScreen, screenX, screenY = World3dToScreen2d(data.coords.x, data.coords.y, data.coords.z)
    if not onScreen then return end

    local text = Config.TextStyle.CustomFont.Enabled and fontText:format(data.text) or data.text
    local scale = Config.TextStyle.Scale * (1.0 - (distance / Config.Display.Distance) * 0.5)
    scale = lib.math.clamp(scale, Config.TextStyle.Scale * 0.5, Config.TextStyle.Scale)

    SetTextScale(scale, scale)
    SetTextCentre(1)
    SetTextDropShadow()
    SetTextColour(r, g, b, a)

    if Config.TextStyle.Outline then
        SetTextOutline()
    end

    SetTextEntry("string")
    AddTextComponentString(text)
    DrawText(screenX, screenY)

    return true
end
