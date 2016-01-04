define("cards", [], ()->

    Construct = (value, element, index) ->
        return {
            value: value
            element: element
            index: index
            isAvailable: true
        }

    return {
        Construct: Construct
    }
)