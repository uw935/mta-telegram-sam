local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), "yourtokenhere")

function Bot:SendRequest(requestName, ...)
  exports["telegramsam"]:BotSendRequest(self.key, requestName, ...)
end

local function MessageHandler(message)
  Bot:SendRequest("SendMessage", message.chat.id, message.text)
end
addEventHandler("onTelegramNewMessage", root, MessageHandler)