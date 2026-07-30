-- Define o estilo de mapa
ModeMap = "Quadrado" -- (Quadrado | Redondo)
--------------------------------------------
if ModeMap == "Quadrado" then
    Quadrado = true
    Redondo = false
elseif ModeMap == "Redondo" then
    Quadrado = false
    Redondo = true
else -- Caso o ModeMap for inválido
    Quadrado = true
    Redondo = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAPA QUADRADO ---
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    if Quadrado then
        if LoadTexture("circleminimap") then
            AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circleminimap", "radarmasksm")

            SetMinimapComponentPosition("minimap", "L", "B", 0.005, -0.025, 0.175, 0.225)
            SetMinimapComponentPosition("minimap_mask", "L", "B", 0.02, 0.39, 0.1135, 0.5)
            SetMinimapComponentPosition("minimap_blur", "L", "B", -0.02, -0.01, 0.265, 0.225)

            SetBigmapActive(true, false)

            repeat
                Wait(100)
                SetMinimapClipType(1)
                SetBigmapActive(false, false)
            until not IsBigmapActive()

            while Quadrado do
                Wait(100)
                local Ped = PlayerPedId()
                local Vehicle = GetVehiclePedIsIn(Ped, false)

                if Vehicle ~= 0 then
                    local Velocidade = GetEntitySpeed(Vehicle) * 3.6

                    if Velocidade < 70 then
                        SetRadarZoom(1100)
                    else
                        SetRadarZoom(1100)
                    end
                else
                    SetRadarZoom(1100)
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MAPA REDONDO...
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    if Redondo then
        DisplayRadar(false)

        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Citizen.Wait(100)
        end

        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

        SetMinimapClipType(1)

        SetMinimapComponentPosition("minimap", "L", "B", 0.0, 0.0, 0.158, 0.28)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.155, 0.12, 0.080, 0.164)
        SetMinimapComponentPosition("minimap_blur", "L", "B", -0.005, 0.021, 0.240, 0.302)

        SetBigmapActive(true, false)

        repeat
            Wait(100)
            SetMinimapClipType(1)
            SetBigmapActive(false, false)
        until not IsBigmapActive()

        while Redondo do
            Wait(100)
            local Ped = PlayerPedId()
            local Vehicle = GetVehiclePedIsIn(Ped, false)

            if Vehicle ~= 0 then
                local Velocidade = GetEntitySpeed(Vehicle) * 3.6

                if Velocidade < 70 then
                    SetRadarZoom(1100)
                else
                    SetRadarZoom(1100)
                end
            else
                SetRadarZoom(1100)
            end
        end
    end
end)