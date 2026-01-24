local nametagsEnabled = false
local showIDs = true
local friendMap = {}
local markMap = {}

local function hexToRgba(hex)
    if type(hex) ~= 'string' then return nil end
    local h = hex:gsub('#','')
    if #h ~= 6 and #h ~= 8 then return nil end
    local r = tonumber(h:sub(1,2), 16) or 255
    local g = tonumber(h:sub(3,4), 16) or 255
    local b = tonumber(h:sub(5,6), 16) or 255
    local a = (#h == 8) and (tonumber(h:sub(7,8), 16) or 255) or 255
    return {r, g, b, a}
end

local BASE_COLOUR = hexToRgba(Config.HexColour) or Config.Colour or {255,255,255,230}
local FRIEND_COLOUR = hexToRgba(Config.FriendHex) or {10, 50, 120, 230}
local MARK_COLOUR = hexToRgba(Config.MarkHex) or {120, 20, 20, 230}

local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local SAFE = {}
SAFE.Font = clamp(math.floor(tonumber(Config.Font) or 4), 0, 7)
local bs = tonumber(Config.FontScale or Config.BaseScale) or 0.35
local mins = tonumber(Config.MinScale) or 0.25
local maxs = tonumber(Config.MaxScale) or 0.45
local hard = tonumber(Config.ScaleHardCap) or 0.90
local farf = tonumber(Config.FarScaleFactor) or 0.50

mins = clamp(mins, 0.20, 2.00)
maxs = clamp(maxs, 0.20, 2.00)
bs = clamp(bs, 0.20, 2.00)
hard = clamp(hard, 0.20, 1.50)
farf = clamp(farf, 0.05, 1.00)
if mins > maxs then mins, maxs = maxs, mins end

mins = math.min(mins, bs)
maxs = math.min(math.max(maxs, bs), hard)
SAFE.BaseScale, SAFE.MinScale, SAFE.MaxScale, SAFE.ScaleHardCap, SAFE.FarFactor = bs, mins, maxs, hard, farf

local function notifyOn()
    lib.notify({
        title = 'Nametags',
        description = 'Nametags are now ON',
        type = 'success',
        position = Config.NotifyPosition,
        duration = Config.NotifyDuration
    })
end

local function notifyOff()
    lib.notify({
        title = 'Nametags',
        description = 'Nametags are now OFF',
        type = 'inform',
        position = Config.NotifyPosition,
        duration = Config.NotifyDuration,
        icon = 'info-circle'
    })
end

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    TriggerServerEvent('lucky-nametags:server:refreshName')
end)

RegisterCommand('tognames', function()
    nametagsEnabled = not nametagsEnabled
    if nametagsEnabled then
        notifyOn()
        TriggerServerEvent('lucky-nametags:server:refreshName')
    else
        notifyOff()
    end
end, false)

RegisterCommand('nmask', function(_, args)
    local sub = args and args[1] or ''
    if sub ~= '' then
        ExecuteCommand(('ntmask %s'):format(sub))
    else
        ExecuteCommand('ntmask')
    end
end, false)

