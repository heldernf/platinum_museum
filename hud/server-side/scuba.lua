-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:GETOXYGENSCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("hud:GetOxygenScuba")
AddEventHandler("hud:GetOxygenScuba",function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Datatable = vRP.Query("hud/GetData", { Id = Passport })
        if Datatable and #Datatable > 0 then
            local Oxygen = Datatable[1].ScubaOxygen
            TriggerClientEvent("hud:ReceiveOxygenScuba", source, Oxygen)
        else
            local Oxygen = 0.0
            TriggerClientEvent("hud:ReceiveOxygenScuba", source, Oxygen)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SETOXYGENSCUBA	
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("hud:SetOxygenScuba")
AddEventHandler("hud:SetOxygenScuba",function(Value, TargetPassport)
    local SetPassport = nil
    if TargetPassport == nil then -- PARA QUANDO O PLAYER DESEQUIPA A SCUBA
        local source = source
        local Passport = vRP.Passport(source)
        if Passport then
            SetPassport = Passport
        end
    else -- PARA QUANDO O PLAYER RECARREGA A SCUBA
        SetPassport = TargetPassport
    end

    if SetPassport > 0 then
        local Datatable = vRP.Query("hud/GetData", { Id = SetPassport })
        if Datatable then
            if Value < 0.0 then
                Value = 0.0
            end
            vRP.Query("hud/SetData", { Id = SetPassport, ScubaOxygen = Value })
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SCUBARECHARGE	
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:ScubaRecharge")
AddEventHandler("hud:ScubaRecharge", function(TargetSource, TargetPassport, Value)
    TriggerClientEvent("hud:ScubaRechargeClient", TargetSource, TargetSource, TargetPassport, Value)
end)