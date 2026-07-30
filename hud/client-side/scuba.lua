-- by heldernf
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Mask = nil
local Tank = nil
local Scubaequip = false
local OxygenNoScuba = 10.0 -- SEGUNDOS
local OxygenWithScuba = 1200.0 -- SEGUNDOS
local GetOxygenScuba = false
local OxygenValue = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SCUBAREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:ScubaRemove")
AddEventHandler("hud:ScubaRemove",function()
	if DoesEntityExist(Mask) then
		TriggerServerEvent("DeleteObject",ObjToNet(Mask))
		Mask = nil
	end

	if DoesEntityExist(Tank) then
		TriggerServerEvent("DeleteObject",ObjToNet(Tank))
		Tank = nil
	end

	SetEnableScuba(PlayerPedId(),false)
	SetPedMaxTimeUnderwater(PlayerPedId(),OxygenNoScuba)

	Scubaequip = false
	SendNUIMessage({ Action = "Oxygen",  Number = OxygenValue, Scubaequip = Scubaequip })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Scuba")
AddEventHandler("hud:Scuba",function()
	if Mask or Tank then
		TriggerServerEvent("hud:SetOxygenScuba", OxygenValue)
		TriggerEvent("hud:ScubaRemove")
	else
		-- PEGA O VALOR DO OXIGÊNIO DA SCUBA NO DB
		if GetOxygenScuba == false then
			TriggerServerEvent("hud:GetOxygenScuba", source)
		else -- SE ELE JA TIVER PEGO UMA VEZ, NÃO IRÁ ACESSAR O DB NOVAMENTE PROCURANTO O VALOR
			initScuba()
		end
	end
end)

RegisterNetEvent("hud:ReceiveOxygenScuba")
AddEventHandler("hud:ReceiveOxygenScuba",function(value)
	OxygenValue = value
	GetOxygenScuba = true
	initScuba()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITSCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
function initScuba ()
	local player = PlayerId()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	-- Verifica se o número já possui um ponto decimal
	local OxygenValueStr = tostring(OxygenValue)
	if not string.find(OxygenValueStr, "%.") then
		OxygenValueStr = string.format("%.1f", OxygenValue)
	end
	OxygenValue = tonumber(OxygenValueStr)

	SetEnableScuba(Ped,true)
	SetPedMaxTimeUnderwater(Ped,OxygenValue)
	Scubaequip = true
	------------------------------------------------------------------------
	------------------------ SETA OS PROPS DA SCUBA ------------------------
	------------------------------------------------------------------------
	local Progression,Network = vRPS.CreateObject("p_s_scuba_tank_s",Coords["x"],Coords["y"],Coords["z"])
	if Progression then
		Tank = LoadNetwork(Network)
		AttachEntityToEntity(Tank,Ped,GetPedBoneIndex(Ped,24818),-0.28,-0.24,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
	end

	local Progression,Network = vRPS.CreateObject("p_s_scuba_mask_s",Coords["x"],Coords["y"],Coords["z"])
	if Progression then
		Mask = LoadNetwork(Network)
		AttachEntityToEntity(Mask,Ped,GetPedBoneIndex(Ped,12844),0.0,0.0,0.0,180.0,90.0,0.0,1,1,0,0,2,1)
	end
	------------------------------------------------------------------------
	-------------------- ATUALIZAÇÃO DO OXIGÊNIO NA NUI --------------------
	------------------------------------------------------------------------
	while Scubaequip do
		if LocalPlayer["state"]["Active"] then
			player = PlayerId()
			if player and IsPedSwimmingUnderWater(Ped) and OxygenValue > 0.0 then
				OxygenValue = GetPlayerUnderwaterTimeRemaining(player)
			elseif OxygenValue <= 0.0 and not IsPedSwimmingUnderWater(Ped) then -- SE TIVER SEM O2 E NÃO ESTIVER NADANDO
				SetPedMaxTimeUnderwater(Ped,OxygenNoScuba)
			end
			SendNUIMessage({ Action = "Oxygen",  Number = OxygenValue, Scubaequip = Scubaequip, TimeInWater = OxygenWithScuba })
		end
		Wait(1000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SCUBARECHARGECLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:ScubaRechargeClient")
AddEventHandler("hud:ScubaRechargeClient", function(TargetSource, TargetPassport, Value)
    local Ped = PlayerPedId()
    if tonumber(Value) >= 0 and tonumber(Value) <= OxygenWithScuba then
        OxygenValue = tonumber(Value) * OxygenWithScuba / 100 -- O 'value' DEVE SER DE 0 - 100 QUE ELE IRÁ CALCULAR O QUANTO É 100 DE ACORDO COM O VALOR QUE ESTÁ NO 'OxygenWithScuba'
        if OxygenValue then
            SetPedMaxTimeUnderwater(Ped, OxygenValue)
            TriggerServerEvent("hud:SetOxygenScuba", OxygenValue, TargetPassport)
        end
    end
end)