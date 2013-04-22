# CRUD

```
% rails g controller Posts index show new edit
      create  app/controllers/posts_controller.rb
       route  get "posts/edit"
       route  get "posts/new"
       route  get "posts/show"
       route  get "posts/index"
      invoke  erb
      create    app/views/posts
      create    app/views/posts/index.html.erb
      create    app/views/posts/show.html.erb
      create    app/views/posts/new.html.erb
      create    app/views/posts/edit.html.erb
      invoke  helper
      create    app/helpers/posts_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/posts.js.coffee
      invoke    scss
      create      app/assets/stylesheets/posts.css.scss
```

```
% rm public/index.html
```

## Routes

Removed: 

```
  get "posts/index"

  get "posts/show"

  get "posts/new"

  get "posts/edit"
```

Added:

```
resources :posts
root :to => 'posts#index'
```


