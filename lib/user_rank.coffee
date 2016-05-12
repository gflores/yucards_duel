DEF("user_rank", [], () ->
    GetRankFromScore = (score) ->
        if score <= 6
            return score / 6
        a = 6
        b = -3
        c = 3 - score
        n = (-b + Math.sqrt(Math.pow(b, 2) - 4 * a * c)) / (2 * a)

        return n
    return {
        GetRankFromScore: GetRankFromScore
    }
)