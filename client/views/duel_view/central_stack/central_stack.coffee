Template.centralStack.helpers({
    IsThereTopCard: () ->
        return require("game_data").get("TopCard")?

    GetCardFunc: () ->
        return () -> require("game_data").get("TopCard")

    GetStackCards: () ->
        return require("game_data").get("StackCards")

    GetStyleForIndex: (index) ->
        index += 1
        offset = "#{index * -10}px"
        return "transform: translate(#{offset},#{offset}); z-index: #{(-1)-index};"
})