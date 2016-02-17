define("main", [
 "game_room", "custom_collection_publisher", "global_data", "cards", "users", "chat_messages", "duels"
 "card_elements", "utils", "id_keys", "card_utils_shared", "shared_constants"
 ], () ->
    return 42
)

require(["main"], () ->
    Meteor.startup(()->
        game_room = require("game_room")
        game_room.SetupRoomsCommunication()

        cards = require("cards")
        cards.SetupCardActions()
    )
)