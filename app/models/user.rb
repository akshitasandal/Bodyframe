class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
                    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User
  include Swagger::Blocks
  include ActiveStorageSupport::SupportForBase64

  scope :active_accounts, -> { where(:status => true) }

  enum user_type: [:trainer, :client]
  enum sex: [:male, :female, :other]
  enum objective: { 'Build Muscle' => 0, 'Lose Weight' => 1, 'Contest Prep' => 2, 'Increase Strength' => 3, 'Improve Stamina' => 4, 'Lifestyle Change' => 5 }
  enum subscription: [:pending, :active, :inactive, :expired]

  has_one_base64_attached :avatar, dependent: :destroy
  # validates :avatar, content_type: ["image/png", "image/jpeg"]
  has_many :clients, class_name: 'User', foreign_key: :trainer_id, dependent: :destroy
  has_many :trainer_workouts, class_name: 'Workout', foreign_key: :user_id, dependent: :destroy
  has_many :trainer_meals, class_name: 'Meal', foreign_key: :user_id, dependent: :destroy
  has_many :trainer_invites, class_name: 'Invitation', foreign_key: :trainer_id, dependent: :destroy
  has_many :client_workouts, class_name: 'Workout', foreign_key: :client_id, dependent: :destroy
  has_many :workout_categories, through: :client_workouts
  has_many :client_meals, class_name: 'Meal', foreign_key: :client_id, dependent: :destroy
  has_many :meal_categories, through: :client_meals
  has_many :payment_histories
  has_many :credit_cards
  has_many :bank_accounts
  has_many :notifications
  has_many :device_tokens
  has_many :admin_payouts
  has_many :upgrade_requests
 
  belongs_to :referrar, class_name: "User", foreign_key: :referrar_id, optional: true
  belongs_to :trainer, class_name: "User", foreign_key: :trainer_id, optional: true

  def self.to_csv
    attributes = %w{id email full_name objective phone user_type}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
  
  def self.to_csv1
    attributes = ["id", "full_name", "email", "phone", "user_type", "amount_paid", "commission_earned"]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << [
          user.id, 
          user.full_name, 
          user.email,
          user.phone,
          user.user_type,
          user.trainer? ? user.payment_histories.sum(:amount) : PaymentHistory.where(client_id: user.id).sum(:amount),
          user.payment_histories.try(:reward_total)
        ]
      end
    end
  end
  
  def stripe_customer
  end

  def firebase_token
  end

  #use if needed to generate AWS public S3 URL
  def avatar_public_url
    avatar.service.send(:object_for, avatar.key).public_url
  end

  def referral_code_generator
    full_name.first(4).upcase + (rand 100000).to_s
  end

  def send_notifications(notification, notification_params)
    device_ids = notification.user.device_tokens.pluck(:device_token)
    NotificationService.notifications(device_ids, notification, notification_params)
  end

  swagger_schema :UserRegister do
    key :required, [:email, :password]
    property :user do
      property :full_name do
        key :type, :string
      end
      property :email do
        key :type, :string
        key :example, "name@mailinator.com"
      end
      property :password do
        key :type, :string
      end
      property :address do
        key :type, :string
      end
      property :state do
        key :type, :string
      end
      property :city do
        key :type, :string
      end
      property :zipcode do
        key :type, :integer
      end
      property :dob do
        key :type, :string
      end
      property :phone do
        key :type, :string
      end
      property :sex do
        key :type, :string
        key :enum, ['male', 'female', 'other']
      end
      property :avatar do
        key :type, :string
      end
      property :user_type do
        key :type, :string
        key :enum, ['trainer', 'client']
        key :example, 'trainer/client'
      end
      property :country_code do
        key :type, :string
      end
      property :height do
        key :type, :integer
      end
      property :weight do
        key :type, :integer
      end
      property :referral_code do
        key :type, :string
      end
      property :objective do
        key :type, :string
        key :enum, ["Build Muscle", "Lose Weight", "Contest Prep", "Increase Strength", "Improve Stamina", "Lifestyle Change"]
        key :example, "Build Muscle/Lose Weight/Contest Prep/Increase Strength/Improve Stamina/Lifestyle Change"
      end
    end
  end

  swagger_schema :UserLogin do
    key :required, [:email, :password]
    property :email do
      key :type, :string
    end
    property :password do
      key :type, :string
    end
  end

  swagger_schema :UpdateProfile do
    property :user do
      property :full_name do
        key :type, :string
      end      
      property :address do
        key :type, :string
      end
      property :state do
        key :type, :string
      end
      property :city do
        key :type, :string
      end
      property :zipcode do
        key :type, :integer
      end
      property :dob do
        key :type, :string
      end
      property :phone do
        key :type, :string
      end
      property :sex do
        key :type, :string
        key :enum, ['male', 'female']
      end
      property :avatar do
        key :type, :string
      end
      property :country_code do
        key :type, :string
      end
      property :height do
        key :type, :integer
      end
      property :weight do
        key :type, :integer
      end
      property :objective do
        key :type, :string
        key :enum, ["Build Muscle", "Lose Weight", "Contest Prep", "Increase Strength", "Improve Stamina", "Lifestyle Change"]
        key :example, "Build Muscle/Lose Weight/Contest Prep/Increase Strength/Improve Stamina/Lifestyle Change"
      end
    end
  end

  swagger_schema :ForgotPassword do
    property :user do
      property :email do
        key :type, :string
      end
    end
  end

  swagger_schema :UpdateForgotPassword do
    property :user do
      property :password do
        key :type, :string
      end
      property :password_confirmation do
        key :type, :string
      end
      property :reset_password_token do
        key :type, :string
      end
    end
  end

  swagger_schema :UserPassword do
    property :user do
      property :current_password do
        key :type, :string
      end
      property :password do
        key :type, :string
      end
      property :password_confirmation do
        key :type, :string
      end
    end
  end

  swagger_schema :UserResponse do
    property :success do
      key :type, :string
    end
  end

  swagger_schema :ClientResponse do
    property :user do
      property :full_name do
        key :type, :string
      end
      property :email do
        key :type, :string
      end
      property :address do
        key :type, :string
      end
      property :state do
        key :type, :string
      end
      property :city do
        key :type, :string
      end
      property :zipcode do
        key :type, :integer
      end
      property :dob do
        key :type, :string
      end
      property :phone do
        key :type, :string
      end
      property :avatar_url do
        key :type, :string
      end
      property :stripe_id do
        key :type, :string
      end
      property :workouts do
        key :type, :array
      end
      property :meals do
        key :type, :array
      end
    end
  end

  swagger_schema :MatchReferralCode do
    property :user do
      property :referral_code do
        key :type, :string
      end
    end
  end
  
  swagger_schema :CancelAccount do
    property :user do
      property :email do
        key :type, :string
      end
      property :device_token do
        key :type, :string
      end
    end
  end

  swagger_schema :UserLogout do
    property :user do
      property :device_token do
        key :type, :string
      end
    end
  end
  
end
