Template.matchmakingView.helpers({
    GetOnlineUsers: () ->
        return Meteor.users.find().fetch()
    GetMessagesToDisplay: () ->
        return require("chat_messages").Messages.find().fetch()
        # return [
        #     {user: {username: "Toto"}, text: "Salut mon grand !"}
        #     {user: {username: "Alberto"}, text: "Hello I would like to say that I don't know"}
        #     {user: {username: "Toto"}, text: "It's a me again !!"}
        #     {user: {username: "Toto"}, text: "And againnnn"}
        # ]
})


SendCurrentMessage = () ->
    messageText = $('#message-input-box textarea')[0].value
    if messageText == ""
        return false
    require("chat_messages").SendMessage(messageText)
    $('#message-input-box textarea')[0].value = ""

Template.matchmakingView.events({
    'keydown #message-input-box textarea': (event) ->
        if (event.which == 13)
            event.preventDefault()
            SendCurrentMessage()
    'click #message-input-box .send-message': (event) ->
        SendCurrentMessage()
})