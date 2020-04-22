class Invitation < ApplicationRecord
  include Swagger::Blocks

  belongs_to :trainer, class_name: 'User', foreign_key: :trainer_id
  validates :full_name, :phone, presence: true

  enum plan: ['per_session', 'per_month']
  enum user_type: ['client', 'trainer']

  def generate_client_invite(client_number)
    update(twilio_response: TwilioService.send_invite_message(full_name, self.trainer.referral_code, client_number, email ))
  end

  def generate_plan_invite(client_number)
    update(twilio_response: TwilioService.send_plan_message(full_name, client_number, email ))
  end

  def generate_trainer_invite(client_number)
    update(twilio_response: TwilioService.send_trainer_invite(full_name, self.trainer.trainer_coupon_code, client_number))
  end

  swagger_schema :Invitation do
    key :required, [:full_name, :phone, :amount, :plan, :email]
    property :invitation do
      property :full_name do
        key :type, :string
      end
      property :email do
        key :type, :string
      end
      property :phone do
        key :type, :string
      end
      property :session_amount do
        key :type, :string
      end
      property :per_session_amount do
        key :type, :string
      end
      property :monthly_amount do
        key :type, :string
      end
      property :session_count do
        key :type, :integer
        key :example, 0
      end
      property :user_type do
        key :type, :string
        key :enum, ['trainer', 'client']
        key :example, 'trainer/client'
      end
      property :plan do
        key :type, :string
        key :enum, ['per_session', 'per_month']
        key :example, 'per_session or per_month'
      end
    end
  end
end
