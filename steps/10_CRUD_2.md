# More CRUD

Added form to new.

Started out with:

```erb
<%= form_for @post do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %><br/>
  <%= f.label :body %>
  <%= f.text_area :body %>
  <%= f.submit "Save" %>
<% end %>
```

> Show how to duplicate lines when doing label/text_field.

Just to show the basics. Then style it.

Submit form, got `Unknown action`. Need to add create. 


Added, and then reloaded the page for the request to be submitted again. Went through and went to show page. (Not sure if my error handling is correct yet, but we'll check that laer.

Take a look at the Rails log (in terminal):


```
Started POST "/posts" for 127.0.0.1 at 2013-04-23 16:54:46 -0600
Processing by PostsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"Q+hcn3ONwHeG3igPjeWwNGexPVO8rSZ0uZDIR3GCpYk=", "post"=>{"title"=>"This is my great title", "body"=>"What do we want this to be about?"}, "commit"=>"Save"}
   (3.0ms)  begin transaction
  SQL (2170.1ms)  INSERT INTO "posts" ("body", "created_at", "title", "updated_at") VALUES (?, ?, ?, ?)  [["body", "What do we want this to be about?"], ["created_at", Tue, 23 Apr 2013 22:54:46 UTC +00:00], ["title", "This is my great title"], ["updated_at", Tue, 23 Apr 2013 22:54:46 UTC +00:00]]
   (186.5ms)  commit transaction
Redirected to http://0.0.0.0:3000/posts/40
Completed 302 Found in 2517ms (ActiveRecord: 2360.2ms)
```

(Have to look at the log after you've written the message since the fail of no create action means that the params don't show up).

```ruby
  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to @post
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end
```

Now doing edit controller, view, then update.

Copyed the view from edit. Change the title. We'll refactor later.

Submitted form, got `Unknown action`. Added the update. Reloaded and it updated.

```
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was updated."
      redirect_to @post
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end
```

Flash message didn't show, so added that to the application layout.

```
    <% if flash[:notice] %>
      <div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <%= flash[:notice] %>
      </div>
    <% elsif flash[:error] %>
      <div class="alert alert-error">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <%= flash[:error] %>
      </div>
    <% end %>
```

Deploy to heroku

```
% git add .
% git commit -m "Added new/create/edit/update"
% git push heroku master
% heroku run rake db:migrate
```

You will get a depreciation warning:

```
DEPRECATION WARNING: You have Rails 2.3-style plugins in vendor/plugins! Support for these plugins will be removed in Rails 4.0. Move them out and bundle them in your Gemfile, or fold them in to your app as lib/myplugin/* and config/initializers/myplugin.rb. See the release notes for more on this: http://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released. (called from <top (required)> at /app/Rakefile:7)
```

Don't worry about it. This is just in preperation for Rails 4. (Might look into best practice about this. Might remove the `vendor` folder).
