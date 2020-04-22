class UpgradeRequest < ApplicationRecord
  include Swagger::Blocks

  belongs_to :user
  belongs_to :client, class_name: "User", foreign_key: :client_id

  enum status: [:requested, :accepted, :declined, :expired]

  swagger_schema :UpgradeRequest do
    key :required, [:full_name, :phone, :amount, :plan, :email]
    property :upgrade_request do
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
      property :client_id do
        key :type, :integer
        key :example, 0
      end
      property :plan do
        key :type, :string
        key :enum, ['per_upgrade_requestssession', 'per_month']
        key :example, 'per_session or per_month'
      end
    end
  end

  swagger_schema :RequestStatus do
    key :required, [:status]
    property :upgrade_request do
      property :status do
        key :type, :string
        key :enum, ['declined']
        key :example, 'declined'
      end
    end
  end
end
