-------------------------
---------- ESX ----------
-------------------------

if Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()

    -----------------------
    ---- TriggerEvents ----
    -----------------------

    RegisterNetEvent("esx:playerLoaded")
    AddEventHandler("esx:playerLoaded", function(xPlayer)
        ESX.PlayerData = xPlayer

        if ESX.PlayerData.job.name == Config.DispatcherJob then
            print(ESX.PlayerData)
            local user = GetPlayerName(PlayerId())
            local name = FirstToUpper(ESX.PlayerData.firstName) .. ' ' .. FirstToUpper(ESX.PlayerData.lastName)
            local number = Config.DefaultDispatchNumber
            TriggerServerEvent('Opto_dispatch:Server:addGlobalUnit', user, name, number,
                GetPlayerServerId(PlayerId()))
        end
    end)

    RegisterNetEvent("esx:setJob")
    AddEventHandler("esx:setJob", function(job)
        ESX.PlayerData.job = job

        Calls = {}
        Numcall = 0
        Allcalls = 0

        SendNUIMessage({
            type = 'clear'
        });

        SendNUIMessage({
            type = 'show',
            action = false
        });
        Show = false
    end)

    -----------------------------------
    ------------ Functions ------------
    -----------------------------------

    UpdateUserData = function()
        ESX.TriggerServerCallback('Opto_dispatch:getGlobalUnits', function(units)
            SendNUIMessage({
                type = 'updateUserData',
                units = units,
            });
        end)
    end

    FirstToUpper = function(str)
        return (str:gsub("^%l", string.upper))
    end

    -----------------------------------
    ------------ Commands -------------
    -----------------------------------

    for k, v in pairs(Config.Jobs) do
        RegisterCommand(Config.AllowedJobs[v].command, function(source, args)
            local job = v
            local text = table.concat(args, " ")
            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())
            local title = LC['Alert_Title']
            local panic = false

            ESX.ShowNotification(LC['Alert_Sent'])
            TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
        end, false)
    end

    RegisterCommand(Config.CommandShow.command, function()
        for k, v in pairs(Config.Jobs) do
            if ESX.PlayerData.job.name == v then
                if Show then
                    SendNUIMessage({
                        type = 'show',
                        action = false
                    });
                    Show = false
                else
                    SendNUIMessage({
                        type = 'show',
                        action = true
                    });
                    Show = true
                end
            end
        end
    end, false)

    RegisterCommand('dispatchLarge', function()
        if ESX.PlayerData.job.name == Config.DispatcherJob then
            if ShowLarg then
                SetNuiFocus(false, false)
                SendNUIMessage({
                    type = 'openLargeDis',
                    bool = false
                });
                ShowLarg = false
            else
                ESX.TriggerServerCallback('Opto_dispatch:getGlobalUnits', function(units)
                    SendNUIMessage({
                        type = 'openLargeDis',
                        bool = true,
                        id = GetPlayerServerId(PlayerId()),
                        units = units
                    });
                    SetNuiFocus(true, true)
                    ShowLarg = true
                end)
            end
        end
    end, false)

    RegisterCommand(Config.CommandClear.command, function()
        for k, v in pairs(Config.Jobs) do
            if ESX.PlayerData.job.name == v then
                Calls = {}
                Numcall = 0
                Allcalls = 0

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
                local name = ESX.PlayerData.firstName
                local surname = ESX.PlayerData.lastName
                local text = LC['Panic_01'] .. name .. " " .. surname .. LC['Panic_02']
                local coords = GetEntityCoords(PlayerPedId())
                local title = LC['Panic_Title']
                local id = GetPlayerServerId(PlayerId())
                local panic = true

                ESX.ShowNotification(LC['Panic_Button'])
                TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
            end
        end
    end)

    RegisterCommand(Config.VehicleRob.command, function(args)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle)
            local r, g, b = GetVehicleColor(vehicle)
            local color = r .. ', ' .. g .. ', ' .. b

            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())

            ESX.ShowNotification(LC['Alert_Sent'])
            TriggerServerEvent("Opto_dispatch:Server:SendVehRob", 'police', coords, model, plate, color, id)
        else
            ESX.ShowNotification(LC['Must_Vehicle'])
        end
    end, false)

    RegisterCommand("enterdisp", function()
        for k, v in pairs(Config.Jobs) do
            if ESX.PlayerData.job.name == v then
                if Show then
                    if Allcalls ~= 0 then
                        local coords = Calls[Numcall]['coords']
                        SetNewWaypoint(coords.x, coords.y)
                        SendNUIMessage({
                            type = 'aceptAlert',
                        })
                    end
                end
            end
        end
    end)

    RegisterCommand("leftdisp", function()
        for k, v in pairs(Config.Jobs) do
            if ESX.PlayerData.job.name == v then
                if Show then
                    if Calls[Numcall - 1] ~= nil then
                        local num = Numcall - 1
                        SendNUIMessage({
                            type = 'setalert',
                            content = Calls[Numcall - 1]['text'],
                            title = Calls[Numcall - 1]['title'],
                            id = Calls[Numcall - 1]['id'],
                            panic = Calls[Numcall - 1]['panic'] or false,
                            color = Calls[Numcall - 1]['color'] or false,
                            numcall = num
                        })
                        Numcall = Numcall - 1
                    end
                end
            end
        end
    end)

    RegisterCommand('rightdisp', function()
        for k, v in pairs(Config.Jobs) do
            if ESX.PlayerData.job.name == v then
                if Show then
                    if Calls[Numcall + 1] ~= nil then
                        local num = Numcall + 1
                        SendNUIMessage({
                            type = 'setalert',
                            content = Calls[Numcall + 1]['text'],
                            title = Calls[Numcall + 1]['title'],
                            id = Calls[Numcall + 1]['id'],
                            panic = Calls[Numcall + 1]['panic'] or false,
                            color = Calls[Numcall + 1]['color'] or false,
                            numcall = num
                        })
                        Numcall = Numcall + 1
                    end
                end
            end
        end
    end)

    -----------------------------------
    ------------- Others --------------
    -----------------------------------

    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            Wait(2000)

            Calls = {}
            Numcall = 0
            Allcalls = 0

                if ESX.PlayerData.job.name == Config.DispatcherJob then
                    local user = GetPlayerName(PlayerId())
                    local name = FirstToUpper(ESX.PlayerData.firstName) ..
                        ' ' .. FirstToUpper(ESX.PlayerData.lastName)
                    local number = Config.DefaultDispatchNumber
                    TriggerServerEvent('Opto_dispatch:Server:addGlobalUnit', user, name, number,
                    GetPlayerServerId(PlayerId()))
                end

            SendNUIMessage({
                type = 'clear'
            });
        end
    end)
