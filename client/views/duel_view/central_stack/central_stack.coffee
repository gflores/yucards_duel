Template.centralStack.helpers({
    IsThereTopCard: () ->
        return REQ("game_data").get("TopCard")?

    GetCardFunc: () ->
        return () -> REQ("game_data").get("TopCard")

    GetStackCards: () ->
        return REQ("game_data").get("StackCards")

    GetStyleForIndex: (index) ->
        index += 1
        heightToWidthRatio = 186 / 130
        offsetWidth = "#{index * (-8 * heightToWidthRatio)}%"
        offsetHeight = "#{index * -8}%"
        return "transform: translate(#{offsetWidth},#{offsetHeight}); z-index: #{(-1)-index};"

    ElementToImagePath: (element) ->
        if element == "ROCK"
            return "/images/card_rock.png"
        else if element == "SCISSOR"
            return "/images/card_scissor.png"
        else if element == "PAPER"
            return "/images/card_paper.png"
})