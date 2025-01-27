AddEventHandler("playerSpawned", function()
    TriggerEvent('chat:addMessage', {
        args = {"Server", "Welcome to the server, " .. GetPlayerName(PlayerId())}
    })
end)
