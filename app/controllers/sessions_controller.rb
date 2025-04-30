class SessionsController < ApplicationController
  def create
    identify = params[:email] || params[:phone_number]
    user = find_user_by_email_or_phone(identify)
    if user&.authenticate(params[:password])
      render json: success_response(user), status: :ok
    else
      render json: { error: "Unable to login" }, status: :unauthorized
    end
  end

  private
  
  def find_user_by_email_or_phone(identify)
    User.find_by(email: identify) || User.find_by(phone_number: identify)
  end

  def success_response(user)
    {
      message: "You are successfully connected",
      token: user.encode_token({ user_id: user.id }),
      user: user.slice(:id, :email, :phone_number, :first_name, :last_name, :role)
    }
  end

  def google_oauth2
    auth = request.env['omniauth.auth']
    
    # Vérifie si l'utilisateur existe dans la base de données
    user = User.find_or_create_by(uid: auth['uid'], provider: 'google') do |u|
      u.email = auth['info']['email']
      u.name = auth['info']['name']
      u.token = auth['credentials']['token']
      u.refresh_token = auth['credentials']['refresh_token']
      u.expires_at = Time.at(auth['credentials']['expires_at'])
    end

    render json: { user: user, token: user.encode_token(user) }
  end

  def failure
    render json: { error: 'Authentication failed' }, status: :unauthorized
  end
end
  


