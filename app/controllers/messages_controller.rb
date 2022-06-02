class MessagesController < ActionController::Base
  before_action :set_chat

    # list all Messages
    # GET /api/v1/applications/:token/chats/:chatNumber/messages
    def index
        json_render(@chat.messages.all)
    end

  # Show Specific Message
  # GET /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber
  def show 
    message = @chat.messages.find_by(messageNumber: params[:message_number])
    json_render(message)
  end
 
 
   # Create New Message
   # POST /api/v1/applications/:token/chats/:chatNumber/messages
   def create 
    messageCount = incr_count(@chat)
    @newMessage = @chat.messages.build(messageContent: params[:message], messageNumber: messageCount)
    DbActionWorker.perform_async('Message',@newMessage.to_json)
    json_render(@newMessage)
   end
 
   
   # Update Message
   # PUT /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber
   def update
    message = @chat.messages.find_by(messageNumber: params[:message_number])
    message.messageContent = params[:message]
    message.save
    json_render(message)
   end
   
   #Delete Message 
   def destroy
    messageCount = decr_count(@chat)
    message = @chat.messages.find_by(messageNumber: params[:message_number])
    message.destroy
    json_render(@chat)
   end

   #Search for part or full message
   def search
    @results = Message.search(params[:query]) unless params[:query].blank?
    render json: @results.map{|value| value.as_json["_source"]}
   end


   private

   def set_chat 
    puts params
     @app = Application.find_by(token: params[:application_token]) 
     if @app
      @chat = @app.chats.find_by(chatNumber: params[:chat_chat_number])
     end
   end
 
   def json_render(reply)
     render json: reply.as_json(:except => [:id, :chat_id])
   end

   def incr_count(chat)
    $redis.sadd("message_counts",chat.id);
    $redis.set(chat.id,chat.messageCount) unless $redis.get(chat.id)
    chatCount = $redis.incr(chat.id)
  end

  def decr_count(chat)
    $redis.sadd("message_counts",chat.id);
    $redis.set(chat.id,chat.messageCount) unless $redis.get(chat.id)
    chatCount = $redis.decr(chat.id)
  end

end
