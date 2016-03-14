Template.playerSide.helpers({
    data: () ->
        require("player_data")
    GetUser: () ->
        Meteor.users.findOne(require("player_data").get("UserId"))

    GetCard: () ->
        return ((index) -> return require("player_data").get("Card#{index}"))
    GetRemainingCardsNumber: () ->
        return ((element) -> return require("player_data").get("RemainingNumber#{element}"))
    GetClassForActionsAvailability: () ->
        return if require("player_data").get("AreActionsAvailable") then "" else "actions-unavailable"
    GetClassForIsSpectator: () ->
        return if require("game_data").get("IsPlayer") then "" else "is-spectator"
    IsGameRoomReady: () ->
        return require("game_data").get("IsGameRoomReady")
    GetPlayerData: () ->
        return require("player_data")
    GetOpponentData: () ->
        return require("opponent_data")


    
})

Template.playerSide.events({
#    "click .playable-card:not(.unavailable)": () ->
    "click :not(.actions-unavailable):not(.is-spectator) > .playable-cards > .playable-card": () ->
        
        console.log("clicking ! #{this.GetCard().index}")
        require("player_actions").PlayCardIndex(this.GetCard().index)

#    "click #discard-button:not(.unavailable)": () ->
    "click :not(.actions-unavailable):not(.is-spectator) > #discard-button": () ->
        
        require("player_actions").DiscardAllCards()

})