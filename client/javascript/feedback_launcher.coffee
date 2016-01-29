define("feedback_launcher", [], () ->

    LaunchScoreGeneratedFeedbackForPlayer = (scoreAdded) ->
        $parent = $("#player-side")[0]
        Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded}, $parent)

    LaunchScoreGeneratedFeedbackForOpponent = (scoreAdded) ->
        $parent = $("#opponent-side")[0]
        Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded}, $parent)

    LaunchAuraDamagingPlayer = (FinalResultFunc) ->
        Blaze.renderWithData(Template.damageAura, {FinalResultFunc: FinalResultFunc}, $("#player-side")[0])
    LaunchAuraDamagingOpponent = (FinalResultFunc) ->
        Blaze.renderWithData(Template.damageAura, {FinalResultFunc: FinalResultFunc}, $("#opponent-side")[0])

    return {
        LaunchScoreGeneratedFeedbackForPlayer: LaunchScoreGeneratedFeedbackForPlayer
        LaunchScoreGeneratedFeedbackForOpponent: LaunchScoreGeneratedFeedbackForOpponent
        LaunchAuraDamagingPlayer: LaunchAuraDamagingPlayer
        LaunchAuraDamagingOpponent: LaunchAuraDamagingOpponent
    }
)