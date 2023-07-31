local TOKEN = ""
local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), TOKEN) -- Login bot and registr this resource

function Bot:SendRequest(reqName, ...) -- creating request function
    return exports["telegramsam"]:BotSendRequest(self.key, reqName, ...)
end

local MyKeyboardWith4Buttons = Bot:SendRequest("InitKeyboard", "myKeyboard4but", false)
local MyKeyboardWith2Buttons = Bot:SendRequest("InitKeyboard", "myKeyboard2but", false) -- init reply_keyboard

Bot:SendRequest("AddRow", MyKeyboardWith4Buttons, {{"Button 1"}, {"Button 2"}}) -- add row to keyboard in format table {{1_Button_Text}, {2_Button_Text}}
Bot:SendRequest("AddRow", MyKeyboardWith4Buttons, {{"Button 3"}, {"Button 4"}}) 
Bot:SendRequest("AddRow", MyKeyboardWith2Buttons, {{"Button 1"}, {"Button 2"}})

local function MessageHandler(message)
    if message.text == "Button 1" or message.text == "Button 3" then -- so by click to Button 1 or Button 2 it will send message with another keyboard
        Bot:SendRequest("SendMessage", message.chat.id, "Hi!\n\nThis is my keyboard with 2 buttons\nClick to button: ", MyKeyboardWith2Buttons)
        return 
    end

    Bot:SendRequest("SendMessage", message.chat.id, "Hi!\n\nThis is my keyboard with 4 buttons\nClick to button: ", MyKeyboardWith4Buttons)
end

addEventHandler("onTelegramNewMessage", root, MessageHandler) -- set event handler to receive telegram messages
