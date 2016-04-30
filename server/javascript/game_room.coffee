define("game_room", [], () ->
    GameRooms = new Mongo.Collection("game_rooms");

    GetAvailableRoomId = () ->
        f = () ->
            Math.floor((Math.random() * 999999) + 1).toString()
        roomId = f()
        while GameRooms.find({roomId: roomId}).count() != 0
            roomId = f()
        return roomId
            

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
            isCountdownFinished: false
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
    ConstructPlayerEndResult = (player, newScore) ->
        res = {
            id: player._id
            oldScore: player.score
            oldRank: player.rank
            isWinner: null
            winNumber: player.winNumber
            loseNumber: player.loseNumber
        }
        player.score = Math.max(newScore, 0)
        player.rank = 1 + Math.floor(require("user_rank").GetRankFromScore(player.score)) #require("duels").GetRankFromScore(player.score)
        console.log("new rank: #{player.rank}")
        res.newScore = player.score
        res.newRank = player.rank
        return res

    ConstructDuelEndResult = (winner, loser) ->
        scoreTransaction = require("duels").GetScoreTransactionAmount(winner, loser)
        winner.winNumber += 1
        loser.loseNumber += 1

        winnerResult = ConstructPlayerEndResult(winner, winner.score + scoreTransaction)
        winnerResult.isWinner = true
        loserResult = ConstructPlayerEndResult(loser, loser.score - scoreTransaction)
        loserResult.isWinner = false
        return {
            players: [winnerResult, loserResult]
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

    CreatePlayerForWithId = (userId, gameRoom) ->
        player = ConstructPlayer(userId, gameRoom.id)
        global_data = require("global_data")
        player.reserveCards = require("cards").GenerateStartingCards()

        player.playableCards.push(player.reserveCards.pop())
        player.playableCards.push(player.reserveCards.pop())
        player.playableCards.push(player.reserveCards.pop())
        require("cards").ComputeRemainingCardsNumberForPlayer(player)
        global_data.players[player.id] = player
        return player

    SetupRoomsCommunication = () ->
        Meteor.methods({
            "register_player_for_game": (roomId) ->
                console.log("INVOKING register_player_for_game")
                check(roomId, String)
                if this.userId? == false
                    return "ERROR: no UserId"
                else
                    console.log("[#{this.userId}] trying to register for game")
                global_data = require("global_data")
                if Meteor.user().isPlaying and global_data.players[this.userId].currentGameRoomId != roomId
                    return {
                        isAlreadyPlaying: true
                        otherRoomId: global_data.players[this.userId].currentGameRoomId
                    }

                gameRoom = null
                if (roomId of global_data.gameRooms) == false #if the room didn't already exist, we create it
                    global_data.gameRooms[roomId] = ConstructGameRoom(roomId)

                gameRoom = global_data.gameRooms[roomId]

                isUserPlayingThisGame = this.userId in gameRoom.players_ids

                if gameRoom.players_ids.length == 2 #if room is already started, no need to do additional stuff. Returning players and spectators will receive the snapshot
                    return {
                        isPlayer: isUserPlayingThisGame
                        isStarted: true
                        snapshot: GetCurrentSnapshotData(gameRoom)
                    }
                if isUserPlayingThisGame
                    console.log("player #{this.userId} already in room #{roomId}")
                else
                    gameRoom.players_ids.push(this.userId)
                    Meteor.users.update({_id: this.userId}, {$push: {"oppenedLinks": roomId}})

                #     player = ConstructPlayer(this.userId, roomId)
                #     if gameRoom.players_ids.length == 1
                #         opponent = global_data.players[gameRoom.players_ids[0]]
                #         player.opponent = opponent
                #         opponent.opponent = player
                #     if gameRoom.players_ids.length == 2
                #         return "ERROR: the room #{roomId} is full"
                #     #Need to create a new player
                #     gameRoom.players_ids.push(this.userId)
                #     player.reserveCards = require("cards").GenerateStartingCards()

                    

                #     player.playableCards.push(player.reserveCards.pop())
                #     player.playableCards.push(player.reserveCards.pop())
                #     player.playableCards.push(player.reserveCards.pop())
                #     require("cards").ComputeRemainingCardsNumberForPlayer(player)

                #     global_data.players[player.id] = player
                return {
                    isPlayer: true
                    isStarted: false
                    playersNb: gameRoom.players_ids.length
                    msg: "SUCCESS: room #{roomId} now has #{gameRoom.players_ids.length} players"
                }
        })
        
        custom_collection_publisher = require("custom_collection_publisher")
        id_keys = require("id_keys")
        global_data = require("global_data")

        IsAllowedFunc = (publisher, subArgs) ->
            roomId = subArgs[0]
            if (Meteor.users.findOne(publisher.userId).isPlaying == true and global_data.players[publisher.userId].currentGameRoomId != roomId) or global_data.gameRooms.hasOwnProperty(roomId) == false
                return false
            else
                return true
        GetCursorFunc = (publisher, subArgs) ->
            roomId = subArgs[0]
            global_data.gameRooms[roomId].messageCollection.find({date: {$gte: new Date}})
        OnSuccessFunc = (publisher, subArgs) ->
            roomId = subArgs[0]
            gameRoom = global_data.gameRooms[roomId]
            if gameRoom.players_ids.length == 1
                console.log("Pub: #{gameRoom.id} still waiting")
            else if gameRoom.players_ids.length == 2 and gameRoom.isStarted == false
                opponent = CreatePlayerForWithId(gameRoom.players_ids[0], gameRoom)
                newPlayer = CreatePlayerForWithId(gameRoom.players_ids[1], gameRoom)
                opponent.opponent = newPlayer
                newPlayer.opponent = opponent
                RemovePlayerIdFromOtherRooms = (playerId) ->
                    for link in Meteor.users.findOne(playerId).oppenedLinks
                        if link != roomId
                            otherRoom = global_data.gameRooms[link]
                            idIndex = otherRoom.players_ids.indexOf(playerId)
                            otherRoom.players_ids.splice(idIndex, 1)

                RemovePlayerIdFromOtherRooms(opponent.id)
                RemovePlayerIdFromOtherRooms(newPlayer.id)

                Meteor.users.update({_id: {$in: gameRoom.players_ids}}, {$set:
                    {
                        "isPlaying": true,
                        "oppenedLinks": []
                        "currentRoomID": gameRoom.id
                    }
                }, {multi: true})

                GameRooms.insert({roomId: gameRoom.id})
                console.log("[#{roomId}] STARTED ! total room nb:" + GameRooms.find().count());

                countdownDuration = require("music_manager").GetCountdownDuration() #require("shared_constants").countdownDuration
                prematureCountdownDuration = require("music_manager").GetPrematureCountdownDuration()
                gameRoom.messageCollection.insert({
                    functionId: "duel_countdown"
                    countdownDuration: countdownDuration
                    players_ids: gameRoom.players_ids
                })
                gameRoom.isStarted = true
                console.log("Pub: duel starting for #{gameRoom.id} in #{countdownDuration} ms")

                Meteor.setTimeout(() ->
                    gameRoom.isCountdownFinished = true
                    gameRoom.messageCollection.insert({
                        functionId: "duel_start"
                        players: [
                            PlayerGetFilteredField(global_data.players[gameRoom.players_ids[0]])
                            PlayerGetFilteredField(global_data.players[gameRoom.players_ids[1]])
                        ]
                            
                    })
                , prematureCountdownDuration
                )
            else
                console.log("[#{gameRoom.id}] accepting subscriber: #{publisher.userId}")
        OnStopFunc = (publisher, subArgs) ->
            roomId = subArgs[0]
            gameRoom = global_data.gameRooms[roomId]
            if gameRoom?
                if not publisher.userId in gameRoom.players_ids
                    console.log("#{publisher.userId} never subscribed")
                if gameRoom.players_ids.length == 1 and publisher.userId in gameRoom.players_ids
                    console.log("Removing #{publisher.userId} from GameRoom #{gameRoom.id}")
                    gameRoom.players_ids = []
                    Meteor.users.update({_id: publisher.userId}, {$pull: {"oppenedLinks": roomId}})
                else
                    if gameRoom.players_ids.length == 0
                        console.log("GameRoom #{gameRoom.id} is already empty...")
            else
                console.log("#{roomId} room doesn't even exist")


        custom_collection_publisher.PublishCursor(id_keys.GetServerMessagesPublicationName(), id_keys.GetServerMessagesCollectionName(), IsAllowedFunc, GetCursorFunc, OnSuccessFunc, OnStopFunc)

    return {
        ConstructGameRoom: ConstructGameRoom
        ConstructPlayer: ConstructPlayer
        SetupRoomsCommunication: SetupRoomsCommunication
        GameRooms: GameRooms
        GetAvailableRoomId: GetAvailableRoomId
        ConstructDuelEndResult: ConstructDuelEndResult
    }
)