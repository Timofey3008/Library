module Api
  module V1
    class UsersController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      attr_reader :user
      before_action :authenticate, only: [:index, :show]

      def index
        if @user.mail == 'tim148@mail.ru'
          service_result = PaginateService.build(User, limit: params[:limit], page: params[:page]).call
          if service_result.success?
            render_success(data: service_result.data.map{ |elem| elem.user_attributes})
          else
            render_error(data: service_result.message)
          end
        else
          render_forbidden(data: "User is not moderator")
        end
      end

      def show
        render_forbidden(data: "User is not moderator")if @user.mail != 'tim148@mail.ru'
        render_success(data: User.find_by(id: params[:id]).user_attributes) if @user.mail == 'tim148@mail.ru'
      end

      def login

        service_result = LoginService.new(User, params).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def create
        service_result = UserCreateService.new(User, user_params).call
        if service_result.success?
          render_created(data: service_result.data.attributes.except('password', 'created_at', 'updated_at'))
        else
          render_error(data: service_result.message)
        end
      end

      private

      def user_params
        params.require(:user).permit(:mail, :password)
      end
    end
  end
end
