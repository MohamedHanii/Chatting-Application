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
    app = Application.find_by(token: params[:token])
    chat = app.chats.find_by(chatNumber: params[:chatNumber])
    messageCount = Message.where(:chat_id => chat.id).count
    @newMessage = chat.messages.build(messageContent: params[:message], messageNumber: messageCount+1)
    chat.messageCount += 1
    chat.save
    @newMessage.save
    render json: @newMessage
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
    chat.messageCount-=1
    chat.save
    message.destroy
    render json: chat
   end
end