-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
rtk = {}
Tunnel.bindInterface("rtk_fleeca",rtk)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
Doors = {
    ["F1"] = {{loc = vector3(312.93, -284.45, 54.16), h = 160.91, txtloc = vector3(312.93, -284.45, 54.16), obj = nil, locked = true}, {loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(148.76, -1045.89, 29.37), h = 158.54, txtloc = vector3(148.76, -1045.89, 29.37), obj = nil, locked = true}, {loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1209.66, -335.15, 37.78), h = 213.67, txtloc = vector3(-1209.66, -335.15, 37.78), obj = nil, locked = true}, {loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2957.26, 483.53, 15.70), h = 267.73, txtloc = vector3(-2957.26, 483.53, 15.70), obj = nil, locked = true}, {loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-351.97, -55.18, 49.04), h = 159.79, txtloc = vector3(-351.97, -55.18, 49.04), obj = nil, locked = true}, {loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1174.24, 2712.47, 38.09), h = 160.91, txtloc = vector3(1174.24, 2712.47, 38.09), obj = nil, locked = true}, {loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("vrp:startcheck")
AddEventHandler("vrp:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local user_id = vRP.getUserId(_source)
    local cops = vRP.getUsersByPermission("dpla.permissao")
        copcount = #cops

    if copcount >= RTK.mincops then
        if not RTK.Banks[bank].onaction == true then
            if (os.time() - RTK.cooldown) > RTK.Banks[bank].lastrobbed then
                RTK.Banks[bank].onaction = true
                TriggerClientEvent("vrp:outcome", _source, true, bank)
                TriggerClientEvent("vrp:policenotify", -1, bank)
            else
                TriggerClientEvent("vrp:outcome", _source, false, "Esse banco foi assalto recentemente. Aguarde "..math.floor((RTK.cooldown - (os.time() - RTK.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((RTK.cooldown - (os.time() - RTK.Banks[bank].lastrobbed)), 60))
            end
        else
            TriggerClientEvent("vrp:outcome", _source, false, "Esse banco já está sendo assaltado")
        end
    else
        TriggerClientEvent("vrp:outcome", _source, false, "Número de policiais insuficiente na cidade.")
    end
end)

RegisterServerEvent("vrp:lootup")
AddEventHandler("vrp:lootup", function(var, var2)
    TriggerClientEvent("vrp:lootup_c", -1, var, var2)
end)

RegisterServerEvent("vrp:openDoor")
AddEventHandler("vrp:openDoor", function(coords, method)
    TriggerClientEvent("vrp:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("vrp:toggleDoor")
AddEventHandler("vrp:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    TriggerClientEvent("vrp:toggleDoor", -1, key, state)
end)

RegisterServerEvent("vrp:toggleVault")
AddEventHandler("vrp:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("vrp:toggleVault", -1, key, state)
end)

RegisterServerEvent("vrp:updateVaultState")
AddEventHandler("vrp:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("vrp:startLoot")
AddEventHandler("vrp:startLoot", function(data, name, players)
    local _source = source
        for i = 1, #players, 1 do
            TriggerClientEvent("vrp:startLoot_c", players[i], data, name)
        end
    TriggerClientEvent("vrp:startLoot_c", _source, data, name)
end)

RegisterServerEvent("vrp:stopHeist")
AddEventHandler("vrp:stopHeist", function(name)
    TriggerClientEvent("vrp:stopHeist_c", -1, name)
end)

RegisterServerEvent("vrp:rewardCash")
AddEventHandler("vrp:rewardCash", function()
    local source = source
	local user_id = vRP.getUserId(source)
    local reward = math.random(RTK.mincash, RTK.maxcash)

    if RTK.black then
        vRP.giveInventoryItem(user_id, "dinheiro-sujo", reward, true)
    else
        vRP.giveMoney(user_id,reward)
    end
end)

RegisterServerEvent("vrp:setCooldown")
AddEventHandler("vrp:setCooldown", function(name)
    RTK.Banks[name].lastrobbed = os.time()
    RTK.Banks[name].onaction = false
    TriggerClientEvent("vrp:resetDoorState", -1, name)
end)

RegisterServerEvent('vrp:GetDoors')
AddEventHandler('vrp:GetDoors', function()
    TriggerClientEvent('vrp:GetDoors', source, Doors)
end)

RegisterServerEvent('vrp:checkItem')
AddEventHandler('vrp:checkItem', function(itemname)
    local source = source
	local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id,itemname,1) then
        TriggerClientEvent('vrp:checkItem', source, true)
    else
        TriggerClientEvent('vrp:checkItem', source, false)
    end
end)

function rtk.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"bcso.permissao")
end
