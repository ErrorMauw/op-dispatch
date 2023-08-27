if Config.Framework == 'ESX' then
    local ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterServerCallback('Opto_dispatch:getGlobalUnits', function(src, cb)
        cb(GlobalUnits)
    end)

    AddEventHandler('playerDropped', function(rs)
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.job.name

        if job == Config.DispatcherJob then
            RemoveUnit(source)
        end
    end)

    RegisterServerEvent("Opto_dispatch:Server:SendAlert")
    AddEventHandler("Opto_dispatch:Server:SendAlert", function(aljob, title, text, coords, panic, id)
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local job = xPlayer.job.name

            if job == aljob then
                TriggerClientEvent("Opto_dispatch:Client:SendAlert", playerId, title, text, coords, panic, id)
            end
        end
    end)

    RegisterServerEvent("Opto_dispatch:Server:SendVehRob")
    AddEventHandler("Opto_dispatch:Server:SendVehRob", function(aljob, coords, model, plate, color, id)
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local job = xPlayer.job.name

            if job == aljob then
                TriggerClientEvent("Opto_dispatch:Client:SendVehRob", playerId, coords, model, plate, color, id)
            end
        end
    end)
end

if Config.Framework == 'QBCore' then
    local QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback('Opto_dispatch:getGlobalUnits', function(_, cb)
        cb(GlobalUnits)
    end)

    AddEventHandler('playerDropped', function(rs)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.PlayerData.job.name == Config.DispatcherJob then
            if Player.PlayerData.job.onduty then
                RemoveUnit(source)
            end
        end
    end)

    RegisterServerEvent("Opto_dispatch:Server:SendAlert")
    AddEventHandler("Opto_dispatch:Server:SendAlert", function(aljob, title, text, coords, panic, id)
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)

            if Player.PlayerData.job.name == aljob and Player.PlayerData.job.onduty then
                TriggerClientEvent("Opto_dispatch:Client:SendAlert", v, title, text, coords, panic, id)
            end
        end
    end)

    RegisterServerEvent("Opto_dispatch:Server:SendVehRob")
    AddEventHandler("Opto_dispatch:Server:SendVehRob", function(aljob, coords, model, plate, color, id)
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)

            if Player.PlayerData.job.name == aljob and Player.PlayerData.job.onduty then
                TriggerClientEvent("Opto_dispatch:Client:SendVehRob", v, coords, model, plate, color, id)
            end
        end
    end)
end
