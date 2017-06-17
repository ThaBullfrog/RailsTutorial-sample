require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:testuser)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_match @user.name, response.body
    assert_select 'th>img.gravatar'
    assert_select 'div.pagination'
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end

end
