define("users", [], () ->
    Meteor.publish(null, () ->
        Meteor.users.find({ "status.online": true })
    )
    Accounts.onCreateUser((options, user) ->
        user.rank = 1
        user.score = 0
        user.winNumber = 0
        user.loseNumber = 0
        user.isDisplayingInstructions = true
        if user.services.twitter? == true
            user.username = user.services.twitter.screenName
        else if user.services.google? == true
            user.username = user.services.google.name
        else if user.services.facebook? == true
            user.username = user.services.facebook.name


        if (options.profile)
            user.profile = options.profile
        return user
    )
    # Accounts.onLogin(() ->
    #     user = Meteor.user()
    #     if user.services.twitter? == true
    #         user.username = user.services.twitter.screenName
    #         console.log("twitter !!")
    #     console.log("username is :#{user.username} ")
    # )
)