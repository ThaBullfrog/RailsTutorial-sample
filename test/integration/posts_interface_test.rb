require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:testuser)
  end

  test "post interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This post really ties the room together"
    picture = fixture_file_upload('rails_logo.png', 'image/png')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, picture: picture } }
    end
    assert assigns(:post).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit a different user (do delete links)
    get user_path(users(:testuser2))
    assert_select 'a', text: 'delete', count: 0
  end

end
