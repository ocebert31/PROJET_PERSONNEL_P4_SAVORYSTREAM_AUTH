require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_email) { 'user@example.com' }
  let(:valid_password) { 'password123' }
  let(:valid_user) { User.new(email: valid_email, password: valid_password) }

  describe 'Validations' do
    context 'when email is valid' do
      it 'with a valid email address' do
        expect(valid_user).to be_valid
      end

      it 'with an email address that includes subdomains' do
        valid_user.email = 'user@mail.example.com'
        expect(valid_user).to be_valid
      end
    end

    context 'when email is invalid' do
      it 'without an email address' do
        valid_user.email = nil
        expect(valid_user).not_to be_valid
      end

      it 'with a non-unique email' do
        User.create!(email: valid_email, password: valid_password)
        valid_user.email = valid_email
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:email]).to include('has already been taken')
      end

      it 'with a non-unique email (case insensitive)' do
        User.create!(email: 'USER@example.com', password: valid_password)
        valid_user.email = 'user@example.com'
        expect(valid_user).not_to be_valid
      end

      context 'when email format is invalid' do
        invalid_emails = [
          { email: 'user @example.com', description: 'email containing spaces' },
          { email: 'userexample.com', description: 'missing "@"' },
          { email: 'user@', description: 'missing domain' },
          { email: 'user@exa$mple.com', description: 'invalid characters' }
        ]
        
        invalid_emails.each do |invalid_email|
          it "with an email #{invalid_email[:description]}" do
            valid_user.email = invalid_email[:email]
            expect(valid_user).not_to be_valid
          end
        end
      end

      context 'when email has leading or trailing spaces' do
        it 'is invalid with email having leading spaces' do
          valid_user.email = '  user@example.com'
          expect(valid_user).not_to be_valid
        end
  
        it 'is invalid with email having trailing spaces' do
          valid_user.email = 'user@example.com  '
          expect(valid_user).not_to be_valid
        end
      end
    end

    context 'when password is invalid' do
      it 'without a password' do
        valid_user.password = nil
        expect(valid_user).not_to be_valid
      end

      it 'with a too short password' do
        valid_user.password = 'short'
        expect(valid_user).not_to be_valid
      end

      it 'when password consists of only spaces' do
        valid_user.password = '     '
        expect(valid_user).not_to be_valid
      end

      it 'with a password longer than 72 characters' do
        valid_user.password = 'a' * 73
        expect(valid_user).not_to be_valid
      end

      context 'when password has leading or trailing spaces' do
        it 'is invalid with password having leading spaces' do
          valid_user.password = '  password'
          expect(valid_user).not_to be_valid
        end
  
        it 'is invalid with password having trailing spaces' do
          valid_user.password = 'password  '
          expect(valid_user).not_to be_valid
        end
      end
    end
  end
end
