module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      attr_reader :user
      before_action :authenticate, only: [:index, :show]

      def index
        if @user.mail == 'tim148@mail.ru'
          @users = User.all
        else
          @message = "You aren't moderator"
          render 'api/v1/books/access', status: :forbidden
        end
      end

      def show
        if @user.mail == 'tim148@mail.ru'
          @user = User.find_by(id: params[:id])
          unless @user.present?
            @message = 'Incorrect user id'
            render 'api/v1/books/fail', status: :precondition_failed
          end
        else
          @message = "You aren't moderator"
          render 'api/v1/books/access', status: :forbidden
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
            render 'api/v1/books/fail', status: :precondition_failed
          end
        else
          @message = 'Incorrect credentials'
          render 'api/v1/books/fail', status: :precondition_failed
        end
      end

      def create
        @user = User.new(user_params)

        if @user.save
          UserMailer.with(user: @user).welcome_email.deliver_now
          render status: :created
        else
          @message = @user.errors
          render 'api/v1/books/fail', status: :precondition_failed
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
