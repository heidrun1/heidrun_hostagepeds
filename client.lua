-- Variables --
local ESX = exports["es_extended"]:getSharedObject()
local settingPed = false

-- Functions --

function hostageFunction()
    local playerPed = PlayerPedId()
    settingPed = true

    local randomHostageModel = Config.pedsModel[math.random(1, #Config.pedsModel)]
    RequestModel(GetHashKey(randomHostageModel))
    while not HasModelLoaded(GetHashKey(randomHostageModel)) do Citizen.Wait(1) end
    local ped = CreatePed(4, GetHashKey(randomHostageModel), vector3(0.0, 0.0, 0.0), 0.0, false, false)
    local coords = nil
    while settingPed do
        local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
        SetEntityCoordsNoOffset(ped, offset.x, offset.y, offset.z, true, true, true)
        SetEntityHeading(ped, GetEntityHeading(playerPed))

        ESX.ShowHelpNotification(Config.locales['helpnotification'])
        if IsControlJustPressed(0, 51) then
            DeleteEntity(ped)
            coords = offset
            settingPed = false
        end
        if IsControlJustPressed(0, 73) then
            DeleteEntity(ped)
            coords = nil
            settingPed = false
        end
        Citizen.Wait(0)
    end
    if coords == nil then return end
    RequestModel(GetHashKey(randomHostageModel))
    while not HasModelLoaded(GetHashKey(randomHostageModel)) do Citizen.Wait(1) end
    local entity = CreatePed(4, GetHashKey(randomHostageModel), coords.x, coords.y, coords.z - 1.0, GetEntityHeading(PlayerPedId()), true, false)
    Wait(250)
    ESX.TriggerServerCallback('heidrun:registerPed', function(data)
        if data then 
            PlaceObjectOnGroundProperly(entity)
            FreezeEntityPosition(entity, Config.hostageConfig['FreezePed'])
            SetEntityInvincible(entity, Config.hostageConfig['InvinciblePed'])
            SetBlockingOfNonTemporaryEvents(entity, Config.hostageConfig['BlockTemporaryEvents'])
            SetPedDiesWhenInjured(ped, Config.hostageConfig['PedDiesWhenInjured'])
            SetPedFleeAttributes(ped, 0, 0)
            SetEntityAsMissionEntity(ped)
            ESX.ShowNotification(Config.locales['success_createhostage'])
        end
    end, PedToNet(entity))
end

function useItem()
    local itemCount = exports["ox_inventory"]:GetItemCount(Config.itemConfig.item)
    if Config.itemConfig.item then 
        if itemCount >= 1 then
            hostageFunction()
        else
            ESX.ShowNotification(Config.locales.no_item)
        end
    else
        hostageFunction()
    end
end

RegisterCommand(Config.itemConfig.command, useItem, false)
exports('useItem', hostageFunction)

CreateThread(function()
    exports.ox_target:addGlobalPed({
        {
            icon = "fa fa-hand",
            label = Config.locales.letout_hostage,
            distance = 2.0,
            canInteract = function(entity, distance, coords, name, bone)
                return Entity(entity).state.isHostagePed
            end,
            onSelect = function(data)
                ESX.ShowNotification(Config.locales.hostage_out)
                local offset = GetOffsetFromEntityInWorldCoords(data.entity, 0.0, 120.0, 0.0)
                FreezeEntityPosition(data.entity, false)
                TaskGoStraightToCoord(data.entity, offset.x, offset.y, offset.z, 5.0, 5000, GetEntityModel(data.entity), 0.1)
                Citizen.Wait(4000)
                TriggerServerEvent("heidrun_hostageped:letoutHostage", PedToNet(data.entity))
            end,
        },
    })
end)