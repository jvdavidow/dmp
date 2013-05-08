BlocReddit::Application.routes.draw do
  
  resources :topics do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
    end
  end

  devise_for :users

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'
end
