class AdminPayout < ApplicationRecord
   belongs_to :user, optional: true
   has_many :payment_histories
   enum payment: [:pending, :requested, :approved, :declined]
end
