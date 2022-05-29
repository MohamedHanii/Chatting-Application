class UpdateCountJob
  include Sidekiq::Job

  def perform(*args)
    puts 'Starting count job'
    appIds = $redis.smembers('chat_counts')
    appIds.each  do  |appId| 
      curr = Application.find_by(id: appId)
      curr.chatCount = $redis.get(appId)
      curr.save

    # app = Application.find_by(token: '033475831f')
    # chatCount = Chat.where(:application_id => app.id).count
    # app.chatCount = chatCount
    # app.save
    end
  end
end
