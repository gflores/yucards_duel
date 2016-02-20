define("chat_messages", [], () ->
    id_keys = require("id_keys")
    Messages = new Meteor.Collection(id_keys.GetChatMessagesCollectionName())
    Meteor.publish(id_keys.GetChatMessagesPublicationName(), () ->
        ms = Messages.find({}, {sort:{date: -1}, fields: {date: 1}, skip: 20, limit: 1}).fetch();
        if ms[0]? == false
            return Messages.find()
        return Messages.find({date: {$gte: ms[0].date}})
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