local TOKEN = ""
local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), TOKEN) 

local menu = {}

function Bot:SendRequest(reqName, ...) 
    return exports["telegramsam"]:BotSendRequest(self.key, reqName, ...)
end

local keyboard = Bot:SendRequest("InitKeyboard", "menu", true)
Bot:SendRequest("AddRow", keyboard, {{"Server online", "serveronline"}, {"Send message to chat", "sendMessage"}})

local function MessageHandler(message)
    if menu[message.chat.id] == "writesomething" then 
        outputChatBox(message.text, root, 231, 217, 176, true)
        print(message.text)
        Bot:SendRequest("SendMessage", message.chat.id, "Message " .. message.text .. " sent!")
        menu[message.chat.id] = nil
        return
    end

    Bot:SendRequest("SendPhoto", message.chat.id, "https://imgur.com/a/FULuGmA")
    Bot:SendRequest("SendMessage", message.chat.id, "Hi, choose what do you want: ", keyboard, true, message.message_id)
end

local function CallbackHandler(cData) -- callbackData
    if cData.callback_data.id == "serveronline" then
        Bot:SendRequest("EditMessage", cData.chat.id, cData.message_id, "Player count: "..getPlayerCount(), false)
        Bot:SendRequest("EditMessageReplyMarkup", cData.chat.id, cData.message_id, keyboard)

    elseif cData.callback_data.id == "sendMessage" then 
        Bot:SendRequest("EditMessage", cData.chat.id, cData.message_id, "Write what do you want to send: ", false)
        Bot:SendRequest("EditMessageReplyMarkup", cData.chat.id, cData.message_id, keyboard)
        menu[cData.chat.id] = "writesomething"
    end
end

addEventHandler("onTelegramNewMessage", root, MessageHandler)
addEventHandler("onTelegramCallbackReceive", root, CallbackHandler)
