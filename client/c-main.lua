local LC = Locales[Config.Locale]

local calls = {}
local numcall = 0
local allcalls = 0
local show = false

----------------------
-------- ESX ---------
----------------------

if Config.Framework == "ESX" then
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
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
            type = 'clear'
        });

        SendNUIMessage({
            type = 'show',
            action = false
        });
        show = false
    end)

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
                            numcall = num
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
                            numcall = num
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
                    type = 'clear'
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
end

-------------------------
-------- QBCore ---------
-------------------------

if Config.Framework == "QBCore" then
    local isLoggedIn = false
    local QBCore = exports['qb-core']:GetCoreObject()

    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
        PlayerData.job = job
        PlayerJob = PlayerData.job

        calls = {}
        numcall = 0
        allcalls = 0

        SendNUIMessage({
            type = 'clear'
        });

        SendNUIMessage({
            type = 'show',
            action = false
        });
        show = false
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerUnload")
    AddEventHandler("QBCore:Client:OnPlayerUnload", function()
        isLoggedIn = false
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        PlayerData = QBCore.Functions.GetPlayerData()
        isLoggedIn = true
    end)

    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            if Config.Framework == 'QBCore' then
                Citizen.Wait(2000)
                PlayerData = QBCore.Functions.GetPlayerData()
                isLoggedIn = true

                calls = {}
                numcall = 0
                allcalls = 0

                SendNUIMessage({
                    type = 'clear'
                });
            end
        end
    end)

    RegisterCommand(Config.CommandShow.command, function()
        for k, v in pairs(Config.Jobs) do
            if isLoggedIn then
                if PlayerData.job.name == v then
                    if PlayerData.job.onduty then
                        if show then
                            SendNUIMessage({
                                type = 'show',
                                action = false
                            });
                            show = false
                        else
                            print('true')
                            SendNUIMessage({
                                type = 'show',
                                action = true
                            });
                            show = true
                        end
                    else
                        QBCore.Functions.Notify(LC['Not_Service'], 'error')
                    end
                end
            end
        end
    end, false)

    RegisterCommand("enterdisp", function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                if PlayerData.job.onduty then
                    if show then
                        if allcalls ~= 0 then
                            local coords = calls[numcall]['coords']
                            SetNewWaypoint(coords.x, coords.y)
                        end
                    end
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end)

    RegisterCommand("leftdisp", function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                if PlayerData.job.onduty then
                    if show then
                        if calls[numcall - 1] ~= nil then
                            local num = numcall - 1
                            SendNUIMessage({
                                type = 'setalert',
                                content = calls[numcall - 1]['text'],
                                title = calls[numcall - 1]['title'],
                                numcall = num
                            })
                            numcall = numcall - 1
                        end
                    end
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end)

    RegisterCommand('rightdisp', function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                if PlayerData.job.onduty then
                    if show then
                        if calls[numcall + 1] ~= nil then
                            local num = numcall + 1
                            SendNUIMessage({
                                type = 'setalert',
                                content = calls[numcall + 1]['text'],
                                title = calls[numcall + 1]['title'],
                                numcall = num
                            })
                            numcall = numcall + 1
                        end
                    end
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end)

    RegisterCommand(Config.CommandClear.command, function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                calls = {}
                numcall = 0
                allcalls = 0

                SendNUIMessage({
                    type = 'clear'
                });
                QBCore.Functions.Notify(LC['Clear_Alerts'])
            end
        end
    end, false)

    RegisterCommand(Config.CommandPanic.command, function()
        for k, v in pairs(Config.Jobs) do
            if Config.AllowedJobs[v].panic then
                if PlayerData.job.onduty then
                    local job = v
                    local text = LC['Panic_01'] .. Config.AllowedJobs[v].label .. LC['Panic_02']
                    local coords = GetEntityCoords(PlayerPedId())
                    local id = GetPlayerServerId(PlayerId())

                    QBCore.Functions.Notify(LC['Panic_Button'])
                    TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, text, coords, id)
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end)

    for k, v in pairs(Config.Jobs) do
        RegisterCommand(Config.AllowedJobs[v].command, function(source, args)
            local job = v
            local text = table.concat(args, " ")
            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())

            QBCore.Functions.Notify(LC['Correcta_Alerta'])
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

            QBCore.Functions.Notify(LC['Correcta_Alerta'])
            TriggerServerEvent("Opto_dispatch:Server:SendVehRob", 'police', coords, model, color, id)
        else
            QBCore.Functions.Notify(LC['En_Vehiculo'])
        end
    end, false)
end

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

        table.insert(calls, {
            text = text,
            coords = coords,
            title = LC['Alerta_Titulo']
        })

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

        table.insert(calls, {
            text = text,
            coords = coords,
            title = LC['Alerta_Titulo']
        })

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

        table.insert(calls, {
            text = LC['Veh_Rob_01'] .. model .. " color " .. color .. LC['Veh_Rob_02'] .. streetname,
            coords = coords,
            title = LC['Alerta_Titulo']
        })

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

        table.insert(calls, {
            text = LC['Veh_Rob_01'] .. model .. " color " .. color .. LC['Veh_Rob_02'] .. streetname,
            coords = coords,
            title = LC['Alerta_Titulo']
        })

        if Config.Sound then
            PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 0)
        end
    end
end)

-----------------------------------
--------- Shooting Thread ---------
-----------------------------------

cooldown = false
CreateThread(function()
    while true do
        if Config.ShootingAlerts and IsPedShooting(PlayerPedId()) then
            for k, v in pairs(Config.Jobs) do
                local job = v
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local substreet = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                local streetname = GetStreetNameFromHashKey(substreet)
                local id = GetPlayerServerId(PlayerId())
                local text = LC['Shooting_Alert'] .. " " .. streetname
                if cooldown == false then
                    TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, text, coords, id)
                    TriggerEvent('Cooldown')
                end
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent('Cooldown')
AddEventHandler('Cooldown', function()
    cooldown = true
    timeRemaining = Config.ShootingCooldown
    local temp = Config.ShootingCooldown
    for i = 1, temp do
        Wait(1000)
        timeRemaining = timeRemaining - 1
    end
    cooldown = false
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
    TriggerEvent("chat:addSuggestion", "/" .. Config.AllowedJobs[v].command, (Config.AllowedJobs[v].descriptcommand), {{
        name = (LC['alert']),
        help = (LC['alert_1'])
    }})
end
