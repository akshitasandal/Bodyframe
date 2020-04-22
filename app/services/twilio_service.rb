class TwilioService
  class << self
    def send_invite_message(user_name, referral_code, client_number, email)
      twilio_client.messages.create(
        from: bodyframe_phone,
        to: client_number, #TODO client_number
        body: "Hello #{user_name}, You have been invited by your trainer to join them on the BodyFrame app. Please use the following link, referral code, and email to complete your sign up. \n Link: https://bodyframe.herokuapp.com/invitations?referral_code=#{referral_code} \n Email: #{email} \n Referral Code: #{referral_code}")
    end

    def send_plan_message(user_name, client_number, email)
      twilio_client.messages.create(
        from: bodyframe_phone,
        to: client_number, #TODO client_number
        body: "Hello #{user_name}, You have been invited by your trainer to subscribe a new plan. Please login to Subscribe.")
    end

    def send_trainer_invite(user_name, coupon_code, client_number)
      twilio_client.messages.create(
        from: bodyframe_phone,
        to: client_number, #TODO client_number
        body: "Hello #{user_name}, You have been invited to join thousands of other trainers on the BodyFrame app! Please use the following link to get started today. \n Link: https://bodyframe.herokuapp.com/invitations?referral_code=#{coupon_code}"
      )
    end
    
    def send_message(message, client_number)
      twilio_client.messages.create(
        from: bodyframe_phone,
        to: client_number, #TODO client_number
        body: message
      )
    end

    def twilio_client
      Twilio::REST::Client.new
    end

    def bodyframe_phone
      ENV.fetch('BODYFRAME_PHONE_NUMBER')
    end
  end
end