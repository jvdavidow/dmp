# Popular posts

Last feature.

* List popular posts
* List people (Mike, you might want to move this to the profile checkpoint, your choice)
* Improve Quries

## Popular posts

In order to have `/posts` work for us we need to move our current post controller underneath topics. Along with the views.

```
app/controllers/posts_controller.rb -> app/controllers/topics/posts_controller.rb
app/views/posts/edit.html.erb -> app/views/topics/posts/edit.html.erb
app/views/posts/new.html.erb -> app/views/topics/posts/new.html.erb
app/views/posts/show.html.erb -> app/views/topics/posts/show.html.erb
```

This means we need to adjust the routes.rb to let it know where to find the new controller and to update the view so the render knows where to find the comments.

Now we can add a new controller and add an index page.

Don't move the `_post` partial since it is referenced elsewhere.

```
% rails g controller posts index
      create  app/controllers/posts_controller.rb
       route  get "posts/index"
      invoke  erb
       exist    app/views/posts
      create    app/views/posts/index.html.erb
      invoke  helper
   identical    app/helpers/posts_helper.rb
      invoke  assets
      invoke    coffee
   identical      app/assets/javascripts/posts.js.coffee
      invoke    scss
    conflict      app/assets/stylesheets/posts.css.scss
    Overwrite /Users/ryanjm/code/bloc/bloc_reddit/app/assets/stylesheets/posts.css.scss? (enter "h" for help) [Ynaqdh] n
        skip      app/assets/stylesheets/posts.css.scss
```

Have it skip overwritting the posts scss. We don't need either.

Add the controller and view (based it off of topic/show).

Add to routes

```ruby
  resources :posts, only: [:index]
```

Add link to the applicaiton layout.

## People

Add index to users_controller

Crazy sql statement to show that you can learn more about SQL. :)

## Improve queries

When you have pow and want to watch the log of the server do the following:

```
tail -f log/development.log
```

Then reload a page and watch the log scroll by.

> Note to mike: just had to add "can? :create, Vote" around _voter.html.erb. Needs to be put in previous lesson.

Go to the topic show page. You'll need to scroll up, but look for this part:

```
Started GET "/topics/1" for 127.0.0.1 at 2013-05-10 17:37:39 -0600
Processing by TopicsController#show as HTML
  Parameters: {"id"=>"1"}
  Topic Load (0.4ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = $1 LIMIT 1  [["id", "1"]]
  Post Load (0.6ms)  SELECT "posts".* FROM "posts" WHERE "posts"."topic_id" = 1 ORDER BY rank DESC LIMIT 10 OFFSET 0
  Topic Load (0.6ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (227.0ms)
  User Load (0.7ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 6 LIMIT 1
   (0.6ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 46
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.2ms)
  User Load (2.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 4 LIMIT 1
   (0.6ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 31
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
  User Load (0.7ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 2 LIMIT 1
   (0.6ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 16
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
  User Load (1.4ms)  SELECT "users".* FROM "users" WHERE "users"."id" = 1 LIMIT 1
   (0.5ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 1
  Rendered posts/_post.html.erb (294.9ms)
  Rendered topics/show.html.erb within layouts/application (319.4ms)
Completed 200 OK in 418ms (Views: 336.7ms | ActiveRecord: 27.9ms)
```

First this tells us what url is being called. Then what controller#action.

But then look at all the queries it is doing. If there are most topics on the page that will only go up. Let's see if we can improve that. We need to include the user and comments count with that inital query.

If we include user

```
  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.includes(:user).paginate(page: params[:page], per_page: 10)
  end
```

```
Started GET "/topics/1" for 127.0.0.1 at 2013-05-10 17:46:36 -0600
Processing by TopicsController#show as HTML
  Parameters: {"id"=>"1"}
  Topic Load (0.5ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = $1 LIMIT 1  [["id", "1"]]
  Post Load (2.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."topic_id" = 1 ORDER BY rank DESC LIMIT 10 OFFSET 0
  User Load (0.8ms)  SELECT "users".* FROM "users" WHERE "users"."id" IN (6, 4, 2, 1)
  Topic Load (2.7ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (1.2ms)
   (2.7ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 46
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
   (1.7ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 31
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
   (1.3ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 16
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
   (0.9ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 1
  Rendered posts/_post.html.erb (313.2ms)
  Rendered topics/show.html.erb within layouts/application (756.2ms)
Completed 200 OK in 933ms (Views: 915.2ms | ActiveRecord: 13.0ms)
```

(might need to referesh one more time if you get a query explination)

Notice our time with ActiveRecord when from 27.9ms to 13.0ms.

These times won't be constant. They will vary based on whatever your computer is doing any given millisecond.

By adding comments we can improve it just a little more.

```
  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.includes(:user).includes(:comments).paginate(page: params[:page], per_page: 10)
  end
```

```
Started GET "/topics/1" for 127.0.0.1 at 2013-05-10 17:50:22 -0600
Processing by TopicsController#show as HTML
  Parameters: {"id"=>"1"}
  Topic Load (0.5ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = $1 LIMIT 1  [["id", "1"]]
  Post Load (0.7ms)  SELECT "posts".* FROM "posts" WHERE "posts"."topic_id" = 1 ORDER BY rank DESC LIMIT 10 OFFSET 0
  User Load (1.6ms)  SELECT "users".* FROM "users" WHERE "users"."id" IN (6, 4, 2, 1)
  Comment Load (0.7ms)  SELECT "comments".* FROM "comments" WHERE "comments"."post_id" IN (46, 31, 16, 1)
  Topic Load (2.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.8ms)
   (0.7ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 46
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
   (0.6ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 31
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
   (1.3ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 16
  CACHE (0.0ms)  SELECT "topics".* FROM "topics" WHERE "topics"."id" = 1 LIMIT 1
  Rendered votes/_voter.html.erb (0.1ms)
   (0.9ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 1
  Rendered posts/_post.html.erb (49.4ms)
  Rendered topics/show.html.erb within layouts/application (62.4ms)
Completed 200 OK in 88ms (Views: 76.7ms | ActiveRecord: 8.9ms)
```

Now in the case above 30ms is actually pretty fast to begin with. You shouldn't worry too much about optimizing your queries until they are noticible to the end user (~1 second). But it is good to know that you can optimize it.