end

-------------------------
-------- QBCore ---------
-------------------------

if Config.Framework == "QBCore" then
    local isLoggedIn = false
    local QBCore = exports['qb-core']:GetCoreObject()

    -----------------------
    ---- TriggerEvents ----
    -----------------------

    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
        PlayerData.job = job
        PlayerJob = PlayerData.job

        Calls = {}
        Numcall = 0
        Allcalls = 0

        SendNUIMessage({
            type = 'clear'
        });

        SendNUIMessage({
            type = 'show',
            action = false
        });
        Show = false
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerUnload")
    AddEventHandler("QBCore:Client:OnPlayerUnload", function()
        isLoggedIn = false
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        PlayerData = QBCore.Functions.GetPlayerData()
        isLoggedIn = true

        if isLoggedIn then
            if PlayerData.job.name == Config.DispatcherJob then
                if PlayerData.job.onduty then
                    local user = GetPlayerName(PlayerId())
                    local name = PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname
                    local number = Config.DefaultDispatchNumber
                    TriggerServerEvent('Opto_dispatch:Server:addGlobalUnit', user, name, number,
                    GetPlayerServerId(PlayerId()))
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end)

    -----------------------------------
    ------------ Functions ------------
    -----------------------------------

    UpdateUserData = function()
        QBCore.Functions.TriggerCallback('Opto_dispatch:getGlobalUnits', function(cb)
            SendNUIMessage({
                type = 'updateUserData',
                units = cb,
            });
        end)
    end

    FirstToUpper = function(str)
        return (str:gsub("^%l", string.upper))
    end

    -----------------------------------
    ------------ Commands -------------
    -----------------------------------

    for k, v in pairs(Config.Jobs) do
        RegisterCommand(Config.AllowedJobs[v].command, function(source, args)
            local job = v
            local text = table.concat(args, " ")
            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())
            local title = LC['Alert_Title']
            local panic = false

            QBCore.Functions.Notify(LC['Alert_Sent'])
            TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
        end, false)
    end

    RegisterCommand(Config.CommandShow.command, function()
        for k, v in pairs(Config.Jobs) do
            if isLoggedIn then
                if PlayerData.job.name == v then
                    if PlayerData.job.onduty then
                        if Show then
                            SendNUIMessage({
                                type = 'show',
                                action = false
                            });
                            Show = false
                        else
                            SendNUIMessage({
                                type = 'show',
                                action = true
                            });
                            Show = true
                        end
                    else
                        QBCore.Functions.Notify(LC['Not_Service'], 'error')
                    end
                end
            end
        end
    end, false)

    RegisterCommand('dispatchLarge', function()
        if isLoggedIn then
            if PlayerData.job.name == Config.DispatcherJob then
                if PlayerData.job.onduty then
                    if ShowLarg then
                        SetNuiFocus(false, false)
                        SendNUIMessage({
                            type = 'openLargeDis',
                            bool = false
                        });
                        ShowLarg = false
                    else
                        QBCore.Functions.TriggerCallback('Opto_dispatch:getGlobalUnits', function(cb)
                            SendNUIMessage({
                                type = 'openLargeDis',
                                bool = true,
                                id = GetPlayerServerId(PlayerId()),
                                units = cb
                            });
                            SetNuiFocus(true, true)
                            ShowLarg = true
                        end)
                    end
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end, false)

    RegisterCommand(Config.CommandClear.command, function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                Calls = {}
                Numcall = 0
                Allcalls = 0

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
                    local name = PlayerData.charinfo.firstname
                    local surname = PlayerData.charinfo.lastname
                    local text = LC['Panic_01'] .. name .. " " .. surname .. LC['Panic_02']
                    local coords = GetEntityCoords(PlayerPedId())
                    local title = LC['Panic_Title']
                    local id = GetPlayerServerId(PlayerId())
                    local panic = true

                    QBCore.Functions.Notify(LC['Panic_Button'])
                    TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
                else
                    QBCore.Functions.Notify(LC['Not_Service'], 'error')
                end
            end
        end
    end)

    RegisterCommand(Config.VehicleRob.command, function(args)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local plate = GetVehicleNumberPlateText(vehicle)
            local r, g, b = GetVehicleColor(vehicle)
            local color = r .. ', ' .. g .. ', ' .. b

            local coords = GetEntityCoords(PlayerPedId())
            local id = GetPlayerServerId(PlayerId())

            QBCore.Functions.Notify(LC['Alert_Sent'])
            TriggerServerEvent("Opto_dispatch:Server:SendVehRob", 'police', coords, model, plate, color, id)
        else
            QBCore.Functions.Notify(LC['Must_Vehicle'])
        end
    end, false)

    RegisterCommand("enterdisp", function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                if PlayerData.job.onduty then
                    if Show then
                        if Allcalls ~= 0 then
                            local coords = Calls[Numcall]['coords']
                            SetNewWaypoint(coords.x, coords.y)
                            SendNUIMessage({
                                type = 'aceptAlert',
                            })
                        end
                    end
                end
            end
        end
    end)

    RegisterCommand("leftdisp", function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                if PlayerData.job.onduty then
                    if Show then
                        if Calls[Numcall - 1] ~= nil then
                            local num = Numcall - 1
                            SendNUIMessage({
                                type = 'setalert',
                                content = Calls[Numcall - 1]['text'],
                                title = Calls[Numcall - 1]['title'],
                                id = Calls[Numcall - 1]['id'],
                                panic = Calls[Numcall - 1]['panic'] or false,
                                color = Calls[Numcall - 1]['color'] or false,
                                numcall = num
                            })
                            Numcall = Numcall - 1
                        end
                    end
                end
            end
        end
    end)

    RegisterCommand('rightdisp', function()
        for k, v in pairs(Config.Jobs) do
            if PlayerData.job.name == v then
                if PlayerData.job.onduty then
                    if Show then
                        if Calls[Numcall + 1] ~= nil then
                            local num = Numcall + 1
                            SendNUIMessage({
                                type = 'setalert',
                                content = Calls[Numcall + 1]['text'],
                                title = Calls[Numcall + 1]['title'],
                                id = Calls[Numcall + 1]['id'],
                                panic = Calls[Numcall + 1]['panic'] or false,
                                color = Calls[Numcall + 1]['color'] or false,
                                numcall = num
                            })
                            Numcall = Numcall + 1
                        end
                    end
                end
            end
        end
    end)

    -----------------------------------
    ------------- Others --------------
    -----------------------------------

    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            if Config.Framework == 'QBCore' then
                Wait(2000)
                PlayerData = QBCore.Functions.GetPlayerData()
                isLoggedIn = true

                Calls = {}
                Numcall = 0
                Allcalls = 0

                if isLoggedIn then
                    if PlayerData.job.name == Config.DispatcherJob then
                        if PlayerData.job.onduty then
                            local user = GetPlayerName(PlayerId())
                            local name = FirstToUpper(PlayerData.charinfo.firstname) ..
                                ' ' .. FirstToUpper(PlayerData.charinfo.lastname)
                            local number = Config.DefaultDispatchNumber
                            TriggerServerEvent('Opto_dispatch:Server:addGlobalUnit', user, name, number,
                            GetPlayerServerId(PlayerId()))
                        else
                            QBCore.Functions.Notify(LC['Not_Service'], 'error')
                        end
                    end
                end

                SendNUIMessage({
                    type = 'clear'
                });
            end
        end
    end)
end
