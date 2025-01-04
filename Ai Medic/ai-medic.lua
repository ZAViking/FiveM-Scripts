-- Simple /aimedic script for FiveM with progress bar and EMS NPC performing CPR

-- Register the /aimedic command
RegisterCommand("aimedic", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local targetPlayer = GetNearestPlayer()

    if targetPlayer then
        -- Notify the player
        TriggerEvent("chat:addMessage", {
            args = {"[AI Medic]", "Reviving the player... Please wait 1 minute."}
        })

        -- Freeze the player during the revive process
        FreezeEntityPosition(playerPed, true)

        -- Get target player coordinates
        local targetPed = GetPlayerPed(targetPlayer)
        local targetCoords = GetEntityCoords(targetPed)

        -- Spawn EMS NPC
        local model = GetHashKey("s_m_m_paramedic_01")
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        local emsPed = CreatePed(4, model, targetCoords.x, targetCoords.y, targetCoords.z, 0.0, true, true)
        TaskStartScenarioAtPosition(emsPed, "WORLD_HUMAN_CPR", targetCoords.x, targetCoords.y, targetCoords.z, GetEntityHeading(targetPed), 0, false, true)

        -- Display progress bar
        local startTime = GetGameTimer()
        Citizen.CreateThread(function()
            while GetGameTimer() - startTime < 60000 do
                local progress = math.floor(((GetGameTimer() - startTime) / 60000) * 100)
                DrawTxt("Reviving... " .. progress .. "%", 0.5, 0.9)
                Citizen.Wait(0)
            end
        end)

        -- Set a timer for 60 seconds
        Citizen.CreateThread(function()
            Citizen.Wait(60000) -- Wait 1 minute (60000 ms)

            -- Revive the target player
            TriggerServerEvent("aimedic:revivePlayer", GetPlayerServerId(targetPlayer))

            -- Notify the player of success
            TriggerEvent("chat:addMessage", {
                args = {"[AI Medic]", "Player has been revived!"}
            })

            -- Cleanup EMS NPC
            DeleteEntity(emsPed)

            -- Unfreeze the player
            FreezeEntityPosition(playerPed, false)
        end)
    else
        -- Notify if no player is nearby
        TriggerEvent("chat:addMessage", {
            args = {"[AI Medic]", "No downed players nearby to revive!"}
        })
    end
end, false)

-- Function to find the nearest downed player
function GetNearestPlayer()
    local players = GetActivePlayers()
    local closestPlayer = nil
    local closestDistance = -1
    local playerCoords = GetEntityCoords(PlayerPedId())

    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            if IsEntityDead(targetPed) then
                local targetCoords = GetEntityCoords(targetPed)
                local distance = #(playerCoords - targetCoords)

                if closestDistance == -1 or distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then -- 3.0 units proximity
        return closestPlayer
    end

    return nil
end

-- Function to draw text on the screen
function DrawTxt(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

-- Server-side event to revive a player
RegisterNetEvent("aimedic:revivePlayer")
AddEventHandler("aimedic:revivePlayer", function(playerId)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
    if DoesEntityExist(playerPed) then
        ResurrectPed(playerPed)
        ClearPedTasksImmediately(playerPed)
        SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    end
end)
