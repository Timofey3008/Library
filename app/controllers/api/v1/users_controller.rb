module Api
  module V1
    class UsersController < ApplicationController
      attr_reader :user

      def index
        @users = User.all
      end

      def show
        @user = User.find(params[:id])
      end

      def login
        @user = User
                    .select('password, token')
                    .find_by('mail' => params.require(:user).require(:mail))
        if @user != nil
          if decrypt == params.require(:user).require(:password)
            @user
          end
        else
          render json: 'Incorrect credentials', status: :unprocessable_entity
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

      def decrypt
        BCrypt::Password.new(@user.password)
      end
    end
  end
end