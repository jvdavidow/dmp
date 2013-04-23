# Deploy

Pushing to heroku

modified Gemfile

```
group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
```

https://toolbelt.herokuapp.com/osx

```
% heroku login
% heroku create
% git push heroku master
```

