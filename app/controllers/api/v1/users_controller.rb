module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      attr_reader :user
      before_action :authenticate, only: [:index, :show]

      def index
        if @user.mail == ENV['moderator_mail']
          @user = User.all
        else
          @message = "You don't have access"
          render 'access', status: :forbidden
        end
      end

      def show
        if @user.mail == ENV['moderator_mail']
          @user = User.find(params[:id])
        else
          @message = "You don't have access"
          render 'access', status: :forbidden
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
