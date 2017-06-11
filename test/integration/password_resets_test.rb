require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:testuser)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new', "should be able to vist new password reset page"
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    follow_redirect!
    assert_not flash.empty?, "invalid email for password reset shouldn't work"
    assert_template 'password_resets/new', "invalid email for password reset should render password_resets/new again"
    # Valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest, "password reset should update the user's reset_digest"
    assert_equal 1, ActionMailer::Base.deliveries.size, "password reset should send an email"
    assert_not flash.empty?, "password reset should show success message when the email is sent"
    assert_redirected_to root_url, "should be redirected to root after password reset email is sent"
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url, "should be redirected to root when a reset token is used with an incorrect email"
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url, "should be redirected to root when a reset token is used with an inactive user"
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url, "should be redirected to root when an incorrect reset token is used"
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit', "a form should be displayed when a valid password reset link is used"
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Mismatched password & confirmation
    patch password_reset_path(user.reset_token), 
        params: { email: user.email, 
                  user: { password: 'foobar', password_confirmation: 'foobaz' } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token), 
        params: { email: user.email, 
                  user: { password: '', password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token), 
        params: { email: user.email, 
                  user: { password: 'password', password_confirmation: 'password' } }
    assert is_logged_in?, "should be logged in after successful password reset"
    user.reload
    assert_nil user.reset_digest, "the user's reset_digest should be set to nil after a successful password reset"
    assert_not flash.empty?, "a success message should be shown after a successful password reset"
    assert_redirected_to user, "should be redirected to user page after a successful password reset"
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), 
        params: { email: @user.email, 
                  user: { password: 'foobar', password_confirmation: 'foobar' } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end

end
