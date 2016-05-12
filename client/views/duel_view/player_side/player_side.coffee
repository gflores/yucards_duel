Template.playerSide.helpers({
    data: () ->
        REQ("player_data")
    GetUser: () ->
        Meteor.users.findOne(REQ("player_data").get("UserId"))

    GetCard: () ->
        return ((index) -> return REQ("player_data").get("Card#{index}"))
    GetRemainingCardsNumber: () ->
        return ((element) -> return REQ("player_data").get("RemainingNumber#{element}"))
    GetClassForActionsAvailability: () ->
        return if REQ("player_data").get("AreActionsAvailable") then "" else "actions-unavailable"
    GetClassForIsSpectator: () ->
        return if REQ("game_data").get("IsPlayer") then "" else "is-spectator"
    IsGameRoomReady: () ->
        return REQ("game_data").get("IsGameRoomReady")
    GetPlayerData: () ->
        return REQ("player_data")
    GetOpponentData: () ->
        return REQ("opponent_data")
    IsDisplayingInstructions: () ->
        if $(window).width() >= 960 #if it's desktop, we look at user preferences
            Meteor.user().isDisplayingInstructions
        else
            REQ("game_data").get("isDisplayingInstructions")

    IsMusicMuted: () ->
        Meteor.user().isMusicMuted == true or REQ("game_data").get("isAudioPlayable") == false

    IsCrazyMode: () ->
        Meteor.user().isCrazyMode == true and REQ("game_data").get("isGoodBrowser") == true

    IsGoodBrowser: () ->
        return REQ("game_data").get("isGoodBrowser")

    IsGameRoomReady: () ->
        return REQ("game_data").get("IsGameRoomReady")

})

Template.playerSide.events({
    "click :not(.actions-unavailable):not(.is-spectator) > .playable-cards > .playable-card": () ->
        console.log("clicking ! #{this.GetCard().index}")
        REQ("player_actions").PlayCardIndex(this.GetCard().index)

    "click :not(.actions-unavailable):not(.is-spectator) > #discard-button": () ->
        REQ("player_actions").DiscardAllCards()

    "click .open-instruction-button": () ->
        if REQ("game_data").get("isDisplayingInstructions") == true
            REQ("game_data").set("isDisplayingInstructions", false)
            Meteor.call("SetIsDisplayingInstructions", false)
        else            
            REQ("game_data").set("isDisplayingInstructions", true)
            Meteor.call("SetIsDisplayingInstructions", true)

    "click .instructions .close-button": () ->
        REQ("game_data").set("isDisplayingInstructions", false)
        Meteor.call("SetIsDisplayingInstructions", false)

    "click .instructions": () ->
        if $(window).width() < 960
            REQ("game_data").set("isDisplayingInstructions", false)
            Meteor.call("SetIsDisplayingInstructions", false)

    "click .crazy-button": () ->
        if REQ("game_data").get("isGoodBrowser") == false
            return

        if Meteor.user().isCrazyMode == true
            Meteor.call("SetIsCrazyMode", false)
        else
            Meteor.call("SetIsCrazyMode", true)

    "click .music-button": () ->
        if REQ("game_data").get("isAudioPlayable") == false
            return
            
        if Meteor.user().isMusicMuted == true
            Meteor.call("SetIsMusicMuted", false)
            REQ("music_manager").UnMute()
        else
            Meteor.call("SetIsMusicMuted", true)
            REQ("music_manager").Mute()


})