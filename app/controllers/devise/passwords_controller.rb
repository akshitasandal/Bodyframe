# frozen_string_literal: true

class Devise::PasswordsController < DeviseController
  prepend_before_action :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_action :assert_reset_token_passed, only: :edit
  include Swagger::Blocks
  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  swagger_path '/forgot_password' do
    operation :post  do
      key :description, 'User Forgot Password'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Pet to add to the store'
        # key :required, true
        schema do
          key :'$ref', :ForgotPassword
        end
      end

      # definition of success response
      response 200  do
        key :description , 'User Registration Response'
        schema do
          key :'$ref', :ForgotPassword
        end
      end
    end
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      render json: { success: I18n.t("devise.passwords.send_paranoid_instructions") }, status: :ok
    else
      render json: { errors: [ 'Please check whether your email is incorrect, as an error has been encountered while sending forgot password email.'] }, status: :unprocessable_entity
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  swagger_path '/update_forgot_password' do
    operation :patch  do
      key :description, 'User Forgot Password'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Pet to add to the store'
        # key :required, true
        schema do
          key :'$ref', :UpdateForgotPassword
        end
      end

      # definition of success response
      response 200  do
        key :description , 'Forgot Password Response'
        schema do
          key :'$ref', :UserResponse
        end
      end
    end
  end
  
  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      Devise.sign_in_after_reset_password
      AwsSesMailer.welcome_email(resource, options = { subject: 'BodyFrame Password Recovery'}).deliver_now
      render json: { success: I18n.t("devise.passwords.updated_not_active") }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end    
    #   if resource.errors.empty?
    #     resource.unlock_access! if unlockable?(resource)
    #     if Devise.sign_in_after_reset_password
    #       flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
    #       set_flash_message!(:notice, flash_message)
    #       resource.after_database_authentication
    #       sign_in(resource_name, resource)
    #     else
    #       set_flash_message!(:notice, :updated_not_active)
    #     end
    #     respond_with resource, location: after_resetting_password_path_for(resource)
    #   else
    #     set_minimum_password_length
    #     respond_with resource
    #   end
  end

  protected
  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end

  # Check if a reset_password_token is provided in the request
  def assert_reset_token_passed
    if params[:reset_password_token].blank?
      set_flash_message(:alert, :no_token)
      redirect_to new_session_path(resource_name)
    end
  end

  # Check if proper Lockable module methods are present & unlock strategy
  # allows to unlock resource on password reset
  def unlockable?(resource)
    resource.respond_to?(:unlock_access!) &&
      resource.respond_to?(:unlock_strategy_enabled?) &&
      resource.unlock_strategy_enabled?(:email)
  end

  def translation_scope
    'devise.passwords'
  end
end
