local miningLocation = vector3(1000, 2000, 30)  -- Change these coordinates to a mining spot in GTA V

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Check if player is near the mining location
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - miningLocation)

        if distance < 10.0 then
            DrawText3D(miningLocation.x, miningLocation.y, miningLocation.z, "Press ~g~E~w~ to mine")

            if distance < 1.5 then
                if IsControlJustPressed(0, 38) then  -- "E" key
                    TriggerServerEvent("mineOre")
                end
            end
        end
    end
end)

-- Function to draw 3D text (for prompt)
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y, z)
end

RegisterServerEvent("mineOre")
AddEventHandler("mineOre", function()
    local playerId = source
    local oreAmount = math.random(1, 5)  -- Random amount of ores mined

    -- Reward the player with ores
    TriggerEvent('esx_addonaccount:getSharedAccount', 'bank', function(account)
        local currentMoney = account.money
        local oreValue = oreAmount * 50  -- Example: each ore is worth 50
        account.addMoney(oreValue)
    end)

    -- Notify player
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {"Server", "You mined " .. oreAmount .. " ores and earned $" .. oreValue}
    })
end)

local vendorLocation = vector3(1050, 2100, 30)  -- Change to vendor's location

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vendorLocation)

        if distance < 10.0 then
            DrawText3D(vendorLocation.x, vendorLocation.y, vendorLocation.z, "Press ~g~E~w~ to sell ores")

            if distance < 1.5 then
                if IsControlJustPressed(0, 38) then  -- "E" key
                    TriggerServerEvent("sellOre")
                end
            end
        end
    end
end)

RegisterServerEvent("sellOre")
AddEventHandler("sellOre", function()
    local playerId = source
    local oreCount = 10  -- Example: Player has 10 ores to sell
    local oreValue = oreCount * 50  -- Each ore is worth $50

    -- Add money to player's bank account
    TriggerEvent('esx_addonaccount:getSharedAccount', 'bank', function(account)
        account.addMoney(oreValue)
    end)

    -- Notify player
    TriggerClientEvent('chat:addMessage', playerId, {
        args = {"Server", "You sold " .. oreCount .. " ores for $" .. oreValue}
    })
end)

