function keyboard:InitKeyboard(key, id, inline)  
    if not keyboard[key] then
        keyboard[key] = {}
    end

    if keyboard["ids"][key] and keyboard["ids"][key][id] then 
        keyboard["blocks"][keyboard["ids"][key][id]] = true -- if trying to init keyboard second time so it will blocked by additing to special table
        return keyboard["ids"][key][id] -- but id of keyboard will returns
    end

    local key_index = #keyboard[key]+1 
    keyboard["ids"][key] = {id=key_index}

    keyboard[key][-2] = {
        ["remove_keyboard"] = true
    }

    keyboard[key][key_index] = {["keyboard"] = {}}

    if inline then 
        keyboard[key][key_index] = {["inline_keyboard"] = {}}
    end

    return key_index
end

function keyboard:ReplyKeyboardRemove(key, remove_keyboard)
    CheckVar({{remove_keyboard, "remove_keyboard", "boolean"}}, "cant remove keyboard @ ")
    keyboard[key][-2]["remove_keyboard"] = remove_keyboard
    return -2
end

function keyboard:AddRow(key, keyboard_index, ...)
    CheckVar({{keyboard_index, "keyboard_index", "number"}}, "cant create AddRow @ ")
    assert(keyboard[key][keyboard_index], "[Telegram Sam][Error] : Cant create AddRow @ keyboard_index not found @ You must init your keyboard using InitKeyboard")

    if keyboard["blocks"][keyboard_index] then return end

    local _result = {}
    
    for k, v in ipairs(unpack({...})) do
        assert(type(v[1])=="string", "[Telegram Sam][Error] : Cant create @ AddRow text (first index) must be string, but " .. type(v[1]) .. " were given")
        _result[k] = {
            text = v[1]
        }

        if keyboard[key][keyboard_index]["inline_keyboard"] then     
            if v[1] and not v[2] and not v[3] then 
                error("[Telegram Sam][Error] : Cant create @ AddRow, to create InlineKeyboard you must put something with text : callback_data or/and url", 2)
            end
            
            if v[2] then 
                CheckVar({{v[2], "callback_data", "string"}}, "Cant create @ AddRow")
            end

            if v[3] then 
                CheckVar({{v[3], "url", "string"}}, "Cant create @ AddRow")
            end

            _result[k] = {
                text=v[1],
                callback_data=v[2],
                url=v[3] or nil 
            }
        end
    end

    if keyboard[key][keyboard_index]["inline_keyboard"] then 
        table.insert(keyboard[key][keyboard_index]["inline_keyboard"], _result)
    else 
        table.insert(keyboard[key][keyboard_index]["keyboard"], _result)
    end
    
    return true
end

