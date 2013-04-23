BlocReddit::Application.routes.draw do
  get "welcome/index"
  get "welcome/about"

  resources :posts
  root :to => 'welcome#index'
end
