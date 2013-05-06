# Validations

Add validations to posts.

## What are validations?

...

## Adding validations to Posts

The validations you are going to put on Posts are:

- must have at least 20 characters in the body
- must have at least 5 characters in the title
- must have a topic and user

[Guides](http://guides.rubyonrails.org/active_record_validations_callbacks.html)

There are numerous types of validations. The most common are presense, length, and format. Formatting usually requires a regex which is talked about in the Library if you want to learn more.

* Added validations to `post.rb`

```
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true
```

* Looked at validations in the console:

```
>> p = Post.new
=> #<Post id: nil, title: nil, body: nil, created_at: nil, updated_at: nil, user_id: nil, topic_id: nil>
>> p.valid?
=> false
>> p.errors
=> #<ActiveModel::Errors:0x007fad729366c0 @base=#<Post id: nil, title: nil, body: nil, created_at: nil, updated_at: nil, user_id: nil, topic_id: nil>, @messages={:title=>["is too short (minimum is 5 characters)", "can't be blank"], :body=>["is too short (minimum is 20 characters)", "can't be blank"], :topic=>["can't be blank"], :user=>["can't be blank"]}>
>> p.errors.full_messages
=> ["Title is too short (minimum is 5 characters)", "Title can't be blank", "Body is too short (minimum is 20 characters)", "Body can't be blank", "Topic can't be blank", "User can't be blank"]
>> p.errors[:title]
=> ["is too short (minimum is 5 characters)", "can't be blank"]
```

* Moved the form to a partial
* Fixed html (Note to Mike: I used `span-6` when it should have been `span6`. Might need to fix that in previous lessons).
* Added `alert-block` div to the front of the form
* Added an application helper

Since:

```
<div class="control-group <%= 'error' if post.errors[:title].any? %>">
```

Is not clean and is not the "Rails way", I created an application helper to extract this logic. This would be a good point to mention alternatives to building these forms (simple form) and reference it in the Library. For now I think this is good practice of using an application helper.

* Added the layout (partial) to the edit page
