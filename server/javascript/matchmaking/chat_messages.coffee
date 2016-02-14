define("chat_messages", [], () ->
    id_keys = require("id_keys")
    Messages = new Meteor.Collection(id_keys.GetChatMessagesCollectionName())
    Meteor.publish(id_keys.GetChatMessagesPublicationName(), () ->
        return Messages.find()
    )
    Meteor.methods({
        "send_public_chat_message": (messageText) ->
            if this.userId? == false
                throw Meteor.Error("<send_public_chat_message>: no userId")
            Messages.insert({text: messageText, user: Meteor.user(), date: new Date()})
    })

    return {
        Messages: Messages
    }
)