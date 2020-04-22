class Trainer::UpgradeRequestsController < ApplicationController
  include Swagger::Blocks

  swagger_path '/trainer/upgrade_requests' do
    operation :get  do
      key :description, 'Trainer Client Upgrade requests API'
      key :tags, [
        'Trainer Client Upgrade requests API'
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
      response 200  do
        key :description , 'Trainer Client Upgrade requests API Response'
        schema do
          key :'$ref', :UpgradeRequest
        end
      end
    end
  end

  def index
    render json: UpgradeRequestSerializer.new(UpgradeRequest.where(client_id: current_user.id, status: "requested").last)
  end

  swagger_path '/trainer/upgrade_requests' do
    operation :post do
      key :description, 'Trainer Client Upgrade requests API'
      key :tags, [
        'Trainer Client Upgrade requests API'
      ]
      parameter do
        key :name, :upgrade_request
        key :in, :body
        key :description, 'Create Client Upgrade requests'
        key :required, true
        schema do
          key :'$ref', :UpgradeRequest
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
      response 201 do
        key :description, 'Create Upgrade Requests Response'
        schema do
          key :'$ref', :UpgradeRequest
        end
      end
    end
  end

  def create
    upgrade_request = current_user.upgrade_requests.build(upgrade_request_params)
    client =  User.where(id: params[:upgrade_request][:client_id]).last
    if (client.status? && current_user.upgrade_requests.where(status: "requested", client_id: client.id).count == 0)
      if upgrade_request.save
        notification = current_user.notifications.build(notification_type: 17, notification_text: 17, to_user_id: upgrade_request.client_id)
        current_user.send_notifications(notification, notification_params = {}) if notification.save
        render json: { success: "Plan request has been sent to the client successfully." }, status: :ok
      else
        render json: { errors: upgrade_request.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["A plan already has been sent by you to this client or their account has been deactivated temporarily."] }, status: :unprocessable_entity
    end
  end

  swagger_path '/trainer/upgrade_requests/{id}' do
    operation :patch do
      key :description, 'Trainer Client Upgrade requests API'
      key :tags, [
        'Trainer Client Upgrade requests API'
      ]
      parameter do
        key :name, :meal
        key :in, :body
        key :description, 'Update Upgrade Request'
        key :required, true
        schema do
          key :'$ref', :RequestStatus
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
      response 200 do
        key :description, 'Update Upgrade Request Response'
        schema do
          key :'$ref', :RequestStatus
        end
      end
    end
  end

  def update
    upgrade_request = UpgradeRequest.where(id: params[:id]).first
    if upgrade_request.update(upgrade_request_params) && upgrade_request.declined?
      render json: { success: "You have declined the Upgrade Request for the new plan sent by your trainer." }, status: :ok
    else
      render json: { errors: ["Something went wrong. Please try again later."] }, status: :unprocessable_entity
    end
  end

  def destroy

  end

  private
  def upgrade_request_params
    params.require(:upgrade_request).permit(:client_id, :user_id, :plan, :monthly_amount, :session_amount, :session_count, :per_session_amount, :status)
  end
end
