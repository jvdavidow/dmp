# Admin section

Goal: add CanCan and lock off ability to manage posts.

Authentication vs authorization. [CanCan](https://github.com/ryanb/cancan) is for the later.

Add Gem to Gemfile.

```
% bundle
```

```
% rails g cancan:ability
```

## Add Roles to User

Before we can limit a user, we need to know which users _can_ access links. We are going to add roles for the following:

* admin - super user who has access to modify permissions on other users and everything below
* mod - will be able to delete anyone's posts
* member - will be able to create posts and can comment
* banned - can not edit
* guest - can just read anything on the site (someone who hasn't signed up)

We'll use [Role Inheritance](https://github.com/ryanb/cancan/wiki/Role-Based-Authorization). This will let us create an array with the above roles.

```
% rails g migration AddRoleToUsers role:string
      invoke  active_record
      create    db/migrate/20130502202355_add_role_to_users.rb
```

Now we can migrate the db.

```
% rake db:migrate        
==  AddRoleToUsers: migrating =================================================
-- add_column(:users, :role, :string)
   -> 0.0013s
==  AddRoleToUsers: migrated (0.0014s) ========================================
```

## Limiting Posts

To try out CanCan, let's limit the ability to go to the `posts/new` url and to see the "New Post" link.

Add the following as the last line in the "new" action under "posts_controller":

```
authorize! :create, Post
```

Start up your server (`rails s`) and try to go to this page.

You should see "CanCan::AccessDenied in PostsController#new". This obviously isn't very user friendly, so let's catch CanCan's error and redirect the user. You can see this under step 3 "Handling Unauthroized Access" in the Readme.

Add this to the application_controller.rb

```
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
```

This requires that we have a `flash[:alert]` in our layout so let's add that.

```
 <% elsif flash[:alert] %>
        <div class="alert">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <%= flash[:alert] %>
        </div>
```

Now try to reload that "/posts/new" page. You should now be redirected to the home page and see "You are not authorized to access this page." This is better, but we'd like to make the message a little more meaningful.

Change the authroize line in the posts_controller.rb to this:

```
authorize! :create, Post, message: "You need to be a member to create a new post."
```

Now when you try you get a much better message. Great.

## Adding a new post

We want only members and above to be able to create a post.

> Note for Mike: when I changed the layout I forgot to make the "new" link viewable since I had it in a `content_for`. But when they do it, it should be viewable. So this will just cover making it only accessable for the right people.

We'll use a similar `CanCan` method as before. Modify the "new" link on the posts/index page:

```
<% if can? :create, Post %>
  <%= link_to "New Post", new_post_path, class: 'btn btn-primary btn-mini' %>
<% end %>
```

Now when you go to the page you shouldn't see it.

## Define Abilities

Alright now we'll work with the `app/models/ability.rb` file that was created earlier.

The initialize method will take a user and we'll check it for various attributes and say what they [can do](https://github.com/ryanb/cancan/wiki/defining-abilities).

```
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    # if a member, the can manage their own posts 
    # (or create new ones)
    if user.role? :member
      can :manage, Post, :user_id => user.id
    end

    # Moderators can delete any post
    if user.role? :moderator
      can destroy, Post
    end

    # Admins can do anything
    if user.role? :admin
      can :manage, :all
    end

    can :read, :all

  end
end
```

In order for this to work we need to add a method to the User model

```
  ROLES = %w[member moderator admin]
  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
```

Notice that for boolean attributes Rails automatically gives us methods with the ? on them. Convention over configuration.

Before we can make this work you need to make yourself have `member` abilities. Open up the rails console (`rails c`) and update yourself.

```
>> u = User.first
>> u.update_attribute(:role, 'member')
```

Now when you login you should be able to see the "New Post" link and be able to create a new post.

# New member

We want to automatically assign "member" to a new user. So let's add a before filter on the user model.

```
before_create :set_member

def set_member
  self.role = 'member'
end
```

We can test this out by resetting the database. When the seed file runs everyone should become a member by default.

```
% rake db:reset
```

Then sign in again.

We'll handle the other permissions later.

## Your challenge

Add the right authorization in the post controller for the eidt and update actions.

> Note for Mike: I had to do this one twice. I had started to do the authorization one way and ended up changing it. I've checked everything 2 or 3 times so it should be correct, but it will be good to have other mentors go through the tutorial later to verify all the steps make sense. I was going to add topics as a part of this but but decided it was long enough as is. I'll add topics next.
