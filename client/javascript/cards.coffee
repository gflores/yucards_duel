define("cards", [], ()->

    Construct = (value, element, index) ->
        return {
            value: value
            element: element
            index: index
            isPreparing: false
        }

    return {
        Construct: Construct
    }
)