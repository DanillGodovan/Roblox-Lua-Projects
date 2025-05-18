local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")

local USER_TOKEN        = "TOKEN"
local COMMAND_PREFIX    = "Aura"

local SERVER_CONFIG = {
    ["1365946084412751913"] = { parseType = 1, placeId = 85896571713843 },
    ["1364301653947449365"] = { parseType = 2 }
}

local lastMessageId = {}
local lastJobId     = {}

local requestFunc = (http and http.request) or request
if not requestFunc then
    warn("❌ AWP have no access to http.request!")
    return
end

local function fetchLatestCommand(channelId)
    local cfg = SERVER_CONFIG[channelId]
    if not cfg then
        warn("⚠️ No Configuration for Channel: " .. channelId)
        return nil
    end

    local response = requestFunc({
        Url     = string.format("https://discord.com/api/v9/channels/%s/messages?limit=1", channelId),
        Method  = "GET",
        Headers = {
            ["Authorization"] = USER_TOKEN,
            ["Content-Type"]  = "application/json",
            ["User-Agent"]    = "RobloxClient/1.0"
        }
    })

    if not response or response.StatusCode ~= 200 then
        warn("❌ Ошибка запроса: ", response and response.StatusCode, response and response.Body)
        return nil
    end

    local data = HttpService:JSONDecode(response.Body)
    if #data == 0 then return nil end

    local message = data[1]
    if lastMessageId[channelId] == message.id then
        return nil
    end

    local embed = message.embeds and message.embeds[1]
    if not embed or not embed.title or not embed.title:find(COMMAND_PREFIX) then
        return nil
    end

    return message.id, embed.description, cfg
end

local function prepareCode(rawDesc, cfg, channelId)
    local inside = rawDesc:match("
lua(.-)
")

    if cfg.parseType == 1 then
        local jobId = rawDesc:match("JobID%s*[:=]%s*(%d+)")
        if not jobId then
            warn("❌ There's no JobID in Description.")
            return nil
        end
        -- Сравниваем с предыдущим
        if lastJobId[channelId] == jobId then
            print("⏹ JobID "..jobId.." was used, skip")
            return nil
        end
        lastJobId[channelId] = jobId
        return string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s")',
            cfg.placeId,
            jobId
        )

    elseif cfg.parseType == 2 then
        if not inside then
            warn("❌ In description there is no 
lua ...
 block.")
            return nil
        end
        return inside:match("^%s*(.-)%s*$")

    else
        warn("⚠️ Unknown parseType: " .. tostring(cfg.parseType))
        return nil
    end
end

local function executeSafe(code)
    print("🧠 Execution from Embed:")
    print(code)

    local func, err = loadstring(code)
    if not func then
        warn("❌ Code Compilation Error: ", err)
        return
    end

    local ok, result = pcall(func)
    if not ok then
        warn("🔥 Execution Error: ", result)
    else
        print("✅ Code has been executed successfully.")
    end
end

while true do
    local success, err = pcall(function()
        for channelId, cfg in pairs(SERVER_CONFIG) do
            local msgId, rawDesc, cfgData = fetchLatestCommand(channelId)
            if msgId and rawDesc and cfgData then
                local codeToExec = prepareCode(rawDesc, cfgData, channelId)
                if codeToExec then
                    executeSafe(codeToExec)
                end
                lastMessageId[channelId] = msgId
            end
        end
    end)
    if not success then
        warn("💥 Error in Main Loop: ", err)
    end
    wait(15)