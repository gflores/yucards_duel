define("duels", [], () ->
    Meteor.methods({
        "get_random_available_room_id": () ->
            if this.userId? == false
                throw Meteor.Error("<get_random_available_room_id>: no userId")
            return require("game_room").GetAvailableRoomId()
    })
    GetScoreTransactionAmount = (winner, loser) ->
        if loser.rank * 2 + 1 < winner.rank
            return 0
        return loser.rank + winner.rank
    # GetRankFromScore = (score) ->
    #     if score <= 6
    #         return score / 6
    #     a = 6
    #     b = -3
    #     c = 3 - score
    #     n = (-b + Math.sqrt(Math.pow(b, 2) - 4 * a * c)) / (2 * a)

    #     return n

    return {
        GetScoreTransactionAmount: GetScoreTransactionAmount
        # GetRankFromScore: GetRankFromScore
    }
)