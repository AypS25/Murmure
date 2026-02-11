Murmure = {}
Murmure.name = "Murmure"
Murmure.prefix = "|c000000[ML]|r"
Murmure.maxDistance = 10

local function GetDistance3D(x1, y1, z1, x2, y2, z2)
    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Murmure.Send(text)
    if not text or text == "" then return end
    local msg = Murmure.prefix .. text
    StartChatInput(msg, CHAT_CHANNEL_SAY)
end

function Murmure.OnChatMessage(eventCode, channelType, fromName, text, isCustomerService, fromDisplayName)
    if channelType ~= CHAT_CHANNEL_SAY then return end

    if not zo_strstarts(text, Murmure.prefix) then return end

    local realText = string.sub(text, string.len(Murmure.prefix) + 1)

    if not DoesUnitExist("reticleover") then return end
    if not IsUnitPlayer("reticleover") then return end

    local targetName = GetUnitName("reticleover")
    if targetName ~= fromName then return end

    local _, px, py, pz = GetUnitWorldPosition("player")
    local _, tx, ty, tz = GetUnitWorldPosition("reticleover")

    if not px or not tx then return end

    local dist = GetDistance3D(px, py, pz, tx, ty, tz)

    if dist > Murmure.maxDistance then return end

    d(string.format("|c00FF00[Murmure]|r %s say : %s", fromName, realText))
end

SLASH_COMMANDS["/mm"] = function(text)
    Murmure.Send(text)
end

function Murmure.OnAddOnLoaded(event, addonName)
    if addonName ~= Murmure.name then return end

    EVENT_MANAGER:RegisterForEvent(
        Murmure.name,
        EVENT_CHAT_MESSAGE_CHANNEL,
        Murmure.OnChatMessage
    )

    d("|c00FF00Murmure loaded. Use /mm <message>|r")
end

EVENT_MANAGER:RegisterForEvent(
    Murmure.name,
    EVENT_ADD_ON_LOADED,
    Murmure.OnAddOnLoaded
)
