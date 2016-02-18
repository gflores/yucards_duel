define("global_data", [], () ->
    gameRooms = {}
    players = {}

    FindRoomFromPlayerId = (playerId) ->
        if players.hasOwnProperty(playerId) == false
            return null
        player = players[playerId]
        if player.currentGameRoomId == null or gameRooms.hasOwnProperty(player.currentGameRoomId) == false
            return null
        return gameRooms[player.currentGameRoomId]

    return {
        gameRooms: gameRooms
        players: players
        FindRoomFromPlayerId: FindRoomFromPlayerId
    }
)