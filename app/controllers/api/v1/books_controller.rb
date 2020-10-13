module Api
  module V1
    class BooksController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :authenticate

      def index

        service_result = PaginateService.build(Book, limit: params[:limit], page: params[:page]).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def available_books

        service_result = PaginateService.build(Book.in_library, limit: params[:limit], page: params[:page]).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def expired

        service_result = PaginateService.build(Book.where("dead_line < ?", Time.now.to_date), limit: params[:limit], page: params[:page]).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def show
        render_success(data: Book.find_by(id: params[:id]))
      end

      def user_read
        render_success(data: Book.find_by(reader_user_id: @user.id, status: :reserved))
      end

      def own_books
        render_success(data: Book.where(owner_id: @user.id))
      end

      def create

        service_result = BookCreateService.new(@user, book_name).call
        if service_result.success?
          render_created(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def reserve

        service_result = BookReserveService.new(Book, @user, params[:id]).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def return
        service_result = BookReturnService.new(Book, @user, params[:id]).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      def return_to_owner

        service_result = ReturnToOwnerService.new(Book, @user, params[:id]).call
        if service_result.success?
          render_success(data: service_result.data)
        else
          render_error(data: service_result.message)
        end
      end

      private

      def book_name
        params.require(:book).permit(:name)
      end
    end
  end
end