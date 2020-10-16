class BookCreateService

  def initialize(user, book_name)
    @user = user
    @book_name = book_name
  end

  def call

    @book = @user.books.new(@book_name)
    if @book.save
      UserMailer.with(book: @book, user: @user).book_registration.deliver_now
      ServiceResult.new(status: true, message: "Service Complete", data: @book)
    else
      ServiceResult.new(status: false, message: @book.errors)
    end
  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end
