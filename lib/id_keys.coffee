DEF("id_keys", [], () ->
    return {
        GetServerMessagesCollectionName: () ->
            "server_messages"
        GetServerMessagesPublicationName: () ->
            "server_messages"
        GetChatMessagesCollectionName: () ->
            "chat_messages"
        GetChatMessagesPublicationName: () ->
            "chat_messages"
    }
)