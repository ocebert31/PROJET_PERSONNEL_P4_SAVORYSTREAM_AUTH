class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6, maximum: 72 }

  validate :password_no_spaces

  def self.from_token(token)
    payload = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
    self.find(payload["id"])
  end

  def self.secret_key
    ENV['SECRET_KEY_BASE'] || Rails.application.secret_key_base
  end

  def encode_token(payload = {})
    payload[:id] = id
    JWT.encode(payload, self.class.secret_key)
  end
  
  def password_no_spaces
    if password.present? && (password != password.strip)
      errors.add(:password, "Password cannot contain spaces before or after")
    end
  end
end