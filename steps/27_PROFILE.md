# Public Profile

See someone's post that you like? Maybe they've posted something else you'd enjoy. Time to create a public profile!

Add to routes

Add controller

```
  def show
    @user = User.find(params[:id])  
  end
```

Add basic view for now

```
<h1><%= @user.name %></h1>
```

Add a link to see your own profile. (application layout)

Changed the avatar size - might want to update previous checkpoint.

Moved posts to a partial. Needed to take out instance variables and base it off the post. Also reworked the comment post so that it could be used elsewhere.

Used a side tabbable from bootstrap. It uses built in JS.

I'm a little lost on what to do for the design here. So it might need to be reworked.
