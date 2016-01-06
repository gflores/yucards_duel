define("main", [
 "player_data", "opponent_data", "game_data", "global_data", "cards", "player_actions", "card_elements", "communication"
 "card_elements", "utils", "id_keys", "card_utils_shared"
 ], () ->
    return 42
)


Meteor.loginVisitor()



require(["main"], () ->
    JoinGameRoom = (roomId) ->
        game_data = require("game_data")
        game_data.set("IsGameRoomReady", false)

        Deps.autorun( () ->
            if (Meteor.userId() != null)
                console.log("userId: #{Meteor.userId()}")

                communication = require("communication")

                communication.RegisterToRoom(roomId)

                
                cards = require("cards")
                card_elements = require("card_elements")


                player_data = require("player_data")

                player_data.set("UserId", Meteor.userId())
                player_data.set("CurrentScore", 0)
                player_data.set("MaxScore", 60)

                # player_data.set("Card0", cards.Construct(8, card_elements.elements.SCISSOR, 0))
                # player_data.set("Card1", cards.Construct(3, card_elements.elements.ROCK, 1))
                # player_data.set("Card2", cards.Construct(7, card_elements.elements.PAPER, 2))

                # opponent_data = require("opponent_data")

                # opponent_data.set("UserId", "badguyID")
                # opponent_data.set("CurrentScore", 15)
                # opponent_data.set("MaxScore", 60)

                # opponent_data.set("Card0", cards.Construct(2, card_elements.elements.ROCK, 0))
                # opponent_data.set("Card1", cards.Construct(6, card_elements.elements.PAPER, 1))
                # opponent_data.set("Card2", cards.Construct(9, card_elements.elements.SCISSOR, 2))
        )




    Router.route('/', () ->
        JoinGameRoom("<defaultRoomId>")
    )
    Router.route('/:roomId', () ->
        JoinGameRoom(this.params.roomId)
    )
)