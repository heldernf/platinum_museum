local function getCardinalDirection()
    local camRot = GetGameplayCamRot(2)
    local heading = math.fmod(camRot.z + 360, 360)

    local direction
    if (heading > 30 and heading <= 60) then
        direction = "Northwest"
    elseif (heading > 60 and heading <= 120) then
        direction = "West"
    elseif (heading > 120 and heading <= 150) then
        direction = "Southwest"
    elseif (heading > 150 and heading <= 210) then
        direction = "South"
    elseif (heading > 210 and heading <= 240) then
        direction = "Southeast"
    elseif (heading > 240 and heading <= 300) then
        direction = "East"
    elseif (heading > 300 and heading <= 330) then
        direction = "Northeast"
    elseif (heading > 330 or heading <= 30) then
        direction = "North"
    end

    return direction, heading
end

local runCardial
local function initCardial()
    CreateThread(function()
        local lastDirection
        runCardial = true
        while runCardial do
            local direction, heading = getCardinalDirection()

            if direction ~= lastDirection then
                lastDirection = direction
                SendNUIMessage({ action = "changeCardialDirection", direction = direction })
            end

            SendNUIMessage({ action = "changeCardialHeading", heading = heading })

            Wait(0)
        end
    end)
end

local function toggleCardial(toggle)
    if toggle then
        initCardial()
        SendNUIMessage({ action = "showCardial", direction = direction })
    else
        SendNUIMessage({ action = "hideCardial", direction = direction })
        runCardial = false
    end
end

local runing
RegisterCommand("cardinalpoints", function(source, args, raw)
    runing = not runing and true or false
    print(runing)
    toggleCardial(runing)
end)