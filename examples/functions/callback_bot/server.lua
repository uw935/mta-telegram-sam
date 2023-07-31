local TOKEN = ""
local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), TOKEN) -- Login bot and registr this resource

function Bot:SendRequest(reqName, ...) -- creating request function what would be convenient
    return exports["telegramsam"]:BotSendRequest(self.key, reqName, ...) -- sending request
end

local function CallbackHandler(cData)
    if cData.callback_data.id == "mycallback" then 
        Bot:SendRequest("EditMessage", cData.chat.id, cData.message_id, cData.callback_data.message) -- editing message to user's
        -- cData have almost the same structe with message in MessageHandler
        -- exclude table callback_data
    end
end

local function MessageHandler(message)
    Bot:SendRequest("SendMessage", message.chat.id, "Hello\n"..message.chat.first_name..", i know what you write me!", false, false, false, false, {["id"]="mycallback", ["message"]=message.text})
end

addEventHandler("onTelegramNewMessage", root, MessageHandler) -- set event handler to receive telegram messages
addEventHandler("onTelegramCallbackReceive", root, CallbackHandler) -- set event handler to receive telegram callback events



