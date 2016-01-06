define("feedback_launcher", [], () ->
    RemoveLoaderForPlayer = () ->
        Blaze.remove(require("global_data").PlayerScoreGeneratedFeedbackRenderer)

    LaunchScoreGeneratedFeedbackForPlayer = (scoreAdded) ->
        $parent = $("#player-side")[0]
        require("global_data").PlayerScoreGeneratedFeedbackRenderer = Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded}, $parent)
        Meteor.setTimeout(() ->
            RemoveLoaderForPlayer()
        , 2000
        )

    RemoveLoaderForOpponent = () ->
        Blaze.remove(require("global_data").OpponentScoreGeneratedFeedbackRenderer)

    LaunchScoreGeneratedFeedbackForOpponent = (scoreAdded) ->
        $parent = $("#opponent-side")[0]
        require("global_data").OpponentScoreGeneratedFeedbackRenderer = Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded}, $parent)
        Meteor.setTimeout(() ->
            RemoveLoaderForOpponent()
        , 2000
        )

    return {
        LaunchScoreGeneratedFeedbackForPlayer: LaunchScoreGeneratedFeedbackForPlayer
        RemoveLoaderForPlayer: RemoveLoaderForPlayer
        LaunchScoreGeneratedFeedbackForOpponent: LaunchScoreGeneratedFeedbackForOpponent
        RemoveLoaderForOpponent: RemoveLoaderForOpponent

    }
)