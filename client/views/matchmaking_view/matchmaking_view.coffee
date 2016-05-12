Template.matchmakingView.helpers({
    GetClassForGuest: () ->
        return if Meteor.user().profile.guest then "is-guest" else ""
    GetOnlineUsers: () ->
        return Meteor.users.find().fetch()
    HashToArrayOfKeys: (hash) ->
        array = []
        for key of hash
            if (hash.hasOwnProperty(key))
                array.push(key)
        return array

    GetMessagesToDisplay: () ->
        return REQ("chat_messages").Messages.find().fetch()
        # return [
        #     {user: {username: "Toto"}, text: "Salut mon grand !"}
        #     {user: {username: "Alberto"}, text: "Hello I would like to say that I don't know"}
        #     {user: {username: "Toto"}, text: "It's a me again !!"}
        #     {user: {username: "Toto"}, text: "And againnnn"}
        # ]
    GetBaseDuelUrl: () ->
        url = Router.routes.duel.url({roomId: ""})
        if(url.match(/http:\/\//))
            url = url.substring(7);
        if(url.match(/^www\./))
            url = url.substring(4);
        return url
    GetDuelUrlFromId: (roomId) ->
        return Router.routes.duel.url({roomId: roomId})
    # GetRoomIdToDisplay: () ->
    #     return gameRoomIdToDisplay.get()
    GetUserStatusClass: (user) ->
        if user.isPlaying
            return "is-playing"
        else if REQ("utils").GetObjectSize(user.oppenedLinks) != 0
            return "is-waiting"
        else
            return "is-available"
})


SendCurrentMessage = () ->
    messageText = $('#message-input-box textarea')[0].value
    if messageText == ""
        return false
    REQ("chat_messages").SendMessage(messageText)
    $('#message-input-box textarea')[0].value = ""

gameRoomIdToDisplay = Math.floor((Math.random() * 999999) + 1).toString()

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
        REQ("chat_messages").SendMessage(Router.routes.duel.url({roomId: gameRoomIdToDisplay}))
        window.open(Router.routes.duel.url({roomId: gameRoomIdToDisplay}))

    'click #game-url': () ->
        REQ("utils").SelectTextById("game-url")
    'click #game-generator-area': () ->
        REQ("utils").SelectTextById("game-url")

    'mouseenter #contact-button': () ->
        $('#contact-button').hide();
        $('#contact-page').show();
    'mouseleave #contact-page': () ->
        $('#contact-button').show();
        $('#contact-page').hide();
    'mouseenter #online-users-list .user:not(.is-available)': (e) ->
        $(e.currentTarget).find('.user-status-extension').show();
    'mouseleave #online-users-list .user:not(.is-available)': (e) ->
        $(e.currentTarget).find('.user-status-extension').hide();


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
    # Meteor.call("get_random_available_room_id", (error, result) ->
    #     gameRoomIdToDisplay = result
    #     $(".battle-link #game-url").text(Router.routes.duel.url({roomId: gameRoomIdToDisplay}).replace(/.*?:\/\//g, ""))
    #     REQ("utils").SelectTextById("game-url")
    # )

    url = Router.routes.duel.url({roomId: gameRoomIdToDisplay})
    if(url.match(/http:\/\//))
        url = url.substring(7);
    if(url.match(/^www\./))
        url = url.substring(4);


    $(".battle-link #game-url").text(url)
    REQ("utils").SelectTextById("game-url")
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