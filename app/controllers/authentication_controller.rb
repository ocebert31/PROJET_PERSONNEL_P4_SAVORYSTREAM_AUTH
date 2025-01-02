class AuthenticationController < ApplicationController
  before_action :validate_email_and_password, only: [:register, :login]
  before_action :validation_for_register, only: [:register]

  def register
    user = build_user
    if user.save
      render json: { token: encode_token(user_id: user.id) }, status: :created
    else
      render_error("Error creating your account", :unprocessable_entity)
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { message: "You are successfully connected", token: encode_token(user_id: user.id) }, status: :ok
    else
      render_error("Invalid email or password", :unauthorized)
    end
  end

  private

  def validate_email_and_password
    validator = AuthenticationValidator.new(params)
    error = validator.validate_common_fields
    return render_error(error[:message], error[:status]) if error
  end

  def validation_for_register 
    validator = AuthenticationValidator.new(params)
    error = validator.validate_register_fields
    return render_error(error[:message], error[:status]) if error
  end

  def build_user
    User.new(user_params)
  end

  def user_params
    params.permit(:email, :password)
  end

  def encode_token(payload)
    secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
    JWT.encode(payload, secret)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
