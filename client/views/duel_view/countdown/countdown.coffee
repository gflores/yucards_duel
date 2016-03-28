Template.countdown.helpers({
    IsCountdownStarted: () ->
        return require("game_data").get("IsCountdownStarted")
    CountdownValue: () ->
        return require("game_data").get("CountdownValue")

    UrlToShare: () ->
        url = Router.current().url
        if(url.match(/http:\/\//))
            url = url.substring(7);
        if(url.match(/^www\./))
            url = url.substring(4);

        return url

    OpponentName: () ->
        Meteor.users.findOne(require("opponent_data").get("UserId")).username
})