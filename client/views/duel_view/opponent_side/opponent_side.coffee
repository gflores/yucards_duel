Template.opponentSide.helpers({
    data: () ->
        require("opponent_data")

    GetCard: () ->
        return ((index) -> return require("opponent_data").get("Card#{index}"))

    GetRemainingCardsNumber: () ->
        return ((element) -> return require("opponent_data").get("RemainingNumber#{element}"))

    GetClassForActionsAvailability: () ->
        return if require("opponent_data").get("AreActionsAvailable") then "" else "actions-unavailable"

})
