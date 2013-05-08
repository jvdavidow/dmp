# Destory

We haven't discussed destroying yet. Here is what should be able to happen:

* Admin can delete a topic and anything else
* Moderator can delete a post or comment
* Member can only delete their own post and their comments

## Delete a topic

* Add dependent destroy to topic model. [Resource](http://stackoverflow.com/questions/2797339/rails-dependent-destroy-vs-dependent-delete-all).
* Add delete button to show view, along with an alert.
* Add `destroy` method to `topic_controller`.

## Delete a post

* Add dependent destroy to post model
* Add destroy method to post controller
* Add to view

## Delete a comment

* Add destroy method to comment controller
* Add to view
