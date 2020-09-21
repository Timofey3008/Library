module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      attr_reader :user
      before_action :authenticate, only: [:index, :show]

      def index
        if @user.mail == 'tim1584569@mail.ru'
          @user = User.all
        else
          @message = "You don't have access"
          render 'access'
        end
      end

      def show
        if @user.mail == 'tim1584569@mail.ru'
          @user = User.find(params[:id])
        else
          @message = "You don't have access"
          render 'access'
        end
      end

      def login
        @user = User
                    .select('password, token')
                    .find_by('mail' => params.require(:user).require(:mail))
        if @user.present?
          if decrypt == params.require(:user).require(:password)
            @user
          else
            @message = 'Incorrect credentials'
            render 'fail'
          end
        else
          @message = 'Incorrect credentials'
          render 'fail'
        end
      end

      def create
        @user = User.new(user_params)

        if @user.save
          UserMailer.with(user: @user).welcome_email.deliver_now
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

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          @user = User.find_by(token: token)
        end
      end
    end
  end
end
