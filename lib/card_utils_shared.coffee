define("card_utils_shared", [], () ->
    GetResultingScore = (subject, target) ->
        card_elements = require("card_elements")

        if target? == false
            return subject.value

        result = card_elements.GetResult(subject.element, target.element)
        if result == 0
            return subject.value
        else if result == 1
            return subject.value + target.value
        else if result == -1
            return Math.max(0, subject.value - target.value) #never go bellow zero

    return {
        GetResultingScore: GetResultingScore
    }
)