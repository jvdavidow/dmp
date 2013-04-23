# Console

```ruby
code/bloc/bloc_reddit[master*]% rails c
Loading development environment (Rails 3.2.12)
>> Post.create(title: "First Post", body: "This is the first post in our system")
   (0.1ms)  begin transaction
  SQL (456.7ms)  INSERT INTO "posts" ("body", "created_at", "title", "updated_at") VALUES (?, ?, ?, ?)  [["body", "This is the first post in our system"], ["created_at", Mon, 22 Apr 2013 22:53:03 UTC +00:00], ["title", "First Post"], ["updated_at", Mon, 22 Apr 2013 22:53:03 UTC +00:00]]
   (803.2ms)  commit transaction
=> #<Post id: 1, title: "First Post", body: "This is the first post in our system", created_at: "2013-04-22 22:53:03", updated_at: "2013-04-22 22:53:03">
>> p = _
=> #<Post id: 1, title: "First Post", body: "This is the first post in our system", created_at: "2013-04-22 22:53:03", updated_at: "2013-04-22 22:53:03">
>> p.comments.create(body: "First comment!")
   (0.1ms)  begin transaction
  SQL (25.3ms)  INSERT INTO "comments" ("body", "created_at", "post_id", "updated_at") VALUES (?, ?, ?, ?)  [["body", "First comment!"], ["created_at", Mon, 22 Apr 2013 22:54:36 UTC +00:00], ["post_id", 1], ["updated_at", Mon, 22 Apr 2013 22:54:36 UTC +00:00]]
   (8.0ms)  commit transaction
=> #<Comment id: 1, body: "First comment!", post_id: 1, created_at: "2013-04-22 22:54:36", updated_at: "2013-04-22 22:54:36">
>> p.comments
  Comment Load (0.4ms)  SELECT "comments".* FROM "comments" WHERE "comments"."post_id" = 1
=> [#<Comment id: 1, body: "First comment!", post_id: 1, created_at: "2013-04-22 22:54:36", updated_at: "2013-04-22 22:54:36">]
>> c = Comment.first
  Comment Load (0.6ms)  SELECT "comments".* FROM "comments" LIMIT 1
=> #<Comment id: 1, body: "First comment!", post_id: 1, created_at: "2013-04-22 22:54:36", updated_at: "2013-04-22 22:54:36">
>> c.post
  Post Load (0.3ms)  SELECT "posts".* FROM "posts" WHERE "posts"."id" = 1 LIMIT 1
=> #<Post id: 1, title: "First Post", body: "This is the first post in our system", created_at: "2013-04-22 22:53:03", updated_at: "2013-04-22 22:53:03">
```
