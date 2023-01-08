Config = {}
Config.Sound = true
Config.Framework = 'QBCore' -- 'ESX' or 'QBCore'
Config.Locale = 'en'

Config.CommandShow = {
    command = 'show',
    description = 'Open Dispatch',
}

Config.VehicleRob = {
    command = 'vehrob',
    description = 'Vehicle theft',
}

Config.CommandPanic = {
    command = 'p',
    description = 'Emergency button'
}

Config.CommandClear = {
    command = 'cls',
    description = 'Clear Alerts'
}

Config.Jobs = {
    'police',
    'ambulance'
}

Config.AllowedJobs = {
    ["police"] = {
        name = 'police',
        label = 'LSPD',
        command = 'alert',
        descriptcommand = 'Send an alert to LSPD',
        panic = true,
    },
    ["ambulance"] = {
        name = 'ambulance',
        label = 'EMS',
        command = 'alertems',
        descriptcommand = 'Send an alert to EMS',
        panic = true,
    },
}