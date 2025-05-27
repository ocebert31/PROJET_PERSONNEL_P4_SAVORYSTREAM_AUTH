require 'rails_helper'

RSpec.describe User, type: :model do
  let(:email) { 'user@example.com' }
  let(:password) { 'password123' }
  let(:phone_number) { '0678652557' }
  let(:first_name) { 'Harry' }
  let(:last_name) { 'Potter' }
  let(:user) do User.new( email: email, password: password, phone_number: phone_number, first_name: first_name, last_name: last_name) end

  describe 'Validations' do
    context 'when all required attributes are valid' do
      it 'is valid' do
        expect(user).to be_valid
      end

      it 'is valid with an email containing a subdomain' do
        user.email = 'user@mail.example.com'
        expect(user).to be_valid
      end

      it 'is valid when email is blank but phone number is provided' do
        user.email = nil
        expect(user).to be_valid
      end

      it 'is valid when phone number is blank but email is provided' do
        user.phone_number = nil
        expect(user).to be_valid
      end
    end

    describe 'Email validations' do
      context 'when email is already taken' do
        it 'is invalid if email is already used by another user' do
          User.create!(email: email, password: password, phone_number: phone_number, first_name: first_name, last_name: last_name)
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include('has already been taken')
        end

        it 'is invalid even if email differs only by case' do
          User.create!(email: 'USER@example.com', password: password, phone_number: phone_number, first_name: first_name, last_name: last_name)
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include('has already been taken')
        end
      end

      context 'when email format is incorrect' do
        [
          { email: 'user @example.com', description: 'contains spaces' },
          { email: 'userexample.com', description: 'missing @ symbol' },
          { email: 'user@', description: 'missing domain' },
          { email: 'user@exa$mple.com', description: 'contains invalid characters' }
        ].each do |invalid_email|
          it "is invalid when email #{invalid_email[:description]}" do
            user.email = invalid_email[:email]
            expect(user).not_to be_valid
          end
        end
      end

      context 'when email has unnecessary spaces' do
        it 'is invalid with leading spaces' do
          user.email = '  user@example.com'
          expect(user).not_to be_valid
        end

        it 'is invalid with trailing spaces' do
          user.email = 'user@example.com  '
          expect(user).not_to be_valid
        end
      end
    end

    describe 'Password validations' do
      context 'when password does not meet criteria' do
        it 'is invalid if password is nil' do
          user.password = nil
          expect(user).not_to be_valid
        end

        it 'is invalid if password is too short' do
          user.password = 'short'
          expect(user).not_to be_valid
        end

        it 'is invalid if password contains only spaces' do
          user.password = '     '
          expect(user).not_to be_valid
        end

        it 'is invalid if password exceeds 72 characters' do
          user.password = 'a' * 73
          expect(user).not_to be_valid
        end

        it 'is invalid with leading spaces' do
          user.password = '  password'
          expect(user).not_to be_valid
        end

        it 'is invalid with trailing spaces' do
          user.password = 'password  '
          expect(user).not_to be_valid
        end
      end

      it 'stores a hashed password instead of plain text' do
        expect(user.password_digest).not_to eq(password)
      end
    end

    describe 'First name validations' do
      it 'is invalid when first name is missing' do
        user.first_name = nil
        expect(user).not_to be_valid
        expect(user.errors[:first_name]).to include("can't be blank")
      end

      it 'is invalid when first name exceeds 50 characters' do
        user.first_name = 'a' * 51
        expect(user).not_to be_valid
        expect(user.errors[:first_name]).to include("is too long (maximum is 50 characters)")
      end
    end

    describe 'Last name validations' do
      it 'is invalid when last name is missing' do
        user.last_name = nil
        expect(user).not_to be_valid
        expect(user.errors[:last_name]).to include("can't be blank")
      end

      it 'is invalid when last name exceeds 50 characters' do
        user.last_name = 'a' * 51
        expect(user).not_to be_valid
        expect(user.errors[:last_name]).to include("is too long (maximum is 50 characters)")
      end
    end

    describe 'Phone number validations' do
      it 'is invalid when phone number has less than 10 digits' do
        user.phone_number = '12345'
        expect(user).not_to be_valid
        expect(user.errors[:phone_number]).to include("must be a valid 10-digit number")
      end

      it 'is invalid when phone number is already used by another user' do
        User.create!(email: 'another@example.com', password: password, phone_number: phone_number, first_name: first_name, last_name: last_name)
        expect(user).not_to be_valid
        expect(user.errors[:phone_number]).to include("has already been taken")
      end
    end

    describe 'Role validations' do
      it 'is valid when role is set to customer' do
        user.role = 'customer'
        expect(user).to be_valid
      end
    
      it 'is valid when role is set to admin' do
        user.role = 'admin'
        expect(user).to be_valid
      end
    
      it 'is invalid when role is not in the accepted list' do
        user.role = 'manager'
        expect(user).not_to be_valid
        expect(user.errors[:role]).to include("is not included in the list")
      end
    
      it 'defaults to customer if role is not specified' do
        expect(user.role).to eq('customer')
      end
    end
  end
end
