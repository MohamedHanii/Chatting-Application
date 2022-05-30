class UpdateCountJob
  include Sidekiq::Job

  def perform(*args)
    puts 'Starting count job'
    puts $redis.smembers('chat_counts')
    appTokens = $redis.smembers('chat_counts')
    appTokens.each  do  |token| 
      curr = Application.find_by(token: token)
      if curr
        curr.chatCount = $redis.get(token)
        curr.save
      end
      $redis.srem('chat_counts',token)
    end

    puts 'Updating messages'
    puts $redis.smembers('message_counts')
    chatIds = $redis.smembers('message_counts')
    chatIds.each  do  |chatId| 
      currChat = Chat.find_by(id: chatId)
      if currChat
        currChat.messageCount = $redis.get(chatId)
        currChat.save
      end
      $redis.srem('message_counts',chatId)
    end
  end
end
