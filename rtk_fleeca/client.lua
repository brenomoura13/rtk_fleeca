
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
rtk = Tunnel.getInterface("rtk_fleeca")

Freeze = {F1 = 0, F2 = 0, F3 = 0, F4 = 0, F5 = 0, F6 = 0}
PlayerData = nil
Check = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
SearchChecks = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
LootCheck = {
  F1 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
  F2 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
  F3 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
  F4 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
  F5 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
  F6 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false}
}

Doors = {}
local disableinput = false
local initiator = false
local startdstcheck = false
local currentname = nil
local currentcoords = nil
local done = true
local dooruse = false
local result = nil
local hacking = false

Citizen.CreateThread(function() while true do local enabled = false Citizen.Wait(4) if disableinput then enabled = true DisableControl() end if not enabled then Citizen.Wait(500) end end end)
function drawTxt(text,font,x,y,scale,r,g,b,a) SetTextFont(font) SetTextScale(scale,scale) SetTextColour(r,g,b,a) SetTextOutline() SetTextCentre(1) SetTextEntry("STRING") AddTextComponentString(text) DrawText(x,y) end
  function DrawText3D(x, y, z, text, scale) local onScreen, _x, _y = World3dToScreen2d(x, y, z) local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) SetTextScale(scale, scale) SetTextFont(4) SetTextProportional(1) SetTextEntry("STRING") SetTextCentre(true) SetTextColour(255, 255, 255, 215) AddTextComponentString(text) DrawText(_x, _y) local factor = (string.len(text)) / 700 DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100) end
    function DisableControl() DisableControlAction(0, 73, false) DisableControlAction(0, 24, true) DisableControlAction(0, 257, true) DisableControlAction(0, 25, true) DisableControlAction(0, 263, true) DisableControlAction(0, 32, true) DisableControlAction(0, 34, true) DisableControlAction(0, 31, true) DisableControlAction(0, 30, true) DisableControlAction(0, 45, true) DisableControlAction(0, 22, true) DisableControlAction(0, 44, true) DisableControlAction(0, 37, true) DisableControlAction(0, 23, true) DisableControlAction(0, 288, true) DisableControlAction(0, 289, true) DisableControlAction(0, 170, true) DisableControlAction(0, 167, true) DisableControlAction(0, 73, true) DisableControlAction(2, 199, true) DisableControlAction(0, 47, true) DisableControlAction(0, 264, true) DisableControlAction(0, 257, true) DisableControlAction(0, 140, true) DisableControlAction(0, 141, true) DisableControlAction(0, 142, true) DisableControlAction(0, 143, true) end


      RegisterNetEvent('vrp:checkItem')
      AddEventHandler('vrp:checkItem', function(ret)
      result = ret
      end)

      RegisterNetEvent('vrp:GetDoors')
      AddEventHandler('vrp:GetDoors', function(ret)
      result = ret
      end)

      RegisterNetEvent("vrp:resetDoorState")
      AddEventHandler("vrp:resetDoorState", function(name)
      Freeze[name] = 0
      end)

      RegisterNetEvent("vrp:lootup_c")
      AddEventHandler("vrp:lootup_c", function(var, var2)
      LootCheck[var][var2] = true
      end)

      RegisterNetEvent("vrp:outcome")
      AddEventHandler("vrp:outcome", function(oc, arg)
      for i = 1, #Check, 1 do
        Check[i] = false
      end
      for i = 1, #LootCheck, 1 do
        for j = 1, #LootCheck[i] do
          LootCheck[i][j] = false
        end
      end
      if oc then
        Check[arg] = true
        TriggerEvent("vrp:startheist", RTK.Banks[arg], arg)
      elseif not oc then
        TriggerEvent("Notify","negado",arg,5000)
      end
      end)

      RegisterNetEvent("vrp:startLoot_c")
      AddEventHandler("vrp:startLoot_c", function(data, name)
      currentname = name
      currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
      if not LootCheck[name].Stop then
        Citizen.CreateThread(function()
        while true do
          local pedcoords = GetEntityCoords(PlayerPedId())
          local dst = GetDistanceBetweenCoords(pedcoords, data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z, true)

          if dst < 40 then
            if not LootCheck[name].Loot1 then
              local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley1.x, data.trolley1.y, data.trolley1.z + 1, true)

              if dst1 < 1 then


                drawTxt("[~r~E~w~] ROUBAR O DINHEIRO",4,0.5,0.87,0.50,255,255,255,255)
                if dst1 < 1 and IsControlJustReleased(0, 38) then
                  TriggerServerEvent("vrp:lootup", name, "Loot1")
                  StartGrab(name)
                end
              end
            end

            if not LootCheck[name].Loot2 then
              local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley2.x, data.trolley2.y, data.trolley2.z+1, true)

              if dst1 < 1 then
                drawTxt("[~r~E~w~] ROUBAR O DINHEIRO",4,0.5,0.87,0.50,255,255,255,255)
                if dst1 < 1 and IsControlJustReleased(0, 38) then
                  TriggerServerEvent("vrp:lootup", name, "Loot2")
                  StartGrab(name)
                end
              end
            end

            if not LootCheck[name].Loot3 then
              local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley3.x, data.trolley3.y, data.trolley3.z+1, true)

              if dst1 < 1  then
                drawTxt("[~r~E~w~] ROUBAR O DINHEIRO",4,0.5,0.87,0.50,255,255,255,255)
                if dst1 < 1 and IsControlJustReleased(0, 38) then
                  TriggerServerEvent("vrp:lootup", name, "Loot3")
                  StartGrab(name)
                end
              end
            end

            if LootCheck[name].Stop or (LootCheck[name].Loot1 and LootCheck[name].Loot2 and LootCheck[name].Loot3) then
              LootCheck[name].Stop = false
              if initiator then
                TriggerEvent("vrp:reset", name, data)
                return
              end
              return
            end
            Citizen.Wait(4)
          else
            Citizen.Wait(1000)
          end
        end
        end)
      end
      end)

      RegisterNetEvent("vrp:stopHeist_c")
      AddEventHandler("vrp:stopHeist_c", function(name)
      LootCheck[name].Stop = true
      end)

      RegisterNetEvent("vrp:policenotify")
      AddEventHandler("vrp:policenotify", function(name)

      local blip = nil

      if rtk.checkPermission() then
        TriggerEvent("Notify","importante","<code><b>911</b></code> Atenção, os alarmes do <b>de um banco Fleeca</b> foram acionados.",15000)
            if not DoesBlipExist(blip) then
            blip = AddBlipForCoord(RTK.Banks[name].doors.startloc.x, RTK.Banks[name].doors.startloc.y, RTK.Banks[name].doors.startloc.z)
            SetBlipSprite(blip, 161)
            SetBlipScale(blip, 2.0)
            SetBlipColour(blip, 1)
            PulseBlip(blip)
            Citizen.Wait(240000)
            RemoveBlip(blip)
            end
        end
      end)

      -- MAIN DOOR UPDATE --

      AddEventHandler("vrp:freezeDoors", function()
      Citizen.CreateThread(function()
        while true do
            for k, v in pairs(Doors) do
            if v[1].obj == nil or not DoesEntityExist(v[1].obj) then
                v[1].obj = GetClosestObjectOfType(v[1].loc, 1.5, GetHashKey("v_ilev_gb_vaubar"), false, false, false)
                FreezeEntityPosition(v[1].obj, v[1].locked)
            else
                FreezeEntityPosition(v[1].obj, v[1].locked)
                Citizen.Wait(100)
            end
            if v[1].locked then
                SetEntityHeading(v[1].obj, v[1].h)
            end
            Citizen.Wait(100)
            end
            Citizen.Wait(4)
        end
      end)

      Citizen.CreateThread(function()
      while true do
        if not dooruse then
          local pcoords = GetEntityCoords(PlayerPedId())
          for k, v in pairs(Doors) do
            for i = 1, 2, 1 do
              local dst = GetDistanceBetweenCoords(pcoords, v[i].loc, true)
                if dst <= 0.5 then
                  if v[i].locked then
                    drawTxt("[~r~H~w~] DESTRANCAR PORTA",4,0.5,0.96,0.50,255,255,255,255)
                  elseif not v[i].locked then
                    drawTxt("[~r~H~w~] TRANCAR PORTA",4,0.5,0.96,0.50,255,255,255,255)
                  end
                  if IsControlJustReleased(0, 74) then
                    if rtk.checkPermission() then
                        dooruse = true
                        if i == 2 then
                        TriggerServerEvent("vrp:toggleVault", k, not v[i].locked)
                        else
                        TriggerServerEvent("vrp:toggleDoor", k, not v[i].locked)
                        end
                    else
                        TriggerEvent("Notify","negado","Você não é um agente autorizado",7000)
                    end
                end
              end
            end
          end
        end
        Citizen.Wait(4)
      end
      end)

      Citizen.CreateThread(function()
      doVaultStuff = function()
      while true do
        local pcoords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(Doors) do
          if GetDistanceBetweenCoords(v[2].loc, pcoords, true) <= 20.0 then
            if v[2].state ~= nil then
              local obj
              if k ~= "F4" then
                obj = GetClosestObjectOfType(v[2].loc, 1.5, GetHashKey("v_ilev_gb_vauldr"), false, false, false)
              else
                obj = GetClosestObjectOfType(v[2].loc, 1.5, 4231427725, false, false, false)
              end
              SetEntityHeading(obj, v[2].state)
              Citizen.Wait(1000)
              return doVaultStuff()
            end
          else
            Citizen.Wait(1000)
          end
        end
        Citizen.Wait(4)
      end
    end
    doVaultStuff()
    end)
    end)

    RegisterNetEvent("vrp:toggleDoor")
    AddEventHandler("vrp:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    dooruse = false
    end)

    RegisterNetEvent("vrp:toggleVault")
    AddEventHandler("vrp:toggleVault", function(key, state)
    dooruse = true
    Doors[key][2].state = nil
    if RTK.Banks[key].hash == nil then
      if not state then
        local obj = GetClosestObjectOfType(RTK.Banks[key].doors.startloc.x, RTK.Banks[key].doors.startloc.y, RTK.Banks[key].doors.startloc.z, 2.0, GetHashKey(RTK.vaultdoor), false, false, false)
        local count = 0

        repeat
          local heading = GetEntityHeading(obj) - 0.10

          SetEntityHeading(obj, heading)
          count = count + 1
          Citizen.Wait(10)
        until count == 900
        Doors[key][2].locked = state
        Doors[key][2].state = GetEntityHeading(obj)
        TriggerServerEvent("vrp:updateVaultState", key, Doors[key][2].state)
      elseif state then
        local obj = GetClosestObjectOfType(RTK.Banks[key].doors.startloc.x, RTK.Banks[key].doors.startloc.y, RTK.Banks[key].doors.startloc.z, 2.0, GetHashKey(RTK.vaultdoor), false, false, false)
        local count = 0

        repeat
          local heading = GetEntityHeading(obj) + 0.10

          SetEntityHeading(obj, heading)
          count = count + 1
          Citizen.Wait(10)
        until count == 900
        Doors[key][2].locked = state
        Doors[key][2].state = GetEntityHeading(obj)
        TriggerServerEvent("vrp:updateVaultState", key, Doors[key][2].state)
      end
    else
      if not state then
        local obj = GetClosestObjectOfType(RTK.Banks.F4.doors.startloc.x, RTK.Banks.F4.doors.startloc.y, RTK.Banks.F4.doors.startloc.z, 2.0, RTK.Banks.F4.hash, false, false, false)
        local count = 0
        repeat
          local heading = GetEntityHeading(obj) - 0.10

          SetEntityHeading(obj, heading)
          count = count + 1
          Citizen.Wait(10)
        until count == 900
        Doors[key][2].locked = state
        Doors[key][2].state = GetEntityHeading(obj)
        TriggerServerEvent("vrp:updateVaultState", key, Doors[key][2].state)
      elseif state then
        local obj = GetClosestObjectOfType(RTK.Banks.F4.doors.startloc.x, RTK.Banks.F4.doors.startloc.y, RTK.Banks.F4.doors.startloc.z, 2.0, RTK.Banks.F4.hash, false, false, false)
        local count = 0

        repeat
          local heading = GetEntityHeading(obj) + 0.10

          SetEntityHeading(obj, heading)
          count = count + 1
          Citizen.Wait(10)
        until count == 900
        Doors[key][2].locked = state
        Doors[key][2].state = GetEntityHeading(obj)
        TriggerServerEvent("vrp:updateVaultState", key, Doors[key][2].state)
      end
    end
    dooruse = false
    end)

    AddEventHandler("vrp:reset", function(name, data)
    for i = 1, #LootCheck[name], 1 do
      LootCheck[name][i] = false
    end
    Check[name] = false
    TriggerEvent("Notify","aviso","O cofre será fechado em <b>10 segundos</b>",7000)
    Citizen.Wait(10000)
    TriggerEvent("Notify","negado","O cofre está <b>fechando</b>. Saia dai imediatamente!",7000)
    TriggerServerEvent("vrp:toggleVault", name, true)
    TriggerEvent("vrp:cleanUp", data, name)
    end)

    AddEventHandler("vrp:startheist", function(data, name)
    TriggerServerEvent("vrp:toggleDoor", name, true) -- ensure to lock the second door for the second, third, fourth... heist
    disableinput = true
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    initiator = true
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
      Citizen.Wait(4)
    end
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.startloc.animcoords.x, data.doors.startloc.animcoords.y, data.doors.startloc.animcoords.z)
    SetEntityHeading(ped, data.doors.startloc.animcoords.h)
    local pedco = GetEntityCoords(PlayerPedId())
    IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    Citizen.Wait(1500)
    DetachEntity(IdProp, false, false)
    SetEntityCoords(IdProp, data.prop.first.coords, 0.0, 0.0, 0.0, false)
    SetEntityRotation(IdProp, data.prop.first.rot, 1, true)
    FreezeEntityPosition(IdProp, true)
    Citizen.Wait(500)
    ClearPedTasksImmediately(ped)
    disableinput = false
    Citizen.Wait(1000)
    TriggerEvent("Notify","sucesso","Acesso <b>completado</b>. Abra a outra porta com o cartão.",7000)
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerServerEvent("vrp:toggleVault", name, false)
    startdstcheck = true
    currentname = name
    TriggerEvent("Notify","aviso","Você tem <b>100 segundos</b> até a ativação do sistema de segurança.",7000)
    SpawnTrolleys(data, name)
    end)

    AddEventHandler("vrp:cleanUp", function(data, name)
    Citizen.Wait(10000)
    for i = 1, 3, 1 do -- full trolley clean
      local obj = GetClosestObjectOfType(data.objects[i].x, data.objects[i].y, data.objects[i].z, 0.75, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)

      if DoesEntityExist(obj) then
        DeleteEntity(obj)
      end
    end
    for j = 1, 3, 1 do -- empty trolley clean
      local obj = GetClosestObjectOfType(data.objects[j].x, data.objects[j].y, data.objects[j].z, 0.75, GetHashKey("hei_prop_hei_cash_trolly_03"), false, false, false)

      if DoesEntityExist(obj) then
        DeleteEntity(obj)
      end
    end
    if DoesEntityExist(IdProp) then
      DeleteEntity(IdProp)
    end
    if DoesEntityExist(IdProp2) then
      DeleteEntity(IdProp2)
    end
    TriggerServerEvent("vrp:setCooldown", name)
    initiator = false
    end)

    function SecondDoor(data, key)
      disableinput = true
      RequestModel("p_ld_id_card_01")
      while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(4)
      end
      local ped = PlayerPedId()

      SetEntityCoords(ped, data.doors.secondloc.animcoords.x, data.doors.secondloc.animcoords.y, data.doors.secondloc.animcoords.z)
      SetEntityHeading(ped, data.doors.secondloc.animcoords.h)
      local pedco = GetEntityCoords(PlayerPedId())
      IdProp2 = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
      local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

      AttachEntityToEntity(IdProp2, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
      TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
      Citizen.Wait(1500)
      DetachEntity(IdProp2, false, false)
      SetEntityCoords(IdProp2, data.prop.second.coords, 0.0, 0.0, 0.0, false)
      SetEntityRotation(IdProp2, data.prop.second.rot, 1, true)
      FreezeEntityPosition(IdProp2, true)
      Citizen.Wait(1000)
      ClearPedTasksImmediately(ped)
      TriggerEvent("Notify","aviso","<b>Acesso</b> completo.",7000)
      PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
      --TriggerServerEvent("vrp:openDoor", vector3(data.doors.secondloc.x, data.doors.secondloc.y, data.doors.secondloc.z), 3)
      TriggerServerEvent("vrp:toggleDoor", key, false)
      disableinput = false
    end

    function SpawnTrolleys(data, name)
      RequestModel("hei_prop_hei_cash_trolly_01")
      while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(4)
      end
      Trolley1 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley1.x, data.trolley1.y, data.trolley1.z, 1, 1, 0)
      Trolley2 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley2.x, data.trolley2.y, data.trolley2.z, 1, 1, 0)
      Trolley3 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley3.x, data.trolley3.y, data.trolley3.z, 1, 1, 0)
      local h1 = GetEntityHeading(Trolley1)
      local h2 = GetEntityHeading(Trolley2)
      local h3 = GetEntityHeading(Trolley3)

      SetEntityHeading(Trolley1, h1 + RTK.Banks[name].trolley1.h)
      SetEntityHeading(Trolley2, h2 + RTK.Banks[name].trolley2.h)
      SetEntityHeading(Trolley3, h3 + RTK.Banks[name].trolley3.h)
      local players = vRP.getNearestPlayers(15)
      local missionplayers = {}

      for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
          table.insert(missionplayers, GetPlayerServerId(players[i]))
        end
      end
      TriggerServerEvent("vrp:startLoot", data, name, missionplayers)
      done = false
    end

    function StartGrab(name)
      disableinput = true
      local ped = PlayerPedId()
      local model = "hei_prop_heist_cash_pile"

      Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
      local CashAppear = function()
      local pedCoords = GetEntityCoords(ped)
      local grabmodel = GetHashKey(model)

      RequestModel(grabmodel)
      while not HasModelLoaded(grabmodel) do
        Citizen.Wait(100)
      end
      local grabobj = CreateObject(grabmodel, pedCoords, true)

      FreezeEntityPosition(grabobj, true)
      SetEntityInvincible(grabobj, true)
      SetEntityNoCollisionEntity(grabobj, ped)
      SetEntityVisible(grabobj, false, false)
      AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
      local startedGrabbing = GetGameTimer()

      Citizen.CreateThread(function()
      while GetGameTimer() - startedGrabbing < 37000 do
        Citizen.Wait(4)
        DisableControlAction(0, 73, true)
        if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
          if not IsEntityVisible(grabobj) then
            SetEntityVisible(grabobj, true, false)
          end
        end
        if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
          if IsEntityVisible(grabobj) then
            SetEntityVisible(grabobj, false, false)
            TriggerServerEvent("vrp:rewardCash")
          end
        end
      end
      DeleteObject(grabobj)
      end)
    end
    local trollyobj = Trolley
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

    if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
      return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
      Citizen.Wait(100)
    end
    while not NetworkHasControlOfEntity(trollyobj) do
      Citizen.Wait(4)
      NetworkRequestControlOfEntity(trollyobj)
    end
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(scene1)
    Citizen.Wait(1500)
    CashAppear()
    local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene2)
    Citizen.Wait(37000)
    local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    --TriggerServerEvent("vrp:updateObj", name, NewTrolley, 2)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
    while not NetworkHasControlOfEntity(trollyobj) do
      Citizen.Wait(4)
      NetworkRequestControlOfEntity(trollyobj)
    end
    DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
    Citizen.Wait(1800)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    disableinput = false
  end

  Citizen.CreateThread(function()
  while true do
    if startdstcheck then
      if initiator then
        local playercoord = GetEntityCoords(PlayerPedId())

        if (GetDistanceBetweenCoords(playercoord, currentcoords, true)) > 20 then
          LootCheck[currentname].Stop = true
          startdstcheck = false
          TriggerServerEvent("vrp:stopHeist", currentname)
        end
      end
      Citizen.Wait(4)
    else
      Citizen.Wait(1000)
    end
    Citizen.Wait(4)
  end
  end)

  Citizen.CreateThread(function()
  while true do
    if not done then
      local pedcoords = GetEntityCoords(PlayerPedId())
      local dst = GetDistanceBetweenCoords(pedcoords, RTK.Banks[currentname].doors.secondloc.x, RTK.Banks[currentname].doors.secondloc.y, RTK.Banks[currentname].doors.secondloc.z, true)
        if dst < 0.5 then
            drawTxt("[~r~E~w~] USAR IDENTIDADE FALSA",4,0.5,0.87,0.50,255,255,255,255)
            if dst < 0.5 and IsControlJustReleased(0 , 38) then
            if not rtk.checkPermission() then
            result = nil
            TriggerServerEvent('vrp:checkItem', RTK.item2)
            while result == nil do
                Wait(0)
            end
            if result then
                done = true
                return SecondDoor(RTK.Banks[currentname], currentname)
            elseif not result then
                TriggerEvent("Notify","negado","Você não possui um <b>cartão de segurança</b>",5000)
            end
          end
        end
      end
      if LootCheck[currentname].Stop then
        done = true
      end
    else
      Citizen.Wait(1000)
    end
    Citizen.Wait(4)
  end
  end)

  Citizen.CreateThread(function()
    local resettimer = RTK.timer

    while true do
        if startdstcheck then
        if initiator then
            if RTK.timer > 0 then
            Citizen.Wait(1000)
            RTK.timer = RTK.timer - 1
            elseif RTK.timer == 0 then
            startdstcheck = false
            TriggerServerEvent("vrp:stopHeist", currentname)
            RTK.timer = resettimer
            end
        end
        Citizen.Wait(4)
        else
        Citizen.Wait(1000)
        end
        Citizen.Wait(4)
    end
  end)

  Citizen.CreateThread(function()
    while true do
        if startdstcheck then
          if initiator then
              drawTxt("RESTAM ~b~"..RTK.timer.." SEGUNDOS ~w~PARA O SISTEMA DE SEGURANÇA ACIONAR",4,0.5,0.905,0.45,255,255,255,255)
              drawTxt("ROUBE TUDO ANTES QUE O TEMPO ACABE",4,0.5,0.93,0.38,255,255,255,100)
          end
        end
        Citizen.Wait(4)
    end
  end)

  Citizen.CreateThread(function()
  result = nil
  TriggerServerEvent('vrp:GetDoors')
  while result == nil do
    Wait(0)
  end
  Doors = result
  while Doors == {} do
    Citizen.Wait(1)
  end
  --Citizen.Wait(1000)
  TriggerEvent("vrp:freezeDoors")
  while true do
    local idle = 1000
    local ped = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(RTK.Banks) do
            if not v.onaction then
                local dst = GetDistanceBetweenCoords(coords, v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z, true)
                if dst <= 2 then
                  idle = 4
                    if dst <= 0.6 and not Check[k] then
                        drawTxt("[~r~E~w~] INICIAR ROUBO AO FLEECA",4,0.5,0.93,0.50,255,255,255,255)
                            if dst <= 0.5 and IsControlJustReleased(0, 38) and not rtk.checkPermission() and not hacking then
                              TriggerServerEvent('vrp:checkItem', RTK.item1)
                                while result == nil do
                                    Wait(0)
                                end
                                if result then
                                  local animDict = "anim@heists@keypad@"
                                  local animLib = "idle_a"
                                
                                  RequestAnimDict(animDict)
                                  while not HasAnimDictLoaded(animDict) do
                                    Citizen.Wait(50)
                                  end                                  
                                  SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
                                    Citizen.Wait(500)		
                                  TriggerEvent('cancelando',true)
                                  hacking = true
                                  TriggerEvent("Notify","sucesso","<b>Conectando</b> com o sistema.",5000)
                                  TaskPlayAnim(ped, animDict, animLib, 2.0, -2.0, -1, 1, 0, 0, 0, 0 )
                                  Citizen.Wait(5000)
                                  TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
                                  Citizen.Wait(2500)
                                  TriggerEvent("mhacking:show")
                                  TriggerEvent("mhacking:start",7,25,function (success)
                                  if success and hacking then
                                    TriggerEvent('mhacking:hide')
                                    TriggerServerEvent("vrp:startcheck", k)
                                    hacking = false
                                    TriggerEvent('cancelando',false)
                                  else
                                    TriggerEvent('mhacking:hide')
                                    hacking = false
                                    TriggerEvent('cancelando',false)                               
                                end
                            end)
                            elseif not result then
                              TriggerEvent("Notify","negado","Você não possui um <b>cartão de segurança</b>",5000)
                            end
                          end
                       end
                    end
                end
            end
        Citizen.Wait(idle)
     end
  end)


  -- SEARCH FOR ID CARD UPDATE --

  function Lockpick(name)
    local player = PlayerPedId()

    RequestAnimDict("mp_arresting")
    while not HasAnimDictLoaded("mp_arresting") do
      RequestAnimDict("mp_arresting")
      Citizen.Wait(10)
    end
    SetEntityCoords(player, loc.x, loc.y, loc.z, 1, 0, 0, 1)
    SetEntityHeading(player, loc.h)
  end