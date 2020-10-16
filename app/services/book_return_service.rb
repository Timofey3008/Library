class BookReturnService

  def initialize(book, user, book_id)
    @book_id = book_id
    @user = user
    @book = book
  end

  def call
    @book = @book.find_by(id: @book_id, reader_user_id: @user.id)
    return ServiceResult.new(status: false, message: "User didn't reserve this book") unless @book.present?
    UserMailer.with(book: @book).return.deliver_now
    @book.update(status: :in_library, reader_user_id: nil, dead_line: nil)
    ServiceResult.new(status: true, message: "Service Complete", data: @book)
  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end
