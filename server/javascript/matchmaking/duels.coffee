define("duels", [], () ->
    Meteor.methods({
        "get_random_available_room_id": () ->
            if this.userId? == false
                throw Meteor.Error("<get_random_available_room_id>: no userId")
            return require("game_room").GetAvailableRoomId()
    })
    GetScoreTransactionAmount = (winner, loser) ->
        # if loser.rank * 2 + 1 < winner.rank
        #     return 0
        return loser.rank + winner.rank
    GetRankFromScore = (score) ->
        return Math.floor(score / 6) + 1
        # n = Math.sqrt(score - 5)
        # if isNaN(n)
        #     n = 0
        # return Math.floor(n) + 1

    return {
        GetScoreTransactionAmount: GetScoreTransactionAmount
        GetRankFromScore: GetRankFromScore
    }
)