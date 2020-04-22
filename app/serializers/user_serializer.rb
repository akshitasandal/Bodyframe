class UserSerializer
  include FastJsonapi::ObjectSerializer
  include AvatarHelper
  attributes :email, :full_name, :address, :phone, :sex, :user_type, :country_code, :referral_code, :state, :zipcode, :city, :subscription, :wallet_amount, :status, :trainer_coupon_code, :weight, :height, :objective, :qb_id, :chat_id

  attribute :dob do |object|
    date_of_birth(object.dob)
  end

  attribute :upgrade_request_id do |object|
    !object.pending? ? UpgradeRequest.where(client_id: object.id, status: "requested").last.try(:id) : ''
  end

  attribute :client_session_amount do |object|
    '%.2f' % Invitation.where(email: object.email).last.try(:session_amount).to_f
  end

  attribute :session_count do |object|
    Invitation.where(email: object.email).last.try(:session_count) || 0
  end

  attribute :client_monthly_amount do |object|
    '%.2f' % Invitation.where(email: object.email).last.try(:monthly_amount).to_f
  end

  attribute :per_session_amount do |object|
    '%.2f' % Invitation.where(email: object.email).last.try(:per_session_amount).to_f
  end

  attribute :trainer_qb_id do |object|
    object.try(:trainer).try(:qb_id)
  end

  attribute :trainer_qb_image do |object|
    if object.trainer.present? && object.trainer.avatar.present?
      object.trainer.avatar.service_url.sub(/\?.*/, '')
    end
  end

  attribute :trainer_code do |object|
    object.referrar_id.present? ? User.find(object.referrar_id).trainer_coupon_code : ''
  end

  attribute :client_plan do |object|
    Invitation.where(email: object.email).last.try(:plan)
  end

  attribute :avatar_url do |object|
    object.avatar.present? ? avatar_url(object.avatar) : ''
  end

  attribute :qbp_access_token do |object|
    text = object.qbp_access_token
    salt, data = text.split "$$"
    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.credentials.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    crypt.decrypt_and_verify data
  end
end
