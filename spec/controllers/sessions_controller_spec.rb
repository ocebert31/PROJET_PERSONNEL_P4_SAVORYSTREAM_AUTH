require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:existing_user) do
    User.create!( email: "test@example.com", password: "password123", first_name: "John", last_name: "Doe", phone_number: "0600000000") end
  

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
      it "returns an error for invalid email and password" do
        post :create, params: { email: "wrong@example.com", password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Unable to login")
      end
    end
  end
end
