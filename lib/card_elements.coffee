define("card_elements", [], () ->
    elements = {
        SCISSOR: "SCISSOR"
        ROCK: "ROCK"
        PAPER: "PAPER"
    }
    IsStrongAgainst = (subject, target) ->
        if (subject == elements.SCISSOR and target == elements.PAPER) or
         (subject == elements.PAPER and target == elements.ROCK) or
         (subject == elements.ROCK and target == elements.SCISSOR)
            return true
        else
            return false

    IsWeakAgainst = (subject, target) ->
        if (subject == elements.PAPER and target == elements.SCISSOR) or
         (subject == elements.ROCK and target == elements.PAPER) or
         (subject == elements.SCISSOR and target == elements.ROCK)
            return true
        else
            return false

    GetResult = (subject, target) ->
        return 0 if subject == target
        return 1 if IsStrongAgainst(subject, target)
        return -1 if IsWeakAgainst(subject, target)

    return {
        elements: elements
        IsStrongAgainst: IsStrongAgainst
        IsWeakAgainst: IsWeakAgainst
        GetResult: GetResult
    }
)