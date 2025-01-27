-- Aimedic Script for FiveM

-- EMS status (server-wide). This will dynamically toggle the `/aimedic` command functionality.
local EMS_JOB_NAME = "ambulance" -- Change this to your EMS job name based on your framework

-- Vector for hospital location (example location, change as needed)
local HOSPITAL_LOCATION = vector3(1151.21, -1529.62, 34.84) -- Modify this to your hospital location

-- Function to calculate distance between two vectors
local function calculateDistance(vector1, vector2)
    return #(vector1 - vector2)
end

-- Function to check if EMS is on duty
local function isEMSOnDuty()
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId) -- Replace with QB-Core equivalent if needed
        if xPlayer and xPlayer.job and xPlayer.job.name == EMS_JOB_NAME then
            return true
        end
    end
    return false
end

-- Function to spawn a PED and vehicle
local function spawnResponder(playerCoords, vehicleModel, pedModel)
    -- Spawn the vehicle
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(0)
    end
    local vehicle = CreateVehicle(vehicleModel, playerCoords.x + 5, playerCoords.y + 5, playerCoords.z, 0.0, true, false)

    -- Spawn the PED
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end
    local ped = CreatePedInsideVehicle(vehicle, 4, pedModel, -1, true, false)

    -- Drive to the player location
    TaskVehicleDriveToCoordLongrange(ped, vehicle, playerCoords.x, playerCoords.y, playerCoords.z, 20.0, 786603, 5.0)
    return ped, vehicle
end

-- Function to handle AI Medic response
local function handleAIMedicResponse(playerCoords)
    local distance = calculateDistance(playerCoords, HOSPITAL_LOCATION)

    if distance <= 5000 then
        -- Ambulance response
        spawnResponder(playerCoords, "ambulance", "s_m_m_paramedic_01")
    elseif distance > 5000 and distance <= 7000 then
        -- Fast paramedic vehicle response
        spawnResponder(playerCoords, "firetruk", "s_m_m_paramedic_01")
    else
        -- Helicopter response
        RequestModel("polmav")
        while not HasModelLoaded("polmav") do
            Wait(0)
        end
        local helicopter = CreateVehicle("polmav", HOSPITAL_LOCATION.x, HOSPITAL_LOCATION.y, HOSPITAL_LOCATION.z + 50, 0.0, true, false)
        local ped = CreatePedInsideVehicle(helicopter, 4, "s_m_m_paramedic_01", -1, true, false)

        -- Helicopter flies to the player location
        TaskVehicleDriveToCoordLongrange(ped, helicopter, playerCoords.x, playerCoords.y, playerCoords.z, 50.0, 786603, 5.0)

        -- Ped rappels down
        Wait(5000) -- Adjust timing as needed
        TaskRappelFromHeli(ped, 0)
    end
end

-- Register the /aimedic command
RegisterCommand("aimedic", function(source, args, rawCommand)
    local src = source

    -- Check if EMS is on duty
    if isEMSOnDuty() then
        TriggerClientEvent('chat:addMessage', src, {
            args = {"^1System", "This command is disabled while EMS is on duty."}
        })
        return
    end

    -- Check if the player is dead or downed
    TriggerClientEvent("aimedic:checkPlayerState", src)
end, false)

-- Event to heal or revive the player after state verification
RegisterNetEvent("aimedic:healOrRevive")
AddEventHandler("aimedic:healOrRevive", function(playerCoords)
    local src = source
    handleAIMedicResponse(playerCoords)
    TriggerClientEvent('esx_ambulancejob:revive', src)
    TriggerClientEvent('chat:addMessage', src, {
        args = {"^2System", "AI Medic is responding to your location."}
    })
end)

-- Client-side logic
if IsDuplicityVersion() then return end

RegisterNetEvent("aimedic:checkPlayerState")
AddEventHandler("aimedic:checkPlayerState", function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if IsEntityDead(playerPed) or GetEntityHealth(playerPed) <= 0 then
        TriggerServerEvent("aimedic:healOrRevive", playerCoords)
    else
        TriggerEvent('chat:addMessage', {
            args = {"^1System", "You are not downed or dead."}
        })
    end
end)
