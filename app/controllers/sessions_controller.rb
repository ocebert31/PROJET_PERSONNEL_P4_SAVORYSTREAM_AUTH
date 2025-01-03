class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            token = user.encode_token({ user_id: user.id })
            render json: { message: "You are successfully connected", token: token }, status: :ok
        else
            render json: { error: "Unable to login" }, status: :unauthorized
        end
    end
end