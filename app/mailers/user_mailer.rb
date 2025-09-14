class UserMailer < ApplicationMailer
  default from: "no-reply@odinbook.com"

  def welcome_email(user)
    @user = user
    @url  = new_user_session_url
    mail(to: @user.email, subject: "Welcome to Odinbook!")
  end
end
