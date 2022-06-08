ESX = nil
local skillsquimicos = 0
local chemicals = {}
local textOutput = {}
local fallo = false

function createBlip()
    for k,v in pairs(labBlips) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 499)
        SetBlipColour(blip, 48)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.7)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Laboratorio Quimico")
        EndTextCommandSetBlipName(blip)
    end
end

function addArrayPure(element, symbol, value) 
	text = '~w~[' .. symbol .. ': ' .. value .. '%~w~] '

	if value > 100 then
		fallo = true
	end

    for i=1, #textOutput do
        if string.sub(textOutput[i], 5, 6) == string.sub(text, 5, 6) then
            textOutput[i] = text
        end
    end
end

function placeChemicalLab(propLab)
	chemicals = {}
	local playerPed = PlayerPedId()
	local object = options[propLab]

    	if IsPedInAnyVehicle(playerPed) then
		exports.pNotify:SendNotification({text = "Lamentablemente, no se puede estar en el vehículo.", type = "error", layout = "centerLeft", timeout = 2000})
		do return end
	end
		
	TriggerServerEvent('io_chemicals:removeItem', propLab)
	exports.pNotify:SendNotification({text = object.start_msg, type = "success", layout = "centerLeft", timeout = 2000})
		
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)
			
	RequestModel(object.prop)
	while not HasModelLoaded(object.prop) do
	    Citizen.Wait(1)
    	end
		
    	ESX.Game.SpawnObject(object.prop, {x = x, y = y, z = z}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
	end)

	Wait(100)

    	local container =  GetClosestObjectOfType(x, y, z, 1.0, object.prop, false, true, true)

    	for i=1, #chemicalPureItems do
        	table.insert(chemicals, {item = container, elements = chemicalPureItems[i].element, value = chemicalPureItems[i].value, symbol = chemicalPureItems[i].chemicalSymbol})
    	end

    	writeChemical(container, object.name)
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function exportsProgressBars(msg, time)
    exports['progressBars']:startUI(time, msg)
end

function writeChemical(container, nombre)
	local crecimiento = 0
  	local text = ''
    	local texto
	local flag = false

    for k, v in pairs(chemicals) do
        if v.item == container then
            text = '~w~[' .. v.symbol .. ': ' .. v.value .. '%~w~] '
            textOutput[k] = text
        end
    end

	while true do
		Citizen.Wait(5)

		local player = PlayerPedId()
		local playercoords = GetEntityCoords(player)
        	local recipientecoords = GetEntityCoords(container)
        	local x, y, z = table.unpack(recipientecoords)
		local recipientecoords = vector3(x,y,z+0.7)
		local maxdistance = 5
        	local distance = #(playercoords - recipientecoords)
        
		if crecimiento < 100 then

			if flag then
				crecimiento = crecimiento + 0.01
			end

			if distance < 5 then
                		texto = nombre .. '~r~ ' .. crecimiento .. '%\n'

                		for i=1, #textOutput do				    
                   			if chemicals[i].value >= 1 then
						flag = true
                        			texto = texto .. textOutput[i]
                    			end
                		end
				ESX.Game.Utils.DrawText3D(recipientecoords, texto, 0.5, 4)
			end
			elseif crecimiento >= 100 then
				if distance < 5 then
					local texto2 = '~g~ [E] ~w~Para ~r~recoger ~w~' .. nombre
					ESX.Game.Utils.DrawText3D(recipientecoords, texto2, 0.5, 4)
				end

			if distance < 2 then
				if IsControlPressed(0, 38) then
					DisableControlAction(0, 38, true)
					
					if not Config.TesterMode then
						SetCurrentPedWeapon(player, 0xA2719263, true)
						LoadAnimDict('anim@heists@narcotics@funding@gang_idle')
						TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
						FreezeEntityPosition(PlayerPedId(), true)
						exportsProgressBars("Obteniendo el componente quimico...", 10000)
                				Wait(10000)
               					ClearPedTasks(PlayerPedId())
						FreezeEntityPosition(PlayerPedId(), false)
					end
					
					local chemicalsUsed = 1
					while chemicalsUsed <= #chemicals do
						if chemicals[chemicalsUsed].value == 0 then
							table.remove(chemicals, chemicalsUsed)
						else
							chemicalsUsed = chemicalsUsed + 1
						end
					end

					for k, v in pairs(chemicals) do
						if v.item == container then
							ESX.Game.DeleteObject(v.item)
						end
					end
					checkRecipe(chemicals)
					break
				end
			end
		end
	end		
end

