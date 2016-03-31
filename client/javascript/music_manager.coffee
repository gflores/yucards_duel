define("music_manager", [], () ->
    softLoop = new PerfectLoop("/audio/Babaroque_soft_loop3.mp3", false, 0, -0.500, -0.525)
    buildupAudio = new Audio("/audio/Babaroque_buildup1.mp3")
    mainLoop = new PerfectLoop("/audio/Babaroque_main_loop1.mp3", false, 0, -0.500, -0.525)

    softLoopAnimation = () ->
        Thump = require("animation_utils").Thump
        softLoop.play((deltaStart) ->
            beforeBeat1Time = 544 + 25 + deltaStart + 100
            beat1Time = 883
            beat1Nb = 32
            beat2Time = beat1Time / 2
            beat2Nb = beat1Nb * 2

            for n in [0...beat1Nb] by 1
                setTimeout(() ->
                    Thump($(".send-your-url"), "scale", 0.05, 0.2, 1.1, 1)
                , beforeBeat1Time + n * beat1Time)

            for n in [0..beat2Nb] by 1
                do (n) ->
                    setTimeout(() ->
                        if n % 2 == 0
                            $("#countdown .url").css("color", "blue")
                        else
                            $("#countdown .url").css("color", "rgb(0, 100, 255)")
                    , beforeBeat1Time + n * beat2Time)
            
        )
        
    buildupAudioAnimation = () ->
        buildupAudio.play()
        setTimeout(() ->
            if require("global_data").isDuelStartMessageReceived == true
                console.log("buildup START")
                require("communication").DuelStartWithMessage()
            else
                require("global_data").isBuildupStartFailed = true
                console.log("buildup FAIL")
        , (buildupAudio.duration - 0.3) * 1000)

    GetBuildupCountdownDuration = () ->
        return Math.ceil(buildupAudio.duration)

    return {
        softLoop: softLoop
        buildupAudio: buildupAudio
        mainLoop: mainLoop

        softLoopAnimation: softLoopAnimation
        buildupAudioAnimation: buildupAudioAnimation

        GetBuildupCountdownDuration: GetBuildupCountdownDuration
    }
)