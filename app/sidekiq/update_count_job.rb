class UpdateCountJob
  include Sidekiq::Job

  def perform(*args)
    puts 'Starting count job'
    app = Application.find_by(token: '8ba43cefe0')
    chatCount = Chat.where(:application_id => app.id).count
    app.chatCount = chatCount
    app.save
  end
end
