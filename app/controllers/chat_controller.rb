class ChatController < ActionController::Base
  protect_from_forgery with: :exception

    # List All Application
    def list
        app = Application.find_by(token: params[:token])
        render json: Chat.find_by(appId: app.id)
    end

   # List a single Application
   def show 
     app = Application.find_by(token: params[:token])
     render json: app
   end
 
 
  skip_before_action :verify_authenticity_token
   #Create New Application
   def create 
    app = Application.find_by(token: params[:token])
    chatCount = Chat.where(:application_id => app.id).count
    @newChat = app.chats.build(chatName: params[:name], chatNumber: chatCount+1)
    @newChat.save
    render json: @newChat
   end
 
   
   # Update Application
   def update
     app = Application.find_by(token: params[:token])
     app.name = params[:name]
     app.save
     render json: app
   end
   
   #Delete Application
   def delete
     app = Application.find_by(token: params[:token])
     app.destroy
     render json: app
   end
 
 
end