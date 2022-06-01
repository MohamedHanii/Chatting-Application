class ChatsController < ActionController::Base
  before_action :set_app

    # List All Chats for Application
    # GET api/v1/applications/:token/chats
    def index
      json_render(@app.chats.all)
    end

   # List a single specific Chat inside application
   # GET api/v1/applications/:token/chats/:chatNumber
   def show 
    chat = @app.chats.find_by(chatNumber: params[:chat_number])
    json_render(chat)
   end
 
 
   # Create New Chat
   # POST api/v1/applications/:token/chats
   def create 
    chatCount = incr_count(@app)
    @newChat = @app.chats.build(chatName: params[:name], chatNumber: chatCount)
    DbActionWorker.perform_async('Chat',@newChat.to_json)
    json_render(@newChat)
   end
 
   
   # Update Chat
   # PUT api/v1/applications/:token/chats/:chatNunber
   def update
     chat = @app.chats.find_by(chatNumber: params[:chat_number])
     chat.chatName = params[:name]
     chat.save
     json_render(chat)
   end
   
   # Update Chat
   # DELETE api/v1/applications/:token/chats/:chatNunber
   def destroy
     chatCount = decr_count(@app)
     chat = @app.chats.find_by(chatNumber: params[:chat_number])
     chat.destroy
     json_render(@app)
   end
 
 
  private

  def set_app 
    @app = Application.find_by(token: params[:application_token])
  end

  def json_render(reply)
    puts params
    render json: reply.as_json(:except => [:id, :application_id])
  end

  def incr_count(app)
    $redis.sadd("chat_counts",app.token);
    $redis.set(app.token,app.chatCount) unless $redis.get(app.token)
    chatCount = $redis.incr(app.token)
  end

  def decr_count(app)
    $redis.sadd("chat_counts",app.token);
    $redis.set(app.token,app.chatCount) unless $redis.get(app.token)
    chatCount = $redis.decr(app.token)
  end
  
end