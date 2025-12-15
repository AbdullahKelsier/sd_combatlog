
function CombatLog:_getCurrentFormattedTime()
    local time = os.date("*t")
    local formattedTime = ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec)
    return formattedTime
end
