Template.playerSide.helpers({
    data: () ->
        require("player_data")
    GetUser: () ->
        Meteor.users.findOne(require("player_data").get("UserId"))

    GetCard: () ->
        return ((index) -> return require("player_data").get("Card#{index}"))
    GetRemainingCardsNumber: () ->
        return ((element) -> return require("player_data").get("RemainingNumber#{element}"))
    GetClassForActionsAvailability: () ->
        return if require("player_data").get("AreActionsAvailable") then "" else "actions-unavailable"
    GetClassForIsSpectator: () ->
        return if require("game_data").get("IsPlayer") then "" else "is-spectator"
    IsGameRoomReady: () ->
        return require("game_data").get("IsGameRoomReady")
    GetPlayerData: () ->
        return require("player_data")
    GetOpponentData: () ->
        return require("opponent_data")
    IsDisplayingInstructions: () ->
        if $(window).width() >= 960 #if it's desktop, we look at user preferences
            Meteor.user().isDisplayingInstructions
        else
            require("game_data").get("isDisplayingInstructions")

    IsMusicMuted: () ->
        Meteor.user().isMusicMuted == true or require("game_data").get("isAudioPlayable") == false

    IsCrazyMode: () ->
        Meteor.user().isCrazyMode == true and require("game_data").get("isGoodBrowser") == true

    IsGoodBrowser: () ->
        return require("game_data").get("isGoodBrowser")

    IsGameRoomReady: () ->
        return require("game_data").get("IsGameRoomReady")

})

Template.playerSide.events({
    "click :not(.actions-unavailable):not(.is-spectator) > .playable-cards > .playable-card": () ->
        console.log("clicking ! #{this.GetCard().index}")
        require("player_actions").PlayCardIndex(this.GetCard().index)

    "click :not(.actions-unavailable):not(.is-spectator) > #discard-button": () ->
        require("player_actions").DiscardAllCards()

    "click .open-instruction-button": () ->
        if require("game_data").get("isDisplayingInstructions") == true
            require("game_data").set("isDisplayingInstructions", false)
            Meteor.call("SetIsDisplayingInstructions", false)
        else            
            require("game_data").set("isDisplayingInstructions", true)
            Meteor.call("SetIsDisplayingInstructions", true)

    "click .instructions .close-button": () ->
        require("game_data").set("isDisplayingInstructions", false)
        Meteor.call("SetIsDisplayingInstructions", false)

    "click .instructions": () ->
        if $(window).width() < 960
            require("game_data").set("isDisplayingInstructions", false)
            Meteor.call("SetIsDisplayingInstructions", false)

    "click .crazy-button": () ->
        if require("game_data").get("isGoodBrowser") == false
            return

        if Meteor.user().isCrazyMode == true
            Meteor.call("SetIsCrazyMode", false)
        else
            Meteor.call("SetIsCrazyMode", true)

    "click .music-button": () ->
        if require("game_data").get("isAudioPlayable") == false
            return
            
        if Meteor.user().isMusicMuted == true
            Meteor.call("SetIsMusicMuted", false)
            require("music_manager").UnMute()
        else
            Meteor.call("SetIsMusicMuted", true)
            require("music_manager").Mute()


})