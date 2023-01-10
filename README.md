# Opto Studios https://discord.gg/rnQePyNK4x
Op-Dispatch

ESX & QBCore FiveM dispatch

## Download & Installation
### Config
- Make sure to change your language in Config.Locale and Config.Framework.
- At the bottom of the config.lua file you will see 
  Config.Jobs and Config.AllowedJobs, you can add whatever job you're interested to be able to use the dispatch.
  
```lua
Config = {}
Config.Sound = true -- Enable/Disable dispatch sounds
Config.Framework = 'QBCore' -- 'ESX' or 'QBCore'
Config.Locale = 'en' -- Language
Config.ShootingAlerts = true -- Enable/Disable Shooting alerts
Config.ShootingCooldown = 30 -- Seconds

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

```

### Manually
- Download https://github.com/ErrorMauw/op-dispatch/archive/refs/heads/main.zip
- Put it in the `resources` directory

### Using [Git](https://git-scm.com/downloads)

cd resources
git clone https://github.com/ErrorMauw/op-dispatch resources/op-dispatch

## Preview
https://user-images.githubusercontent.com/80290702/186480282-8c2db285-7d3e-412e-9803-5d8491862699.mp4
