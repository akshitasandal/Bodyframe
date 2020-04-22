require 'hmac-sha1'
class QuickbloxService
  class << self
    
    def user_sign_up(user, password)
      token = create_session.parsed_response["session"]["token"]
      qb_user = HTTParty.post("https://api.quickblox.com/users.json", headers: { "QB-Token": token }, body: { user: { email: user.email, password: password, full_name: user.full_name, custom_data: user.avatar.service_url.sub(/\?.*/, '') } }) if token.present?
    end

    def generate_signature(params, secret)
      pairs = params.map { |key, value| "#{key}=#{value}" }
      pairs.sort!
      body  = pairs.join("&")
      return hmac_sha(body, secret)
    end

    def create_session
      @params = {
        "application_id": ENV['QB_APPLICATION_ID'],
        "auth_key": ENV['QB_AUTH_KEY'],
        "timestamp": Time.now.to_i,
        "nonce": rand(2000)
      }
      @params["signature"] = generate_signature(@params, ENV['QB_AUTH_SECRET'])
      HTTParty.post("https://api.quickblox.com/session.json", body: @params)
    end

    def create_user_session(user, password)
      @params = {
        "application_id": ENV['QB_APPLICATION_ID'],
        "auth_key": ENV['QB_AUTH_KEY'],
        "timestamp": Time.now.to_i,
        "nonce": rand(2000)
      }
      @params["user[email]"] = user.email
      @params["user[password]"] = password
      @params["signature"] = generate_signature(@params, ENV['QB_AUTH_SECRET'])
      HTTParty.post("https://api.quickblox.com/session.json", body: @params)
    end

    def hmac_sha(data, secret)
      require "base64"
      require "cgi"
      require "openssl"
      hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), secret.encode("ASCII"), data.encode("ASCII"))
      return hmac
    end

    def decrypt(text)
      salt, data = text.split "$$"
      len   = ActiveSupport::MessageEncryptor.key_len
      key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
      crypt = ActiveSupport::MessageEncryptor.new key
      crypt.decrypt_and_verify data
    end
  end
end