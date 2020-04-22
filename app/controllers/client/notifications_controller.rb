class Client::NotificationsController < ClientController
  include Trestle::PaginationHelper
  before_action :authenticate_user!
  
  swagger_path '/client/notifications' do
    operation :get do
      key :description, 'Client Notifications API'
      key :tags, [
        'Client Notification API'
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
        key :description, 'Client Notifications Response'
        # schema do
        #   # key :'$ref', :Workout
        # end
      end
    end
  end

  def index
    # Notification.all.update(status: 'read')
    render json: NotificationSerializer.new(Notification.where(to_user_id: current_user.id).order('created_at desc'))
  end

  swagger_path '/client/notifications/{id}' do
    operation :delete do
      key :description, 'Client Delete Notifications API'
      key :tags, [
        'Client Notification API'
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
        key :description, 'Client Notification Response'
      end
    end
  end

  def destroy
    notification = Notification.find(params[:id])
    if notification.destroy
      render json: { success: "Notification has been deleted successfully." }
    else
      render json: { errors: ["Something went wrong. Please try again later"] }, status: :unprocessable_entity
    end
  end
end
