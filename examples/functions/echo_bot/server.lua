local TOKEN = ""
local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), TOKEN) -- Login bot and registr this resource

function Bot:SendRequest(reqName, ...) -- creating request function
    return exports["telegramsam"]:BotSendRequest(self.key, reqName, ...)
end

local function MessageHandler(message)
    Bot:SendRequest("SendMessage", message.chat.id, "Hello my friend! I think your name is " .. message.chat.first_name.." and you write me: "..message.text)
end

addEventHandler("onTelegramNewMessage", root, MessageHandler) -- set event handler to receive telegram messages


