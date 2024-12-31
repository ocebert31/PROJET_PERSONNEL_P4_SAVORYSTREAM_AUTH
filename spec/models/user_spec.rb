require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_email) { 'user@example.com' }
  let(:valid_password) { 'password123' }
  let(:valid_user) { User.new(email: valid_email, password: valid_password) }

  describe 'Validations' do
    context 'when attributes are valid' do
      it 'is valid with valid attributes' do
        expect(valid_user).to be_valid
      end

      it 'is valid with an email address that includes subdomains' do
        valid_user.email = 'user@mail.example.com'
        expect(valid_user).to be_valid
      end
    end

    context 'when email is invalid' do
      it 'is invalid without an email address' do
        valid_user.email = nil
        expect(valid_user).not_to be_valid
      end
      
      it 'is invalid when email is not unique' do
        User.create!(email: valid_email, password: valid_password)
        valid_user.email = valid_email
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:email]).to include('has already been taken')
      end

      it 'is invalid when email is not unique, ignoring case' do
        User.create!(email: 'USER@example.com', password: valid_password)
        valid_user.email = 'user@example.com'
        expect(valid_user).not_to be_valid
      end
    end

    context 'when email format is invalid' do
      invalid_emails = [
        { email: 'user @example.com', description: 'email containing spaces' },
        { email: 'userexample.com', description: 'missing "@"' },
        { email: 'user@', description: 'missing domain' },
        { email: 'user@exa$mple.com', description: 'invalid characters' }
      ]
      
      invalid_emails.each do |invalid_email|
        it "is not valid with an email #{invalid_email[:description]}" do
          valid_user.email = invalid_email[:email]
          expect(valid_user).not_to be_valid
        end
      end
    end

    context 'when password is invalid' do
      it 'is not valid without a password' do
        valid_user.password = nil
        expect(valid_user).not_to be_valid
      end

      it 'is invalid with a short password' do
        valid_user.password = 'pass'
        expect(valid_user).not_to be_valid
      end

      it 'is invalid when the password consists only of spaces' do
        valid_user.password = '      '
        expect(valid_user).not_to be_valid
      end

      it 'is invalid with a password longer than the maximum length of 72 characters' do
        valid_user.password = 'a' * 73
        expect(valid_user).not_to be_valid
      end
    end

    context 'when saving the user' do
      it 'hashes the password before saving' do
        user = User.create!(email: valid_email, password: valid_password)
        expect(user.password_digest).not_to eq(valid_password)
      end
    end
  end

  describe 'Password Authentication' do
    it 'authenticates with correct password' do
      user = User.create!(email: valid_email, password: valid_password)
      expect(user.authenticate(valid_password)).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = User.create!(email: valid_email, password: valid_password)
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
end
