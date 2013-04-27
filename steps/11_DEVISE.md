# Devise

> Tip: It is helpful to keep three tabs open in Terminal. 1 for doing git/file management, 1 for the Rails server, and 1 for the console.

[Github](https://github.com/plataformatec/devise)

```
gem 'devise'
```

> Tip: you can just type `bundle` and it will, by default, run `bundle install`

```
% bundle
% rails generate devise:install
```

Follow instructions given by that.

1. Add `config.action_mailer.default_url_options = { :host => 'localhost:3000' }` to "config/environments/development.rb"

(should add explination of config folder and where inside this file to put this)

2. done already.
3. done (though different syntax)
4. Add `config.assets.initialize_on_precompile = false` to config/application.rb.
5. Fun `rails g devise:views`

```
% rails g devise:views
      invoke  Devise::Generators::SharedViewsGenerator
      create    app/views/devise/shared
      create    app/views/devise/shared/_links.erb
      invoke  form_for
      create    app/views/devise/confirmations
      create    app/views/devise/confirmations/new.html.erb
      create    app/views/devise/passwords
      create    app/views/devise/passwords/edit.html.erb
      create    app/views/devise/passwords/new.html.erb
      create    app/views/devise/registrations
      create    app/views/devise/registrations/edit.html.erb
      create    app/views/devise/registrations/new.html.erb
      create    app/views/devise/sessions
      create    app/views/devise/sessions/new.html.erb
      create    app/views/devise/unlocks
      create    app/views/devise/unlocks/new.html.erb
      invoke  erb
      create    app/views/devise/mailer
      create    app/views/devise/mailer/confirmation_instructions.html.erb
      create    app/views/devise/mailer/reset_password_instructions.html.erb
      create    app/views/devise/mailer/unlock_instructions.html.erb
```

```
% rails generate devise User
      invoke  active_record
      create    db/migrate/20130425234006_devise_create_users.rb
      create    app/models/user.rb
      insert    app/models/user.rb
       route  devise_for :users
```

Edit the migration before running it.

```
      t.string :name
```

## Adding Confirmable

Also enable confirmable in the migration. Uncomment these lines:

```
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email 
```


Then run the migration.


```
% rake db:migrate
==  DeviseCreateUsers: migrating ==============================================
-- create_table(:users)
   -> 0.1794s
-- add_index(:users, :email, {:unique=>true})
   -> 0.0011s
-- add_index(:users, :reset_password_token, {:unique=>true})
   -> 0.0008s
==  DeviseCreateUsers: migrated (0.1870s) =====================================
```


Now add "confirmable" to the user model. Open it up and add `:confirmable` to the end of the `devise` line (line 6). (Explain what this line does in the user model does).

If you have the server running, make sure to restart it. If you rake routes you'll see a whole set of routes for Devise.

```
% rake routes
        new_user_session GET    /users/sign_in(.:format)          devise/sessions#new
            user_session POST   /users/sign_in(.:format)          devise/sessions#create
    destroy_user_session DELETE /users/sign_out(.:format)         devise/sessions#destroy
           user_password POST   /users/password(.:format)         devise/passwords#create
       new_user_password GET    /users/password/new(.:format)     devise/passwords#new
      edit_user_password GET    /users/password/edit(.:format)    devise/passwords#edit
                         PUT    /users/password(.:format)         devise/passwords#update
cancel_user_registration GET    /users/cancel(.:format)           devise/registrations#cancel
       user_registration POST   /users(.:format)                  devise/registrations#create
   new_user_registration GET    /users/sign_up(.:format)          devise/registrations#new
  edit_user_registration GET    /users/edit(.:format)             devise/registrations#edit
                         PUT    /users(.:format)                  devise/registrations#update
                         DELETE /users(.:format)                  devise/registrations#destroy
       user_confirmation POST   /users/confirmation(.:format)     devise/confirmations#create
   new_user_confirmation GET    /users/confirmation/new(.:format) devise/confirmations#new
                         GET    /users/confirmation(.:format)     devise/confirmations#show...
```

## Setting up email

Since we've setup confirmable we'll need to setup UserMailer which is Rails's system for sending email.

To do this you just need to add a file under "config/initializers/" and you'll name it "setup_mail.rb".

```rb
# Add gmail smtp for development
if Rails.env.development?
  ActionMailer::Base.smtp_settings = {  
    :address              => "smtp.gmail.com",  
    :port                 => 587,  
    :domain               => "gmail.com",  
    :user_name            => "<<>>",  
    :password             => "<<>>",  
    :authentication       => "plain",  
    :enable_starttls_auto => true
  }  
end
```

Notice we'll be putting in secure information in here. Therefore it is **very important** that we make sure to add this to our .gitignore file. DO NOT COMMIT THIS FILE TO GITHUB.

In the base directory of your project you should have a `.gitignore` file. Add the following line to your file.

```
config/initializers/setup_mail.rb
```

Verify that the file does not show up when you do `git status`. Additionally it will be helpful for others if you will copy the file to "setup_mail.rb.tmp" and take out the sensative data. This way anyone cloning your project can copy this file and get up and running. It would also help to make a note about this in the README.md.

## Test Registration

Now that all of that is setup, let's test it out. Go to `/users/sign_up`. Go ahead and sign up for the site. You should be redirected to the home page with an alert that says, "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."

Check your email and click on the link in the email. You should get a message that says:  "Your account was successfully confirmed. You are now signed in."

If you refresh the page, you won't have any notification that you are signed in. Let's change that.

## current_user

Devise gives us a variable called `current_user` that refers to the user who is logged in. We can check to see if it exists in order to know if someone is logged in and then use it to grab information. Let's modify our menu to look like this:

```erb
      <ul class="nav nav-tabs">
        <li><%= link_to "Bloccit", welcome_index_path %></li>
        <li><%= link_to "About", welcome_about_path %></li>
        <li><%= link_to "Posts", posts_path %></li>
        <div class="pull-right user-info">

          <% if current_user %>
            Hello <%= current_user.email %>! <%= link_to "Sign out", destroy_user_session_path, method: :delete %>
          <% else %>
            <%= link_to "Sign In", new_user_session_path %> or 
            <%= link_to "Sign Up", new_user_registration_path %>
          <% end %>
        </div>
      </ul>
```

We are grabbing these urls from `% rake routes`.

Now the formatting is off a little so add the following to `application.css.scss`:

```css
.user-info {
  margin-top: 9px;
}
```
