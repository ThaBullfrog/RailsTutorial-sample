require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:testuser)
    @user_to_delete = users(:user_13)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "users index should redirect to root when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "admin should not editable through the web" do
    log_in_as @user
    assert_not @user.admin?, "for this test to work the test user cannot already be an admin"
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email, password: "password", admin: 1 } }
    @user.reload
    assert_not @user.admin?
  end

  test "users should need to be logged in to destroy other users" do
    assert_no_difference 'User.count' do
      delete user_path(@user_to_delete)
    end
  end

  test "only admins should be able to delete users" do
    log_in_as @user
    assert_not @user.admin?, "the test user must not be an admin for this test to work"
    assert_no_difference 'User.count' do
      delete user_path(@user_to_delete)
    end
  end

  test "admins should be able to delete users" do
    admin = users(:testadmin)
    log_in_as admin
    assert admin.admin?, "the test user must be an admin for this test to work"
    assert_difference 'User.count', -1 do
      delete user_path(@user_to_delete)
    end
  end

end
