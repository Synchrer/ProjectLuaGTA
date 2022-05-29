ESX = nil
staminaValue = nil
disparoValue = nil
agriculturaValue = nil
lootingValue = nil
mineriaValue = nil
quimicaValue = nil
medicinaValue = nil
local counter = 0

local openKey = 142 -- sustituir por la tecla que se quiera usar

function round(num, numDecimalPlaces)
	local mult = 10 ^ (2)
	return math.floor(num * mult + 0.5) / mult
end

if Config.DebugMode then
	RegisterCommand('ds', function()
		ESX.TriggerServerCallback("io_skillsystem:getSkills", function(stamina, agricultura, looting, mineria, quimica, medicina, disparo)
			TriggerEvent('io_skillsystem:sendPlayerSkills', stamina, agricultura, looting, mineria, quimica, medicina, disparo)
		end)
	end)
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function mySkills()
	local elements = {}

	ESX.TriggerServerCallback("io_skillsystem:getSkills", function(stamina, agricultura, looting, mineria, quimica, medicina, disparo)
		TriggerEvent('io_skillsystem:sendPlayerSkills', stamina, agricultura, looting, mineria, quimica, medicina, disparo)
		
		table.insert(elements, {label = 'Stamina: ' .. stamina .. '%', action = "stamina"})
		table.insert(elements, {label = 'Agricultura: ' .. agricultura .. '%', action = "agricultura"})
		table.insert(elements, {label = 'Looting: ' .. looting .. '%', action = "looting"})
		table.insert(elements, {label = 'Mineria: ' .. mineria .. '%', action = "mineria"})
		table.insert(elements, {label = 'Quimica: ' .. quimica .. '%', action = "quimica"})
		table.insert(elements, {label = 'Medicina: ' .. medicina .. '%', action = "medicina"})
		table.insert(elements, {label = 'Disparo: ' .. disparo .. '%', action = "disparo"})
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mySkills', {
			title   = 'Menu de Habilidades',
			align   = 'bottom-right',
			elements = elements
		},

		function(data, menu)
			local ped = PlayerPedId()
			local ds = data.current.action
			if ds == 'stamina' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a aumentar tu resistencia", type = "info", timeout = 4000, layout = "centerLeft"})
			elseif ds == 'agricultura' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a cultivar y recolectar de forma más eficiente", type = "info", timeout = 4000, layout = "centerLeft"})
			elseif ds == 'looting' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a optimizar el tiempo de búsqueda de objetos", type = "info", timeout = 4000, layout = "centerLeft"})
			elseif ds == 'mineria' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a excarvar de forma mas eficiente", type = "info", timeout = 4000, layout = "centerLeft"})
			elseif ds == 'quimica' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a procesar mejores y mayor cantidad de quimicos", type = "info", timeout = 4000, layout = "centerLeft"})
			elseif ds == 'medicina' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a curar o curarte de forma mas eficiente", type = "info", timeout = 4000, layout = "centerLeft"})
			elseif ds == 'disparo' then
				exports.pNotify:SendNotification({text = "Dicha habilidad te ayudara a conseguir mayor precisión y control con las armas", type = "info", timeout = 4000, layout = "centerLeft"})
			else
				menu.close()
			end
		end,

		function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('io_skillsystem:sendPlayerSkills')
AddEventHandler('io_skillsystem:sendPlayerSkills', function(stamina, agricultura, looting, mineria, quimica, medicina, disparo)
	staminaValue     = stamina
	disparoValue     = disparo
	agriculturaValue = agricultura
	lootingValue     = looting
	quimicaValue 	 = quimica
    -- Pensar en que influye al jugador estas habilidades
	mineriaValue 	 = mineria
	medicinaValue 	 = medicina 

	StatSetInt("MP0_STAMINA", stamina, true)
	StatSetInt('MP0_LUNG_CAPACITY', stamina, true)
	StatSetInt('MP0_SHOOTING_ABILITY', disparo, true)
end)

RegisterKeyMapping('myskills', 'Mis Habilidades', 'keyboard', '')
RegisterCommand('myskills', function()
	mySkills()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)

		if IsPedShooting(ped) then
			counter = counter + 1
			if counter == 5 then
				TriggerServerEvent("io_skillsystem:addDisparo", GetPlayerServerId(PlayerId()), 1)
				counter = 0
			end
		end
	end
end)