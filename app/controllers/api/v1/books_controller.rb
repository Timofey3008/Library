module Api
  module V1
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :authenticate

      def index
        @books = Book.where("status = 0")
        if @books.present?
          @books
        else
          render json: 'No available books', status: :unprocessable_entity
        end
      end

      def create
        @book = @user.books.new(book_name)
        if @book.save
          UserMailer.with(book: @book, user: @user).book_registration.deliver_now
          render status: :created
        else
          render json: @book.errors, status: :unprocessable_entity
        end
      end

      def reserve
        if Book.find_by('reader_user_id' => @user.id)
          render json: 'You already have book. Only one book can be taken', status: :unprocessable_entity
        else
          @book = Book.find_by('id' => params[:id])
          if @book.present?
            if @book.in_library?
              @book.update(status: :reserved, reader_user_id: @user.id, dead_line: DateTime.now + 1.months)
              @book.save
              UserMailer.with(book: @book).book_reserved.deliver_now
            else
              render json: 'Someone has already taken this book', status: :unprocessable_entity
            end
          else
            render json: "Book doesn't exist", status: :unprocessable_entity
          end
        end
      end

      def return
        @book = Book.find_by(id: params[:id], reader_user_id: @user.id)
        if @book.present?
          UserMailer.with(book: @book).return.deliver_now
          @book.update(status: :in_library, reader_user_id: nil, dead_line: nil)
        else
          render json: "You don't have this book", status: :unprocessable_entity
        end
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