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
    currentElement = null
 
    # elementColorTable = {
    #     "ROCK": "#856C4C"
    #     "PAPER": "#C5E1A4"
    #     "SCISSOR": "#FF8080"
    # }

    elementEnvIdTable = {
        "ROCK": "rock-environment"
        "PAPER": "paper-environment"
        "SCISSOR": "scissor-environment"
    }

    # LaunchChangeEnvironmentTo = (element) ->
    #     if currentElement == element
    #         return
    #     currentElement = element
    #     color = elementColorTable[element]
    #     environmentCircle = $("#card-environment > svg:eq(#{currentSvgIndex})")
    #     currentSvgIndex = (currentSvgIndex + 1) % 3
    #     environmentCircle.css("z-index", parseInt(environmentCircle.css("z-index")) + 1)
    #     elementToGrow = environmentCircle.find("circle")
    #     elementToGrow.attr("r", 0)
    #     elementToGrow.attr("fill", color)
    #     TweenLite.to(elementToGrow[0], 1, {ease: Linear.easeNone, attr: {r:Math.max($(window).width(), $(window).height()) * 0.7}});

    environmentCurrentZIndex = -2000;

    LaunchChangeEnvironmentTo = (element) ->
        if currentElement == element
            return
        currentElement = element
        id = elementEnvIdTable[element]
        environmentCircle = $("#card-environment > svg##{id}")
        currentSvgIndex = (currentSvgIndex + 1) % 3
        environmentCurrentZIndex += 1;
        environmentCircle.css("z-index", environmentCurrentZIndex)

        elementToGrow = environmentCircle.find("circle")
        backgroundImage = environmentCircle.find("image")

        imageHeightToWidthRatio = 1.3334

        windowHeightReference = $(window).height()
        
        if $(window).width() < 960
            windowWidthReference = $(window).width() * 1.4

            iconWidth = (60 + ( ($(window).width() - 360) / (960 - 360) ) * (130 - 60))
            lifeBarWidth = $(window).width() - iconWidth

            elementToGrow.attr("cx", iconWidth + lifeBarWidth / 2)
        else
            windowWidthReference = $(window).width()
            elementToGrow.attr("cx", "50%")

        imageHeight = windowHeightReference
        imageWidth = imageHeight * imageHeightToWidthRatio
        if (imageWidth < windowWidthReference)
            imageWidth = windowWidthReference
            imageHeight = imageWidth / imageHeightToWidthRatio

        backgroundImage.attr("width", imageWidth)
        backgroundImage.attr("height", imageHeight)
        console.log("WIDTH #{imageWidth}  HEIGHT #{imageHeight}")
        elementToGrow.attr("r", 0)
        # elementToGrow.attr("fill", color)
        TweenLite.to(elementToGrow[0], 1, {ease: Linear.easeNone, attr: {r:Math.max($(window).width(), $(window).height()) * 0.7}});
        # TweenLite.to(elementToGrow[0], 1, {ease: Linear.easeNone, attr: {r:100}});

    return {
        LaunchScoreGeneratedFeedbackForPlayer: LaunchScoreGeneratedFeedbackForPlayer
        LaunchScoreGeneratedFeedbackForOpponent: LaunchScoreGeneratedFeedbackForOpponent
        LaunchAuraDamagingPlayer: LaunchAuraDamagingPlayer
        LaunchAuraDamagingOpponent: LaunchAuraDamagingOpponent
        LaunchChangeEnvironmentTo: LaunchChangeEnvironmentTo
    }
)