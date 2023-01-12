Config = {}
Config.Sound = true -- Enable/Disable dispatch sounds
Config.Framework = 'QBCore' -- 'ESX' or 'QBCore'
Config.Locale = 'en' -- Language
Config.ShootingAlerts = true -- Enable/Disable Shooting alerts
Config.ShootingCooldown = 30 -- Seconds
Config.BlipDeletion = 30 -- Seconds

Config.CommandShow = {
    command = 'show',
    description = 'Open Dispatch'
}

Config.VehicleRob = {
    command = 'vehrob',
    description = 'Vehicle theft'
}

Config.CommandPanic = {
    command = 'p',
    description = 'Emergency button'
}

Config.CommandClear = {
    command = 'cls',
    description = 'Clear Alerts'
}

Config.Jobs = {'police', 'ambulance'}

Config.AllowedJobs = {
    ["police"] = {
        name = 'police',
        label = 'LSPD',
        command = 'alert',
        descriptcommand = 'Send an alert to LSPD',
        panic = true
    },
    ["ambulance"] = {
        name = 'ambulance',
        label = 'EMS',
        command = 'alertems',
        descriptcommand = 'Send an alert to EMS',
        panic = true
    }
}
