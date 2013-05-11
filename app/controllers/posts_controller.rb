class PostsController < ApplicationController
  def index
    # Already sorted by popularity
    @posts = Post.where("created_at > ?",7.days.ago).paginate(page: params[:page], per_page: 10)
  end
end
