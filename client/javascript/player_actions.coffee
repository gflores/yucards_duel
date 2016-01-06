define("player_actions", [], () ->
    
    SetAvailableForPlayer = (card_player_data, isAvailable) ->
        for index in [0..2]
            card = card_player_data.get("Card#{index}")
            card.isAvailable = isAvailable
            card_player_data.set("Card#{index}", card)

    LaunchLoaderForPlayer = () ->
        $parent = $("#player-side")[0]
        require("global_data").playerCardLoadingRenderer = Blaze.render(Template.cardLoading, $parent)
    RemoveLoaderForPlayer = () ->
        Blaze.remove(require("global_data").playerCardLoadingRenderer)

    LaunchLoaderForOpponent = () ->
        $parent = $("#opponent-side")[0]
        require("global_data").opponentCardLoadingRenderer = Blaze.render(Template.cardLoading, $parent)
    RemoveLoaderForOpponent = () ->
        Blaze.remove(require("global_data").opponentCardLoadingRenderer)

    PlayCardIndex = (index) ->
        player_data = require("player_data")

        SetAvailableForPlayer(player_data, false)

        card = player_data.get("Card#{index}")
        card.isPreparing = true
        player_data.set("Card#{index}", card)

        LaunchLoaderForPlayer()
        Meteor.call("play_card_index", index, (error, result) ->
            console.log("error: '#{error}' | result: '#{result}'")
        )

    return {
        PlayCardIndex: PlayCardIndex
        SetAvailableForPlayer: SetAvailableForPlayer
        LaunchLoaderForPlayer: LaunchLoaderForPlayer
        RemoveLoaderForPlayer: RemoveLoaderForPlayer
        LaunchLoaderForOpponent: LaunchLoaderForOpponent
        RemoveLoaderForOpponent: RemoveLoaderForOpponent
    }
)