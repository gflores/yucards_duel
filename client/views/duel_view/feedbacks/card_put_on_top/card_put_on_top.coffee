Template.cardPutOnTop.rendered = () ->
    animation_utils = require("animation_utils")
    $feedbackCard = $(this.find(".playable-card"))[0]
    instanceView = this.view
    FinalResultFunc = this.data.FinalResultFunc

    tl = new TimelineLite()

    
    tl
        .fromTo($feedbackCard, 0.5, {
            ease: Power0.easeNone, "#{if this.data.isPlayerSide == true then "bottom" else "top"}": "-=100%", autoAlpha:0.8, scale: 2
        }, {
            "#{if this.data.isPlayerSide == true then "bottom" else "top"}": 0, autoAlpha: 1, scale: 1, visibility: "visible"
            onComplete: () ->
                FinalResultFunc()
                Blaze.remove(instanceView)
                animation_utils.Shake($("#top-card .playable-card")[0], 25, 0.010, 10, 10, 2)
        })
                

#            .add(animation_utils.Shake($feedbackCard, 25, 0.010, 10, 10, 5))