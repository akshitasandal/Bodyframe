class AwsSesMailer < ActionMailer::Base
  default from: 'no-reply@matrixm.email'
  layout 'welcome_email'
  def welcome_email(user, options)
    @user = user
    @name = user.full_name
    @email = user.email
    @subject = options[:subject]
    mail(to: @email, subject: @subject)
  end
end