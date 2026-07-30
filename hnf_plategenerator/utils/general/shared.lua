function HNF.Utils.getVehicleRear(vehicle)
    local minDimension = GetModelDimensions(GetEntityModel(vehicle))
    return GetOffsetFromEntityInWorldCoords(vehicle, 0.0, minDimension.y, 0.0)
end

function HNF.Utils.vectorOffset(coords, heading, amountOffset)
    local radioHeading = math.rad(heading)
    local offset = { x = math.cos(radioHeading) * amountOffset, y = math.sin(radioHeading) * amountOffset }
    return vec3(coords.x + offset.x, coords.y + offset.y, coords.z)
end