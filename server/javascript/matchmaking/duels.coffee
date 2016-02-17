define("duels", [], () ->
    Meteor.methods({
        "get_random_available_room_id": () ->
            if this.userId? == false
                throw Meteor.Error("<send_public_chat_message>: no userId")
            Messages.insert({text: messageText, user: Meteor.user(), date: new Date()})
    })

)