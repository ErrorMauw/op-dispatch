ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

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