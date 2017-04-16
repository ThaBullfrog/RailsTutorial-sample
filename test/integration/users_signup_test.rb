require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "users should not be able to sign up with an invalid form submission" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "user valid signup and account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: { name: "Test User", email: "test@example.com", password: "foobar", password_confirmation: "foobar" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size, "activation email should be sent"
    user = assigns(:user)
    assert_not user.activated?, "user should not be activated yet"
    log_in_as user
    assert_not is_logged_in?, "should not be able to log in to an account that isn't activated"
    get edit_account_activation_path("invalid token", user_id: user.id)
    assert_not is_logged_in?, "invalid activation tokens should not work"
    get edit_account_activation_path(user.activation_token, user_id: 'wrong')
    assert_not is_logged_in?, "invalid user ids in activation links should not work"
    get edit_account_activation_path(user.activation_token, user_id: user.id)
    assert user.reload.activated?
    assert times_10_seconds_or_less_apart(Time.zone.now, user.activated_at), "activated_at time should be correct"
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?, "users should be automatically logged in after account activation"
  end

end
