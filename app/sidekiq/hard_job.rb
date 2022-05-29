class HardJob
  include Sidekiq::Job

  def perform(*args)
      puts 'Running'  
  end
end
