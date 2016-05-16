Template.duelView.helpers({
    IsGameRoomReady: () ->
        return REQ("game_data").get("IsGameRoomReady")
    IsGameFinished: () ->
        return REQ("game_data").get("IsGameFinished")
    IsWinner: () ->
        return REQ("game_data").get("IsWinner")
    IsAlreadyPlayingOtherGame: () ->
        return REQ("game_data").get("IsAlreadyPlayingOtherGame")
    IsPlayer: () ->
        return REQ("game_data").get("IsPlayer")
    OtherRoomUrl: () ->
        return Router.routes.duel.url({roomId: REQ("game_data").get("OtherRoomId")})
    ScoreChange: () ->
        player_data = REQ("player_data")
        scoreChange = player_data.get("NewScore") - player_data.get("OldScore")
        if scoreChange >= 0
            return "+#{scoreChange}"
        else
            return scoreChange
    GetPlayerData: () ->
        return REQ("player_data")
    GetOpponentData: () ->
        return REQ("opponent_data")

    GetClassForVisualEffectMode: () ->
        return if REQ("game_data").get("isGoodBrowser") == true and Meteor.user().isCrazyMode == true then "visual-mode-crazy" else "visual-mode-normal"

    IsTutorial: () ->
        return REQ("game_data").get("IsTutorial") == true
        
    GetClassForTutorial: () ->
        return if REQ("game_data").get("IsTutorial") == true then "tutorial-mode" else "not-tutorial-mode"
    GetClassForTutorialStep: () ->
        return if REQ("game_data").get("TutorialStep") != undefined then "tutorial-step-#{REQ("game_data").get("TutorialStep")}" else ""
})

Template.duelView.events({
    "click .see-results": (event) ->
        $(".first-part").toggle()
        $(".next-part").toggle()
        # setTimeout(() ->
        #     $(".end-game-buttons").toggle()
        # , 2000
        # )

    "click .play-again": (event) ->
        location.reload()

    "click .go-to-home": (event) ->
        window.location.href = Router.routes.mainRoom.url({})

    "click #already-in-another-duel a": () ->
        Meteor.setTimeout(() ->
            document.location.reload(true)
        , 500
        )
})

Template.playerResult.helpers({
    GetOldScore: () ->
        this.data.get("OldScore")
    GetNewScore: () ->
        this.data.get("NewScore")
    GetOldRank: () ->
        this.data.get("OldRank")
    GetNewRank: () ->
        this.data.get("NewRank")
    GetWinNumber: () ->
        this.data.get("WinNumber")
    GetLoseNumber: () ->
        this.data.get("LoseNumber")
})