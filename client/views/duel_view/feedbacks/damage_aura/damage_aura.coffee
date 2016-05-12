# GetNewSpinnerScale = () ->
#     return $(window).height() * 0.00080

# Meteor.Spinner.options = {
#   lines: 17
# , length: 0
# , width: 52
# , radius: 14
# , scale: GetNewSpinnerScale()
# , corners: 1
# , color: '#333333'
# , opacity: 0.05
# , rotate: 0
# , direction: 1
# , speed: 1.1
# , trail: 60
# , fps: 20
# , zIndex: 2e9
# , className: 'spinner'
# , top: '50%'
# , left: '50%'
# , shadow: false
# , hwaccel: false
# , position: 'absolute'
# }

# Meteor.startup(() ->
#     $(window).resize((evt) ->
#         Meteor.Spinner.options["scale"] = GetNewSpinnerScale()
#     )
# )

Template.damageAura.helpers({
    GetSpinnerScale: () ->
        return $(window).height() * 0.00120
})


Template.damageAura.rendered = () ->
    damageAura = $(this.find(".damage-aura-indicator"))
    # Meteor.setTimeout( () ->
    #     indicator.css("top", "0")
    # , 100)
    animation_utils = REQ("animation_utils")
    FinalResultFunc = this.data.FinalResultFunc

    instanceView = this.view

    tl = new TimelineLite()

    tl
        .to(damageAura[0], 0.3, {
            ease: Linear.easeNone, top: "-40%"
            onComplete: () ->
                # animation_utils.Shake(damageAura[0], 25, 0.010, 30, 30, 2)
                FinalResultFunc()
                Blaze.remove(instanceView)
        })
        # .to(damageAura[0], 0.3, {
        #     ease: Power0.easeNone, autoAlpha: 0, scale: 3
        #     onComplete: () ->
        #         Blaze.remove(instanceView)
        # })
