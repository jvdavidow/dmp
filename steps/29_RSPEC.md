# RSpec

> Note for Mike: just noticed I forgot to take off the `unless` on comment.rb line 19. Hopefully you noticed it. :) Should be taken out when refactored.

* Test vote methods (easiest)
* Test User query
* Factories
* Guard

> Note to Mike: I changed the `top_rated` query in user.rb. The testing showed that it wasn't working as I expected. It still isn't perfect, but good enough.

> Note to Mike: This might be worth breaking into two lessons. I didn't test as much as I wanted to, but it does cover all the basis (I think. See anything I'm missing?). Let me know if you want me to add anything.

## RSpec Setup

Add to gemfile

```ruby
group :development, :test do
  gem 'rspec-rails'
end
```

Install

```
% rails generate rspec:install
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
```

> Tip: Do this at the beginning of your project and RSpec will add files for you as you generate your models.

Your tests run in their own database (which gets cleared between tests). We need to set this db up.

```
% rake db:test:prepare
```

## First RSpec test

Create a folder under `spec` called `models`. Add a file named `vote_spec.rb`. This is where our `Vote` model tests will be locaed.

The first thing you need in this file is the `spec_helper` which was created by `rspec:install`.

```ruby
require 'spec_helper'
```

Then just like you saw in the beginning of the course, we'll describe the class, then the method, then describe what the class should do with `it` tests.

```ruby
describe Vote do
  describe "#up_vote?" do
    it "returns true for an up vote" do
      v = Vote.new(value: 1)
      v.up_vote?.should be(true)
    end
  end
end
```

First thing to notice is that `up_vote?` has a pound sign in front of it. This is a way of letting the reader (yourself 12 months for now) know that this is an instance method. This related to an `id` in CSS. We will use a period to represent a class method, just like css where class are described with a period.

