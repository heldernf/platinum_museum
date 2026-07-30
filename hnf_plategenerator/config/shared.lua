local Config = {}

Config.locale = "es"

Config.plate = {
    -- Allowed letters and numbers in the plates generated
    allowedCharacters = {
        letters = "BCDEFGHIJKLMNOPQRSTUVWXYZ",
        numbers = "0123456789",
    },

    -- Character Positions Configuration
    --  Rules:
    --    "A-Z" represents a **letter** (A-Z)
    --    "0-9" represents a **number** (0-9)
    --    " " (space) is allowed
    --    false → The character at this position will be **random**, either a letter or a number, chosen from `allowedCharacters`
    --    **!MAX 8 CHARACTERS**
    characterPositions = { "1", "2", "3", "4", " ", "A", "B", "C" }
}

-- All spawned vehicles will have their license plate as per **characterPositions**
Config.allVehiclesWithStandardizedPlate = true

-- Name of the table where the players' vehicles are stored
Config.playerVehiclesTableName = "owned_vehicles"

-- Item to change a vehicle's license plate
Config.changePlate = {
    enablePlateChangeWithItem = true,
    vehicleDetectionRange = 5.0,
    animations = {
        choosingPlate = {
            dict = "amb@world_human_guard_patrol@male@idle_b",
            name = "idle_e",
        },
        changingPlate = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            name = "machinic_loop_mechandplayer",
            duration = 4000
        }
    },
}

return Config