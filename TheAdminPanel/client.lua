-- client.lua

RegisterCommand('openadminpanel', function()
    local player = PlayerId()
    -- Check if the player has admin permissions
    if IsPlayerAceAllowed(player, "admin") then
        SetNuiFocus(true, true)  -- Open the NUI (HTML page)
        SendNUIMessage({ type = "showAdminPanel" })
    else
        TriggerEvent('chat:addMessage', { args = { '^1You do not have permission to access this panel.' } })
    end
end, false)

-- Handle events coming from the NUI (admin panel buttons)
RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('admin:banPlayer', data)  -- Trigger server event for banning player
    cb('ok')
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('admin:kickPlayer', data)  -- Trigger server event for kicking player
    cb('ok')
end)


-- Client-side (client.lua)

local NativeUI = require('NativeUI') -- Load NativeUI

local menu = NativeUI.CreateMenu("My Custom Menu", "Choose an option") -- Create the menu
_menuPool:Add(menu)  -- Add the menu to the pool

-- Add items to the menu
local item1 = NativeUI.CreateItem("Option 1", "Description of Option 1")
local item2 = NativeUI.CreateItem("Option 2", "Description of Option 2")
local item3 = NativeUI.CreateItem("Option 3", "Description of Option 3")

menu:AddItem(item1)
menu:AddItem(item2)
menu:AddItem(item3)

-- Add item actions (What happens when the option is selected)
item1.Activated = function()
    print("You selected Option 1")
end

item2.Activated = function()
    print("You selected Option 2")
end

item3.Activated = function()
    print("You selected Option 3")
end

-- Open the menu when a key is pressed (for example, "M" key)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, 244) then -- "M" key
            menu:Visible(not menu:Visible()) -- Toggle the menu visibility
        end

        _menuPool:ProcessMenus()  -- Process the menu
    end
end)
