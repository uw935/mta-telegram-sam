-- TODO : Add more telegram functions, work with chats


local function GetResult(respData, respCode, CallbackData)
    if respCode == 0 then
        if CallbackData then
            local _callbackData = fromJSON(respData)["result"]  
            if type(_callbackData) ~= "table" then 
                _callbackData = {status=_callbackData}
            end
            
            _callbackData["callback_data"] = CallbackData 
            triggerEvent("onTelegramCallbackReceive", root, _callbackData)  
        end

        return
    end

    error("[Telergam Sam][Error] : "..respCode.." "..ERROR_CODE[respCode], 3)
end

function bot:DeleteMessage(key, chat_id, message_id, response_data)
    CheckVar({{chat_id, "chat_id", "number"}, {message_id, "message_id", "number"}}, "delete message @ ")
    fetchRemote(TelegramURL..bot[key].token.."/deleteMessage?chat_id="..chat_id.."&message_id="..message_id, "r"..chat_id, 10, 5000, GetResult, "", false, response_data)
end

function bot:SendPhoto(key, chat_id, photo, caption, reply_markup, reply_to_message_id, response_data)
    CheckVar({{chat_id, "chat_id", "number"}, {photo, "photo", "string"}}, "send photo @ ")

    local request_text = TelegramURL..bot[key].token.."/sendPhoto?chat_id="..chat_id.."&photo="..photo
    if caption then
        CheckVar({{caption, "caption", "string"}}, "send photo @ ")
        request_text = request_text.."&caption="..caption
    end
    if reply_to_message_id then 
        CheckVar({{reply_to_message_id, "reply_to_message_id", "number"}}, "send photo @ ")
        request_text = request_text.."&reply_to_message_id="..tostring(reply_to_message_id)
    end
    if reply_markup then
        CheckVar({{reply_markup, "reply_markup", "number"}}, "send photo @ ")
        
        assert(keyboard[key][reply_markup], "[Telegram Sam][Error] : Cant send photo @ reply_markup keyboard not found")
        reply_markup = toJSON(keyboard[key][reply_markup])
        reply_markup = string.sub(reply_markup, 3, #reply_markup-2)
        request_text = request_text.."&reply_markup="..reply_markup
    end

    fetchRemote(request_text, "r"..chat_id, 10, 5000, GetResult, "", false, response_data) 
end

function bot:EditMessage(key, chat_id, message_id, text, caption, response_data)
    CheckVar({{chat_id, "chat_id", "number"}, {text, "text", "string"}, {message_id, "message_id", "number"}}, "edit message @ ")
    local action = (caption and "Caption?caption=" or "Text?text=")  
    fetchRemote(TelegramURL..bot[key].token.."/editMessage"..action..text.."&chat_id="..chat_id.."&message_id="..message_id, 10, 500, GetResult, "", false, response_data)
end

function bot:EditMessageReplyMarkup(key, chat_id, message_id, reply_markup, response_data)
    CheckVar({{chat_id, "chat_id", "number"}, {message_id, "message_id", "number"}, {reply_markup, "reply_markup", "number"}}, "edit message reply markup @ ")
    assert(keyboard[key][reply_markup], "[Telegram Sam][Error] : Cant send message @ reply_markup keyboard not found")
    
    reply_markup = toJSON(keyboard[key][reply_markup])  
    reply_markup = string.sub(reply_markup, 3, #reply_markup-2)

    fetchRemote(TelegramURL..bot[key].token.."/editMessageReplyMarkup?chat_id="..chat_id.."&reply_markup="..reply_markup.."&message_id="..message_id, 10, 500, GetResult, "", false, response_data)
end

function bot:SendMessage(key, chat_id, text, reply_markup, disable_notification, reply_to_message_id, disable_web_page_preview, response_data)
    CheckVar({{chat_id, "chat_id", "number"}, {text, "text", "string"}}, "send message @ ")

    local request_text = TelegramURL..bot[key].token.."/sendMessage"
    text = string.gsub(text, "\n", "%%0A") -- changing \n to %0A
    request_text = request_text.."?chat_id="..chat_id.."&text="..text
    
    if reply_markup then
        CheckVar({{reply_markup, "reply_markup", "number"}}, "send message @ ")
        assert(keyboard[key][reply_markup], "[Telegram Sam][Error] : Cant send message @ reply_markup keyboard not found")

        reply_markup = toJSON(keyboard[key][reply_markup])
        reply_markup = string.sub(reply_markup, 3, #reply_markup-2)
        request_text = request_text.."&reply_markup="..reply_markup
    end

    if disable_notification then
        CheckVar({{disable_notification, "disable_notification", "boolean"}}, "cant send message @ ")
        request_text = request_text.."&disable_notification="..tostring(disable_notification)
    end
    
    if reply_to_message_id then
        CheckVar({{reply_to_message_id, "reply_to_message_id", "number"}}, "cant send message @ ")
        request_text = request_text.."&reply_to_message_id="..tostring(reply_to_message_id)
    end

    if disable_web_page_preview then 
        CheckVar({{disable_web_page_preview, "disable_web_page_preview", "boolean"}}, "cant send message @ ")
        request_text = request_text.."&disable_web_page_preview="..tostring(disable_web_page_preview)
    end
    fetchRemote(request_text, "r"..chat_id, 10, 5000, GetResult, "", false, response_data)
end

-- function bot:SendSticker(key, chat_id, sticker_file, disable_notification, response_data) -- soon
--     CheckVar({{chat_id, "chat_id", "number"}, {sticker_file, "sticker_file", "string"}}, "cant send sticker @ ")
    
--     local request_text = TelegramURL..bot[key].token.."/sendSticker"
--     request_text = request_text.."?chat_id="..chat_id.."&text="..sticker_file

--     if disable_notification then
--         CheckVar({{disable_notification, "disable_notification", "boolean"}}, "cant send sticker @ ")
--         request_text = request_text.."&disable_notification="..disable_notification
--     end
    
--     fetchRemote(request_text, "r"..chat_id, 10, 5000, GetResult, "", false, response_data)
-- end

