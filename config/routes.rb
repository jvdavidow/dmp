BlocReddit::Application.routes.draw do
  
  resources :topics do
    resources :posts, except: [:index]
  end

  devise_for :users

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'
end
