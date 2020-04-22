class Trainer < User
  has_many :admin_payouts
  has_many :payment_histories
  def referral_code_generator
    full_name.first(4).upcase + (rand 100000).to_s
  end
  
  def send_invite!
    TwilioService.send_invite_message(client.phone)
  end
end
