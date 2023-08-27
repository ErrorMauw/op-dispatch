local Cooldown = false
LC = Locales[Config.Locale]

Calls = {}
Numcall = 0
Allcalls = 0
Show = false
ShowLarg = false

-----------------------
---- TriggerEvents ----
-----------------------

RegisterNetEvent("Opto_dispatch:Client:SendAlert")
AddEventHandler("Opto_dispatch:Client:SendAlert", function(title, text, coords, panic, id)
    Numcall = Numcall + 1
    Allcalls = Allcalls + 1

    if Numcall == Allcalls then
        print(id)
        SendNUIMessage({
            type = 'alert',
            title = title,
            content = text,
            numcall = Numcall,
            allcalls = Allcalls,
            panic = panic,
            id = id
        });

        table.insert(Calls, {
            text = text,
            coords = coords,
            title = title,
            panic = panic,
            id = id,
        })

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    else
        Numcall = Allcalls
        SendNUIMessage({
            type = 'alert',
            title = title,
            content = text,
            panic = panic,
            numcall = Numcall,
            allcalls = Allcalls,
            id = id
        });

        table.insert(Calls, {
            text = text,
            coords = coords,
            title = title,
            panic = panic,
            id = id
        })

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    end
end)

RegisterNetEvent("Opto_dispatch:Client:SendVehRob")
AddEventHandler("Opto_dispatch:Client:SendVehRob", function(coords, model, plate, color, id)
    Numcall = Numcall + 1
    Allcalls = Allcalls + 1

    local substreet = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetname = GetStreetNameFromHashKey(substreet)

    if Numcall == Allcalls then
        SendNUIMessage({
            type = 'alert',
            title = LC['Vehicle_Title'],
            content = LC['Veh_Rob_01'] ..
                model .. " plate: " .. plate .. LC['Veh_Rob_02'] .. streetname,
            numcall = Numcall,
            allcalls = Allcalls,
            color = color,
            id = id
        });

        table.insert(Calls, {
            text = LC['Veh_Rob_01'] ..
                model .. " plate: " .. plate .. LC['Veh_Rob_02'] .. streetname,
            coords = coords,
            title = LC['Vehicle_Title'],
            color = color,
            id = id
        })

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    else
        Numcall = Allcalls

        SendNUIMessage({
            type = 'alert',
            title = LC['Vehicle_Title'],
            content = LC['Veh_Rob_01'] ..
            model .. " plate: " .. plate .. LC['Veh_Rob_02'] .. streetname,
            numcall = Numcall,
            allcalls = Allcalls,
            color = color,
            id = id
        });

        table.insert(Calls, {
            text = LC['Veh_Rob_01'] ..
            model .. " plate: " .. plate .. LC['Veh_Rob_02'] .. streetname,
            coords = coords,
            title = LC['Vehicle_Title'],
            color = color,
            id = id
        })

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    end
end)

RegisterNetEvent('Opto_dispatch:Client:Cooldown')
AddEventHandler('Opto_dispatch:Client:Cooldown', function()
    Cooldown = true
    local timeRemaining = Config.ShootingCooldown
    local temp = Config.ShootingCooldown
    for i = 1, temp do
        Wait(1000)
        timeRemaining = timeRemaining - 1
    end
    Cooldown = false
end)

RegisterNUICallback('closeLarge', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'openLargeDis',
        bool = false
    });
    ShowLarg = false
end)

-----------------------------------
------------ Threads --------------
-----------------------------------

CreateThread(function()
    while true do
        if Show and Numcall ~= 0 then
            local ply = GetEntityCoords(PlayerPedId())
            local dist = #(ply - Calls[Numcall]['coords'])

            if Config.Measurement then
                SendNUIMessage({
                    type = 'dist',
                    distance = string.format("%.2f", (dist / 1000)),
                    text = LC['Dist_tl'],
                    med = 'km'
                });
            else
                SendNUIMessage({
                    type = 'dist',
                    distance = string.format("%.2f", (dist / 1000)),
                    text = LC['Dist_tl'],
                    med = 'mi'
                });
            end
        end
        Wait(150)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if Config.ShootingAlerts and IsPedShooting(ped) then
            for k, v in pairs(Config.Jobs) do
                local job = v
                local coords = GetEntityCoords(ped)
                local substreet = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                local streetname = GetStreetNameFromHashKey(substreet)
                local id = GetPlayerServerId(PlayerId())
                local text = LC['Shooting_Alert'] .. " " .. streetname
                local title = LC['Shotting_Title']
                local panic = true

                if Cooldown == false then
                    TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
                    ShootingBlip()
                    TriggerEvent('Opto_dispatch:Client:Cooldown')
                end
            end
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        if ShowLarg then
            UpdateUserData()
        end
        Wait(400)
    end
end)

-----------------------------------
------------ Functions ------------
-----------------------------------

ShootingBlip = function ()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 156)
    SetBlipColour(blip, 4)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.5)
    SetBlipFlashes(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(LC['Blip_Label'])
    EndTextCommandSetBlipName(blip)

    Wait(Config.BlipDeletion * 1000)
    RemoveBlip(blip)
end

-----------------------------------
------------ Callbacks ------------
-----------------------------------

RegisterNUICallback('updateUserUnit', function(data)
    TriggerServerEvent('Opto_dispatch:Server:updateUserUnit', GetPlayerServerId(PlayerId()), data.type, data.value)
end)

-----------------------------------
---- Suggestion and KeyMapping ----
-----------------------------------

RegisterKeyMapping(Config.CommandShow.command, Config.CommandShow.description, 'keyboard', 'K')
RegisterKeyMapping('dispatchLarge', 'Open the Large Dispatch', 'keyboard', 'O')

RegisterKeyMapping("rightdisp", LC['rightdisp'], 'keyboard', 'RIGHT')
RegisterKeyMapping("leftdisp", (LC['leftdisp']), 'keyboard', 'LEFT')
RegisterKeyMapping("enterdisp", (LC['enterdisp']), 'keyboard', 'RETURN')

TriggerEvent("chat:addSuggestion", "/" .. Config.VehicleRob.command, (Config.VehicleRob.description))
TriggerEvent("chat:addSuggestion", "/" .. Config.CommandShow.command, (Config.CommandShow.description))
TriggerEvent("chat:addSuggestion", "/" .. Config.CommandClear.command, (Config.CommandClear.description))
TriggerEvent("chat:addSuggestion", "/" .. Config.CommandPanic.command, (Config.CommandPanic.description))
TriggerEvent("chat:addSuggestion", "/" .. 'dispatchLarge', LC['large_dispatchopen'])

for k, v in pairs(Config.Jobs) do
    TriggerEvent("chat:addSuggestion", "/" .. Config.AllowedJobs[v].command, (Config.AllowedJobs[v].descriptcommand), { {
        name = (LC['alert']),
        help = (LC['alert_1'])
    } })
end