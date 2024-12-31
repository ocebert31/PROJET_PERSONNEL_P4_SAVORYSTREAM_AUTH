class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.find(decoded_token[:user_id]) if decoded_token
  end

  def logged_in?
    !!current_user
  end

  def authorize_request
    render json: { error: 'Not Authorized' }, status: :unauthorized unless logged_in?
  end

  private

  def decoded_token
    if auth_header
      token = auth_header.split(' ').last
      begin
        JWT.decode(token, Rails.application.secret_key_base).first
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def auth_header
    request.headers['Authorization']
  end
end

