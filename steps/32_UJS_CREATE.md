# UJS Create

Deleting a comment was easy enough, time to dynamically add one.

Modify the controller just like delete.

Create `create.js.erb`.

Modify `posts/show`, you'll need a way to append new comments:

```
    <div class="js-comments">
      <h2 class='js-comments-count'><%= @comments.count %> Comments</h2>
      
      <%= render partial: 'comments/comment', collection: @comments %>
    </div>
```

> Tip: when working with ajax it is _really_ important to be looking at the log when you run into errors. They will be very helpful. (reminder: `% tail -f log/development.rb`). Additionally you can check out the "Network" tab and click on the ajax call.

Make the `comments/_form` use ajax.

Should break this up into parts. Just add comment / show the form. Then show that the comment form isn't cleared, so do that. And then just like destroy, update the count.

```
<% if @comment.valid? %>
  $(".js-comments").append("<%= escape_javascript(render(@comment)) %>");
  $(".new_comment").replaceWith("<%= escape_javascript(render partial: 'comments/form', locals: { topic: @topic, post: @post, comment: Comment.new }) %>");
  $('.js-comments-count').html("<%= @post.comments.count %> Comments");
<% else %>
  $(".new_comment").replaceWith("<%= escape_javascript(render partial: 'comments/form', locals: { topic: @topic, post: @post, comment: @comment }) %>");
<% end %>
```

One more reason why partials are helpful!
