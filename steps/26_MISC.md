# Misc

I realized there are a couple things that need to be cleaned up. Figured I'd make a step in order to let you know about them.

* Redirect to topics page after sign in
* Current password needs to be taken out of the registration/edit so that facebook users can update their information. (should also take out password if they are from fb).
* Up/down arrow needs a visual change to show if you've already voted.
* Update bootstrap colors
* Make sure to check user permission before sending email

## Redirect to sign in

[wiki](https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in-out)

Add to application controller

## Remove password requirement 

[wiki](https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password)

This is a little more complicated because you have to add your own RegistrationsController and subclass the Devise one. Which means you also have to register it in routes.

I've just kept it clean by putting it under the user folder.

## Up/down arrows

Added turnery for class and added opacity.

## Update bootstrap colors

This should be in the CSS lesson when we add bootstrap. This way students see how they can customize the variables.

Choose a good link color from this [site](http://color.hailpixel.com/#0D777D,) (click to select).

Get the variable names [here](http://twitter.github.io/bootstrap/customize.html#variables) - just change `@` to `$`.

## User permissions on email

In the last checkpoint (email), I forgot to add permission checking before sending the email. I think it is important to show that code as is (to show a good example of `unless`), but then bring up the point they need to check permission and then have them change it to what it is in this commit (comment.rb).
