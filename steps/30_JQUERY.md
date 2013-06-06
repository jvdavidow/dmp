# JQuery

JQuery is ...

Before diving into jQuery, check out `console.log`. It is basically the `puts` for JavaScript.

Open `application.js` (`app/assets/javascript`) and add this to the bottom of the file:

```
console.log("hello world");
```

Notice the semi-colon. In JavaScript almost every line will end with a semi-colon.

Now when you reload your page check out the Developer Tools (right click on the page and click "inspect element") then click the tab that says "Console".

You should see "hello world" there.

Alright, time to do something more interesting. jQuery has a selector method that use CSS attributes (this will look a little forign compared to JS so hang in there):

```
$(".my-class")
```

Memorize that. You'll be using it a _lot_. jQuery makes some common actions _really_ easy. Replease your `console.log` line with this:


```
$(".hero-unit").slideUp();
```

Now reload your home page.

Nothing? That's because the jQuery wasn't loaded before that line was run. You have to wrap jQuery commands in a document.ready line like this:


```js
$(document).ready(function() {
  $(".hero-unit").slideUp();
});
```

Now try it. Cool? "One" line if JS and we get a really nice animation. But that obviously isn't what we want. Let's put that in a more useful place.

Open up `posts/show.html.erb` and change the comment section to look like this:

```
    <% if can? :create, Comment %>
      <hr/>
      
      <a href="#" class="js-add-comment">Add Comment</a>
      <br/>
      <div class="js-new-comment hide">
        <h4>New Comment</h4>
        <%= render partial: 'comments/form', locals: { topic: @topic, post: @post, comment: @comment } %>
      </div>
    <% end %>
```

It is a great convention to add `js-` to the beginning of classes you'll use in javascript.

Now change the application.js to look like this.

```js
$(document).ready(function() {
  $(".js-add-comment").click(function() {
    $(".js-new-comment").slideDown();
    return false;
  });
});
```

talk about call backs (`.click`) and the structure of functions.

And add this to your application.css.scss:

```
.hide {
  display: none;
}
```

Check out the page now. This animation would obviously be nicer if we had a footer so the page doesn't extend beyond the bottom (if you are in a post with comments already).

Now we have the Add Comment button showing. If we wanted to remove it from the page we could add this right before the `return false`:

```js
$(this).hide();
```

`this` in JS is much like `self` in Ruby.

But what if we want to show/hide. You could change it to:

```js
  $(".js-add-comment").click(function() {
    if ($(".js-new-comment").is(":visible")) {
      $(".js-new-comment").slideUp();
    }
    else {
      $(".js-new-comment").slideDown();
    }
    return false;
  });
```

What happens if we want to show/hide all the comments? Or some other elements in on the site. The code wouldn't be very DRY if we copied and pasted this method for every combination of button/area. 

Thankfully there is something called the `data-*` attribute. It let's us add arbitration arguments to an html element which we can then use in JS.

If you change the anchor tag to this:

```
      <a href="#" class="js-show-hide" data-selector="js-new-comment">Add Comment</a>
```

Then you can create a generic method to be used multiple times:

```
  $(".js-show-hide").click(function() {
    var selector = "." + $(this).attr('data-selector');
    if ($(selector).is(":visible")) {
      $(selector).slideUp();
    }
    else {
      $(selector).slideDown();
    }
    return false;
  });
```

jQuery is a great tool to do many things in JavaScript. Check out the [jQuery](http://jquery.com/) website and poke around to see what it can do.

> Note to Mike: anything else you want me to cover with jQuery? Might be helpful to give them 3 or 4 other methods to check out themselves??
