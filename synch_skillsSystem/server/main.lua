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

