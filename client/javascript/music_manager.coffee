define("music_manager", [], () ->
    softLoop = new PerfectLoop("/audio/Babaroque_soft_loop3.mp3", false, 0, -0.500, -0.525)
    buildupAudio = new Audio("/audio/Babaroque_buildup1.mp3")
    mainLoop = new PerfectLoop("/audio/Babaroque_main_loop1.mp3", false, 0, -0.500, -0.525)

    softLoopAnimation = () ->
        Thump = require("animation_utils").Thump
        softLoop.play((deltaStart) ->
            beforeBeat1Time = 544 + 25 + deltaStart + 100
            beat1Time = 882.8
            beat1Nb = 32
            beat2Time = beat1Time / 2
            beat2Nb = beat1Nb * 2

            for n in [0...beat1Nb] by 1
                setTimeout(() ->
                    Thump($(".send-your-url"), "scale", 0.05, 0.2, 1.1, 1)
                    Thump($("#player-side .card-player-icon img"), "scale", 0.05, 0.2, 1.1, 1)

                , beforeBeat1Time + n * beat1Time)

            for n in [0..beat2Nb] by 1
                do (n) ->
                    setTimeout(() ->
                        if n % 2 == 0
                            $("#countdown .url").css("color", "blue")
                        else
                            $("#countdown .url").css("color", "rgb(100, 0, 225)")
                    , beforeBeat1Time + n * beat2Time)
            
        )

    mainLoopAnimation = () ->
        Thump = require("animation_utils").Thump
        mainLoop.play((deltaStart) ->
            beforeBeat1Time = 103 + 25 + deltaStart + 100
            beat1Time = 882.8
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
                        Thump($("#player-side .card-player-icon img"), "scale", 0.05, 0.2, 1.1, 1)
                        # for cardN in [0..2] by 1
                        #     color = $("#player-side .playable-cards .playable-card:nth(#{cardN})").css("background-color")
                        #     Thump($("#player-side .playable-cards .playable-card:nth(#{cardN})"), "boxShadow", 0.02, 0.15, "0px 0px 40px 10px #{color}", "0px 0px 16px 0px #{color}")
                    , beforeBeat1Time + n * beat1Time)

            for n in [0..beat2Nb] by 1
                do (n) ->
                    setTimeout(() ->
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
        Thump = require("animation_utils").Thump
        buildupAudio.play()
        setTimeout(() ->
            if require("global_data").isDuelStartMessageReceived == true
                console.log("buildup START")
                require("communication").DuelStartWithMessage()
            else
                require("global_data").isBuildupStartFailed = true
                console.log("buildup FAIL")
        , (buildupAudio.duration - 0.1) * 1000)


        beforeBeat1Time = 931 + 25 + 150
        beat1Time = 882.8
        beat1Nb = 4
        beat2Time = beat1Time / 2
        beat2Nb = 4

        currentScale = 1
        currentFontSize = 32
        for n in [0...beat1Nb] by 1
            setTimeout(() ->
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
            currentFontSize += 40
            Thump($(".countdown-timer-value"), "font-size", 2, 0.2, "#{currentFontSize}px", "#{currentFontSize}px")
            require("animation_utils").Shake($(".countdown-timer-value")[0], 40, 0.030, 20, 20)
        , beforeBeat1Time + (beat1Nb * beat1Time) + (beat1Nb * beat2Time)
        )
        setTimeout(() ->
            Thump($(".plane-overlay"), "opacity", (beat2Time / 1000), (beat2Time / 1000) / 2, 1, 0)
        , beforeBeat1Time + (beat1Nb * beat1Time) + (beat1Nb * beat2Time) + (2 * beat2Time)
        )

    GetBuildupCountdownDuration = () ->
        return Math.ceil(buildupAudio.duration)

    return {
        softLoop: softLoop
        buildupAudio: buildupAudio
        mainLoop: mainLoop

        softLoopAnimation: softLoopAnimation
        buildupAudioAnimation: buildupAudioAnimation
        mainLoopAnimation: mainLoopAnimation

        GetBuildupCountdownDuration: GetBuildupCountdownDuration
    }
)