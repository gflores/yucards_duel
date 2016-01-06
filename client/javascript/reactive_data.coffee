define("player_data", [], () ->
    return new ReactiveDict('playerData');
)

define("opponent_data", [], () ->
    return new ReactiveDict('opponentData');
)

define("game_data", [], () ->
    game_data = new ReactiveDict('gameData');
    return game_data;
)

define("global_data", [], () ->
    return {
        playerCardLoadingRenderer: null
        opponentCardLoadingRenderer: null
    }
)