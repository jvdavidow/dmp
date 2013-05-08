# Pagination

`will_paginate` is a very popular gem for pagination. Check out the [github](https://github.com/mislav/will_paginate).

* Add to Gemfile (should explain the `~>` part)
* bundle
* Add pagination to topics_controller, topics/index, and topics/show

> Note: might increase the numbers in the seed file so you can see more pagination.

That's it! Alright, maybe not. It isn't styled very well. Bootstrap does have a pagination module that we can [use](http://twitter.github.io/bootstrap/components.html#pagination).

You could just use a [gem](https://github.com/nickpad/will_paginate-bootstrap) to do the styling for you, but that isn't fun. Dig in and find out how to customize `will_paginate` yourself.

If you go to the will_paginate [wiki](https://github.com/mislav/will_paginate/wiki) and click on "Pages" you'll see a link for [Link renderer](https://github.com/mislav/will_paginate/wiki/Link-renderer). This page let's you know that you'll need to overwrite the :renderer option and there is a snippet for setting the default renderer of will_paginate. It is just an ApplicationHelper so that it is run prior to the will_paginate's helper method. Notice it calls super, which means this method passes everything up the chain to will_paginate. Add this to your ApplicationHelper.

```
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => BootstrapLinkRenderer
    end
    super *[collection_or_options, options].compact
  end
```

Now we need to wirte `BootstrapLinkRenderer`. Let's create a new file in config/initializers.

The goal is to translate the will_paginate into this format:

```html
<div class="pagination">
  <ul>
    <li class="disabled"><a href="#">&laquo;</a></li>
    <li class="active"><a href="#">1</a></li>
    ...
  </ul>
</div>
```

It takes a little to digest this link renderer [code](https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/view_helpers/link_renderer.rb) but first just look at the method names avalible. `to_html` looks like it renders the final html string, `page_number` looks like it renders a given page number, `gap` must be for the case there are a _lot_ of results (would give you &hellip;), `previous_page` and `next_page` render links for the front and end of the pagination, and as you go further down you pick up some of the other things a `renderer` can do.

Let's first see what will_paginate does by default:

```html
<div class="pagination">
  <a class="previous_page" rel="prev start" href="#">&#8592; Previous</a> 
  <a rel="prev start" href="#">1</a> 
  <em class="current">2</em> 
  <span class="next_page disabled">Next &#8594;</span>
</div>
```

So the container (outside) looks good, you just need a `ul` to surround the anchor tags. The `html_contianer` class uses a `tag` method. If we look at that it looks to render a html tag, much like you've done with the `link_to` excercise. We can use this `tag` method to add our ul around the html.

```ruby
  def html_container(html)
    tag :div, tag(:ul, html), container_attributes
  end
```

Next up you need each page number inside a li. will_paginate's defualt `page_number` method will return a link unless it is the current page in which case it does just an `em`. For Bootstrap you always want an anchor tag. So use the default `will_paginate` method and adjust it.

```ruby
  def page_number(page)
    tag :li, 
      link(page, page, rel: rel_value(page)), 
      class: ('active' if page == current_page)
  end
```

For the prev/next tags we want to change the text to the symbols that bootstrap uses. The code they have is just fine for your use, we just want to change the label. The second line of the methods call `previous_or_next_page` and you can see that the second argument into that method is the text for the tag so just change that.

```ruby
  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, '&laquo;', 'previous_page')
  end
  
  def next_page
    num = @collection.current_page < total_pages && @collection.current_page + 1
    previous_or_next_page(num, '&raquo;', 'next_page')
  end
```

Now you need to adjust the `previous_or_next_page` method. You want to surround it with an li. From the method they have you can see that sometimes `page` is not set. Therefore you'll just set a default value using the `||` operator.


```ruby
  def previous_or_next_page(page, text, classname)
    tag :li, link(text, page || '#')
  end
```

The last thing is the gap. Bootstrap doesn't talk about this, but you basically want a disabled link. Use super to call will_paginate's gap method.


```ruby
  def gap
    tag :li, link(super, '#'), class: 'disabled'
  end
```

That's it.

This is what you should have in your `bootstrap_link_renderer.rb`:

...
