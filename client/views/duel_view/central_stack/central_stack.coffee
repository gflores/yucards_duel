Template.centralStack.helpers({
    IsThereTopCard: () ->
        return require("game_data").get("TopCard")?

    GetCardFunc: () ->
        return () -> require("game_data").get("TopCard")
})