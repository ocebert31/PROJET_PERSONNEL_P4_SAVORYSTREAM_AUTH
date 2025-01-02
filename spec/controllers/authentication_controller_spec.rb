require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let(:valid_attributes) { { email: "user@example.com", password: "password123", confirmPassword: "password123" } }
  let(:invalid_attributes) { { email: "user@example.com", password: "short" } }
  let(:existing_user) { User.create!(email: "existing@example.com", password: "password123") }

  describe "POST #register" do
    context "with valid parameters" do
      it "creates a new user and returns a token" do
        expect {
          post :register, params: valid_attributes
        }.to change(User, :count).by(1)  

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["token"]).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post :register, params: invalid_attributes
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Password must be at least 6 characters long")
      end
    end

    context 'when creating a new user' do
      it 'hashes the password before saving' do
        post :register, params: valid_attributes
        user = User.find_by(email: valid_attributes[:email])
        expect(user.password_digest).not_to eq('password123')
      end
    end
  end

  describe "POST #login" do
    context "with valid credentials" do
      it "logs the user in and returns a token" do
        post :login, params: { email: existing_user.email, password: "password123" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("You are successfully connected")
        expect(JSON.parse(response.body)["token"]).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns an error for invalid email" do
        post :login, params: { email: "wrong@example.com", password: "password123" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password")
      end

      it "returns an error for invalid password" do
        post :login, params: { email: existing_user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password")
      end
    end
  end
end
