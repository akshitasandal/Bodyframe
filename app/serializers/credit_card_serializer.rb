class CreditCardSerializer
  include FastJsonapi::ObjectSerializer
  attributes :cc_number, :cc_number, :customer_name, :country, :zipcode, :card_type, :status

  attribute :created_at do |object|
    object.created_at.strftime('%m/%d/%Y')
  end
end
