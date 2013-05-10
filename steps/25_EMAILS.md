# Following a Thread

Being able to get email notifications for your favorite stories might be of interest to some of your users. In order to do that you will need to:

* Add email permission to user account
* Add a model to represent the favorites
* Add to post show
* Set up email notifications for new comments to a post

## Add email permissions

```
% rails g migration AddEmailPermissionToUsers email_favorites:boolean
      invoke  active_record
      create    db/migrate/20130510022054_add_email_permission_to_users.rb
```

Add default to migration.

```
add_column :users, :email_favorites, :boolean, default: false
```

```
% rake db:migrate
```

Add boolean to user model. Also cleaning up view to use Bootstrap.

Add :email_favorites to attr_accessible in User model.

## Add Favorites model

```
% rails g model Favorite post:references user:references
      invoke  active_record
      create    db/migrate/20130510025251_create_favorites.rb
      create    app/models/favorite.rb
```

Add `has_many` to posts and users

## Add to view

Add

```
    <div>
      <% if current_user.favorited?(@post) %>
        unfavorite
      <% else %>
        favorite
      <% end %>
    </div>
```

You need to created `favorited?`

```ruby
  def favorited?(post)
    self.favorites.where(post_id: post.id).count
  end
```

Now to create the favorite/unfavorte part you could do what you just did for up/down votes, but we'll walk you through another way of doing it.

Add the form to create a favorite:

```
...
```

Need to use a button instead of a input submit so we could put the icon + text in there.

If you reload the page you get "undefined method `favorites_path'", need to add the route.

Add the favorites_controller and the create action

Add post to the attr_accessible for favorite

Add delete button

Add a class and css in order to give a little spacing.

Add authorization around it (so it doesn't show up if your not logged in). And authorization to the controller.

Move to partial.

## Email notifications

[Guides](http://guides.rubyonrails.org/action_mailer_basics.html)

```
% rails g mailer FavoriteMailer
      create  app/mailers/favorite_mailer.rb
      invoke  erb
      create    app/views/favorite_mailer
```

Update `from` address in mailer.

Header info from [threading](http://blog.bloc.io/perfect-email-threading-in-rails) post.

Updated the config/development to use the Pow address

Updated the _comment partial to include the anchor. Should mention how jumping to an id (anchor) works.

Testing out the mailer in the console. Probably should mention that ActionMailer does some "Rails Magic" in order to be able to call the instance methods as class methods.

```
>> u = User.last # make sure it is a valid email you can check
>> p = Post.first
>> c = p.comments.last
>> FavoriteMailer.new_comment(u, p, c).deliver
```

## After create

Now you want to send an email every time a new comment is added. Add this as an after_create method.

```
  def send_favorite_emails
    # for every favorite associated with post, send email
    self.post.favorites.each do |fav|
      FavoriteMailer.new_comment(fav.user, self.post, self).deliver
    end
  end
```

Problem is we don't want to send email to user if they are the one who commented.


```
  FavoriteMailer.new_comment(fav.user, self.post, self).deliver unless fav.user_id == self.user_id
```
