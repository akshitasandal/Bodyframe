class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:assign_clients]
  skip_before_action :authenticate_user!, only: [:vimeo]
  include Swagger::Blocks
  #respond_to :html, only: :vimeo

  def index
  end

  swagger_path '/user' do
    operation :get  do
      key :description, 'Get User Details'
      key :tags, [
        'User'
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
        key :description , 'Trainer Details Response'
        schema do
          key :'$ref', :UserRegister
        end
      end
    end
  end

  def show    
    render json: UserSerializer.new(current_user)
  end

  swagger_path '/update_profile' do
    operation :patch  do
      key :description, 'Trainer Profile Update'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Trainer Update API'
        key :required, true
        schema do
          key :'$ref', :UpdateProfile
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
      response 200  do
        key :description , 'Trainer Update Response'
        schema do
          key :'$ref', :UserRegister
        end
      end
    end
  end

  def update_profile
    if params[:user][:avatar].present?
      begin
        _image_with_mime_type = params[:user][:avatar].match(/\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/) || []
        extension = MIME::Types[_image_with_mime_type[1]]&.first&.preferred_extension || 'png'
        current_user.avatar.attach({ data: params[:user][:avatar], filename: 'profile-image', content_type: "image/#{extension}" })
      rescue => exception
        current_user.errors.add(:avatar, 'Please provide valid base64 encoded image')
      end
    end
    current_user.assign_attributes(user_params)
    if current_user.objective_changed?
      notification = current_user.notifications.build(notification_type: 15, notification_text: 15, to_user_id: current_user.trainer_id)
      notification_params = { client_name: current_user.full_name , option: current_user.objective }
      current_user.send_notifications(notification, notification_params) if notification.save
    end
    if current_user.weight_changed?
      notification1 = current_user.notifications.build(notification_type: 16, notification_text: 16, to_user_id: current_user.trainer_id)
      notification_params = { client_name: current_user.full_name , new_weight: current_user.weight }
      current_user.send_notifications(notification1, notification_params) if notification1.save
    end
    if current_user.valid? && current_user.update(user_params)
      render json: { success: 'Profile has been updated successfully', image_url: current_user.avatar.service_url.sub(/\?.*/, '') }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/update_password' do
    operation :patch  do
      key :description, 'Logged in user password update'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Update Password for logged in User'
        key :required, true
        schema do
          key :'$ref', :UserPassword
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
        key :description , 'Password update response'
        schema do
          key :'$ref', :UserResponse
        end
      end
    end
  end

  def update_password
    if current_user.update_with_password(password_params)
      render json: { success: 'Password has been updated successfully' }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_path '/cancel_my_account' do
    operation :patch  do
      key :description, 'My account deactivation'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Update Password for logged in User'
        key :required, true
        schema do
          key :'$ref', :CancelAccount
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
        key :description , 'Account deactivation response'
        schema do
          key :'$ref', :CancelAccount
        end
      end
    end
  end

  def cancel_my_account
    user = User.active_accounts.where(email: params[:user][:email]).first
    if user.present? && user.id == current_user.id && user.update(status: false, tokens: nil)      
      if current_user.trainer? && current_user.active? && current_user.subscription_id.present?
        StripeService.cancel_subscription(current_user)
        current_user.update(cancelled_at: DateTime.current, subscription: "expired")
      elsif current_user.client? && current_user.active?
        current_user.update(cancelled_at: DateTime.current, subscription: "expired")
      end
      if params[:user][:device_token].present?
        DeviceToken.where(device_token: params[:user][:device_token]).destroy_all
      end
      AwsSesMailer.welcome_email(current_user, options = { subject: 'Sorry to See You Go'}).deliver_now
      AwsSesMailer.welcome_email(current_user, options = { subject: 'BodyFrame Subscription Cancelled'}).deliver_now
      render json: { success: "You have temporarily deactivated your account. A delete request has been sent to admin to delete it permanently." }
    else
      render json:  { errors: ["Your email is Incorrect."] }, status: :unprocessable_entity
    end
  end

  swagger_path '/upload_video' do
    operation :post do
      key :description, 'Trainer Upload Video'
      key :tags, [
        'Trainer Assigning Client Meals'
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
      response 201 do
        key :description, 'Trainer Upload Video Response'
        schema do
          key :'$ref', :Meal
        end
      end
    end
  end

  def upload_video
    vimeo_client = VimeoMe2::User.new('20d9bf9cd677f0a54127fe9d397e4680')   
    begin
      video = vimeo_client.upload_video(params[:video])
      video_url = video['uri'].split('/')[-1]
      render json: { success: "Video has been uploaded successfully.", video_url: video_url }, status: :ok
    rescue VimeoMe2::RequestFailed => e
      render json: { errors: [e.message] }, status: unprocessable_entity
    end
  end

  swagger_path '/mark_as_read/{id}' do
    operation :get do
      key :description, 'Client Workout MARK as DONE/NOT-DONE'
      key :tags, [
        'Client Workouts'
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
      response 200  do
        key :description , 'Mark notification read Response'
        schema do
          key :'$ref', :Workout
        end
      end
    end
  end

  def mark_as_read
    notification = Notification.find(params[:id])
    if notification.read!
      render json: { badge_count: Notification.where(to_user_id: current_user.id, status: 'unread').count, notification: NotificationSerializer.new(notification) }
    else
      render json: { error: ["Something went Wrong. Please try again later"] }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :dob, :address, :phone, :sex, :country_code, :state, :city, :zipcode, :weight, :height, :objective)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
