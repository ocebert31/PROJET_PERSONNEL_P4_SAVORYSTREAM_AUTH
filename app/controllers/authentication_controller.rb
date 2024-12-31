class AuthenticationController < ApplicationController
  def register
    if email_already_taken?
      return render_error("L'email a déjà été pris", :unprocessable_entity)
    end

    if valid_email_format?(params[:email])
      return render_error("Le format de l'email n'est pas valide", :unprocessable_entity)
    end

    if passwords_do_not_match?
      return render_error("Les mots de passe ne correspondent pas", :unprocessable_entity)
    end

    if password_empty?
      return render_error("Le mot de passe ne peut pas être vide", :unprocessable_entity)
    end

    user = build_user

    if user.save
      render json: { token: encode_token(user_id: user.id) }, status: :created
    else
      render_error(user.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def email_already_taken?
    User.exists?(email: params[:email])
  end

  def passwords_do_not_match?
    params[:password] != params[:confirmPassword]
  end

  def password_empty?
    params[:password].blank?
  end

  def build_user
    User.new(user_params)
  end

  def encode_token(payload)
    secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
    JWT.encode(payload, secret)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def valid_email_format?(email)
    !(email =~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
  end  
end