GlobalUnits = {}

RegisterServerEvent("Opto_dispatch:Server:addGlobalUnit")
AddEventHandler("Opto_dispatch:Server:addGlobalUnit", function(user, name, number, id)
    local newUnit = {
        user = user,
        id = id,
        name = name,
        number = number,
        status = 'greenSt',
        patrol = 'fa-car'
    }
    table.insert(GlobalUnits, newUnit)
end)

RegisterServerEvent("Opto_dispatch:Server:updateUserUnit")
AddEventHandler("Opto_dispatch:Server:updateUserUnit", function(id, type, value)
    for k, v in pairs(GlobalUnits) do
        if v.id == id then
            if type == 'status' then
                v.status = value
            elseif type == 'patrol' then
                v.patrol = value
            elseif type == 'number' then
                v.number = value
            end
        end
    end
end)

RemoveUnit = function(id)
    for k, v in ipairs(GlobalUnits) do
        if v.id == id then
            table.remove(GlobalUnits, k)
            break
        end
    end
end