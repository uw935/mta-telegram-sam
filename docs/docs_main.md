<p align="center">
  <img align="center" src="../imgs/docs_main.png">
  <h3 align="center">Telegram Sam v1.0.0</h3>
  <p align="center">Simple Multi Theft Auto Lua library for <a href="https://core.telegram.org/bots/api">Telegram Bot API</a><p>
</p>

## Documentation
## How does it briefly work?
Library use longpoll to get information from Telegram. Every 500ms it checks Telegram getUpdates, 
and when there is new update (last update doesnt match with currently) it triggering server event called **"onTelegramNewMessage"**, 
when it is new message, but when it is callback query, triggering another event called **"onTelegramCallbackReceive"**. 


Library use fetchRemote to request Telegram information. Due to that, all Telegram API actions are provides by callback. 
For example, if you want to get some information about message you have sent, you need to pass response_data through the function and create "onTelegramCallbackReceive" eventHandler to receive callbacks. 

## Telegram Error Codes
+ 400 Telegram BAD REQUEST : https://core.telegram.org/api/errors#400-bad-request
+ 401 Telergam UNAUTHORIZED : https://core.telegram.org/api/errors#401-unauthorized 
+ 403 Telegram FORBIDDEN : https://core.telegram.org/api/errors#403-forbidden
+ 404 Telegram METHOD NOT_FOUND : https://core.telegram.org/api/errors#404-not-found
+ 420 Telegram FLOOD : https://core.telegram.org/api/errors#420-flood
+ 500 Telergam INTERNAL : https://core.telegram.org/api/errors#500-internal

<br>

## Events
## onTelegramNewMessage
This event triggered  when new message from Telegram was received
### Parameters
```
  table message
```
+ message: Telegram message type, more you can see here: https://core.telegram.org/bots/api#message
### Examples
This examples sends "Hello world" whenever a new message received
```Lua
addEventHandler("onTelegramNewMessage", root, function(message)
  exports["telegramsam"]:BotSendRequest(Bot.key, "SendMessage", message.chat.id, "Hello world!")
end)
```
![image](https://github.com/uw935/mta-telegram-sam/assets/74175088/86ae0649-2ae5-4240-9344-cd7ab1a3e196)

## onTelegramCallbackReceive
This event triggered when new callback received from Telegram OR when it need to return the result of the callback function
### Parameters
```
  table callbackData
```
+ callbackData: table that contain telegram function result and response_data in callback_data
### Examples
This example sends message that was just sent by callback data
```Lua
addEventHandler("onTelegramCallbackReceive", root, function(cData) -- cData = calbackData (short)
  if cData.callback_data.id == "mycallbackdata" then 
    exports["telegramsam"]:BotSendRequest(Bot.key, "SendMessage", cData.chat.id, cData.text.." message with that text was sent!")
  end
end)

addEventHandler("onTelegramNewMessage", root, function(message)
  exports["telegramsam"]:BotSendRequest(Bot.key, "SendMessage", message.chat.id, "Your just wrote me: "..message.text, false, false, false, false, {id="mycallbackdata"})
end)
```
![image](https://github.com/uw935/mta-telegram-sam/assets/74175088/1fe58f37-e8b2-433b-ba70-229f8fa1a526)

<br>

## Export functions
## BotLogin
This function registers resource in library table, check token to it work and starting listening longpoll.
### Syntax
```
  table BotLogin( string resourceName, string token ) 
```
### Arguments
+ resourceName: the name of resource to register
+ token: bot token you received from BotFather
### Returns
Returns table contain key to contact with library
### Examples
This example put table with key to local variable called "Bot" and then prints bot key.
```Lua
local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), token)
print(Bot.key)
```

<br>

## BotSendRequest
This function allowed you to contact with library functions. 
### Syntax 
```
  BotSendRequest( string key, string functionName, arguments... )
```
### Arguments
+ key: a key from BotLogin table
+ functionName: a name of function you want to call
+ arguments: arguments to function you want to call
### Returns
Returns the same as the function you want to call
### Examples
This example sends "Hello!" message when entering "/sendTelegramHello" with some telegram id. 

Note: User with this ID must write something to bot first to let bot write him
```Lua
  local Bot = exports["telegramsam"]:BotLogin(getResourceName(getThisResource()), token)
  addCommandHandler("sendTelegramHello", function(_, _, telegramId)
    exports["telegramsam"]:BotSendRequest(Bot.key, "SendMessage", tonumber(telegramId), "Hello!")
  end)
```

## Other documentation
+ [About keyboard](https://github.com/uw935/mta-telegram-sam/blob/master/docs/docs_keyboards.md)
+ [About functions](https://github.com/uw935/mta-telegram-sam/blob/master/docs/docs_functions.md)
+ [Main documentation](https://github.com/uw935/mta-telegram-sam/blob/master/docs/docs_main.md)
