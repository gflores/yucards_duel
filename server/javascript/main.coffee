DEF("main", [
 "game_room", "custom_collection_publisher", "global_data", "cards", "users", "chat_messages", "duels", "music_manager"
 "card_elements", "utils", "id_keys", "card_utils_shared", "shared_constants", "user_rank"
 ], () ->
    return 42
)

REQ(["main"], () ->
    Meteor.startup(()->
        process.env.MAIL_URL = "smtp://gael@blitzrps.com:blitzrpsITACHI999@smtp.gmail.com:465/"

        Meteor.users.update({}, {$set: 
            {
                "isPlaying": false
                "oppenedLinks": {}
                "currentRoomID": null
            }
        }, {multi: true}
        )

        game_room = REQ("game_room")
        game_room.SetupRoomsCommunication()

        cards = REQ("cards")
        cards.SetupCardActions()
    )
)