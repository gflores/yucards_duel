Template.countdown.helpers({
    IsCountdownStarted: () ->
        return require("game_data").get("IsCountdownStarted")
    CountdownValue: () ->
        return require("game_data").get("CountdownValue")

    UrlToShare: () ->
        return Router.current().url

    OpponentName: () ->
        Meteor.users.findOne(require("opponent_data").get("UserId")).username
})