We are doing the _minimum_ amount of work in order to test this method. In this case we do not need to save Vote to the database (`create`) so it only uses `new` (additionally, had we used `create` it would have failed on the `update_post` callback becuase there isn't a Post.

Run the test.

```
% rspec spec
```

RSpec has a few different ways of doing expectations. Check out the [documentation](https://www.relishapp.com/rspec/rspec-expectations/v/2-13/docs/built-in-matchers) for some variations. This test can be improved by using `be_true` instead of `be(true)`.

When testing you should test all cases of a method, both positive and negative. You now know enough to write tests for the `down_vote?` method. Try that before reading the code below:

```ruby
require 'spec_helper'

describe Vote do
  
  describe "#up_vote?" do
    it "returns true for an up vote" do
      v = Vote.new(value: 1)
      v.up_vote?.should be_true
    end
    it "returns false for a down vote" do
      v = Vote.new(value: -1)
      v.up_vote?.should be_false
    end
  end

  describe "#down_vote?" do
    it "returns true for a down vote" do
      v = Vote.new(value: -1)
      v.down_vote?.should be_true
    end
    it "returns false for an up vote" do
      v = Vote.new(value: 1)
      v.down_vote?.should be_false
    end
  end

end
```

Run the tests again:

```
% rspec spec
```

## Guard

Running the tests yourself can be annoying. You are using a computer that can do the work for you. Check out [Guard](https://github.com/guard/guard). Guard is a gem that will watch your files for any changes and perform some task for you based on that. In this case you'll have guard run RSpec.

Also add [guard-rspec](https://github.com/guard/guard-rspec).

```
  gem 'guard'
  gem 'guard-rspec'
```

```
% bundle
% guard init  
09:55:19 - INFO - Writing new Guardfile to /Users/ryanjm/code/bloc/bloc_reddit/Guardfile
09:55:19 - INFO - rspec guard added to Guardfile, feel free to edit it
```

Now run guard:

```
% guard
```

This will keep track of your spec files and run rspec whenever you save a new version.

## Mocks

Your `vote_spec` is almost complete. There is still one method that needs to be tested, `update_post`. Since `update_post` relies on `update_rank` in the `post` model, you just need to verify that method gets called in the `update_rank` (and that `Post` responds to `update_rank` so you catch if the method name changes).

Mocks allow you to intercept a method call and return your own. Check out the documentation about [mocks](http://rubydoc.info/gems/rspec-mocks/frames). Check out the sudo code for what we want to be doing:

```ruby
describe "#update_post" do
  it "should call update_rank on it's post"
    create a post
    create a vote object and save it
    make sure post's `update_rank` method is called
  end
end
```

You can't check that a method was called after the fact so you have to move that line ahead.

```ruby
  describe "#update_post" do
    it "calls `update_rank` on post" do
      post = Post.new
      post.save(validate: false)
      post.should_receive(:update_rank)
      Vote.create(value: 1, post: post)
    end
  end
```

You'll get a failure:

```ruby
  1) Vote#update_post calls `update_rank` on post
     Failure/Error: post.save(validate: false)
     NoMethodError:
       undefined method `votes' for nil:NilClass
```

This is because of Post's own callbacks. We can skip those with this:

```ruby
  describe "#update_post" do
    it "calls `update_rank` on post" do
      Post.skip_callback(:create,:after,:create_vote)
      post = Post.new
      post.save(validate: false)
      post.should_receive(:update_rank)
      Vote.create(value: 1, post: post)
      Post.set_callback(:create, :after, :create_vote)
    end
  end
```

This will pass. But there is a lot of code in there that is just setup for creating a Post. This is the Vote spec. Let's look at how to improve that.

## Factory

Add to gemfile. Bundle.

Create folder `spec/factories`.

Check out [Getting Started](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md).

Create a `support` folder and put `devise.rb` and `factory_girl.rb` in there.

... show files.

In order to properly create a Post, you need to have a User and a Topic.

Add `user.rb` to factories folder. Then we can create a Factory, which will create an instance of a model. We want to provide the minimum number of arguments.

```
FactoryGirl.define do
  factory :user do
    name "Douglas Adams"
    email "douglas@example.com"
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
  end
end
```

Add `topic.rb` to factories.


```
...
```


Also add a `post.rb` factory:

```ruby
FactoryGirl.define do
  factory :post do
    title "First Post"
    body "This is the newest post. It needs 20 char to be saved."
    user
    topic
  end
end
```

FactoryGirl lets you easily create relationships just by naming the factory (`user` and `topic`).

Now you can rewrite the RSpec:

```ruby
  describe "#update_post" do
    it "calls `update_rank` on post" do
      post = create(:post)
      post.should_receive(:update_rank)
      Vote.create(value: 1, post: post)
    end
  end
```

Much cleaner. The last thing you want to do is verify that the `update_rank` method exists for `post`, otherwise at some point in the future if you change the name of the method this test wouldn't fail because you are overwritting the method.

```ruby
  describe "#update_post" do
    it "calls `update_rank` on post" do
      post = create(:post)
      post.should respond_to(:update_rank)
      post.should_receive(:update_rank)
      Vote.create(value: 1, post: post)
    end
  end
```

## Testing User

> Note to mike: just fixed something in the `comments_controller.rb`:

```
      render 'topics/posts/show'
```

When dealing with multiple instances of a class or trying to grab all instances of a class (as with `top_rated`) it is important to make sure the database is properly clearned between tests. We'll use `database_cleaner` for that.

Add to Gemfile. Bundle. Add `spec/support/database_cleaner.rb`. Comment out the following line in `spec_helper.rb`:

```
  # config.use_transactional_fixtures = true
```

Since you will be creating multiple users you need to change the factory.

```
...
```


If you ever get the following error, just run the tests again. Factory is using a random number for the email and sometimes it claches. 

```
  1) User.top_rated should return users based on comments + posts
     Failure/Error: @u0 = create(:user) do |user|
     ActiveRecord::RecordInvalid:
       Validation failed: Email has already been taken
```

Now add `user.rb` to the `spec/models` directory. Before getting to the code here are a few helpful concepts.

```
before :each do
  ...
end
```

This block will run before each test. This is a great way to setup variables for your tests and keep things DRY. You'll need to use instance variables in order to make the variable avalible though.

```
attributes_for(:post)
```

This is a FactoryGirl method (learn more in the [Getting Started](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md) documentation). It will return a hash of the arguments for your model so you can use it in a `create` method. It _does not_ include relationships. You'll want to use this because when you do `User.top_rated` you'll get back all users that were created, we don't want to create extra users in the database or else we won't be able to test for proper order.

```ruby
@u0 = create(:user) do |user|
  post = user.posts.build(attributes_for(:post))
  post.topic = topic
  post.save
  c = user.comments.build(attributes_for(:comment))
  c.post = post
  c.save
end
```

The FactoryGirl `create` method can take a block. It will pass in the created objet. We'll use this just to keep things tied together and create other related objects. Notice we are having to use `build` instead of create. This is so that we can make sure the validations pass.

Alright here it is put together:

```
... spec/models/users.rb
```

Play around with the test and see if you can find a way to break the expected behavior of the query. It isn't perfect, but it mostly works. What might be a better way? (Hint: how did you handle it with ordering posts?).
