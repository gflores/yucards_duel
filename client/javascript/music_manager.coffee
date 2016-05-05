define("music_manager", [], () ->
    softLoop = new PerfectLoop("/audio/Babaroque_soft_loop3.mp3", false, 0, -0.500, -0.525)
    buildupAudio = new Audio("/audio/Babaroque_buildup1.mp3")
    mainLoop = new PerfectLoop("/audio/Babaroque_main_loop1.mp3", false, 0, -0.500, -0.525)

    loopAnimationToLaunch = null

    delayFinderStartTime = null
    delayFinderTotalTime = null
    delayFinderDelta = null


    Meteor.setTimeout(() ->
        delayFinderAudio = new Audio("/audio/coma.mp3")
        delayFinderAudio.oncanplaythrough = () ->
            delayFinderStartTime = (new Date()).getTime()
            delayFinderAudio.play()
            delayFinderAudio.volume = 0
        delayFinderAudio.onended = () ->
            require("game_data").set("isAudioPlayable", true)
            console.log("AUDIO IS NOT BUGGY")
            delayFinderTotalTime = (new Date()).getTime() - delayFinderStartTime
            delayFinderDelta = delayFinderTotalTime - (delayFinderAudio.duration * 1000)
            if loopAnimationToLaunch?
                loopAnimationToLaunch()
            console.log("TOTAL TIME: #{delayFinderTotalTime}, time duration: #{delayFinderAudio.duration}, DELTA: #{delayFinderDelta}")


        Meteor.setTimeout(() ->
            if isNaN(delayFinderAudio.duration) == true #is buggy
                require("game_data").set("isAudioPlayable", false)
                require("game_data").set("isGoodBrowser", false)
                require("music_manager").Mute()
                console.log("AUDIO IS BUGGY")
        , 1000)



    , 1500)


    softLoopAnimation = () ->
        if delayFinderTotalTime == null
            loopAnimationToLaunch = softLoopAnimation
            return null
        Thump = require("animation_utils").Thump
        softLoop.play((deltaStart) ->
            if require("game_data").get("isGoodBrowser") == false
                return

            beforeBeat1Time = 544 + deltaStart + 25  + 100 - 225 + delayFinderDelta
            beat1Time = 882.35
            beat1Nb = 32
            beat2Time = beat1Time / 2
            beat2Nb = beat1Nb * 2

            for n in [0...beat1Nb] by 1
                setTimeout(() ->
                    if Meteor.user().isCrazyMode == false
                        return

                    Thump($(".send-your-url"), "scale", 0.05, 0.2, 1.1, 1)
                    Thump($("#player-side .card-player-icon img"), "scale", 0.05, 0.2, 1.1, 1)

                , beforeBeat1Time + n * beat1Time)

            for n in [0..beat2Nb] by 1
                do (n) ->
                    setTimeout(() ->
                        if Meteor.user().isCrazyMode == false
                            return

                        if n % 2 == 0
                            $("#countdown .url").css("color", "blue")
                        else
                            $("#countdown .url").css("color", "rgb(100, 0, 225)")
                    , beforeBeat1Time + n * beat2Time)
            
        )

    mainLoopAnimation = () ->
        if delayFinderTotalTime == null
            loopAnimationToLaunch = mainLoopAnimation
            return null

        Thump = require("animation_utils").Thump
        mainLoop.play((deltaStart) ->
            if require("game_data").get("isGoodBrowser") == false
                return

            beforeBeat1Time = 103 + 25 + deltaStart + 100 - 225 + delayFinderDelta
            beat1Time = 882.35
            beat1Nb = 64
            beat2Time = beat1Time / 2
            beat2Nb = beat1Nb * 2

            beat3Time = beat2Time / 2
            beat3Nb = beat2Nb * 2


            Beat3Time1 = 294 #second2
            Beat3Time2 = 365 #main
            Beat3Time3 = 224 #second1

            for n in [0...beat1Nb] by 1
                do (n) ->
                    setTimeout(() ->
                        if Meteor.user().isCrazyMode == false
                            return

                        Thump($("#player-side .card-player-icon img"), "scale", 0.05, 0.2, 1.1, 1)
                        # for cardN in [0..2] by 1
                        #     color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
                        #     Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.02, 0.15, "0px 0px 40px 10px #{color}", "0px 0px 16px 0px #{color}")
                    , beforeBeat1Time + n * beat1Time)

            for n in [0..beat2Nb] by 1
                do (n) ->
                    setTimeout(() ->
                        if Meteor.user().isCrazyMode == false
                            return

                        if n % 2 == 0
                            $discardButton = $("#discard-button")
                            if $discardButton? == true
                                Thump($discardButton, "scale", 0.05, 0.2, 1.015, 1)
                            for cardN in [0..2] by 1
                                Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "scale", 0.05, 0.2, 1.015, 1)
                                Thump($("#opponent-side .playable-cards .playable-card:nth(#{cardN})"), "scale", 0.05, 0.2, 1.015, 1)

                                color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
                                Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.05, 0.20, "0px 0px 40px 6px #{color}", "0px 0px 16px 0px #{color}")
                        else
                            $discardButton = $("#discard-button")
                            if $discardButton? == true
                                Thump($discardButton, "scale", 0.05, 0.2, 1.05, 1)
                            for cardN in [0..2] by 1
                                Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "scale", 0.05, 0.2, 1.05, 1)
                                Thump($("#opponent-side .playable-cards .playable-card:nth(#{cardN})"), "scale", 0.05, 0.2, 1.05, 1)

                                color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
                                Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.05, 0.20, "0px 0px 14px 12px #{color}", "0px 0px 16px 0px #{color}")
                        if n == 31 or n == 0
                                Thump($(".plane-overlay"), "opacity", 0.05, 0.2, 0.3, 0)
                    , beforeBeat1Time + n * beat2Time)

            # for n in [0..beat3Nb] by 1
            #     do (n) ->
            #         setTimeout(() ->
            #             if n % 4 == 0
            #                 for cardN in [0..2] by 1
            #                     color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
            #                     Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.05, 0.20, "0px 0px 40px 6px #{color}", "0px 0px 16px 0px #{color}")
            #             # if n % 4 == 1
            #             #     for cardN in [0..2] by 1
            #             #         color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
            #             #         Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.02, 0.15, "0px 0px 20px 6px #{color}", "0px 0px 0px 0px #{color}")
            #             if n % 4 == 2
            #                 for cardN in [0..2] by 1
            #                     color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
            #                     Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.05, 0.20, "0px 0px 14px 12px #{color}", "0px 0px 16px 0px #{color}")
            #         , beforeBeat1Time + n * beat3Time)

            # for n in [0...beat1Nb] by 1
            #     setTimeout(() ->
            #             if n % 2 == 0
            #                 for cardN in [0..2] by 1
            #                     color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
            #                     Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.05, 0.20, "0px 0px 40px 10px #{color}", "0px 0px 16px 0px #{color}")
            #     , beforeBeat1Time + (n * beat1Time) + Beat3Time1)

            # for n in [0...beat1Nb] by 1
            #     setTimeout(() ->
            #             if n % 2 == 0
            #                 for cardN in [0..2] by 1
            #                     color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
            #                     Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.05, 0.20, "0px 0px 40px 10px #{color}", "0px 0px 16px 0px #{color}")
            #     , beforeBeat1Time + (n * beat1Time) + Beat3Time1 + Beat3Time2)

            
        )

        
    buildupAudioAnimation = () ->
        setTimeout(() ->
            if require("global_data").isDuelStartMessageReceived == true
                console.log("buildup START")
                require("communication").DuelStartWithMessage()
            else
                require("global_data").isBuildupStartFailed = true
                console.log("buildup FAIL")
        , (require("game_data").get("CountdownValue") * 1000) - 100)
        console.log("time before automatic DuelStartWithMessage #{require("game_data").get("CountdownValue")}")

        if delayFinderTotalTime == null
            loopAnimationToLaunch = buildupAudioAnimation
            return null

        Thump = require("animation_utils").Thump
        if Meteor.user().isMusicMuted
            buildupAudio.volume = 0
        buildupAudio.play()

        if require("game_data").get("isGoodBrowser") == false
            return

        beforeBeat1Time = 931 + 25 + 150 - 225 + delayFinderDelta
        beat1Time = 882.35
        beat1Nb = 4
        beat2Time = beat1Time / 2
        beat2Nb = 4

        currentScale = 1
        currentFontSize = 32
        for n in [0...beat1Nb] by 1
            setTimeout(() ->
                if Meteor.user().isCrazyMode == false
                    return

                Thump($("#player-side .card-player-icon img"), "scale", 0.05, 0.2, 1.1, 1)

                # currentScale += 0.1
                currentFontSize += 3
                # $(".countdown-timer-value").css("transform", "scale(#{currentScale})")
                # Thump($(".countdown-timer-value"), "scale", 0.05, 0.2, currentScale * 1.1, currentScale)
                Thump($(".countdown-timer-value"), "font-size", 0.05, 0.2, "#{currentFontSize * 1.1}px", "#{currentFontSize}px")

                # Thump($(".countdown-timer-value"), "scale", 0.05, 0.2, 1.1, 1)
            , beforeBeat1Time + n * beat1Time
            )

        for n in [0...beat2Nb] by 1
            setTimeout(() ->
                if Meteor.user().isCrazyMode == false
                    return

                console.log("scale: #{currentScale}")
                # currentScale += 0.1
                currentFontSize += 6
                # $(".countdown-timer-value").css("transform", "scale(#{currentScale})")
                # Thump($(".countdown-timer-value"), "scale", 0.05, 0.2, currentScale * 1.1, currentScale)
                Thump($(".countdown-timer-value"), "font-size", 0.05, 0.2, "#{currentFontSize * 1.1}px", "#{currentFontSize}px")

                # Thump($(".countdown-timer-value"), "scale", 0.05, 0.2, 1.1, 1)
            , beforeBeat1Time + (beat1Nb * beat1Time) + n * beat2Time
            )

        setTimeout(() ->
            if Meteor.user().isCrazyMode == false
                return

            currentFontSize += 40
            Thump($(".countdown-timer-value"), "font-size", 2, 0.2, "#{currentFontSize}px", "#{currentFontSize}px")
            require("animation_utils").Shake($(".countdown-timer-value")[0], 40, 0.030, 20, 20)
        , beforeBeat1Time + (beat1Nb * beat1Time) + (beat1Nb * beat2Time)
        )
        setTimeout(() ->
            if Meteor.user().isCrazyMode == false
                return

            Thump($(".plane-overlay"), "opacity", (beat2Time / 1000) * 1.3, (beat2Time / 1000) * 0.7, 1, 0)
        , beforeBeat1Time + (beat1Nb * beat1Time) + (beat1Nb * beat2Time) + (2 * beat2Time)
        )

    Mute = () ->
        if softLoop.currentAudio? == true
            softLoop.currentAudio.volume = 0
        if mainLoop.currentAudio? == true
            mainLoop.currentAudio.volume = 0
        buildupAudio.volume = 0

    UnMute = () ->
        if softLoop.currentAudio? == true
            softLoop.currentAudio.volume = 1
        if mainLoop.currentAudio? == true
            mainLoop.currentAudio.volume = 1
        buildupAudio.volume = 1


    return {
        softLoop: softLoop
        buildupAudio: buildupAudio
        mainLoop: mainLoop

        softLoopAnimation: softLoopAnimation
        buildupAudioAnimation: buildupAudioAnimation
        mainLoopAnimation: mainLoopAnimation

        Mute: Mute
        UnMute: UnMute
    }
)