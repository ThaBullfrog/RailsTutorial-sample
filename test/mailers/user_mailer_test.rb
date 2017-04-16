require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:testuser)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Sample App Account Activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["bot@[172.245.173.138]"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match user.id.to_s, mail.body.encoded
  end

  test "password_reset" do
    # TODO
  end

end
