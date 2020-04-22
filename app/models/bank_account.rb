class BankAccount < ApplicationRecord
  include Swagger::Blocks
  validates_length_of :account_number, minimum: 5, allow_blank: false
  validates_length_of :routing_number, is: 9, allow_blank: false

  belongs_to :user

  swagger_schema :AddBankAccount do
    property :bank_account do
      property :name do
        key :type, :string
        key :example, "Test User"
      end
      property :bank_name do
        key :type, :string
        key :example, "Test Bank"
      end
      property :routing_number do
        key :type, :string
        key :example, "110000000"
      end
      property :account_number do
        key :type, :string
        key :example, "000123456789"
      end
    end
  end
end
