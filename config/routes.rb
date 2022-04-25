Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages
  post :lost_script, to: 'messages#lost_script'
  get :admin, to: 'messages#admin'
  get :doctor, to: 'messages#doctor'

end
