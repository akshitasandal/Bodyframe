# frozen_string_literal: true

class Devise::RegistrationsController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  prepend_before_action :set_minimum_password_length, only: [:new, :edit]
  prepend_before_action :set_user_access_token!, only: %i[edit update destroy]
  include Swagger::Blocks
  clear_respond_to
  respond_to :json
  # GET /resource/sign_up
  def new
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  swagger_path '/sign_up' do    
    operation :post  do
      key :description, 'User Registration (Please use domain with names mailinator.com and yopmail.com for emails)'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Create Trainer and Client Signup API'
        key :required, true
        schema do
          key :'$ref', :UserRegister
        end
      end

      # definition of success response
      response 200  do
        key :description , 'User Registration Response'
        schema do
          key :'$ref', :UserRegister
        end
      end
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if params[:user][:avatar].present?
      begin
        _image_with_mime_type = params[:user][:avatar].match(/\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/) || []
        extension = MIME::Types[_image_with_mime_type[1]]&.first&.preferred_extension || 'png'
        resource.avatar = { data: params[:user][:avatar], filename: 'profile-image', content_type: "image/#{extension}" }
      rescue => exception
        resource.errors.add(:avatar, 'Please provide valid base64 encoded image')
      end
    end
    qbp_password = SecureRandom.hex(6)
    resource.qbp_access_token = encrypt(qbp_password)
    if !resource.errors.present? and resource.save
      if resource.trainer?
        if params[:user][:referral_code].present?
          trainer = User.where(trainer_coupon_code: params[:user][:referral_code]).first
          resource.update(referrar_id: trainer.id) if trainer.present?
        end
      else
        if params[:user][:referral_code].present?
          trainer =  User.where(referral_code: params[:user][:referral_code]).first
          resource.update(trainer_id: trainer.id) if trainer.present?
        end
      end
      if resource.user_type == "client"
        if resource.trainer.trainer_invites.present? && resource.trainer.trainer_invites.where(email: resource.email).last.present?
          result = QuickbloxService.user_sign_up(resource, qbp_password)
          if result && result.parsed_response["user"].present? && result.parsed_response["user"]["id"].present?
            resource.update(qb_id: result.parsed_response["user"]["id"])
          else
            resource.destroy
            render json: { errors: ["Please use the email for which you are invited."] }, status: :unprocessable_entity
            return
          end
          AwsSesMailer.welcome_email(resource, options = { subject: 'Welcome to BodyFrame!'}).deliver_now
        else
          resource.destroy
          render json: { errors: ["Please use the email for which you are invited."] }, status: :unprocessable_entity
          return
        end
      else
        result = QuickbloxService.user_sign_up(resource, qbp_password)
        if result && result.parsed_response["user"].present? && result.parsed_response["user"]["id"].present?
          resource.update(qb_id: result.parsed_response["user"]["id"])
          AwsSesMailer.welcome_email(resource, options = { subject: 'Welcome to BodyFrame!'}).deliver_now
        else
          resource.destroy
          render json: { errors: ["There is some problem signing up user. Please try again later."] }, status: :unprocessable_entity
          return
        end
      end
      if resource.trainer?
        resource.update(referral_code: resource.referral_code_generator, trainer_coupon_code: coupon_code_generator)
        # generate_stripe_coupon(resource)
        Devise::Mailer.confirmation_instructions(resource, resource.send(:generate_confirmation_token)).deliver_now
        render json: { success: I18n.t('devise.registrations.signed_up_but_unconfirmed', resource_email: resource.email) }, status: :created
      else
        check_referral_code
      end
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    a = DeviceToken.where(device_token: params[:user][:device_token]).destroy_all
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource) if is_navigational_format?
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    sign_in_after_change_password? ? signed_in_root_path(resource) : new_session_path(resource_name)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  def translation_scope
    'devise.registrations'
  end

  private

  def encrypt(text)
    text = text.to_s unless text.is_a? String
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.credentials.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end

  # def default_serializer_options
  #   {
  #     serializer: nil
  #   }
  # end
  def check_referral_code
    if params[:user][:referral_code].present?
      trainer =  User.where(referral_code: params[:user][:referral_code]).first
      if trainer.trainer_invites && trainer.trainer_invites.where(email: resource.email).length < 1
        resource.destroy
        render json: { errors: ["Please Use the email for which you are invited."] }, status: 422
        return
      else
        resource.update(trainer_id: trainer.id)
        Devise::Mailer.confirmation_instructions(resource, resource.send(:generate_confirmation_token)).deliver_now
        render json: { success: I18n.t('devise.registrations.signed_up_but_unconfirmed', resource_email: resource.email) }, status: :created
      end
    else
      resource.destroy
      render json: { status: 500, error: "Your referral Code is Invalid." }
    end
  end
  
  def generate_stripe_coupon(user)
    Stripe::Coupon.create({
      duration: 'once',
      id: user.id,
      percent_off: 10,
    })
  end

  def coupon_code_generator
    SecureRandom.hex.first(6).upcase
  end

  def set_flash_message_for_update(resource, prev_unconfirmed_email)
    return unless is_flashing_format?

    flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                  :update_needs_confirmation
                elsif sign_in_after_change_password?
                  :updated
                else
                  :updated_but_not_signed_in
                end
    set_flash_message :notice, flash_key
  end

  def sign_in_after_change_password?
    return true if account_update_params[:password].blank?

    Devise.sign_in_after_change_password
  end
end
