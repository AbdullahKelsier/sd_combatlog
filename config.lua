
Config = {}
Config.Debug = false

Config.Command = {"combat", "combatlog"}

Config.CountDelay = 1000 -- delay to show count notification
Config.ShowCountNotification = true -- show count notification
Config.ShowStateNotification = true -- show state notification

Config.Display = {
    Duration = 1000 * 30, -- 30 seconds
    Distance = 15.0, -- distance to display logs
}

Config.Cache = {
    Duration = 1000 * 60, -- 1 minute
    Distance = 50.0, -- distance to search for logs
}

Config.TextStyle = {
    CustomFont = {
        Enabled = false,
        Name = "rubik",
    },
    Scale = 0.3,
    Color = {255, 153, 0, 255},
    Outline = true,
}
