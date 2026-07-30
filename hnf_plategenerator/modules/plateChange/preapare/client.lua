local _HNF = HNF
if not _HNF.Config.changePlate.enablePlateChangeWithItem then return end

local function getVehicleDataByNearestRearPlate(nearbyVehicles, playerCoords)
    local vehicleData = nearbyVehicles[1]
    vehicleData.rearPlateCoords = _HNF.Utils.getVehicleRear(nearbyVehicles[1].vehicle)

    for i = 2, #nearbyVehicles do
        local vehicleRear = _HNF.Utils.getVehicleRear(nearbyVehicles[i].vehicle)

        if #(vehicleRear.xyz - playerCoords.xyz) < #(vehicleData.rearPlateCoords.xyz - playerCoords.xyz) then
            vehicleData = nearbyVehicles[i]
            vehicleData.rearPlateCoords = vehicleRear
        end
    end

    return vehicleData
end

local function monitorInteractZoneInVehicleRear(nearestVehicle, playerPed)
    if not DoesEntityExist(nearestVehicle.vehicle) or not DoesEntityExist(playerPed) then return end

    local playerCoords = GetEntityCoords(playerPed)
    if #(_HNF.Utils.getVehicleRear(nearestVehicle.vehicle).xy - nearestVehicle.rearPlateCoords.xy) > 0.05 or #(playerCoords.xy - nearestVehicle.coords.xy) > _HNF.Config.changePlate.vehicleDetectionRange then
        return
    end

    return true
end

local usingItem
local function __chagePlate(nearestVehicle, playerPed)
    local success, result = pcall(_HNF.GFunctions.changePlate, nearestVehicle, playerPed)
    FreezeEntityPosition(playerPed, false)
    usingItem = false

    if not result then
        TriggerEvent("esx:showNotification", _HNF.Locales.general.plateWasNotApplied, "error")
        HNF.GFunctions.refundPlateItem()
    end
end

local function createInteractZoneInVehicleRear(nearestVehicle, playerPed)
    local changePlateZone, interected
    changePlateZone = lib.zones.sphere({
        coords = vec3(nearestVehicle.rearPlateCoordsWithOffset.x, nearestVehicle.rearPlateCoordsWithOffset.y, GetEntityCoords(nearestVehicle.vehicle).z + 0.5),
        radius = 0.7,
        inside = function()
            ESX.ShowHelpNotification(_HNF.Locales.general.changePlate, "E")

            if IsControlJustReleased(0, 38) then
                usingItem = true
                CreateThread(function() __chagePlate(nearestVehicle, playerPed) end)
                interected = true
            end
        end,
        debug = false
    })

    local markerCoords = vec3(nearestVehicle.rearPlateCoordsWithOffset.x, nearestVehicle.rearPlateCoordsWithOffset.y, nearestVehicle.rearPlateCoordsWithOffset.z - 1.0)
    local marker = lib.marker.new({ type = 1, coords = markerCoords, width = 0.7 * 2, color = { r = 255, g = 255, b = 0, a = 165 }})
    while not interected and monitorInteractZoneInVehicleRear(nearestVehicle, playerPed) do
        marker:draw()
        if IsControlJustReleased(0, 252) then break end
        Wait(0)
    end
    if changePlateZone then changePlateZone:remove() end

    return interected
end

local function usePlateItem(itemData)
    local playerPed = cache.ped
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyVehicles = lib.getNearbyVehicles(playerCoords, _HNF.Config.changePlate.vehicleDetectionRange, true)
    if #nearbyVehicles == 0 then return end
    exports.ox_inventory:useItem(itemData)

    local nearestVehicle = getVehicleDataByNearestRearPlate(nearbyVehicles, playerCoords)
    nearestVehicle.rearPlateCoordsWithOffset = _HNF.Utils.vectorOffset(nearestVehicle.rearPlateCoords, GetEntityHeading(nearestVehicle.vehicle) + 90, -0.25)

    if not createInteractZoneInVehicleRear(nearestVehicle, playerPed) then
        HNF.GFunctions.refundPlateItem()
    end
end

local running, itemPlateName
exports("UsePlateItem", function(data, slot)
    if running or usingItem then return end
    running = true

    if not itemPlateName then itemPlateName = data.name end

    pcall(usePlateItem, data)

    running = false
end)

function HNF.GFunctions.refundPlateItem()
    TriggerServerEvent("hnf_plategenerator:RefundPlateItem", itemPlateName)
end