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
```

This adds heroku as a remote repository, just like we did with github.

Commit your files and then push to heroku

```
% git add .
% git commit -m "Deploying to heroku"
% git push heroku master
```


```
...
-----> Compiled slug size: 9.7MB
-----> Launching... done, v6
       http://cryptic-atoll-8261.herokuapp.com deployed to Heroku
```

Check it [out](http://cryptic-atoll-8261.herokuapp.com).
