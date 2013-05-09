# Facebook

Facebook (and many other services) use omniauth to allow their users to sign in on other websites. Today you'll be implimenting Facebook connect with your app.

> Should cover what Omniauth is at a high level and how it works.

Check out the [overview](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview) on Devise's wiki page (which is really helpful!).

Gemfile:

```
gem 'omniauth'
gem 'omniauth-facebook'
```

```
% bundle
```

Migration:

```
% rails g migration AddOmniauthToUsers provider:string uid:string
      invoke  active_record
      create    db/migrate/20130509164401_add_omniauth_to_users.rb
% rake db:migrate
==  AddOmniauthToUsers: migrating =============================================
-- add_column(:users, :provider, :string)
   -> 0.0015s
-- add_column(:users, :uid, :string)
   -> 0.0007s
==  AddOmniauthToUsers: migrated (0.0024s) ====================================
```

Add both to `attr_accessible`.

Add facebook configuration to `config/initializers/devise.rb`. Use the `ENV` like we did before.

## Pow

In order for Facebook to be able to redirect back to your site, you will need to sign up for a Facebook developer account and give it a url. Unfortinetly `localhost:3000` and `0.0.0.0:3000` won't work. So we'll use [Pow](http://pow.cx/) instead. Pow is also just a great tool to use as you develop your own applications.

To install pow:

```
$ curl get.pow.cx | sh
```

Now we need to add a symlink. A symlink is just a file that points to a different location. Either another file or folder. Grab the path to your project by doing:

```
% pwd
```

Then add the symlink to pow.

```
$ cd ~/.pow
$ ln -s /path/to/myapp
```

Now you can visit your app at `http://myapp.dev/` (don't forget the `http://` and replace "myapp" with the name of your app's folder). We can now use this url for facebook.

> Pro tip, if you want to rename your app so that it is a cleaner url: `% ln -s /path/to/app newappname` then you can just use `http://newappname.dev`.

## Facebook

Now you'll need to get your own access id/secret from facebook. Sign in [here](https://developers.facebook.com/docs/facebook-login/getting-started-web/).

You'll need to "Create New App". Do not check "Free hosting from Heroku".

When filling out information, make sure to not include "http://" or the ending "/" when putting in the App Domain.

Updated application.yml and application.example.yml

Add `:omniauthable, :omniauth_providers => [:facebook]` to devise in the User model.

Now go to your pow url and when you click "sign up" you will see a link to sign in with Facebook. Click on it. You are now asked if you want to grant your app permission.

Now when you click yes and it redirects back to your site you'll get an "Unknown action" error. This is because you haven't setup a controller to handle that route.

## Handle the Redirect

Let devise know which controller will handle the callback in the route.

```
devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
```

Add a folder `users` under controllers and add `omniauth_callbacks_controller.rb` to it.

Debugging: Got a "uninitialized constant Users::OmniauthCallbacksController" error. That was because I forgot to add `_controller` to the file name.

Tip: If you need to test your signin process again, you'll need to go into rails console and delete the user.

That is it!

## Heroku

In order to make the app work on heroku, you'll need to create an additional app within facebook and get another set of credentails, then update your application.yml files.

Make sure to update heroku's configs:

```
rake figaro:heroku
```

And migrate the database on heroku.

```
% heroku run rake db:migrate
```

If you've already signed up with your facebook email on heroku, make sure to delete it before trying to login again.

```
% heroku run rails c
```
