class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_request_headers
  rescue_from ::ActiveRecord::ActiveRecordError, with: :render_api_error
  rescue_from ::ActiveRecord::RecordNotFound, with: :render_record_not_found  
  rescue_from ::Stripe::StripeError, with: :render_stripe_error
  # rescue_from ::StandardError, with: :render_api_error
  
  #around_action :handle_errors

  def handle_errors
    yield
  rescue ActiveRecord::RecordNotFound => e
    render_api_error(e.message, 404)
  rescue ActiveRecord::RecordInvalid => e
    render_api_error(e.record.errors, 422)
  rescue Stripe::StripeError => e
    render_api_error(e.error.message, 422)
  #rescue JWT::ExpiredSignature => e
  #  render_api_error(e.message, 401)
  #rescue InvalidTokenError => e
  #  render_api_error(e.message, 422)
  #rescue MissingTokenError => e
  #  render_api_error(e.message, 422)
  end

  def static
    head :no_content
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :address, :phone, :sex, :user_type, :country_code, :dob, :weight, :height, :objective, :state, :city, :zipcode])
  end

  def log_request_headers
    http_headers = {}.tap do |options|
      ['HTTP_ACCEPT', 'HTTP_ACCESS_TOKEN', 'HTTP_CLIENT', 'HTTP_EXPIRY', 'HTTP_UID', 'HTTP_TOKEN_TYPE'].each do |key|
        options[key] = request.headers[key]
      end
    end
    logger.info({ 'HTTP-HEADERS': http_headers.compact })
  end

  # def render_api_error(messages, code)
  #   data = { errors: { code: code, details: Array.wrap(messages) } }
  #   render json: data, status: code
  # end

  def render_record_not_found(exception)
    render json:  { errors: [ 'Record not found or might already be deleted.' ] }.to_json, status: 422
    return
  end
  
  def render_api_error(exception)    
    render json: { status: 500, error: exception.message }.to_json, status: 500
    return
  end

  def render_stripe_error(exception)
    render json: {errors: [ exception.message ]}.to_json, status: 422
    return
  end

end
