class PaymentHistorySerializer
  include FastJsonapi::ObjectSerializer
  attribute :cc_number, :plan, :session_count

  attribute :created_at do |object|
    object.created_at.strftime('%m/%d/%Y')
  end
  
  attribute :amount do |object|
    ('%.2f' % object.try(:amount).to_f)
  end

  attribute :deducted_amount do |object|
    object.reward_total.present? ? ('%.2f' % (object.amount.to_f - object.reward_total.to_f)) : 0.to_f
  end

  attribute :per_session_amount do |object|
    ('%.2f' % object.try(:per_session_amount).to_f)
  end

  attribute :next_payable_date do|object|
    if object.plan != "per_session"
      object.amount == 0.997e3 ? (object.created_at + 1.year).strftime('%m/%d/%Y') : (object.created_at + 1.month).strftime('%m/%d/%Y')
    end
  end

  attribute :client_name do |object|
    object.client.present? ? object.client.full_name : ''
  end
end
  