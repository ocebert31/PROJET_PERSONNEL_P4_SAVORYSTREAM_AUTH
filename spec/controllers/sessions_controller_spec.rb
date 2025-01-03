require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:existing_user) { User.create!(email: "existing@example.com", password: "password123") }

  describe "POST #create" do
    context "with valid credentials" do
      it "logs the user in and returns a token" do
        post :create, params: { email: existing_user.email, password: "password123" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("You are successfully connected")
        expect(JSON.parse(response.body)["token"]).to be_present
      end
    end

    context "with invalid credentials" do
      it "returns an error for invalid email" do
        post :create, params: { email: "wrong@example.com", password: "password123" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Unable to login")
      end

      it "returns an error for invalid password" do
        post :create, params: { email: existing_user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Unable to login")
      end
    end
  end
end
