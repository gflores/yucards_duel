Template.opponentSide.helpers({
    data: () ->
        REQ("opponent_data")
    GetClassForIsDisconnected: () ->
        return if Meteor.users.findOne(REQ("opponent_data").get("UserId"))? == false then "is-disconnected" else ""
        
    GetUser: () ->
        Meteor.users.findOne(REQ("opponent_data").get("UserId"))

    GetCard: () ->
        return ((index) -> return REQ("opponent_data").get("Card#{index}"))

    GetRemainingCardsNumber: () ->
        return ((element) -> return REQ("opponent_data").get("RemainingNumber#{element}"))

    GetClassForActionsAvailability: () ->
        return if REQ("opponent_data").get("AreActionsAvailable") then "" else "actions-unavailable"

})
