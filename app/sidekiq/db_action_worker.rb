class DbActionWorker
  include Sidekiq::Worker

  def perform(modelName, record)
    model = modelName.constantize
    object = JSON.parse(record)
    model.new(object).save!
  end
  
end
