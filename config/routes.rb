Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'applications', to: 'application#list'
  get 'applications/:token', to: 'application#show'
  post 'applications', to: 'application#create'
  put 'applications/:token', to: 'application#update'
  delete 'applications/:token', to: 'application#delete'

  get 'applications/:token/chats', to: 'chat#list'
  get 'applications/:token/chats/:chatNumber', to: 'chat#show'
  post 'applications/:token/chats', to: 'chat#create'
  put 'applications/:token/chats/:chatNumber', to: 'chat#update'
  delete 'applications/:token/chats/:chatNumber', to: 'chat#delete'

  get 'applications/:token/chats/:chatNumber/messages', to: 'message#list'
  get 'applications/:token/chats/:chatNumber/messages/:messageNumber', to: 'message#show'
  post 'applications/:token/chats/:chatNumber/messages', to: 'message#create'
  put 'applications/:token/chats/:chatNumber/messages/:messageNumber', to: 'message#update'
  delete 'applications/:token/chats/:chatNumber/messages/:messageNumber', to: 'message#delete'

end
