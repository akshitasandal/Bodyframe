class DeviceTokensController < ApplicationController
  before_action :authenticate_user!, except: [ :delete_token ]
  include Swagger::Blocks

  swagger_path '/device_tokens' do
    operation :post  do
      key :description, 'Device Token Creation'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :device_token
        key :in, :body
        key :description, 'Generate Device Token'
        key :required, true
        schema do
          key :'$ref', :GenerateDeviceTokens
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
        key :description , 'Token response'
        schema do
          key :'$ref', :GenerateDeviceTokens
        end
      end
    end
  end
  
  def create
    if current_user.present? && params[:device_token].present?
      if current_user.device_tokens.where(device_token: params[:device_token]).count < 1
        token = current_user.device_tokens.build(device_token: params[:device_token], device_type: params[:device_type])
        token.save
      end
      render json: { success: "Device token has been added successfully" }, status: :created
    else
      render json: { errors: ["Something went wrong. Please try again later."] }, status: :unprocessable_entity
    end
  end

  swagger_path '/device_tokens/delete_token' do
    operation :delete  do
      key :description, 'Device Token deletion'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :device_token
        key :in, :body
        key :description, 'Generate Device Token'
        key :required, true
        schema do
          key :'$ref', :GenerateDeviceTokens
        end
      end
      # definition of success response
      response 200 do
        key :description , 'Token response'
        schema do
          key :'$ref', :GenerateDeviceTokens
        end
      end
    end
  end

  def delete_token
    if params[:device_token].present?
      DeviceToken.where(device_token: params[:device_token]).destroy_all
      render json: { success: "Device token has been destroyed successfully" }
    end
  end
end
