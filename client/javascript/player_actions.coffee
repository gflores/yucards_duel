define("player_actions", [], () ->
    PlayCardIndex = (index) ->
        player_data = require("player_data")

        card = player_data.get("Card#{index}")
        card.isAvailable = false
        player_data.set("Card#{index}", card)

        Meteor.call("play_card_index", index, (error, result) ->
            console.log("error: '#{error}' | result: '#{result}'")
        )

    return {
        PlayCardIndex: PlayCardIndex
    }
)