module AvatarHelper
  extend ActiveSupport::Concern

  class_methods do
    def avatar_url(avatar)
      avatar.attached? ? avatar.service_url.sub(/\?.*/, '') : ''
    end

    def date_of_birth(dob)
      (dob.strftime('%m/%d/%Y') rescue '')
    end
  end

  def avatar_url
    object.avatar.attached? ? object.avatar.service_url.sub(/\?.*/, '') : ''
  end

  def image_url
    object.image.attached? ? object.image.service_url.sub(/\?.*/, '') : ''
  end
end
