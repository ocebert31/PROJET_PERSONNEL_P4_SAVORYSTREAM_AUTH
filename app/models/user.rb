class User < ApplicationRecord
    has_secure_password
  
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6, maximum: 72 }

    validate :password_no_spaces

    def encode_token(payload)
      secret = ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
      JWT.encode(payload, secret)
    end

    private
  
    def password_no_spaces
      if password.present? && (password != password.strip)
        errors.add(:password, "Password cannot contain spaces before or after")
      end
    end
end
  