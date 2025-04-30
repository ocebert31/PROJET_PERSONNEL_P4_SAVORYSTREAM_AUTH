class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone_number, format: { with: /\A\d{10}\z/, message: "must be a valid 10-digit number" }, uniqueness: true, allow_blank: true
  validate :email_or_phone_number
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :role, presence: true, inclusion: { in: ['customer', 'admin'] }
  validates :password, presence: true, length: { minimum: 6, maximum: 72 }
  validate :password_no_spaces
  after_initialize :set_default_role, if: :new_record?

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

  def password_present?
    new_record? || password.present?
  end

  def set_default_role
    self.role ||= 'customer' 
  end

  def email_or_phone_number
    if email.blank? && phone_number.blank?
      errors.add(:base, "Either email or phone number must be present")
    end
  end
end