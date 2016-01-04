define("game_room", [], () ->
    ConstructGameRoom = (id) ->
        return {
            id: id
            players: []
            stackTopCard: null
        }

    return {
        ConstructGameRoom: ConstructGameRoom
    }
)