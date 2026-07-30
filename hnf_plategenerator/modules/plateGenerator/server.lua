local _HNF = HNF

local allValidCharacters = _HNF.Config.plate.allowedCharacters.letters .. _HNF.Config.plate.allowedCharacters.numbers
local function generatePlate()
    local plate = ""

    for i = 1, #_HNF.Config.plate.characterPositions do
        if _HNF.Config.plate.characterPositions[i] == false then
            local randomIndex = math.random(1, #allValidCharacters)
            plate = plate .. allValidCharacters:sub(randomIndex, randomIndex)
        elseif _HNF.Config.plate.characterPositions[i] == " " then
            plate = plate .. " "
        else
            local characterType = not tonumber(_HNF.Config.plate.characterPositions[i]) and "letters" or "numbers"
            local randomIndex = math.random(1, #_HNF.Config.plate.allowedCharacters[characterType])
            plate = plate .. _HNF.Config.plate.allowedCharacters[characterType]:sub(randomIndex, randomIndex)
        end
    end

    return plate
end

local function thisPlateExistsInDatabase(plate)
    local result = MySQL.query.await(("SELECT 1 FROM %s WHERE plate = ?"):format(_HNF.Config.playerVehiclesTableName), { plate })
    return #result > 0
end

local function thisPlateExistsInVehiclesSpawnedInTheCity(plate)
    for _, vehicleEntity in pairs(GetAllVehicles()) do
        if GetVehicleNumberPlateText(vehicleEntity) == plate then
            return true
        end
    end
end

function HNF.GFunctions.generateUniquePlate()
    while true do
        local plate = generatePlate()
        if not thisPlateExistsInDatabase(plate) and not thisPlateExistsInVehiclesSpawnedInTheCity(plate) then
            return plate
        end

        Wait(0)
    end
end
local generateUniquePlate = HNF.GFunctions.generateUniquePlate
exports("GenerateUniquePlate", generateUniquePlate)