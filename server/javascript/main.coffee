define("main", [
 "game_room", "custom_collection_publisher", "global_data", "cards",
 "card_elements", "utils", "id_keys"
 ], () ->
    return 42
)

require(["main"], () ->
    Meteor.startup(()->
        game_room = require("game_room")
        game_room.SetupRoomsCommunication()
    )
)