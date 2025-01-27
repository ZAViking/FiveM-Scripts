RegisterCommand('admincommand', function(source, args, rawCommand)
    -- Check if the player has admin permissions
    local player = source
    local isAdmin = IsPlayerAceAllowed(player, "admin")  -- Checking if player has "admin" permission
    
    if isAdmin then
        -- Your admin command logic here
        TriggerClientEvent("chat:addMessage", player, { args = { "^1Admin Command Executed" } })
    else
        TriggerClientEvent("chat:addMessage", player, { args = { "^1You do not have permission to use this command." } })
    end
end, false) -- Set to false to allow permission check (could be true for devs)

-- Add the permission to your ACL config file (e.g., server.cfg)


-- server.lua

RegisterNetEvent('admin:banPlayer')
AddEventHandler('admin:banPlayer', function(data)
    local player = source
    if IsPlayerAceAllowed(player, "admin") then
        -- Code to ban the player (use any ban logic you like)
        local targetPlayer = data.playerID  -- Example: Assume playerID is passed
        DropPlayer(targetPlayer, "You have been banned from the server.")
    else
        TriggerClientEvent("chat:addMessage", player, { args = { "^1You do not have permission to ban players." } })
    end
end)

RegisterNetEvent('admin:kickPlayer')
AddEventHandler('admin:kickPlayer', function(data)
    local player = source
    if IsPlayerAceAllowed(player, "admin") then
        local targetPlayer = data.playerID
        DropPlayer(targetPlayer, "You have been kicked from the server.")
    else
        TriggerClientEvent("chat:addMessage", player, { args = { "^1You do not have permission to kick players." } })
    end
end)
