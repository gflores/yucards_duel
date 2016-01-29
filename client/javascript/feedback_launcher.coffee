define("feedback_launcher", [], () ->

    LaunchScoreGeneratedFeedbackForPlayer = (scoreAdded) ->
        $parent = $("#player-side")[0]
        Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded}, $parent)

    LaunchScoreGeneratedFeedbackForOpponent = (scoreAdded) ->
        $parent = $("#opponent-side")[0]
        Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded}, $parent)

    return {
        LaunchScoreGeneratedFeedbackForPlayer: LaunchScoreGeneratedFeedbackForPlayer
        LaunchScoreGeneratedFeedbackForOpponent: LaunchScoreGeneratedFeedbackForOpponent
    }
)