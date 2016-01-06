Template.playableCards.helpers({
    
    GetCardFunc: (index)->
        f = this.GetCard
        return () -> (() -> f(index))
})

Template.playableCard.helpers({
    GetClassForAvailability: () ->
        return if this.GetCard().isAvailable then "" else "unavailable"

    GetClassForIsPreparing: () ->
        return if this.GetCard().isPreparing then "preparing-card" else ""
})

Template.playableCard.events({
})