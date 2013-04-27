BlocReddit::Application.routes.draw do
  devise_for :users

  get "welcome/index"
  get "welcome/about"

  resources :posts
  root :to => 'welcome#index'
end
