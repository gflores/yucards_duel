DEF("chat_messages", [], () ->
    id_keys = REQ("id_keys")
    Messages = new Meteor.Collection(id_keys.GetChatMessagesCollectionName())
    Meteor.subscribe(id_keys.GetChatMessagesPublicationName())

    SendMessage = (message) ->
        Meteor.call("send_public_chat_message", message, (error, result) ->
            console.log("error: '#{error}' | result: '#{result}'")
        )
    Meteor.methods({
        "send_public_chat_message": (messageText) ->
            if this.userId? == false
                throw Meteor.Error("<send_public_chat_message>: no userId")
            Messages.insert({text: messageText, user: Meteor.user(), date: new Date()})
    })

    return {
        Messages: Messages
        SendMessage: SendMessage
    }
)