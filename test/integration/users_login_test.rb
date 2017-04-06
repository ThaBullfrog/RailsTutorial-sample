require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:testuser)
  end

  test "should receive an error message when attempting a login with an invalid email" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new', message: 'users should be sent back to the login page'
    assert_not flash.empty?
    get root_path
    assert flash.empty?, 'the error message should not persist through a page request'
  end

  test "should receive an error message when attempting a login with an incorrect password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: "incorrect" } }
    assert_template 'sessions/new', message: 'users should be sent back to the login page'
    assert_not flash[:danger].nil?
    assert flash[:danger].include?('ncorrect password'), 'should display incorrect password error'
    get root_path
    assert flash.empty?, 'the error message should not persist through a page request'
  end

  test "valid login followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to @user, 'user should be redirected to their profile after login'
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", user_path(@user), true, "navbar should've changed"
    delete logout_path
    assert_not is_logged_in?, 'user should be able to log out'
    assert_redirected_to root_url, 'user should be redirected to root after logout'
    follow_redirect!
    assert_select "a[href=?]", user_path(@user), false, "navbar should lose profile link after logout"
    assert_select "a[href=?]", login_path, true, "navbar should have login link after logout"
  end

end
