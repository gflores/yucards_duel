define("player_data", [], () ->
    return new ReactiveDict('playerData');
)

define("opponent_data", [], () ->
    return new ReactiveDict('opponentData');
)

define("game_data", [], () ->
    return new ReactiveDict('gameData');
)

define("global_data", [], () ->
    return {
        playerCardLoadingRenderer: null
        opponentCardLoadingRenderer: null
    }
)