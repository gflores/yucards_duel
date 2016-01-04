Template.playerSide.helpers({
    data: () ->
        require("player_data")

    GetCard: () ->
        return ((index) -> return require("player_data").get("Card#{index}"))
})
