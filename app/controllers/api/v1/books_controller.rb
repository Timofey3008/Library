module Api
  module V1
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :authenticate

      def index
        @books = Book.all
        unless @books.present?
          @message = "Library doesn't have books"
          render 'api/v1/success', status: :ok
        end
      end

      def available_books
        @books = Book.where(status: :in_library)
        if @books.present?
          @books
        else
          @message = 'No available books'
          render 'api/v1/books/access', status: :ok
        end
      end

      def expired
        @books = Book.where("dead_line < ?", Time.now.to_date)
        if @books.present?
          @books
        else
          @message = "We don't have expired books"
          render 'api/v1/success', status: :ok
        end
      end

      def show
        @book = Book.find_by(id: params[:id])
        unless @book.present?
          @message = 'Incorrect book id'
          render 'fail', status: :bad_request
        end
      end

      def user_read
        @book = Book.find_by(reader_user_id: @user.id, status: :reserved)
        if @book.present?
          @book
        else
          @message = "You don't have reserved books"
          render 'api/v1/success', status: :ok
        end
      end

      def own_books
        @books = Book.where(owner_id: @user.id)
        if @books.present?
          @books
        else
          @message = "Library doesn't have your books"
          render 'api/v1/success', status: :ok
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
          @message = 'You already have book. Only one book can be taken'
          render 'fail', status: :bad_request
        else
          @book = Book.find_by('id' => params[:id])
          if @book.present?
            if @book.in_library?
              @book.update(status: :reserved, reader_user_id: @user.id, dead_line: DateTime.now + 1.months)
              @book.save
              UserMailer.with(book: @book).book_reserved.deliver_now
            else
              @message = 'Someone has already taken this book'
              render 'fail', status: :bad_request
            end
          else
            @message = "Book doesn't exist"
            render 'fail', status: :bad_request
          end
        end
      end

      def return
        @book = Book.find_by(id: params[:id], reader_user_id: @user.id)
        if @book.present?
          UserMailer.with(book: @book).return.deliver_now
          @book.update(status: :in_library, reader_user_id: nil, dead_line: nil)
        else
          @message = "You don't have this book"
          render 'fail', status: :bad_request
        end
      end

      def return_to_owner
        @book = Book.find_by(id: params[:id], owner_id: @user.id)
        if @book.present?
          if @book.reader_user_id.present?
            UserMailer.with(book: @book).return_to_owner.deliver_now
            @message = 'Request to the reader was sent'
            render 'api/v1/success', status: :ok
          else
            if @book.status == 'picked_up'
              @message = 'You already took your book'
              render 'fail', status: :bad_request
            else
              UserMailer.with(book: @book).returned.deliver_now
              @book.update(status: :picked_up)
            end
          end
        else
          @message = "It's not your book"
          render 'fail', status: :bad_request
        end
      end

      private

      def book_name
        params.require(:book).permit(:name)
      end
    end
  end
end