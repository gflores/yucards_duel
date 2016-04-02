class @PerfectLoop
    constructor: (@uri, @autostart, deltaStart, deltaEnd, deltaRepeat) ->
        self = this
        @pauseAudioTimeout = null
        @playNextAudioTimeout = null
        @audio1 = new Audio(@uri)
        @audio2 = new Audio(@uri)
        @isPlaying = false
        @isInit = false
        @loopCallback = null
        @audio2.oncanplaythrough =  () ->
            if self.isInit == false
                self.isInit = true
                self.deltaStart = deltaStart
                self.deltaEnd = deltaEnd
                self.deltaRepeat = deltaRepeat

                self.realDuration = self.audio2.duration - self.deltaStart - self.deltaEnd
                if self.autostart == true
                    self.play(self.loopCallback)
                console.log("can play through!")

    play: (loopCallback) ->
        self = this
        @loopCallback = loopCallback
        if @isInit == true
            @isPlaying = true
            @audio2.play()
            @audio2.volume = 0
            self.SchedulePlayAndPause(@audio1, @audio2)
        else
            console.log("play not ready, autostart")
            @autostart = true

    SchedulePlayAndPause: (currentAudio, nextAudio) ->
        self = this
        currentAudio.currentTime = self.deltaStart
        currentAudio.volume = 1
        currentAudio.play()
        if self.loopCallback? == true
            self.loopCallback(self.deltaStart)
        @pauseAudioTimeout = Meteor.setTimeout(() ->
            currentAudio.pause()
        , self.realDuration * 1000)
        @playNextAudioTimeout = Meteor.setTimeout(() ->
            self.SchedulePlayAndPause(nextAudio, currentAudio)
        , (self.realDuration + self.deltaRepeat) * 1000)


    stop: () ->
        if @isPlaying
            @isPlaying = false
            @audio1.pause()
            @audio2.pause()
            Meteor.clearTimeout(@pauseAudioTimeout)
            Meteor.clearTimeout(@playNextAudioTimeout)
