RegisterCommand('setmoney', function(source, args, rawCommand)
    local playerId = source
    local money = tonumber(args[1])

    if money then
        local steamId = GetPlayerIdentifiers(playerId)[1] -- Getting Steam ID
        
        -- Save money to MySQL
        MySQL.Async.execute('INSERT INTO player_data (steam_id, money) VALUES (@steamId, @money) ON DUPLICATE KEY UPDATE money = @money', {
            ['@steamId'] = steamId,
            ['@money'] = money
        }, function(rowsChanged)
            print("Player money saved!")
        end)
    end
end, false)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local playerId = source
    local steamId = GetPlayerIdentifiers(playerId)[1]

    -- Retrieve player data from MySQL
    MySQL.Async.fetchScalar('SELECT money FROM player_data WHERE steam_id = @steamId', {
        ['@steamId'] = steamId
    }, function(result)
        if result then
            print("Player's Money: " .. result)
        else
            print("No data found for player.")
        end
    end)
end)
