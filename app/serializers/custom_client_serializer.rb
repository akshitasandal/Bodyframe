class CustomClientSerializer
  include FastJsonapi::ObjectSerializer
  include DateRangeHelper
  include AvatarHelper
  attributes :email, :full_name, :address, :phone, :sex, :weight, :height, :objective, :qb_id

  attribute :dob do |object|
    date_of_birth(object.dob)
  end

  attribute :avatar_url do |object|
    avatar_url(object.avatar)
  end
  
  has_many :payment_histories, serializer: PaymentHistorySerializer
end
  