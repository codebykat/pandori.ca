Pandorica::Application.routes.draw do
  resources :characters

  resources :quotes, :only => [:index, :show]
  resources :episodes, :only => [:index, :show]

  root :to => "quotes#index"

end
