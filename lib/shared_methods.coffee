Meteor.methods({
    "SetIsDisplayingInstructions": (isDisplayingInstructions) ->
        Meteor.users.update(Meteor.userId(), {$set: {isDisplayingInstructions: isDisplayingInstructions}})
    "SetIsMusicMuted": (isMusicMuted) ->
        Meteor.users.update(Meteor.userId(), {$set: {isMusicMuted: isMusicMuted}})
    "SetIsCrazyMode": (isCrazyMode) ->
        Meteor.users.update(Meteor.userId(), {$set: {isCrazyMode: isCrazyMode}})
})
