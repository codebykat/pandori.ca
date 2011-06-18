Pandorica::Application.routes.draw do
  get "quote/index"

  resources :characters, :only => [:index, :show, :update]

  resources :quotes, :only => [:index, :show]
  resources :episodes, :only => [:index, :show]

  root :to => "quotes#random"
  match '(/*quotes)' => "quotes#random", :quotes => /(\d+(-\d+)?\.){3}\d+(-\d+)?/
end
