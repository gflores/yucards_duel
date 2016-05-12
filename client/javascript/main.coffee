DEF("main", [
 "player_data", "opponent_data", "game_data", "global_data", "cards", "player_actions", "card_elements", "communication", "feedback_launcher", "animation_utils", "chat_messages", "music_manager"
 "card_elements", "utils", "id_keys", "card_utils_shared", "shared_constants", "user_rank"
 ], () ->
    return 42
)


Meteor.loginVisitor()



REQ(["main"], () ->
    JoinGameRoom = (roomId) ->
        game_data = REQ("game_data")
        game_data.set("IsGameRoomReady", false)
#        game_data.set("isDiscardButtonAvailable", true)
        game_data.set("IsGameFinished", false)
        game_data.set("IsWinner", false)
        game_data.set("isDisplayingInstructions", false)
        if BrowserDetect.browser == "Chrome" or BrowserDetect.browser == "Opera"
            game_data.set("isGoodBrowser", true)
        else
            game_data.set("isGoodBrowser", false)

        game_data.set("StackCards", [])

        Meteor.setTimeout(() ->
            Deps.autorun( () ->
    #        Meteor.loginVisitor(undefined, () ->
                if (Meteor.userId() != null)
                    console.log("userId: #{Meteor.userId()}")

                    # if Meteor.user().isMusicMuted == true
                    #     REQ("music_manager").Mute()

                    communication = REQ("communication")

                    communication.RegisterToRoom(roomId)

                    
                    cards = REQ("cards")
                    card_elements = REQ("card_elements")


                    player_data = REQ("player_data")

                    player_data.set("UserId", Meteor.userId())
                    player_data.set("CurrentLife", REQ("shared_constants").maxLife)
                    player_data.set("MaxLife", REQ("shared_constants").maxLife)
                    player_data.set("AreActionsAvailable", true)

                    # player_data.set("Card0", cards.Construct(8, card_elements.elements.SCISSOR, 0))
                    # player_data.set("Card1", cards.Construct(3, card_elements.elements.ROCK, 1))
                    # player_data.set("Card2", cards.Construct(7, card_elements.elements.PAPER, 2))

                    # opponent_data = REQ("opponent_data")

                    # opponent_data.set("UserId", "badguyID")
                    # opponent_data.set("CurrentLife", 15)
                    # opponent_data.set("MaxLife", 60)

                    # opponent_data.set("Card0", cards.Construct(2, card_elements.elements.ROCK, 0))
                    # opponent_data.set("Card1", cards.Construct(6, card_elements.elements.PAPER, 1))
                    # opponent_data.set("Card2", cards.Construct(9, card_elements.elements.SCISSOR, 2))
            )

        , 2000)



    Router.route('/', {
        name: "mainRoom"
        action: () ->
            this.render("matchmakingView")
        }
    )
    Router.route('/play/:roomId', {
        name: "duel"
        action: () ->
            JoinGameRoom(this.params.roomId)
            this.render("duelView")
        }
    )
)