define("player_actions", [], () ->
    PlayCardIndex = (index) ->
        player_data = require("player_data")

        card = player_data.get("Card#{index}")
        card.isAvailable = false
        player_data.set("Card#{index}", card)
    return {
        PlayCardIndex: PlayCardIndex
    }
)