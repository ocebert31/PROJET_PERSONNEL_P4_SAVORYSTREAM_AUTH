class UsersController < ApplicationController
    def create
        user = build_user
        user.save!
        render json: { token: user.encode_token(user_id: user.id) }, status: :created
    rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.to_a }, status: :unprocessable_entity
    end

    private

    def build_user
        User.new(create_user_params)
    end

    def create_user_params
        params.permit(:email, :password, :password_confirmation)
      end
      
end