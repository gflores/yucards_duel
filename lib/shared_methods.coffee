Meteor.methods({
    "SetIsDisplayingInstructions": (isDisplayingInstructions) ->
        Meteor.users.update(Meteor.userId(), {$set: {isDisplayingInstructions: isDisplayingInstructions}})
})
