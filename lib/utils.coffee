define("utils", [], () ->
    class Timer
        constructor: (lastTime)->
            if lastTime? == false
                lastTime = (new Date).getTime()
            @lastTime = lastTime
            @currentValue = 0

        UpdateAndGet: (updateTime) ->
            if updateTime? == false
                updateTime = (new Date).getTime()
            @currentValue = updateTime - @lastTime
            return @currentValue

        Reset: (lastTime)->
            if lastTime? == false
                lastTime = (new Date).getTime()
            @lastTime = lastTime
            @currentValue = 0

    return {
        Timer: Timer
    }
)