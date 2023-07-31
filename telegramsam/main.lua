bot         = {}
keyboard    = { ["ids"]={}, ["blocks"]={} }
TelegramURL = "https://api.telegram.org/bot" 

ERROR_CODE = { 
    [400] = "Telegram BAD REQUEST",
    [401] = "Telergam UNAUTHORIZED",
    [403] = "Telegram FORBIDDEN",
    [404] = "Telegram METHOD NOT_FOUND",
    [420] = "Telegram FLOOD",
    [500] = "Telergam INTERNAL"
}

addEvent("onTelegramNewMessage") 
addEvent("onTelegramCallbackReceive")

function CheckVar(data, msg)
    for k=1, #data do -- data format : {{var, var_name, var_need_type}}
        if type(data[k][1])~=data[k][3] then
            return error("[Telegram Sam][Error] : Cant "..msg.." "..data[k][2].." must be "..data[k][3].." but "..type(data[k][1]).." was given", 3)
        end
    end
end

local function TelegramGetLastUpdate(respData, respCode, key)
    if respCode == 0 then
        local _result = fromJSON(respData)["result"] 
        -- fetching telegram response result

        bot[key].lastUpdate = (_result[#_result] and _result[#_result]["update_id"] or 100) 
        -- updating last update
        -- if not last_update in telegram response, so set it to 100 (or whatever number it doesnt even matter)
        return
    end

    error("[Telegram Sam][Error] : Cant get last update", 3) 
end

local function TelegramConnect(respData, respCode, key)
    if respCode == 0 then 
        local respData = fromJSON(respData) 
        -- fetching telegram getMe response to table

        outputDebugString("[Telegram Sam] : Succefully connected as " .. respData["result"]["first_name"], 3)
        fetchRemote(TelegramURL .. bot[key].token .. "/getUpdates", "r"..key, 10, 5000, TelegramGetLastUpdate, "", false, key) -- fetchRemote to get last update
        return
    end

    error("[Telegram Sam][Error] : Login error occurred Invalid token", 3) 
    bot.token = nil 
end

local function TelegramCallbackHandler(respData, respCode, key)
    if not respData or not respCode then return end
    local _result = fromJSON(respData)["result"]

    if respCode == 0 then
        if _result[#_result] and _result[#_result]["update_id"] > bot[key].lastUpdate then 
            bot[key].lastUpdate = _result[#_result]["update_id"]

            if _result[#_result]["message"] then 
                triggerEvent("onTelegramNewMessage", root, _result[#_result].message)
            elseif _result[#_result]["callback_query"] then
                local _callbackResult = _result[#_result].callback_query.message
                _callbackResult["callback_data"] = {id=_result[#_result].callback_query.data}

                triggerEvent("onTelegramCallbackReceive", root, _callbackResult)
            end
        end
    end
end

local function ListenLongpoll(key) 
    if bot[key].token and bot[key].lastUpdate then 
        fetchRemote(TelegramURL .. bot[key].token .. "/getUpdates?offset=" .. bot[key].lastUpdate, "r"..key, 10, 5000, TelegramCallbackHandler, "", false, key)
    end

    setTimer(ListenLongpoll, 500, 1, key) 
    -- if token not set and lastUpdate dont set, so try again. it made to if ListenLongpoll starts earlier than telegramConnected
end

local function GenerateRandom(gen_string, len) -- function to generate random key
    local _result = {}

    for x=1, len do 
        local _random = math.random(1, #gen_string) 
        -- getting some random char from str
        table.insert(_result, string.sub(gen_string, _random, _random))
    end

    return table.concat(_result)
end

function BotSendRequest(key, reqName, ...) -- sendRequest to bot or keyboard functions from another resource
    CheckVar({{key, "key", "string"}, {reqName, "reqName", "string"}}, "cant send request @ ")

    assert(bot[key], "[Telegram Sam][Error] : Cant send request @ key not found, to registr resource use BotLogin first")
    assert(bot[reqName] or keyboard[reqName], "[Telegram Sam][Error] : Cant send request @ request not found")

    if bot[reqName] then 
        return bot[reqName](bot[token], key, unpack({...}))
    end

    return keyboard[reqName](_, key, unpack({...}))
end

function BotLogin(resourceName, token) -- checking bot token and start listen to longpoll
    assert(token, "[Telegram Sam][BotLogin] : Token not set")
    CheckVar({{token, "token", "string"}, {resourceName, "resourceName", "string"}}, "cant login @ ")

    local randomWord = GenerateRandom(resourceName, 6)
    bot[randomWord] = {token = token}

    fetchRemote(TelegramURL .. bot[randomWord].token .. "/getMe", "r"..randomWord, 10, 5000, TelegramConnect, "", false, randomWord)
    setTimer(function() if bot[randomWord].token then ListenLongpoll(randomWord) end end, math.random(3, 5)*1000, 1)

    return {key=randomWord}
end 