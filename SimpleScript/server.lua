RegisterCommand("hello", function(source, args, rawCommand)
    TriggerClientEvent("chat:addMessage", source, {
        args = {"Server", "Hello, " .. GetPlayerName(source) .. "!"}
    })
end, false)
