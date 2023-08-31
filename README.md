# Opto Studio https://discord.gg/rnQePyNK4x

## Preview
![MiniaturaOptoDispatch](https://github.com/ErrorMauw/op-dispatch/assets/110748601/4957c493-97e6-475e-9360-85495e848454)
## https://youtu.be/uxI09PKPvLk

Opto Dispatch V2
Available for ESX & QBCore

## Download & Installation
### Config
- Make sure to change your language in Config.Locale and Config.Framework.
- At the bottom of the config.lua file you will see 
  Config.Jobs and Config.AllowedJobs, you can add whatever job you're interested to be able to use the dispatch.
  
```lua
Config = {}
Config.Sound = true -- Enable/Disable dispatch sounds
Config.Framework = 'ESX' -- 'ESX' or 'QBCore'
Config.Locale = 'en' -- Language 'en' or 'es'
Config.ShootingAlerts = true -- Enable/Disable Shooting alerts
Config.Measurement = true -- True = Metric False = Imperial
Config.ShootingCooldown = 30 -- Seconds
Config.BlipDeletion = 30 -- Seconds

Config.CommandShow = {
    command = 'showDispatch',
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

Config.DispatcherJob = 'police'
Config.Jobs = {'police', 'ambulance'}
Config.DefaultDispatchNumber = '0A-00'

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
### Adding alerts to your scripts
```lua
Example function:
function ExampleAlert()
 local job = "police" -- Jobs that will recive the alert
 local text = "Example Text" -- Main text alert
 local coords = GetEntityCoords(PlayerPedId()) -- Alert coords
 local id = GetPlayerServerId(PlayerId()) -- Player that triggered the alert
 local title = "Example Title" -- Main title alert
 local panic = false -- Allow/Disable panic effect

 TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
end
```

### Manually
- Download https://github.com/ErrorMauw/op-dispatch/archive/refs/heads/main.zip
- Put it in the `resources` directory

### Using [Git](https://git-scm.com/downloads)

cd resources
git clone https://github.com/ErrorMauw/op-dispatch resources/op-dispatch
