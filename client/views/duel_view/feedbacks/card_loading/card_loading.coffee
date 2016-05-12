
# GetNewSpinnerScale = () ->
#     return $(window).height() * 0.00040

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

Template.cardLoading.helpers({
    GetSpinnerScale: () ->
        return $(window).height() * 0.00040
})

Template.cardLoading.rendered = () ->
    # indicator = $(this.find(".car-loading-indicator"))
    # Meteor.setTimeout( () ->
    #     indicator.css("top", "15%")
    # , 100)
    side = this.data.side
    if side == "isPlayer"
        timeoutTime = 50
        firstBarLoadingTime = 1.2 + 0.150
    else
        timeoutTime = 0
        firstBarLoadingTime = 1.2

    tl = new TimelineLite()
    element = this.find(".filling-part")
    element2 = this.find(".filling-part-2")
    Meteor.setTimeout(() ->
        tl
            .to(element, firstBarLoadingTime, {width: "33%", ease:Linear.easeNone})
            .to(element2, 2.4, {width: "67%", ease:Linear.easeNone})
    , timeoutTime)

    tl2 = new TimelineLite()
    element3 = this.find(".loading-bar")

    REQ("animation_utils").Shake(element3, firstBarLoadingTime / 0.016, 0.016, 1.7, 1.7)
    tl2
        .to(element3, firstBarLoadingTime, {
            scale: "1.0", ease:Linear.easeNone,
            onComplete: () ->
                REQ("animation_utils").Shake(element3, 2.4 / 0.030, 0.030, 3, 3)

        })
        .to(element3, 2.4, {scale: "1.4", ease:Linear.easeNone})
