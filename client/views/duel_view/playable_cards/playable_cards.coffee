Template.playableCards.helpers({
    
    GetCardFunc: (index)->
        f = this.GetCard
        return () -> (() -> f(index))
})

Template.playableCard.helpers({
    GetClassForAvailability: () ->
        return if this.GetCard().isAvailable then "" else "unavailable"
})

Template.playableCard.events({
    "click .playable-card:not(.unavailable)": () ->
        console.log("clicking ! #{this.GetCard().index}")
        require("player_actions").PlayCardIndex(this.GetCard().index)
})