RegisterCommand('friend', function(_, args)
    local sid = tonumber(args and args[1])
    if not sid then
        lib.notify({ title = 'Nametags', description = 'Usage: /friend <serverId>', type = 'error', position = Config.NotifyPosition, duration = Config.NotifyDuration })
        return
    end
    if friendMap[sid] then
        friendMap[sid] = nil
        lib.notify({ title = 'Nametags', description = ('Removed friend highlight for [%d]'):format(sid), type = 'inform', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    else
        friendMap[sid] = true
        markMap[sid] = nil
        lib.notify({ title = 'Nametags', description = ('Friend highlight set for [%d]'):format(sid), type = 'success', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    end
end, false)

RegisterCommand('mark', function(_, args)
    local sid = tonumber(args and args[1])
    if not sid then
        lib.notify({ title = 'Nametags', description = 'Usage: /mark <serverId>', type = 'error', position = Config.NotifyPosition, duration = Config.NotifyDuration })
        return
    end
    if markMap[sid] then
        markMap[sid] = nil
        lib.notify({ title = 'Nametags', description = ('Removed mark for [%d]'):format(sid), type = 'inform', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    else
        markMap[sid] = true
        friendMap[sid] = nil
        lib.notify({ title = 'Nametags', description = ('Marked [%d]'):format(sid), type = 'warning', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    end
end, false)

RegisterCommand('unfriend', function(_, args)
    local sid = tonumber(args and args[1])
    if not sid then
        lib.notify({ title = 'Nametags', description = 'Usage: /unfriend <serverId>', type = 'error', position = Config.NotifyPosition, duration = Config.NotifyDuration })
        return
    end
    if friendMap[sid] then
        friendMap[sid] = nil
        lib.notify({ title = 'Nametags', description = ('Removed friend highlight for [%d]'):format(sid), type = 'inform', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    else
        lib.notify({ title = 'Nametags', description = ('No friend highlight found for [%d]'):format(sid), type = 'inform', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    end
end, false)

RegisterCommand('unmark', function(_, args)
    local sid = tonumber(args and args[1])
    if not sid then
        lib.notify({ title = 'Nametags', description = 'Usage: /unmark <serverId>', type = 'error', position = Config.NotifyPosition, duration = Config.NotifyDuration })
        return
    end
    if markMap[sid] then
        markMap[sid] = nil
        lib.notify({ title = 'Nametags', description = ('Removed mark for [%d]'):format(sid), type = 'inform', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    else
        lib.notify({ title = 'Nametags', description = ('No mark found for [%d]'):format(sid), type = 'inform', position = Config.NotifyPosition, duration = Config.NotifyDuration })
    end
end, false)

RegisterCommand('togids', function()
    showIDs = not showIDs
    lib.notify({
        title = 'Nametags',
        description = showIDs and 'IDs are now ON' or 'IDs are now OFF',
        type = showIDs and 'success' or 'inform',
        position = Config.NotifyPosition,
        duration = Config.NotifyDuration
    })
end, false)

RegisterCommand('ntmask', function(_, args)
    local current = LocalPlayer.state.nametagMasked or false
    local action = args and args[1] and tostring(args[1]):lower() or nil
    local newState
    if action == 'on' then
        newState = true
    elseif action == 'off' then
        newState = false
    else
        newState = not current
    end
    LocalPlayer.state:set('nametagMasked', newState, true)
    lib.notify({
        title = 'Nametags',
        description = newState and 'Your nametag is now HIDDEN' or 'Your nametag is now VISIBLE',
        type = newState and 'warning' or 'success',
        position = Config.NotifyPosition,
        duration = Config.NotifyDuration
    })
end, false)

local headBone = 0x796E

local function getDisplayName(targetPlayerId)
    local srvId = GetPlayerServerId(targetPlayerId)
    local bag = Player(srvId).state
    local rpName = bag and bag.rpName
    if not rpName or rpName == '' then return nil end
    if showIDs then
        return string.format('%s [%d]', rpName, srvId)
    else
        return rpName
    end
end

local function world3DToScreen2D(vec)
    local onScreen, sx, sy = World3dToScreen2d(vec.x, vec.y, vec.z)
    return onScreen, sx, sy
end

local function hasClearLineOfSight(fromPos, toPos, targetPed)
    local handle = StartShapeTestRay(fromPos.x, fromPos.y, fromPos.z, toPos.x, toPos.y, toPos.z, 511, PlayerPedId(), 7)
    local _, hit, _, _, entityHit = GetShapeTestResult(handle)
    if hit == 0 then
        return true
    end
    return entityHit == targetPed
end

local function drawText3D(text, worldPos, dist, colour)
    local scale
    if Config.ScaleWithDistance then
        local d = math.max(dist or 0.0, 0.0)
        local t = (8.0 / (d + 8.0))
        local computed = SAFE.BaseScale * (SAFE.FarFactor + (1.0 - SAFE.FarFactor) * t)
        scale = math.max(SAFE.MinScale, math.min(SAFE.MaxScale, computed))
    else
        scale = SAFE.BaseScale
    end
    scale = math.min(scale, SAFE.ScaleHardCap)

    SetDrawOrigin(worldPos.x, worldPos.y, worldPos.z, 0)
    SetTextScale(scale, scale)
    SetTextFont(SAFE.Font)
    SetTextProportional(1)
    if Config.UseDropShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    if Config.UseOutline then SetTextOutline() end
    SetTextCentre(1)
    local c = colour or BASE_COLOUR
    SetTextColour(c[1], c[2], c[3], c[4])
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        local wait = 500
        if nametagsEnabled then
            wait = 0
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)

            for _, ply in ipairs(GetActivePlayers()) do
                    local targetPed = GetPlayerPed(ply)

                    local srvId = GetPlayerServerId(ply)
                    local bag = Player(srvId).state
                    if bag and bag.nametagMasked then goto continue end

                    if IsPedInAnyVehicle(targetPed, false) then goto continue end

                    local coords = GetEntityCoords(targetPed)
                    local dist = #(myCoords - coords)
                    if dist <= Config.MaxDistance then
                        local head = GetPedBoneCoords(targetPed, headBone)
                        local pos = vector3(head.x, head.y, head.z + Config.ZOffset)
                        -- I'm fucking tweaking
                        if Config.RequireLineOfSight then
                            local cam = GetGameplayCamCoord()
                            if not hasClearLineOfSight(cam, pos, targetPed) then goto continue end
                        end
                        local label = getDisplayName(ply)
                        if not label then goto continue end
                        local colour = nil
                        if markMap[srvId] then
                            colour = MARK_COLOUR
                        elseif friendMap[srvId] then
                            colour = FRIEND_COLOUR
                        end
                        drawText3D(label, pos, dist, colour)
                    end
                ::continue::
            end
        end
        Wait(wait)
    end
end)
