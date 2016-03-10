Template.cardPutOnTop.rendered = () ->
    animation_utils = require("animation_utils")
    $feedbackCard = $(this.find(".playable-card"))
    instanceView = this.view
    FinalResultFunc = this.data.FinalResultFunc
    SetNewCardFromReserveFunc = this.data.SetNewCardFromReserveFunc
    SetTopCardOnStack = this.data.SetTopCardOnStack

    tl = new TimelineLite()

    # {if this.data.isPlayerSide == true then "bottom" else "top"}
    relativeDestinationLeft = $feedbackCard.position().left
    relativeDestinationTop = $feedbackCard.position().top

    if this.data.isPlayerSide == true
        sideId = "player-side"
        auraDamageFunc = require("feedback_launcher").LaunchAuraDamagingOpponent
    else
        sideId = "opponent-side"
        auraDamageFunc = require("feedback_launcher").LaunchAuraDamagingPlayer

    $feedbackCard.css("right", "initial");
    $feedbackCard.offset($("##{sideId} .playable-card:nth-child(#{this.data.cardPlayedIndex + 1})").offset())

    tl
        .to($feedbackCard[0], 0.2, {
            visibility: "visible", scale: 1.6
            onComplete: () ->
                SetNewCardFromReserveFunc()
        })
        .to($feedbackCard[0], 0.3, {
            ease: Power0.easeNone, left: relativeDestinationLeft, top: relativeDestinationTop, scale: 1
            onComplete: () ->
                SetTopCardOnStack()
                auraDamageFunc(FinalResultFunc)
                Blaze.remove(instanceView)
                animation_utils.Shake($("#top-card .playable-card")[0], 25, 0.010, 10, 10, 2)
        })
    # tl
    #     .fromTo($feedbackCard, 0.5, {
    #         ease: Power0.easeNone, "#{if this.data.isPlayerSide == true then "bottom" else "top"}": "-=100%", autoAlpha:0.8, scale: 2
    #     }, {
    #         "#{if this.data.isPlayerSide == true then "bottom" else "top"}": 0, autoAlpha: 1, scale: 1, visibility: "visible"
    #         onComplete: () ->
    #             FinalResultFunc()
    #             Blaze.remove(instanceView)
    #             animation_utils.Shake($("#top-card .playable-card")[0], 25, 0.010, 10, 10, 2)
    #     })
                

#            .add(animation_utils.Shake($feedbackCard, 25, 0.010, 10, 10, 5))

Template.cardPutOnTop.helpers({
    ImagePath: () ->
        if this.card.element == "ROCK"
            return "/images/card_rock.png"
        else if this.card.element == "SCISSOR"
            return "/images/card_scissor.png"
        else if this.card.element == "PAPER"
            return "/images/card_paper.png"
})