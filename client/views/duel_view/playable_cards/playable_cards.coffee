Template.playableCards.helpers({    
    GetCardFunc: (index)->
        f = this.GetCard
        return () -> (() -> f(index))

    GetRemainingCardsNumberFunc: ()->
        return this.GetRemainingCardsNumber
})

Template.playableCard.helpers({
    GetClassForAvailability: () ->
        return if this.GetCard().isAvailable then "" else "unavailable"

    GetClassForIsPreparing: () ->
        return if this.GetCard().isPreparing then "preparing-card" else ""
})