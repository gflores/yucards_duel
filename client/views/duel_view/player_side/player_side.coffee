Template.playerSide.helpers({
    data: () ->
        require("player_data")

    GetCard: () ->
        return ((index) -> return require("player_data").get("Card#{index}"))
    GetRemainingCardsNumber: () ->
        return ((element) -> return require("player_data").get("RemainingNumber#{element}"))
    GetClassForActionsAvailability: () ->
        return if require("player_data").get("AreActionsAvailable") then "" else "actions-unavailable"
    IsGameRoomReady: () ->
        return require("game_data").get("IsGameRoomReady")

    
})

Template.playerSide.events({
#    "click .playable-card:not(.unavailable)": () ->
    "click :not(.actions-unavailable) > .playable-cards > .playable-card": () ->
        
        console.log("clicking ! #{this.GetCard().index}")
        require("player_actions").PlayCardIndex(this.GetCard().index)

#    "click #discard-button:not(.unavailable)": () ->
    "click :not(.actions-unavailable) > #discard-button": () ->
        
        require("player_actions").DiscardAllCards()

})