ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for propsLab in pairs(options) do
    ESX.RegisterUsableItem(propsLab, function(source)
        TriggerClientEvent('io_chemicals:synthesize', source, propsLab)
    end)
end

for k,v in pairs(chemicalPureItems) do 
    ESX.RegisterUsableItem(v.element, function(source)
        TriggerClientEvent('io_chemicals:addPureElement', source, v.element)
    end)
end

for k,v in pairs(chemicalCompoundItems) do 
    ESX.RegisterUsableItem(v.compound, function(source)
        TriggerClientEvent('io_chemicals:addCompound', source, v.compound)
    end)
end

ESX.RegisterServerCallback('io_chemicals:getSkillChemicals', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    while xPlayer == nil do
        Citizen.Wait(0)
       xPlayer = ESX.GetPlayerFromId(_source)
    end

    MySQL.Async.fetchAll("SELECT * FROM habilidades WHERE identifier=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data)
        for _,v in pairs(data) do
            skillquimica = v.quimica
        end
        cb(skillquimica)
    end)
end)

RegisterServerEvent("io_chemicals:removeItem")
AddEventHandler("io_chemicals:removeItem", function(item_name)
    local _source = source
    exports.ox_inventory:RemoveItem(source, item_name, 1)
end)