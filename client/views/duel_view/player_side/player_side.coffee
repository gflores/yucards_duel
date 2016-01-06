Template.playerSide.helpers({
    data: () ->
        require("player_data")

    GetCard: () ->
        return ((index) -> return require("player_data").get("Card#{index}"))
    GetRemainingCardsNumber: () ->
        return ((element) -> return require("player_data").get("RemainingNumber#{element}"))

    GetClassForAvailabilityForDiscardButton: () ->
        return if require("game_data").get("isDiscardButtonAvailable") then "" else "unavailable"
    
})

Template.playerSide.events({
    "click .playable-card:not(.unavailable)": () ->
        console.log("clicking ! #{this.GetCard().index}")
        require("player_actions").PlayCardIndex(this.GetCard().index)

    "click #discard-button:not(.unavailable)": () ->
        require("player_actions").DiscardAllCards()

})