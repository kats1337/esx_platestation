lib.callback.register("kats_plates:checkAvailability", function(src, wantedPlate, change)
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerMoney = xPlayer.getMoney()

    if playerMoney < Config.PlateCheckCost then
        TriggerClientEvent("ox_lib:notify", src, {
            title = Config.Strings.NoMoney,
            description = (Config.Strings.NoMoneyDesc):format((Config.PlateCheckCost - playerMoney)),
            type = "error"
        })
        return
    end

    xPlayer.removeMoney(Config.PlateCheckCost)
    TriggerClientEvent("ox_lib:notify", src, {
        title = Config.Strings.ChargedForChecking,
        description = (Config.Strings.ChargedForCheckingDesc):format(Config.PlateCheckCost),
        type = "inform"
    })
    MySQL.query('SELECT plate FROM owned_vehicles WHERE plate = @plate', {['@plate'] = string.upper(tostring(wantedPlate))}, function(result)
        if json.encode(result) ~= "[]" then
            for k,v in pairs(result) do
                if v.plate == string.upper(tostring(wantedPlate)) then
                    TriggerClientEvent("ox_lib:notify", src, {
                        title = Config.Strings.PlateTaken,
                        description = Config.Strings.PlateTakenDesc,
                        type = "error"
                    })
                else
                    if not change then
                        TriggerClientEvent("ox_lib:notify", src, {
                            title = Config.Strings.PlateNotTaken,
                            description = Config.Strings.PlateNotTakenDesc,
                            type = "success"
                        })
                    end
                end
            end
        else
            if not change then
                TriggerClientEvent("ox_lib:notify", src, {
                    title = Config.Strings.PlateNotTaken,
                    description = Config.Strings.PlateNotTakenDesc,
                    type = "success"
                })
            end
        end
    end)
end)

lib.callback.register("kats_plates:changeVehiclePlate", function(src, vehNetID, plate)
	local xPlayer = ESX.GetPlayerFromId(src)
    local veh = NetworkGetEntityFromNetworkId(vehNetID)
    local currentPlate = GetVehicleNumberPlateText(veh)
    local playerMoney = xPlayer.getMoney()

    if playerMoney < Config.PlateCost then
        TriggerClientEvent("ox_lib:notify", src, {
            title = Config.Strings.NoMoney,
            description = (Config.Strings.NoMoneyDesc):format((Config.PlateCost - playerMoney)),
            type = "error"
        })
        return
    end

	MySQL.query('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = string.upper(tostring(currentPlate))
	}, function(result)
        if result ~= nil then
            for k,v in pairs(result) do
                if v.owner == xPlayer.identifier then
                    MySQL.update('UPDATE owned_vehicles SET `plate` = @newPlate WHERE owner = @owner AND plate = @oldPlate', {
                        ["@newPlate"] = string.upper(tostring(plate)),
                        ['@owner'] = xPlayer.identifier,
                        ['@oldPlate'] = string.upper(tostring(currentPlate))
                    }, function(rowsChanged)
                        if rowsChanged then
                            xPlayer.removeMoney(Config.PlateCost)
                            TriggerClientEvent("ox_lib:notify", src, {
                                title = Config.Strings.ChargedForChanging,
                                description = (Config.Strings.ChargedForChangingDesc):format(Config.PlateCost),
                                type = "inform"
                            })
                            SetVehicleNumberPlateText(veh, tostring(plate))
                        end
                    end)
                end
            end
        end
    end)
end)