local Framework = nil
local FrameworkName = 'standalone'

CreateThread(function()
    Wait(100)
    
    local choice = (type(Config) == 'table' and Config.Framework) or 'auto'

    local function tryQBX()
        if GetResourceState('qbx_core') == 'started' then
            local ok, obj = pcall(function() return exports['qbx_core']:GetCoreObject() end)
            if ok and obj then Framework = obj FrameworkName = 'qbx' return true end
            ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
            if ok and obj then Framework = obj FrameworkName = 'qbx' return true end
        end
        if GetResourceState('qbox') == 'started' then
            local ok, obj = pcall(function() return exports['qbox']:GetCoreObject() end)
            if ok and obj then Framework = obj FrameworkName = 'qbx' return true end
            ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
            if ok and obj then Framework = obj FrameworkName = 'qbx' return true end
        end
        return false
    end

    local function tryQB()
        if GetResourceState('qb-core') == 'started' then
            local ok, obj = pcall(function() return exports['qb-core']:GetCoreObject() end)
            if ok and obj then Framework = obj FrameworkName = 'qbcore' return true end
        end
        return false
    end

    local function tryESX()
        if GetResourceState('es_extended') == 'started' then
            local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
            if ok and obj then Framework = obj FrameworkName = 'esx' return true end
        end
        return false
    end

    if choice == 'qbx' then 
        tryQBX()
    elseif choice == 'qbcore' then 
        tryQB()
    elseif choice == 'esx' then 
        tryESX()
    elseif choice == 'standalone' then 
        Framework = nil 
        FrameworkName = 'standalone'
    else
        if not tryQBX() then 
            if not tryQB() then 
                tryESX() 
            end 
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(src, xPlayer)
    applyStateBags(src)
end)

AddEventHandler('QBCore:Server:OnPlayerLoaded', function(src)
    applyStateBags(src)
end)

AddEventHandler('QBX:Server:OnPlayerLoaded', function(src)
    applyStateBags(src)
end)

AddEventHandler('qbx:server:playerLoaded', function(src)
    applyStateBags(src)
end)

AddEventHandler('qbx_core:server:playerLoaded', function(src)
    applyStateBags(src)
end)

local function buildRPName(src)
    if not Framework then return nil end
    
    if FrameworkName == 'qbcore' or FrameworkName == 'qbx' then
        if Framework and Framework.Functions and Framework.Functions.GetPlayer then
            local Player = Framework.Functions.GetPlayer(src)
            if Player and Player.PlayerData and Player.PlayerData.charinfo then
                local fn = Player.PlayerData.charinfo.firstname or ''
                local ln = Player.PlayerData.charinfo.lastname or ''
                local full = (fn .. ' ' .. ln):gsub('^%s*(.-)%s*$', '%1')
                if full ~= '' then return full end
            end
        end
    elseif FrameworkName == 'esx' then
        local xPlayer = Framework.GetPlayerFromId and Framework.GetPlayerFromId(src)
        if xPlayer then
            local fn = xPlayer.get and (xPlayer.get('firstName') or xPlayer.get('firstname')) or ''
            local ln = xPlayer.get and (xPlayer.get('lastName') or xPlayer.get('lastname')) or ''
            local full = (fn .. ' ' .. ln):gsub('^%s*(.-)%s*$', '%1')
            if full ~= '' then return full end
            if xPlayer.getName then
                local name = xPlayer.getName()
                if type(name) == 'string' and name ~= '' then return name end
            end
        end
    end
    return nil
end

local function applyStateBags(src)
    local state = Player(src).state
    if not state then return end
    local rpName = buildRPName(src)
    if rpName and rpName ~= '' then
        state:set('rpName', rpName, true)
        TriggerClientEvent('lucky-nametags:client:setName', -1, src, rpName)
    else
        state:set('rpName', nil, true)
        TriggerClientEvent('lucky-nametags:client:setName', -1, src, nil)
    end
    if state.nametagMasked == nil then
        state:set('nametagMasked', false, true)
    end
end
AddEventHandler('playerJoining', function()
    local src = source
    applyStateBags(src)
end)
AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    Wait(500)
    for _, src in ipairs(GetPlayers()) do
        applyStateBags(tonumber(src))
    end
end)
RegisterNetEvent('lucky-nametags:server:refreshName', function()
    local src = source
    applyStateBags(src)
end)
CreateThread(function()
    while true do
        Wait(10000)
        for _, src in ipairs(GetPlayers()) do
            applyStateBags(tonumber(src))
        end
    end
end)