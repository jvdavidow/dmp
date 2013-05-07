# Photos

Note to Mike: one of the complaints I've heard about tutorial based is that people go along a clean road (the tutorial) and when they are done they aren't sure how to apply the knowledge. Probably should probably talk through the thought process here so that people can start building that.

I'll try to add my thoughts with Blockquotes and you can add what you think is appropriate.

---

There are seveal options for file uploads (images). Carrierwave is one of the more popular [ones](https://www.ruby-toolbox.com/categories/rails_file_uploads) which is in pretty active development.

> I like checking out ruby-toolbox to see what popular gems exist for a given category. I've used Carrierwave in the past and I like it for images. Since I'm familiar with it, I've gone ahead and used it.

Checkout the [github](https://github.com/jnicklas/carrierwave) page and read through the instructions. You'll go through them here but it is helpful read documentation in the wild.

> Always good to get familiar with the read me. It walks through most of this process.

* Add to gemfile (along with `mini_magick`)
* `% bundle`
* Add uploader

```
% rails generate uploader Avatar
      create  app/uploaders/avatar_uploader.rb
```

* Add migration

```
% rails g migration AddAvatarToUsers avatar:string
      invoke  active_record
      create    db/migrate/20130507161519_add_avatar_to_users.rb
```

* Run migration

```
% rake db:migrate
==  AddAvatarToUsers: migrating ===============================================
-- add_column(:users, :avatar, :string)
   -> 0.0398s
==  AddAvatarToUsers: migrated (0.0404s) ======================================
```

* Modify the User model.

```
mount_uploader :avatar, AvatarUploader
```

> It is pretty common for gems dealing with models to have you add things to the model. This is how they are able to add additional functionality.

* Add `:avatar` and `:avatar_cache` to list of `attr_accessible`

> I figured ths out after I submitted the form and it says I couldn't mass-assign it. I've been realizing we haven't done much debugging in here. Might be worth mentioning.

* Add file upload to the user form

> I always forget the syntax for this so I had to look it up on Google "rails file upload" and found the [Rails Guides](http://guides.rubyonrails.org/form_helpers.html#uploading-files).

* Modify the uploader

Use [documentation](http://carrierwave.rubyforge.org/rdoc/classes/CarrierWave/MiniMagick.html) for MiniMagick.

> The template files gives you most of the information you need. MiniMagick is smaller than ImageMagic so I used that instead. This meant the default commands (`scale`) don't work. Rails will throw an error letting you know it can't find the command. I had to do a quick google search to file how to properly scale it. I then found the above article which showed how.

* (re)Start server

> I was realizing it wasn't picking up some changes I was making to the uploader, so I had to restart the server for it to notice.

* Add image to layout/application
* Add image to post/show and topic/show

At this point you should be able to make it all work locally. If you look at `git status` you should see `public/uploads`. This is the default location that Carrierwave uses to save the files. You don't want to commit these files to git so add the path to `.gitignore`:

```
public/uploads
```

Heroku also does not lot you modify files on the server which means this solution will not work on heroku. The prefered way to do this is to save images to Amazon S3.

## Amazon S3 Integration

Sign up for [Amazon S3](http://aws.amazon.com/s3/) - should be free for first year.

Once signed in:

* Click on "AWS Management Console" on the right and sign in again.
* Click "S3" under Storage
* "Create Bucket"
* Name it "[something]Development"
* Click your name on the top left and select Security Credentails, copy down your access key and secret access key (Note to Mike: I signed up a couple months ago, I don't remember if I had to go through a step to create the Access Key).

> Kind of just had to click around here to figure out what was going on. I originally was clicking on "Amazon S3" but that took me to a product page. I then saw the "AWS Managment Console" so figure that out. Same with access keys. Feel free to just click around and see what Amazon provides.

Configuring your app: 

> This was one of the more confusing parts of this checkpoint. There wasn't any clear directive to how you should go about doing this. I had to Google for awhile to find examples of how to set it up (articles in `fog.rb`).

* `gem install 'fog'`
* Change storage argument in `avatar_uploader.rb`
* Create `config/initializer/fog.rb`
* `% bundle`
* Restart server
* Check it out.

This works locally now, but we want to use different buckets for local/production. Also, just like with SendGrid, we don't want to store credentials in a file that is being saved to git.

> This is something to keep in mind when changing a lot of things. Isolate the number of changes between tests. I wanted to test locally so that I knew it was working properly before trying to test it on heroku. But before I pushed it heroku I knew I would need to commit files and I don't want sensative data in the system. Therefore...

## To improve system of password handling.

Note to Mike: should probably move this to the part where we setup mail. I never knew about this before, but figured there should be a better way to handle sensative data.

We'll use [figaro](https://github.com/laserlemon/figaro).

* Add to Gemfile
* Bundle
* `% rails generate figaro:install`
* Modify `config/application.yml`
* Update `config/initializers/setup_mail.rb` and `config/initializers/fog.rb`
* Note to mike: I modified the .gitignore to take out `setup_mail.rb` sense it is safe now.
* Restart server and test it.
* Update readme so that "setup" includes `config/application.yml`.

If all works, push to heroku.

> Again, making sure it works locally before pushing.

```
% git push heroku master
```

Need to set the env variables:

```
% rake figaro:heroku
```

* `heroku run rake db:migrate`

> When I do `heroku logs -t` and watch as try to sign in, I see I'm getting "NoMethodError (undefined method `avatar_changed?' for #<User:0x00000004dd8318>):". Looks like my migration didn't take hold. Had to do `heroku restart` for it to kick in. Works great! Users the right bucket too.

## Challenge

Commit what you have. Then:

Add photos to post model

You can use the same Amazon S3 bucket

Just do a new uploader since a posts's images should be at different sizes.

Add images to views.

Link to the commit.

### My solution

```
% rails g uploader Image 
      create  app/uploaders/image_uploader.rb
% rails g migration AddImageToPosts image:string
      invoke  active_record
      create    db/migrate/20130507195227_add_image_to_posts.rb
% rake db:migrate
==  AddImageToPosts: migrating ================================================
-- add_column(:posts, :image, :string)
   -> 0.0014s
==  AddImageToPosts: migrated (0.0017s) =======================================
```

Modify `models/post.rb`

Modify `image_uploader.rb`

Modify `posts/_form.html.erb`

Modify `topics/show.html.erb`.

Used more of the [media](http://twitter.github.io/bootstrap/components.html#media) grouping.
