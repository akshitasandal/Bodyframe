class DeviceToken < ApplicationRecord
  include Swagger::Blocks
  belongs_to :user
  swagger_schema :GenerateDeviceTokens do
    property :device_token do
      key :type, :string
    end
    property :device_key do
      key :type, :string
    end
  end
end
