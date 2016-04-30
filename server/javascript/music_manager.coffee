define("music_manager", [], () ->
    GetCountdownDuration = () ->
        7811
    GetPrematureCountdownDuration = () ->
        7000
    return {
        GetCountdownDuration: GetCountdownDuration
        GetPrematureCountdownDuration: GetPrematureCountdownDuration
    }
)