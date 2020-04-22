class BankAccountSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :bank_name, :routing_number, :source_id, :user_id
  
  attribute :account_number do |object|
    'XXXXXXXXXXXX' + object.account_number[-4..-1]
  end

  attribute :created_at do |object|
    object.created_at.strftime('%m/%d/%Y')
  end
  
end
  