Template.scoreGeneratedFeedback.helpers({
    GetValue: () ->
        return Math.abs(this.value)
    IsCriticalHit: () ->
        return this.damageCriticalityValue == 1
})

Template.scoreGeneratedFeedback.rendered = () ->
    feedback = $(this.find(".score-generated-feedback"))
    Meteor.setTimeout( () ->
        feedback.css("transform", "translateY(-1em)")
    , 100)

    instanceView = this.view
    Meteor.setTimeout(() ->
        Blaze.remove(instanceView)
    , 1500)

