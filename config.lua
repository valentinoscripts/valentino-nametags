Config = {}

-- scaling options
Config.MaxDistance = 25.0     -- max draw distance
Config.ZOffset = 0.35         -- how high above head to draw
Config.BaseScale = 0.35       -- base text scale (close range)
Config.ScaleWithDistance = true
Config.RequireLineOfSight = true -- hide tags through objects
Config.FarScaleFactor = 0.50     -- size at max distance relative to BaseScale (0.1..1.0)

-- appearance
Config.UseOutline = true
Config.UseDropShadow = true

-- Colors (hex). Supports #RRGGBB or #RRGGBBAA
Config.HexColour = '#FFFFFFE6'   -- base text color (white with ~0.9 alpha)
Config.FriendHex = '#0A3278E6'   -- friend color (dark blue)
Config.MarkHex = '#781414E6'     -- mark color (dark red)

-- notifications
Config.NotifyPosition = 'center-right'
Config.NotifyDuration = 5000 -- ms

-- framework selection
-- Options: 'auto' | 'esx' | 'qbcore' | 'qbx' | 'standalone'
Config.Framework = 'auto'

-- advanced scaling options
Config.MinScale = 0.25         -- lower bound when far away
Config.MaxScale = 0.45         -- upper bound when very close
Config.ScaleHardCap = 0.90     -- absolute max applied to final scale (safety)

return Config
