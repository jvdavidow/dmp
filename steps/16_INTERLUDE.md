# Pushing to heroku.

Had add the sendgrid package.

```
% heroku addons:add sendgrid:starter
```

Then add sendgrid smtp to our setup. Added `setup_mail_production.rb`. `mail.rb` might have been cleaner.

Also went ahead and modified the application layout so that you can get to the user edit page, which hasn't been styled. Also added name to the sign up process.
