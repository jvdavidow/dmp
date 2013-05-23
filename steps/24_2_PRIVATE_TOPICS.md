# Private Topics

Alright, so we have a boolean on topics. Let's use it.

* If you aren't logged in, you shouldn't see private topics
* If you aren't logged in, you shouldn't be able to go to a private topic url

## Limit private topics

We'll add a simple [scope](http://guides.rubyonrails.org/active_record_querying.html#scopes) to the topic model.

We could do something basic like:

```ruby
  scope :public, where(public: true)
```

But this would require an if statement in the controller. Instead we'll make the scope take an argument and move the if statement to the scope.

```ruby
  scope :public, lambda { |user| user ? scoped : where(public: true) }
```

You might need to go into the console and make a topic private.

```ruby
>> Topic.first.update_attribute(:public, false)
```

While in there you can also test out the scope.

```ruby
>> Topic.public(nil).count
>> Topic.public(User.first).count
```

> Note to Mike: Also need to add this scope to the `post_controller` (which is added in lesson 28). :)

## Authorization

As it is, nothing changes you from manually entering in a url that you shouldn't have access to. For example, in the console find the `id` of the non-public post you created.

```ruby
>> Topic.where(public: false).first.id
=> 1
```

Then you can go to that url: `http://bloccit.dev/topics/1`.

Time to authorize the user.

All we have to do is add an ability to the bottom of the `ability.rb` file:

```ruby
    cannot :read, Topic, public: false
```

Then just check it in topic/show.

```ruby
    authorize! :read, @topic, message: "You need to be user to do that."
```

And in the topics/posts_controller.rb:

```ruby
  def show
    @topic = Topic.find(params[:topic_id])
    authorize! :read, @topic, message: "You need to be user to do that."
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end
```
