define("duels", [], () ->
    Meteor.methods({
        "get_random_available_room_id": () ->
            if this.userId? == false
                throw Meteor.Error("<get_random_available_room_id>: no userId")
            return require("game_room").GetAvailableRoomId()
    })

)