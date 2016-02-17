define("game_room", [], () ->
    GameRooms = new Mongo.Collection("game_rooms");

    ConstructGameRoom = (id) ->
        messageCollection = new Mongo.Collection(null)
        messageCollection.before.insert((userId, doc) ->
            doc.date = new Date()
        )
        return {
            id: id
            players_ids: []
            stackTopCard: null
            messageCollection: messageCollection
            maxLife: require("shared_constants").maxLife
            isStarted: false
            isFinished: false
        }
    ConstructPlayer = (id, currentGameRoomId) ->
        return {
            id: id
            opponent: null
            currentGameRoomId: currentGameRoomId
            playableCards: []
            reserveCards: []
            currentLife: require("shared_constants").maxLife
            isBusy: false
            remainingCardsNumber: {}
        }

    PlayerGetFilteredField = (player) ->
        return {
            id: player.id
            playableCards: player.playableCards
            currentLife: player.currentLife
            isBusy: player.isBusy
            remainingCardsNumber: player.remainingCardsNumber
        }

    GetCurrentSnapshotData = (gameRoom) ->
        global_data = require("global_data")
        return {
            players: [
                PlayerGetFilteredField(global_data.players[gameRoom.players_ids[0]])
                PlayerGetFilteredField(global_data.players[gameRoom.players_ids[1]])
            ]
            stackTopCard: gameRoom.stackTopCard
        }


    SetupRoomsCommunication = () ->
        Meteor.methods({
            "register_player_for_game": (roomId) ->
                check(roomId, String)
                if this.userId? == false
                    return "ERROR: no UserId"
                global_data = require("global_data")
                if Meteor.user().status.playing and global_data.players[this.userId].currentGameRoomId != roomId
                    return {
                        isAlreadyPlaying: true
                        otherRoomId: global_data.players[this.userId].currentGameRoomId
                    }

                gameRoom = null
                if (roomId of global_data.gameRooms) == false #if the room didn't already exist, we create it
                    global_data.gameRooms[roomId] = ConstructGameRoom(roomId)

                gameRoom = global_data.gameRooms[roomId]

                if this.userId in gameRoom.players_ids
                    console.log("player #{this.userId} already in room #{roomId}")
                    if gameRoom.isStarted
                        return {
                            isStarted: true
                            snapshot: GetCurrentSnapshotData(gameRoom)
                        }
                else
                    player = ConstructPlayer(this.userId, roomId)
                    if gameRoom.players_ids.length == 1
                        opponent = global_data.players[gameRoom.players_ids[0]]
                        player.opponent = opponent
                        opponent.opponent = player
                    if gameRoom.players_ids.length == 2
                        return "ERROR: the room #{roomId} is full"
                    #Need to create a new player
                    gameRoom.players_ids.push(this.userId)
                    player.reserveCards = require("cards").GenerateStartingCards()

                    

                    player.playableCards.push(player.reserveCards.pop())
                    player.playableCards.push(player.reserveCards.pop())
                    player.playableCards.push(player.reserveCards.pop())
                    require("cards").ComputeRemainingCardsNumberForPlayer(player)

                    global_data.players[player.id] = player
                return {
                    isStarted: false
                    msg: "SUCCESS: room #{roomId} now has #{gameRoom.players_ids.length} players"
                }
        })
        
        custom_collection_publisher = require("custom_collection_publisher")
        id_keys = require("id_keys")
        global_data = require("global_data")

        IsAllowedFunc = (publisher) ->
            try
                publisher.userId in global_data.FindRoomFromPlayerId(publisher.userId).players_ids
            catch error
                false
        GetCursorFunc = (publisher) ->
            console.log("current date: #{new Date}")
            global_data.FindRoomFromPlayerId(publisher.userId).messageCollection.find({date: {$gte: new Date}})
        OnSuccessFunc = (publisher) ->
            gameRoom = global_data.FindRoomFromPlayerId(publisher.userId)
            if gameRoom.players_ids.length == 2
                Meteor.users.update({_id: {$in: gameRoom.players_ids}}, {$set: {"status.playing": true}}, {multi: true})
                if gameRoom.isStarted == false
                    GameRooms.insert({roomId: gameRoom.id})
                    console.log("total room nb:" + GameRooms.find().count());

                    countdownDuration = require("shared_constants").countdownDuration
                    gameRoom.messageCollection.insert({
                        functionId: "duel_countdown"
                        countdownDuration: countdownDuration
                        players_ids: gameRoom.players_ids
                    })
                    gameRoom.isStarted = true
                    console.log("Pub: duel starting for #{gameRoom.id} in #{countdownDuration} ms")

                    Meteor.setTimeout(() ->
                        gameRoom.messageCollection.insert({
                            functionId: "duel_start"
                            players: [
                                PlayerGetFilteredField(global_data.players[gameRoom.players_ids[0]])
                                PlayerGetFilteredField(global_data.players[gameRoom.players_ids[1]])
                            ]
                                
                        })
                    , countdownDuration
                    )
            else
                console.log("Pub: #{gameRoom.id} still waiting")

        custom_collection_publisher.PublishCursor(id_keys.GetServerMessagesPublicationName(), id_keys.GetServerMessagesCollectionName(), IsAllowedFunc, GetCursorFunc, OnSuccessFunc)

    return {
        ConstructGameRoom: ConstructGameRoom
        ConstructPlayer: ConstructPlayer
        SetupRoomsCommunication: SetupRoomsCommunication
        GameRooms: GameRooms
    }
)