require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "users should not be able to sign up with an invalid form submission" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "users should be able to sign up with a valid form submission" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: { name: "Test User", email: "test@example.com", password: "foobar", password_confirmation: "foobar" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?, 'should show flash indicating success'
  end

end
