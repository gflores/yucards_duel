
Template.matchmakingView.helpers({
    GetClassForGuest: () ->
        return if Meteor.user().profile.guest then "is-guest" else ""
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
    GetBaseDuelUrl: () ->
        return Router.routes.duel.url({roomId: ""})
    # GetRoomIdToDisplay: () ->
    #     return gameRoomIdToDisplay.get()
})


SendCurrentMessage = () ->
    messageText = $('#message-input-box textarea')[0].value
    if messageText == ""
        return false
    require("chat_messages").SendMessage(messageText)
    $('#message-input-box textarea')[0].value = ""

gameRoomIdToDisplay = ""

Template.matchmakingView.events({
    'keydown #message-input-box textarea': (event) ->
        if (event.which == 13)
            event.preventDefault()
            SendCurrentMessage()
    'click #message-input-box .send-message': (event) ->
        SendCurrentMessage()

    'click .generate-new-link': (event) ->
        Meteor.call("get_random_available_room_id", (error, result) ->
            gameRoomIdToDisplay = result
            $(".battle-link input")[0].value = gameRoomIdToDisplay
        )

    'click .launch-battle': (event) ->
        require("chat_messages").SendMessage(Router.routes.duel.url({roomId: gameRoomIdToDisplay}))
        window.open(Router.routes.duel.url({roomId: gameRoomIdToDisplay}))
})

ScrollChatToBottom = () ->
    messagesListArea = $("#messages-list-area")
    messagesListArea.scrollTop(999999)
    console.log("scrollheight: #{messagesListArea[0].scrollHeight}")



Template.matchmakingView.onRendered(() ->
    Meteor.setTimeout(ScrollChatToBottom, 100)
    Meteor.setTimeout(ScrollChatToBottom, 200)
    Meteor.setTimeout(ScrollChatToBottom, 300)
    Meteor.setTimeout(ScrollChatToBottom, 500)
    Meteor.setTimeout(ScrollChatToBottom, 1000)
)



Template.chatMessage.onRendered(() ->
    messagesListArea = $("#messages-list-area")
    messagesListArea.scrollTop(messagesListArea.scrollTop() + this.$(".message").height())
    # if isChatScrolledToBottom
    #     ScrollChatToBottom()
)
Template.chatMessage.helpers({
    GetClassForGuest: () ->
        return if this.message.user.profile.guest then "is-guest" else ""

    GetTimeToDisplay: () ->
        date = this.message.date
        date = new Date(date.getTime())
        return "#{date.getHours()}:#{date.getMinutes()}:#{date.getSeconds()}"
})