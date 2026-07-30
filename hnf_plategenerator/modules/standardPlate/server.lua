local _HNF = HNF
if not _HNF.Config.allVehiclesWithStandardizedPlate then return end

AddEventHandler("entityCreated", function(entity)
    if DoesEntityExist(entity) and GetEntityType(entity) == 2 then
        SetVehicleNumberPlateText(entity, _HNF.GFunctions.generateUniquePlate())
    end
end)