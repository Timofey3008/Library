module Api
  module V1
    class UsersController < ApplicationController

      def index
        @user = User.find_by(user_params)
        if @user == nil
          render json: 'Incorrect credentials', status: :not_found
        end
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:mail, :password)
      end
    end
  end
end
