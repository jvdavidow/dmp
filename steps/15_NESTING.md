# Topics & Nesting

Possibly a _little_ ambitious, but the goal for this step is to:

* Create topics
* Lock it off for just admin
* Nest comments under topics

## Create topics

### Create the model

```
% rails g model topic name:string public:boolean description:text
      invoke  active_record
      create    db/migrate/20130503194244_create_topics.rb
      create    app/models/topic.rb
```

Set public to be true.

```
% rake db:migrate
==  CreateTopics: migrating ===================================================
-- create_table(:topics)
   -> 0.0258s
==  CreateTopics: migrated (0.0264s) ==========================================
```

### Create the controller

```
% rails g controller topics index new show edit
      create  app/controllers/topics_controller.rb
       route  get "topics/edit"
       route  get "topics/show"
       route  get "topics/new"
       route  get "topics/index"
      invoke  erb
      create    app/views/topics
      create    app/views/topics/index.html.erb
      create    app/views/topics/new.html.erb
      create    app/views/topics/show.html.erb
      create    app/views/topics/edit.html.erb
      invoke  helper
      create    app/helpers/topics_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/topics.js.coffee
      invoke    scss
      create      app/assets/stylesheets/topics.css.scss
```

Update routes.

```
  resources :topics
```

* Update the controller.
* Update the index view
* Update the new view (similar to posts)
* Update the edit view
* Update the show view

```
<h1><%= @topic.name %></h1>
<p class="lead"><%= @topic.description %></p>

... posts will go here ...
```

* Add link to the application layout (note for Mike: I'm also fixing the other paths)

At this point you should be able to create new topics and see them.

## Lock creation for just admins

Alright back to CanCan. We want to limit the editing and creation of topics to just admins. Add a similar lock like we did with creating a new post.

```
<% if can? :create, Topic %>
  <%= link_to "New Topic", new_topic_path, class: 'btn btn-primary btn-mini' %>
<% end %>
```

Now you can't see it. In our "models/abilities.rb" we already have it set so the admin can manage any model. So let's change our user's permission.

> Note to Mike, I forgot a colon on line 15 of abilities.rb last time (for destroy).

```
% rails c
Loading development environment (Rails 3.2.12)
>> u = User.first
  User Load (0.3ms)  SELECT "users".* FROM "users" LIMIT 1
=> #<User id: 1, name: "Jayden Wintheiser I", email: "ryanjm@bloc.io", encrypted_password: "$2a$10$GWSOyl1o1rSMzJfNM.OmP.w/BdAZq9kDtg6mZqGXK14t...", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2013-05-02 22:04:52", last_sign_in_at: "2013-05-02 22:04:52", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", confirmation_token: nil, confirmed_at: "2013-05-02 22:04:38", confirmation_sent_at: "2013-05-02 22:04:33", unconfirmed_email: nil, created_at: "2013-05-02 22:04:22", updated_at: "2013-05-02 22:04:52", role: "member">
>> u.update_attribute(:role, 'admin')
   (0.1ms)  begin transaction
   (0.6ms)  UPDATE "users" SET "role" = 'admin', "updated_at" = '2013-05-03 20:27:43.090914' WHERE "users"."id" = 1
   (1.1ms)  commit transaction
=> true
```

Great! That's it.

## Nest Posts

### Add migration

The goal is to have posts under a given topic. Add another migration to add `topic_id` to posts.

```
% rails g migration AddTopicToPosts topic_id:integer
      invoke  active_record
      create    db/migrate/20130503203021_add_topic_to_posts.rb
% rake db:migrate
```

Now add the relationships to the models. And add `:topic` to `attr_accessible`.

### Update the seed

None of the posts in the database currently have a topic, so you'll want to modify the seed file. You'll create a few topics first, and then add we create posts, we'll assign them to a new topic.

```
topics = []
15.times do
  topics << Topic.create(
    name: Faker::Lorem.words(rand(1..10)).join(" "), 
    description: Faker::Lorem.paragraph(rand(1..4))
  )
end
```

Then when before we create a new post, we'll grab the first topic.

```
topic = topics.first
```

Then when you are done creating the post, then rotate topics (move the first to the last).

```
topics.rotate!
```

While you are changing the seed file, add three users so that you have an easy way to sign in to test the different user permissions.


```
u = User.new(
  name: 'Admin User',
  email: 'admin@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com', 
  password: 'helloworld', 
  password_confirmation: 'helloworld')
u.skip_confirmation!
u.save
```

### Change views

Now time to change the views.

* Nest the posts in the routes

```
  resources :topics do
    resources :posts
  end
```

```
             topic_posts GET    /topics/:topic_id/posts(.:format)          posts#index
                         POST   /topics/:topic_id/posts(.:format)          posts#create
          new_topic_post GET    /topics/:topic_id/posts/new(.:format)      posts#new
         edit_topic_post GET    /topics/:topic_id/posts/:id/edit(.:format) posts#edit
              topic_post GET    /topics/:topic_id/posts/:id(.:format)      posts#show
                         PUT    /topics/:topic_id/posts/:id(.:format)      posts#update
                         DELETE /topics/:topic_id/posts/:id(.:format)      posts#destroy
```

* Remove posts from layout
* Add to topics show

Use the layout from posts#index for most of it. Need to touch on nested routing paths. Here in the index and on the show page for the edit button.

Also need to talk about setting @topic in the post controller

* Remove index

Moved the "New Post" link to topics index. Also added an exclude to the resource.

* Modify create

Need to modify create so that it sets the `topic`. Additionally the rediret for `create` and `update` both need to be modified. Along with the forms for each.

> Note for Mike: In the next section I'll go back and do a before filter and partials for those.
