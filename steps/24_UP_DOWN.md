# Up/Down Voting

Posts are only so useful. How are you supposed to find the best of the best? Time to impliment voting.

High overview:

* Need a vote model to hold a vote. It will tie a person to a post. It will have a value of +1 or -1.
* Add UI elements to be able to vote (can't vote more than once).
* Sort the posts for a given topic to be highest votes for the past 24 hours.

## Model

```
% rails g model vote value:integer user:references post:references 
      invoke  active_record
      create    db/migrate/20130509184756_create_votes.rb
      create    app/models/vote.rb
% rake db:migrate
==  CreateVotes: migrating ====================================================
-- create_table(:votes)
   -> 0.0812s
-- add_index(:votes, :user_id)
   -> 0.0011s
-- add_index(:votes, :post_id)
   -> 0.0008s
==  CreateVotes: migrated (0.0836s) ===========================================
```

Add `has_many` to posts and users (with dependent destroy). Add `:post` to `attr_accisble` for `vote` model. Also add a validation to the vote model (we don't expect to need it, but don't want the system rigged).

You want to be able to show how many votes a given post has gotten, both up and down, so you'll create two methods.

```
  def up_votes
    self.votes.where(value: 1).count
  end

  def down_votes
    self.votes.where(value: -1).count
  end
```

We also want a method to get the total votes (up + down). We could just use the methods above or we could get the sum of the votes.

``` 
  def points
    self.votes.sum(:value).to_i
  end
```

You can test this out in the console.

```
>> u = User.first
>> p = Post.first
>> u.votes.create(value: 1, post: p)
>> p.up_votes
```

## UI

Time to add the ability to up vote and down vote things in the view. In order to get the proper order:

```
(up arrow)
points
(down arrow)
```

You'll need three seperate divs. Additionally we want everything to work together so we'll put it all inside another div:

```
        <div class="vote-arrows pull-left">
          <div><%= link_to " ", '#', class: 'icon-chevron-up' %></div>
          <div><strong><%= post.points %></strong></div>
          <div><%= link_to " ", '#', class: 'icon-chevron-down' %></div>
        </div>
```

And then clean it up a little with css:

```
.vote-arrows {
  width: 40px;
  text-align: center;
}
```

Now you need a location for those links to go to. We could make this restful, but that would require us creating forms in the view in order to send what we want the value to be. But to keep things simple we'll break that and show you how to create arbitrary routes.

Add the two `match` lines to your rotues.rb file.

```
  resources :topics do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
      match '/up-vote', to: 'votes#up_vote', as: :up_vote
      match '/down-vote', to: 'votes#down_vote', as: :down_vote
    end
  end
```

Now when you do rake routes you'll see two new lines:

```
      topic_post_up_vote        /topics/:topic_id/posts/:post_id/up-vote(.:format)      votes#up_vote
    topic_post_down_vote        /topics/:topic_id/posts/:post_id/down-vote(.:format)    votes#down_vote
```

You can use these to update our view's links.

Now you need to create the controller `votes_controller.rb`. You can create the up_vote method like this:

```ruby
def up_vote
  # Just like other controllers, grab the parent objects
  @topic = Topic.find(params[:topic_id])
  @post = @topic.posts.find(params[:post_id])

  # Look for an existing vote by this person so we don't create multiple
  @vote = @post.votes.where(user_id: current_user.id).first

  if @vote # if it exists, update it
    @vote.update_attribute(:value, 1)
  else # create it
    @vote = current_user.votes.create(value: 1, post: @post)
  end
  redirect_to :back
end
```

This method will look almost identical for the `down_vote` method. You could just extract this into one method, but in order to show before_filters in the controller do this:

```
class VotesController < ApplicationController
  before_filter :setup

  ...

  private

  def setup
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @vote = @post.votes.where(user_id: current_user.id).first
  end
end
```

Before each action `setup` will be run. (FYI: you can limit that before filter to run for only some actions).

For the updating a vote part, we can extract that to it's own method also:

```ruby
  def update_vote(new_value)
    if @vote # if it exists, update it
      @vote.update_attribute(:value, new_value)
    else # create it
      @vote = current_user.votes.create(value: new_value, post: @post)
    end
  end
```

This means your actions turn into:

```ruby
  def up_vote
    update_vote(1)
    redirect_to :back
  end

  def down_vote
    update_vote(-1)
    redirect_to :back
  end
```

We also want to make sure a person is allowed to do this action so add `authorize` to the `setup` method:

```
  def setup
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    authorize! :create, Vote, message: "You need to be a user to do that."

    @vote = @post.votes.where(user_id: current_user.id).first
  end
```

And add it as a permission to `abilities.rb`.

```ruby
    if user.role? :member
      can :manage, Post, :user_id => user.id
      can :manage, Comment, :user_id => user.id
      can :create, Vote
    end
```

Now voting should work on the topic show page.

Make it a partial under a votes folder and add it to the post show (had to add some styling around the title for it to look right - probably needs to be back dates to previous lessons).

Add some stats to the right side.

## Sorting

```
% rails g migration AddRankToPosts rank:float
% rake db:migrate
```

Adding after_create filter to vote

Added after_create filter to post

> Note about the update_rank method. This is something teams of people can spend hours on. This is a very rutamentary pass at an exceptable algorithm. It is a float so you can try your hand at your own algorithm _later_. Try searching for hackernews or reddit ranking algorithms.

Changing default order

Added a call to update rank in the seed file

Reset database
