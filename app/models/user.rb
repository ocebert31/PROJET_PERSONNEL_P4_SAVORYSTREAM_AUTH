class User < ApplicationRecord
    has_secure_password
  
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/ }
    validates :password, presence: true, length: { minimum: 6, maximum: 72 }
end
  