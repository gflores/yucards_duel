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

        if (options.profile)
            user.profile = options.profile
        return user
    )
)