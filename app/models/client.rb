class Client < User
  include Swagger::Blocks
  has_one :trainer, foreign_key: :trainer_id

  has_many :workouts, class_name: 'Workout', foreign_key: :client_id, dependent: :destroy
  has_many :meals, class_name: 'Meal', foreign_key: :client_id, dependent: :destroy
  has_many :payment_histories
  
  def subscribed?
  end

  swagger_schema :UpdateChatId do
    property :client do
      property :chat_id do
        key :type, :string
      end
    end
  end
end