local centrifugedChemicals = {}
local centrifugedChemicalsOrdered = {}
function checkRecipe(chemicals)
	centrifugedChemicals = {}
	centrifugedChemicalsOrdered = {}
	local resultCompound = ''

	for k, v in pairs(chemicals) do
		table.insert(centrifugedChemicals, v.symbol)
		if string.len(v.symbol) ~= 1 then 
			table.insert(centrifugedChemicalsOrdered, string.byte(v.symbol) + 0.1)
		else
			table.insert(centrifugedChemicalsOrdered, string.byte(v.symbol))
		end
	end

	table.sort(centrifugedChemicalsOrdered)

	local encaja = false
	local notEnoughQuantity = false
	local finalQuantity = 1
	local expQuantity = 1
	for key, value in pairs(chemicalCompoundItems) do
		if #centrifugedChemicalsOrdered == #value.components then
			if #centrifugedChemicalsOrdered == 2 then
				if centrifugedChemicalsOrdered[1] == value.components[1] and centrifugedChemicalsOrdered[2] == value.components[2] then
					encaja = true
					resultCompound = value.compound

					if chemicals[1].value >= 99 and chemicals[2].value >= 99 then
						finalQuantity = 4
						expQuantity = 4
					elseif chemicals[1].value >= 85 and chemicals[2].value >= 85 and chemicals[1].value < 99 and chemicals[2].value < 99 then
						finalQuantity = 3
						expQuantity = 2
					elseif chemicals[1].value < 50 or chemicals[2].value < 50
						notEnoughQuantity = true
					end
				end			
			elseif #centrifugedChemicalsOrdered == 3 then
				if centrifugedChemicalsOrdered[1] == value.components[1] and centrifugedChemicalsOrdered[2] == value.components[2] and centrifugedChemicalsOrdered[3] == value.components[3] then
					encaja = true
					resultCompound = value.compound

					if chemicals[1].value >= 99 and chemicals[2].value >= 99 then
						finalQuantity = 4
						expQuantity = 6
					elseif chemicals[1].value >= 85 and chemicals[2].value >= 85 and chemicals[3].value >= 85 and chemicals[1].value < 99 and chemicals[2].value < 99 and chemicals[3].value < 99 then
						finalQuantity = 3
						expQuantity = 3
					elseif chemicals[1].value < 50 or chemicals[2].value < 50 or 
						notEnoughQuantity = true
					end
				end
			end
		end
	end

	if encaja then
		if not fallo and not notEnoughQuantity then		
			TriggerServerEvent('io_chemicals:addItem', resultCompound, finalQuantity)
			TriggerServerEvent('io_chemicals:addChemicalLvl', "source", expQuantity)
		elseif notEnoughQuantity then
			exports.pNotify:SendNotification({text = "Has introducido pocos materiales y la mezcla no se ha podido sintentizar", type = "error", timeout = 4000, layout = "centerLeft"})
			TriggerServerEvent('io_chemicals:addChemicalLvl', "source", 0.5)
		else 
			exports.pNotify:SendNotification({text = "Te has pasado y el resultado es inútil", type = "error", timeout = 4000, layout = "centerLeft"})
			TriggerServerEvent('io_chemicals:addChemicalLvl', "source", 0.5)
		end
	else
		exports.pNotify:SendNotification({text = "La mezcla ha fallado", type = "error", timeout = 4000, layout = "centerLeft"})
		TriggerServerEvent('io_chemicals:addChemicalLvl', "source", 0.5)
	end
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    if Config.ShowBlips then
        ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(skills)
		    skillsquimicos = skills
		    skills = skills
		    if skills >= Config.minSkillToShowBlips then
			    createBlip()
		    end
	    end)
    end
end)

AddEventHandler('playerSpawned', function()
    Wait(3000)
    ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(skills)
		skillsquimicos = skills
        if Config.ShowBlips then
		    if skills >= Config.minSkillToShowBlips then
			    createBlip()
		    end
        end 
	end)
end)

AddEventHandler('onResourceStart', function(resource)
	while ESX == nil do
		Citizen.Wait(0)
	end

	ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(skills)
		skillsquimicos = skills
	end)
end)

RegisterNetEvent('io_chemicals:synthesize')
AddEventHandler('io_chemicals:synthesize', function(propLab)
	local objeto = options[propLab]
	ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(skills)
		local skills = skills

		if skills < 10 then
			ESX.ShowNotification('Para sintetizar quimicos tienes que estudiar quimica')
		elseif skills >= 10 and skills <= 100 then
			placeChemicalLab(propLab)
		end

	end)
end)

RegisterNetEvent('io_chemicals:addPureElement')
AddEventHandler('io_chemicals:addPureElement', function(element)
    local coords    = GetEntityCoords(PlayerPedId())
	local forward   = GetEntityForwardVector(PlayerPedId())
	local x, y, z   = table.unpack(coords + forward * 1.0)
    ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(chemical)
        if chemical > 0 and chemical <= 20 then
         	cantidad = math.random(17,42)
	elseif chemical > 20 and chemical <= 60 then
		cantidad = math.random(17, 39)
	elseif chemical > 60 and chemical <= 90 then
		cantidad = math.random(17, 36)
	elseif chemical > 90 then
		cantidad = 33
	end

        for propsLab in pairs(options) do
            local objetoquimico = GetClosestObjectOfType(x, y, z, 1.0, GetHashKey(propsLab), false, true, true)
        end

        for k, v in pairs(chemicalPureItems) do
            if element == v.element then
                if v.chemicalSymbol == chemicals[k].symbol then
			chemicals[k].value = chemicals[k].value + cantidad
			addArrayPure(v.element, v.chemicalSymbol, chemicals[k].value)
		end
            end
        end
    end)
end)

RegisterNetEvent('io_chemicals:addCompound')
AddEventHandler('io_chemicals:addCompound', function(compound)
    local coords    = GetEntityCoords(PlayerPedId())
	local forward   = GetEntityForwardVector(PlayerPedId())
	local x, y, z   = table.unpack(coords + forward * 1.0)
    ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(chemical)
        if chemical > 0 and chemical <= 20 then
            cantidad = math.random(17,42)
		elseif chemical > 20 and chemical <= 60 then
			cantidad = math.random(17, 39)
		elseif chemical > 60 and chemical <= 90 then
			cantidad = math.random(17, 36)
		elseif chemical > 90 then
			cantidad = 33
		end

        for propsLab in pairs(options) do
            local objetoquimico = GetClosestObjectOfType(x, y, z, 1.0, GetHashKey(propsLab), false, true, true)
        end

        for k, v in pairs(chemicalCompoundItems) do 
        end
    end)
end)
