if Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()

    RegisterServerEvent("Opto_dispatch:Server:SendAlert")
    AddEventHandler("Opto_dispatch:Server:SendAlert", function(aljob, text, coords, id)
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local job = xPlayer.job.name

            if job == aljob then
                TriggerClientEvent("Opto_dispatch:Client:SendAlert", playerId, text, coords, id)
            end
        end
    end)

    RegisterServerEvent("Opto_dispatch:Server:SendVehRob")
    AddEventHandler("Opto_dispatch:Server:SendVehRob", function(aljob, coords, model, color, id)
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local job = xPlayer.job.name

            if job == aljob then
                TriggerClientEvent("Opto_dispatch:Client:SendVehRob", playerId, coords, model, color, id)
            end
        end
    end)
end

if Config.Framework == 'QBCore' then
    local QBCore = exports['qb-core']:GetCoreObject()

    RegisterServerEvent("Opto_dispatch:Server:SendAlert")
    AddEventHandler("Opto_dispatch:Server:SendAlert", function(aljob, text, coords, id)
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)

            if Player.PlayerData.job.name == aljob and Player.PlayerData.job.onduty then
                TriggerClientEvent("Opto_dispatch:Client:SendAlert", v, text, coords, id)
            end
        end
    end)

    RegisterServerEvent("Opto_dispatch:Server:SendVehRob")
    AddEventHandler("Opto_dispatch:Server:SendVehRob", function(aljob, coords, model, color, id)
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)

            if Player.PlayerData.job.name == aljob and Player.PlayerData.job.onduty then
                TriggerClientEvent("Opto_dispatch:Client:SendVehRob", v, coords, model, color, id)
            end
        end
    end)
end
