class PostsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user_or_admin, only: :destroy

  def create
    @post = current_user.posts.build(post_params)
    if(@post.save)
      flash[:success] = "Post created"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', locals: { write_post_expanded: true }
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_back(fallback_location: root_url)
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

    def correct_user_or_admin
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil? && !current_user.admin?
    end

end
