define("cards", [], ()->

    Construct = (value, element, index) ->
        return {
            value: value
            element: element
            index: index
            isAvailable: true
            isPreparing: false
        }

    return {
        Construct: Construct
    }
)