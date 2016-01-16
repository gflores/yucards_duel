Template.playableCards.helpers({    
    GetCardFunc: (index)->
        f = this.GetCard
        return () -> (() -> f(index))

    GetRemainingCardsNumberFunc: ()->
        return this.GetRemainingCardsNumber
})

Template.playableCard.helpers({
    GetClassForIsPreparing: () ->
        return if this.GetCard().isPreparing then "preparing-card" else ""
})