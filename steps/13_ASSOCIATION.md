# Associations

Now that we have Devise let's associate posts with a user.

Need to add a migration in order to add user_id to posts. [info](http://guides.rubyonrails.org/migrations.html#creating-a-standalone-migration).

```
% rails g migration AddUserToPosts user_id:integer 
      invoke  active_record
      create    db/migrate/20130429201755_add_user_to_posts.rb
% rake db:reset
```

Need to add relationship to models (`has_many` & `belongs_to`).

Let's test this relationship out in the console.


```
>> u = User.first
  User Load (0.3ms)  SELECT "users".* FROM "users" LIMIT 1
=> #<User id: 1, name: nil, email: "ryan@bloc.io", encrypted_password: "$2a$10$702fd8Io3WH7UTWoTY3rUeUJBcFVlsq8/K6ypPKZUQni...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, confirmation_token: nil, confirmed_at: "2013-04-29 20:25:26", confirmation_sent_at: "2013-04-29 20:25:09", unconfirmed_email: nil, created_at: "2013-04-29 20:25:09", updated_at: "2013-04-29 20:25:26">
>> u
=> #<User id: 1, name: nil, email: "ryan@ryanjm.com", encrypted_password: "$2a$10$702fd8Io3WH7UTWoTY3rUeUJBcFVlsq8/K6ypPKZUQni...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, confirmation_token: nil, confirmed_at: "2013-04-29 20:25:26", confirmation_sent_at: "2013-04-29 20:25:09", unconfirmed_email: nil, created_at: "2013-04-29 20:25:09", updated_at: "2013-04-29 20:25:26">
>> u.posts
  Post Load (0.2ms)  SELECT "posts".* FROM "posts" WHERE "posts"."user_id" = 1
=> []
>> u.posts.create(title: "New Post", body: "This is a new post")
   (0.1ms)  begin transaction
  SQL (0.9ms)  INSERT INTO "posts" ("body", "created_at", "title", "updated_at", "user_id") VALUES (?, ?, ?, ?, ?)  [["body", "This is a new post"], ["created_at", Mon, 29 Apr 2013 20:26:03 UTC +00:00], ["title", "New Post"], ["updated_at", Mon, 29 Apr 2013 20:26:03 UTC +00:00], ["user_id", 1]]
   (1.3ms)  commit transaction
=> #<Post id: 14, title: "New Post", body: "This is a new post", created_at: "2013-04-29 20:26:03", updated_at: "2013-04-29 20:26:03", user_id: 1>
>> u.posts.count
   (0.3ms)  SELECT COUNT(*) FROM "posts" WHERE "posts"."user_id" = 1
=> 1
```

We can see that this relationship works properly. While we are in the console, let's look at how to create a User. We'll need to pass `password` and `password_confirmation`.

```
u = User.create(name: "Ryan", email: "ryan@ryanjm.com", password: "helloworld", password_confirmation: "helloworld")
```

This gives us "ActiveModel::MassAssignmentSecurity::Error: Can't mass-assign protected attributes: name". Let's change that. Add `:name` to list of `attr_accessible`. Then we need to reload the console and try again (use the up arrows):

```
>> reload!
Reloading...
=> true
>> u = User.create(name: "Ryan", email: "ryan@bloc.io", password: "helloworld", password_confirmation: "helloworld")
   (0.1ms)  begin transaction
  User Exists (0.3ms)  SELECT 1 AS one FROM "users" WHERE "users"."email" = 'ryan@bloc.io' LIMIT 1
  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."confirmation_token" = 'H3sg3wpm3GQqrxHNsWhD' LIMIT 1
Binary data inserted for `string` type on column `encrypted_password`
  SQL (0.9ms)  INSERT INTO "users" ("confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", "last_sign_in_at", "last_sign_in_ip", "name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "sign_in_count", "unconfirmed_email", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)  [["confirmation_sent_at", Mon, 29 Apr 2013 20:29:23 UTC +00:00], ["confirmation_token", "H3sg3wpm3GQqrxHNsWhD"], ["confirmed_at", nil], ["created_at", Mon, 29 Apr 2013 20:29:23 UTC +00:00], ["current_sign_in_at", nil], ["current_sign_in_ip", nil], ["email", "ryan@bloc.io"], ["encrypted_password", "$2a$10$mzfo7ZcH/PIuzhI9Tok.YeJXcRPLsdyiTDS/zpecK9atlYZ9X8vAa"], ["last_sign_in_at", nil], ["last_sign_in_ip", nil], ["name", "Ryan"], ["remember_created_at", nil], ["reset_password_sent_at", nil], ["reset_password_token", nil], ["sign_in_count", 0], ["unconfirmed_email", nil], ["updated_at", Mon, 29 Apr 2013 20:29:23 UTC +00:00]]
   (1.7ms)  commit transaction
=> #<User id: 2, name: "Ryan", email: "ryan@bloc.io", encrypted_password: "$2a$10$mzfo7ZcH/PIuzhI9Tok.YeJXcRPLsdyiTDS/zpecK9at...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, confirmation_token: "H3sg3wpm3GQqrxHNsWhD", confirmed_at: nil, confirmation_sent_at: "2013-04-29 20:29:23", unconfirmed_email: nil, created_at: "2013-04-29 20:29:23", updated_at: "2013-04-29 20:29:23">
```

When you do this with your own email you'll see the system sent the confirmation email, which took a second or two. We want to modify our "seeds.rb" file and when we do, we don't want to be sending email. Additionally you'll noticed that `confirmed_at` hasn't been set. We can do both of these at the same time if we'll call `User.new` instead of `create` and then call `skip_confirmation!` before calling `save`.

Let's add this to our seed file so that we can add a bunch of users. The trick it to grab a user at the end and reset the credentials so that you can sign in:

```
u = User.first
u.update_attributes(email: 'ryanjm@bloc.io', password: 'helloworld', password_confirmation: 'helloworld')
u.confirm!
```

Make sure to restart the server before trying to login.

## Adding Author information

Modified index page:

```
      <small>
        submitted <%= time_ago_in_words(post.created_at) %> ago by <%= post.user.name %><br/>
        <%= post.comments.count %> Comments
      </small>
```

Added `default_scope`:

```
  default_scope order('created_at DESC')
```


Added a random `created_at` to posts:

```
    # set the created_at to a time within the past year
    p.update_attribute(:created_at, Time.now - rand(600..31536000))
```

Then re-ran the seed file:

```
% rake db:reset
```

Restart server, sign in, go to posts.
