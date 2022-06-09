ESX = nil
local skillsquimicos = 0
local chemicals = {}
local compounds = {}
local textOutput = {}
local textOutputCompounds = {}
local centrifugedChemicals = {}
local centrifugedChemicalsOrdered = {}
local centrifugedCompounds = {}
local fallo = false
local labPlace = false

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

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

function exportsProgressBars(msg, time)
    exports['progressBars']:startUI(time, msg)
end

function addArrayPure(symbol, value) 
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

function addArrayCompound(symbol, value) 
	text = '~w~[' .. symbol .. ': ' .. value .. '%~w~] '

	if value > 100 then
		fallo = true
	end

    for i=1, #textOutputCompounds do
        if string.sub(textOutputCompounds[i], 5, 7) == string.sub(text, 5, 7) then
            textOutputCompounds[i] = text
        end
    end
end

if Config.TesterMode then
	RegisterCommand('testLab', function(source)
		placeChemicalLab('tanque_quimico')
	end)
end

function placeChemicalLab(propLab)
	labPlace = true
	chemicals = {}
	compounds = {}
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

	for i=1, #chemicalCompoundItems do
		table.insert(compounds, {item = container, compound = chemicalCompoundItems[i].compound, value = chemicalCompoundItems[i].value, symbol = chemicalCompoundItems[i].chemicalSymbol, posi = chemicalCompoundItems[i].pos})
	end

    	writeChemical(container, object.name)
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

	for k, v in pairs(compounds) do
        	if v.item == container then
            		text = '~w~[' .. v.symbol .. ': ' .. v.value .. '%~w~] '
            		textOutputCompounds[k] = text
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
				crecimiento = crecimiento + 0.05
			end

			if distance < 5 then
				texto = nombre .. '~r~ ' ..  math.ceil(crecimiento) .. '%\n '

				for i=1, #textOutput do				    
					if chemicals[i].value >= 1 then
						flag = true
						texto = texto .. textOutput[i]
					end
				end

				for i=1, #textOutputCompounds do				    
					if compounds[i].value >= 1 then
						flag = true
						texto = texto .. textOutputCompounds[i]
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
					labPlace = false
					DisableControlAction(0, 38, true)
					
					if Config.TesterMode then
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

					local compoundsUsed = 1
					while compoundsUsed <= #compounds do
						if compounds[compoundsUsed].value == 0 then
							table.remove(compounds, compoundsUsed)
						else
							compoundsUsed = compoundsUsed + 1
						end
					end

					if #chemicals > 0 and #compounds > 0 then
						exports.pNotify:SendNotification({text = "La mezcla ha fallado, has introducido químicos incorrectos", type = "error", timeout = 4000, layout = "centerLeft"})
						if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.05) end

						for k, v in pairs(chemicals) do
							if v.item == container then
								ESX.Game.DeleteObject(v.item)
							end
						end

						for a, b in pairs(compounds) do
							if b.item == container then
								ESX.Game.DeleteObject(b.item)
							end
						end
						break

					elseif #compounds > 0 then

						for k, v in pairs(compounds) do
							if v.item == container then
								ESX.Game.DeleteObject(v.item)
							end
						end
						checkFinalRecipes(compounds)
						break
					end

					for k, v in pairs(chemicals) do
						if v.item == container then
							ESX.Game.DeleteObject(v.item)
						end
					end
					checkRecipes(chemicals)
					break
				end
			end
		end
	end		
end

function checkRecipes(chemicals)
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
	local finalQuantity = 2
	local expQuantity = 0.1

	for key, value in pairs(chemicalCompoundItems) do
		if #centrifugedChemicalsOrdered == #value.components then
			if #centrifugedChemicalsOrdered == 2 then
				if centrifugedChemicalsOrdered[1] == value.components[1] and centrifugedChemicalsOrdered[2] == value.components[2] then
					encaja = true
					resultCompound = value.compound

					if chemicals[1].value >= 99 and chemicals[2].value >= 99 then
						finalQuantity = 4
						expQuantity = 0.15
					elseif chemicals[1].value >= 85 and chemicals[2].value >= 85 and (chemicals[1].value < 99 or chemicals[2].value < 99) then
						finalQuantity = 3
						expQuantity = 0.12
					elseif chemicals[1].value < 50 or chemicals[2].value < 50 then
						notEnoughQuantity = true
					end

				end			
			elseif #centrifugedChemicalsOrdered == 3 then
				if centrifugedChemicalsOrdered[1] == value.components[1] and centrifugedChemicalsOrdered[2] == value.components[2] and centrifugedChemicalsOrdered[3] == value.components[3] then
					encaja = true
					resultCompound = value.compound

					if chemicals[1].value >= 99 and chemicals[2].value >= 99 and chemicals[3].value >= 99 then
						finalQuantity = 4
						expQuantity = 0.18
					elseif chemicals[1].value >= 85 and chemicals[2].value >= 85 and chemicals[3].value >= 85 and (chemicals[1].value < 99 or chemicals[2].value < 99 or chemicals[3].value < 99) then
						finalQuantity = 3
						expQuantity = 0.15
					elseif chemicals[1].value < 50 or chemicals[2].value < 50 or chemicals[3].value < 50 then
						notEnoughQuantity = true
					end

				end
			end
		end
	end

	if encaja then
		if not fallo and not notEnoughQuantity then		
			TriggerServerEvent('io_chemicals:addItem', resultCompound, finalQuantity)
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', expQuantity) end
		elseif notEnoughQuantity then
			exports.pNotify:SendNotification({text = "Has introducido pocos materiales y la mezcla no se ha podido sintentizar", type = "error", timeout = 4000, layout = "centerLeft"})
			if Config.SkillSystem then  TriggerServerEvent('io_chemicals:addChemicalLvl', 0.04) end
			fallo = false
			notEnoughQuantity = false
		else 
			exports.pNotify:SendNotification({text = "Te has pasado y el resultado es inútil", type = "error", timeout = 4000, layout = "centerLeft"})
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.04) end
			fallo = false
			notEnoughQuantity = false
		end
	else
		exports.pNotify:SendNotification({text = "La mezcla ha fallado", type = "error", timeout = 4000, layout = "centerLeft"})
		if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.05) end
		fallo = false
		notEnoughQuantity = false
	end
