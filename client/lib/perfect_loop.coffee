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
        @currentAudio = null
        # @audio1.onplaying = () ->
        #     console.log("audio1 on PLAYING #{(new Date()).getTime()}")

        # @audio1.onseeking = () ->
        #     console.log("audio1 SEEKING #{(new Date()).getTime()}")
        # @audio1.onseeked = () ->
        #     console.log("audio1 SEEKED #{(new Date()).getTime()}")
        # @audio1.onloadstart = () ->
        #     console.log("audio1 LOADSTART #{(new Date()).getTime()}")
        # @audio1.ontimeupdate = () ->
        #     console.log("audio1 TIMEUPDATE #{(new Date()).getTime()}")



        # @audio2.onplaying = () ->
        #     console.log("audio2 on PLAYING #{(new Date()).getTime()}")
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
        @currentAudio = currentAudio
        self = this
        currentAudio.currentTime = self.deltaStart
        if Meteor.user().isMusicMuted
            currentAudio.volume = 0
        else
            currentAudio.volume = 1

        if self.loopCallback? == true
            # console.log(">loopback #{(new Date()).getTime()}")
            self.loopCallback(self.deltaStart)
            # console.log("<loopback #{(new Date()).getTime()}")

        currentAudio.play()
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
