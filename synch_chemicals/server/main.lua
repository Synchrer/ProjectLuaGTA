ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for propsLab in pairs(options) do
    ESX.RegisterUsableItem(propsLab, function(source)
        TriggerClientEvent('io_chemicals:synthesize', source, propsLab)
    end)
end

for k,v in pairs(chemicalPureItems) do 
    ESX.RegisterUsableItem(v.element, function(source)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        TriggerClientEvent('io_chemicals:addPureElement', source, v.element)
        xPlayer.removeInventoryItem(v.element, 1)
    end)
end

for k,v in pairs(chemicalCompoundItems) do 
    ESX.RegisterUsableItem(v.compound, function(source)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        TriggerClientEvent('io_chemicals:addCompound', source, v.compound)
        xPlayer.removeInventoryItem(v.compound, 1)
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

RegisterServerEvent("io_chemicals:addItem")
AddEventHandler("io_chemicals:addItem", function(item_name, quantity)
    print(item_name, quantity)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addInventoryItem(item_name, quantity)
end)

RegisterServerEvent('io_chemicals:addChemicalLvl')
AddEventHandler('io_chemicals:addChemicalLvl', function(puntos)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `quimica` = @quimica WHERE `identifier` = @identifier', {
            ['@quimica'] = (skillInfo[1].quimica + puntos),
			['@identifier'] = xPlayer.identifier
		})
	end)
    TriggerClientEvent("pNotify:SendNotification", source, {text = "Has adquirido habilidades de quimica. Puntos adquiridos: " .. puntos, type = "info", timeout = 4000, layout = "centerLeft"})
end)
