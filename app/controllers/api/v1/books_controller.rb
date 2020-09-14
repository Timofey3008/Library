module Api
  module V1
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :authenticate

      def index
        @books = Book.where("status = '0'")
      end

      def create
        @book = @user.books.new(book_name)
        if @book.save
          UserMailer.with(book: @book, user: @user).book_registration.deliver_now
          render status: :created
        else
          render json: @book. errors, status: :unprocessable_entity
        end
      end

      def show
        @book = Book.find(params[:id])
        @book.reader = @user.id
        @book.status = 1
        @book.deadLine = DateTime.now + 1.months
        @book.save
      end

      private

      def book_name
        params.require(:book).permit(:name)
      end

      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          @user = User.find_by(token: token)
        end
      end
    end
  end
end