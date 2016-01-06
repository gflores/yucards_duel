Template.playerSide.helpers({
    data: () ->
        require("player_data")

    GetCard: () ->
        return ((index) -> return require("player_data").get("Card#{index}"))
})

Template.playerSide.events({
    "click .playable-card:not(.unavailable)": () ->
        console.log("clicking ! #{this.GetCard().index}")
        require("player_actions").PlayCardIndex(this.GetCard().index)
})