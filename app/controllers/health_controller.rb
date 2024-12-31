# app/controllers/rails/health_controller.rb
module Rails
    class HealthController < ApplicationController
      def show
        render plain: "OK"
      end
    end
end  