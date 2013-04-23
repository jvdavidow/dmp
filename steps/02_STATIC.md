# Static Pages

```
% rails g controller welcome index about
      create  app/controllers/welcome_controller.rb
       route  get "welcome/about"
       route  get "welcome/index"
      invoke  erb
      create    app/views/welcome
      create    app/views/welcome/index.html.erb
      create    app/views/welcome/about.html.erb
      invoke  helper
      create    app/helpers/welcome_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/welcome.js.coffee
      invoke    scss
      create      app/assets/stylesheets/welcome.css.scss
```

Modify `layouts/application.html.erb`.

Have to just have "about" on menu.

Look at rake routes:

```
% rake routes
welcome_index GET    /welcome/index(.:format)  welcome#index
welcome_about GET    /welcome/about(.:format)  welcome#about
         root        /                         welcome#index
```
