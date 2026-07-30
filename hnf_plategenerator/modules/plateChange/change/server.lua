local _HNF = HNF
if not _HNF.Config.changePlate.enablePlateChangeWithItem then return end

local function plateHasChanged(newPlate, vehicleEntity)
    local timeout = GetGameTimer() + 1000
    while true do
        local vehiclePlate = GetVehicleNumberPlateText(vehicleEntity):gsub("^%s*(.-)%s*$", "%1")
        if vehiclePlate == newPlate then return true end

        if GetGameTimer() >= timeout then return end

        Wait(0)
    end
end

lib.callback.register("hnf_plategenerator:ChangeVehiclePlate", function(source, newPlate, vehicleNetId)
    newPlate = string.upper(newPlate)
    local vehicleEntity = NetworkGetEntityFromNetworkId(vehicleNetId)
    local oldPlate = GetVehicleNumberPlateText(vehicleEntity):gsub("^%s*(.-)%s*$", "%1")

    SetVehicleNumberPlateText(vehicleEntity, newPlate)
    if not plateHasChanged(newPlate, vehicleEntity) then return end
    TriggerClientEvent("esx:showNotification", source, _HNF.Locales.general.plateHasBeenapplied, "success")

    MySQL.update("UPDATE owned_vehicles SET plate = ? WHERE plate = ?", { newPlate, oldPlate })

    return true
end)