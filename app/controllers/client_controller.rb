class ClientController < ApplicationController
  include Swagger::Blocks
  before_action :authenticate_user!, except: [:match_referral_code, :assign_clients]

  swagger_path '/client?date=YYYY-MM-DD' do
    operation :get do
      key :description, 'Fetch Client Details with Workout and Meals'
      key :tags, [
        'Client Workouts + Meals'
      ]
      parameter do
        key :name, :date
        key :in, :query
        key :required, false
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
      response 200  do
        key :description , 'Client Details Response'
        schema do
          key :'$ref', :ClientResponse
        end
      end
    end
  end

  def show
    render json: ClientSerializer.new(current_user, { params: permitted_params })
  end

  swagger_path '/match_referral_code' do
    operation :post do
      key :description, 'Match referral code API'
      key :tags, [
        'Client Signup Match Referral Code'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Match Referral Code API'
        key :required, true
        schema do
          key :'$ref', :MatchReferralCode
        end
      end
      # definition of success response
      response 200  do
        key :description, 'Match Referral Code Response'
        schema do
          key :'$ref', :MatchReferralCode
        end
      end
    end
  end

  def match_referral_code
    if params[:user][:referral_code].present?
      referral_code_user = User.where(referral_code: params[:user][:referral_code], user_type: 'trainer').first
      trainer_code_user = User.where(trainer_coupon_code: params[:user][:referral_code], user_type: 'trainer').first
      if referral_code_user.present?
        invited_user =  Invitation.where(trainer_id: referral_code_user.id, user_type: "client").last
        if invited_user.present?
          render json: { user_type: invited_user.user_type  }
        else
          render json: { errors: ['Enter valid Invitation code.'] }, status: :unprocessable_entity
        end
      else
        if trainer_code_user.present?
          render json: { user_type: trainer_code_user.user_type }
        else
          render json: { errors: ['Enter valid Invitation code.'] }, status: :unprocessable_entity
        end
      end
    else
      render json: { errors: ['Enter valid Invitation code.'] }, status: :unprocessable_entity
    end
  end

  swagger_path '/client/{id}' do
    operation :patch  do
      key :description, 'Client Profile Update'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Client Update API'
        key :required, true
        schema do
          key :'$ref', :UpdateChatId
        end
      end
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
      response 200  do
        key :description , 'Client Update Response'
        schema do
          key :'$ref', :UpdateChatId
        end
      end
    end
  end

  def update
    if params[:client][:chat_id].present?
      user = current_user.trainer? ? current_user.clients.where(id: params[:id]).first : current_user
    end
    if user.update(chat_id: params[:client][:chat_id])
      render json: ClientSerializer.new(user)
    else
      render json: { errors: ["Something went wrong. please try again later."] }, status: :unprocessable_entity
    end
  end

  def permitted_params
    params.permit!.slice(:date).to_h
  end
end
