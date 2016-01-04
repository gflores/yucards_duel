define("custom_collection_publisher", [], () ->
    GenerateHandlerForSync = (publisher, cursor, collectionName) ->
        cursor.observeChanges({
            added: (id, fields) ->
                publisher.added(collectionName, id, fields)
            removed: (id) ->
                publisher.removed(collectionName, id)
            changed: (id, fields) ->
                publisher.changed(collectionName, id, fields)
        })


    PublishCursor = (publicationName, collectionName, GetCursorFunc, IsAllowed) ->
        Meteor.publish(keys_FUNC.GetBattleEventPublicationName(publicationName), () ->
            console.log("User:#{this.userId} REQUESTS for subscription to '#{publicationName}'")
            if IsAllowed(this)
                collectionHandle = GenerateHandlerForSync(
                    this, GetCursorFunc(this), collectionName)
                this.ready()
                this.onStop( () ->
                    console.log("User:#{this.userId} UNSUBSCRIBED from '#{publicationName}'")
                    collectionHandle.stop()
                )
            else
                console.log("User:#{this.userId} DENIED subscription to '#{publicationName}'")
                return null
        )

    return {
        GenerateHandlerForSync: GenerateHandlerForSync
        PublishCursor: PublishCursor
    }
)