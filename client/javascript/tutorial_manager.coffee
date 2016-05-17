DEF("tutorial_manager", [], ()->

    LaunchStep1 = () ->
        REQ("game_data").set("TutorialStep", 1)
        REQ("game_data").set("PlayerNbPlay", 0)

        Meteor.setTimeout(() ->
            tl = new TimelineLite()
            tl.to($(".popup-text1")[0], 0.4, {scale: 1})
        , 500)

    LaunchStep2 = () ->
        REQ("game_data").set("TutorialStep", 2)
        tl = new TimelineLite()
        tl.to($(".popup-text2")[0], 0.4, {scale: 1})
        Meteor.setTimeout(() ->
            $(".other1-hider").css("bottom", "calc(50% - 1px + (130px * 1.425) / 2 + 40px)")
            $(".other1-hider").css("height", "calc(100% - (6% + 6px) - (50% - 1px + (130px * 1.425) / 2) - 40px)")
        , 2500)
        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".popup-text2")[0], 0.1, {scale: 0})
        , 3000)

    LaunchStep3 = () ->
        REQ("game_data").set("TutorialStep", 3)
        Meteor.setTimeout(() ->
            tl = new TimelineLite()
            tl.to($(".popup-text3")[0], 0.4, {scale: 1})
            tl.to($(".popup-text4")[0], 0.4, {scale: 1})
        , 500)
        REQ("communication").PauseServerMessages()
        Meteor.setTimeout(() ->
            REQ("communication").UnpauseServerMessages()
        , 3000)

        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".popup-text3")[0], 0.1, {scale: 0})
        , 5000)

        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".popup-text4")[0], 0.1, {scale: 0})
        , 10000)

    opponentStepPlayed = false

    OpponentPlayStep = () ->
        if opponentStepPlayed == true
            return
        opponentStepPlayed = true
        (new TimelineLite()).to($(".other1-hider")[0], 0.1, {scale: 0})
        (new TimelineLite())
            .to($(".popup-text3")[0], 0.1, {scale: 0})
            .to($(".opponent-played")[0], 0.4, {scale: 1})

        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".opponent-played-damages")[0], 0.4, {scale: 1})
            (new TimelineLite()).to($(".bottom-hider")[0], 0.1, {scale: 0})
        , 500)

        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".opponent-played-damages")[0], 0.1, {scale: 0})
            (new TimelineLite()).to($(".opponent-played")[0], 0.1, {scale: 0})
        , 5000)

    PlayerPlayDescription = () ->
        (new TimelineLite()).to($(".player-play-description")[0], 0.4, {scale: 1})
        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".player-play-description")[0], 0.1, {scale: 0})
        3400)
    OpponentPlayDescription = () ->
        (new TimelineLite()).to($(".opponent-play-description")[0], 0.4, {scale: 1})
        Meteor.setTimeout(() ->
            (new TimelineLite()).to($(".opponent-play-description")[0], 0.1, {scale: 0})
        3400)

    RevealDiscardButton = () ->
        (new TimelineLite()).to($(".left-hider")[0], 0.1, {scale: 0})
        (new TimelineLite()).to($(".right-hider")[0], 0.1, {scale: 0})
        Meteor.setTimeout(() ->
            (new TimelineLite()).to($("#discard-button")[0], 0.4, {opacity: 1})
            (new TimelineLite()).to($(".tutorial-discard-button-text")[0], 0.4, {scale: 1})
            Meteor.setTimeout(() ->
                REQ("animation_utils").Shake($("#discard-button")[0], 16, 0.035, 18, 18)
            , 400)
        , 100)

    TutorialFinished = () ->
        (new TimelineLite()).to($(".tutorial-discard-button-text")[0], 0.4, {scale: 0})
        (new TimelineLite()).to($(".other1-hider")[0], 0.1, {scale: 0})
        (new TimelineLite()).to($(".bottom-hider")[0], 0.1, {scale: 0})



    return {
        LaunchStep1: LaunchStep1
        LaunchStep2: LaunchStep2
        LaunchStep3: LaunchStep3
        OpponentPlayStep: OpponentPlayStep
        PlayerPlayDescription: PlayerPlayDescription
        OpponentPlayDescription: OpponentPlayDescription
        RevealDiscardButton: RevealDiscardButton
        TutorialFinished: TutorialFinished
    }
)