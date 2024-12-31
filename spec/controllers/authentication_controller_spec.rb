require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST #register' do
    let(:valid_params) { { email: 'user@example.com', password: 'password123', confirmPassword: 'password123' } }
    let(:invalid_params) { { email: 'user@example.com', password: 'password123', confirmPassword: 'password456' } }
    let(:existing_user) { create(:user, email: 'user@example.com', password: 'password123') }

    context 'when email is already taken' do
      before do
        existing_user
        post :register, params: invalid_params
      end

      it 'returns an error message' do
        expect(response.status).to eq(422)
        expect(response.body).to include("L'email a déjà été pris")
      end
    end

    context 'when passwords do not match' do
      before do
        post :register, params: invalid_params
      end

      it 'returns an error message' do
        expect(response.status).to eq(422)
        expect(response.body).to include("Les mots de passe ne correspondent pas")
      end
    end

    context 'when registration is successful' do
      before do
        post :register, params: valid_params
      end

      it 'returns a created status' do
        expect(response.status).to eq(201)
      end

      it 'returns a token in the response' do
        expect(response.body).to include("token")
      end
    end

    context 'when email is invalid' do
      let(:invalid_email_params) { { email: 'invalidemail', password: 'password123', confirmPassword: 'password123' } }
    
      before do
        post :register, params: invalid_email_params
      end
    
      it 'returns an error message' do
        expect(response.status).to eq(422)
        expect(response.body).to include("Le format de l'email n'est pas valide")
      end
    end
    
    context 'when password is empty' do
      let(:empty_password_params) { { email: 'newuser@example.com', password: '', confirmPassword: '' } }
    
      before do
        post :register, params: empty_password_params
      end
    
      it 'returns an error message' do
        expect(response.status).to eq(422)
        expect(response.body).to include("Le mot de passe ne peut pas être vide")
      end
    end    
  end
end
