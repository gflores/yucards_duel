DEF("player_actions", [], () ->
    
    SetAvailableForPlayer = (card_player_data, isAvailable) ->
        card_player_data.set("AreActionsAvailable", isAvailable)
        # for index in [0..2]
        #     card = card_player_data.get("Card#{index}")
        #     card.isAvailable = isAvailable
        #     card_player_data.set("Card#{index}", card)

    LaunchLoaderForPlayer = () ->
        $parent = $("#player-side")[0]
        REQ("global_data").playerCardLoadingRenderers.push(Blaze.renderWithData(Template.cardLoading, {side: "isPlayer"}, $parent))

    RemoveLoaderForPlayer = () ->
        tl = new TimelineLite()    
        loader = $("#player-side .loading-bar")
        tl
            .to(loader[0], 0.5, {
                visibility: "visible", scale: 1.6, autoAlpha: 0
                onComplete: () ->
                    Blaze.remove(REQ("global_data").playerCardLoadingRenderers.shift())
            })

    LaunchLoaderForOpponent = () ->
        $parent = $("#opponent-side")[0]
        REQ("global_data").opponentCardLoadingRenderers.push(Blaze.renderWithData(Template.cardLoading, {side: "isOpponent"}, $parent))
    RemoveLoaderForOpponent = () ->
        tl = new TimelineLite()    
        loader = $("#opponent-side .loading-bar")
        tl
            .to(loader[0], 0.5, {
                visibility: "visible", scale: 1.6, autoAlpha: 0
                onComplete: () ->
                    Blaze.remove(REQ("global_data").opponentCardLoadingRenderers.shift())
            })

    PlayCardIndex = (index) ->
        player_data = REQ("player_data")
        if REQ("game_data").get("IsTutorial") == true
            if REQ("game_data").get("TutorialStep") == 1
                REQ("tutorial_manager").LaunchStep2()


        SetAvailableForPlayer(player_data, false)
        REQ("game_data").set("isDiscardButtonAvailable", false)

        card = player_data.get("Card#{index}")
        card.isPreparing = true
        player_data.set("Card#{index}", card)

        LaunchLoaderForPlayer()
        Meteor.call("play_card_index", index, (error, result) ->
            console.log("error: '#{error}' | result: '#{result}'")
        )

    DiscardAllCards = () ->
        player_data = REQ("player_data")
        console.log("discarding cards...")

        SetAvailableForPlayer(player_data, false)
#        REQ("game_data").set("isDiscardButtonAvailable", false)
        LaunchLoaderForPlayer()
        Meteor.call("discard_all_cards", new Date(), (error, result) ->
            console.log("error: '#{error}' | result: '#{result}'")
        )

    return {
        PlayCardIndex: PlayCardIndex
        SetAvailableForPlayer: SetAvailableForPlayer
        LaunchLoaderForPlayer: LaunchLoaderForPlayer
        RemoveLoaderForPlayer: RemoveLoaderForPlayer
        LaunchLoaderForOpponent: LaunchLoaderForOpponent
        RemoveLoaderForOpponent: RemoveLoaderForOpponent
        DiscardAllCards: DiscardAllCards
    }
)