Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'applications', to: 'application#list'
  get 'applications/:token', to: 'application#show'
  post 'applications', to: 'application#create'
  put 'applications/:token', to: 'application#update'
  delete 'applications/:token', to: 'application#delete'

end
