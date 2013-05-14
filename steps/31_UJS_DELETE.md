# Deleting a comment

AJAX is ....

Rails makes this easy. UJS stands for...

## Render

The most complicated part about this process is reworking the controller.

I'll let you explain it. :)

```
  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])
    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    if @comment.destroy
      respond_with do |f|
        f.html do
          flash[:notice] = "Comment was removed."
          redirect_to [@topic, @post]
        end
        f.js { render :destroy }
      end
    else
      respond_with do |f|
        f.html do
          flash[:error] = "Comment couldn't be deleted. Try again."
          redirect_to [@topic, @post]
        end
        f.js { render :destroy }
      end
    end
```

Create a `destroy.js.erb` file:


```
$('#comment-' +<%= @comment.id %>).hide();
```

You already have the id setup for the comment `div`. You just need to tell Rails to make the call use ajax.

```erb
<%= link_to "Delete", [topic, post, comment], method: :delete, remote: true %>
```

Try it out. In the off case that something fails you could fail silently (like does right now) or put a conditional in the view to handle that.

```
<% if @comment.destroyed? %>
  $('#comment-' +<%= @comment.id %>).hide();
<% else %>
  $('#comment-' +<%= @comment.id %>).prepend("<div class='alert alert-error'>Unable to delete post.</div>");
<% end %>
```

To test it out just change the `if` statement (make sure to change it back.

```
    if false #@comment.destroy
```

If you've deleted a few, you'll notice the count isn't actually correct. This might not be a big deal, but fixing it is easy. In the posts/show change the comments line to:

```erb
    <h2 class='js-comments-count'><%= @comments.count %> Comments</h2>
```

Update your destroy.js.erb

```js
<% if @comment.destroyed? %>
  $('#comment-' +<%= @comment.id %>).hide();
  $('.js-comments-count').html("<%= @post.comments.count %> Comments");
<% else %>
  $('#comment-' +<%= @comment.id %>).prepend("<div class='alert alert-error'>Unable to delete post.</div>");
<% end %>
```

That's it.
