-- Variables --
local ESX = exports["es_extended"]:getSharedObject()

-- Events
ESX.RegisterServerCallback('heidrun:registerPed', function(src, cb, PedNetworkId)
  local entity = NetworkGetEntityFromNetworkId(PedNetworkId)
  local xPlayer = ESX.GetPlayerFromId(src)
  if Config.itemConfig.removeitem then
    xPlayer.removeInventoryItem(Config.itemConfig["item"], 1)
  end
  Entity(entity).state.isHostagePed = true
  cb(true)
end)

RegisterServerEvent("heidrun_hostageped:letoutHostage")
AddEventHandler("heidrun_hostageped:letoutHostage", function(entity)
  DeleteEntity(NetworkGetEntityFromNetworkId(entity))
end)
