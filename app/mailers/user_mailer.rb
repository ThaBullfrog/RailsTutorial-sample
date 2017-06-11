class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Sample App Account Activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Sample App Password Reset"
  end
end
