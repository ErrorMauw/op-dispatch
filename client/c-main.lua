ESX = nil

local LC = Locales[Config.Locale]

local calls = {}
local numcall = 0
local allcalls = 0
local show = false

----------------------
-------- ESX ---------
----------------------

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job

    calls = {}
    numcall = 0
    allcalls = 0

    SendNUIMessage({
        type = 'clear',
    });
end)

----------------------
------ Commands ------
----------------------

RegisterCommand(Config.CommandShow.command, function()
    for k, v in pairs(Config.Jobs) do
        if ESX.PlayerData.job.name == v then
            if show then
                SendNUIMessage({
                    type = 'show',
                    action = false
                });
                show = false
            else
                SendNUIMessage({
                    type = 'show',
                    action = true
                });
                show = true
            end
        end
    end
end, false)

RegisterCommand("enterdisp", function()
    for k, v in pairs(Config.Jobs) do
        if ESX.PlayerData.job.name == v then
            if show then
                if allcalls ~= 0 then
                    local coords = calls[numcall]['coords']
                    SetNewWaypoint(coords.x, coords.y)
                end
            end
        end
    end
end)

RegisterCommand("leftdisp", function()
    for k, v in pairs(Config.Jobs) do
        if ESX.PlayerData.job.name == v then
            if show then
                if calls[numcall - 1] ~= nil then
                    local num = numcall - 1
                    SendNUIMessage({
                        type = 'setalert',
                        content = calls[numcall - 1]['text'],
                        title = calls[numcall - 1]['title'],
                        numcall = num,
                    })
                    numcall = numcall - 1
                end
            end
        end
    end
end)

RegisterCommand('rightdisp', function()
    for k, v in pairs(Config.Jobs) do
        if ESX.PlayerData.job.name == v then
            if show then
                if calls[numcall + 1] ~= nil then
                    local num = numcall + 1
                    SendNUIMessage({
                        type = 'setalert',
                        content = calls[numcall + 1]['text'],
                        title = calls[numcall + 1]['title'],
                        numcall = num,
                    })
                    numcall = numcall + 1
                end
            end
        end
    end
end)

RegisterCommand(Config.CommandClear.command, function()
    for k, v in pairs(Config.Jobs) do
        if ESX.PlayerData.job.name == v then
            calls = {}
            numcall = 0
            allcalls = 0

            SendNUIMessage({
                type = 'clear',
            });
            ESX.ShowNotification(LC['Clear_Alerts'])
        end
    end
end, false)

RegisterCommand(Config.CommandPanic.command, function()
    for k, v in pairs(Config.Jobs) do
        if Config.AllowedJobs[v].panic then
            local job = v
            local text = LC['Panic_01'] .. Config.AllowedJobs[v].label .. LC['Panic_02']
            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())

            ESX.ShowNotification('Boton de panico activado!')
            TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, text, coords, id)
        end
    end
end)

for k, v in pairs(Config.Jobs) do
    RegisterCommand(Config.AllowedJobs[v].command, function(source, args)
        local job = v
        local text = table.concat(args, " ")
        local coords = GetEntityCoords(PlayerPedId())
        local id = GetPlayerServerId(PlayerId())

        ESX.ShowNotification(LC['Correcta_Alerta'])
        TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, text, coords, id)
    end, false)
end

RegisterCommand(Config.VehicleRob.command, function(args)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

        local coords = GetEntityCoords(PlayerPedId())
        local id = GetPlayerServerId(PlayerId())

        local subcolor = tostring(GetVehicleColor(vehicle))
        local color = LC.Colors[subcolor]

        ESX.ShowNotification(LC['Correcta_Alerta'])
        TriggerServerEvent("Opto_dispatch:Server:SendVehRob", 'police', coords, model, color, id)
    else
        ESX.ShowNotification(LC['En_Vehiculo'])
    end
end, false)

----------------------
---- TriggerEvent ----
----------------------

RegisterNetEvent("Opto_dispatch:Client:SendAlert")
AddEventHandler("Opto_dispatch:Client:SendAlert", function(text, coords, id)
    numcall = numcall + 1
    allcalls = allcalls + 1

    if callnum == totalcalls then
        SendNUIMessage({
            type = 'alert',
            title = LC['Alerta_Titulo'],
            content = text,
            numcall = numcall,
            allcalls = allcalls,
            id = id
        });

        table.insert(calls, { text = text, coords = coords, title =  LC['Alerta_Titulo']})

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    else
        numcall = allcalls
        SendNUIMessage({
            type = 'alert',
            title = LC['Alerta_Titulo'],
            content = text,
            numcall = numcall,
            allcalls = allcalls,
            id = id
        });

        table.insert(calls, { text = text, coords = coords, title =  LC['Alerta_Titulo']})

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    end
end)

RegisterNetEvent("Opto_dispatch:Client:SendVehRob")
AddEventHandler("Opto_dispatch:Client:SendVehRob", function(coords, model, color, id)
    numcall = numcall + 1
    allcalls = allcalls + 1

    local substreet = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetname = GetStreetNameFromHashKey(substreet)

    if callnum == totalcalls then
        SendNUIMessage({
            type = 'alert',
            title = LC['Alerta_Titulo'],
            content = LC['Veh_Rob_01'] .. model .. " color " .. color .. LC['Veh_Rob_02'] .. streetname,
            numcall = numcall,
            allcalls = allcalls,
            id = id
        });

        table.insert(calls, { text = LC['Veh_Rob_01'] .. model .. " color " .. color .. LC['Veh_Rob_02'] .. streetname, coords = coords, title =  LC['Alerta_Titulo']})

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    else
        numcall = allcalls

        SendNUIMessage({
            type = 'alert',
            title = LC['Alerta_Titulo'],
            content = LC['Veh_Rob_01'] .. model .. " color " .. color .. LC['Veh_Rob_02'] .. streetname,
            numcall = numcall,
            allcalls = allcalls,
            id = id
        });

        table.insert(calls, { text = LC['Veh_Rob_01'] .. model .. " color " .. color .. LC['Veh_Rob_02'] .. streetname, coords = coords, title =  LC['Alerta_Titulo']})

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    end
end)

-----------------------------------
---- Suggestion and KeyMapping ----
-----------------------------------

RegisterKeyMapping(Config.CommandShow.command, Config.CommandShow.description, 'keyboard', 'K')

RegisterKeyMapping("rightdisp", LC['rightdisp'], 'keyboard', 'RIGHT')
RegisterKeyMapping("leftdisp", (LC['leftdisp']), 'keyboard', 'LEFT')
RegisterKeyMapping("enterdisp", (LC['enterdisp']), 'keyboard', 'RETURN')

TriggerEvent("chat:addSuggestion", "/" .. Config.VehicleRob.command, (Config.VehicleRob.description))
TriggerEvent("chat:addSuggestion", "/" .. Config.CommandShow.command, (Config.CommandShow.description))
TriggerEvent("chat:addSuggestion", "/" .. Config.CommandClear.command, (Config.CommandClear.description))
TriggerEvent("chat:addSuggestion", "/" .. Config.CommandPanic.command, (Config.CommandPanic.description))

for k, v in pairs(Config.Jobs) do
    TriggerEvent("chat:addSuggestion", "/" .. Config.AllowedJobs[v].command, (Config.AllowedJobs[v].descriptcommand), {{name = (LC['alert']), help = (LC['alert_1'])}})
end
