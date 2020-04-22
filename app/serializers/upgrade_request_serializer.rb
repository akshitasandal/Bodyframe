class UpgradeRequestSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :client_id, :user_id, :plan, :monthly_amount, :session_amount, :session_count, :per_session_amount, :status
end
  