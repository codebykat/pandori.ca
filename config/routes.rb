Pandorica::Application.routes.draw do
  get "quote/index"

  resources :characters

  resources :quotes, :only => [:index, :show]
  resources :episodes, :only => [:index, :show]

  root :to => "quotes#index"

end
