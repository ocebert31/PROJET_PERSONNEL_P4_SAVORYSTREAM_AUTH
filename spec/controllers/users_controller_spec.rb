require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { { email: "user@example.com", password: "password123" } }
  let(:invalid_attributes) { { email: "user@example.com", password: "short" } }

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new user and returns a token" do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)  

        expect(response).to have_http_status(:created)
        token = JSON.parse(response.body)["token"]
        expect(token).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not create a new user and returns errors" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        errors = JSON.parse(response.body)["errors"]
      end
    end
  end
end