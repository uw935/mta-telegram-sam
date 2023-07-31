local TOKEN = ""
local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), TOKEN) -- Login bot and registr this resource

function Bot:SendRequest(reqName, ...) -- creating request function
    return exports["telegramsam"]:BotSendReque
    

local MyKeyboardWith4Buttons = Bot:SendRequest("InitKeyboard", "myKeyboard4but", true)

Bot:SendRequest("AddRow", MyKeyboardWith4Buttons, {{"Link", "", "https://github.com"}, {"Callback", "myKeyboardCallback"}}) -- add row to keyboard in format table {{1_Button_Text}, {2_Button_Text}}
Bot:SendRequest("AddRow", MyKeyboardWith4Buttons, {{"Delete this message", "keyboardCallbackDeleteMessage"}, {"Button 4", "", "https://google.com/"}})

local function CallbackHandler(cData)
    if cData.callback_data.id == "myKeyboardCallback" then 
        Bot:SendRequest("SendMessage", cData.chat.id, "Hmm.. I think you just click to callback button")
    elseif cData.callback_data.id == "keyboardCallbackDeleteMessage" then
        Bot:SendRequest("DeleteMessage", cData.chat.id, cData.message_id) -- Deleting message
        Bot:SendRequest("SendMessage", cData.chat.id, "Message Deleted!")
    end
end

local function MessageHandler(message) 
    Bot:SendRequest("SendMessage", message.chat.id, "Hi!\n\nThis is my inline keyboard with 4 buttons\nClick them: ", MyKeyboardWith4Buttons)
end

addEventHandler("onTelegramNewMessage", root, MessageHandler) -- set event handler to receive telegram messages
addEventHandler("onTelegramCallbackReceive", root, CallbackHandler) -- set event handler to receive callbacks


