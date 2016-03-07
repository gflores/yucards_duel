Template.playableCards.helpers({    
    GetCardFunc: (index)->
        f = this.GetCard
        return () -> (() -> f(index))

    GetRemainingCardsNumberFunc: ()->
        return this.GetRemainingCardsNumber
})

Template.playableCard.helpers({
    ImagePath: () ->
        if this.GetCard().element == "ROCK"
            return "/images/card_rock.png"
        else if this.GetCard().element == "SCISSOR"
            return "/images/card_scissor.png"
        else if this.GetCard().element == "PAPER"
            return "/images/card_paper.png"

    GetClassForIsPreparing: () ->
        return if this.GetCard().isPreparing then "preparing-card" else ""
})