end

function checkFinalRecipes(compounds)
	centrifugedCompounds = {}
	local finalResult = ''

	for k, v in pairs(compounds) do
		print(v.posi)
		table.insert(centrifugedCompounds, v.posi)
	end

	table.sort(centrifugedCompounds)
	
	local encaja = false
	local notEnoughQuantity = false
	local finalQuantity = 2
	local expQuantity = 0.1

	for key, value in pairs(finalItems) do
		if #centrifugedCompounds == #value.components then
			if #centrifugedCompounds == 1 then	
				if centrifugedCompounds[1] == value.components[1] then				
					encaja = true
					finalResult = value.final

					if compounds[1].value >= 99 then
						finalQuantity = 4
						expQuantity = 0.16
					elseif compounds[1].value >= 85 and (compounds[1].value < 99) then
						finalQuantity = 3
						expQuantity = 0.15
					elseif compounds[1].value < 50 then
						notEnoughQuantity = true
					end

				end
			elseif #centrifugedCompounds == 2 then
				if centrifugedCompounds[1] == value.components[1] and centrifugedCompounds[2] == value.components[2] then
					encaja = true
					finalResult = value.final

					if compounds[1].value >= 99 and compounds[2].value >= 99 then
						finalQuantity = 4
						expQuantity = 0.18
					elseif compounds[1].value >= 85 and compounds[2].value >= 85 and (compounds[1].value < 99 or compounds[2].value < 99) then
						finalQuantity = 3
						expQuantity = 0.17
					elseif compounds[1].value < 50 or compounds[2].value < 50 then
						notEnoughQuantity = true
					end

				end			
			elseif #centrifugedCompounds == 3 then
				if centrifugedCompounds[1] == value.components[1] and centrifugedCompounds[2] == value.components[2] and centrifugedCompounds[3] == value.components[3] then
					encaja = true
					finalResult = value.final

					if compounds[1].value >= 99 and compounds[2].value >= 99 and compounds[3].value >= 99 then
						finalQuantity = 4
						expQuantity = 0.20
					elseif compounds[1].value >= 85 and compounds[2].value >= 85 and compounds[3].value >= 85 and (compounds[1].value < 99 or compounds[2].value < 99 or compounds[3].value < 99) then
						finalQuantity = 3
						expQuantity = 0.19
					elseif compounds[1].value < 50 or compounds[2].value < 50 or compounds[3].value < 50 then
						notEnoughQuantity = true
					end

				end
			end
		end
	end

	if encaja then
		if not fallo and not notEnoughQuantity then		
			TriggerServerEvent('io_chemicals:addItem', finalResult, finalQuantity)
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', expQuantity) end
		elseif notEnoughQuantity then
			exports.pNotify:SendNotification({text = "Has introducido pocos compuestos y la mezcla no se ha podido sintentizar", type = "error", timeout = 4000, layout = "centerLeft"})
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.05) end
			fallo = false
			notEnoughQuantity = false
		else 
			exports.pNotify:SendNotification({text = "Te has pasado y el resultado es inútil", type = "error", timeout = 4000, layout = "centerLeft"})
			if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.04) end
			fallo = false
			notEnoughQuantity = false
		end
	else
		exports.pNotify:SendNotification({text = "La mezcla ha fallado", type = "error", timeout = 4000, layout = "centerLeft"})
		if Config.SkillSystem then TriggerServerEvent('io_chemicals:addChemicalLvl', 0.04) end
		fallo = false
		notEnoughQuantity = false
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
			if not labPlace then
				placeChemicalLab(propLab) 
			else
				ESX.ShowNotification('No puedes tener dos laboratorios al mismo tiempo. Solo puede realizar una mezcla al mismo tiempo')
			end																	
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
			addArrayPure(v.chemicalSymbol, chemicals[k].value)
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
			if compound == v.compound then
                if v.chemicalSymbol == compounds[k].symbol then
			compounds[k].value = compounds[k].value + cantidad
			addArrayCompound(v.chemicalSymbol, compounds[k].value)
		end
            end
        end
    end)
end)
