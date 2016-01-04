Template.duelView.helpers({
    IsGameRoomReady: () ->
        require("game_data").get("IsGameRoomReady")
})
