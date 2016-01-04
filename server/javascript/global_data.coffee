define("global_data", [], () ->
    gameRooms = {}
    players = {}

    FindRoomFromPlayerId = (playerId) ->
        gameRooms[players[playerId].currentGameRoomId]

    return {
        gameRooms: gameRooms
        players: players
        FindRoomFromPlayerId: FindRoomFromPlayerId
    }
)