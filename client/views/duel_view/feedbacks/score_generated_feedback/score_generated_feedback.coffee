Template.scoreGeneratedFeedback.helpers({
    GetValue: () ->
        return Math.abs(this.value)
})

Template.scoreGeneratedFeedback.rendered = () ->
    feedback = $(this.find(".score-generated-feedback"))
    Meteor.setTimeout( () ->
        feedback.css("transform", "translateY(-1em)")
    , 100)

