# frozen_string_literal: true

class Devise::SessionsController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action :verify_signed_out_user, only: :destroy
  prepend_before_action(only: [:create, :destroy]) { request.env["devise.skip_timeout"] = true }
  include Swagger::Blocks
  clear_respond_to 
  respond_to :json
  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  swagger_path '/login' do    
    operation :post  do
      key :description, 'User Login'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Pet to add to the store'
        key :required, true
        schema do
          key :'$ref', :UserLogin
        end
      end

      # definition of success response
      response 200  do
        key :description , 'User Registration Response'
        schema do
          key :'$ref', :UserLogin
        end
      end
    end
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)    
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?    
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  swagger_path '/sign_out' do    
    operation :delete  do
      key :description, 'User SignOut'
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'Pet to add to the store'
        key :required, true
        schema do
          key :'$ref', :UserLogout
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
        key :description , 'User Registration Response'
        schema do
          key :'$ref', :UserLogout
        end
      end
    end
  end
  
  # DELETE /resource/sign_out
  def destroy
    DeviceToken.where(device_token: params[:user][:device_token]).destroy_all
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out 
    yield if block_given?
    respond_to_on_destroy
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def translation_scope
    'devise.sessions'
  end

  private

  # Check if there is no signed in user before doing the sign out.
  #
  # If there is no signed in user, it will set the flash message and redirect
  # to the after_sign_out path.
  def verify_signed_out_user
    if all_signed_out?
      set_flash_message! :notice, :already_signed_out

      respond_to_on_destroy
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }

    users.all?(&:blank?)
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end
