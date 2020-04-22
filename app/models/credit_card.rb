class CreditCard < ApplicationRecord
  include Swagger::Blocks
  STRIPE_PLANS = ["plan_GNQpwYzH4ZIcth", "plan_GNQrJT9PN9GFLy"]

  enum status: [:primary, :secondary]
  belongs_to :user

  swagger_schema :CreateCustomer do
    property :credit_card do
      property :customer_name do
        key :type, :string
      end
      property :cc_number do
        key :type, :string
        key :example, "4242424242424242"
      end
      property :expiry do
        key :type, :string
        key :example, "01/2023"
      end
      property :plan do
        key :type, :string
        key :example, "monthly/yearly"
      end
      property :free_trial do
        key :type, :string
        key :example, "true/false"
      end
      property :cvv do
        key :type, :string
      end
      property :country do
        key :type, :string
      end
      property :zipcode do
        key :type, :integer
      end
      property :recurring_payments do
        key :type, :string
      end
      property :trainer_coupon_code do
        key :type, :string
      end
      property :device_token do
        key :type, :string
      end
    end
  end

  swagger_schema :ClientSubscription do
    property :credit_card do
      property :customer_name do
        key :type, :string
      end
      property :cc_number do
        key :type, :string
        key :example, "4242424242424242"
      end
      property :expiry do
        key :type, :string
        key :example, "01/2023"
      end
      property :plan do
        key :type, :string
        key :example, "per_month/per_session"
      end
      property :cvv do
        key :type, :string
      end
      property :country do
        key :type, :string
      end
      property :zipcode do
        key :type, :integer
      end
      property :amount do
        key :type, :string
      end
      property :upgrade_request_id do
        key :type, :string
      end
    end
  end
  
  swagger_schema :MatchCouponCode do
    property :credit_card do
      property :trainer_coupon_code do
        key :type, :string
      end
    end
  end
end