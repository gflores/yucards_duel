
GetNewSpinnerScale = () ->
    return $(window).height() * 0.00040

Meteor.Spinner.options = {
  lines: 17
, length: 0
, width: 52
, radius: 14
, scale: GetNewSpinnerScale()
, corners: 1
, color: '#333333'
, opacity: 0.05
, rotate: 0
, direction: 1
, speed: 1.1
, trail: 60
, fps: 20
, zIndex: 2e9
, className: 'spinner'
, top: '50%'
, left: '50%'
, shadow: false
, hwaccel: false
, position: 'absolute'
}

Meteor.startup(() ->
    $(window).resize((evt) ->
        Meteor.Spinner.options["scale"] = GetNewSpinnerScale()
    )
)



Template.cardLoading.rendered = () ->
    indicator = $(this.find(".car-loading-indicator"))
    Meteor.setTimeout( () ->
        indicator.css("top", "15%")
    , 100)

