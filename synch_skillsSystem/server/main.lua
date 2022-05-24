ESX = nil

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function updatePlayerInfo(source)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
        if (skillInfo and skillInfo[1]) then
            TriggerClientEvent('io_skillsystem:sendPlayerSkills', _source, skillInfo[1].stamina, skillInfo[1].agricultura, skillInfo[1].looting, skillInfo[1].mineria, skillInfo[1].quimica, skillInfo[1].medicina, skillInfo[1].disparo)
        end
    end)
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source) 
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
    	if ( skillInfo and skillInfo[1] ) then
    		TriggerClientEvent('io_skillsystem:sendPlayerSkills', _source, skillInfo[1].stamina, skillInfo[1].driving, skillInfo[1].shooting, skillInfo[1].fishing, skillInfo[1].drugs)
    	else
    		MySQL.Async.execute('INSERT INTO `habilidades` (`identifier`,  `stamina`, `agricultura`, `looting`, `mineria`, `quimica`, `medicina`, `disparo`) VALUES (@identifier, @stamina, @agricultura, @looting, @mineria, @quimica, @medicina, @disparo);',
                {
                ['@identifier'] = xPlayer.identifier,
                ['@stamina'] = 0,
                ['@agricultura'] = 0,
                ['@looting'] = 0,
                ['@mineria'] = 0,
                ['@quimica'] = 0,
                ['@medicina'] = 0,
                ['@disparo'] = 0
                }, function ()
    	    end)
        end
    end)

	MySQL.Async.fetchAll('SELECT * FROM `habilidades_book` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		if ( skillInfo and skillInfo[1] ) then
			TriggerClientEvent('io_skillsystem:sendPlayerSkills', _source, skillInfo[1].stamina, skillInfo[1].driving, skillInfo[1].shooting, skillInfo[1].fishing, skillInfo[1].drugs)
		else
			MySQL.Async.execute('INSERT INTO `habilidades_book` (`identifier`, `stamina`, `agricultura`, `looting`, `mineria`, `quimica`, `medicina`, `disparo`) VALUES (@identifier, @stamina, @agricultura, @looting, @mineria, @quimica, @medicina, @disparo);',
                {
                ['@identifier'] = xPlayer.identifier,
                ['@stamina'] = 0,
                ['@agricultura'] = 0,
                ['@looting'] = 0,
                ['@mineria'] = 0,
                ['@quimica'] = 0,
                ['@medicina'] = 0,
                ['@disparo'] = 0
                }, function ()
			end)
		end
	end)
end)

RegisterServerEvent("io_skillsystem:addStamina")
AddEventHandler("io_skillsystem:addStamina", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, 'Tu resistencia ha subido ~g~' .. round(amount, 2) .. '%!')

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
        MySQL.Async.execute('UPDATE `habilidades` SET `stamina` = @stamina WHERE `identifier` = @identifier',
            {
            ['@stamina'] = (skillInfo[1].stamina + amount),
            ['@identifier'] = xPlayer.identifier
            }, function ()
            
            updatePlayerInfo(source)
        end)
	end)
end)

RegisterServerEvent("io_skillsystem:addAgricultura")
AddEventHandler('io_skillsystem:addAgricultura', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, 'Tu habilidad de agricultor ha subido ~g~' .. round(amount, 2) .. '%!')

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `agricultura` = @agricultura WHERE `identifier` = @identifier',
			{
			['@agricultura'] = (skillInfo[1].agricultura + amount),
			['@identifier'] = xPlayer.identifier
		    }, function ()
            
            updatePlayerInfo(source)
        end)
	end)
end)

RegisterServerEvent("io_skillsystem:addLooting")
AddEventHandler('io_skillsystem:addLooting', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, 'Tu habilidad de looteo ha subido ~g~' .. round(amount, 2) .. '%!')

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `looting` = @looting WHERE `identifier` = @identifier',
			{
			['@looting'] = (skillInfo[1].looting + amount),
			['@identifier'] = xPlayer.identifier
		    }, function ()

            updatePlayerInfo(source)
        end)
	end)
end)

RegisterServerEvent("io_skillsystem:addMineria")
AddEventHandler('io_skillsystem:addMineria', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, 'Tu habilidad de mineria ha subido ~g~' .. round(amount, 2) .. '%!')

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `mineria` = @mineria WHERE `identifier` = @identifier',
			{
			['@mineria'] = (skillInfo[1].mineria + amount),
			['@identifier'] = xPlayer.identifier
		    }, function ()

            updatePlayerInfo(source)
        end)
	end)
end)

RegisterServerEvent("io_skillsystem:addQuimica")
AddEventHandler('io_skillsystem:addQuimica', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, 'Tu habilidad de quimica ha subido ~g~' .. round(amount, 2) .. '%!')

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `quimica` = @quimica WHERE `identifier` = @identifier',
			{
			['@quimica'] = (skillInfo[1].quimica + amount),
			['@identifier'] = xPlayer.identifier
		    }, function ()

            updatePlayerInfo(source)
        end)
	end)
end)

RegisterServerEvent("io_skillsystem:addMedicina")
AddEventHandler('io_skillsystem:addMedicina', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx:showNotification', source, 'Tu habilidad de medico ha subido ~g~' .. round(amount, 2) .. '%!')

    MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `medicina` = @medicina WHERE `identifier` = @identifier',
			{
			['@medicina'] = (skillInfo[1].medicina + amount),
			['@identifier'] = xPlayer.identifier
		    }, function ()

            updatePlayerInfo(source)
        end)
	end)
end)

RegisterServerEvent("io_skillsystem:addDisparo")
AddEventHandler("io_skillsystem:addDisparo", function(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, 'Tu punteria ha subido ~g~' .. round(amount, 2) .. '%!')
    
	MySQL.Async.fetchAll('SELECT * FROM `habilidades` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `habilidades` SET `disparo` = @disparo WHERE `identifier` = @identifier',
			{
			['@disparo'] = (skillInfo[1].disparo + amount),
			['@identifier'] = xPlayer.identifier
			}, function()
            
			updatePlayerInfo(source)
		end)
	end)
end)