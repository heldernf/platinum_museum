-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
South = {}
Tunnel.bindInterface("hud", South)
vSERVER = Tunnel.getInterface("hud")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Display = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Road = ""
local Gemstone = 0
local Crossing = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Health = 999
local Armour = 999
-----------------------------------------------------------------------------------------------------------------------------------------
-- THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
local Thirst = 999
local ThirstTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
local Hunger = 999
local HungerTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
local Stress = 0
local StressTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
local Wanted = 0
local WantedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
local Reposed = 0
local ReposedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
local Luck = 0
local LuckTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
local Dexterity = 0
local DexterityTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()

			if Display then
				local Coords = GetEntityCoords(Ped)
				local Armouring = GetPedArmour(Ped)
				local Healing = GetEntityHealth(Ped) - 100
				local MinRoad, MinCross = GetStreetNameAtCoord(Coords["x"], Coords["y"], Coords["z"])
				local FullRoad = GetStreetNameFromHashKey(MinRoad)
				local FullCross = GetStreetNameFromHashKey(MinCross)

				if Health ~= Healing then
					if Healing < 0 then
						Healing = 0
					end

					SendNUIMessage({ Action = "Health", Number = Healing })
					Health = Healing
				end

				if Armour ~= Armouring then
					SendNUIMessage({ Action = "Armour", Number = Armouring })
					Armour = Armouring
				end

				if FullRoad ~= "" and Road ~= FullRoad then
					SendNUIMessage({ Action = "Road", Name = FullRoad })
					Road = FullRoad
				end

				if FullCross ~= "" and Crossing ~= FullCross then
					SendNUIMessage({ Action = "Crossing", Name = FullCross })
					Crossing = FullCross
				end

				SendNUIMessage({ Action = "Clock", Hours = GlobalState["Hours"], Minutes = GlobalState["Minutes"] })
			end

			if Luck > 0 and LuckTimer <= GetGameTimer() then
				Luck = Luck - 1
				LuckTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Luck", Number = Luck })
			end

			if Dexterity > 0 and DexterityTimer <= GetGameTimer() then
				Dexterity = Dexterity - 1
				DexterityTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Dexterity", Number = Dexterity })
			end

			if Wanted >= 0 and WantedTimer <= GetGameTimer() then
				Wanted = Wanted - 1
				WantedTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Wanted", Number = Wanted })
			end

			if Reposed > 0 and ReposedTimer <= GetGameTimer() then
				Reposed = Reposed - 1
				ReposedTimer = GetGameTimer() + 1000
				SendNUIMessage({ Action = "Reposed", Number = Reposed })
			end

			if HungerTimer <= GetGameTimer() then
				HungerTimer = GetGameTimer() + 10000

				if Hunger < 25 and GetEntityHealth(Ped) > 100 then
					ApplyDamageToPed(Ped, math.random(2), false)
					TriggerEvent("Notify", "hunger", "Sofrendo de fome.", 2500)
				end
			end

			if ThirstTimer <= GetGameTimer() then
				ThirstTimer = GetGameTimer() + 10000

				if Thirst < 25 and GetEntityHealth(Ped) > 100 then
					ApplyDamageToPed(Ped, math.random(2), false)
					TriggerEvent("Notify", "thirst", "Sofrendo de sede.", 2500)
				end
			end

			if StressTimer <= GetGameTimer() then
				StressTimer = GetGameTimer() + 10000

				if Stress >= 25 and GetEntityHealth(Ped) > 100 then
					ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 0.20)
					SetTimeout(2500, function()
						ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 0.20)
					end)
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Passport")
AddEventHandler("hud:Passport", function(Number)
	SendNUIMessage({ Action = "Passport", Number = Number })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voip")
AddEventHandler("hud:Voip", function(Number)
	local Target = { "Baixo", "Normal", "Médio", "Alto", "Megafone" }

	SendNUIMessage({ Action = "Voip", Voip = Target[Number] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voice")
AddEventHandler("hud:Voice", function(Status)
	SendNUIMessage({ Action = "Voice", Status = Status and true or false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Wanted")
AddEventHandler("hud:Wanted", function(Seconds)
	Wanted = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted", function()
	return Wanted > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Reposed")
AddEventHandler("hud:Reposed", function(Seconds)
	Reposed = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Reposed",function()
	return Reposed > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active", function(Status)
	SendNUIMessage({ Action = "Body", Status = Status })
	Display = Status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud", function()
	Display = not Display
	SendNUIMessage({ Action = "Body", Status = Display })

	if not Display then
		if IsMinimapRendering() then
			DisplayRadar(false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress", function(Message, Timer)
	SendNUIMessage({ Action = "Progress", Message = Message, Timer = Timer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected", function()
	SendNUIMessage({ Action = "Voip", Voip = "Online" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected", function()
	SendNUIMessage({ Action = "Voip", Voip = "Offline" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst", function(Number)
	if Thirst ~= Number then
		SendNUIMessage({ Action = "Thirst", Number = Number })
		Thirst = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger", function(Number)
	if Hunger ~= Number then
		SendNUIMessage({ Action = "Hunger", Number = Number })
		Hunger = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Stress")
AddEventHandler("hud:Stress", function(Number)
	if Stress ~= Number then
		SendNUIMessage({ Action = "Stress", Number = Number })
		Stress = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Luck")
AddEventHandler("hud:Luck", function(Seconds)
	Luck = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Dexterity")
AddEventHandler("hud:Dexterity", function(Seconds)
	Dexterity = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ADDGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:AddGems")
AddEventHandler("hud:AddGems", function(Number)
	Gemstone = Gemstone + Number

	SendNUIMessage({ Action = "Gemstone", Number = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveGems")
AddEventHandler("hud:RemoveGems", function(Number)
	Gemstone = Gemstone - Number

	if Gemstone < 0 then
		Gemstone = 0
	end

	SendNUIMessage({ Action = "Gemstone", Number = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio", function(Frequency)
	if type(Frequency) == "number" then
		SendNUIMessage({ Action = "Frequency", Frequency = Frequency .. " MHz" })
	else
		SendNUIMessage({ Action = "Frequency", Frequency = Frequency })
	end
end)
