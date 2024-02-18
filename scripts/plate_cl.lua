local playerLoaded = nil

openChangePlate = function(vehNetID)
    lib.registerContext({
        id = 'vehiclePlateMenu',
        title = Config.Strings.PlateMenu,
        options = {
            {
                title = (Config.Strings.ChangePlateMenu):format(Config.PlateCost, Config.PlateCheckCost),
                icon = 'car',
                onSelect = function()

                    local input = lib.inputDialog((Config.Strings.ChangePlateMenu):format(Config.PlateCost, Config.PlateCheckCost), {Config.Strings.WritePlateText})
 
                    if not input then 
                        return 
                    end

                    local string = tostring(input[1])

                    if string.find(string, "%W+") then
                        lib.notify({
                            title = Config.Strings.SpecialChars,
                            description = Config.Strings.SpecialCharsDesc,
                            type = "error"
                        })
                        return
                    end

                    if string.len(string) < Config.MinLength then
                        lib.notify({
                            title = Config.Strings.TooShortPlate,
                            description = (Config.Strings.TooShortPlateDesc):format(Config.MinLength),
                            type = "error"
                        })
                        return
                    end

                    local wasPlateTaken = lib.callback.await("kats_plates:checkAvailability", false, string, true)

                    if wasPlateTaken then
                        lib.notify({
                            title = Config.Strings.PlateTaken,
                            description = Config.Strings.PlateTakenDesc,
                            type = "error"
                        })
                        return
                    end

                    lib.callback.await("kats_plates:changeVehiclePlate", false, vehNetID, string)

                end,
            },

            {
                title = (Config.Strings.CheckPlateMenu):format(Config.PlateCheckCost),
                icon = 'car',
                onSelect = function()

                    local input = lib.inputDialog((Config.Strings.CheckPlateMenu):format(Config.PlateCheckCost), {Config.Strings.WritePlateText})
 
                    if not input then 
                        return 
                    end

                    local string = tostring(input[1])

                    if string.find(string, "%W+") then
                        lib.notify({
                            title = Config.Strings.SpecialChars,
                            description = Config.Strings.SpecialCharsDesc,
                            type = "error"
                        })
                        return
                    end

                    if string.len(string) < Config.MinLength then
                        lib.notify({
                            title = Config.Strings.TooShortPlate,
                            description = (Config.Strings.TooShortPlateDesc):format(Config.MinLength),
                            type = "error"
                        })
                        return
                    end
                    
                    lib.callback.await("kats_plates:checkAvailability", false, string, false)
                end,
            }
        }
    })
    lib.showContext("vehiclePlateMenu")
end

CreateTarget = function()
    exports.ox_target:addGlobalVehicle({
        {
            name = 'changeLicense',
            icon = "fa-solid fa-car",
            label = Config.Strings.PlateMenu,
            canInteract = function(entity, distance, coords, name)
                local pedCoords = GetEntityCoords(cache.ped)
                for k,v in pairs(Config.PlateStations) do
                    if #(pedCoords - v) <= 10 and distance <= 2 then
                        return true
                    end
                    return false
                end
            end,
            onSelect = function(data)
                openChangePlate(VehToNet(data.entity))
            end
        }
    })
end



CreateThread(function()
    if Config.Blip.Enabled then
        for k,v in pairs(Config.PlateStations) do
            local coords = v
            local blipSettings = Config.Blip
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, blipSettings.Sprite)
            SetBlipColour(blip, blipSettings.Color)
            SetBlipScale(blip, blipSettings.Scale)
            SetBlipDisplay(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Config.Strings.Blip)
            EndTextCommandSetBlipName(blip)
        end
    end
    while playerLoaded == nil do
        Wait(1)
    end
    CreateTarget()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function()
    playerLoaded = true
end)

CreateTarget()