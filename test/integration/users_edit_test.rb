require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:testuser)
    @user2 = users(:testuser2)
  end

  test "users should not be able to edit their profile with an incorrect password" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_empty flash, "should not show error message"
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email, password: "incorrect" } }
    assert_template 'users/edit'
    assert_not_empty flash[:danger]
  end

  test "users should not be able to update their profile with invalid info" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "", password: 'password' } }
    assert_template 'users/edit'
    assert_select "div[id=error_explanation]"
  end

  test "users should be able to update their profile with valid info" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user), "Is there friendly redirecting?"
    follow_redirect!
    assert_equal nil, session[:forwarding_url], "Friendly redirect url should be cleared after use"
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: 'password' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "users should not be able to edit a profile without logging in" do
    get edit_user_path(@user)
    assert_not_empty flash
    assert_redirected_to login_url
  end

  test "users should not be able to update a profile without logging in" do
    patch user_path(@user), params: { user: { name: @user.name, email: "newemail@example.com", password: "password" } }
    @user.reload
    assert_not_equal "newemail@example.com", @user.email
    assert_not_empty flash
    assert_redirected_to login_url
  end

  test "users should not be able to edit someone else's profile" do
    log_in_as(@user2)
    patch user_path(@user), params: { user: { name: @user.name, email: "newemail@example.com", password: "password" } }
    @user.reload
    assert_not_equal "newemail@example.com", @user.email
    assert_not_empty flash
    assert_redirected_to root_url
  end

end
