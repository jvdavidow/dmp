# Basic Models

```
% rails g model post title:string body:text
      invoke  active_record
      create    db/migrate/20130422224319_create_posts.rb
      create    app/models/post.rb
% rails g model comment body:text post:references
      invoke  active_record
      create    db/migrate/20130422224501_create_comments.rb
      create    app/models/comment.rb
% rake db:migrate
==  CreatePosts: migrating ====================================================
-- create_table(:posts)
   -> 0.0028s
==  CreatePosts: migrated (0.0030s) ===========================================

==  CreateComments: migrating =================================================
-- create_table(:comments)
   -> 0.0019s
-- add_index(:comments, :post_id)
   -> 0.0015s
==  CreateComments: migrated (0.0041s) ========================================
```

Added `has_many :comments` to `post.rb`.
