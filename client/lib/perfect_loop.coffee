class @PerfectLoop
    constructor: (@uri, autostart, deltaStart, deltaEnd, deltaRepeat) ->
        self = this
        @pauseAudioTimeout = null
        @playNextAudioTimeout = null
        @audio1 = new Audio(@uri)
        @audio2 = new Audio(@uri)
        @isPlaying = false
        @audio2.oncanplaythrough =  () ->
            if self.isPlaying == false
                self.deltaStart = deltaStart
                self.deltaEnd = deltaEnd
                self.deltaRepeat = deltaRepeat

                self.realDuration = self.audio2.duration - self.deltaStart - self.deltaEnd
                if autostart == true
                    self.play()
                console.log("can play through!")

    play: (loopCallback) ->
        self = this
        @isPlaying = true
        @audio2.play()
        @audio2.volume = 0
        self.SchedulePlayAndPause(@audio1, @audio2, loopCallback)

    SchedulePlayAndPause: (currentAudio, nextAudio, loopCallback) ->
        self = this
        currentAudio.currentTime = self.deltaStart
        currentAudio.volume = 1
        currentAudio.play()
        if loopCallback? == true
            loopCallback(self.deltaStart)
        @pauseAudioTimeout = Meteor.setTimeout(() ->
            currentAudio.pause()
        , self.realDuration * 1000)
        @playNextAudioTimeout = Meteor.setTimeout(() ->
            self.SchedulePlayAndPause(nextAudio, currentAudio, loopCallback)
        , (self.realDuration + self.deltaRepeat) * 1000)


    stop: () ->
        if @isPlaying
            @isPlaying = false
            @audio1.pause()
            @audio2.pause()
            Meteor.clearTimeout(@pauseAudioTimeout)
            Meteor.clearTimeout(@playNextAudioTimeout)
