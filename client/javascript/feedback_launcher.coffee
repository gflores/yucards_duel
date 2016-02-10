define("feedback_launcher", [], () ->

    LaunchScoreGeneratedFeedbackForPlayer = (scoreAdded, damageCriticalityValue) ->
        $parent = $("#player-side")[0]
        Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded, damageCriticalityValue: damageCriticalityValue}, $parent)

    LaunchScoreGeneratedFeedbackForOpponent = (scoreAdded, damageCriticalityValue) ->
        $parent = $("#opponent-side")[0]
        Blaze.renderWithData(Template.scoreGeneratedFeedback, {value: scoreAdded, damageCriticalityValue: damageCriticalityValue}, $parent)

    LaunchAuraDamagingPlayer = (FinalResultFunc) ->
        Blaze.renderWithData(Template.damageAura, {FinalResultFunc: FinalResultFunc}, $("#player-side")[0])
    LaunchAuraDamagingOpponent = (FinalResultFunc) ->
        Blaze.renderWithData(Template.damageAura, {FinalResultFunc: FinalResultFunc}, $("#opponent-side")[0])


    currentSvgIndex = 0
    elementColorTable = {
        "ROCK": "#856C4C"
        "PAPER": "#C5E1A4"
        "SCISSOR": "#FF8080"
    }
    currentElement = null
    LaunchChangeEnvironmentTo = (element) ->
        if currentElement == element
            return
        currentElement = element
        color = elementColorTable[element]
        environmentCircle = $("#card-environment > svg:eq(#{currentSvgIndex})")
        currentSvgIndex = (currentSvgIndex + 1) % 3
        environmentCircle.css("z-index", parseInt(environmentCircle.css("z-index")) + 1)
        elementToGrow = environmentCircle.find("circle")
        elementToGrow.attr("r", 0)
        elementToGrow.attr("fill", color)

        TweenLite.to(elementToGrow[0], 1, {ease: Linear.easeNone, attr: {r:Math.max($(window).width(), $(window).height()) * 0.7}});

    return {
        LaunchScoreGeneratedFeedbackForPlayer: LaunchScoreGeneratedFeedbackForPlayer
        LaunchScoreGeneratedFeedbackForOpponent: LaunchScoreGeneratedFeedbackForOpponent
        LaunchAuraDamagingPlayer: LaunchAuraDamagingPlayer
        LaunchAuraDamagingOpponent: LaunchAuraDamagingOpponent
        LaunchChangeEnvironmentTo: LaunchChangeEnvironmentTo
    }
)