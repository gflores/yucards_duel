DEF("tutorial_manager", [], ()->

    LaunchStep1 = () ->
        REQ("game_data").set("TutorialStep", 1)

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

    LaunchStep3 = () ->
        REQ("game_data").set("TutorialStep", 3)
        Meteor.setTimeout(() ->
            tl = new TimelineLite()
            tl.to($(".popup-text3")[0], 0.4, {scale: 1})
            tl.to($(".popup-text4")[0], 0.4, {scale: 1})
        , 500)


    return {
        LaunchStep1: LaunchStep1
        LaunchStep2: LaunchStep2
        LaunchStep3: LaunchStep3
    }
)