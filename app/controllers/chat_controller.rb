class ChatController < ActionController::Base
  protect_from_forgery with: :exception

    # List All Application
    def list
        app = Application.find_by(token: params[:token])
        render json: app.chats.all
    end

   # List a single Application
   def show 
     app = Application.find_by(token: params[:token])
     chat = Chat.find_by(application_id: app.id, chatNumber: params[:chatNumber])
     render json: chat
   end
 
 
  skip_before_action :verify_authenticity_token
   #Create New Application
   def create 
    app = Application.find_by(token: params[:token])
    chatCount = Chat.where(:application_id => app.id).count
    @newChat = app.chats.build(chatName: params[:name], chatNumber: chatCount+1)
    #app.chatCount += 1
    #app.save
    @newChat.save
    render json: @newChat
   end
 
   
   # Update Application
   def update
     app = Application.find_by(token: params[:token])
     chat = app.chats.find_by(chatNumber: params[:chatNumber])
     chat.chatName = params[:name]
     chat.save
     render json: chat
   end
   
   #Delete Application
   def delete
     app = Application.find_by(token: params[:token])
     chat = app.chats.find_by(chatNumber: params[:chatNumber])
     app.chatCount-=1
     app.save
     chat.destroy
     render json: app
   end
 
 
end