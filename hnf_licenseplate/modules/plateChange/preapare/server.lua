RegisterNetEvent("hnf_plategenerator:RefundPlateItem", function(itemName)
    exports.ox_inventory:AddItem(1, itemName, 1)
end)
