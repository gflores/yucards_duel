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

    ShuffleArray = (arr) ->
        i = arr.length
        return arr unless i > 0
        while --i
            j = Math.floor(Math.random() * (i+1))
            [arr[i], arr[j]] = [arr[j], arr[i]] # use pattern matching to swap

    SelectTextById = (element) ->
        doc = document
        text = doc.getElementById(element)
        range = null
        selection = null

        if (doc.body.createTextRange)
            range = document.body.createTextRange();
            range.moveToElementText(text);
            range.select();
        else if (window.getSelection)
            selection = window.getSelection();        
            range = document.createRange();
            range.selectNodeContents(text);
            selection.removeAllRanges();
            selection.addRange(range);

    return {
        Timer: Timer
        ShuffleArray: ShuffleArray
        SelectTextById: SelectTextById
    }
)