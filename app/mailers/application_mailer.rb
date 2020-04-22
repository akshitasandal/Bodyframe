class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  def welcome_email(options={})
        @name = "abc"
        @email = "def"
        @message ="text"
        mail(:to=>"dvd@mailinator.com", :subject=>"Amazon SES Email")
  end
end
