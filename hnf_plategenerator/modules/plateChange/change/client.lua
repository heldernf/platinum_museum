local _HNF = HNF
if not _HNF.Config.changePlate.enablePlateChangeWithItem then return end

local function alignPlayer(rearPlateCoords)
    TaskTurnPedToFaceCoord(playerPed, rearPlateCoords, 750)
    Wait(750)
    FreezeEntityPosition(playerPed, true)
end

local cfgChangePlate = _HNF.Config.changePlate
local function chooseNewPlate(playerPed)
    ESX.Streaming.RequestAnimDict(cfgChangePlate.animations.choosingPlate.dict)
    TaskPlayAnim(playerPed, cfgChangePlate.animations.choosingPlate.dict, cfgChangePlate.animations.choosingPlate.name, 1.0, 1.0, -1, 1, 0, false, false, false)

    local input = lib.inputDialog('Basic dialog', {
        { type = 'input', label = _HNF.Locales.plateChagingInputLabel, placeholder = "ABCD 123", required = true, min = 1, max = 8 },
    })

    ClearPedTasks(playerPed)
    return input
end

function HNF.GFunctions.changePlate(nearestVehicle, playerPed)
    CreateThread(function() alignPlayer(nearestVehicle.rearPlateCoords) end)

    local newPlate = chooseNewPlate(playerPed)
    if not newPlate then return end

    if lib.progressBar({
        duration = cfgChangePlate.animations.changingPlate.duration,
        label = _HNF.Locales.general.plateChaging,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            combat = false,
            sprint = false,
        },
        anim = {
            dict = cfgChangePlate.animations.changingPlate.dict,
            clip = cfgChangePlate.animations.changingPlate.name,
            flag = 1
        },
    }) then
        if DoesEntityExist(nearestVehicle.vehicle) then
            return lib.callback.await("hnf_plategenerator:ChangeVehiclePlate", false, newPlate[1], NetworkGetNetworkIdFromEntity(nearestVehicle.vehicle))
        end
    end
end