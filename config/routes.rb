require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  scope 'api/v1' do
    resources :applications, param: :token do
      resources :chats, param: :chat_number do
        resources :messages, param: :message_number
      end
    end

    get 'applications/messages/search', to: 'messages#search'

  end


  # get 'applications', to: 'applications#index'
  # get 'applications/:token', to: 'applications#show'
  # post 'applications', to: 'applications#create'
  # put 'applications/:token', to: 'applications#update'
  # delete 'applications/:token', to: 'applications#destroy'

  # get 'applications/:token/chats', to: 'chat#index'
  # get 'applications/:token/chats/:chatNumber', to: 'chat#show'
  # post 'applications/:token/chats', to: 'chat#create'
  # put 'applications/:token/chats/:chatNumber', to: 'chat#update'
  # delete 'applications/:token/chats/:chatNumber', to: 'chat#destroy'

  # get 'applications/:token/chats/:chatNumber/messages', to: 'message#list'
  # get 'applications/:token/chats/:chatNumber/messages/:messageNumber', to: 'message#show'
  # post 'applications/:token/chats/:chatNumber/messages', to: 'message#create'
  # put 'applications/:token/chats/:chatNumber/messages/:messageNumber', to: 'message#update'
  # delete 'applications/:token/chats/:chatNumber/messages/:messageNumber', to: 'message#destroy'
  
end
