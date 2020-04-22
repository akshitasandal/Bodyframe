class PaymentHistory < ApplicationRecord
  belongs_to :credit_card, optional: true
  belongs_to :bank_account, optional: true
  belongs_to :user
  belongs_to :client, class_name: "User", foreign_key: :client_id, optional: true
  belongs_to :admin_payout, optional: true

  def self.to_csv_p
    attributes = ["id", "amount", "reward_total", "plan", "created_at","trainer", "client"]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |payment|
        csv << [
          payment.id, 
          payment.try(:amount), 
          payment.try(:reward_total),
          payment.created_at,
          payment.user.full_name,
          payment.client.try(:full_name)
        ]
      end
    end
  end

end