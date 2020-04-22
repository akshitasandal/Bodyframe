class AMS::UserSerializer < AmsSerializer
  include AvatarHelper
  attributes :full_name, :avatar_url, :subscription, :status, :qb_id, :chat_id
end
