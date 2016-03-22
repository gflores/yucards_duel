define("users", [], () ->
    Meteor.publish(null, () ->
        Meteor.users.find({ "status.online": true }, {limit: 30, fields: {
            status: 1, rank: 1, score: 1, winNumber: 1, loseNumber: 1, isDisplayingInstructions: 1, username: 1,
            oppenedLinks: 1, currentRoomID: 1, isPlaying: 1
        }})
    )
    Accounts.onCreateUser((options, user) ->
        user.rank = 1
        user.score = 0
        user.winNumber = 0
        user.loseNumber = 0
        user.isDisplayingInstructions = true
        user.oppenedLinks = []
        user.currentRoomID = null
        user.isPlaying = false

        userEmail = null

        if user.services.twitter? == true
            user.username = user.services.twitter.screenName
        else if user.services.google? == true
            user.username = user.services.google.name
            userEmail = user.services.google.email
        else if user.services.facebook? == true
            user.username = user.services.facebook.name
            userEmail = user.services.facebook.email
        else
            userEmail = user.emails[0].address

        if (options.profile)
            user.profile = options.profile
            if options.profile.guest == true
                userEmail = null
        if userEmail != null
            try
                Email.send({
                    from: "Gael from Blitz-RPS <gael@blitzrps.com>"
                    to: userEmail
                    subject: "Thanks for playing Blitz-RPS !"
                    html: "
                        Hey there :)
                        <br><br>
                        Thank you for playing the game and registering, I really hope you enjoy the game !
                        <br><br>
                        This email was sent automatically, but if you reply to this email then I (Gael) will receive your message and be able to reply to you. I would love to
                        receive your feedback so don't hesitate to write me a message ! You can also contact me on Twitter at <a href='https://twitter.com/gael_flores' target='_blank'>@gael_flores</a>.
                        <br><br>
                        Don't worry I didn't put you in any mailing list (so I can't sell you my latest E-book on 'How to get Rich and Ripped using this One Easy and Weird Trick (doctors hate it)' for only $3889, -60% OFF!!1!)
                        <br><br>
                        See you around !

                        <br><br>
                        --
                        <br><br>
                        <div><b>Gael Flores</b></div><div><br></div><font color='#783f04'><b>Blitz-RPS</b></font>, a fast paced strategy online Rock Paper Scissor game in your web-browser !<br><div><a href='http://www.blitzrps.com/' target='_blank'><span style='font-size:12.8px'>www.blitzrps.com/</span><br></a></div><div><span style='font-size:12.8px'><br></span></div><div><span style='font-size:12.8px'><font color='#0000ff'>Twitter:&nbsp;<a href='https://twitter.com/gael_flores' target='_blank'>@gael_flores</a></font></span></div>
                    "
                })
            catch e
              console.log(e);
              console.log("Email error end")
            
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