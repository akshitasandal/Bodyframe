class CreditCardsController < ApplicationController
  before_action :authenticate_user!
  include Swagger::Blocks

  swagger_path '/subscribe_user' do
    operation :post  do
      key :description, 'Create stripe Customer API'
      key :tags, [
        'Credit Card and Subscription APIs'
      ]
      parameter do
        key :name, :id
        key :in, :body
        key :description, 'Create Stripe Customer'
        key :required, true
        schema do
          key :'$ref', :CreateCustomer
        end
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end     
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end     
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description , 'Stripe Customer response'
        schema do
          key :'$ref', :CreateCustomer
        end
      end
    end
  end

  def subscribe_user
    trainer = User.where(trainer_coupon_code: params[:credit_card][:trainer_coupon_code]).first
    if params[:credit_card][:trainer_coupon_code].present? && !trainer.present?
      render json: { errors: ['Your coupon code is invalid.'] }, status: :unprocessable_entity
    else
      if !current_user.active?
        result = StripeService.create_customer(current_user, params[:credit_card])
        render json: UserSerializer.new(current_user)
      else
        render json: UserSerializer.new(current_user)
      end
    end
  end

  swagger_path '/subscribe_client' do
    operation :post  do
      key :description, 'Create stripe Customer API'
      key :tags, [
        'Credit Card and Subscription APIs'
      ]
      parameter do
        key :name, :id
        key :in, :body
        key :description, 'Create Stripe Customer'
        key :required, true
        schema do
          key :'$ref', :ClientSubscription
        end
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description , 'Stripe Customer response'
        schema do
          key :'$ref', :ClientSubscription
        end
      end
    end
  end

  def subscribe_client
    result = StripeService.client_subscription(current_user, params[:credit_card])
    render json: UserSerializer.new(current_user)
  end
  
  swagger_path '/payment_information' do
    operation :get do
      key :description, 'Credit Card Details API'
      key :tags, [
        'Payment Histories'
      ]
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description, 'Credit Card Details Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def payment_information
    if current_user.trainer?
      render json: {
        subscription_amount: current_user.payment_histories.first.present? ? true : false,
        payment: PaymentHistorySerializer.new(current_user.payment_histories.where(client_id: nil).last), 
        cards: CreditCardSerializer.new(current_user.credit_cards) 
      }
    else
      render json: {
        subscription_amount: PaymentHistory.where(client_id: current_user.id).last.present? ? true : false ,
        payment: PaymentHistorySerializer.new(PaymentHistory.where(client_id: current_user.id).last), 
        cards: CreditCardSerializer.new(current_user.credit_cards) 
      }
    end
  end

  swagger_path '/credit_cards' do
    operation :post  do
      key :description, 'Add New Card API'
      key :tags, [
        'Credit Card and Subscription APIs'
      ]
      parameter do
        key :name, :id
        key :in, :body
        key :description, 'Add New Card'
        key :required, true
        schema do
          key :'$ref', :CreateCustomer
        end
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description , 'New Card response'
        schema do
          key :'$ref', :CreateCustomer
        end
      end
    end
  end

  def create
    result = StripeService.add_credit_card(current_user, params[:credit_card])
    render json: UserSerializer.new(current_user)
  end

  swagger_path '/credit_cards/{id}' do
    operation :delete do
      key :description, 'Destroy credit card API'
      key :tags, [
        'Credit Card and Subscription APIs'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end

      # definition of success response
      response 200 do
        key :description, 'Response'
      end
    end
  end

  def destroy
    card = CreditCard.where(id: params[:id]).first
    if card.present? && card.destroy
      result = StripeService.remove_credit_card(current_user, card)
      render json: { success: 'Card has been removed succefully.'}, status: :ok
    else
      render json: { errors: ['Record not found or might already be deleted.'] }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer_wallet' do
    operation :get do
      key :description, 'Trainer Wallet API'
      key :tags, [
        'Trainer Wallet APIs'
      ]
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end

      # definition of success response
      response 200 do
        key :description, 'Wallet Response'
      end
    end
  end

  def trainer_wallet
    # result = current_user.stripe_id.present? ? Stripe::Customer.retrieve(current_user.stripe_id) : 0
    # wallet_amount = current_user.update(wallet_amount: (result == 0 ? 0 : result.balance))
    render json: { balance: current_user.wallet_amount, bank_account: BankAccountSerializer.new(current_user.bank_accounts) }
  end

  swagger_path '/wallet_withdrawal' do
    operation :patch  do
      key :description, 'Withdraw money from wallet API'
      key :tags, [
        'Trainer Wallet APIs'
      ]
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description , 'Withdraw money response'
        schema do
          key :'$ref', ''
        end
      end
    end
  end

  def wallet_withdrawal
    if current_user.bank_accounts.size > 0 && current_user.update(wallet_amount: 0)
      current_user.admin_payouts.present? ? current_user.admin_payouts.last.update(payment: 1) : ''
      AwsSesMailer.welcome_email(current_user, options = { subject: 'Wallet Withdraw Confirmation'}).deliver_now
      render json: { success: 'The transaction to be completed in 3-4 business days.' }
    elsif current_user.bank_accounts.size == 0
      render json: { errors: ['Please add bank Account to withdraw a payment.'] }, status: :unprocessable_entity
    else
      render json: { errors: ['Something went wrong. Please try again later.'] }, status: :unprocessable_entity
    end
  end

  swagger_path '/billing_history' do
    operation :get do
      key :description, 'Billing History API'
      key :tags, [
        'Payment Histories'
      ]
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description, 'Billing History Response'
      end
    end
  end

  def billing_history
    if current_user.trainer?
      render json: PaymentHistorySerializer.new(current_user.payment_histories.where(client_id: nil))
    else
      render json: PaymentHistorySerializer.new(PaymentHistory.where(client_id: current_user.id))
    end
  end
  
  swagger_path '/client_payment_history?month=&year=' do
    operation :get do
      key :description, 'Client Payment History API'
      key :tags, [
        'Payment Histories'
      ]
      parameter do
        key :name, :month
        key :in, :query
        key :required, false
        key :type, :integer
      end
      parameter do
        key :name, :year
        key :in, :query
        key :required, false
        key :type, :integer
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description, 'Client Payment History Response'
      end
    end
  end

  def client_payment_history
    render json: PaymentHistorySerializer.new(current_user.payment_histories.where.not(client_id: nil).where(created_at: Date.new(params[:year].to_i,params[:month].to_i,1).beginning_of_day..Date.new(params[:year].to_i,params[:month].to_i,-1).end_of_day))
  end
  
  swagger_path '/credit_cards/{id}' do
    operation :patch  do
      key :description, 'set Primary card API'
      key :tags, [
        'Credit Card and Subscription APIs'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :required, :true
        key :type, :string
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description , 'Primary Card response'
        schema do
          key :'$ref', :MatchCouponCode
        end
      end
    end
  end

  def update
    if current_user.stripe_id.present?
      card = current_user.credit_cards.where(id: params[:id]).first
      result = StripeService.set_primary_card(current_user, card)
      puts "***********#{result.inspect}"
      render json: CreditCardSerializer.new(current_user.credit_cards)
    else
      render json: { errors: ["Something went wrong. Please try again later."]}
    end
  end

  swagger_path '/match_coupon_code' do
    operation :post do
      key :description, 'Match Coupon Code API'
      key :tags, [
        'Payment Histories'
      ]
      parameter do
        key :name, :id
        key :in, :body
        key :description, 'Create Stripe Customer'
        key :required, true
        schema do
          key :'$ref', :MatchCouponCode
        end
      end
      parameter do
        key :name, 'access-token'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'client'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'expiry'
        key :in, :header
        key :description, ''
      end
      parameter do
        key :name, 'token-type'
        key :in, :header
        key :description, ''
        key :example, 'Bearer'
      end
      parameter do
        key :name, 'uid'
        key :in, :header
        key :description, ''
      end
      # definition of success response
      response 200 do
        key :description, 'Match Coupon Code Response'
      end
    end
  end

  def match_coupon_code
    trainer = User.where(trainer_coupon_code: params[:credit_card][:trainer_coupon_code]).first
    if trainer.present?
      render json: { success: 'You got 10% discount by applying this coupon.' }
    else
      render json: { errors: ['Your coupon code is invalid. Please try correct one to get discount.']}
    end
  end
end
