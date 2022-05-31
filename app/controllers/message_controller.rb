class MessageController < ActionController::Base
    protect_from_forgery with: :exception

    # List All Application
    def list
        app = Application.find_by(token: params[:token])
        chat = app.chats.find_by(chatNumber: params[:chatNumber])
        render json: chat.messages.all
    end

   # List a single Application
   def show 
    app = Application.find_by(token: params[:token])
    chat = app.chats.find_by(chatNumber: params[:chatNumber])
    message = chat.messages.find_by(messageNumber: params[:messageNumber])
    render json: message
   end
 
 
  skip_before_action :verify_authenticity_token
   #Create New Application
   def create 
    #  query = params[:content]
    #  @message = Message.search_content(query)
    app = Application.find_by(token: params[:token])
    chat = app.chats.find_by(chatNumber: params[:chatNumber])

    $redis.sadd("message_counts",chat.id);

    if $redis.get(chat.id)
      # need to revert this if 
      puts 'app.id found'
    else
      puts 'app.id found'
      $redis.set(chat.id,chat.messageCount)
    end

    messageCount = $redis.incr(chat.id)
    @newMessage = chat.messages.build(messageContent: params[:message], messageNumber: messageCount)
    
    DbActionWorker.perform_async('Message',@newMessage.to_json)

    #@newMessage.save
    render json: @newMessage

    # render json: @message
   end
 
   
   # Update Application
   def update
    app = Application.find_by(token: params[:token])
    chat = app.chats.find_by(chatNumber: params[:chatNumber])
    message = chat.messages.find_by(messageNumber: params[:messageNumber])
    message.messageContent = params[:content]
    message.save
    render json: message
   end
   
   #Delete Application 
   def delete
    app = Application.find_by(token: params[:token])
    chat = app.chats.find_by(chatNumber: params[:chatNumber])
    message = chat.messages.find_by(messageNumber: params[:messageNumber])
    $redis.sadd("message_counts",chat.id);

    if $redis.get(chat.id)
      # need to revert this if 
      puts 'app.id found'
    else
      puts 'app.id found'
      $redis.set(chat.id,chat.messageCount)
    end
    $redis.decr(chat.id)

    message.destroy
    render json: chat
   end

   def search
    @results = Message.search(params[:query]) unless params[:query].blank?
    render json: @results.map{|value| value.as_json["_source"]}
   end

end
