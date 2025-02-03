class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = user.encode_token({ user_id: user.id })
      render json: { message: "You are successfully connected", token: token }, status: :ok
    else
      render json: { error: "Unable to login" }, status: :unauthorized
    end
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
  


