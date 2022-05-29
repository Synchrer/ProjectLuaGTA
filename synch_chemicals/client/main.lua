ESX = nil
local skillsquimicos = 0
local chemicals = {}
local textOutput = {}

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

    for i=1, #textOutput do
        if string.sub(textOutput[i], 5, 6) == string.sub(text, 5, 6) then
            textOutput[i] = text
        end
    end
end

function placeChemicalLab(propLab)
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
				crecimiento = crecimiento + 0.1
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

local chemicalsReceived = {}
local chemicalsOrderReceived = {}
function checkRecipe(chemicals)

	for k, v in pairs(chemicals) do
		table.insert(chemicalsReceived, v.symbol)

		if string.len(v.symbol) ~= 1 then 
			table.insert(chemicalsOrderReceived, string.byte(v.symbol) + 0.1)
		else
			table.insert(chemicalsOrderReceived, string.byte(v.symbol))
		end
		
	end

	table.sort(chemicalsOrderReceived)

	for clave, valor in pairs(chemicalCompoundItems) do
		--print(chemicalsOrderReceived[1], chemicalsOrderReceived[2],"-", valor.components[1], valor.components[2])
		local encaja = true

		if #chemicalsOrderReceived == #valor.components then
			local final = true
			local cont = 1
			while final do
				if chemicalsOrderReceived[cont] ~= valor.components[cont] then
					final = false
					encaja = false
				end
				cont = cont + 1
				if #chemicalsOrderReceived < cont then final = false end
			end
		else
			encaja = false
		end

		if encaja then
			print("es esta mezcla")
		else
			print("necesito ")
		end
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
        if chemical > 0 and chemical < 20 then
            cantidad = math.random(17, 38)
		elseif chemical > 20 and chemical <= 60 then
			cantidad = math.random(17, 32)
		elseif chemical > 60 and chemical <= 90 then
			cantidad = math.random(17, 28)
		elseif chemical > 90 then
			cantidad = 25
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

--[[
RegisterNetEvent('io_chemicals:addCompound')
AddEventHandler('io_chemicals:addCompound', function(compound)
    local coords    = GetEntityCoords(PlayerPedId())
	local forward   = GetEntityForwardVector(PlayerPedId())
	local x, y, z   = table.unpack(coords + forward * 1.0)
    ESX.TriggerServerCallback('io_chemicals:getSkillChemicals', function(chemical)
        if chemical <= 10 then
			cantidad = math.random(17, 38)
		elseif chemical > 20 and chemical <= 60 then
			cantidad = math.random(17, 32)
		elseif chemical > 60 and chemical <= 90 then
			cantidad = math.random(17, 28)
		elseif chemical > 90 then
			cantidad = 25
		end

        for propsLab in pairs(options) do
            local objetoquimico = GetClosestObjectOfType(x, y, z, 1.0, GetHashKey(propsLab), false, true, true)
        end

        for k, v in pairs(chemicalCompoundItems) do 
        end
    end)
end)
]]